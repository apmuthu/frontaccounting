<?php
//module/import_transactions
function all_delete($yes=true)
{
   if ($yes==true)
   {    
    display_notification(_("Function 'all_delete' has been set to true: Relevant records deleted before each test run."));
    //journal entries table: gl_trans
    $sql1a = "SELECT * FROM ".TB_PREF."gl_trans";
    $result1a = db_query($sql1a, _("Could not query gl_trans"));
    if (db_num_rows($result1a) > 0)
    {  
     
     $sql1b = "DELETE FROM ".TB_PREF."gl_trans";
     $result1b = db_query($sql1b, _("Could not delete records."));
     display_notification(_("Deleted ".db_num_rows($result1a)." records from table gl_trans.")); 
    }  
      
    //bank entries table: bank_trans
    $sql2a = "SELECT * FROM ".TB_PREF."bank_trans WHERE id>-1";  
    $result2a = db_query($sql2a, _("Could not query bank_trans"));
    if (db_num_rows($result2a) > 0)
    {
    
    $sql2b = "DELETE FROM ".TB_PREF."bank_trans";
    $result2b=db_query($sql2b, _("Could not delete records."));
    display_notification(_("Deleted ".db_num_rows($result2a)." records from table bank_trans.")); 
    }    
    
    //tax entries  table: trans_tax_details
    $sql3a = "SELECT * FROM ".TB_PREF."trans_tax_details WHERE id>-1";   
    $result3a = db_query($sql3a, _("Could not query bank_trans"));
    if (db_num_rows($result3a) > 0)
    {
    
    $sql3b = "DELETE FROM ".TB_PREF."trans_tax_details";
    $result3b=db_query($sql3b, _("Could not delete records."));
    display_notification(_("Deleted ".db_num_rows($result3a)." records from table trans_tax_details.")); 
    }
    
    //next_reference entries table: sys_types 
    $sql4 =  "UPDATE ".TB_PREF."sys_types SET next_reference='1'";
    $result4=db_query($sql4, _("Could not update records."));
    display_notification(_("Reset column 'next_reference' in table 'sys_types' to '1' for all types.")); 
    
    //refs
    $sql5a = "SELECT * FROM ".TB_PREF."refs";   
    $result5a=db_query($sql5a, _("Could not query bank_trans"));
    if (db_num_rows($result5a) > 0)
    {
    
    $sql5b = "DELETE FROM ".TB_PREF."refs";
    $result5b=db_query($sql5b, _("Could not delete records."));
    display_notification(_("Deleted ".db_num_rows($result5a)." records from table refs")); 
    }
    
    //suppliers transactions all deleted
    $sql6a = "SELECT * FROM ".TB_PREF."supp_trans";  
    $result6a = db_query($sql6a, _("Could not query supp_trans"));
    if (db_num_rows($result6a) > 0)
    {
        
    $sql6b = "DELETE FROM ".TB_PREF."supp_trans";
    $result6b=db_query($sql6b, _("Could not delete records."));
    display_notification(_("Deleted ".db_num_rows($result6a)." records from table supp_trans.")); 
    }   
        
    //customers transactions all deleted
    $sql7a = "SELECT * FROM ".TB_PREF."debtor_trans";  
    $result7a = db_query($sql7a, _("Could not query debtor_trans"));
    if (db_num_rows($result7a) > 0)
    {
   
    $sql7b = "DELETE FROM ".TB_PREF."debtor_trans";
    $result7b=db_query($sql7b, _("Could not delete records."));
    display_notification(_("Deleted ".db_num_rows($result7a)." records from table debtor_trans.")); 
    }  
    
    $sql8a = "SELECT * FROM ".TB_PREF."comments";  
    $result8a = db_query($sql8a, _("Could not query comments."));
    if (db_num_rows($result8a) > 0)
    {
   
    $sql8b = "DELETE FROM ".TB_PREF."comments";
    $result8b=db_query($sql8b, _("Could not delete records."));
    display_notification(_("Deleted ".db_num_rows($result8a)." records from table comments.")); 
    }  
      
   } 
     
}

function bank_inclusive_tax($type, $reference, $date, $bank_account, $bank_account_gl_code, $line, $curEntryId, $code, $dim1, $dim2, $memo, $amt, $taxtype, $person_type_id,$person_id, $BranchNo) // extra inclusive of tax column in csv
{
    list($return_amt,$inclusive_amt,$exclusive_amt,$taxamt,$taxaccount,$salestaxaccount,$purchasetaxaccount)=determinetax($taxtype, $amt); 
    if ($type == ST_BANKDEPOSIT)
      {
          add_bank_trans($type, $curEntryId, $bank_account, $reference, $date, $inclusive_amt, $person_type_id, $person_id,$currency="", $err_msg="", $rate=0);
          display_notification_centered(_("Added to table 'bank_trans': $curEntryId, $date, $reference, $code, $dim1, $dim2, $inclusive_amt (line $line in import file '{$_FILES['imp']['name']}')"));          
          
          if ($taxtype > 0)
          { 
                   
                add_gl_trans($type,$curEntryId, $date, $code, $dim1, $dim2 ,$memo, -$exclusive_amt, $currency=null, $person_type_id,$person_id, $err_msg="", $rate=0); 
                add_audit_trail($type, $curEntryId, $date);
                display_notification_centered(_("Added to table 'gl_trans Credit:': $curEntryId, $date, $code, $dim1, $dim2, -$exclusive_amt, $memo (line $line in import file '{$_FILES['imp']['name']}')"));    
      
                add_gl_trans($type,$curEntryId, $date, $salestaxaccount, $dim1, $dim2 ,$memo, -$taxamt, $currency=null, $person_type_id,$person_id, $err_msg="", $rate=0); 
                add_audit_trail($type, $curEntryId, $date);
                display_notification_centered(_("Added tax to table 'gl_trans Credit:': $curEntryId, $date, $salestaxaccount, $dim1, $dim2, -$taxamt, $memo (line $line in import file '{$_FILES['imp']['name']}')"));    
      
                if ((customer_exist($person_id)) && ($person_type_id==2))
                   {
                      display_notification_centered(_("No tax types should be used with customer deposits since tax is accounted for at source document entry - eg. Invoice'. Use customer id with a control account only. (line $line in import file '{$_FILES['imp']['name']}')"));    
                   }
              
                if ((supplier_exist($person_id)) && ($person_type_id==1))
                   {
                      display_notification_centered(_("No tax types should be used with supplier payments since tax is accounted for at source document entry - eg. Invoice'. Use supplier id with a control account only.(line $line in import file '{$_FILES['imp']['name']}')"));    
                   }  
          }
          
          if ($taxtype == 0)
          {
              add_gl_trans($type,$curEntryId, $date, $code, $dim1, $dim2 ,$memo, -$inclusive_amt, $currency=null, $person_type_id,$person_id, $err_msg="", $rate=0); 
              add_audit_trail($type, $curEntryId, $date);
              display_notification_centered(_("Added to table 'gl_trans Credit:': $curEntryId, $date, $code, $dim1, $dim2, -$inclusive_amt, $memo (line $line in import file '{$_FILES['imp']['name']}')"));    
              
              if ((customer_exist($person_id)) && ($person_type_id==2))
              {
                  write_customer_trans(ST_BANKDEPOSIT, $curEntryId, $person_id, $BranchNo, $date, $reference, $inclusive_amt);
                  display_notification_centered(_("Added to table 'debtor_trans Credit: Payment from customer': $inclusive_amt (line $line in import file '{$_FILES['imp']['name']}')"));    
              }
              
              if ((supplier_exist($person_id)) && ($person_type_id==1))
              {
                  write_supp_trans(ST_BANKDEPOSIT, $curEntryId, $person_id, $date, $due_date="", $reference, $supp_reference="", $inclusive_amt, $amount_tax=0, $discount=0);
                  display_notification_centered(_("Added to table 'supp_trans Credit: Our over-payment amount reimbursed': $inclusive_amt (line $line in import file '{$_FILES['imp']['name']}')"));    
              }    
                  
                  
          }
           
      add_gl_trans($type, $curEntryId, $date, $bank_account_gl_code, $dim1, $dim2 ,$memo, $inclusive_amt, $currency=null, $person_type_id, $person_id, $err_msg="", $rate=0);
      add_audit_trail($type, $curEntryId, $date);
      display_notification_centered(_("Added to table 'gl_trans' Debit bank account: $curEntryId, $date, $bank_account_gl_code, $dim1, $dim2, $inclusive_amt, $memo (line $line in import file '{$_FILES['imp']['name']}')"));    
      add_gl_tax_details($salestaxaccount, ST_BANKDEPOSIT, $curEntryId, -$taxamt, 1, $date, $memo,1, -$inclusive_amt);
      }
      If ($type == ST_BANKPAYMENT)
      {
         add_bank_trans($type, $curEntryId, $bank_account, $reference, $date, -$inclusive_amt, $person_type_id, $person_id,$currency="", $err_msg="", $rate=0);
         display_notification_centered(_("Added to table 'bank_trans': $curEntryId, $date, $reference, $code, $dim1, $dim2, -$inclusive_amt (line $line in import file '{$_FILES['imp']['name']}')"));     
          
          
          if ($taxtype > 0)
          {        
                add_gl_trans($type,$curEntryId, $date, $code, $dim1, $dim2 ,$memo, $exclusive_amt, $currency=null, $person_type_id,$person_id, $err_msg="", $rate=0);
                add_audit_trail($type, $curEntryId, $date);
                display_notification_centered(_("Added to table 'gl_trans' Debit: $curEntryId, $date, $code, $dim1, $dim2, $exclusive_amt, $memo (line $line in import file '{$_FILES['imp']['name']}')"));                                        
      
                add_gl_trans($type,$curEntryId, $date, $purchasetaxaccount, $dim1, $dim2 ,$memo, $taxamt, $currency=null, $person_type_id,$person_id, $err_msg="", $rate=0);
                add_audit_trail($type, $curEntryId, $date);
                display_notification_centered(_("Added tax to table 'gl_trans' Debit: $curEntryId, $date, $purchasetaxaccount, $dim1, $dim2, $taxamt, $memo (line $line in import file '{$_FILES['imp']['name']}')"));                                        
                
                if ((customer_exist($person_id)) && ($person_type_id==2))
                   {
                      display_notification_centered(_("No tax types should be used with customer deposits since tax is accounted for at source document entry - Invoice'. Use customer id with a control account only. (line $line in import file '{$_FILES['imp']['name']}')"));    
                   }
              
                if ((supplier_exist($person_id)) && ($person_type_id==1))
                   {
                      display_notification_centered(_("No tax types should be used with supplier payments since tax is accounted for at source document entry - Invoice'. Use supplier id with a control account only.(line $line in import file '{$_FILES['imp']['name']}')"));    
                   }  
          }
      if ($taxtype == 0)
          {
             add_gl_trans($type,$curEntryId, $date, $code, $dim1, $dim2 ,$memo, $inclusive_amt, $currency=null, $person_type_id,$person_id, $err_msg="", $rate=0);
             add_audit_trail($type, $curEntryId, $date);
             display_notification_centered(_("Added to table 'gl_trans' Debit: $curEntryId, $date, $code, $dim1, $dim2, $inclusive_amt, $memo (line $line in import file '{$_FILES['imp']['name']}')")); 
             
              if ((customer_exist($person_id)) && $person_type_id==2)
              {
                  write_customer_trans(ST_BANKPAYMENT, $curEntryId, $person_id, $BranchNo, $date, $reference, -$inclusive_amt);
                  display_notification_centered(_("Added to table 'debtor_trans Debit:' Customer over-payment reimbursed -$inclusive_amt (line $line in import file '{$_FILES['imp']['name']}')"));    
              }
              
              if ((supplier_exist($person_id)) && $person_type_id==1)
              {
                  write_supp_trans(ST_BANKPAYMENT, $curEntryId, $person_id, $date, $due_date="", $reference, $supp_reference="", -$inclusive_amt, $amount_tax=0, $discount=0);                  
                  display_notification_centered(_("Added to table 'supp_trans' Debit: Supplier paid -$inclusive_amt (line $line in import file '{$_FILES['imp']['name']}')"));    
              }  
             
         }
      add_gl_trans($type,$curEntryId, $date, $bank_account_gl_code, $dim1, $dim2 ,$memo, -$inclusive_amt, $currency=null,$person_type_id, $person_id, $err_msg="", $rate=0);
      add_audit_trail($type, $curEntryId, $date);
      display_notification_centered(_("Added to table 'gl_trans' Credit bank account: $curEntryId, $date, $bank_account_gl_code, $dim1, $dim2, -$inclusive_amt, $memo (line $line in import file '{$_FILES['imp']['name']}')"));    
      add_gl_tax_details($purchasetaxaccount, ST_BANKPAYMENT, $curEntryId, $taxamt, 1, $date, $memo,1, $inclusive_amt);
      }
   }

//Note: Ajax will be implemented here since default is true
function checkbox_row($label, $name, $value, $submit_on_change=true, $title, $params = "") //adapted from check_row to accomodate colspan
{
	if (is_array($label))
        {
            echo "<tr><td class='label' $params><ul>";
            foreach ($label as $line => $item) {echo "<li>$item</li>";}
            echo "</ul></td>";
        }
        else
            
        {
            echo "<tr><td class='label' $params>$label</td>";            
        }           
        echo "<td>";
	echo checkbox("", $name, $value, $submit_on_change=true, $title);
	echo "</td>";
        echo "</tr>\n";
}
//function checkbox_row($label, $name, $value, $params='', $submit_on_change, $title) //adapted from check_row to accomodate colspan

//notify when tax type used with income or expenses.
//issue warning if 'ie' is returned false => tax type used with asset or liability. 
function check_tax_appropriate($code, $taxtype, $line)
{
    $ie = true;
    if ($taxtype > 0) 
    {//get account_code and account_type from chart master
      $sql = "SELECT account_code,account_type FROM ".TB_PREF."chart_master WHERE ".$code." = account_code";
      $result = db_query($sql, _("Could not query chart_master table"));
      $row = db_fetch($result);
      $acctype = $row['account_type'];
      $sql2 = "SELECT id, class_id FROM ".TB_PREF."chart_types WHERE ".$acctype." = id";
      $result2 = db_query($sql2, _("Could not query chart_types table"));
      $row2 = db_fetch($result2);
      $classid = $row2['class_id'];
                
      //if classid < 3 => asset or liability
      
      if ($classid > 2) {$ie = true;display_notification_centered(_("Correct: Tax type used with Income or expense:$code. (line $line in import file '{$_FILES['imp']['name']}')"));} else {$ie = false; display_notification_centered(_("Warning: Taxtype used with Asset or Liability.(line $line in import file '{$_FILES['imp']['name']}')"));}
           
    }
    return $ie;
}

function check_customer_supplier($code_id,$person_id,$person_type_id,$line,$memo,$error)
{
      if ($person_id = !null) 
     {
      //check that debtor or supplier exist
      if (($code_id==$_POST['debtors_act']) && ($person_type_id==2) && (customer_exist($person_id)==false)){display_notification_centered(_("Error: Customer does not exist. (line $line in import file '{$_FILES['imp']['name']}') "));$error=true;} 
      if (($code_id==$_POST['creditors_act']) && ($person_type_id==1) && (supplier_exist($person_id)==false)){display_notification_centered(_("Error: Supplier does not exist. (line $line in import file '{$_FILES['imp']['name']}') "));$error=true;} 
      //build a memo on current memo if entry line acceptable
      if (($code_id==$_POST['debtors_act']) && ($person_type_id==2) && (customer_exist($person_id)==true))
          {
             $memo = $memo." Customer name: ".customer_name($person_id)." id: ".$person_id;
          } 
      if (($code_id==$_POST['creditors_act']) && ($person_type_id==1) && (supplier_exist($person_id)==true))
          {
             $memo = $memo." Supplier name: ".supplier_name($person_id)." id: ".$person_id;
          }
     }      
      //check for default control accounts used without $person_id and $person_type_id 
      if (($code_id==$_POST['debtors_act']) && (($person_id==null) || ($person_type_id==null))){display_notification_centered(_("Error: Debtors Control account used without person_type_id or person_id. (line $line in import file '{$_FILES['imp']['name']}') "));$error=true;}   
      if (($code_id==$_POST['creditors_act']) && (($person_id==null) || ($person_type_id==null))){display_notification_centered(_("Error: Creditors Control account used without person_type_id or person_id. (line $line in import file '{$_FILES['imp']['name']}') "));$error=true;} 
    
return array($error,$memo);    
}
//csv_demo_line("Example Journal Dr:","this", "16/12/2014", $lastjlref, "8100", "D1", "D2", "222.24");
function csv_demo_line($param="",$count,$a,$b,$c,$d,$e,$f,$g,$h,$i,$j,$k,$l,$m) //utilized for displaying examples in a table
{
    start_row($param); // param usefull for incorporating css classes.
    label_cell($a,"width=3% wrap",$count+1);
    label_cell($b,"width=2% wrap",$count+2);
    label_cell($c,"width=2% wrap",$count+3);
    label_cell($d,"width=2% wrap",$count+4);
    label_cell($e,"width=2% wrap",$count+5);
    label_cell($f,"width=2% align=right wrap",$count+6);
    label_cell($g,"width=2% wrap",$count+7); 
    label_cell($h,"width=2% wrap",$count+8);
    label_cell($i,"width=2% wrap",$count+9);
    label_cell($j,"width=2% wrap",$count+10);
    label_cell($k,"width=2% wrap",$count+11);
    label_cell($l,"width=2% wrap",$count+12);
    label_cell($m,"width=2% wrap",$count+13);
    end_row();
}

function customer_exist($person_id)
{
    $sql= "SELECT debtor_no FROM ".TB_PREF."debtors_master WHERE debtor_no=".db_escape($person_id);
    $result = db_query($sql, _("Could not query debtors master table"));
    if (db_num_rows($result) > 0) {return true;} else {return false;}    
}

function customer_name($person_id)
{
    $sql= "SELECT name FROM ".TB_PREF."debtors_master WHERE debtor_no=".db_escape($person_id);
    $result = db_query($sql, _("Could not query debtors master table"));
    $row = db_fetch($result);
    $custname = $row['name']; 
    return $custname;
}

//if taxtype > 0 separate into inclusive, exclusive, and tax in preparation for gl split
function determinetax($taxtype,$amt)
{
      $initialamt = $amt;
      $sql = "SELECT * FROM ".TB_PREF."tax_types WHERE id=".db_escape($taxtype);
      $result = db_query($sql, _("Could not query tax type table"));
      $row = db_fetch($result);
      $taxper = $row['rate'];
      //determine the VAT accounts associated with the taxtype eg. standard VAT
      $salestaxaccount = $row['sales_gl_code'];
      $purchasetaxaccount = $row['purchasing_gl_code'];
      $taxamt = round(($amt/(1+($taxper/100))*($taxper/100)),2);
      if ($taxamt < 0){$taxaccount = $salestaxaccount;}else{$taxaccount = $purchasetaxaccount;}
      $inclusive_amt = round($amt,2);
      //get the exclusive value
      $amt=round($amt/(1+($taxper/100)),2);
      //avoid rounding issues with the following line
      $exclusive_amt = $inclusive_amt - $taxamt;
      return array($amt,$inclusive_amt,$exclusive_amt, $taxamt, $taxaccount, $salestaxaccount, $purchasetaxaccount);
}

function display_import_items($title, $order) //adapted from display_gl_items
{
 global $path_to_root;
 $displayed_at_least_once=false;
 display_heading($title);
 $dim = get_company_pref('use_dimension');
 div_start('items_table');
 start_table(TABLESTYLE2, "colspan=7 width=95%");
 if ($dim == 2)
 $th = array(_("Account Code"), _("Account Description"), _("Dimension")." 1",_("Dimension")." 2", _("Debit"), _("Credit"), _("Memo"),_("Jnl Entry"));

 else if ($dim == 1)$th = array(_("Account Code"), _("Account Description"), _("Dimension"),_("Debit"), _("Credit"), _("Memo"),_("Jnl Entry"));
 
 else $th = array(_("Account Code"), _("Account Description"),_("Debit"), _("Credit"), _("Memo"), _("Jnl Entry"));
  
 if (count($order->gl_items)) $th[] = '';
 table_header($th);	
$k = 0;
$id = find_submit('Edit');
$num = 0;
foreach ($order->gl_items as $line => $item) 
{
 if ($id != $line){
  $num=$num+1;   
  alt_table_row_color($k);
  label_cell($item->code_id, "width = 10%");
  label_cell($item->description,"width = 30%");
  if ($dim >= 1){label_cell(get_dimension_string($item->dimension_id, true),"wrap width = 10%");}
  if ($dim > 1){label_cell(get_dimension_string($item->dimension2_id, true),"wrap width = 10%");}
  if ($item->amount > 0) {
   amount_cell(abs($item->amount),null,"width=10%");
   label_cell("","width = 10%"); }
  //note: the $item->reference is carrying $memo for display purposes. 
  else {label_cell("","width = 10%");amount_cell(abs($item->amount),null,"width=10%");}label_cell($item->reference,"wrap align=left width=20%");label_cell($num,"width=5% align=right colspan=3");
  end_row();
 } 
}
if ($order->count_gl_items()) {
 $colspan = ($dim == 2 ? "4" : ($dim == 1 ? "3" : "2"));
 start_row();
 label_cell(_("Total"), "align=right colspan=" . $colspan);
 amount_cell($order->gl_items_total_debit());
 amount_cell(abs($order->gl_items_total_credit()));
 label_cell('', "colspan=4");
 end_row();
 $displayed_at_least_once = true;
 
}
end_table();
echo "<br>";
div_end();
return $displayed_at_least_once;
}// display import itemsmport items

function display_entries($type,$entry)
{
        if ($type == 0) $jname = "Journal Processing";
        if ($type == 1) $jname = "Payment Processing";
        if ($type == 2) $jname = "Deposit Processing";
        $title = $jname; 
        return $displayed_at_least_once = display_import_items(_("$title"), $entry);       
}        

function get_dimension_id_from_dimref($ref)
{
	if ($ref == null || trim($ref) == '')
		return 0;

        $sql = "SELECT id FROM ".TB_PREF."dimensions WHERE reference LIKE ".db_escape($ref);

	$result = db_query($sql, _("could not get dimension from reference"));

	$row = db_fetch_row($result);

	return $row[0];
}//function get_dimension_id_from_reference($ref)
//

//$entry or item_cart class merely used for tabular display of journal entries.
function init_entry_part_1($entry) 
{
	$entry->clear_items();
        //group all csv lines 'gl_items' under one entry
	$entry->order_id = 0;
}

function init_entry_part_2($entry,$date,$reference)
{        
	$entry->tran_date = $date;
	$entry->reference = $reference;
	$entry->memo_ = 'Imported via \'Import Multiple Journal Entries\' plugin';	
}
function import_type_list_row($label, $name, $selected=null, $submit_on_change=false)
{
    $arr = array(
    ST_JOURNAL=> _("Journal Processing"),
    ST_BANKDEPOSIT=> _("Deposit Processing"),
    ST_BANKPAYMENT=> _("Payment Processing")
    );
    //echo "<tr><td class='label'>$label</td><td>";
    echo "<tr><td class='label' colspan=1>$label</td><td>";
    echo array_selector($name, $selected, $arr, 
    array(
	'select_submit'=> $submit_on_change,
	'async' => false,
	));
    echo "</td></tr>\n";
}//function import_type_list_row($label, $name, $selected=null, $submit_on_change=false)

function initialize_controls()
{
    initialize_main_controls();
    initialize_tools_controls();    
}

function initialize_main_controls()
//initialize dropdown boxes
{
$myrow = get_company_prefs();    
if (!isset($_POST['debtors_act'])) $_POST['debtors_act']  = $myrow["debtors_act"];
if (!isset($_POST['creditors_act'])) $_POST['creditors_act']  = $myrow["creditors_act"];  
if (!isset($_POST['type'])) $_POST['type'] = null;
if (!isset($_POST['stateformat'])) {$stateformat = null;$_POST['stateformat']=null;}
if (!isset($_POST['tools'])) $_POST['tools']=null;
if (!isset($_POST['lookup'])) $_POST['lookup']=null;
if (!isset($_POST['notes'])) $_POST['notes']=null;
if (!isset($_POST['sep'])) $_POST['sep'] = ",";
if (!isset($_POST['bank_account'])) $_POST['bank_account'] = _("Current account");
if (!isset($_FILES['imp'])) $_FILES['imp'] = null;
if (!isset($_POST['trial'])) $_POST['trial'] = !null;
}

function initialize_tools_controls()
{
if (!isset($_POST['cust'])) $_POST['cust'] = null;
if (!isset($_POST['supp'])) $_POST['supp'] = null;
if (!isset($_POST['fis'])) $_POST['fis'] = null;
if (!isset($_POST['ttype'])) $_POST['ttype'] = null;
if (!isset($_POST['lookrefs'])) $_POST['lookrefs'] = _("Select a reference");
}


function journal_display($i,$type,$taxtype,$amt,$entry,$code_id, $dim1, $dim2, $memo, $description,$bank_account_gl_code,$bankdesc)
{
  if ($taxtype > 0) //tax inclusive
      {     
       list($return_amt, $inclusive_amt,$exclusive_amt,$taxamt,$taxaccount,$salestaxaccount, $purchasetaxaccount)=determinetax($taxtype,$amt); 
       $taxdesc = get_gl_account_name($taxaccount);
       if ($type == 0) //tax inclusive and journal line
          {
          $entry->gl_items[$i] = new gl_item($code_id, $dim1, $dim2, $exclusive_amt, $memo, $description);
          $i=$i+1;
          $entry->gl_items[$i] = new gl_item($taxaccount, $dim1, $dim2, $taxamt, $memo, $taxdesc); 
          }
       
       if ($type == 1) //tax inclusive and bank payment
          {
          $entry->gl_items[$i] = new gl_item($code_id, $dim1, $dim2, $exclusive_amt, $memo, $description);
          $i=$i+1;
          $entry->gl_items[$i] = new gl_item($taxaccount, $dim1, $dim2, $taxamt, $memo, $taxdesc);          
          $i=$i+1;
          $entry->gl_items[$i] = new gl_item($bank_account_gl_code, $dim1, $dim2, -$amt, $memo, $bankdesc);
          }
      
       if ($type == 2) //tax inclusive and bank deposit
          {
          $entry->gl_items[$i] = new gl_item($code_id, $dim1, $dim2, -$exclusive_amt, $memo, $description);
          $i=$i+1;
          $entry->gl_items[$i] = new gl_item($taxaccount, $dim1, $dim2, -$taxamt, $memo, $taxdesc);          
          $i=$i+1;
          $entry->gl_items[$i] = new gl_item($bank_account_gl_code, $dim1, $dim2, $amt, $memo, $bankdesc);
          }
      }   
      
       if ($taxtype == 0)
      {    
       if ($type == 0) //tax exclusive and journal line
          {
          $entry->gl_items[$i] = new gl_item($code_id, $dim1, $dim2, $amt, $memo, $description);
          }
       
       if ($type == 1) //tax exclusive and bank payment
          {
          $entry->gl_items[$i] = new gl_item($code_id, $dim1, $dim2, $amt, $memo, $description);
          $i=$i+1;
          $entry->gl_items[$i] = new gl_item($bank_account_gl_code, $dim1, $dim2, -$amt, $memo, $bankdesc);
          }
       
        if ($type == 2) //tax exclusive and bank deposit
          {
          $entry->gl_items[$i] = new gl_item($code_id, $dim1, $dim2, -$amt, $memo, $description);
          $i=$i+1;
          $entry->gl_items[$i] = new gl_item($bank_account_gl_code, $dim1, $dim2, $amt, $memo, $bankdesc);
          }
       } //if ($taxtype == 0)   
           
      $i=$i+1; 
      return $i;
    
}

function journal_inclusive_tax($type,$date, $line, $curEntryId, $code, $dim1, $dim2, $memo, $amt, $taxtype=null,$person_type_id,$person_id) // extra inclusive of tax column in csv
{
    list($return_amt,$inclusive_amt,$exclusive_amt,$taxamt,$taxaccount,$salestaxaccount,$purchasetaxaccount)=determinetax($taxtype, $amt);
    if (($taxtype > 0 ))  //amt inclusive of tax
    {
      add_gl_trans($type, $curEntryId, $date, $taxaccount, $dim1, $dim2 ,$memo, $taxamt, $currency=null, $person_type_id, $person_id, $err_msg="", $rate=0); //credit tax control account
      if ($return_amt<0){display_notification_centered(_("Added tax to table 'gl_trans' Credit: $curEntryId, $date, $taxaccount, $dim1, $dim2, $taxamt, $memo (line $line in import file '{$_FILES['imp']['name']}')"));}
      if ($return_amt>0){display_notification_centered(_("Added tax to table 'gl_trans' Debit: $curEntryId,$date, $taxaccount, $dim1, $dim2, $taxamt, $memo (line $line in import file '{$_FILES['imp']['name']}')"));}
      add_gl_tax_details($taxaccount, ST_JOURNAL, $curEntryId, $taxamt, 1, $date, $memo,1,$inclusive_amt);
    }
    add_gl_trans($type, $curEntryId, $date, $code, $dim1, $dim2 ,$memo, $exclusive_amt, $currency=null, $person_type_id,$person_id, $err_msg="", $rate=0);
    if ($return_amt >0){display_notification_centered(_("Added to table 'gl_trans' Debit: $curEntryId, $date, $code, $dim1, $dim2, $exclusive_amt, $memo (line $line in import file '{$_FILES['imp']['name']}')"));} 
    if ($return_amt <0){display_notification_centered(_("Added to table 'gl_trans' Credit: $curEntryId, $date, $code, $dim1, $dim2, $exclusive_amt, $memo (line $line in import file '{$_FILES['imp']['name']}')"));} 
}

function journal_id($prev_date,$date,$amt, $input_id, $total_debit_positive, $total_credit_negative, $line)
{
    $new_id = $input_id;
    $error=false;
    if ($amt > 0) {$total_debit_positive=$total_debit_positive+$amt;}
    if ($amt < 0) {$total_credit_negative=$total_credit_negative+(abs($amt));}   
    //as soon as debits equal credits create a new journal group id for the next journal line in the csv file
    //to be processed
    //the current csv line being processed will use the $new_id
    if (($total_debit_positive - $total_credit_negative) == 0)
      {
        if ($prev_date <> $date) {display_notification(_("Error: Dates do not correspond. (line $line in import file '{$_FILES['imp']['name']}')"));$error=true;}
        
        $total_debit_positive=0;
        $total_credit_negative=0;
        $input_id = $input_id + 1;
      }
    return array($error,$input_id, $new_id,$total_debit_positive,$total_credit_negative);
}

//Output the last transno for bank related transactions using table bank_trans.
//Output the last typeno for general ledger related transactions using table gl_trans.

function last_transno($type)
{
    //'get last row's typeno since type_no is the trans no'
    if ($type == ST_BANKDEPOSIT || $type == ST_BANKPAYMENT)
    {
        $sql = "SELECT id, type, trans_no, amount FROM ".TB_PREF."bank_trans ORDER BY id DESC LIMIT 1";
        $result = db_query($sql, _("Cannot locate last entry"));
        $row = mysql_fetch_assoc($result);
        $rowtrans = $row['trans_no'];        
    } // end if
    
    if ($type == ST_JOURNAL)
    {    
        $sql = "SELECT counter, type, type_no, amount FROM ".TB_PREF."gl_trans ORDER BY counter DESC LIMIT 1";
        $result = db_query($sql, _("Cannot locate last entry"));
        $row = mysql_fetch_assoc($result);
        $rowtrans = $row['type_no'];        
    } // end if
    return $rowtrans;//
}//function last_transno($type)

function processing($type,$errCnt,$entryCount,$displayed_at_least_once,$trial) //to be used
{
if ($type == ST_JOURNAL){$typeString = "Journals";}                
 elseif ($type == ST_BANKDEPOSIT){$typeString = "Deposits";}
 elseif ($type == ST_BANKPAYMENT){$typeString = "Payments";}
if (($errCnt==0) && ($trial == null))
 {if ($entryCount > 0){commit_transaction();display_notification_centered(_("$entryCount $typeString have been imported."));}
  else display_error(_("Import file contained no $typeString."));}
if (($errCnt==0) && ($trial == !null))
 {display_notification_centered(_("$entryCount $typeString would have been successful if imported. Uncheck Trial check before importing."));}
if (($errCnt>0) && ($trial == !null) && $displayed_at_least_once)
 {display_notification_centered(_("Errors detected. Correct before importing."));}
 if (($errCnt>0) && ($trial == null) && $displayed_at_least_once)
 {display_notification_centered(_("Errors detected. Correct before importing."));}   
 $errCnt =0;
}

function reference_type_list_cell($label, $name, $selected=null, $submit_on_change=false)
{
    global $systypes_array;
    $arr = $systypes_array; //sysnames.inc
    echo "<td class='label' colspan=1>$label</td><td>";
    echo array_selector($name, $selected, $arr, 
    array(
	'select_submit'=> $submit_on_change,
	'async' => false,
	));
    echo "</td>";
}   

function supplier_exist($person_id)
{
    $sql= "SELECT supplier_id FROM ".TB_PREF."suppliers WHERE supplier_id=".db_escape($person_id);
    $result = db_query($sql, _("Could not query debtors master table"));
    if (db_num_rows($result) > 0) {return true;} else {return false;} 
}//function supplier_exist($person_id)

function supplier_name($person_id)
{
    $sql= "SELECT supp_name FROM ".TB_PREF."suppliers WHERE supplier_id=".db_escape($person_id);
    $result = db_query($sql, _("could not query debtors master table"));
    $row = db_fetch($result);
    $suppname = $row['supp_name'];
    return $suppname;
}
//function supplier_name($person_id)

function show_table_section_bank_account_number()
{
    $bank = $_POST['bank_account'];
    $account = get_bank_gl_account($bank); 
    table_section_title(_("Bank Accounts"),2);
    label_row(_("Account number: "), $account,'colspan=1');
    
}
function show_table_section_company_settings_lookup()
{
    table_section_title(_("Lookup: Company Settings"),2);
    echo "<tr class='oddrow'>";gl_all_accounts_list_cells(_("General Ledger Account Lookup:"), false,false, false, false, _("All Accounts"),$submit_on_change=false);echo "</tr>";
    echo "<tr class='oddrow'>";fiscalyears_list_cells(_("Active Fiscal year(s):"),'fis',false);echo "</tr>";
    echo "<tr class='evenrow'>";dateformats_list_row(_("User selected Display format:"), "date_format", user_date_format());echo "</tr>";
    table_section_title("");
}

function show_table_section_csv_separator()
{
    table_section_title(_("CSV fields are separated by: "),2);
    text_cells(_("Field Separator:"), 'sep', $_POST['sep'], 2, 1,$title="",'colspan=1');
}
function show_table_section_control_accounts()
{
     table_section_title(_("Control Accounts"),2);
     echo "<tr>";gl_all_accounts_list_cells(_("Receivable Account / Debtors Control account Default:"), 'debtors_act',$_POST['debtors_act']);echo "</tr>";
     echo "<tr>";gl_all_accounts_list_cells(_("Payable Account / Creditors Control account Default:"), 'creditors_act',$_POST['creditors_act']);echo "</tr>";
}
function show_table_section_display($type)
{
    global $Ajax;
    table_section_title(_("Display"),2);
    checkbox_row(_("Lookup id's for Tax Type, Customers, and Suppliers"), 'tools', $_POST['tools'], $submit_on_change=true,$title="",'colspan=1');
    if ((isset($_POST['tools'])) && ($_POST['tools'] !=null)) {show_table_section_tools();} else $Ajax->activate('_page_body');
    checkbox_row(_("Display Company Settings Lookup"), 'lookup', $_POST['lookup'], $submit_on_change=true,$title="",'colspan=1');
    if ((isset($_POST['lookup'])) && ($_POST['lookup'] !=null)) {show_table_section_company_settings_lookup();} else $Ajax->activate('_page_body');
    checkbox_row(_("Display Help Notes"), 'notes', $_POST['notes'], $submit_on_change=true,$title="",'colspan=1');
    if ((isset($_POST['notes'])) && ($_POST['notes'] !=null)) {show_table_section_notes($type);} else $Ajax->activate('_page_body'); 
 
}

function show_table_section_import_settings()
{
    table_section_title(_("Import Settings"),2);
    import_type_list_row(_("Import Type:"), 'type', $_POST['type'], true);
    if ($_POST['type'] != ST_JOURNAL)
     {bank_accounts_list_cells( $_POST['type'] == ST_BANKPAYMENT ? _("From:") : _("To:"), 'bank_account',$selected_id="",$_POST['bank_account']);
      show_table_section_bank_account_number();
     }
    return $type = $_POST['type'];
}
function show_table_section_important_bank()
{
    table_section_title(_("Display Help Notes: Important regarding bank transactions"),2);
    label_row(_("1.No negative amounts. Payment amounts are converted to negative amounts for the table 'bank_trans' which represent credit amounts."),"",'colspan=1');
    label_row(_("2.Tax inclusive expenses (eg.rent) or tax inclusive income (eg. sales) must include a taxtype if a company is registered for VAT."),"",'colspan=1');
    label_row(_("3.Dim1_ref is a description for the dimension id. "),"",'colspan=1');
    label_row(_("4.Non-essential fields: dim1_ref, dim2_ref. Include as column headers in csv even if not used."),"",'colspan=1');
    label_row(_("5.The reference field is stored in a separate database 'refs' and should be unique to every transaction."),"",'colspan=1');
    label_row(_("6. Ensure that your csv file date format includes a 4 number year ie. YYYY. Use a low-level format editor to confirm this since format can be lost when saving to csv format. So check your csv with Notepad+ for a four digit year."),"",'colspan=1');
    label_row(_("7. Ensure that 'Account code' in your spreadsheet is in text format since eg. 0010 will lose its zeros in number format when saving to csv."),"",'colspan=1');
    label_row(_("8. Template: <a href='./templates/payment_en_GB.csv'>payment_en_GB.csv using British Chart of Accounts</a> for Payment only processing. Template: <a href='./templates/deposit_en_GB.csv'>deposit_en_GB.csv using British Chart of Accounts </a> for Deposit only processing.  Template: <a href='./templates/bank_en_GB.csv'>bank_en_GB.csv using British Chart of Accounts</a> for Bank Statement format processing."),"",'colspan=1');    
}

function show_table_section_important_journals()
{
    table_section_title(_("Display Help Notes: Important regarding Journals"),2);
    label_row(_("1. Credit amounts must be shown with a negative amount."),"",'colspan=1');        
    label_row(_("2. Tax inclusive expenses (eg.rent) or tax inclusive income (eg. sales) must include a taxtype, normally 1, if a company is registered for VAT and has set up various tax types."),"",'colspan=1');
    label_row(_("3. No bank transactions are to be processed through the journal. Use 'Deposit Processing' or 'Payment Processing' for this purpose."),"",'colspan=1');
    label_row(_("4. Ensure that your csv file date format eg. DD/MM/YYYY includes a 4 number year ie. YYYY, and it complies with your User selected date format, eg. DDMMYYYY as indicated above under tools. Do this preferably with a low-level format editor since format can be lost when converting to csv from a spreadsheet package. So check your csv with Notepad+ for a four digit year."),"",'colspan=1');
    label_row(_("5. Ensure that 'Account code' in your spreadsheet is in text format since eg. 0010 will lose its zeros in number format when saving to csv."),"",'colspan=1');
    label_row(_("6. Template: <a href='./templates/journal_en_GB.csv'>journal_en_GB.csv using British Chart of Accounts</a>"),"",'colspan=1');
    label_row(_("7. The correct debtors control account (eg. 1100) or creditors control account (eg. 2100) should be used with Person_type_id and Person_id. Use 'Display Tax Type, Customers, and Suppliers' to check Person_type_id and Person_id."),"",'colspan=1');
}

function show_table_section_notes($type)
{
    if ($type == 0)
    {
        show_table_section_important_journals();   
    }
    else
    {
        show_table_section_important_bank();
    }    
}


function show_table_section_tools()
{
    table_section_title(_("Lookup: Tax Type, Customers, and Suppliers"),2);
    echo "<tr class='evenrow'>";tax_types_list_cells(_("Tax Type:"),'ttype',$_POST['ttype'],_("All Tax types"),$submit_on_change=true);echo "</tr>";
    $ttype=$_POST['ttype'];
    if ($ttype==-1) $ttype=null;
    echo "<tr class='oddrow'>";label_cell(_("Taxtype id:"),'colspan=1');label_cell($ttype,'colspan=1 align=right width=20px');echo "</tr>";
    echo "<tr class='evenrow'>";customer_list_cells(_("Customer:"),'cust',$_POST['cust'],_("All Customers"),true);echo "</tr>";
    $cust=$_POST['cust'];
    echo "<tr class='oddrow'>";label_cell(_("Person_id:"),'colspan=1');label_cell($cust,'colspan=1 align=right width=20px');echo "</tr>";
    echo "<tr class='evenrow'>";supplier_list_cells(_("Supplier:"),'supp',$_POST['supp'],_("All Suppliers"),true);echo "</tr>";
    $supp=$_POST['supp'];
    echo "<tr class='oddrow'>";label_cell(_("Person_id:"),'colspan=1');label_cell($supp,'colspan=1 align=right width=20px');echo "</tr>";
    table_section_title("");
}

function show_table_section_trial_or_final()
{
    table_section_title(_("Trial-run (tick) or Final-run (no tick)"),2);
    check_row(_("Trial-run before importing. Do NOT process into database."), 'trial', $_POST['trial']=!null, $submit_on_change = false,$title="");
    label_row(_("Import File:"), "<input type='file' id='imp' name='imp'>",'colspan=1');
 }

function show_table_section_bankstatement_checkbox()
{
    $bs = array(    _("First amount column (col D) in csv = Payments"),
                    _("Second amount column (col E) in csv = Deposits"),
                    _("The same csv file should be used for both 'Payment' and 'Deposit' processing."),
                    _("When you select 'Deposit Processing' then all csv lines with an amount in the Payments column D will be ignored."),
                    _("When you select 'Payment Processing' then all csv lines with an amount in the Deposits column E will be ignored."),
                    _("Typically you will import a Bank statement in csv format from your bank and adjust it according to required columns."),
                    _("Bank statement = columns B,C,D,E"),
                    _("Add columns A (reference), and columns F,G,H,I,J,K. See template."),
                    _("You will need to process bank.csv twice. Once with 'Payment Processing', next with 'Deposit Processing'"),
                    _("Template <a href='./templates/bank_en_GB.csv'>bank_en_GB.csv</a>."));
    table_section_title(_("Bank Statement Format"),2);
    checkbox_row($bs, 'stateformat', $_POST['stateformat'], false, $title = "", 'colspan=1 wrap align=left');
    return $stateformat = $_POST['stateformat'];
}
?>
