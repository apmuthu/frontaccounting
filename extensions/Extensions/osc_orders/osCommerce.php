<?php
/**********************************************
Author: Tom Moulton
Name: osCommerce order import to Sales Order
Free software under GNU GPL
***********************************************/
$page_security = 'SA_OSCORDERS';
$path_to_root="../..";

include($path_to_root . "/includes/session.inc");
add_access_extensions();

include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/includes/data_checks.inc");
include_once($path_to_root . "/sales/includes/db/branches_db.inc");
include_once($path_to_root . "/sales/includes/db/customers_db.inc");
include_once($path_to_root . "/sales/includes/db/sales_order_db.inc");
include_once($path_to_root . "/sales/includes/cart_class.inc");
include_once($path_to_root . "/sales/includes/ui/sales_order_ui.inc");
include_once($path_to_root . "/inventory/includes/db/items_prices_db.inc");

/*
SELECT c.customers_id, CONCAT(c.customers_firstname, ' ', c.customers_lastname) , b.entry_street_address, b.entry_suburb, b.entry_city, b.entry_zone_id, b.entry_state, b.entry_postcode, b.entry_country_id, c.customers_telephone, c.customers_email_address FROM customers c left join `customers_info` i on c.customers_id = i.customers_info_id left join address_book b on c.customers_default_address_id = b.address_book_id

SELECT `customers_id` FROM `customers` order by `customers_id` desc LIMIT 0,1
SELECT `customers_id` FROM `customers` order by `customers_id` asc LIMIT 0,1

SELECT products_model, products_price FROM products WHERE products_status = 1
*/

function not_null($str) {
    if ($str != '' && $str != NULL) return 1;
    return 0;
}

function osc_get_zone_code($osc, $zone_name) {
    $sql = "SELECT zone_code from zones where zone_name='$zone_name'";
    $result = mysql_query($sql, $osc);
    $zone = mysql_fetch_assoc($result);
    mysql_free_result($result);
    $id = $zone['zone_code'];
    if (!not_null($id)) $id = $zone_name;
    return $id;
}

function osc_get_zone_code_from_id($osc, $zone_id) {
    $sql = "SELECT zone_code from zones where zone_id='$zone_id'";
    $result = mysql_query($sql, $osc);
    $zone = mysql_fetch_assoc($result);
    mysql_free_result($result);
    $id = $zone['zone_code'];
    return $id;
}

function osc_get_zone_name_from_id($osc, $zone_id) {
    $sql = "SELECT zone_name from zones where zone_id='$zone_id'";
    $result = mysql_query($sql, $osc);
    $zone = mysql_fetch_assoc($result);
    mysql_free_result($result);
    $id = $zone['zone_name'];
    return $id;
}

function osc_get_country($osc, $country_id) {
    $sql = "SELECT countries_name from countries where countries_id='$country_id'";
    $result = mysql_query($sql, $osc);
    $country = mysql_fetch_assoc($result);
    mysql_free_result($result);
    $id = $country['countries_name'];
    return $id;
}

function osc_address_format($osc, $data, $pre) {
    $company = $data[$pre . 'company'];
    if (not_null($data[$pre . 'name'])) $name = $data[$pre . 'name'];
    else $name = $data[$pre . 'firstname'] . ' ' . $data[$pre . 'lastname'];
    $street_address = $data[$pre . 'street_address'];
    $suburb = $data[$pre . 'suburb'];
    $city = $data[$pre . 'city'];
    $postcode = $data[$pre . 'postcode'];
    // $state = $data[$pre . 'state'];
    if (not_null($data[$pre . 'state'])) $state = $data[$pre . 'state'];
    else if (not_null($data[$pre . 'zone_id'])) $state = osc_get_zone_code_from_id($osc, $data[$pre . 'zone_id']);
    if (not_null($data[$pre . 'country_id'])) $country = osc_get_country($osc, $data[$pre . 'country_id']);
    else $country = $data[$pre . 'country'];

    $ret = '';
    if (not_null($company)) $ret .= $company . "\n";
    $ret .= $name . "\n" . $street_address . "\n";
    if (not_null($suburb)) $ret .= $suburb . "\n";
    if (not_null($city)) $ret .= $city;
    if (not_null($state)) $ret .= ", " . osc_get_zone_code($osc, $state);
    if (not_null($postcode)) $ret .= " " . $postcode . "\n";
    else $ret .=  "\n";
    if (not_null($country)) $ret .= $country . "\n";
    return $ret;
}

function get_tax_group_from_zone_id($osc, $zone_id, $def_tax_group_id) {
    $tax_group = osc_get_zone_name_from_id($osc, $zone_id);
    $taxgid = "";
    if ($tax_group != "") {
        $sql = "select id from ".TB_PREF."tax_groups WHERE name='".$tax_group."'";
        $result = db_query($sql, "Non Taxable Group");
        $row = db_fetch_row($result);
        if ($row) $taxgid = $row[0];
    }
    if ($taxgid == "") $taxgid = $def_tax_group_id;
    return $taxgid;
}

function check_stock_id($stock_id) {
    $sql = "SELECT * FROM ".TB_PREF."stock_master where stock_id = " . db_escape($stock_id);
    $result = db_query($sql, "Can not look up stock_id");
    $row = db_fetch_row($result);
    if (!$row[0]) return 0;
    return 1;
}

// error_reporting(E_ALL);
// ini_set("display_errors", "on");

global $db; // Allow access to the FA database connection
$debug_sql = 0;

global $db_connections;
$cur_prefix = $db_connections[$_SESSION["wa_current_user"]->cur_con]['tbpref'];

check_db_has_sales_areas("You must first define atleast one Sales Area");

$sql = "SHOW TABLES";
$result = db_query($sql, "could not show tables");
$found = 0;
$one_database = 0; // Use one DB, auto-detect below
while (($row = db_fetch_row($result))) {
    if ($row[0] == $cur_prefix."oscommerce") $found = 1;
	if (stripos($row[0], 'orders_status_history') !== false) $one_database = 1;
}

$dbHost = "";
$dbUser = "";
$dbPassword = "";
$dbName = "";
$lastcid = 0;
$lastoid = 0;
$defaultTaxGroup = 0;

$db_Host = "";
$db_User = "";
$db_Password = "";
$db_Name = "";
$last_cid = 0;
$last_oid = 0;
$default_TaxGroup = 0;

if ($found) {
    // Get Host Name
    $sql = "SELECT * FROM ".TB_PREF."oscommerce WHERE name = 'myhost'";
    $result = db_query($sql, "could not get host name");
    $row = db_fetch_row($result);
    $db_Host = $row[1];

    // Get User Name
    $sql = "SELECT * FROM ".TB_PREF."oscommerce WHERE name = 'myuser'";
    $result = db_query($sql, "could not get user name");
    $row = db_fetch_row($result);
    $db_User = $row[1];

    // Get Password
    $sql = "SELECT * FROM ".TB_PREF."oscommerce WHERE name = 'mypassword'";
    $result = db_query($sql, "could not get password");
    $row = db_fetch_row($result);
    $db_Password = $row[1];

    // Get DB Name
    $sql = "SELECT * FROM ".TB_PREF."oscommerce WHERE name = 'myname'";
    $result = db_query($sql, "could not get DB name");
    $row = db_fetch_row($result);
    $db_Name = $row[1];

    // Get last cID imported
    $sql = "SELECT * FROM ".TB_PREF."oscommerce WHERE name = 'lastcid'";
    $result = db_query($sql, "could not get DB name");
    $row = db_fetch_row($result);
    if (!$row) {
        $sql = "INSERT INTO ".TB_PREF."oscommerce (name, value) VALUES ('lastcid', 0)";
	db_query($sql, "add lastcid");
	$last_cid = 0;
    } else $last_cid = $row[1];

    // Get last oID imported
    $sql = "SELECT * FROM ".TB_PREF."oscommerce WHERE name = 'lastoid'";
    $result = db_query($sql, "could not get DB name");
    $row = db_fetch_row($result);
    if (!$row) {
        $sql = "INSERT INTO ".TB_PREF."oscommerce (name, value) VALUES ('lastoid', 0)";
	db_query($sql, "add lastoid");
	$last_oid = 0;
    } else $last_oid = $row[1];

    // Get Default Tax Group
    $sql = "SELECT * FROM ".TB_PREF."oscommerce WHERE name = 'taxgroup'";
    $result = db_query($sql, "could not get taxgroup");
    $row = db_fetch_row($result);
    $default_TaxGroup = $row[1];
}

$num_price_errors = -1;

$action = 'summary';
if (isset($_GET['action']) && $found) $action = $_GET['action'];
if (!$found) $action = 'show';

if ($action == 'c_import') {
	if (!check_num('credit_limit', 0)) {
		display_error(_("The credit limit must be numeric and not less than zero."));
		$action = 'cimport';
	} 
}
	
if (isset($_POST['action'])) {
    $action = $_POST['action'];

    // Create Table
    if ($action == 'create') {
	$sql = "DROP TABLE IF EXISTS ".TB_PREF."oscommerce";
	db_query($sql, "Error dropping table");
	$sql = "CREATE TABLE ".TB_PREF."oscommerce ( `name` char(15) NOT NULL default '', " .
  	       " `value` varchar(100) NOT NULL default '', PRIMARY KEY  (`name`)) TYPE=MyISAM";
	db_query($sql, "Error creating table");
        header("Location: osCommerce.php?action=show");
    }
    if ($action == 'update') {
        if (isset($_POST['dbHost'])) $dbHost = $_POST['dbHost'];
        if (isset($_POST['dbUser'])) $dbUser = $_POST['dbUser'];
        if (isset($_POST['dbPassword'])) $dbPassword = $_POST['dbPassword'];
        if (isset($_POST['dbName'])) $dbName = $_POST['dbName'];
        if (isset($_POST['lastcid'])) $lastcid = $_POST['lastcid'];
        if (isset($_POST['lastoid'])) $lastoid = $_POST['lastoid'];
        if (isset($_POST['taxgroup'])) $defaultTaxGroup = $_POST['taxgroup'];

        if ($dbHost != $db_Host) { // It changd
            if ($dbHost == '') $sql = "DELETE FROM ".TB_PREF."oscommerce WHERE name = 'myhost'";
            else if ($db_Host == '') $sql = "INSERT INTO ".TB_PREF."oscommerce (name, value) VALUES ('myhost', '" . $dbHost . "')";
	    else $sql = "UPDATE  ".TB_PREF."oscommerce SET value = '" . $dbHost . "' WHERE name = 'myhost'";
	    db_query($sql, "Update 'myhost'");
	}

        if ($dbUser != $db_User) { // It changd
            if ($dbUser == '') $sql = "DELETE FROM ".TB_PREF."oscommerce WHERE name = 'myuser'";
            else if ($db_User == '') $sql = "INSERT INTO ".TB_PREF."oscommerce (name, value) VALUES ('myuser', '" . $dbUser . "')";
	    else $sql = "UPDATE  ".TB_PREF."oscommerce SET value = '" . $dbUser . "' WHERE name = 'myuser'";
	    db_query($sql, "Update 'myuser'");
	}

        if ($dbPassword != $db_Password) { // It changd
            if ($dbPassword == '') $sql = "DELETE FROM ".TB_PREF."oscommerce WHERE name = 'mypassword'";
            else if ($db_Password == '') $sql = "INSERT INTO ".TB_PREF."oscommerce (name, value) VALUES ('mypassword', '" . $dbPassword . "')";
	    else $sql = "UPDATE  ".TB_PREF."oscommerce SET value = '" . $dbPassword . "' WHERE name = 'mypassword'";
	    db_query($sql, "Update 'mypassword'");
	}

        if ($dbName != $db_Name) { // It changd
            if ($dbName == '') $sql = "DELETE FROM ".TB_PREF."oscommerce WHERE name = 'myname'";
            else if ($db_Name == '') $sql = "INSERT INTO ".TB_PREF."oscommerce (name, value) VALUES ('myname', '" . $dbName . "')";
	    else $sql = "UPDATE  ".TB_PREF."oscommerce SET value = '" . $dbName . "' WHERE name = 'myname'";
	    db_query($sql, "Update 'myname'");
        }

        if ($lastcid != $last_cid) { // It changd
            if ($lastcid == '') $sql = "DELETE FROM ".TB_PREF."oscommerce WHERE name = 'lastcid'";
            else if ($last_cid == '') $sql = "INSERT INTO ".TB_PREF."oscommerce (name, value) VALUES ('lastcid', $lastcid)";
	    else $sql = "UPDATE  ".TB_PREF."oscommerce SET value = $lastcid WHERE name = 'lastcid'";
	    db_query($sql, "Update 'lastcid'");
	}

        if ($lastoid != $last_oid) { // It changd
            if ($lastoid == '') $sql = "DELETE FROM ".TB_PREF."oscommerce WHERE name = 'lastoid'";
            else if ($last_oid == '') $sql = "INSERT INTO ".TB_PREF."oscommerce (name, value) VALUES ('lastoid', $lastoid)";
	    else $sql = "UPDATE  ".TB_PREF."oscommerce SET value = $lastoid WHERE name = 'lastoid'";
	    db_query($sql, "Update 'lastoid'");
	}

        if ($defaultTaxGroup != $default_TaxGroup) { // It changd
            if ($defaultTaxGroup == '') $sql = "DELETE FROM ".TB_PREF."oscommerce WHERE name = 'taxgroup'";
            else if ($default_TaxGroup == '') $sql = "INSERT INTO ".TB_PREF."oscommerce (name, value) VALUES ('taxgroup', $defaultTaxGroup)";
	    else $sql = "UPDATE  ".TB_PREF."oscommerce SET value = $defaultTaxGroup WHERE name = 'taxgroup'";
	    db_query($sql, "Update 'defaultTaxGroup'");
        header("Location: osCommerce.php?action=summary");
	}
    } else {
        $dbHost = $db_Host;
        $dbUser = $db_User;
        $dbPassword = $db_Password;
        $dbName = $db_Name;
        $lastcid = $last_cid;
        $lastoid = $last_oid;
        $defaultTaxGroup = $default_TaxGroup;
    }
    if ($action == 'c_import') {
		if (!check_num('credit_limit', 0)) {
			display_error(_("The credit limit must be numeric and not less than zero."));
		} 
	
		$min_cid = 0;
		$max_cid = 0;
        if (isset($_POST['min_cid'])) $min_cid = $_POST['min_cid'];
        if (isset($_POST['max_cid'])) $max_cid = $_POST['max_cid'];

        if ($one_database) $osc = $db;
        else $osc = mysql_connect($dbHost, $dbUser, $dbPassword);

        if (!$osc) display_notification("Failed to connect osCommerce Database");
        else {
	        if (!$one_database) mysql_select_db($dbName, $osc);
	        $sql = "SELECT * FROM customers c left join address_book b on c.customers_default_address_id = b.address_book_id where c.customers_id  >= $min_cid AND c.customers_id <= $max_cid";
	        // print $sql;
	        $customers = mysql_query($sql, $osc);
	        display_notification("Found " . db_num_rows($customers) . " new customers");
            // display_notification("osc " . $sql);
            $i = $j = 0;
	        while ($cust = mysql_fetch_assoc($customers)) {
		        $email = $cust['customers_email_address'];
		        $name = $cust['customers_firstname'] . ' ' . $cust['customers_lastname'];
		        $contact = $cust['entry_firstname'] . ' ' . $cust['entry_lastname'];
                $addr = osc_address_format($osc, $cust, 'entry_');
		        $tax_id = '';
		        $phone = $cust['customers_telephone'];
		        $fax = $cust['customers_fax'];
		        $area_code = $_POST['area'];
		        $currency = $_POST['currency'];

                // id; name; address1; address2; address3; address4; area; phone; fax; email; contact; tax_id; currency; tax_group

		        $taxgid = get_tax_group_from_zone_id($osc, $cust['entry_zone_id'], $_POST['tax_group_id']);
        
                $sql = "SELECT debtor_no,name FROM ".TB_PREF."debtors_master WHERE name=".db_escape($name);
                $result = db_query($sql,"customer could not be retreived");
                $row = db_fetch_assoc($result);
    
                if (!$row) {
					add_customer($name, $name, $addr, $tax_id, $currency, $_POST['dimension_id'], $_POST['dimension2_id'], 1, $_POST['payment_terms'], 0, 0, input_num('credit_limit'), $_POST['sales_type'], NULL);
                    if ($debug_sql) display_notification("INSERT DM " . $sql);
                    db_query($sql, "The customer could not be added");
                    $id = db_insert_id();
					add_branch($id, $name, $name, $addr, $_POST['salesman'], $area_code, $taxgid, $_POST['sales_account'], $_POST['sales_discount_account'], $_POST['receivables_account'], $_POST['payment_discount_account'], $_POST['default_location'], $addr, 0, 0, 1, NULL);
                    if ($debug_sql) display_notification("INSERT BR " . $sql);
            		display_notification("Added New Customer $name");

                    $i++;
                } else {
					update_customer($row['debtor_no'], $name, $name, $addr, $tax_id, $currency, $_POST['dimension_id'], $_POST['dimension2_id'], 1, $_POST['payment_terms'], 0, 0, input_num('credit_limit'), $_POST['sales_type'], NULL);
                    if ($debug_sql) display_notification("UPDATE DM " . $sql);
            		display_notification("Updated Customer $name");
                    $j++;
                }
		        if ((int)$cust['customers_id'] > $lastcid) {
	           	    $sql = "UPDATE  ".TB_PREF."oscommerce SET value = " . $cust['customers_id'] . " WHERE name = 'lastcid'";
	           	    db_query($sql, "Update 'lastcid'");
	    	    }
            }
            display_notification("$i customer posts created, $j customer posts updated.");
        }
    }
    if ($action == 'o_import') { // Import Order specified by oID
		$first_oid = (int)$_POST['first_oid'];
		$last_oid = (int)$_POST['last_oid'];
        if (!not_null($first_oid) || !not_null($last_oid)) {
	    	$first_oid = 0;
	    	$last_oid = 0;
		}
        if ($one_database) $osc = $db;
        else $osc = mysql_connect($dbHost, $dbUser, $dbPassword);
        if (!$osc) display_notification("Failed to connect osCommerce Database");
		else {
	    	if (!$one_database) mysql_select_db($dbName, $osc);
	    	$sql = "SELECT * FROM orders where orders_id >= $first_oid AND orders_id <= $last_oid";
	    	$oid_result = mysql_query($sql, $osc);
        	// echo "Found " . mysql_num_rows($oid_result) . " New Orders\n";
        	display_notification("Found " . mysql_num_rows($oid_result) . " New Orders");
	    	while ($order = mysql_fetch_assoc($oid_result)) {
				$oID = $order['orders_id'];
				$sql = "SELECT * FROM orders_total WHERE orders_id = $oID AND class = 'ot_shipping'";
				$result = mysql_query($sql, $osc);
				$order_total = mysql_fetch_assoc($result);
				mysql_free_result($result);
				$sql = "SELECT comments FROM orders_status_history WHERE orders_id = $oID";
				$result = mysql_query($sql, $osc);
				$comments = "";
				while ($row = mysql_fetch_assoc($result)) {
					if (not_null($row['comments'])) $comments .= $row['comments'] . "\n";
				}
				mysql_free_result($result);
				// print_r($order);
				// print_r($order_total);
				$sql = "SELECT * FROM ".TB_PREF."debtors_master where name=" . db_escape($order['customers_name']);
				$result = db_query($sql, "Cold not find customer by name");
				// echo "Found " . db_num_rows($result);
				if (db_num_rows($result) == 0) {
					display_notification("Customer " . db_escape($order['customers_name']) . " not found");
					break;
				}
				$customer = db_fetch_assoc($result);
				$addr = osc_address_format($osc, $order, 'delivery_');
				$taxgid = get_tax_group_from_zone_id($osc, $order['delivery_state'], $defaultTaxGroup);
				$sql = "SELECT * FROM ".TB_PREF."cust_branch WHERE debtor_no =" . $customer['debtor_no'] . " AND br_address = " . db_escape($addr);
                if ($debug_sql) display_notification("Find BR " . $sql);
				$result = db_query($sql, "could not find customer branch");
				if (db_num_rows($result) == 0) {
				    if ($debug_sql) display_notification("New Branch");
		    		$debtor_no = $customer['debtor_no'];
		    		$sql = "SELECT * FROM ".TB_PREF."cust_branch WHERE debtor_no = $debtor_no";
                	if ($debug_sql) display_notification("Find BR * " . $sql);
		    		$result = db_query($sql, "could not find any customer branch");
		    		$old_branch = db_fetch_assoc($result);
					if ($debug_sql) print_r($old_branch);
					add_branch($debtor_no, $old_branch['br_name'], $old_braanch['branch_ref'], $addr, $old_branch['salesman'], $old_branch['area'], $taxgid, $old_branch['sales_account'], $old_branch['sales_discount_account'], $old_branch['receivables_account'], $old_branch['payment_discount_account'], $old_branch['default_location'], $addr, 0, 0, 1, $old_branch['notes']);
                    $id = db_insert_id();
					$sql = "SELECT * FROM ".TB_PREF."cust_branch WHERE branch_code = $id";
                	if ($debug_sql) display_notification("Get BR " . $sql);
					$result = db_query($sql, "Could not load new branch");
				}
				$branch = db_fetch_assoc($result);
				// print_r($branch);
				// Now Add Sales_Order and Sales_Order_Details
				$cart = new Cart(30); // New Sales Order
				$cart->customer_id = $customer['debtor_no'];
				$cart->customer_currency = $customer['curr_code'];
				$cart->Branch = $branch['branch_code'];
				$cart->cust_ref = "osC Order # $oID";
				$cart->Comments = $comments;
				$cart->document_date = Today();
				// $_POST['OrderDate'] = $cart->document_date;
				$cart->sales_type = $customer['sales_type'];
				$cart->ship_via = $branch['default_ship_via'];
				$cart->deliver_to = $branch['br_name'];
				$cart->delivery_address = $branch['br_address'];
				$cart->phone = $branch['phone'];
				$cart->email = $branch['email'];
				$cart->freight_cost = $order_total['value'];
				$cart->Location = $branch['default_location'];
				$cart->due_date = Today();
				$sql = "SELECT * FROM orders_products WHERE orders_id = $oID";
				$result = mysql_query($sql, $osc);
				$lines = array();
				while ($prod = mysql_fetch_assoc($result)) {
		    		add_to_order($cart, $prod['products_model'], $prod['products_quantity'], $prod['products_price'], $customer['pymt_discount']);
				}
				mysql_free_result($result);
				$order_no = $cart->write(0);
				display_notification("Added Order Number $order_no for " . $order['customers_name']);
		
				if ($oID > $lastoid) {
	     			$sql = "UPDATE  ".TB_PREF."oscommerce SET value = " . $oID . " WHERE name = 'lastoid'";
	    			db_query($sql, "Update 'lastoid'");
				}
	    	}
	    	if (!$one_database) mysql_close($osc);
		}
    }
    if ($action == 'p_check') { // Price Check
        if ($one_database) $osc = $db;
        else $osc = mysql_connect($dbHost, $dbUser, $dbPassword);
        if (!$osc) display_notification("Failed to connect osCommerce Database");
		else {
	    	if (!$one_database) mysql_select_db($dbName, $osc);
	    	$sql = "SELECT products_model, products_price FROM products WHERE products_status = 1";
	    	// echo $sql;
	    	$p_result = mysql_query($sql, $osc);
	    	$currency = $_POST['currency'];
	    	$sales_type = $_POST['sales_type'];
	    	$num_price_errors = 0;
	    	while ($pp = mysql_fetch_assoc($p_result)) {
            	$price = $pp['products_price'];
            	$model = $pp['products_model'];
				$myprice = false;
				$myprice = get_kit_price($model, $currency, $sales_type);
				if ($myprice === false) {
					display_notification("$model price not found in FA");
				} else if ($price != $myprice) {
		    		display_notification("$model Prices do not match FA $myprice osC $price");
		    		$num_price_errors++;
				}
        	}
    	}
		$action = 'pcheck';
    }
    if ($action == 'p_update') { // Price Update
        if ($one_database) $osc = $db;
        else $osc = mysql_connect($dbHost, $dbUser, $dbPassword);
        if (!$osc) display_notification("Failed to connect osCommerce Database");
		else {
	    	if (!$one_database) mysql_select_db($dbName, $osc);
	    	$sql = "SELECT products_model, products_price FROM products WHERE products_status = 1";
	    	$p_result = mysql_query($sql, $osc);
	    	$currency = $_POST['currency'];
	    	$sales_type = $_POST['sales_type'];
	    	$num_price_errors = 0;
	    	while ($pp = mysql_fetch_assoc($p_result)) {
                $price = $pp['products_price'];
                $model = $pp['products_model'];
				$myprice = false;
				$myprice = get_kit_price($model, $currency, $sales_type);
				if ($myprice === false) display_notification("$model price not found in FA");
				else if ($price != $myprice) {
		    		display_notification("Updating $model from $price to $myprice");
		    		$sql = "UPDATE products SET products_price = $myprice where products_model = '$model'";
		    		mysql_query($sql, $osc);
		    		$num_price_errors++;
				}
            }
        }
	$action = 'pupdate';
    }
} else {
    $dbHost = $db_Host;
    $dbUser = $db_User;
    $dbPassword = $db_Password;
    $dbName = $db_Name;
    $lastcid = $last_cid;
    $lastoid = $last_oid;
    $defaultTaxGroup = $default_TaxGroup;

    if ($action == 'cimport' || $action == 'summary') { // Preview Customer Import page
        $min_cid = 0;
        $max_cid = 0;
        if ($one_database) $osc = $db;
        else $osc = mysql_connect($dbHost, $dbUser, $dbPassword);
        if (!$osc) display_notification("Failed to connect osCommerce Database");
        else {
	    if (!$one_database) mysql_select_db($dbName, $osc);
            $sql = "SELECT `customers_id` FROM `customers` order by `customers_id` asc LIMIT 0,1";
            $result = mysql_query($sql, $osc);
            $cid = mysql_fetch_assoc($result);
            $min_cid = (int)$cid['customers_id'];
	    if ($min_cid <= $last_cid) $min_cid = $last_cid+1;
            mysql_free_result($result);
            $sql = "SELECT `customers_id` FROM `customers` order by `customers_id` desc LIMIT 0,1";
            $result = mysql_query($sql, $osc);
            $cid = mysql_fetch_assoc($result);
            $max_cid = (int)$cid['customers_id'];
            mysql_free_result($result);
            if (!$one_database) mysql_close($osc);
        }
    }
    if ($action == 'oimport' || $action == 'summary') { // Preview Order Import page
        $min_oid = 0;
        $max_oid = 0;
        if ($one_database) $osc = $db;
        else $osc = mysql_connect($dbHost, $dbUser, $dbPassword);
        if (!$osc) display_notification("Failed to connect osCommerce Database");
        else {
	    if (!$one_database) mysql_select_db($dbName, $osc);
            $sql = "SELECT `orders_id` FROM `orders` order by `orders_id` asc LIMIT 0,1";
            $result = mysql_query($sql, $osc);
            $oid = mysql_fetch_assoc($result);
            $min_oid = (int)$oid['orders_id'];
	    if ($min_oid <= $last_oid) $min_oid = $last_oid+1;
            mysql_free_result($result);
            $sql = "SELECT `orders_id` FROM `orders` order by `orders_id` desc LIMIT 0,1";
            $result = mysql_query($sql, $osc);
            $oid = mysql_fetch_assoc($result);
            $max_oid = (int)$oid['orders_id'];
            mysql_free_result($result);
            if (!$one_database) mysql_close($osc);
        }
    }
}

page("osCommerce Interface");
if ($action == 'summary') echo 'Summary';
else hyperlink_params($_SERVER['PHP_SELF'], _("Summary"), "action=summary", false);
echo '&nbsp;|&nbsp;';
if ($action == 'show') echo 'Configuration';
else hyperlink_params($_SERVER['PHP_SELF'], _("Configuration"), "action=show", false);
echo '&nbsp;|&nbsp;';
if ($action == 'cimport') echo 'Customer Import';
else hyperlink_params($_SERVER['PHP_SELF'], _("&Customer Import"), "action=cimport", false);
echo '&nbsp;|&nbsp;';
if ($action == 'oimport') echo 'Order Import';
else hyperlink_params($_SERVER['PHP_SELF'], _("&Order Import"), "action=oimport", false);
echo '&nbsp;|&nbsp;';
if ($action == 'pcheck') echo 'Price Check';
else hyperlink_params($_SERVER['PHP_SELF'], _("&Price Check"), "action=pcheck", false);
echo '&nbsp;|&nbsp;';
if ($action == 'pupdate') echo 'Update Prices';
else hyperlink_params($_SERVER['PHP_SELF'], _("&Update Prices"), "action=pupdate", false);
echo "<br><br>";

include($path_to_root . "/includes/ui.inc");

if ($action == 'summary') {
    start_form(true);
    start_table($table_style);

    $th = array("Type", "# of Updates Needed");
    table_header($th);

    $k = 0;

    //alt_table_row_color($k);

	label_cell("New Customers");
	if ($min_cid > $max_cid) {
		label_cell("None");
	} else {
		label_cell($max_cid-$min_cid+1);
	}
    end_row();
	label_cell("New Orders");
	if ($min_oid > $max_oid) {
		label_cell("None");
	} else {
		label_cell($max_oid-$min_oid+1);
	}
    end_row();
    end_form();

    end_page();
}

if ($action == 'show') {
    start_form(true);
    start_table($table_style);

    $th = array("Function", "Description");
    table_header($th);

    $k = 0;

    alt_table_row_color($k);

    label_cell("Table Status");
    if ($found) $table_st = "Found";
    else $table_st = "<font color=red>Not Found</font>";
    label_cell($table_st);
    end_row();

	if ($found) {
    	text_row("Mysql Host", 'dbHost', $dbHost, 20, 40);

    	text_row("User", 'dbUser', $dbUser, 20, 40);

    	text_row("Password", 'dbPassword', $dbPassword, 20, 40);

    	text_row("DB Name", 'dbName', $dbName, 20, 40);
    	tax_groups_list_row(_("Default Tax Group:"), 'taxgroup', $default_TaxGroup);
	}

    end_table(1);

    if (!$found) {
        hidden('action', 'create');
        submit_center('create', 'Create Table');
    } else {
        hidden('action', 'update');
        submit_center('update', 'Update Mysql');
    }

    end_form();

    end_page();
}
if ($action == 'cimport') {

    start_form(true);

    start_table("$table_style2 width=40%");

    table_section_title("Default GL Accounts");

    $company_record = get_company_prefs();

    if (!isset($_POST['sales_account']) || $_POST['sales_account'] == "")
            $_POST['sales_account'] = $company_record["default_sales_act"];

    if (!isset($_POST['sales_discount_account']) || $_POST['sales_discount_account'] == "")
            $_POST['sales_discount_account'] = $company_record["default_sales_discount_act"];

    if (!isset($_POST['receivables_account']) || $_POST['receivables_account'] == "")
            $_POST['receivables_account'] = $company_record["debtors_act"];

    if (!isset($_POST['payment_discount_account']) || $_POST['payment_discount_account'] == "")
            $_POST['payment_discount_account'] = $company_record["default_prompt_payment_act"];

    gl_all_accounts_list_row("Sales Account:", 'sales_account', $_POST['sales_account']);
    gl_all_accounts_list_row("Sales Discount Account:", 'sales_discount_account', $_POST['sales_discount_account']);
    gl_all_accounts_list_row("Receivables Account:", 'receivables_account', $_POST['receivables_account']);
    gl_all_accounts_list_row("Payment Discount Account:", 'payment_discount_account', $_POST['payment_discount_account']);

    $dim = get_company_pref('use_dimension');
    if ($dim < 1)
        hidden('dimension_id', 0);
    if ($dim < 2)
        hidden('dimension2_id', 0);

	global $SysPrefs;
	$credit_limit = price_format($SysPrefs->default_credit_limit());

    table_section_title("Location, Tax Type, Sales Type, Sales Person and Payment Terms");
    locations_list_row("Location:", 'default_location', null);
    tax_groups_list_row(_("Default Tax Group:"), 'tax_group_id', $default_TaxGroup);
    sales_types_list_row("Sales Type:", 'sales_type', null);
    sales_persons_list_row("Sales Person:", 'salesman', null);
    sales_areas_list_row("Sales Area:", 'area');
    currencies_list_row("Customer Currency:", 'currency', get_company_pref("curr_default"));
    payment_terms_list_row("Payment Terms:", 'payment_terms', null);
	amount_row(_("Credit Limit:"), 'credit_limit', $credit_limit);
    if ($dim >= 1)
        dimensions_list_row(_("Dimension")." 1:", 'dimension_id', $_POST['dimension_id'], true, " ", false, 1);
    if ($dim > 1)
        dimensions_list_row(_("Dimension")." 2:", 'dimension2_id', $_POST['dimension2_id'], true, " ", false, 2);
    text_row("Starting osC Customer ID:", 'min_cid', $min_cid, 6, 6);
    text_row("Ending osC Customer ID:", 'max_cid', $max_cid, 6, 6);

    end_table(1);

    hidden('action', 'c_import');
    submit_center('cimport', "Import osC Customers");

    end_form();
    end_page();
}
if ($action == 'oimport') {

    start_form(true);

    start_table("$table_style2 width=40%");

    table_section_title("Order Import Options");

    text_row("Starting Order Number:", 'first_oid', $min_oid, 8, 8);
    text_row("Last Order Number:", 'last_oid', $max_oid, 8, 8);

    end_table(1);

    hidden('action', 'o_import');
    submit_center('oimport', "Import osC Orders");

    end_form();
    end_page();
}
if ($action == 'pcheck') {

    start_form(true);

    start_table("$table_style2 width=40%");

    table_section_title("Price Check Options");

    $company_record = get_company_prefs();

    currencies_list_row("Customer Currency:", 'currency', get_company_pref("curr_default"));
    sales_types_list_row("Sales Type:", 'sales_type', null);

    end_table(1);

    hidden('action', 'p_check');
    submit_center('pcheck', "Check osC Prices");
    if ($num_price_errors == 0) display_notification("No Pricing Errors Found");

    end_form();

    hyperlink_params($_SERVER['PHP_SELF'], _("Refresh"), "action=pcheck");
    end_page();
}
if ($action == 'pupdate') {

    start_form(true);

    start_table("$table_style2 width=40%");

    table_section_title("Update Price Options");

    $company_record = get_company_prefs();

    currencies_list_row("Customer Currency:", 'currency', get_company_pref("curr_default"));
    sales_types_list_row("Sales Type:", 'sales_type', null);

    end_table(1);

    hidden('action', 'p_update');
    submit_center('pupdate', "Update osC Prices");
    if ($num_price_errors > 0) display_notification("There were $num_price_errors prices updated");

    end_form();
    end_page();
}
?>
