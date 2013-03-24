<?php

$page_security = 'SA_SUPPBULKREP';
// ----------------------------------------------------------------
// $ Revision:	1.0 $
// Creator:	Tu Nguyen/Joe Hunt
// date_:	2010-03-04
// Title:	Print CPA Cheques (Canadian Pre-printed Standard)
// ----------------------------------------------------------------

$path_to_root="..";

include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/data_checks.inc");

// Get Cheque Number to display
$checkinput = $_POST['PARAM_0'];
$from = $_POST['PARAM_1'];
$trans_no = explode("-", $from);

include_once($path_to_root . "/reporting/includes/pdf_report.inc");

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

// Grab Cheque Information

$from_trans = get_remittance($trans_no[1], $trans_no[0]);

$company_currency = get_company_currency();

$show_currencies = false;
$show_both_amounts = false;

$show_currencies = ($from_trans['curr_code'] != $company_currency);

$cheque = new FrontReport(_("Cheque Printing"), "cheque.pdf", user_pagesize(), 10);
$cheque->SetHeaderType(null); 
$cheque->NewPage();
$cheque->Font();
$cheque->lineHeight = 16;

$cheque->row = $cheque->pageHeight - $cheque->topMargin;

$cheque->row -= 47;
//------------------------ col - row - spec's ------------
$col0 				= 45;		// the first column
$col1 				= 248;
$col3 				= 480;
$col4 				= 380;
$col5 				= 455;
$col6 				= 145;
$col_right = $cheque->pageWidth - $cheque->rightMargin;
$width_col0 = $col_right - $col0;
$width_col1 = $col_right - $col1;
$width_col3 = $col_right - $col3;
$width_col4 = $col_right - $col4;
$width_col5 = $col_right - $col5;
$width_normal 		= 200;

$row_address		= $cheque->pageHeight - 177;
$row_first_stub 	= $row_address - 149; 	// first spec. for the payment
$row_second_stub 	= $row_address - 380; 	// second spec. for the payment

$gap 				= 15; 	// space between the spaced date and spec
//-------------------------------------------------------
if ($checkinput != "")
{
	$cheque->TextWrap($col4, $cheque->row, $width_normal, $cheque->title);
	$cheque->TextWrap($col4, $cheque->row, $width_col4, $checkinput, "right");
}
$cheque->NewLine();

$cheque->TextWrap($col4, $cheque->row, 50, _("DATE"));

$cdate = sql2checkdate($from_trans['tran_date']);
$ddate = "DDMMYYYY";

for ($i = 0, $col = $col5; $i < 8; $col += $gap, $i++)
	$cheque->TextWrap($col, $cheque->row, $gap - 1, $cdate[$i]);

$cheque->lineHeight = 12;
$cheque->NewLine();
for ($i = 0, $col = $col5; $i < 8; $col += $gap, $i++)
	$cheque->TextWrap($col, $cheque->row, $gap - 1, $ddate[$i]);

$cheque->lineHeight = 22;
$cheque->NewLine();
$amt_total = -$from_trans['Total'];
$dec = user_price_dec();

$amount = "**".price_in_words($amt_total, ST_CHEQUE);
$themoney = ($show_currencies ? $from_trans['curr_code'] : '').'**'.number_format2($amt_total, $dec);

$cheque->TextWrap($col0, $cheque->row, $width_col0, $amount);

$cheque->TextWrap($col0, $cheque->row, $width_col0, $themoney, "right");
$cheque->lineHeight = 13;
$cheque->NewLine();
if ($show_currencies)
	$cheque->TextWrap($col0, $cheque->row, $width_col0, _("Amount in ").$from_trans['curr_code']);

$cheque->row = $row_address;
$cheque->lineHeight = 12;
$cheque->TextWrapLines($col0, $width_col0, $from_trans['supp_name'] . "\n" .$from_trans['address']);

$dotadd = 40;

$cheque->lineHeight = 16;

for ($i = 0; $i < 2; $i++)
{
	// First Stub
	$cheque->row = ($i == 0 ? $row_first_stub : $row_second_stub);

	$cheque->TextWrap($col0, $cheque->row, $width_col0, $from_trans['supp_name']);
	$cheque->TextWrap($col1, $cheque->row, $width_col1, sql2date($from_trans['tran_date']));
	if ($checkinput != "")
		$cheque->TextWrap($col3, $cheque->row, 93, $checkinput);

	$cheque->NewLine();

	// Get allocations (shows supplier references on invoices and its amount) (Two columns).
	$result = get_allocations_for_remittance($from_trans['supplier_id'], $from_trans['type'], $from_trans['trans_no']);
	$totalallocated = 0;
	$totallines = 0;
	while ($alloc_row = db_fetch($result))
	{
		$theamout = number_format2($alloc_row['amt'], $dec);
		$cheque->TextWrap($col0, $cheque->row, 100, $alloc_row['supp_reference'] . " " . str_repeat('.',$dotadd));
		$tcol = $col6;
		$cheque->TextWrap($tcol, $cheque->row, 50, number_format2($alloc_row['amt'], $dec), "right");
		if ($show_currencies)
			$cheque->TextWrap($tcol += 55, $cheque->row, 50, $from_trans['curr_code']);
		if ($alloc_row['Total'] != $alloc_row['amt'])
			$cheque->TextWrap($tcol += 55, $cheque->row, $width_normal, _(" (Left to allocate ").
				number_format2($alloc_row['Total'] - $alloc_row['amt'], $dec).")");
		$totalallocated += $alloc_row['amt'];
		$totallines++;
		$cheque->lineHeight = 12;
		$cheque->NewLine();
	}
	if ($totalallocated < $amt_total)
	{
		$cheque->NewLine();
		$cheque->TextWrap($col0, $cheque->row, 200, _("Unallocated amount: ").number_format2($amt_total - $totalallocated, $dec));
		$cheque->NewLine();
	}
	$cheque->lineHeight = 16;
}
$cheque->End();

function sql2checkdate($date_)
{
	global $date_system;

	//for MySQL dates are in the format YYYY-mm-dd
	if ($date_ == null || strlen($date_) == 0)
		return "";

	if (strpos($date_, "/"))
	{ // In MySQL it could be either / or -
		list($year, $month, $day) = explode("/", $date_);
	}
	elseif (strpos ($date_, "-"))
	{
		list($year, $month, $day) = explode("-", $date_);
	}

	if (strlen($day) > 4)
	{  /*chop off the time stuff */
		$day = substr($day, 0, 2);
	}
	if ($date_system == 1)
		list($year, $month, $day) = gregorian_to_jalali($year, $month, $day);
	elseif ($date_system == 2)
		list($year, $month, $day) = gregorian_to_islamic($year, $month, $day);

	return $day.$month.$year;
}

?>