<?php
// ----------------------------------------------------------------
// $ Revision:  1.0 $
// Creator: Alastair Robertson
// date_:   2011-10-22
// Title:   Paypal transaction import
// Free software under GNU GPL
// ----------------------------------------------------------------
$page_security = 'SA_PAYPALIMPORT';
$path_to_root="../..";

include($path_to_root . "/includes/session.inc");
add_access_extensions();

include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/modules/import_paypal/includes/import_paypal_db.inc");
include_once($path_to_root . "/includes/db/crm_contacts_db.inc");
include_once($path_to_root . "/sales/includes/db/customers_db.inc");

function log_message($msg) {
    global $path_to_root;
    $fp = fopen($path_to_root."/tmp/paypal.log", "a+");
    fwrite($fp, "[".date("d-M-Y H:i:s")."] ".$msg."\r\n");
    fclose($fp);
}

function write_customer($email, $name, $company, $address, $phone, $fax, $currency) {

    global $paypal_sales_type_id, $paypal_tax_group_id, $paypal_salesman, $paypal_area,
        $paypal_location, $paypal_credit_status, $paypal_shipper;
    global $SysPrefs;

    log_message("Memory, write_customer start:".memory_get_usage());
    $customer_id = find_customer_by_email($email);
    if (empty($customer_id)) {
    	$customer_id = find_customer_by_name($company);
    }
    if (empty($customer_id)) {
        //it is a new customer
        begin_transaction();
        add_customer($company, substr($company,0,30), $address,
            '', $currency, 0, 0,
            $paypal_credit_status, -1,
            0, 0,
            $SysPrefs->default_credit_limit(),
            $paypal_sales_type_id, 'PayPal');

        $customer_id = db_insert_id();

        add_branch($customer_id, $company, substr($company,0,30),
            $address, $paypal_salesman, $paypal_area, $paypal_tax_group_id, '',
            get_company_pref('default_sales_discount_act'), get_company_pref('debtors_act'),
            get_company_pref('default_prompt_payment_act'),
            $paypal_location, $address, 0, 0,
            $paypal_shipper, 'PayPal');

        $selected_branch = db_insert_id();

        $nameparts = explode(" ", $name);
        $firstname = "";
        for ($i=0; $i<(count($nameparts) - 1); $i++) {
            if (!empty($firstname)) {
                $firstname .= " ";
            }
            $firstname .= $nameparts[$i];
        }
        $lastname = $nameparts[count($nameparts)-1];
        add_crm_person('paypal', $firstname, $lastname, $address,
            $phone, '', $fax, $email, '', '');

        add_crm_contact('customer', 'general', $selected_branch, db_insert_id());

        commit_transaction();
    }
    else {
    	$selected_branch = 0;
    }
    log_message("Memory, write_customer end:".memory_get_usage());
    return array($customer_id, $selected_branch);
}

page(_("Import of Paypal transactions"));
$user_id = $_SESSION["wa_current_user"]->username;
$saveFilename = '';

if (isset($_POST['import_paypal'])) {
  if (isset($_FILES['imp']) && $_FILES['imp']['name'] != '') {
      log_message("file:".$_FILES['imp']['name']);

      $prefs = get_company_prefs();
      $paypal_create_invoices = $prefs['paypal_create_invoices'];
      $paypal_sales_type_id  = $prefs["paypal_sales_type_id"];
      $paypal_tax_group_id = $prefs['paypal_tax_group_id'];
      $paypal_salesman = $prefs['paypal_salesman'];
      $paypal_area = $prefs['paypal_area'];
      $paypal_location = $prefs['paypal_location'];
      $paypal_shipper = $prefs['paypal_shipper'];
      $paypal_credit_status = $prefs['paypal_credit_status'];
      $paypal_name_col = $prefs['paypal_name_col'];
      unset($prefs);

      $headings = array();
      $data = array();

      $filename = $_FILES['imp']['tmp_name'];
      $sep = ',';
      $saveFilename = $path_to_root."/tmp/".$user_id."paypal.csv";
      move_uploaded_file($filename, $saveFilename);

      $fp = @fopen($saveFilename, "r");
      if (!$fp)
      	die(_("can not open file")." ".$saveFilename);

      $fileline = fgetcsv($fp, 4096, $sep);
      foreach( $fileline as $field ) { $headings[] = trim($field); }

      begin_transaction();
      clear_paypal_items($user_id);

  	$lines = $new_custs = $updated_custs = $invoices = $receipts = $payments = $transfers = 0;
  	// type, item_code, stock_id, description, category, units, qty, mb_flag, currency, price
  	while ($fileline = fgetcsv($fp, 4096, $sep)) {
  		//if ($lines++ == 0) continue;
        foreach( $headings as $k => $v ) {
            // Store data against field headings
            $data[$v] = $fileline[$k];
        }
  		$date = $data["Date"];
  		$time = $data["Time"];
        $person = $data["Name"];
        $currency = $data["Currency"];
        $amount = str_replace(",","",$data["Gross"]);
        $account = '';
        $fromEmail = $data["From Email Address"];
        $memo = $data["Item Title"];
        $ref = $data["Transaction ID"];
  		$type = strtoupper($data["Type"]);
        $name = $data["Name"];
        if (!empty($paypal_name_col)) {
          $company = $data[$paypal_name_col];
        } else {
          $company = $data["Name"];
        }
  		$address1 = $data["Address Line 1"];
        $address2 = $data["Address Line 2/District/Neighbourhood"];
		if (array_key_exists("Suburb", $data))
	        $address3 = $data["Suburb"];
		else
	        $address3 = $data["Town/City"];
        $address4 = $data["State/Province/Region/County/Territory/Prefecture/Republic"];
		if (array_key_exists("Postcode", $data))
        	$postcode = $data["Postcode"];
		else
        	$postcode = $data["Zip/Postcode"];
        if (empty($postcode))
            $postcode = $data["Postcode"];
        $country = $data["Country"];
        $phone = "";
        $fax = "";
        $address = "";
        if (!empty($address1)) {
          $address .= $address1;
          if (!empty($address2) || !empty($address3) || !empty($address4) || !empty($postcode) ||!empty($country))
              $address .= chr(13) . chr(10);
        }
        if (!empty($address2)) {
          $address .= $address2;
          if (!empty($address3) || !empty($address4) || !empty($postcode) ||!empty($country))
              $address .= chr(13) . chr(10);
        }
        if (!empty($address3)) {
          $address .= $address3;
          if (!empty($address4) || !empty($postcode) ||!empty($country))
              $address .= chr(13) . chr(10);
        }
        if (!empty($address4)) {
          $address .= $address4;
        }
        if (!empty($postcode)) {
          $address .= " " . $postcode;
        }
        if (!empty($country)) {
            if (!empty($address4)) {
              $address .= chr(13) . chr(10);
            }
            $address .= $country;
        }
        if (strlen($address) > 255) {
          $address = substr($address,1,255);
        }

  		switch (strtoupper($type)) {
          case "WEB ACCEPT PAYMENT RECEIVED":
          case "UPDATE TO ECHEQUE RECEIVED":
            // create customer now to save memory in second pass
            if ($paypal_create_invoices) {
              write_customer($fromEmail, $name, $company, $address, $phone, $fax, $currency);
            }
            break;
          case "PAYPAL EXPRESS CHECKOUT PAYMENT SENT":
          case "EXPRESS CHECKOUT PAYMENT SENT":
          case "WEB ACCEPT PAYMENT SENT":
            insert_paypal_item($user_id, $date, $ref, $person, $memo, -$amount, $account);
            break;
  		  case "WITHDRAW FUNDS TO A BANK ACCOUNT":
              // to be processed in second pass
  		    break;
  		}

  	}
    commit_transaction();
  	@fclose($fp);
    update_paypal_item_default_account();

    header("Location:".$path_to_root."/modules/import_paypal/import_paypal_update.php?filename=".$saveFilename );

  } else display_error(_("No CSV file selected"));
}

start_form(true);

start_table(TABLESTYLE2);

label_row(_("CSV Import File:"), "<input type='file' id='imp' name='imp'>");
hidden("filename",$saveFilename);

end_table(1);

submit_center('import_paypal', _("Import Paypal Transactions"));

end_form();
end_page();
?>
