<?php
// ----------------------------------------------------------------
// $ Revision:  1.0 $
// Creator: Alastair Robertson
// date_:   2011-10-22
// Title:   Paypal assign account to payment transaction and update
// Free software under GNU GPL
// ----------------------------------------------------------------
$page_security = 'SA_PAYPALIMPORT';
$path_to_root="../..";

include($path_to_root . "/includes/db_pager.inc");
include($path_to_root . "/includes/session.inc");
add_access_extensions();

include_once($path_to_root . "/includes/data_checks.inc");
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/includes/ui/items_cart.inc");
include_once($path_to_root . "/includes/db/crm_contacts_db.inc");
include_once($path_to_root . "/modules/import_paypal/includes/import_paypal_db.inc");
include_once($path_to_root . "/sales/includes/cart_class.inc");
include_once($path_to_root . "/sales/includes/db/customers_db.inc");
include_once($path_to_root . "/sales/includes/ui/sales_order_ui.inc");
include_once($path_to_root . "/includes/ui/allocation_cart.inc");
include_once($path_to_root . "/taxes/tax_calc.inc");

$user_id = $_SESSION["wa_current_user"]->username;

function log_message($msg) {
    global $path_to_root;
    $fp = fopen($path_to_root."/tmp/paypal.log", "a+");
    fwrite($fp, "[".date("d-M-Y H:i:s")."] ".$msg."\r\n");
    fclose($fp);
}
function get_tax_line($gross)
{
    global $paypal_tax_included, $paypal_tax_type_id, $paypal_tax_group_id, $paypal_item_tax_id;

    $taxLine = array('account' => '', 'tax' => 0);
    $tax_group_array = null;
    $tax_rate = 0;
    $tax_group_array = get_tax_group_items_as_array($paypal_tax_group_id);
    $item_tax = get_tax_type($paypal_tax_type_id);
    $tax_rate = $item_tax['rate'];
    $index = $item_tax[$paypal_item_tax_id];
    if (isset($tax_group_array[$index]['rate'])) {
        $tax_rate += $tax_group_array[$index]['rate'];
    }
    $taxLine['account'] = $item_tax["sales_gl_code"];
    if($paypal_tax_included)
        $taxLine['tax'] = round($gross*$tax_rate/($tax_rate+100),  user_price_dec());
    else
        $taxLine['tax'] = round($gross*$tax_rate/100,  user_price_dec());
    return $taxLine;
}
function write_payment($ref, $gross, $date, $memo, $name, $paypal_bank_id) {
    log_message("Payment, ref:".$ref.", amount:".$gross);
    $payment = get_paypal_item_by_ref($ref);
    $trans_no = get_next_trans_no(ST_BANKPAYMENT);
    $entry = new items_cart(ST_BANKPAYMENT);
    $entry->order_id = 0;
    $entry->tran_date = $date;
    $entry->reference = $ref;
    $entry->memo_ = $memo;
    $entry->add_gl_item($payment["account"], '', '', -$gross, $memo);
    write_bank_transaction(ST_BANKPAYMENT, 0, $paypal_bank_id, $entry, $entry->tran_date,
                      PT_MISC, $name, false, $entry->reference, $entry->memo_, false);
    $entry->clear_items();
    unset($entry);
}
function write_customer_invoices($date, $ref, $email, $name, $company, $address, $phone, $fax, $currency, $item_code, $item_title, $shipping, $insurance, $tax, $gross, $fee, $net) {
    global $paypal_shipping_act, $paypal_insurance_act, $paypal_sales_tax_act,
            $paypal_sales_act, $paypal_add_tax, $paypal_recpt_today, $paypal_bank_id,
            $paypal_sales_type_id, $paypal_tax_group_id, $paypal_location, $paypal_shipper;

    $result = write_customer($email, $name, $company, $address, $phone, $fax, $currency);
    $customer_id = $result[0];
    $branch_id = $result[1];

    $invoice = new Cart(ST_SALESINVOICE, 0, true);
    $invoice->document_date = $date;
    $invoice->order_no = $ref;
    get_customer_details_to_order($invoice, $customer_id, $branch_id);
    add_to_order($invoice, $item_code, 1, $gross, 0, $item_title);
    $invoice->cust_ref = $ref;
    $taxes = $invoice->get_taxes($shipping);
    $invoice_no = $invoice->write(0);

    log_message("Deposit, ref:".$ref.", net:".$net);
    if ($paypal_recpt_today) {
        $recpt_date = Today();
    } else {
        $recpt_date = $date;
    }
    $alloc = new allocation(ST_CUSTPAYMENT,0);
    $payment_no = write_customer_payment(0, $customer_id, $branch_id,
        $paypal_bank_id, $recpt_date, $ref,
        $gross, 0, $company, 1, 0 - $fee);

    $alloc->trans_no = $payment_no;
    $alloc->add_item(ST_SALESINVOICE, $invoice_no, $recpt_date, $date, $gross,
                        $gross, $gross, $ref);
    $alloc->write();
    $alloc->allocs = array();
    unset($alloc->allocs);
    unset($alloc);

    $invoice->clear_items();
    unset($invoice->line_items);
    unset($invoice);
}
function write_customer($email, $name, $company, $address, $phone, $fax, $currency) {

    global $paypal_sales_type_id, $paypal_tax_group_id, $paypal_salesman, $paypal_area,
        $paypal_location, $paypal_credit_status, $paypal_shipper;
    global $SysPrefs;

    $customer_id = find_customer_by_ref(substr($company,0,30));
    if (!empty($customer_id)) {
        $selected_branch = find_customer_branch_by_customer_id($customer_id);
    } else {
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
    return array($customer_id, $selected_branch);
}
function write_bank_receipt($date, $ref, $name, $shipping, $insurance, $tax, $gross, $fee, $net) {
    global $paypal_shipping_act, $paypal_insurance_act, $paypal_sales_tax_act,
            $paypal_sales_act, $paypal_add_tax, $paypal_bank_id;

    $trans_no = get_next_trans_no(ST_BANKDEPOSIT);
    $entry = new items_cart(ST_BANKDEPOSIT);
    $entry->order_id = 0;
    if ($paypal_recpt_today) {
        $entry->tran_date = Today();
    } else {
        $entry->tran_date = $date;
    }
    $entry->reference = $ref;
    $entry->memo_ = $name;
    if ($shipping != 0) {
      $entry->add_gl_trans($paypal_shipping_act, '', '', -$shipping, $ref);
    }
    if ($insurance != 0) {
      $entry->add_gl_trans($paypal_insurance_act, '', '', -$insurance, $ref);
    }
    if ($tax != 0) {
      $entry->add_gl_trans($paypal_sales_tax_act, '', '', -$tax, $ref);
      $taxNet = $gross;
    }
    elseif ($paypal_add_tax) {
      $taxLine = get_tax_line($gross);
      $entry->add_gl_item($taxLine['account'], '', '', -$taxLine['tax'], '');
      $taxNet = $gross - $taxLine['tax'];
      unset($taxLine);
    }
    $entry->add_gl_item(get_company_pref('bank_charge_act'), '', '', -$fee, $ref);
    $entry->add_gl_item($paypal_sales_act, '', '', -$taxNet, $ref);

    log_message("Deposit, ref:".$ref.", net:".$net);
    write_bank_transaction(ST_BANKDEPOSIT, 0, $paypal_bank_id, $entry, $entry->tran_date,
                      PT_MISC, $name, false, $entry->reference, $entry->memo_, false);
    $entry->clear_items();
    unset($entry);

}
function select_account($row) {
    // skip bank accs=true, all=false, submit on change=true
    return gl_all_accounts_list($row["ref"], $row["account"], true, false, false, true);
}
function process_combo_postback() {
    if (!isset($_SESSION["trans_tbl"]))
        return false;
    $table = $_SESSION["trans_tbl"]->data;
    foreach( $table as $row ) {
      $ref = $row["ref"];
      $flag = "_".$ref."_update";
      if (isset($_POST[$flag])) {
        update_paypal_item_account($ref,$_POST[$ref]);
        return true;
      }
    }
}

if (isset($_POST['ok'])) {
    header("Location:".$path_to_root."/index.php" );
}

$postBack = process_combo_postback();

$myRow = get_paypal_unconfirmed_count($user_id);
$totalPayments = $myRow[0];
$unconfirmedPayments = $myRow[1];

if (isset($_GET["filename"]))
    $filename = $_GET["filename"];
else
    $filename = get_post("filename",'');

page(_("Select payments' account"));

if (isset($_POST['import_paypal']) && $unconfirmedPayments != 0) {
  display_error(_("You must select an account for every payment"));
} else {
  if ((isset($_POST['import_paypal']) && $unconfirmedPayments == 0 && !$postBack) || $totalPayments == 0) {
      if (isset($filename)) {
        save_paypal_item_account();

        log_message("Second pass file: ".$filename);

        $prefs = get_company_prefs();
        $paypal_bank_id  = $prefs["paypal_bank_id"];
        $paypal_create_invoices = $prefs['paypal_create_invoices'];
        $paypal_sales_act  = $prefs["paypal_sales_act"];
        $paypal_sales_tax_act  = $prefs["paypal_sales_tax_act"];
        $paypal_shipping_act  = $prefs["paypal_shipping_act"];
        $paypal_insurance_act  = $prefs["paypal_insurance_act"];
        $paypal_withdraw_id  = $prefs["paypal_withdraw_id"];
        $paypal_sales_type_id  = $prefs["paypal_sales_type_id"];
        $use_paypal_trn_id = $prefs['use_paypal_trn_id'];
        $paypal_add_tax = $prefs['paypal_add_tax'];
        $paypal_recpt_today = $prefs['paypal_recpt_today'];
        $paypal_tax_group_id = $prefs['paypal_tax_group_id'];
        $paypal_item_tax_id = $prefs['paypal_item_tax_id'];
        $paypal_tax_type_id = $prefs['paypal_tax_type_id'];
        $paypal_tax_included = $prefs['paypal_tax_included'];
        $paypal_name_col = $prefs['paypal_name_col'];
        $paypal_salesman = $prefs['paypal_salesman'];
        $paypal_area = $prefs['paypal_area'];
        $paypal_location = $prefs['paypal_location'];
        $paypal_shipper = $prefs['paypal_shipper'];
        $paypal_credit_status = $prefs['paypal_credit_status'];
        unset($prefs);
        $headings = array();
        $data = array();

        log_message("Paypal act:".$paypal_bank_id.", withrawal:".$paypal_withdraw_id.", sales:".$paypal_sales_act.", tax:".$paypal_sales_tax_act);

      	$sep = ',';

      	$fp = @fopen($filename, "r");
      	if (!$fp)
            die(_("can not open file")." ".$filename);

      	$fileline = fgetcsv($fp, 4096, $sep);
        log_message("Fileline:".implode(',',$fileline));
      	foreach( $fileline as $field ) { $headings[] = trim($field); }

        begin_transaction();

      	$lines = $new_custs = $updated_custs = $invoices = $receipts = $payments = $transfers = 0;
      	// type, item_code, stock_id, description, category, units, qty, mb_flag, currency, price
      	while ($fileline = fgetcsv($fp, 4096, $sep)) {
          log_message("Fileline:".implode(',',$fileline));
          foreach( $headings as $k => $v ) {
            // Store data against field headings
            $data[$v] = $fileline[$k];
          }
          $lines++;
          $date = $data["Date"];
          $time = $data["Time"];
          $name = $data["Name"];
          if (!empty($paypal_name_col)) {
            $company = $data[$paypal_name_col];
          } else {
            $company = $data["Name"];
          }
          $fromEmail = $data["From Email Address"];
          $address1 = $data["Address Line 1"];
          $address2 = $data["Address Line 2/District/Neighbourhood"];
          $address3 = $data["Town/City"];
          $address4 = $data["State/Province/Region/County/Territory/Prefecture/Republic"];
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

          $memo = $data["Item Title"];
          $item_code = $data["Item ID"];
          $item_title = $data["Item Title"];
          $currency = $data["Currency"];
          $gross = str_replace(",","",$data["Gross"]);
          $fee = str_replace(",","",$data["Fee"]);
          $net = str_replace(",","",$data["Net"]);
          $insurance = str_replace(",","",$data["Insurance Amount"]);

          // shipping and tax have different headings in different paypal countries
          if (array_key_exists("Shipping and Handling Amount", $data))
              $shipping = str_replace(",","",$data["Shipping and Handling Amount"]);
          elseif (array_key_exists("Postage and Packing Amount", $data))
              $shipping = str_replace(",","",$data["Postage and Packing Amount"]);
          elseif (array_key_exists("Postage and Packing", $data))
              $shipping = str_replace(",","",$data["Postage and Packing"]);

          if (array_key_exists("GST", $data))
              $tax = str_replace(",","",$data["GST"]);
          elseif (array_key_exists("VAT", $data))
              $tax = str_replace(",","",$data["VAT"]);
          elseif (array_key_exists("Sales Tax", $data))
              $tax = str_replace(",","",$data["Sales Tax"]);

          if ($use_paypal_trn_id) {
      		$ref = $data["Transaction ID"];
          }
          $type = strtoupper($data["Type"]);
          log_message($type.", gross:".$gross.", fee:".$fee.", net:".$net.", shipping:".$shipping.", tax: ".$tax);
          switch (strtoupper($type)) {
            case "WEB ACCEPT PAYMENT RECEIVED":
              if ($paypal_create_invoices) {
                // check for existing customer and create if not found
                write_customer_invoices($date, $ref, $fromEmail, $name, $company, $address, $phone, $fax, $currency, $item_code, $item_title, $shipping, $insurance, $tax, $gross, $fee, $net);
                // create invoice, bank receipt, allocate payment to invoice
                $invoices += 1;
              } else {
                // create bank transfer crediting sales account directly
                if (!$use_paypal_trn_id) {
                  $ref = $data["Transaction ID"];
                }
                write_bank_receipt($date, $ref, $name, $shipping, $insurance, $tax, $gross, $fee, $net);
                $receipts += 1;
              }
              break;
            case "PAYPAL EXPRESS CHECKOUT PAYMENT SENT":
                write_payment($ref, $gross, $date, $memo, $name, $paypal_bank_id);
                $payments += 1;
              break;
            case "WITHDRAW FUNDS TO A BANK ACCOUNT":
              log_message("Withdrawal, ref:".$ref.", from:".$paypal_bank_id.", to:".$paypal_withdraw_id.", amount:".-$gross);
              add_bank_transfer($paypal_bank_id, $paypal_withdraw_id, $date,
                      -$gross, $ref, _("Paypal transfer"));
              $transfers += 1;
              break;
          }
      	}
        commit_transaction();
      	@fclose($fp);
        unset($data);
        unset($headings);

      	if ($new_custs + $updated_custs > 0)
      	     display_notification($new_custs." "._("customers created,")." ".$updated_custs." "._("customers updated"));
      	if ($invoices > 0) display_notification($invoices." "._("invoices added."));
        if ($receipts > 0) display_notification($receipts." "._("receipts added."));
        if ($payments > 0) display_notification($payments." "._("payments added."));
        if ($transfers > 0) display_notification($transfers." "._("withdrawals added."));
      }
    }
};

start_form(true);

if ($lines > 0) {
  submit_center('ok', _("OK"));
} else {
  $sql = get_paypal_items($user_id);

  $cols =
  array(
      _("PayPal Reference") => 'ref',
      _("Date") => 'date',
      _("Person") => 'person',
      _("Memo") => 'mem',
      _("Amount") => 'amount',
      _("Account") => array('fun'=>'select_account')
     );
  $table =& new_db_pager('trans_tbl', $sql, $cols);

  $table->width = "80%";
  display_db_pager($table);

  br(1);
  hidden("filename",$filename);

  submit_center('import_paypal', "Import Paypal Transactions");
}

end_form();
end_page();
?>
