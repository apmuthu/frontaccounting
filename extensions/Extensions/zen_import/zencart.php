<?php
/**********************************************
Name: Zen Cart customer and order import
Based on osCommerce order import by Tom Moulton
modified for Zen Cart 1.3.9h and FrontAccounting 2.3.2 by ckrosco
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
include_once($path_to_root . "/modules/zen_import/includes/zen_interface_db.inc");
include_once($path_to_root . "/modules/zen_import/includes/zen_orders_db.inc");

function not_null($str) {
    if ($str != '' && $str != NULL) return 1;
    return 0;
}

function zen_address_format($zen, $data, $pre) {
    $company = $data[$pre . 'company'];
    if (not_null($data[$pre . 'name'])) $name = $data[$pre . 'name'];
    else $name = $data[$pre . 'firstname'] . ' ' . $data[$pre . 'lastname'];
    $street_address = $data[$pre . 'street_address'];
    $suburb = $data[$pre . 'suburb'];
    $city = $data[$pre . 'city'];
    $postcode = $data[$pre . 'postcode'];
    // $state = $data[$pre . 'state'];
    if (not_null($data[$pre . 'state'])) $state = $data[$pre . 'state'];
    else if (not_null($data[$pre . 'zone_id'])) $state = zen_get_zone_code_from_id($zen, $data[$pre . 'zone_id']);
    if (not_null($data[$pre . 'country_id'])) $country = zen_get_country($zen, $data[$pre . 'country_id']);
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
//$debug_sql = 1;

check_db_has_sales_areas(_("You must first define at least one Sales Area"));


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
   	$last_cid = get_zen_import_pref('lastoid');

    // Get Default Tax Group
    $default_TaxGroup = get_zen_import_pref('taxgroup');
}

$num_price_errors = -1;

// Show information to connect to Zen Cart Database 
$action = $found ? 'cimport' : 'show';
if (isset($_GET['action']) && $found) $action = $_GET['action'];

if (isset($_POST['action'])) {
    $action = $_POST['action'];

    // Create Table
    if ($action == 'create') {
    	create_zen_prefs();
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
    } else {
        $dbHost = $db_Host;
        $dbUser = $db_User;
        $dbPassword = $db_Password;
        $dbName = $db_Name;
        $lastcid = $last_cid;
        $lastoid = $last_oid;
        $defaultTaxGroup = $default_TaxGroup;
    }
    
// Customer Import from Zen Cart Database
   if ($action == 'c_import') {
        $min_cid = 0;
        $max_cid = 0;
        if (isset($_POST['min_cid'])) $min_cid = $_POST['min_cid'];
        if (isset($_POST['max_cid'])) $max_cid = $_POST['max_cid'];


			$customers = zen_get_customers($min_cid, $max_cid);
            display_notification(sprintf(_("Found %d new customers"), db_num_rows($customers)));
            $i = $j = 0;
            while ($cust = mysql_fetch_assoc($customers)) {
                $email = $cust['customers_email_address'];
                $name = db_escape($cust['customers_firstname'] . ' ' . $cust['customers_lastname']);
                $contact = db_escape($cust['entry_firstname'] . ' ' . $cust['entry_lastname']);
                $addr = db_escape(zen_address_format($zen, $cust, 'entry_'));
                $tax_id = '';
                $phone = $cust['customers_telephone'];
                $fax = $cust['customers_fax'];
                $area_code = $_POST['area'];
                $currency = $_POST['currency'];

                $taxgid = get_tax_group_from_zone_id($zen, $cust['entry_zone_id'], $_POST['tax_group_id']);

                $sql = "SELECT debtor_no FROM ".TB_PREF."debtors_master WHERE name=$name";
                $result = db_query($sql,"customer could not be retrieved");
                $row = db_fetch_assoc($result);

                if (!$row) {
                    $sql = "INSERT INTO ".TB_PREF."debtors_master (name, address, tax_id, curr_code, sales_type, dimension_id, dimension2_id, payment_terms, credit_status, debtor_ref)
                            VALUES ($name, $addr, '$tax_id', '$currency', {$_POST['sales_type']},
                            {$_POST['dimension_id']}, {$_POST['dimension2_id']}, {$_POST['payment_terms']}, 1, $name)";
                    if (isset($debug_sql)) display_notification("INSERT DM " . $sql);
                    db_query($sql, "The customer could not be added");
                    $id = db_insert_id();
                    $sql = "INSERT INTO ".TB_PREF."cust_branch (debtor_no, br_name, br_address, area, salesman, contact_name, default_location, tax_group_id, sales_account,
                            sales_discount_account, receivables_account, payment_discount_account, br_post_address, branch_ref)
                            VALUES ($id, $name, $addr, '$area_code', '{$_POST['salesman']}', $contact, '{$_POST['default_location']}', $taxgid, '{$_POST['sales_account']}',
                            '{$_POST['sales_discount_account']}', '{$_POST['receivables_account']}',
                            '{$_POST['payment_discount_account']}', $addr, $name)";
                    if (isset($debug_sql)) display_notification("INSERT BR " . $sql);
                    db_query($sql, "The customer branch could not be added");

                    $i++;
                } else {
                    $sql = "UPDATE ".TB_PREF."debtors_master SET address=$addr, tax_id='$tax_id', address=$addr,
                            curr_code='$currency',
                            sales_type={$_POST['sales_type']},
                            dimension_id={$_POST['dimension_id']},
                            dimension2_id={$_POST['dimension2_id']},
                            payment_terms={$_POST['payment_terms']}
                            WHERE name=$name";

                    if (isset($debug_sql)) display_notification("UPDATE DM " . $sql);
                    db_query($sql, "The customer could not be updated");

/*                    if ($row['email'] != $email) { // Email is different, make a new branch
                        $sql = "INSERT INTO ".TB_PREF."cust_branch (debtor_no, br_name, br_address, area, salesman,
                                contact_name, default_location, tax_group_id, sales_account,
                                sales_discount_account, receivables_account, payment_discount_account, br_post_address, branch_ref)
                                VALUES ({$row['debtor_no']}, $name, $addr, '$area_code', '{$_POST['salesman']}', $contact, '{$_POST['default_location']}', $taxgid, '{$_POST['sales_account']}',
                                '{$_POST['sales_discount_account']}', '{$_POST['receivables_account']}',
                                '{$_POST['payment_discount_account']}', $addr, $name)";
                        if (isset($debug_sql)) display_notification("INSERT BR " . $sql);
                        db_query($sql, "The customer branch could not be added");
                    }
*/
                    $j++;
                }
                if ((int)$cust['customers_id'] > $lastcid) {
                    $sql = "UPDATE  ".TB_PREF."zencart SET value = " . $cust['customers_id'] . " WHERE name = 'lastcid'";
                    db_query($sql, "Update 'lastcid'");
                }
            }
            display_notification(sprintf(_("%d customer posts created, %d customer posts updated."), $i, $j));
    }

// Order Import from Zen Cart database
    if ($action == 'o_import') { 
        $first_oid = (int)$_POST['first_oid'];
        $last_oid = (int)$_POST['last_oid'];
        if (!not_null($first_oid) || !not_null($last_oid)) {
            $first_oid = 0;
            $last_oid = 0;
        }
            $sql = "SELECT * FROM orders WHERE orders_id >= $first_oid AND orders_id <= $last_oid";
            $oid_result = mysql_query($sql, $zen);
            display_notification(sprintf(_("Found %d New Orders"), mysql_num_rows($oid_result)));
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
                $date_purchased = array_pop(mysql_fetch_assoc($result));
                mysql_free_result($result);             
                
                $sql = "SELECT * FROM ".TB_PREF."debtors_master WHERE name=" . db_escape($order['customers_name']);
                $result = db_query($sql, "Cold not find customer by name");
                if (db_num_rows($result) == 0) {
                        display_notification(sprintf(_("Customer '%s' not found"), db_escape($order['customers_name'])));
                        break;
                }
                $customer = db_fetch_assoc($result);
                $addr = db_escape(zen_address_format($zen, $order, 'delivery_'));
                $taxgid = get_tax_group_from_zone_id($zen, $order['delivery_state'], $defaultTaxGroup);
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
                           $old_branch['default_location'] . "', $taxgid, '" . $old_branch['sales_account'] . "', '" .
                           $old_branch['sales_discount_account'] . "', '" . $old_branch['receivables_account'] . "', '" .
                           $old_branch['payment_discount_account'] . "', $addr, '" . $customer['name'] . "')";
                    db_query($sql_new, "The customer branch could not be added");
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
                $cart->phone = $branch['phone'];
                $cart->email = $branch['email'];
                $cart->freight_cost = $order_total['value'];
                $cart->Location = $branch['default_location'];
                $cart->due_date = $date_purchased;
                
      $sql = "SELECT orders_products.orders_id, orders_products_attributes.products_options_values, orders_products.products_priced_by_attribute, orders_products.products_quantity, orders_products.final_price, orders_products.products_id
FROM orders_products
LEFT JOIN orders_products_attributes ON orders_products_attributes.orders_products_id = orders_products.orders_products_id
WHERE orders_products.orders_id = $oID";
                
                $result = mysql_query($sql, $zen);

                while ($prod = mysql_fetch_assoc($result)) {
                        
         if ($prod['products_priced_by_attribute'] == 1) {
                 $prod['products_quantity'] = $prod['products_quantity'] * (int)$prod["products_options_values"];
                  }
                        print_r($prod['products_quantity']);
                        $prod['final_price'] = $prod['final_price'] / $prod['products_quantity'];
                    add_to_order($cart, $prod['products_id'], $prod['products_quantity'], $prod['final_price'], $customer['pymt_discount']);
                }
                mysql_free_result($result);
                $order_no = $cart->write(0);
                display_notification(sprintf(_("Added Order Number %d"), $order_no));
                
                if ($oID > $lastoid) {
                    $sql = "UPDATE  ".TB_PREF."zencart SET value = " . $oID . " WHERE name = 'lastoid'";
                    db_query($sql, "Update 'lastoid'");
                }
            }
            mysql_close($zen);
    }
    if ($action == 'p_check') { // Price Check
            $sql = "SELECT products_model, products_price FROM products WHERE products_status = 1";
            // echo $sql;
            $p_result = mysql_query($sql, $zen);
            $currency = $_POST['currency'];
            $sales_type = $_POST['sales_type'];
            $num_price_errors = 0;
            while ($pp = mysql_fetch_assoc($p_result)) {
                $price = $pp['products_price'];
                $model = $pp['products_model'];
                $myprice = false;
                if (check_stock_id($model)) $myprice = get_price($model, $currency, $sales_type);
                if ($myprice === false) display_notification(sprintf(_("'%s' price not found in FA"), $model));
                else if ($price != $myprice) {
                    display_notification(sprintf(_("'%s' Prices do not match - FA: %s zen: %s"), $model, price_format($myprice), price_format($price)));
                    $num_price_errors++;
                }
            }
        $action = 'pcheck';
    }
    if ($action == 'p_update') { // Price Update
            $sql = "SELECT products_model, products_price FROM products WHERE products_status = 1";
            $p_result = mysql_query($sql, $zen);
            $currency = $_POST['currency'];
            $sales_type = $_POST['sales_type'];
            $num_price_errors = 0;
            while ($pp = mysql_fetch_assoc($p_result)) {
                $price = $pp['products_price'];
                $model = $pp['products_model'];
                $myprice = false;
                if (check_stock_id($model)) $myprice = get_price($model, $currency, $sales_type);
                if ($myprice === false) display_notification(sprintf(_("'%s' price not found in FA"), $model));
                else if ($price != $myprice) {
                    display_notification(sprintf(_("Updating '%s' from %s to %s"), $model, price_format($price), price_format($myprice)));
                    $sql = "UPDATE products SET products_price = $myprice WHERE products_model = '$model'";
                    mysql_query($sql, $zen);
                    $num_price_errors++;
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

page(_($help_context = "Zen Cart Interface"));
//if ($action == 'show') echo 'Summary';
//else hyperlink_params($_SERVER['PHP_SELF'], _("Summary"), "action=summary", false);
//echo '&nbsp;|&nbsp;';
if ($action == 'show') echo 'Configuration';
else hyperlink_params($_SERVER['PHP_SELF'], _("Configuration"), "action=show", false);
echo '&nbsp;|&nbsp;';
if ($action == 'cimport') echo 'Customer Import';
else hyperlink_params($_SERVER['PHP_SELF'], _("&Customer Import"), "action=cimport", false);
echo '&nbsp;|&nbsp;';
if ($action == 'oimport') echo 'Order Import';
else hyperlink_params($_SERVER['PHP_SELF'], _("&Order Import"), "action=oimport", false);
echo '&nbsp;|&nbsp;';
//if ($action == 'pcheck') echo 'Price Check';
//else hyperlink_params($_SERVER['PHP_SELF'], _("&Price Check"), "action=pcheck", false);
//echo '&nbsp;|&nbsp;';
//if ($action == 'pupdate') echo 'Update Prices';
//else hyperlink_params($_SERVER['PHP_SELF'], _("&Update Prices"), "action=pupdate", false);
//echo "<br><br>";

include($path_to_root . "/includes/ui.inc");

if ($action == 'show') {
        
    start_form(true);
    start_table(TABLESTYLE2, "width=40%");

    $th = array(_("Function"), _("Description"));
    table_header($th);

    $k = 0;

    alt_table_row_color($k);

    label_cell(_("Table Status"));
    if ($found) $table_st = _("Found");
    else $table_st = "<font color=red>"._("Not Found")."</font>";
    label_cell($table_st);
    end_row();

    text_row(_("Mysql Host"), 'dbHost', $dbHost, 20, 40);

    text_row(_("User"), 'dbUser', $dbUser, 20, 40);

    text_row(_("Password"), 'dbPassword', $dbPassword, 20, 40);

    text_row(_("ZenCart DB Name"), 'dbName', $dbName, 20, 40);
    tax_groups_list_row(_("Default Tax Group:"), 'taxgroup', $default_TaxGroup);

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

    table_section_title(_("Default GL Accounts"));

    $company_record = get_company_prefs();

    if (!isset($_POST['sales_account']) || $_POST['sales_account'] == "")
            $_POST['sales_account'] = $company_record["default_sales_act"];

    if (!isset($_POST['sales_discount_account']) || $_POST['sales_discount_account'] == "")
            $_POST['sales_discount_account'] = $company_record["default_sales_discount_act"];

    if (!isset($_POST['receivables_account']) || $_POST['receivables_account'] == "")
            $_POST['receivables_account'] = $company_record["debtors_act"];

    if (!isset($_POST['payment_discount_account']) || $_POST['payment_discount_account'] == "")
            $_POST['payment_discount_account'] = $company_record["default_prompt_payment_act"];

    gl_all_accounts_list_row(_("Sales Account:"), 'sales_account', $_POST['sales_account']);
    gl_all_accounts_list_row(_("Sales Discount Account:"), 'sales_discount_account', $_POST['sales_discount_account']);
    gl_all_accounts_list_row(_("Receivables Account:"), 'receivables_account', $_POST['receivables_account']);
    gl_all_accounts_list_row(_("Payment Discount Account:"), 'payment_discount_account', $_POST['payment_discount_account']);

    $dim = get_company_pref('use_dimension');
    if ($dim < 1)
        hidden('dimension_id', 0);
    if ($dim < 2)
        hidden('dimension2_id', 0);

    table_section_title(_("Location, Tax Type, Sales Type, Sales Person and Payment Terms"));
    locations_list_row(_("Location:"), 'default_location', null);
    tax_groups_list_row(_("Default Tax Group:"), 'tax_group_id', $default_TaxGroup);
    sales_types_list_row(_("Sales Type:"), 'sales_type', null);
    sales_persons_list_row(_("Sales Person:"), 'salesman', null);
    sales_areas_list_row(_("Sales Area:"), 'area');
    currencies_list_row(_("Customer Currency:"), 'currency', get_company_pref("curr_default"));
    payment_terms_list_row(_("Payment Terms:"), 'payment_terms', null);
    if ($dim >= 1)
        dimensions_list_row(_("Dimension")." 1:", 'dimension_id', null, true, " ", false, 1);
    if ($dim > 1)
        dimensions_list_row(_("Dimension")." 2:", 'dimension2_id', null, true, " ", false, 2);
    text_row(_("Starting Zen Cart Customer ID:"), 'min_cid', $min_cid, 6, 6);
    text_row(_("Ending Zen Cart Customer ID:"), 'max_cid', $max_cid, 6, 6);

    end_table(1);

    hidden('action', 'c_import');
    submit_center('cimport', _("Import Zen Cart Customers"));

    end_form();
    end_page();
}
if ($action == 'oimport') {

    start_form(true);

    start_table(TABLESTYLE2, "width=40%");

    table_section_title(_("Order Import Options"));

    text_row(_("Starting Order Number:"), 'first_oid', $min_oid, 8, 8);
    text_row(_("Last Order Number:"), 'last_oid', $max_oid, 8, 8);

    end_table(1);

    hidden('action', 'o_import');
    submit_center('oimport', _("Import Zen Cart Orders"));

    end_form();
    end_page();
}
if ($action == 'pcheck') {

    start_form(true);

    start_table(TABLESTYLE2, "width=40%");

    table_section_title(_("Price Check Options"));

    $company_record = get_company_prefs();

    currencies_list_row(_("Customer Currency:"), 'currency', get_company_pref("curr_default"));
    sales_types_list_row(_("Sales Type:"), 'sales_type', null);

    end_table(1);

    hidden('action', 'p_check');
    submit_center('pcheck', _("Check Zen Cart Prices"));
    if ($num_price_errors == 0) display_notification(_("No Pricing Errors Found"));

    end_form();

    hyperlink_params($_SERVER['PHP_SELF'], _("Refresh"), "action=pcheck");
    end_page();
}
if ($action == 'pupdate') {

    start_form(true);

    start_table(TABLESTYLE2, "width=40%");

    table_section_title(_("Update Price Options"));

    $company_record = get_company_prefs();

    currencies_list_row(_("Customer Currency:"), 'currency', get_company_pref("curr_default"));
    sales_types_list_row(_("Sales Type:"), 'sales_type', null);

    end_table(1);

    hidden('action', 'p_update');
    submit_center('pupdate', _("Update Zen Cart Prices"));
    if ($num_price_errors > 0) display_notification(_("There were $num_price_errors prices updated"));

    end_form();
    end_page();
}
?>
