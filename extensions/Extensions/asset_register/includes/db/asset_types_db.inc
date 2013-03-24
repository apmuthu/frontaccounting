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
function add_asset_type($name, $rate, $asset_account, $depreciation_account, $accumulated_account, $valuation_account, $disposal_account)
{
	$sql = "INSERT INTO ".TB_PREF."asset_types (asset_type_name, depreciation_rate, asset_account, depreciation_account, accumulated_account, valuation_account, disposal_account)
		VALUES (".db_escape($name).",".db_escape($rate).",".db_escape($asset_account).",".db_escape($depreciation_account).",".db_escape($accumulated_account)
		.",".db_escape($valuation_account).",".db_escape($disposal_account).")";

	db_query($sql, "could not add asset types");
}

function update_asset_type($type_id, $name, $rate, $asset_account, $depreciation_account, $accumulated_account, $valuation_account, $disposal_account)
{
	$sql = "UPDATE ".TB_PREF."asset_types SET asset_type_name=".db_escape($name)
			.", depreciation_rate=".db_escape($rate)
			.", asset_account=".db_escape($asset_account)
			.", depreciation_account=".db_escape($depreciation_account)
			.", accumulated_account=".db_escape($accumulated_account)
			.", valuation_account=".db_escape($valuation_account)
			.", disposal_account=".db_escape($disposal_account)
			."WHERE asset_type_id=".db_escape($type_id);

	db_query($sql, "could not update asset type");
}

function get_all_asset_types($all=false)
{
	$sql = "SELECT * FROM ".TB_PREF."asset_types";
	if (!$all) $sql .= " WHERE !inactive";

	return db_query($sql, "could not get all asset types");
}

function get_asset_type($selected_id)
{
	$sql = "SELECT * FROM ".TB_PREF."asset_types WHERE asset_type_id=".db_escape($selected_id);

	$result = db_query($sql, "could not get asset type");

	return db_fetch($result);
}

function delete_asset_type($type_id)
{
	$sql="DELETE FROM ".TB_PREF."asset_types WHERE asset_type_id=".db_escape($type_id);

	db_query($sql, "could not delete asset type");
}

function asset_types_in_assets($selected_id)
{
	$sql="SELECT COUNT(*) FROM ".TB_PREF."assets WHERE asset_type_id=".db_escape($selected_id);

	$result = db_query($sql, "could not query assets");
	$myrow = db_fetch_row($result);
	return ($myrow[0] > 0); 
}

?>
