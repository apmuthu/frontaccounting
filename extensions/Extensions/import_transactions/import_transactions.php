<?php

//Author: Ross Addison Version 2.3.21 upgrade to Tom Hallman's 2.3.3
//Website: http://www.bbqq.co.uk
//Email: frontaccounting@bbqq.co.uk 
//New features:
//1. Trial check before importing.
//2. Tabular display of journal entries, each journal grouped into  debits and credits using Front Accounting's 'items cart' class.
//3. Importing of bank statements.
//4. Tax type inclusion for VAT registered companies.
//5. Inclusion of transactions automatically in an audit trail.
//6. Display notifications identifying how tables within the database are being affected for a more transparent display to interested programmers.
//7. Additional lookup tools for looking up customer, supplier, company setup information eg. fiscal year, and other tools that users might find useful for their import.
//8. Inclusion of csv examples using the en_GB account structure under folder templates.
//9. See the Spreadsheet_headers file for csv formats.
//10. Import Sales Orders/Invoices

//Module contents
//./Import_transactions/import_transactions.php
//./Import_transactions/template/bank_en_GB.csv                                       .......for bank statement processing......users process bank.csv twice. once with 'deposit processing' and once with 'payment processing'.
//./Import_transactions/template/deposit_en_GB.csv                                    .......for non-bank statement deposit processing...deposit.csv
//./Import_transactions/template/payment_en_GB.csv                                    .......for non-bank statement payment processing...payment.csv
//./Import_transactions/template/journal_en_GB.csv                                    .......for non-bank journal processing.............journal.csv
//./Import_transactions/includes/import_transactions.inc                              .......include file containing functions used here.
//./Import_transactions/includes/import_sales_order_entry.inc                         .......for importing sales orders/invoices
//./Import_transactions/includes/import_sales_cart_class.inc                         
//./Import_transactions/includes/import_sales_order_ui.inc

$page_security = 'SA_CSVTRANSACTIONS';
$path_to_root="../..";
include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/includes/sysnames.inc"); //referencetype_list_row for determining next reference for source documents
include_once($path_to_root . "/includes/main.inc"); //function page
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/includes/ui/items_cart.inc"); //class 'items_cart' gl_items for classic tabular representation of journals
include_once($path_to_root . "/includes/ui/ui_input.inc");
include_once($path_to_root . "/includes/references.inc"); //get next reference, exists reference.
include_once($path_to_root . "/includes/db/audit_trail_db.inc"); //add_audit_trail mandatory for all import transactions
include_once($path_to_root . "/includes/db/references_db.inc"); //get next reference
include_once($path_to_root . "/gl/includes/db/gl_db_trans.inc"); // write journal entries; add_gl_tax_details; add_gl_trans
include_once($path_to_root . "/gl/includes/db/gl_db_bank_trans.inc"); //add_bank_trans
include_once($path_to_root . "/gl/includes/db/gl_db_bank_accounts.inc"); //get_bank_gl_account
include_once($path_to_root . "/gl/includes/db/gl_db_accounts.inc"); // gl_account_in_bank_accounts
include_once($path_to_root . "/gl/includes/gl_db.inc"); //link to other includes
include_once($path_to_root . "/includes/date_functions.inc"); //sql2date, is_date_in_fiscal_year
include_once($path_to_root . "/includes/data_checks.inc");
include_once($path_to_root . "/admin/db/company_db.inc"); //default control accounts
include_once($path_to_root . "/includes/ui/ui_controls.inc");
include_once($path_to_root . "/modules/import_transactions/includes/import_transactions.inc"); //functions used
include_once($path_to_root . "/modules/import_transactions/includes/import_sales_order_entry.inc"); // adaptation of sales_order_entry.php
include_once($path_to_root . "/modules/import_transactions/includes/import_sales_cart_class.inc"); // adaptation of cart class
include_once($path_to_root . "/modules/import_transactions/includes/import_sales_order_ui.inc"); // adaptation of sales_order_ui.inc
//include_once($path_to_root . "/gl/includes/ui/gl_journal_ui.inc"); display_import_items adapted from display_ gl_items

add_access_extensions();

//Turn these next two lines on for debugging
error_reporting(E_ALL);
ini_set("display_errors", "on");

//Set '$yes' to true if you are testing this module and you do not want to manually(phpmyadmin) delete previous test run records before each test run
//Ensure that your company has no important information in it as these will be deleted by means of all_delete function under import_transactions.inc 
//Warning: Most records will be deleted if '$yes' set to true. Default must stay on false for normal operation.
//Recommended: Remove this next line after you are happy with testing.
all_delete($yes=false);

$js = '';
if ($use_popup_windows) {$js .= get_js_open_window(800, 500);}
$help_context = "Import General Journals  / Deposits / Payments / Bank Statements / Sales Orders / Sales Invoices  <a href='spreadsheet_headers.html'>Help: Formats</a>"; 
page(_($help_context), false, false, "", $js);

global $Refs;
global $Ajax;

if ((isset($_POST['type']))) 
{
 $type = $_POST['type'];
 $entry = new items_cart($type);
 init_entry_part_1($entry, $type);
 if (($type > 0) && isset($_POST['stateformat']))
 {
 	$stateformat = $_POST['stateformat'];
 }
 else 
 {
 	$stateformat = null;
 }
 $errCnt = 0;
 $entryCount = 0;
 $bank_account_gl_code="";
 $error = false;
 $displayed_at_least_once = false;
 if (isset($_FILES['imp']) && $_FILES['imp']['name'] != '')
 {
   $filename = $_FILES['imp']['tmp_name'];
   $sep = $_POST['sep'];
   if (isset($_POST['bank_account']) ? $_POST['bank_account'] : ""){
   $bank_account = isset($_POST['bank_account']) ? $_POST['bank_account'] : "";
   $bank_account_gl_code = get_bank_gl_account($bank_account);} //gl_db_bank_accounts.inc
   $fp = @fopen($filename, "r");

   $trial = (isset($_POST['trial']) ? $_POST['trial'] : false);

   if (!$fp)
   {
    display_error(_("Error opening file $filename"));
   }
   else 
   {
     begin_transaction();
     $curEntryId=last_transno($type)+1;
     $line = 0;
     $description = "";
     $i=0;
     $docline=1;
     $doc_num=0;
     $firstlinecopied=false;
     $no=0;
     $total_debit_positive=0;
     $total_credit_negative=0;
     $input_id=1;
     $skippedheader = false;
     $prev_ref = -1;
     $prev_date = null;
     $bank_desc = "";
     $ignore = "";
     $debitsEqualcredits = 1;
     check_db_has_stock_items(_("There are no inventory items defined in the system."));
     check_db_has_customer_branches(_("There are no customers, or there are no customers with branches. Please define customers and customer branches."));   
     while ($data = fgetcsv($fp, 4096, $sep))
     {
       if (($line++ == 0) && ($skippedheader == false))
           {display_notification_centered(_("Skipped header. (line $line in import file '{$_FILES['imp']['name']}')"));$skippedheader = true;continue;}
            display_notification_centered(" --------------------------------------------------------------------------------------------Line $line ------------------------------------------------------------------------------------------"); 
       
       if ($type == 0) // if type is a journal
        {       
         list($reference, $date, $memo, $amt, $code_id, $taxtype, $dim1_ref, $dim2_ref,$person_type_id,$person_id) = $data;
         $memo = $memo ." Date: ".$date." Reference: ".$reference;
        }
        
        
       if  (($type == ST_BANKPAYMENT) && ($stateformat!=null))
           //All amounts to the right of amt are ignored since only considering payments which are to the left of deposits on a bank statement.     
       {
               list($reference, $date, $memo, $amt, $ignore, $code_id, $taxtype, $dim1_ref, $dim2_ref,$person_type_id,$person_id,$BranchNo) = $data;
               display_notification_centered("You are here payment");
               if ((($ignore == "")||($ignore == null) || empty($ignore)) && ($amt > 0.01 )){} else 
                 {
                   display_notification_centered(_("Ignoring deposit. Use same csv under deposit processing. (line $line in import file '{$_FILES['imp']['name']}')")); 
                   $error = false;
                   $prev_ref = $reference;
                   continue;                  
                 } 
       }

      if (($type == ST_BANKDEPOSIT) && ($stateformat!=null))
      {
           //All amounts to the left of amt are ignored since only considering deposits which are to the left of payments on a bank statement.     
               list($reference, $date, $memo, $ignore, $amt, $code_id, $taxtype, $dim1_ref, $dim2_ref,$person_type_id,$person_id,$BranchNo) = $data;
               if ((($ignore == "")||($ignore == null)|| empty($ignore) ) && ($amt > 0.01 )){} else 
                   {
                    display_notification_centered(_("Ignoring payment. Use same csv under payment processing.(line $line in import file '{$_FILES['imp']['name']}')"));  
                    $error = false;
                    $prev_ref = $reference;
                    continue;
                   } 
       }

       if ((($type == ST_BANKDEPOSIT) || ($type == ST_BANKPAYMENT)) && ($stateformat==null))
       list($reference, $date, $memo, $amt, $code_id, $taxtype, $dim1_ref, $dim2_ref, $person_type_id, $person_id, $BranchNo) = $data;
           
       if (($type == ST_SALESORDER) || ($type == ST_SALESINVOICE))
           {
            list($customer_id, $branchNo, $reference, $date, $payment_id, $sales_type_name, $dimension_id, $dimension2_id, $item_code, $item_description, $quantity, $unit, $price, $discountpercentage, $freightcost, $delfrom, $deldate, $delto, $deladdress, $contactphone, $email, $custref, $shipvia, $comments, $exrate) = $data;
            display_notification_centered(_("Processing line $line ($customer_id, $branchNo, $reference, $date, $payment_id, $sales_type_name, $dimension_id, $dimension2_id, $item_code, $item_description, $quantity, $unit, $price, $discountpercentage, $freightcost, $delfrom, $deldate, $delto, $deladdress, $contactphone, $email, $custref, $shipvia, $comments, $exrate) in import file '{$_FILES['imp']['name']}')"));
            if (!customer_exist($customer_id)){display_notification("Customer does not exist in the database"); $error=true;}
            if (($prev_ref <> $reference)) // reference has changed so new invoice with new lineitem(s) 
            {
                if ($firstlinecopied == true) // if the reference has changed for line items write the preference reference based document to the cart
                {
                    $_SESSION['Items']->write(0); //reset the cart for the next set of line items for each reference document.
                    $_SESSION['Items']->clear_items();
                    unset($_SESSION['Items']->line_items);
                    unset($_SESSION['Items']);
                    $firstlinecopied = false;
                }
                $docline = 1; //the reference has changed so this will be the first line item.
                $doc_num++;
                $_SESSION['Items'] = new import_sales_cart($type, 0, false); 
                $_SESSION['Items']->document_date = $date;
                $_SESSION['Items']->order_no = $reference; //order_no is the source document's original 
                $com = get_customer_details_to_order($_SESSION['Items'], $customer_id, $branchNo);
                display_notification_centered($com);
                if ($com <> "")
                {
                     display_notification_centered("Error");
                     $error=true;
                }
                copy_to_cart($customer_id, $branchNo, $sales_type_name, $reference, $date, $payment_id, $dimension_id, $dimension2_id, $freightcost=0, $delfrom, $deldate, $delto, $deladdress, $contactphone, $email, $custref, $shipvia, $comments,$exrate=null);
                $firstlinecopied = true;
            }
            if ($prev_ref == $reference)  
            {    
                $docline=$docline+1; 
                $com = get_customer_details_to_order($_SESSION['Items'], $customer_id, $branchNo);
                display_notification_centered($com);
                if ($com <> "")
                {
                    display_notification_centered("Error");
                    $error=true;
                }
                copy_to_cart($customer_id, $branchNo, $sales_type_name, $reference, $date, $payment_id, $dimension_id, $dimension2_id, $freightcost=0, $delfrom, $deldate, $delto, $deladdress, $contactphone, $email, $custref, $shipvia, $comments,$exrate=null);
                
            }
            import_add_to_order($_SESSION['Items'], $item_code, $quantity, $price, $discountpercentage, $item_description);
            $_SESSION['Items']->cust_ref = $reference;
            if ((!check_import_item_data($line_no=$docline, $item_code, $item_description, $quantity, $unit, $price, $discountpercentage)) ||
             (!can_process($line, $customer_id, $branchNo, $reference, $date, $dimension_id, $dimension2_id, $freightcost=0, $delfrom, $deldate, $delto, $deladdress, $contactphone, $email, $custref, $shipvia, $comments,$exrate)))
            {
                display_notification_centered("Error");
                $error=true;}
               
         }

         if (($prev_ref <> $reference) && ($type < 4)) {     
         init_entry_part_2($entry, $date, $reference);}
         
         if ($type == 0)
         {
             list($error,$input_id, $total_debit_positive, $total_credit_negative)=journal_id($prev_date,$date,$amt, $input_id=0, $total_debit_positive, $total_credit_negative, $line);
         }

        if (($type == ST_BANKDEPOSIT) || ($type == ST_BANKPAYMENT) || ($type == ST_JOURNAL))
        {
            list($error,$memo)=check_customer_supplier($code_id,$person_id,$person_type_id,$line,$memo,$error);
            if (check_code_id($code_id)){}else{display_notification_centered("Error: Account code $code_id does not exist");$error = true;}
            $dim1 = get_dimension_id_from_dimref($dim1_ref);
            if ($dim1_ref != '' && $dim1 == null) {display_error(_("Error: Could not find dimension with dimension reference '$dim1_ref' (line $line in import file '{$_FILES['imp']['name']}')"));$error = true;}
            $dim2 = get_dimension_id_from_dimref($dim2_ref);
            if ($dim2_ref != '' && $dim2 == null) {display_error(_("Error: Could not find dimension with dimension reference '$dim2_ref' (line $line in import file '{$_FILES['imp']['name']}')"));$error = true;}
        }

         if ($reference == '' ){display_error(_("$line does not have a reference. (line $line in import file '{$_FILES['imp']['name']}')"));$error = true;}
         if (($Refs->exists($type, $reference)) && ($reference!=$prev_ref)){
          display_error(_("Error: Reference from table 'refs': '$reference' is already in use. (line $line in import file '{$_FILES['imp']['name']}')"));$error = true;}   
         elseif (($Refs->exists($type, $reference)) && ($reference==$prev_ref)){//do nothing $Refs->save($type,$line,$reference);            
         }elseif ((($Refs->exists($type, $reference))==null) && ($reference!=$prev_ref)){
           $Refs->save($type,$curEntryId,$reference);
           save_next_reference($type, $reference);
         }      

      if (($type == ST_BANKDEPOSIT) || ($type == ST_BANKPAYMENT) || ($type == ST_JOURNAL))
      {$description = get_gl_account_name($code_id);}
      if (is_date($date)==false)
          {
	  	display_error(_("Error: date '$date' not properly formatted (line $line in import file '{$_FILES['imp']['name']}')"));
		$error = true;
	  }
      //$date = sql2date($date);
     if ((is_date_in_fiscalyear($date)) == false) {display_error(_("Error: Date not within company fiscal year. Make sure date is in dd/mm/yyyy format and your csv years are 4 digits long. Check that current fiscal year is active under Setup..Company Setup"));$error=true;}
     // validation for 
                  
     if (($type == ST_BANKDEPOSIT) || ($type == ST_BANKPAYMENT)) {$bankdesc = get_gl_account_name($bank_account_gl_code);}

     if (($type == ST_BANKDEPOSIT) || ($type == ST_BANKPAYMENT) || ($type == ST_JOURNAL))
     {   
       $i=journal_display($i, $type, $taxtype, $amt, $entry, $code_id, $dim1, $dim2, $memo, $description, $bank_account_gl_code, $bank_desc);
     }

      if (!$error)
     {
       if (($type == ST_JOURNAL))
       {
         if (gl_account_in_bank_accounts($code_id) == true){display_notification_centered(_("Error: Bank account detected in journal. No processing of bank accounts allowed. (line $line in import file '{$_FILES['imp']['name']}')"));$error = true;}
         if (check_tax_appropriate($code_id, $taxtype,$line) == true) 
         {        
             journal_inclusive_tax($type,$date, $line, $curEntryId, $code_id, $dim1, $dim2, $memo, $amt, $taxtype,$person_type_id,$person_id);
             add_audit_trail($type, $curEntryId, $date);
         }
            
       } 
       elseif (($type == ST_BANKDEPOSIT || $type == ST_BANKPAYMENT) && ($amt > 0))
       {
          if (check_tax_appropriate($code_id, $taxtype, $line) == true)
          {
           bank_inclusive_tax($type, $reference, $date, $bank_account, $bank_account_gl_code, $line, $curEntryId, $code_id, $dim1, $dim2, $memo, $amt, $taxtype,$person_type_id,$person_id, $BranchNo);
          }
          else 
         {
             display_notification_centered(_("Warning: Taxtype used with Asset or Liability - $curEntryId, $date, $code_id.(line $line in import file '{$_FILES['imp']['name']}')"));
         } 
       }
       
       elseif (($type == ST_BANKDEPOSIT || $type == ST_BANKPAYMENT) && ($amt < 0))
       {
           display_notification_centered(_("Error: Credit amounts represented by negative amounts being entered. Check csv file is correct.(line $line in import file '{$_FILES['imp']['name']}')"));
           $error = true;
       }
       $entryCount = $entryCount+1;  
     } 
     
     if ($error) {$errCnt=$errCnt+1;} 
     $error = false;
     $prev_ref = $reference;
     $prev_date = $date;
     $curEntryId += (($type <> 0) ? 1 : $input_id);
    }//while

    if (($type == ST_BANKDEPOSIT) || ($type == ST_BANKPAYMENT) || ($type == ST_JOURNAL))
    {
        $displayed_at_least_once = display_entries($type, $entry);
        end_row();
        end_table(1); 
        div_end();
        if ($displayed_at_least_once == false) //there has been no occurrence of debits equalling credits - at least one journal not properly balanced
        {
            display_notification_centered(_("Error: Debits do not equal credits.")); 
            $errCnt = $errCnt + 1;
        }
    }
    
    if (($type == ST_SALESORDER) || ($type == ST_SALESINVOICE))
    {
               if (($firstlinecopied == true) && ($prev_ref == $reference)) //for the last line item in a csv 
                {
                    $_SESSION['Items']->write(0);
                    $_SESSION['Items']->clear_items();
                    unset($_SESSION['Items']->line_items);
                    unset($_SESSION['Items']);
                    $firstlinecopied = false;
                }

    }
// Commit import to database

 if ($type == ST_JOURNAL){$typeString = "General Journals";}
 elseif ($type == ST_BANKDEPOSIT){$typeString = "Deposits";}
 elseif ($type == ST_BANKPAYMENT){$typeString = "Payments";}
 elseif ($type == ST_SALESORDER){$typeString = "Sales Order csv lines / $doc_num order(s)";}
 elseif ($type == ST_SALESINVOICE){$typeString = "Sales Invoices csv lines / $doc_num invoice(s)";}
 
 if (!$trial) {
    if ($errCnt == 0) {
        if ($entryCount > 0) {
		    commit_transaction();
		    display_notification_centered(_("$entryCount $typeString have been imported."));
	    } else display_error(_("Import file contained no $typeString."));
    }
 } else {
	if ($errCnt==0) {
        if ($entryCount > 0) display_notification_centered(_("$entryCount $typeString would have been successful if imported. Uncheck Trial check before importing."));
        else display_notification_centered(_("Import file contained no $typeString. Populate file with data before importing."));
	}
	if (($errCnt>0) && $displayed_at_least_once) display_notification_centered(_("$errCnt error(s) detected. Correct before importing."));
 }
 $errCnt =0;
   
  }// if (!$fp)
 }// if (isset($_FILES['imp']) && $_FILES['imp']['name'] != '')
@fclose($fp);


}// if (isset($_POST['type'])) 

// User Interface
start_form(true);
div_start('_main_table');
initialize_controls();
start_table(TABLESTYLE2,"width=95%");//inner table
$type=show_table_section_import_settings();
if (($type == ST_JOURNAL) || ($type == ST_BANKDEPOSIT) || ($type == ST_BANKPAYMENT))
{  
  show_table_section_control_accounts();
}  
show_table_section_display($type);
if ((($type == ST_BANKDEPOSIT) || ($type == ST_BANKPAYMENT)))
{
    $stateformat = show_table_section_bankstatement_checkbox();
}
show_table_section_csv_separator();
show_table_section_trial_or_final();
end_table(1);
div_end('_main_table');
submit_center('import', "Process",$echo=true, $title=false, $async=true, $icon=ICON_OK);
end_form();
end_page();
?>
