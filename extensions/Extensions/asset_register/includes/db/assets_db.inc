<?php

function add_asset($type, $name, $serial, $purchase_date, $purchase_value, $tag, $location, $condition, $acquisition)
{
	$sql = "INSERT INTO ".TB_PREF."assets (asset_type_id,  asset_name,  asset_serial,  purchase_date,  purchase_value,  
			tag_number, asset_location, asset_condition, asset_acquisition,  disposal_amount)
			VALUES (".db_escape($type).",".db_escape($name).",".db_escape($serial).",".db_escape(date2sql($purchase_date)).",".db_escape($purchase_value)
			.",".db_escape($tag).",".db_escape($location).",".db_escape($condition).",".db_escape($acquisition).",0)";

	db_query($sql, "could not add asset.");
}

function update_asset($asset_id, $type, $name, $serial, $purchase_date, $purchase_value, $tag, $location, $condition, $acquisition, $disposal_amount, $disposal_date)
{
	$sql = "UPDATE ".TB_PREF."assets SET asset_name=".db_escape($name).", asset_serial=".db_escape($serial).", purchase_date=".db_escape(date2sql($purchase_date)).
			", purchase_value=".db_escape($purchase_value).", tag_number=".db_escape($tag).
			", asset_location=".db_escape($location).", asset_condition=".db_escape($condition).", asset_acquisition=".db_escape($acquisition).
			", disposal_amount=".db_escape($disposal_amount).", disposal_date=".db_escape(date2sql($disposal_date)). "
			WHERE asset_id=".db_escape($asset_id);

	db_query($sql, "could not update asset");
}

function get_all_assets($all=false)
{
	$sql = "SELECT *, ".TB_PREF."get_asset_value(a.asset_id, YEAR(now())) as current_value 
		FROM ".TB_PREF."asset_types at INNER JOIN ".TB_PREF."assets a ON at.asset_type_id = a.asset_type_id";
	if (!$all) $sql .= " WHERE !a.inactive";

	return db_query($sql, "could not get all assets");
}

function get_one_asset($assetid)
{
	$sql = "SELECT * , ".TB_PREF."get_asset_value(a.asset_id, YEAR(now())) as current_value 
		FROM ".TB_PREF."asset_types at INNER JOIN ".TB_PREF."assets a ON at.asset_type_id = a.asset_type_id ".
	"WHERE a.asset_id=".db_escape($assetid);

	return db_query($sql, "could not get one assets");
}

function get_asset($assetid)
{
	$sql = "SELECT * FROM ".TB_PREF."asset_types at INNER JOIN ".TB_PREF."assets a ON at.asset_type_id = a.asset_type_id ".
	"WHERE a.asset_id=".db_escape($assetid);

	$result = db_query($sql, "could not get asset");

	return db_fetch($result);
}

function delete_asset($assetid)
{
	$sql="DELETE FROM ".TB_PREF."assets WHERE asset_id=".db_escape($assetid);

	db_query($sql, "could not delete asset");
}

function asset_in_amortisation($selected_id)
{
	$sql="SELECT COUNT(*) FROM ".TB_PREF."amortisation WHERE asset_id=".db_escape($selected_id);

	$result = db_query($sql, "could not query amortisation");
	$myrow = db_fetch_row($result);
	return ($myrow[0] > 0); 
}

?>
