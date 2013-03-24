<?php
// ----------------------------------------------------------------
// $ Revision:  1.0 $
// Creator: Alastair Robertson
// date_:   2011-10-22
// Title:   Tax Details (Cash Basis)
// Free software under GNU GPL
// ----------------------------------------------------------------
$page_security = 'SA_BANKREP';
$path_to_root="..";

include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/data_checks.inc");
include_once($path_to_root . "/modules/rep_tax_cash_basis/includes/tax_cash_db.inc");

//----------------------------------------------------------------------------------------------------

print_tax_details_cash();

//----------------------------------------------------------------------------------------------------

function print_tax_details_cash()
{
	global $path_to_root, $systypes_array;

	$from = $_POST['PARAM_0'];
	$to = $_POST['PARAM_1'];
    $net = $_POST['PARAM_2'];
    $comments = $_POST['PARAM_3'];
    $destination = $_POST['PARAM_4'];
	if ($destination)
		include_once($path_to_root . "/reporting/includes/excel_report.inc");
	else
		include_once($path_to_root . "/reporting/includes/pdf_report.inc");

	$rep = new FrontReport(_('Tax Details (Cash Basis)'), "TaxDetails", user_pagesize(), 9, "L");
	$dec = user_price_dec();

	$cols = array(0, 100, 170, 250, 310, 485, 550, 700);

	$aligns = array('left',	'left', 'left',	'left',	'left',	'right', 'right');

    if (!$net) {
        $grossAmount =  _('Gross');
    } else { 
        $grossAmount =  _('Net');
    }
	
    $headers = array(_('Type'),	_('Ref'), _('#'),_('Date'), _('Payer/Payee'),
          _('Tax Amount'), $grossAmount.' '._('Output/Input'));

    if (!$net)
        $grossAmount = _('Gross Amounts');
    else
        $grossAmount = _('Net Amounts');
		
    $params =   array( 	0 => $comments,
	    1 => array('text' => _('Period'), 'from' => $from, 'to' => $to),
        2 => array('text' => _('Output/input'), 'from' => $grossAmount, 'to' => ''));

	$rep->Font();
	$rep->Info($params, $cols, $headers, $aligns);
	$rep->NewPage();

	$trans = get_tax_cash_details($from, $to);

	$rows = db_num_rows($trans);
	$rep->Font();
	if ($rows > 0)
	{
		// Keep a running total as we loop through
		// the transactions.
        $subTotalTax = 0;
        $subTotalGross = 0;
        $total = 0;		
		$lastTaxType = '';	
		$lastOutput = '';
		$lastRate = 0;
		
		while ($myrow=db_fetch($trans))
		{
		    $taxType = $myrow["name"];
		    $output = $myrow["Output"];
            if ($taxType != $lastTaxType || $output != $lastOutput) {
                if ($lastTaxType != '') {
                    print_tax_details_cash_subtotals($rep, $lastOutput, $lastTaxType, $lastRate,  $subTotalTax, $subTotalGross);
                }
                $lastOutput = $output;
                $lastTaxType = $taxType;
                $lastRate = $myrow['rate'];
                $subTotalTax = 0;
                $subTotalGross = 0;
            }

            $rep->TextCol(0, 1, $systypes_array[$myrow["type"]], -2);
            $reference = get_reference($myrow["type"], $myrow["trans_no"]);
            $rep->TextCol(1, 2, $reference);
            $rep->TextCol(2, 3, $myrow["trans_no"]);
            $rep->DateCol(3, 4,	$myrow["trans_date"], true);
			$rep->TextCol(4, 5,	payment_person_name($myrow["person_type_id"],$myrow["person_id"], false));
            if ($output == "Output") {
                $payable = $myrow['payable'];
                if (!$net) {
                    $amount = $myrow['gross_output'];
                } else {
                    $amount = $myrow['net_output'];
                }
                $rep->AmountCol(5, 6, $payable, $dec);
                $subTotalTax += $payable;
                $total += $payable;
                $rep->AmountCol(6, 7, $amount, $dec);
                $subTotalGross += $amount;
            } else {
                $collectible = $myrow['collectible'];
                if (!$net) {
                    $amount = $myrow['gross_input'];
                } else {
                    $amount = $myrow['net_input'];
                }
                $rep->AmountCol(5, 6, $collectible, $dec);
                $subTotalTax += $collectible;
                $total += $collectible;
                $rep->AmountCol(6, 7, $amount, $dec);
                $subTotalGross += $amount;
            }
			$rep->NewLine();
			if ($rep->row < $rep->bottomMargin + $rep->lineHeight)
			{
				$rep->Line($rep->row - 2);
				$rep->NewPage();
			}            
		}
		
		// Print totals 
        print_tax_details_cash_subtotals($rep, $lastOutput, $lastTaxType, $lastRate,  $subTotalTax, $subTotalGross);
            
		$rep->Font('bold');
		$rep->TextCol(4, 5, _("Total Payable or Refund"));
		$rep->AmountCol(5, 6, $total, $dec);
		$rep->NewLine(2);

		$rep->Font();
		$rep->NewLine(2);	
		
	}
	$rep->End();
}

function print_tax_details_cash_subtotals($rep, $lastOutput, $lastTaxType, $lastRate,  $subTotalTax, $subTotalGross) 
{
    global $path_to_root, $systypes_array;
    $dec = user_price_dec();
    
    $rep->Font('bold');
    $rep->TextCol(0, 1, $lastTaxType . " " . $lastRate . "%");
    if ($lastOutput == "Output") {
        $rep->TextCol(1, 3, _("Charged on sales") . " (" . _("Output Tax")."):");
    } else {
        $rep->TextCol(1, 3,_("Paid on purchases") . " (" . _("Input Tax")."):");
    }
    $rep->AmountCol(5, 6, $subTotalTax, $dec);
    $rep->AmountCol(6, 7, $subTotalGross, $dec);
    $rep->Line($rep->row - $rep->lineHeight + 4);
    $rep->NewLine(2);
    $rep->Font();
}

?>