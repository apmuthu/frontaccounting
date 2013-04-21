<?php
/**********************************************
Name: Zen Cart customer and order import
Based on osCommerce order import by Tom Moulton
modified for Zen Cart 1.5.1 and FrontAccounting 2.3.15 by ckrosco
Free software under GNU GPL
***********************************************/

$page_security = 'SA_ZENIMPORT';
$path_to_root="../..";

include($path_to_root . "/includes/session.inc");
add_access_extensions();
set_ext_domain('modules/zen_import');

include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/includes/data_checks.inc");
include_once($path_to_root . "/sales/includes/db/branches_db.inc");
include_once($path_to_root . "/sales/includes/db/customers_db.inc");
include_once($path_to_root . "/sales/includes/db/sales_order_db.inc");
include_once($path_to_root . "/sales/includes/cart_class.inc");
include_once($path_to_root . "/sales/includes/ui/sales_order_ui.inc");

include_once($path_to_root . "/modules/zen_orders/includes/zen_interface_db.inc");
include_once($path_to_root . "/modules/zen_orders/includes/zen_orders_db.inc");

function not_null($str) {
    if ($str != '' && $str != NULL) return 1;
    return 0;
}

function zen_address_format($zen, $data, $pre) {
    $company = $data[$pre . 'company'];
    $name = isset($data[$pre . 'firstname']) ? $data[$pre . 'firstname'] . ' ' . $data[$pre . 'lastname'] : false;
    $street_address = $data[$pre . 'street_address'];
    $suburb = $data[$pre . 'suburb'];
    $city = $data[$pre . 'city'];
    $postcode = $data[$pre . 'postcode'];
    if (not_null($data[$pre . 'state'])) $state = $data[$pre . 'state'];
    else if (not_null($data[$pre . 'zone_id'])) $state = zen_get_zone_code_from_id($zen, $data[$pre . 'zone_id']);
    if (isset($data[$pre . 'country_id'])) $country = zen_get_country($zen, $data[$pre . 'country_id']);
    else $country = $data[$pre . 'country'];

    $ret = '';
    if (not_null($company)) $ret .= $company . "\n";
    $ret .= $name . "\n" . $street_address . "\n";
    if (not_null($suburb)) $ret .= $suburb . "\n";
    if (not_null($city)) $ret .= $city;
    if (not_null($state)) $ret .= ", " . zen_get_zone_code($zen, $state);
    if (not_null($postcode)) $ret .= " " . $postcode . "\n";
    else $ret .=  "\n";
    if (not_null($country)) $ret .= $country . "\n";
    return $ret;
}

//error_reporting(E_ALL);
//ini_set("display_errors", "on");

global $db; // Allow access to the FA database connection
$debug_sql = 0;  // Change to 1 for debug messages

check_db_has_sales_areas("You must first define at least one Sales Area");

$dbHost = "";
$dbUser = "";
$dbPassword = "";
$dbName = "";
$lastcid = 0;
$lastoid = 0;
$defaultTaxGroup = 0;
$defaultCurrency = "";

$db_Host = "";
$db_User = "";
$db_Password = "";
$db_Name = "";
$last_cid = 0;
$last_oid = 0;
$default_TaxGroup = 0;
$default_Currency = "";

$found = zen_orders_installed();

if ($found) {
	$zen = zen_connect();
	if(!$zen)
		display_error(_("Failed to connect to Zen Cart Database"));

    // Get Host Name
	 $db_Host = get_zen_import_pref('myhost');

    // Get User Name
    $db_User = get_zen_import_pref('myuser');

    // Get Password
    $db_Password = get_zen_import_pref('mypassword');

    // Get DB Name
    $db_Name = get_zen_import_pref('myname');

    // Get last cID imported
    $last_cid = get_zen_import_pref('lastcid');

    // Get last oID imported
    $last_oid = get_zen_import_pref('lastoid');

    // Get Default Tax Group
    $default_TaxGroup = get_zen_import_pref('taxgroup');
    
    //Get Default Currency
    $default_Currency = get_zen_import_pref('currency');
}

// Show information to connect to Zen Cart Database 
//$action = 'show';
$action = $found ? 'cimport' : 'show';
if (isset($_GET['action']) && $found) $action = $_GET['action'];

if (isset($_POST['action'])) {
    $action = $_POST['action'];

    // Create Table
    if ($action == 'create') {
        $sql = "DROP TABLE IF EXISTS ".TB_PREF."zencart";
        db_query($sql, "Error dropping table");
        $sql = "CREATE TABLE ".TB_PREF."zencart (name char(15) NOT NULL default '', value varchar(100) NOT NULL default '', PRIMARY KEY  (name)) ENGINE=MyISAM";
        db_query($sql, "Error creating table");

		  set_zen_import_pref('lastcid', 0);
		  set_zen_import_pref('lastoid', 0);

        if (isset($_POST['dbHost'])) $dbHost = $_POST['dbHost'];
        if (isset($_POST['dbUser'])) $dbUser = $_POST['dbUser'];
        if (isset($_POST['dbPassword'])) $dbPassword = $_POST['dbPassword'];
        if (isset($_POST['dbName'])) $dbName = $_POST['dbName'];
        if (isset($_POST['taxgroup'])) $defaultTaxGroup = $_POST['taxgroup'];
        if (isset($_POST['currency'])) $defaultCurrency = $_POST['currency'];
        
        if ($dbHost != $db_Host) // If it changed
        	set_zen_import_pref('myhost', $dbHost);

        if ($dbUser != $db_User) // If it changed
        	set_zen_import_pref('myuser', $dbUser);

        if ($dbPassword != $db_Password) // If it changed
        	set_zen_import_pref('mypassword', $dbPassword);

        if ($dbName != $db_Name) // If it changed
        	set_zen_import_pref('myname', $dbName);

        if ($defaultTaxGroup != $default_TaxGroup) // If it changed
        	set_zen_import_pref('taxgroup', $defaultTaxGroup);
        	
        if ($defaultCurrency != $default_Currency) // If it changed
        	set_zen_import_pref('currency', $defaultCurrency);	
		  
        header("Location: zencart.php");
    }
    

    if ($action == 'update') {
         if (isset($_POST['dbHost'])) $dbHost = $_POST['dbHost'];
        if (isset($_POST['dbUser'])) $dbUser = $_POST['dbUser'];
        if (isset($_POST['dbPassword'])) $dbPassword = $_POST['dbPassword'];
        if (isset($_POST['dbName'])) $dbName = $_POST['dbName'];
        if (isset($_POST['lastcid'])) $lastcid = $_POST['lastcid'];
        if (isset($_POST['lastoid'])) $lastoid = $_POST['lastoid'];
        if (isset($_POST['taxgroup'])) $defaultTaxGroup = $_POST['taxgroup'];
        if (isset($_POST['currency'])) $defaultCurrency = $_POST['currency'];
        
        if ($dbHost != $db_Host) // If it changed
        	set_zen_import_pref('myhost', $dbHost);

        if ($dbUser != $db_User) // If it changed
        	set_zen_import_pref('myuser', $dbUser);

        if ($dbPassword != $db_Password) // If it changed
        	set_zen_import_pref('mypassword', $dbPassword);

        if ($dbName != $db_Name) // If it changed
        	set_zen_import_pref('myname', $dbName);

        if ($lastcid != $last_cid) // If it changed
        	set_zen_import_pref('lastcid', $lastcid);

        if ($lastoid != $last_oid) // If it changed
        	set_zen_import_pref('lastoid', $lastoid);

        if ($defaultTaxGroup != $default_TaxGroup) // If it changed
        	set_zen_import_pref('taxgroup', $defaultTaxGroup);

        if ($defaultCurrency != $default_Currency) // If it changed
        	set_zen_import_pref('currency', $defaultCurrency);
    } else {
        $dbHost = $db_Host;
        $dbUser = $db_User;
        $dbPassword = $db_Password;
        $dbName = $db_Name;
        $lastcid = $last_cid;
        $lastoid = $last_oid;
        $defaultTaxGroup = $default_TaxGroup;
        $defaultCurrency = $default_Currency;
    }
    
// Customer Import from Zen Cart Database
   if ($action == 'c_import') {
        $min_cid = 0;
        $max_cid = 0;
        if (isset($_POST['min_cid'])) $min_cid = $_POST['min_cid'];
        if (isset($_POST['max_cid'])) $max_cid = $_POST['max_cid'];

        $zen = mysql_connect($dbHost, $dbUser, $dbPassword);

        if (!$zen) display_notification("Failed to connect to Zen Cart Database");
        else {
            mysql_select_db($dbName, $zen);
            $sql = "SELECT * FROM customers c left join address_book b on c.customers_default_address_id = b.address_book_id WHERE c.customers_id  >= $min_cid AND c.customers_id <= $max_cid";
            $customers = mysql_query($sql, $zen);
            display_notification("Found " . db_num_rows($customers) . " new customers");
            $i = $j = 0;
            while ($cust = mysql_fetch_assoc($customers)) {
                $name = db_escape($cust['customers_firstname'] . ' ' . $cust['customers_lastname']);
                $contact = db_escape($cust['entry_firstname'] . ' ' . $cust['entry_lastname']);
                $addr = db_escape(zen_address_format($zen, $cust, 'entry_'));
                $tax_id = '';
                $phone = $cust['customers_telephone'];
                $fax = $cust['customers_fax'];
                $area_code = $_POST['area'];
                $currency = $_POST['currency'];

                $sql = "SELECT debtor_no FROM ".TB_PREF."debtors_master WHERE name=$name";
                $result = db_query($sql,"customer could not be retrieved");
                $row = db_fetch_assoc($result);

                if (!$row) {
                    $sql = "INSERT INTO ".TB_PREF."debtors_master (name, address, tax_id, curr_code, sales_type, payment_terms, credit_status, debtor_ref)
                            VALUES ($name, $addr, '', '$currency', {$_POST['sales_type']},
                            5, 1, $name)";
                    if ($debug_sql) display_notification("INSERT DM " . $sql);
                    db_query($sql, "The customer could not be added");
                    $id = db_insert_id();
                    $sql = "INSERT INTO ".TB_PREF."cust_branch (debtor_no, br_name, br_address, area, salesman, contact_name, default_location, tax_group_id, sales_account,
                            sales_discount_account, receivables_account, payment_discount_account, br_post_address, branch_ref)
                            VALUES ($id, $name, $addr, '$area_code', '{$_POST['salesman']}', $contact, '{$_POST['default_location']}', '3', '{$_POST['sales_account']}',
                            '{$_POST['sales_discount_account']}', '{$_POST['receivables_account']}',
                            '{$_POST['payment_discount_account']}', $addr, $name)";
                    if ($debug_sql) display_notification("INSERT BR " . $sql);
                    db_query($sql, "The customer branch could not be added 1");

                    $i++;
                } else {
                    $sql = "UPDATE ".TB_PREF."debtors_master SET address=$addr, tax_id='', address=$addr,
                            curr_code='$currency',
                            sales_type={$_POST['sales_type']},
                            payment_terms= 5
                            WHERE name=$name";

                    if ($debug_sql) display_notification("UPDATE DM " . $sql);
                    db_query($sql, "The customer could not be updated");



                    $j++;
                }
                if ((int)$cust['customers_id'] > $lastcid) {
                    $sql = "UPDATE ".TB_PREF."zencart SET value = " . $cust['customers_id'] . " WHERE name = 'lastcid'";
                    db_query($sql, "Update 'lastcid'");
                }
            }
            display_notification("$i customer posts created, $j customer posts updated.");
        }
    }

// Order Import from Zen Cart database
    if ($action == 'o_import') { 
        $first_oid = (int)$_POST['first_oid'];
        $last_oid = (int)$_POST['last_oid'];
        if (!not_null($first_oid) || !not_null($last_oid)) {
            $first_oid = 0;
            $last_oid = 0;
        }
        $zen = mysql_connect($dbHost, $dbUser, $dbPassword);
        if (!$zen) display_notification("Failed to connect to Zen Cart Database");
        else {
            mysql_select_db($dbName, $zen);
            $sql = "SELECT * FROM orders WHERE orders_id >= $first_oid AND orders_id <= $last_oid";
            $oid_result = mysql_query($sql, $zen);
            display_notification("Found " . mysql_num_rows($oid_result) . " New Orders");
            while ($order = mysql_fetch_assoc($oid_result)) {
                $oID = $order['orders_id'];
                $sql = "SELECT * FROM orders_total WHERE orders_id = $oID AND class = 'ot_shipping'";
                $result = mysql_query($sql, $zen);
                $order_total = mysql_fetch_assoc($result);
                mysql_free_result($result);
                $sql = "SELECT comments FROM orders_status_history WHERE orders_id = $oID";
                $result = mysql_query($sql, $zen);
                $comments = "";
                while ($row = mysql_fetch_assoc($result)) {
                        if (not_null($row['comments'])) $comments .= $row['comments'] . "\n";
                }
                mysql_free_result($result);

                $sql = "SELECT DATE_FORMAT(date_purchased, '%m/%d/%Y') FROM orders WHERE orders_id = $oID";
                $result = mysql_query($sql, $zen);
                $date_purchased_result = mysql_fetch_assoc($result);
                $date_purchased = array_pop($date_purchased_result);
                mysql_free_result($result);             
                
                $sql = "SELECT * FROM ".TB_PREF."debtors_master WHERE name=" . db_escape($order['customers_name']);
                $result = db_query($sql, "Could not find customer by name");

                if (db_num_rows($result) == 0) {
                        display_notification("Customer " . db_escape($order['customers_name']) . " not found");
                        break;
                }
                $customer = db_fetch_assoc($result);

                $addr = db_escape(zen_address_format($zen, $order, 'delivery_'));
                $sql = "SELECT * FROM ".TB_PREF."cust_branch WHERE debtor_no =" . $customer['debtor_no'] . " AND br_address = " . $addr;
                $result = db_query($sql, "could not find customer branch");
                if (db_num_rows($result) == 0) {
                    $debtor_no = $customer['debtor_no'];
                    $sql = "SELECT * FROM ".TB_PREF."cust_branch WHERE debtor_no = $debtor_no";
                    $result = db_query($sql, "could not find any customer branch");
                    $old_branch = db_fetch_assoc($result);
                    $sql_new = "INSERT INTO ".TB_PREF."cust_branch (debtor_no, br_name, br_address, area, salesman, " .
                           "contact_name, default_location, tax_group_id, sales_account, " .
                           "sales_discount_account, receivables_account, payment_discount_account, br_post_address, branch_ref) " .
                           "VALUES ($debtor_no, '" . $customer['name'] . "', $addr, '" . $old_branch['area'] . "', '" . $old_branch['salesman'] . "', '" .
                           $old_branch['contact_name'] . "', '" .
                           $old_branch['default_location'] . "', 1, '" . $old_branch['sales_account'] . "', '" .
                           $old_branch['sales_discount_account'] . "', '" . $old_branch['receivables_account'] . "', '" .
                           $old_branch['payment_discount_account'] . "', $addr, '" . $customer['name'] . "')";
                    db_query($sql_new, "The customer branch could not be added 2");
                    $result = db_query($sql, "could not find customer branch");
                }
                $branch = db_fetch_assoc($result);
                $cart = new Cart(30); // New Sales Order
                $cart->customer_id = $customer['debtor_no'];
                $cart->customer_currency = $customer['curr_code'];
                $cart->Branch = $branch['branch_code'];
                $cart->cust_ref = "Zen Order # $oID";
                $cart->Comments = $comments;
                $cart->document_date = $date_purchased;
                $cart->sales_type = $customer['sales_type'];
                $cart->ship_via = $branch['default_ship_via'];
                $cart->deliver_to = $branch['br_name'];
                $cart->delivery_address = $branch['br_address'];
//                $cart->phone = $branch['phone'];
                $cart->freight_cost = $order_total['value'];
                $cart->Location = $branch['default_location'];
                $cart->due_date = $date_purchased;
                $cart->payment = 5;
                
      $sql = "SELECT orders_products.orders_id, orders_products_attributes.products_options_values, orders_products.products_priced_by_attribute, orders_products.products_quantity, orders_products.final_price, orders_products.products_id
FROM orders_products
LEFT JOIN orders_products_attributes ON orders_products_attributes.orders_products_id = orders_products.orders_products_id
WHERE orders_products.orders_id = $oID";
                
                $result = mysql_query($sql, $zen);

                while ($prod = mysql_fetch_assoc($result)) {
                        
         if ($prod['products_priced_by_attribute'] == 1) {
                 $prod['quantity'] = $prod['products_quantity'] * (int)$prod["products_options_values"];
                  }
                  else {
                  	$prod['quantity'] = $prod['products_quantity'];
                  	}
// 'ceil' function in the next line should round up a final decimal '3' to a '4'
                     $prod['final_price'] = ceil(1000000*($prod['final_price'] / $prod['quantity'] * $prod['products_quantity']))/1000000;
                     add_to_order($cart, $prod['products_id'], $prod['quantity'], $prod['final_price'], $customer['pymt_discount']);
                }
                mysql_free_result($result);
                $order_no = $cart->write(0);
                display_notification("Added Order Number $order_no");
                
                if ($oID > $lastoid) {
                    $sql = "UPDATE  ".TB_PREF."zencart SET value = " . $oID . " WHERE name = 'lastoid'";
                    db_query($sql, "Update 'lastoid'");

                }
            }
            mysql_close($zen);
        }
    }


} else {
    $dbHost = $db_Host;
    $dbUser = $db_User;
    $dbPassword = $db_Password;
    $dbName = $db_Name;
    $lastcid = $last_cid;
    $lastoid = $last_oid;
    $defaultTaxGroup = $default_TaxGroup;
    $defaultCurrency = $default_Currency;

    if ($action == 'cimport') { // Preview Customer Import page
        $min_cid = 0;
        $max_cid = 0;
		$cid = get_zen_customer_ids();
        $min_cid = max((int)$cid['min_cid'], $last_cid+1);
        $max_cid = max($min_cid, (int)$cid['max_cid']);
    }
    if ($action == 'oimport') { // Preview Order Import page
        $min_oid = 0;
        $max_oid = 0;
		$oid = get_zen_order_ids();
        $min_oid = max((int)$oid['min_oid'], $last_oid+1);
        $max_oid = max($min_oid, (int)$oid['max_oid']);
    }  
}

page(_($help_context = "zencart Interface"));
if ($action == 'show') echo 'Configuration';
else hyperlink_params($_SERVER['PHP_SELF'], _("Configuration"), "action=show", false);
echo '&nbsp;|&nbsp;';
if ($action == 'cimport') echo 'Customer Import';
else hyperlink_params($_SERVER['PHP_SELF'], _("&Customer Import"), "action=cimport", false);
echo '&nbsp;|&nbsp;';
if ($action == 'oimport') echo 'Order Import';
else hyperlink_params($_SERVER['PHP_SELF'], _("&Order Import"), "action=oimport", false);
echo '&nbsp;|&nbsp;';


if ($action == 'show') {
        
    start_form(true);
    start_table(TABLESTYLE2, "width=40%");

    $th = array("Function", "Description");
    table_header($th);

    $k = 0;

    alt_table_row_color($k);

    label_cell("Table Status");
    if ($found) $table_st = "Found";
    else $table_st = "<font color=red>Not Found</font>";
    label_cell($table_st);
    end_row();

    text_row("Mysql Host", 'dbHost', $dbHost, 20, 40);

    text_row("User", 'dbUser', $dbUser, 20, 40);

    text_row("Password", 'dbPassword', $dbPassword, 20, 40);

    text_row("DB Name", 'dbName', $dbName, 20, 40);
    tax_groups_list_row(_("Default Tax Group:"), 'taxgroup', $default_TaxGroup);
    currencies_list_row(_("Default Currency:"), 'currency', $default_Currency);
    
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

    start_table(TABLESTYLE2, "width=40%");

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

    table_section_title("Location, Tax Type, Sales Type, Sales Person and Payment Terms");
    locations_list_row("Location:", 'default_location', 'DEF');
    tax_groups_list_row(_("Default Tax Group:"), 'tax_group_id', $default_TaxGroup);
    sales_types_list_row("Sales Type:", 'sales_type', null);
    sales_persons_list_row("Sales Person:", 'salesman', null);
    sales_areas_list_row("Sales Area:", 'area');
    currencies_list_row("Customer Currency:", 'currency', $default_Currency);
    payment_terms_list_row("Payment Terms:", 'payment_terms', null);
    text_row("Starting Zen Cart Customer ID:", 'min_cid', $min_cid, 10, 10);
    text_row("Ending Zen Cart Customer ID:", 'max_cid', $max_cid, 10, 10);
 
    end_table(1);

    hidden('action', 'c_import');
    submit_center('cimport', "Import Zen Cart Customers");

    end_form();
    end_page();
}
if ($action == 'oimport') {

    start_form(true);

    start_table(TABLESTYLE2, "width=40%");

    table_section_title("Order Import Options");

    text_row("Starting Order Number:", 'first_oid', $min_oid, 10, 10);
    text_row("Last Order Number:", 'last_oid', $max_oid, 10, 10);

    end_table(1);

    hidden('action', 'o_import');
    submit_center('oimport', "Import Zen Cart Orders");

    end_form();
    end_page();
}
?>
