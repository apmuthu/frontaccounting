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
log_message("Phase 2 start:".memory_get_usage());

include($path_to_root . "/includes/db_pager.inc");
include($path_to_root . "/includes/session.inc");
add_access_extensions();

//include_once($path_to_root . "/includes/data_checks.inc");
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/includes/ui/items_cart.inc");
include_once($path_to_root . "/modules/import_paypal/includes/import_paypal_db.inc");
include_once($path_to_root . "/sales/includes/cart_class.inc");
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
function write_customer_invoices($date, $status, $name, $ref, $email, $currency, $item_code, $item_title, $shipping, $insurance, $tax, $gross, $fee, $net) {
    global $paypal_shipping_act, $paypal_insurance_act, $paypal_sales_tax_act, $paypal_fee_act,
            $paypal_sales_act, $paypal_add_tax, $paypal_recpt_today, $paypal_bank_id;

    log_message("Memory, write_customer_invoices start:".memory_get_usage());
    $customer_id = find_customer_by_email($email);
    if (!isset($customer_id)) {
    	$customer_id = find_customer_by_name($name);
    }
    if (!isset($customer_id)) {
    	log_message("unable to find customer, customer:".$email.", net:".$net);
    	return;
    }
    $branch_id = find_customer_branch_by_customer_id($customer_id);

    if ($item_code == '') {
      // eCheque not cleared, get unpaid invoice
      $trans_items = get_allocatable_to_cust_transactions($customer_id);
      if ($myrow = db_fetch($trans_items)) {
          $invoice_no = $myrow["trans_no"];
          $company = $myrow["DebtorName"];
      } else {
          log_message("eCheque missing invoice, customer:".$customer_id.", net:".$net);
      }
    } else {
      $invoice = new Cart(ST_SALESINVOICE, 0, true);
      $invoice->document_date = $date;
      $invoice->order_no = $ref;
      get_customer_details_to_order($invoice, $customer_id, $branch_id);
      add_to_order($invoice, $item_code, 1, $gross, 0, $item_title);
      $invoice->cust_ref = $ref;
      $taxes = $invoice->get_taxes($shipping);
      $invoice_no = $invoice->write(0);
      $invoice->clear_items();
      unset($invoice->line_items);
      unset($invoice);
      $company = '';
    }

    log_message("Deposit, ref:".$ref.", net:".$net);
    if ($paypal_recpt_today) {
        $recpt_date = Today();
    } else {
        $recpt_date = $date;
    }
    if (strtoupper($status) == 'COMPLETED') {
      $alloc = new allocation(ST_CUSTPAYMENT,0);
      $payment_no = write_customer_payment(0, $customer_id, $branch_id,
          $paypal_bank_id, $recpt_date, $ref,
          $gross, 0, $company, 1, 0 - $fee, $gross, $paypal_fee_act);

      $alloc->trans_no = $payment_no;
      $alloc->add_item(ST_SALESINVOICE, $invoice_no, $recpt_date, $date, $gross,
                          $gross, $gross, $ref);
      $alloc->write();
      $alloc->allocs = array();
      unset($alloc->allocs);
      unset($alloc);
    }
    log_message("Memory, write_customer_invoices end:".memory_get_usage());
}
function write_bank_receipt($date, $ref, $name, $shipping, $insurance, $tax, $gross, $fee, $net) {
    global $paypal_shipping_act, $paypal_insurance_act, $paypal_sales_tax_act,
            $paypal_sales_act, $paypal_add_tax, $paypal_fee_act, $paypal_bank_id;

    log_message("Memory, write_bank_receipt start:".memory_get_usage());

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
    $entry->add_gl_item($paypal_fee_act, '', '', -$fee, $ref);
    $entry->add_gl_item($paypal_sales_act, '', '', -$taxNet, $ref);

    log_message("Deposit, ref:".$ref.", net:".$net);
    write_bank_transaction(ST_BANKDEPOSIT, 0, $paypal_bank_id, $entry, $entry->tran_date,
                      PT_MISC, $name, false, $entry->reference, $entry->memo_, false);
    $entry->clear_items();
    unset($entry);
    log_message("Memory, write_bank_receipt end:".memory_get_usage());

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
log_message("Memory, phase 2 process start:".memory_get_usage());

$postBack = process_combo_postback();

$myRow = get_paypal_unconfirmed_count($user_id);
$totalPayments = $myRow[0];
$unconfirmedPayments = $myRow[1];

if (isset($_GET["filename"]))
    $filename = $_GET["filename"];
else
    $filename = get_post("filename",'');

page(_("Select payments' account"));
$lines = 0;

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
        $paypal_fee_act  = $prefs["paypal_fee_act"];
        $paypal_shipping_act  = $prefs["paypal_shipping_act"];
        $paypal_insurance_act  = $prefs["paypal_insurance_act"];
        $paypal_withdraw_id  = $prefs["paypal_withdraw_id"];
        $use_paypal_trn_id = $prefs['use_paypal_trn_id'];
        $paypal_add_tax = $prefs['paypal_add_tax'];
        $paypal_recpt_today = $prefs['paypal_recpt_today'];
        $paypal_item_tax_id = $prefs['paypal_item_tax_id'];
        $paypal_tax_type_id = $prefs['paypal_tax_type_id'];
        $paypal_tax_included = $prefs['paypal_tax_included'];
        $paypal_name_col = $prefs['paypal_name_col'];
        unset($prefs);
        $headings = array();
        $data = array();

        log_message("Paypal act:".$paypal_bank_id.", withdrawal:".$paypal_withdraw_id.", sales:".$paypal_sales_act.", tax:".$paypal_sales_tax_act);

      	$sep = ',';

      	$fp = @fopen($filename, "r");
      	if (!$fp)
            die(_("can not open file")." ".$filename);

      	$fileline = fgetcsv($fp, 4096, $sep);
        log_message("Fileline:".implode(',',$fileline));
      	foreach( $fileline as $field ) { $headings[] = trim($field); }

        begin_transaction();

      	$lines = $new_custs = $updated_custs = $invoices = $receipts = $payments = $transfers = $pending = 0;
      	// type, item_code, stock_id, description, category, units, qty, mb_flag, currency, price
      	while ($fileline = fgetcsv($fp, 4096, $sep)) {
          log_message("Fileline:".implode(',',$fileline));
          //log_message("GC:".gc_collect_cycles());
          foreach( $headings as $k => $v ) {
            // Store data against field headings
            $data[$v] = $fileline[$k];
          }
          $lines++;
          $date = $data["Date"];
          $time = $data["Time"];
          $status = $data["Status"];
          $fromEmail = $data["From Email Address"];
          $memo = $data["Item Title"];
          $item_code = $data["Item ID"];
          $item_title = $data["Item Title"];
          $currency = $data["Currency"];
          $name = $data["Name"];
			if (!empty($paypal_name_col)) {
				$company = $data[$paypal_name_col];
			} else {
				$company = $data["Name"];
			}
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
                write_customer_invoices($date, $status, $company, $ref, $fromEmail, $currency, $item_code, $item_title, $shipping, $insurance, $tax, $gross, $fee, $net);
                // create invoice, bank receipt, allocate payment to invoice
                $invoices += 1;
              } else {
                // create bank transfer crediting sales account directly
                if (!$use_paypal_trn_id) {
                  $ref = $data["Transaction ID"];
                }
                write_bank_receipt($date, $ref, $company, $shipping, $insurance, $tax, $gross, $fee, $net);
                $receipts += 1;
              }
              break;
            case "UPDATE TO ECHEQUE RECEIVED":
              break;
            case "PAYPAL EXPRESS CHECKOUT PAYMENT SENT":
            case "EXPRESS CHECKOUT PAYMENT SENT":
            case "WEB ACCEPT PAYMENT SENT":
              write_payment($ref, $gross, $date, $memo, $name, $paypal_bank_id);
              $payments += 1;
              break;
            case "WITHDRAW FUNDS TO A BANK ACCOUNT":
              log_message("Withdrawal, ref:".$ref.", from:".$paypal_bank_id.", to:".$paypal_withdraw_id.", amount:".-$gross);
              add_bank_transfer($paypal_bank_id, $paypal_withdraw_id, $date,
                      -$gross, $ref, _("Paypal transfer"), 0, 0);
              $transfers += 1;
              break;
          }
          log_message("Memory, process line:" .$lines.":".memory_get_usage());

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
