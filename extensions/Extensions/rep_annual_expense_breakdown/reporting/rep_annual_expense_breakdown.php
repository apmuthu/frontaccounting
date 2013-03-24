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
$page_security = 'SA_GLANALYTIC';
// ----------------------------------------------------------------
// $ Revision:	2.2 $
// Creator:	Joe Hunt - Based on the new Report Engine by Tom Hallman
// Creator:	Chaitanya for the recursive version 2009-02-05.
// Date:	2009-12-22
// Title:	Annual expense breakdown - detail
// ----------------------------------------------------------------
$path_to_root="..";

include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/data_checks.inc");
include_once($path_to_root . "/gl/includes/gl_db.inc");

//----------------------------------------------------------------------------------------------------

print_annual_expense_breakdown_detail();

//----------------------------------------------------------------------------------------------------

function getPeriods($yr, $mo, $account, $dimension, $dimension2, $balance=false)
{
	$begin = date2sql(begin_fiscalyear());
	$date13 = date('Y-m-d',mktime(0,0,0,$mo+12,1,$yr));
	$date12 = date('Y-m-d',mktime(0,0,0,$mo+11,1,$yr));
	$date11 = date('Y-m-d',mktime(0,0,0,$mo+10,1,$yr));
	$date10 = date('Y-m-d',mktime(0,0,0,$mo+9,1,$yr));
	$date09 = date('Y-m-d',mktime(0,0,0,$mo+8,1,$yr));
	$date08 = date('Y-m-d',mktime(0,0,0,$mo+7,1,$yr));
	$date07 = date('Y-m-d',mktime(0,0,0,$mo+6,1,$yr));
	$date06 = date('Y-m-d',mktime(0,0,0,$mo+5,1,$yr));
	$date05 = date('Y-m-d',mktime(0,0,0,$mo+4,1,$yr));
	$date04 = date('Y-m-d',mktime(0,0,0,$mo+3,1,$yr));
	$date03 = date('Y-m-d',mktime(0,0,0,$mo+2,1,$yr));
	$date02 = date('Y-m-d',mktime(0,0,0,$mo+1,1,$yr));
	$date01 = date('Y-m-d',mktime(0,0,0,$mo,1,$yr));

	if (!$balance)
	{
  	  	$sql = "SELECT SUM(CASE WHEN tran_date >= '$date01' AND tran_date < '$date02' THEN amount ELSE 0 END) AS per01,
		   		SUM(CASE WHEN tran_date >= '$date02' AND tran_date < '$date03' THEN amount ELSE 0 END) AS per02,
		   		SUM(CASE WHEN tran_date >= '$date03' AND tran_date < '$date04' THEN amount ELSE 0 END) AS per03,
		   		SUM(CASE WHEN tran_date >= '$date04' AND tran_date < '$date05' THEN amount ELSE 0 END) AS per04,
		   		SUM(CASE WHEN tran_date >= '$date05' AND tran_date < '$date06' THEN amount ELSE 0 END) AS per05,
		   		SUM(CASE WHEN tran_date >= '$date06' AND tran_date < '$date07' THEN amount ELSE 0 END) AS per06,
		   		SUM(CASE WHEN tran_date >= '$date07' AND tran_date < '$date08' THEN amount ELSE 0 END) AS per07,
		   		SUM(CASE WHEN tran_date >= '$date08' AND tran_date < '$date09' THEN amount ELSE 0 END) AS per08,
		   		SUM(CASE WHEN tran_date >= '$date09' AND tran_date < '$date10' THEN amount ELSE 0 END) AS per09,
		   		SUM(CASE WHEN tran_date >= '$date10' AND tran_date < '$date11' THEN amount ELSE 0 END) AS per10,
		   		SUM(CASE WHEN tran_date >= '$date11' AND tran_date < '$date12' THEN amount ELSE 0 END) AS per11,
		   		SUM(CASE WHEN tran_date >= '$date12' AND tran_date < '$date13' THEN amount ELSE 0 END) AS per12,
		   		SUM(CASE WHEN tran_date >= '$begin' AND tran_date < '$date13' THEN amount ELSE 0 END) AS ytd,
		   		SUM(CASE WHEN tran_date >= '$date01' AND tran_date < '$date13' THEN amount ELSE 0 END) AS mon12
    			FROM ".TB_PREF."gl_trans
				WHERE account='$account'";
	}
	else
	{
  	  	$sql = "SELECT SUM(CASE WHEN tran_date < '$date02' THEN amount ELSE 0 END) AS per01,
		   		SUM(CASE WHEN tran_date < '$date03' THEN amount ELSE 0 END) AS per02,
		   		SUM(CASE WHEN tran_date < '$date04' THEN amount ELSE 0 END) AS per03,
		   		SUM(CASE WHEN tran_date < '$date05' THEN amount ELSE 0 END) AS per04,
		   		SUM(CASE WHEN tran_date < '$date06' THEN amount ELSE 0 END) AS per05,
		   		SUM(CASE WHEN tran_date < '$date07' THEN amount ELSE 0 END) AS per06,
		   		SUM(CASE WHEN tran_date < '$date08' THEN amount ELSE 0 END) AS per07,
		   		SUM(CASE WHEN tran_date < '$date09' THEN amount ELSE 0 END) AS per08,
		   		SUM(CASE WHEN tran_date < '$date10' THEN amount ELSE 0 END) AS per09,
		   		SUM(CASE WHEN tran_date < '$date11' THEN amount ELSE 0 END) AS per10,
		   		SUM(CASE WHEN tran_date < '$date12' THEN amount ELSE 0 END) AS per11,
		   		SUM(CASE WHEN tran_date < '$date13' THEN amount ELSE 0 END) AS per12
    			FROM ".TB_PREF."gl_trans
				WHERE account='$account'";
	}
	if ($dimension != 0)
  		$sql .= " AND dimension_id = ".($dimension<0?0:db_escape($dimension));
	if ($dimension2 != 0)
  		$sql .= " AND dimension2_id = ".($dimension2<0?0:db_escape($dimension2));

	$result = db_query($sql, "Transactions for account $account could not be calculated");

	return db_fetch($result);
}


function display_type ($type, $typename, $yr, $mo, $convert, &$dec, &$rep, $dimension, $dimension2)
{
	$ctotal = array(1 => 0,0,0,0,0,0,0,0,0,0,0,0,0,0);
	$total = array(1 => 0,0,0,0,0,0,0,0,0,0,0,0,0,0);
	$totals_arr = array();

	$printtitle = 0; //Flag for printing type name	
	$fill = 0;
	//Get Accounts directly under this group/type
	$result = get_gl_accounts(null, null, $type);	
	while ($account=db_fetch($result))
	{
		$bal = getPeriods($yr, $mo, $account["account_code"], $dimension, $dimension2);
		if (!$bal['per01'] && !$bal['per02'] && !$bal['per03'] && !$bal['per04'] &&	!$bal['per05'] && 
			!$bal['per06'] && !$bal['per07'] && !$bal['per08'] && !$bal['per09'] && !$bal['per10'] && 
			!$bal['per11'] && !$bal['per12'] && !$bal['ytd'] && !$bal['mon12'])
			continue;
	
		//Print Type Title if it has atleast one non-zero account	
		if (!$printtitle)
		{
			$printtitle = 1;
			$rep->row += 4;
			$rep->NewLine();		
            $oldcMargin = $rep->GetCellPadding();
            $rep->SetCellPadding(0);
            $rep->Font('b');
			$rep->TextCol(0, 5, $typename);
            $rep->Font();
            $rep->SetCellPadding($oldcMargin);
            $rep->row += 1;
			$rep->Line($rep->row - 4);
			$rep->NewLine();
		}			

		$balance = array(1 => $bal['per01'], $bal['per02'], $bal['per03'], $bal['per04'],
			$bal['per05'], $bal['per06'], $bal['per07'], $bal['per08'],
			$bal['per09'], $bal['per10'], $bal['per11'], $bal['per12'], $bal['ytd'], $bal['mon12']);
		$rep->TextCol(0, 1,	$account['account_name'], 0, 4, 0, $fill, NULL, 1);

		for ($i = 1; $i <= 14; $i++)
		{
			$rep->AmountCol2($i, $i + 1, $balance[$i] * $convert, $dec, 0, 4, 0, $fill, NULL, 1, true);
			$ctotal[$i] += $balance[$i];
		}
		$rep->NewLine();
		$fill = !$fill;
	}
		
	//Get Account groups/types under this group/type
	$result = get_account_types(false, false, $type);
	while ($accounttype=db_fetch($result))
	{
		//Print Type Title if has sub types and not previously printed
		if (!$printtitle)
		{
			$printtitle = 1;
			$rep->row += 4;
			$rep->NewLine();		
            $oldcMargin = $rep->GetCellPadding();
            $rep->SetCellPadding(0);
            $rep->Font('b');
			$rep->TextCol(0, 5, $typename);
            $rep->Font();
            $rep->SetCellPadding($oldcMargin);
            $rep->row += 1;
			$rep->Line($rep->row - 4);
			$rep->NewLine();
		}

		$totals_arr = display_type($accounttype["id"], $accounttype["name"], $yr, $mo, $convert, $dec, $rep, $dimension, $dimension2);
		for ($i = 1; $i <= 14; $i++)
		{
			$total[$i] += $totals_arr[$i];
		}
	}

	//Display Type Summary if total is != 0 OR head is printed (Needed in case of unused hierarchical COA) 
	if ($printtitle)
	{
		$rep->row += 5;
		$rep->Line($rep->row - 3);
		$rep->NewLine();
		$rep->Font('b');
		$oldcMargin = $rep->GetCellPadding();
		$rep->SetCellPadding(0);
		$fill = 0;
		$rep->TextCol(0, 1,	'Total' . " " . $typename, 0, 4, 0, $fill, NULL, 1);
		$rep->SetCellPadding($oldcMargin);
		for ($i = 1; $i <= 14; $i++)
			$rep->AmountCol2($i, $i + 1, ($total[$i] + $ctotal[$i]) * $convert, $dec, 0, 4, 0, $fill, NULL, 1, true);
		$rep->Font();
		$rep->NewLine(2);
	}
	for ($i = 1; $i <= 14; $i++)
		$totals_arr[$i] = $total[$i] + $ctotal[$i];	
	return $totals_arr;
}

//----------------------------------------------------------------------------------------------------

function print_annual_expense_breakdown_detail()
{
	global $path_to_root, $date_system, $comp_path;

	$dim = get_company_pref('use_dimension');
	$dimension = $dimension2 = 0;

	if ($dim == 2)
	{
		$date = $_POST['PARAM_0'];
		$dimension = $_POST['PARAM_1'];
		$dimension2 = $_POST['PARAM_2'];
		$comments = $_POST['PARAM_3'];
		$destination = $_POST['PARAM_4'];
	}
	else if ($dim == 1)
	{
		$date = $_POST['PARAM_0'];
		$dimension = $_POST['PARAM_1'];
		$comments = $_POST['PARAM_2'];
		$destination = $_POST['PARAM_3'];
	}
	else
	{
		$date = $_POST['PARAM_0'];
		$comments = $_POST['PARAM_1'];
		$destination = $_POST['PARAM_2'];
	}
	if ($destination)
		include_once($path_to_root . "/reporting/includes/excel_report.inc");
	else
		include_once($path_to_root . "/reporting/includes/pdf_report.inc");

   	$title = _("Annual Expense Breakdown - Detailed");
   	$output_filename = "AnnualBreakDownDetail";
   	$fontsize = 7;
   	$page_size = user_pagesize();
   	$page_orientation = 'L';
   	$margins = array('top' => 30, 'bottom' => 34, 'left' => 16, 'right' => 10);
   	$excelColWidthFactor = 5;
   
   	$rep = new FrontReport($title, $output_filename, $page_size, $fontsize, $page_orientation, $margins, $excelColWidthFactor);

	$enddate = end_month($date);

   	$dec = user_price_dec();

   	// Lay out the columns for this report
   	//$cols2 = array(0, 70, 127, 184, 232, 280, 328, 376, 424, 472, 520, 568, 616, 664, 712, 760);
   	//-------------0--1---2----3----4----5----6----7----8----9----10---11---12---13---14---15-
   	
   	$cols2 = array(0=>0, 70);
   	$endline = $rep->endLine - 20;
   	$wi = ($endline - $cols2[1]) / 14; // 14 amount columns
   	for ($i = 2; $i < 17; $i++)
   		$cols2[$i] = $cols2[$i-1] + $wi;
   	$cols = $cols2;	
   	//----------------------------------------------------------------------------------------
   	$aligns2 = array('left', 'right', 'right', 'right', 'right', 'right', 'right', 'right',
				   'right', 'right', 'right', 'right', 'right', 'right', 'right');
   	$headers2 = array();

   	//$cols = array(0, 70, 127, 184, 232, 280, 328, 376, 424, 472, 520, 568, 616, 664, 712, 760);
   	//-------------0--1---2----3----4----5----6----7----8----9----10---11---12---13---14---15-
   	//----------------------------------------------------------------------------------------
   	$aligns = array('left', 'right', 'right', 'right', 'right', 'right', 'right', 'right',
				   'right', 'right', 'right', 'right', 'right', 'right', 'right');
   	$headers = array();

	$date = begin_month($date);
	$date = add_months($date, -11);
	list($da, $mo, $yr) = explode_date_to_dmy($date);
	if ($date_system == 1)
		list($yr, $mo, $da) = jalali_to_gregorian($yr, $mo, $da);
	elseif ($date_system == 2)
		list($yr, $mo, $da) = islamic_to_gregorian($yr, $mo, $da);

    $headers2[0] = 'Account';
    $headers[0] = '';
	for ($i = 0; $i < 12; $i++)
	{
		$header_row[$i] = $rep->DatePrettyPrint($date, 0, 1);
		// Wrap at space between month & year
	   	$wrap_point = strpos($header_row[$i], ' ');
	   	if ($wrap_point)
	   	{
			$headers2[] = substr($header_row[$i], 0, $wrap_point);
			$headers[] = substr($header_row[$i], $wrap_point+1);
	   	}
	   	else
	   	{
			$headers2[] = '';
			$headers[] = $header_row[$i];
	   	}
   		$date = add_months($date, 1);
	}
	$header_row[] = _("Fiscal YTD");
	$header_row[] = _("12 Mo. to Date");
	for ($i = 12; $i < 14; $i++)
	{
	   	$wrapped_header_text = $rep->TextWrapCalc($header_row[$i], $cols[$i+2] - $cols[$i+1], true);
	   	$headers2[] = trim($wrapped_header_text[0]);
	   	$headers[] = trim($wrapped_header_text[1]);
	}

    if ($dim == 2)
    {
    	$params =   array( 	0 => $comments,
                    	1 => array('text' => _("Report Period"),
                    		'from' => '', 'to' => $rep->DatePrettyPrint($enddate)),
                    	2 => array('text' => '', 'from' => '', 'to' => ''),	
                    	3 => array('text' => '', 'from' => '', 'to' => ''),	
                    	4 => array('text' => _("Dimension 1"),
                    		'from' => get_dimension_string($dimension), 'to' => ''),
                    	5 => array('text' => _("Dimension 2"),
                    		'from' => get_dimension_string($dimension2), 'to' => ''));
    }
    else if ($dim == 1)
    {
    	$params =   array( 	0 => $comments,
                    	1 => array('text' => _("Report Period"),
                    		'from' => '', 'to' => $rep->DatePrettyPrint($enddate)),
                      	2 => array('text' => '', 'from' => '', 'to' => ''),	
                  		3 => array('text' => _('Dimension'),
                    		'from' => get_dimension_string($dimension), 'to' => ''));
    }
    else
    {
    	$params =   array( 	0 => $comments,
                    	1 => array('text' => _("Report Period"),
                    		'from' => '', 'to' => $rep->DatePrettyPrint($enddate)));
    }
   	// Company logo setting
   	$companylogoenable = true;

   	// Footer Settings
   	$footerenable = true;
   	$footertext = _('For Management Purposes Only');

	$rep->Font();
    $rep->SetFillColor(240, 240, 240);
    $rep->scaleLogoWidth = true;
    $rep->lineHeight = 8;
    $rep->SetCellPadding(4);
    $rep->Info($params, $cols, $headers, $aligns, $cols2, $headers2, $aligns2, $companylogoenable, $footerenable, $footertext);
    $rep->SetHeaderType('Header3');
    $rep->NewPage();
    $rep->SetDrawColor(0,0,0);
    $rep->SetLineWidth(0.1);

	$sales = Array(1 => 0,0,0,0,0,0,0,0,0,0,0,0,0,0);
	
	$classresult = get_account_classes(false, 0);
	while ($class = db_fetch($classresult))
	{
		$ctotal = Array(1 => 0,0,0,0,0,0,0,0,0,0,0,0,0,0);
		$convert = get_class_type_convert($class["ctype"]); 		
		
		//Print Class Name	
		$rep->NewLine();
		$oldcMargin = $rep->GetCellPadding();
		$rep->SetCellPadding(0);
		$oldFontSize = $rep->fontSize;
		$rep->fontSize = 12;
		$rep->Font('b');
		$rep->TextCol(0, 5, $class["class_name"]);
		$rep->Font();
       	$rep->fontSize = $oldFontSize;
       	$rep->SetCellPadding($oldcMargin);
		$rep->NewLine();
		
		//Get Account groups/types under this group/type with no parents
		$typeresult = get_account_types(false, $class['cid'], -1);
		while ($accounttype=db_fetch($typeresult))
		{
			$classtotal = display_type($accounttype["id"], $accounttype["name"], $yr, $mo, $convert, $dec, $rep, $dimension, $dimension2);
			for ($i = 1; $i <= 14; $i++)
				$ctotal[$i] += $classtotal[$i];
		}
		
		//Print Class Summary	
		$rep->row += 5;
		$rep->Line($rep->row - 3);
		$rep->NewLine();
		$rep->Font('b');
		$oldcMargin = $rep->GetCellPadding();
		$rep->SetCellPadding(0);
		$fill = 0;
		$rep->TextCol(0, 1,	_('Total') . " " . $class["class_name"], 0, 4, 0, $fill, NULL, 1);
		$rep->SetCellPadding($oldcMargin);
		for ($i = 1; $i <= 14; $i++)
		{
			$rep->AmountCol2($i, $i + 1, $ctotal[$i] * $convert, $dec, 0, 4, 0, $fill, NULL, 1, true);
			$sales[$i] += $ctotal[$i];
		}
		$rep->Font();
		$rep->NewLine(2);
	}
	$rep->Font('bold');	
	$oldcMargin = $rep->GetCellPadding();
	$rep->SetCellPadding(0);
	$rep->TextCol(0, 1,	_('Net Income (Loss)'), 0, 4, 0, $fill, NULL, 1);
	$rep->SetCellPadding($oldcMargin);
	for ($i = 1; $i <= 14; $i++)
		$rep->AmountCol2($i, $i + 1, $sales[$i] * -1, $dec, 0, 4, 0, $fill, NULL, 1, true);
	$rep->Font();
	$rep->NewLine();
	$rep->Line($rep->row);
	$rep->NewLine(2);
	
	$calc = Array(1 => 0,0,0,0,0,0,0,0,0,0,0,0,0,0);
	$total = Array(1 => 0,0,0,0,0,0,0,0,0,0,0,0,0,0);

	$classresult = get_account_classes(false, 1);
	while ($class = db_fetch($classresult))
	{
		$convert = get_class_type_convert($class["ctype"]); 		
		
		//Print Class Name	
		$oldcMargin = $rep->GetCellPadding();
		$rep->SetCellPadding(0);
		$rep->Font('b');
		$rep->TextCol(0, 1, "Total " . $class["class_name"], 0, 4, 0, $fill, NULL, 1);
		$rep->SetCellPadding($oldcMargin);
		$typeresult = get_account_types(false, $class['cid']);
		while ($accounttype=db_fetch($typeresult))
		{
			$result = get_gl_accounts(null, null, $accounttype['id']);	
			while ($account=db_fetch($result))
			{
				$bal = getPeriods($yr, $mo, $account["account_code"], $dimension, $dimension2, true);
				$balance = array(1 => $bal['per01'], $bal['per02'], $bal['per03'], $bal['per04'],
					$bal['per05'], $bal['per06'], $bal['per07'], $bal['per08'],
					$bal['per09'], $bal['per10'], $bal['per11'], $bal['per12']);
				for ($i = 1; $i <= 12; $i++)
					$total[$i] += $balance[$i];
			}
		}
		for ($i = 1; $i <= 12; $i++)
		{
			$rep->AmountCol2($i, $i + 1, $total[$i] * $convert, $dec, 0, 4, 0, $fill, NULL, 1, true);
			$calc[$i] += $total[$i];
			$total[$i] = 0;
		}
		$rep->NewLine(2);
	}	
	$oldcMargin = $rep->GetCellPadding();
	$rep->SetCellPadding(0);
	$rep->TextCol(0, 1,	'Total Net Asset', 0, 4, 0, $fill, NULL, 1);
	$rep->SetCellPadding($oldcMargin);
	for ($i = 1; $i <= 12; $i++)
	{
		$rep->AmountCol2($i, $i + 1, $calc[$i], $dec, 0, 4, 0, $fill, NULL, 1, true); // no convert
	}	
	$rep->Font();
	$rep->End();
}

?>