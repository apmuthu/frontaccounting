<?php
/**********************************************
Name: Zen Cart customer and order import
Based on osCommerce order import by Tom Moulton
modified for Zen Cart 1.3.9h and FrontAccounting 2.3.2 by ckrosco
Free software under GNU GPL
***********************************************/

function zen_connect()
{
	$dbHost = get_zen_import_pref('myhost');
	$dbUser =  get_zen_import_pref('myuser');
	$dbPassword = get_zen_import_pref('mypassword');
	$dbName = get_zen_import_pref('myname');
	$zen = mysql_connect($dbHost, $dbUser, $dbPassword, true); // keep database resource ids separate
    mysql_select_db($dbName, $zen);

	return $zen;
}

function zen_get_zone_code($zen, $zone_name) {
    $sql = "SELECT zone_code FROM zones WHERE zone_name='$zone_name'";
    $result = mysql_query($sql, $zen);
    $zone = mysql_fetch_assoc($result);
    mysql_free_result($result);
    $id = $zone['zone_code'];
    if (!not_null($id)) $id = $zone_name;
    return $id;
}

function zen_get_zone_code_from_id($zen, $zone_id) {
    $sql = "SELECT zone_code FROM zones WHERE zone_id='$zone_id'";
    $result = mysql_query($sql, $zen);
    $zone = mysql_fetch_assoc($result);
    mysql_free_result($result);
    $id = $zone['zone_code'];
    return $id;
}

function zen_get_zone_name_from_id($zen, $zone_id) {
    $sql = "SELECT zone_name FROM zones WHERE zone_id='$zone_id'";
    $result = mysql_query($sql, $zen);
    $zone = mysql_fetch_assoc($result);
    mysql_free_result($result);
    $id = $zone['zone_name'];
    return $id;
}

function zen_get_country($zen, $country_id) {
    $sql = "SELECT countries_name FROM countries WHERE countries_id='$country_id'";
    $result = mysql_query($sql, $zen);
    $country = mysql_fetch_assoc($result);
    mysql_free_result($result);
    $id = $country['countries_name'];
    return $id;
}

function zen_get_customers($min_cid, $max_cid)
{
	global $zen;

	$min_cid = db_escape($min_cid);
	$max_cis = db_escape($max_cid);
	$sql = "SELECT * FROM customers c left join address_book b on c.customers_default_address_id = b.address_book_id WHERE c.customers_id  >= $min_cid AND c.customers_id <= $max_cid";
	return mysql_query($sql, $zen);
}
