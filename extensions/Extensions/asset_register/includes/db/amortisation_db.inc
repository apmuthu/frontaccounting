<?php

function get_amortise($assetid)
{
	$sql = "SELECT ".TB_PREF."amortise(".$assetid.")";

	$result = db_query($sql, "could not amortise");

	return db_fetch($result);
}

function get_all_amortisation($assetid)
{
	$sql = "SELECT * FROM ".TB_PREF."amortisation WHERE asset_id=".db_escape($assetid) 
	. " ORDER BY amortisation_year";

	return db_query($sql, "could not get all amortisation");
}

function get_amortisation($type_id)
{
	$sql = "SELECT * FROM ".TB_PREF."assets WHERE asset_id=".db_escape($type_id);

	$result = db_query($sql, "could not get asset");

	return db_fetch($result);
}

function delete_amortisation($type_id)
{
	$sql="DELETE FROM ".TB_PREF."assets WHERE asset_id=".db_escape($type_id);

	db_query($sql, "could not delete asset");
}

function amortisation_in_ledger($selected_id)
{
	$sql="SELECT COUNT(*) FROM ".TB_PREF."amortisation WHERE asset_id=".db_escape($selected_id);

	$result = db_query($sql, "could not query amortisation");
	$myrow = db_fetch_row($result);
	return ($myrow[0] > 0); 
}

?>
