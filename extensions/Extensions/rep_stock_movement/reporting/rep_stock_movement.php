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
$page_security = 'SA_ITEMSVALREP';
// ----------------------------------------------------------------
// $ Revision:	2.0 $
// Creator:	Jujuk
// date_:	2011-05-24
// Title:	Stock Movements
// ----------------------------------------------------------------
$path_to_root="..";

include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/ui/ui_input.inc");
include_once($path_to_root . "/includes/data_checks.inc");
include_once($path_to_root . "/gl/includes/gl_db.inc");
include_once($path_to_root . "/sales/includes/db/sales_types_db.inc");
include_once($path_to_root . "/inventory/includes/inventory_db.inc");

//----------------------------------------------------------------------------------------------------

stock_listing();

function fetch_items($category=0)
{
		$sql = "SELECT ".TB_PREF."stock_master.stock_id, ".TB_PREF."stock_master.description AS name,
				".TB_PREF."stock_master.material_cost+".TB_PREF."stock_master.labour_cost+".TB_PREF."stock_master.overhead_cost AS Standardcost,
				".TB_PREF."stock_master.category_id,
				".TB_PREF."stock_master.units,
				".TB_PREF."stock_category.description
			FROM ".TB_PREF."stock_master,
				".TB_PREF."stock_category
			WHERE ".TB_PREF."stock_master.category_id=".TB_PREF."stock_category.category_id";
		if ($category != 0)
			$sql .= " AND ".TB_PREF."stock_category.category_id = ".db_escape($category);
		$sql .= " ORDER BY ".TB_PREF."stock_master.category_id,
				".TB_PREF."stock_master.stock_id";

    return db_query($sql,"No transactions were returned");
}

function trans_qty($stock_id, $location=null, $from_date, $to_date, $inward = true)
{
	if ($from_date == null)
		$from_date = Today();

	$from_date = date2sql($from_date);	
	
	if ($to_date == null)
		$to_date = Today();

	$to_date = date2sql($to_date);

	$sql = "SELECT SUM(qty) FROM ".TB_PREF."stock_moves
		WHERE stock_id=".db_escape($stock_id)."
		AND tran_date > '$from_date' 
		AND tran_date <= '$to_date'";

	if ($location != null)
		$sql .= " AND loc_code = ".db_escape($location);
		
	if ($inward)
		$sql .= " AND qty > 0 ";	
	else
		$sql .= " AND qty < 0 ";

	$result = db_query($sql, "QOH calulcation failed");

	$myrow = db_fetch_row($result);	
	
	return $myrow[0];
	
}

//----------------------------------------------------------------------------------------------------

function stock_listing()
{
    global $comp_path, $path_to_root, $pic_height, $pic_width;

    $category = $_POST['PARAM_0'];
	$location = $_POST['PARAM_1'];
    $from_date = $_POST['PARAM_2'];
    $to_date = $_POST['PARAM_3'];
    $comments = $_POST['PARAM_4'];
	$destination = $_POST['PARAM_5'];
	if ($destination)
		include_once($path_to_root . "/reporting/includes/excel_report.inc");
	else
		include_once($path_to_root . "/reporting/includes/pdf_report.inc");

	if ($category == ALL_NUMERIC)
		$category = 0;
	if ($category == 0)
		$cat = _('All');
	else
		$cat = get_category_name($category);

	if ($location == ALL_TEXT)
		$location = 'all';
	if ($location == 'all')
		$loc = _('All');
	else
		$loc = get_location_name($location);

	$cols = array(0, 100, 300, 365, 440, 540, 640, 715);

	$headers = array(_('Category/Items'), _('Description'),	_('UOM'),	_('Opening'), _('Inward'), _('Outward'), _('Balance'));

	$aligns = array('left',	'left',	'left', 'right', 'right', 'right','right');

    $params =   array( 	0 => $comments,
    				    1 => array('text' => _('Category'), 'from' => $cat, 'to' => ''),
						2 => array('text' => _('Report Period'), 'from' => $from_date, 'to' => $to_date));
						3 => array('text' => _('Location'), 'from' => $loc, 'to' => ''));

	

    $rep = new FrontReport(_('Stock Movements'), "StockMovements", user_pagesize(),9,'L');

    $rep->Font();
    $rep->Info($params, $cols, $headers, $aligns);
    $rep->NewPage();

	$result = fetch_items($category);

	$catgor = '';
	while ($myrow=db_fetch($result))
	{
		if ($catgor != $myrow['description'])
		{
			$rep->Line($rep->row  - $rep->lineHeight);
			$rep->NewLine(2);
			$rep->fontSize += 2;
			$rep->TextCol(0, 3, $myrow['category_id'] . " - " . $myrow['description']);
			$catgor = $myrow['description'];
			$rep->fontSize -= 2;
			$rep->NewLine();
		}
		$rep->NewLine();
		$rep->TextCol(0, 1,	$myrow['stock_id']);
		$rep->TextCol(1, 2, $myrow['name']);
		$rep->TextCol(2, 3, $myrow['units']);
		$qoh_start= $inward = $outward = $qoh_end = 0; 
		
		$qoh_start += get_qoh_on_date($myrow['stock_id'], $location, $from_date);
		$qoh_end += get_qoh_on_date($myrow['stock_id'], $location, $to_date);
		
		$inward += trans_qty($myrow['stock_id'], $location, $from_date, $to_date);
		$outward += trans_qty($myrow['stock_id'], $location, $from_date, $to_date, false);

		$rep->AmountCol(3, 4, $qoh_start, get_qty_dec($myrow['stock_id']));
		$rep->AmountCol(4, 5, $inward, get_qty_dec($myrow['stock_id']));
		$rep->AmountCol(5, 6, $outward, get_qty_dec($myrow['stock_id']));
		$rep->AmountCol(6, 7, $qoh_end, get_qty_dec($myrow['stock_id']));
		
		$rep->NewLine(0, 1);
	}
	$rep->Line($rep->row  - 4);

	$rep->NewLine();
    $rep->End();
}

?>