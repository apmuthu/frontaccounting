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
function add_asset_valuation($assetid, $valuationyear, $assetvalue)
{
	$sql = "INSERT INTO ".TB_PREF."asset_valuations (asset_id, valuation_year, asset_value)
		VALUES (".db_escape($assetid).",".db_escape($valuationyear).",".db_escape($assetvalue).")";

	db_query($sql, "could not add asset valuation");
}

function update_asset_valuation($selectedid, $valuationyear, $assetvalue)
{
	$sql = "UPDATE ".TB_PREF."asset_valuations SET valuation_year=".db_escape($valuationyear)
			.", asset_value=".db_escape($assetvalue)
			."WHERE asset_valuation_id=".db_escape($selectedid);

	db_query($sql, "could not update asset type");
}

function get_all_asset_valuations($assetid)
{
	$sql = "SELECT * FROM ".TB_PREF."asset_valuations WHERE asset_id=".db_escape($assetid);

	return db_query($sql, "could not get all asset valuation");
}

function get_asset_valuation($selectedid)
{
	$sql = "SELECT * FROM ".TB_PREF."asset_valuations WHERE asset_valuation_id=".db_escape($selectedid);

	$result = db_query($sql, "could not get asset valuation");

	return db_fetch($result);
}

function delete_asset_valuation($selectedid)
{
	$sql="DELETE FROM ".TB_PREF."asset_valuations WHERE asset_valuation_id=".db_escape($selectedid);

	db_query($sql, "could not delete asset valuation");
}

?>
