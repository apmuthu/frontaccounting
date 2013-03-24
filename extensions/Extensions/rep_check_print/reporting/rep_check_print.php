<?php
/**********************************************************************
    Copyright (C) FrontAccounting, LLC.
	Released under the terms of the GNU General Public License, GPL, 
	as published by the Free Software Foundation, either version 3 
	of the License, or (at your option) any later version.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
    See the License here <http://www.gnu.org/licenses/gpl-3.0.html>.
***********************************************************************/
$page_security = $_POST['PARAM_0'] == $_POST['PARAM_1'] ?
	'SA_SUPPTRANSVIEW' : 'SA_SUPPBULKREP';
// ----------------------------------------------------------------
// $ Revision:	2.2 $
// Creator:	Joe Hunt - Based on the new Report Engine by Tom Hallman
// Creator:	Based on Tom Hallman's Report.
// Date:	2010-03-03
// Title:	Printable Check
// ----------------------------------------------------------------
$path_to_root="..";

include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/data_checks.inc");

//----------------------------------------------------------------------------------------------------

print_check();

//----------------------------------------------------------------------------------------------------
function get_remittance($type, $trans_no)
{
   	$sql = "SELECT ".TB_PREF."supp_trans.*, 
   		(".TB_PREF."supp_trans.ov_amount+".TB_PREF."supp_trans.ov_gst+".TB_PREF."supp_trans.ov_discount) AS Total, 
   		".TB_PREF."suppliers.supp_name,  ".TB_PREF."suppliers.supp_account_no,
   		".TB_PREF."suppliers.curr_code, ".TB_PREF."suppliers.payment_terms, ".TB_PREF."suppliers.gst_no AS tax_id, 
   		".TB_PREF."suppliers.address, ".TB_PREF."suppliers.contact
		FROM ".TB_PREF."supp_trans, ".TB_PREF."suppliers
		WHERE ".TB_PREF."supp_trans.supplier_id = ".TB_PREF."suppliers.supplier_id
		AND ".TB_PREF."supp_trans.type = ".db_escape($type)."
		AND ".TB_PREF."supp_trans.trans_no = ".db_escape($trans_no);
   	$result = db_query($sql, "The remittance cannot be retrieved");
   	if (db_num_rows($result) == 0)
   		return false;
    return db_fetch($result);
}

function get_allocations_for_remittance($supplier_id, $type, $trans_no)
{
	$sql = get_alloc_supp_sql("amt, supp_reference, trans.alloc", "trans.trans_no = alloc.trans_no_to
		AND trans.type = alloc.trans_type_to
		AND alloc.trans_no_from=".db_escape($trans_no)."
		AND alloc.trans_type_from=".db_escape($type)."
		AND trans.supplier_id=".db_escape($supplier_id),
		TB_PREF."supp_allocations as alloc");
	$sql .= " ORDER BY trans_no";
	return db_query($sql, "Cannot retreive alloc to transactions");
}


//----------------------------------------------------------------------------------------------------

function print_check()
{
    global $path_to_root, $systypes_array, $print_invoice_no;

    // Get the payment
    $from = $_POST['PARAM_0'];
    $destination = $_POST['PARAM_1'];
 	
 	$trans_no = explode("-", $from);

	$dec = user_price_dec();
	if ($destination)
		include_once($path_to_root . "/reporting/includes/excel_report.inc");
	else
		include_once($path_to_root . "/reporting/includes/pdf_report.inc");
    
	$from_trans = get_remittance($trans_no[1], $trans_no[0]);

    // Get check information
    $total_amt = $from_trans['Total'];
    
    $date = sql2date($from_trans['tran_date']);
    $memo = get_comments_string($trans_no[1], $trans_no[0]);
    
    // Begin the report
    $rep = new FrontReport(_('Printable Check'), "PrintableCheck", user_pagesize());
	$rep->SetHeaderType(null);    
    $rep->NewPage();
    // Set the font
    $rep->Font('','courier');
    $rep->fontSize = 12;
   
    //////////////////
    // Check portion
    
    $rep->NewLine(1,0,76);
    $rep->cols = array(63, 340, 470, 565);
    $rep->aligns = array('left', 'left', 'right', 'right');
    
    // Pay to    
    $rep->TextCol(0, 1, $from_trans['supp_name']);
    
    // Date
    $rep->DateCol(1, 2, $rep->DatePrettyPrint($date, 0, 0));
    
    // Amount (numeric)
    $rep->TextCol(2, 3, '***'.number_format2(-$total_amt, $dec));
    
    // Amount (words)
    $rep->NewLine(1,0,23);
    $rep->TextCol(0, 2, $from_trans['curr_code'].": ". price_in_words(-$total_amt, ST_CHEQUE));
    
    // Memo
    $rep->NewLine(1,0,78);
    $rep->TextCol(0, 1, $memo);

  	$rep->company = get_company_prefs();
  /////////////////////
    // Item details x 2 
    
    for ($section=1; $section<=2; $section++) 
    {
        $rep->fontSize = 12;        
        // Move down to the correct section
        $rep->row = $section == 1 ? 505 : 255;
        $rep->cols = array(20, 340, 470, 588);
        $rep->aligns = array('left', 'left', 'right', 'right');
        
        // Pay to
        $rep->Font('b');
        $rep->TextCol(0, 1, $from_trans['supp_name']);
        $rep->Font();
        
        // Date
        $rep->DateCol(1, 2, $rep->DatePrettyPrint($date, 0, 0));
        
        // Amount (numeric)
        $rep->TextCol(2, 3, number_format2(-$total_amt, 2));
    
        // Add Trans # + Reference
        $rep->NewLine();
        if ($print_invoice_no == 0)
        	$tno = $from_trans['reference'];
        else
        	$tno = $from_trans['trans_no'];
        $rep->TextCol(0, 3, sprintf( _("Payment # %s - from Customer: %s - %s"), $tno,
        	$from_trans['supp_account_no'], $rep->company['coy_name']));
        
        // Add memo
        $rep->NewLine();
        $rep->TextCol(0, 3, _("Memo: ").$memo);    
        
        // TODO: Do we want to set a limit on # of item details?  (Max is probably 6-7)

        // Get item details
		$result = get_allocations_for_remittance($from_trans['supplier_id'], $from_trans['type'], $from_trans['trans_no']);
        // Fill in details
        $rep->NewLine(2);
        $rep->fontSize = 10;
        // Use different columns now for the additional info
        $rep->cols = array(20, 160, 235, 290, 370, 480, 588);
        $rep->aligns = array('left', 'left', 'left', 'right', 'right', 'right');
        
        // Add headers
        $rep->Font('b');
        $rep->TextCol(0, 1, _("Type/Id"));
        $rep->TextCol(1, 2, _("Trans Date"));
        $rep->TextCol(2, 3, _("Due Date"));
        $rep->TextCol(3, 4, _("Total Amount"));
        $rep->TextCol(4, 5, _("Left to Allocate"));
        $rep->TextCol(5, 6, _("This Allocation"));
        $rep->NewLine();
        
        $rep->Font();    
		$total_allocated = 0;
		while ($item=db_fetch($result))
		{
           	$rep->TextCol(0, 1, $systypes_array[$item['type']]." ".$item['supp_reference']);
           	$rep->TextCol(1, 2, sql2date($item['tran_date']));
           	$rep->TextCol(2, 3, sql2date($item['due_date']));
           	$rep->AmountCol(3, 4, $item['Total'], $dec);
           	$rep->AmountCol(4, 5, $item['Total'] - $item['alloc'], $dec);
           	$rep->AmountCol(5, 6, $item['amt'], $dec);
           	$total_allocated += $item['amt'];
       		$rep->NewLine(1, 0, $rep->lineHeight + 3); // Space it out
    	}
    	$rep->NewLine();
       	$rep->TextCol(4, 5, _("Total Allocated"));
       	$rep->AmountCol(5, 6, $total_allocated, $dec);
    	$rep->NewLine();
       	$rep->TextCol(4, 5, _("Left to Allocate"));
       	$rep->AmountCol(5, 6, -$from_trans['Total'] - $total_allocated, $dec);
    	
    } // end of section
    
    $rep->End();
}

//--------------------------------------------------------------------------------


?>