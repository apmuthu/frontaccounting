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
$page_security = 'SA_BOMREP';
// ----------------------------------------------------------------
// $ Revision:	2.0 $
// Creator:	Joe Hunt
// date_:	2005-05-19
// Title:	Bill Of Material
// ----------------------------------------------------------------
$path_to_root="..";

include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/data_checks.inc");
include_once($path_to_root . "/gl/includes/gl_db.inc");
include_once($path_to_root . "/inventory/includes/db/items_db.inc");
set_ext_domain('modules/asset_register');

//----------------------------------------------------------------------------------------------------

print_assets_list();

function getTransactions($from, $to)
{
	$sql = "SELECT ".TB_PREF."asset_types.asset_type_id,
			".TB_PREF."asset_types.asset_type_name,
			".TB_PREF."assets.asset_name,
			".TB_PREF."assets.asset_serial,
			".TB_PREF."assets.purchase_date,
			".TB_PREF."assets.purchase_value
		FROM
			".TB_PREF."asset_types INNER JOIN ".TB_PREF."assets ON 
		".TB_PREF."asset_types.asset_type_id = ".TB_PREF."assets.asset_type_id 
		GROUP BY ".TB_PREF."asset_types.asset_type_id";

    return db_query($sql,"No transactions were returned");
}

//----------------------------------------------------------------------------------------------------

function print_assets_list()
{
    global $path_to_root;

    $frompart = $_POST['PARAM_0'];
    $topart = $_POST['PARAM_1'];
    $comments = $_POST['PARAM_2'];
	$destination = $_POST['PARAM_3'];
	if ($destination)
		include_once($path_to_root . "/reporting/includes/excel_report.inc");
	else
		include_once($path_to_root . "/reporting/includes/pdf_report.inc");

	$cols = array(0, 50, 305, 375, 445,	515);

	$headers = array(_('Asset Type'), _('Asset name'), _('Serial Number'), _('Purchase Date'), _('Purchase Value'));

	$aligns = array('left',	'left',	'left', 'left', 'right');

    $params =   array( 	0 => $comments,
    				    1 => array('text' => _('Component'), 'from' => $frompart, 'to' => $topart));

    $rep = new FrontReport(_('Assets Listing'), "AssetList", user_pagesize());

    $rep->Font();
    $rep->Info($params, $cols, $headers, $aligns);
    $rep->NewPage();

	$res = getTransactions($frompart, $topart);
	$parent = '';
	while ($trans=db_fetch($res))
	{
		if ($parent != $trans['asset_type_name'])
		{
			if ($parent != '')
			{
				$rep->Line($rep->row - 2);
				$rep->NewLine(2, 3);
			}
			$rep->TextCol(0, 2, $trans['asset_type_name']);
			$desc = get_item($trans['asset_type_name']);
			$parent = $trans['asset_type_name'];
			$rep->NewLine();
		}

		$rep->NewLine();
		$dec = get_qty_dec($trans['asset_id']);
		$rep->TextCol(0, 1, $trans['asset_type_name']);
		$rep->TextCol(1, 2, $trans['asset_name']);
		$rep->TextCol(2, 3, $trans['asset_serial']);
		$rep->TextCol(3, 4, $trans['purchase_date']);
		$rep->AmountCol(4, 5, $trans['purchase_value'], $dec);
	}
	$rep->Line($rep->row - 4);
	$rep->NewLine();
    $rep->End();
}

?>
