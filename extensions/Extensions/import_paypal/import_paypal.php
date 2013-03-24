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

function log_message($msg) {
    global $path_to_root;
    $fp = fopen($path_to_root."/tmp/paypal.log", "a+");
    fwrite($fp, "[".date("d-M-Y H:i:s")."] ".$msg."\r\n");
    fclose($fp);
}

page(_("Import of Paypal transactions"));
$user_id = $_SESSION["wa_current_user"]->username;
$saveFilename = '';

if (isset($_POST['import_paypal'])) {
  if (isset($_FILES['imp']) && $_FILES['imp']['name'] != '') {
      log_message("file:".$_FILES['imp']['name']);

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
        $amount = str_replace(",","",$data["Gross"]);
        $account = '';
        $fromEmail = $data["From Email Address"];
        $memo = $data["Item Title"];
        $ref = $data["Transaction ID"];
  		$type = strtoupper($data["Type"]);

  		switch (strtoupper($type)) {
  		  case "WEB ACCEPT PAYMENT RECEIVED":
              // to be processed in second pass
              break;
  		  case "PAYPAL EXPRESS CHECKOUT PAYMENT SENT":
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
