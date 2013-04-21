<?php
/**********************************************
Name: Zen Cart customer and order import
Based on osCommerce order import by Tom Moulton
modified for Zen Cart 1.3.9h and FrontAccounting 2.3.2 by ckrosco
Free software under GNU GPL
***********************************************/

function zen_orders_installed()
{
	global $db_connections;

	$cur_prefix = $db_connections[$_SESSION["wa_current_user"]->cur_con]['tbpref'];

	$sql = "SHOW TABLES LIKE '{$cur_prefix}zencart'";
	$result = db_query($sql, "could not show tables");

	return db_num_rows($result) != 0;
}

function create_zen_prefs()
{
	$sql = "DROP TABLE IF EXISTS ".TB_PREF."zencart";
   	db_query($sql, "Error dropping table");

    $sql = "CREATE TABLE `".TB_PREF."zencart` (
         `name` char(15) NOT NULL default \"\",
         `value` varchar(100) NOT NULL default \"\",
          PRIMARY KEY  (`name`))
          ENGINE=MyISAM";
    db_query($sql, "Error creating table");

	set_zen_import_pref('lastcid', 0);
	set_zen_import_pref('lastoid', 0);
}

function get_tax_group_from_zone_id($zen, $zone_id, $def_tax_group_id) {
    $tax_group = zen_get_zone_name_from_id($zen, $zone_id);
    $taxgid = "";
    if ($tax_group != "") {
        $sql = "SELECT id FROM ".TB_PREF."tax_groups WHERE name='".$tax_group."'";
        $result = db_query($sql, "Non Taxable Group");
        $row = db_fetch_row($result);
        if ($row) $taxgid = $row[0];
    }
    if ($taxgid == "") $taxgid = $def_tax_group_id;
    return $taxgid;
}

function check_stock_id($stock_id) {
    $sql = "SELECT * FROM ".TB_PREF."stock_master WHERE stock_id = " . db_escape($stock_id);
    $result = db_query($sql, "Can not look up stock_id");
    $row = db_fetch_row($result);
    if (!$row[0]) return 0;
    return 1;
}

function get_zen_import_pref($pref)
{
	$pref = db_escape($pref);

    $sql = "SELECT * FROM ".TB_PREF."zencart WHERE name = $pref";
    $result = db_query($sql, "could not get zen pref ".$pref);

    if (!db_num_rows($result))
    	return null;
	$row = db_fetch_row($result);
    return $row[1];
}

function set_zen_import_pref($pref, $value)
{
	$sql = "REPLACE ".TB_PREF."zencart (name, value) VALUES (".db_escape($pref).", ".db_escape($value).")";
    db_query($sql, "can't update ". $pref);
}

function get_zen_customer_ids()
{
	global $zen;

	$sql = "SELECT MIN(`customers_id`) as min_cid, MAX(`customers_id`) as max_cid FROM `customers`";
    $result = mysql_query($sql, $zen);
    return mysql_fetch_assoc($result);
}

function get_zen_order_ids()
{
	global $zen;

	$sql = "SELECT MIN(`orders_id`) as min_oid, MAX(`orders_id`) as max_oid FROM `orders`";
   $result = mysql_query($sql, $zen);
   return mysql_fetch_assoc($result);
}
