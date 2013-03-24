<?php

function get_year_assets($yearid)
{
	$sql = "SELECT *, ".TB_PREF."get_asset_value(a.asset_id, YEAR(now())) as current_value 
		FROM ".TB_PREF."asset_types at INNER JOIN ".TB_PREF."assets a ON at.asset_type_id = a.asset_type_id
		WHERE (a.inactive = 1) AND (YEAR(a.disposal_date) = ".$yearid.")";

	return db_query($sql, "could not get year assets");
}

function get_year_asset_valuations($yearid)
{
	$sql = "SELECT * FROM ".TB_PREF."asset_valuations av INNER JOIN ".TB_PREF."assets a ON av.asset_id = a.asset_id
	WHERE av.valuation_year=".db_escape($yearid);

	return db_query($sql, "could not get all asset valuation");
}

function get_year_amortisation($yearid)
{
	$sql = "SELECT * FROM ".TB_PREF."amortisation am INNER JOIN ".TB_PREF."assets a ON am.asset_id = a.asset_id
	WHERE am.amortisation_year=".db_escape($yearid);

	return db_query($sql, "could not get all amortisation");
}

function post_amortise($yearid)
{
	$sql = "SELECT ".TB_PREF."amortise_post(".$yearid.")";

	db_query($sql, "could not post amortise");
}


?>
