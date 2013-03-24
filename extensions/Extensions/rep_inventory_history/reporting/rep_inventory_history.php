<?php
/**********************************************************************
Module ini di buat oleh INFOKOM CAMP dalam kotribusi nya dalam Open Source

***********************************************************************/
$page_security = 'SA_ITEMSVALREP';
// ----------------------------------------------------------------
// $ Revision:	1.0 $
// Creator:	Jujuk-Indonesia
// Email:	siji.tux@gmail.com
// date_:	28-02-2011
// Title:	Inventory History
// ----------------------------------------------------------------
$path_to_root="..";

include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/data_checks.inc");
include_once($path_to_root . "/gl/includes/gl_db.inc");
include_once($path_to_root . "/inventory/includes/db/items_category_db.inc");

//----------------------------------------------------------------------------------------------------

print_inventory_history();

function getTransactions($category, $location, $fromcust, $from, $to)
{
	$from = date2sql($from);
	$to = date2sql($to);
	$sql = "SELECT 	".TB_PREF."stock_master.category_id,
		".TB_PREF."stock_category.description AS cat_description,
		".TB_PREF."stock_master.stock_id,
		".TB_PREF."stock_master.description,
		".TB_PREF."stock_master.units,
		IFNULL(stokbrg.jml,0) stk_brg,
		IFNULL(penyesuaian.jml,0) peny_brg,
		IFNULL(produksi.jml,0) pro_brg,
		IFNULL(pembelian.jml,0) beli_brg,
		IFNULL(returnspl.jml,0) rtrspl_brg,
		IFNULL(transfer.jml,0) mutasi_brg,
		IFNULL(jualan.jml,0) penjualan,
		IFNULL(kembali.jml,0) retur_brg,
		(IFNULL(stokbrg.jml,0) + IFNULL(penyesuaian.jml,0) + IFNULL(produksi.jml,0) + IFNULL(pembelian.jml,0)  - 
		IFNULL(returnspl.jml,0) + IFNULL(transfer.jml,0) + IFNULL(kembali.jml,0) - IFNULL(jualan.jml,0)) saldo
FROM (".TB_PREF."stock_moves, ".TB_PREF."stock_master, ".TB_PREF."stock_category)
LEFT JOIN(SELECT stk.stock_id, SUM(IFNULL(stk.qty,0)) jml FROM ".TB_PREF."stock_moves AS stk WHERE stk.tran_date < '$from'";
if ($location != 'all')
	$sql .= " AND stk.loc_code = ".db_escape($location);
$sql .= " GROUP BY stk.stock_id ORDER BY stk.stock_id) AS stokbrg ON stokbrg.stock_id=".TB_PREF."stock_master.stock_id

LEFT JOIN(SELECT peny.stock_id, SUM(IFNULL(peny.qty,0)) jml FROM ".TB_PREF."stock_moves AS peny WHERE peny.type='17'
AND peny.tran_date >= '$from' AND peny.tran_date <= '$to'";
if ($location != 'all')
	$sql .= " AND peny.loc_code = ".db_escape($location);
$sql .= " GROUP BY peny.stock_id ORDER BY peny.stock_id) AS penyesuaian ON penyesuaian.stock_id=".TB_PREF."stock_master.stock_id
LEFT JOIN(SELECT pro.stock_id, SUM(IFNULL(pro.qty,0)) jml FROM ".TB_PREF."stock_moves AS pro WHERE pro.type='26'
AND pro.tran_date >= '$from' AND pro.tran_date <= '$to'";
if ($location != 'all')
	$sql .= " AND pro.loc_code = ".db_escape($location);
$sql .= " GROUP BY pro.stock_id ORDER BY pro.stock_id) AS produksi ON produksi.stock_id=".TB_PREF."stock_master.stock_id
LEFT JOIN(SELECT beli.stock_id, SUM(IFNULL(beli.qty,0)) jml FROM ".TB_PREF."stock_moves AS beli WHERE beli.type='25'
AND beli.tran_date>='$from' AND beli.tran_date<='$to'";
if ($location != 'all')
	$sql .= " AND beli.loc_code = ".db_escape($location);
$sql .= " GROUP BY beli.stock_id ORDER BY beli.stock_id) AS pembelian ON pembelian.stock_id=".TB_PREF."stock_master.stock_id
LEFT JOIN(SELECT rtrspl.stock_id, SUM(IFNULL(-rtrspl.qty,0)) jml FROM ".TB_PREF."stock_moves AS rtrspl WHERE rtrspl.type='21'
AND rtrspl.tran_date>='$from' AND rtrspl.tran_date<='$to'";
if ($location != 'all')
	$sql .= " AND rtrspl.loc_code = ".db_escape($location);
$sql .= " GROUP BY rtrspl.stock_id ORDER BY rtrspl.stock_id) AS returnspl ON returnspl.stock_id=".TB_PREF."stock_master.stock_id

LEFT JOIN(SELECT mutasi.stock_id, SUM(IFNULL(mutasi.qty,0)) jml FROM ".TB_PREF."stock_moves AS mutasi WHERE mutasi.type='16'
AND mutasi.tran_date>='$from' AND mutasi.tran_date<='$to'";
if ($location != 'all')
	$sql .= " AND mutasi.loc_code = ".db_escape($location);
$sql .= " GROUP BY mutasi.stock_id ORDER BY mutasi.stock_id) AS transfer ON transfer.stock_id=".TB_PREF."stock_master.stock_id
LEFT JOIN(SELECT jual.stock_id, SUM(IFNULL(-jual.qty,0)) jml FROM ".TB_PREF."stock_moves AS jual WHERE jual.type='13'
AND jual.tran_date>='$from' AND jual.tran_date<='$to'";
if ($location != 'all')
	$sql .= " AND jual.loc_code = ".db_escape($location);
$sql .= " GROUP BY jual.stock_id ORDER BY jual.stock_id) AS jualan ON jualan.stock_id=".TB_PREF."stock_master.stock_id
LEFT JOIN(SELECT retur.stock_id, SUM(IFNULL(retur.qty,0)) jml FROM ".TB_PREF."stock_moves AS retur WHERE retur.type='11'
AND retur.tran_date>='$from' AND retur.tran_date<='$to'";
if ($location != 'all')
	$sql .= " AND retur.loc_code = ".db_escape($location);
$sql .= " GROUP BY retur.stock_id ORDER BY retur.stock_id) AS kembali ON kembali.stock_id=".TB_PREF."stock_master.stock_id
WHERE ".TB_PREF."stock_master.stock_id=".TB_PREF."stock_moves.stock_id
AND ".TB_PREF."stock_master.category_id=".TB_PREF."stock_category.category_id AND ".TB_PREF."stock_moves.type>='11'
AND ".TB_PREF."stock_moves.type<='26' AND ".TB_PREF."stock_moves.tran_date>='$from' AND ".TB_PREF."stock_moves.tran_date<='$to' ";
if ($category != 0)
	$sql .= " AND ".TB_PREF."stock_master.category_id = ".db_escape($category);
if ($location != 'all')
	$sql .= " AND ".TB_PREF."stock_moves.loc_code = ".db_escape($location);
$sql .= " GROUP BY ".TB_PREF."stock_master.stock_id ORDER BY ".TB_PREF."stock_master.category_id, ".TB_PREF."stock_master.stock_id";
    
    return db_query($sql,"No transactions were returned");
}

//----------------------------------------------------------------------------------------------------

function print_inventory_history()
{
    global $path_to_root;

    $from = $_POST['PARAM_0'];
	$to = $_POST['PARAM_1'];
	$category = $_POST['PARAM_2'];
    $location = $_POST['PARAM_3'];
    $detail = $_POST['PARAM_4'];
	$comments = $_POST['PARAM_5'];
	$destination = $_POST['PARAM_6'];
	
	if ($destination)
		include_once($path_to_root . "/reporting/includes/excel_report.inc");
	else
		include_once($path_to_root . "/reporting/includes/pdf_report.inc");
	$detail = !$detail;
    $dec = user_price_dec();

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

	//$cols = array(0, 65, 210, 235, 300, 365, 430, 495, 560, 625, 690,	755);
	$cols = array(0, 65, 220, 245, 305, 365, 425, 485, 545, 605, 665,	725);

	$headers = array(_('Category'), '', _('UOM'), _('Adjustment'), _('Production'),  _('GRN'),  _('SuppCredit'),_('Transfer'), 
		_('Delivery'),  _('CustCredit'),_('QOH'));

	$aligns = array('left',	'left',	'left', 'right', 'right', 'right', 'right', 'right', 'right', 'right', 'right');

    $params =   array( 	0 => $comments,
						1 => array('text' => _('Period'),'from' => $from, 'to' => $to),
    				    2 => array('text' => _('Category'), 'from' => $cat, 'to' => ''),
    				    3 => array('text' => _('Location'), 'from' => $loc, 'to' => ''));

    $rep = new FrontReport(_('Inventory History'), "InventoryHistory", user_pagesize(), 10, 'L');

    $rep->Font();
    $rep->Info($params, $cols, $headers, $aligns);
    $rep->NewPage();

	$res = getTransactions($category, $location, $fromcust, $from, $to);
	$total = $grandtotal = 0.0;
	$catt = '';
	while ($trans=db_fetch($res))
	{
		if ($catt != $trans['cat_description'])
		{
			if ($catt != '')
			{
				if ($detail)
				{
					$rep->NewLine(2, 3);
					$rep->TextCol(0, 4, _('Total'));
				}
				$rep->AmountCol(10, 11, $total, $dec);
				if ($detail)
				{
					$rep->Line($rep->row - 2);
					$rep->NewLine();
				}
				$rep->NewLine();
				$total = 0.0;
			}
			$rep->TextCol(0, 1, $trans['category_id']);
			$rep->TextCol(1, 2, $trans['cat_description']);
			$catt = $trans['cat_description'];
			if ($detail)
				$rep->NewLine();
		}
		if ($detail)
		{
			$rep->NewLine();
			$rep->fontSize -= 2;
			$rep->TextCol(0, 1, $trans['stock_id']);
			$rep->TextCol(1, 2, $trans['description'].($trans['inactive']==1 ? " ("._("Inactive").")" : ""), -1);
			$rep->TextCol(2, 3, $trans['units']);
			$rep->AmountCol(3, 4, $trans['peny_brg'], get_qty_dec($trans['stock_id']));
			$rep->AmountCol(4, 5, $trans['pro_brg'], get_qty_dec($trans['stock_id']));
			$rep->AmountCol(5, 6, $trans['beli_brg'], get_qty_dec($trans['stock_id']));
			$rep->AmountCol(6, 7, -$trans['rtrspl_brg'], get_qty_dec($trans['stock_id']));
			$rep->AmountCol(7, 8, $trans['mutasi_brg'], get_qty_dec($trans['stock_id']));
			$rep->AmountCol(8, 9, -$trans['penjualan'], get_qty_dec($trans['stock_id']));
			$rep->AmountCol(9, 10, $trans['retur_brg'], get_qty_dec($trans['stock_id']));
			$rep->AmountCol(10, 11, $trans['saldo'], get_qty_dec($trans['stock_id']));
			$rep->fontSize += 2;
		}
		$total += $trans['saldo'];
		$grandtotal += $trans['saldo'];
	}
	if ($detail)
	{
		$rep->NewLine(2, 3);
		$rep->TextCol(0, 4, _('Total'));
	}
	$rep->Amountcol(10, 11, $total, $dec);
	if ($detail)
	{
		$rep->Line($rep->row - 2);
		$rep->NewLine();
	}
	$rep->NewLine(2, 1);
	$rep->TextCol(0, 4, _('Grand Total'));
	$rep->AmountCol(10, 11, $grandtotal, $dec);
	$rep->Line($rep->row  - 4);
	$rep->NewLine();
    $rep->End();
}

?>