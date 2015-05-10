<?php

include_once($path_to_root . "/modules/import_transactions/includes/import_sales_cart_class.inc"); // adaptation of cart class
include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/sales/includes/sales_ui.inc");
include_once($path_to_root . "/sales/includes/ui/sales_order_ui.inc");
include_once($path_to_root . "/sales/includes/sales_db.inc");
include_once($path_to_root . "/sales/includes/db/sales_types_db.inc");
include_once($path_to_root . "/reporting/includes/reporting.inc");

function can_process($line, $customer_id, $branchNo, $reference, $date, $dimension_id, $dimension2_id, $freightcost=0, $delfrom, $deldate, $delto, $deladdress, $contactphone, $email, $custref, $shipvia, $comments,$exrate) {

	global $Refs, $SysPrefs;

	if (empty($customer_id)) 
	{
		display_error(_("On line $line there is no customer input."));
		return false;
	} 
	       
        if (empty($branchNo)) 
	{
	    display_error(_("On line $line this customer has no branch defined."));
	    return false;
	} 
        
        if (!customer_branch_exists($customer_id, $branchNo))
        {
            display_error(_("On line $line this branch number does not exist for this customer."));
            return false;
        }    
        
        if (!$Refs->is_valid($reference)) {
		display_error(_("On line $line you must enter a reference."));
		return false;
	}
	if (empty($date)) {
		display_error(_("On line $line you must enter a valid date."));
		return false;
	}
        if ($_SESSION['Items']->trans_type!=ST_SALESORDER && $_SESSION['Items']->trans_type!=ST_SALESQUOTE && !is_date_in_fiscalyear($date)) {
		display_error(_("On line $line the entered date is not in the fiscal year"));
		return false;
	}
	if (!$SysPrefs->allow_negative_stock() && ($low_stock = $_SESSION['Items']->check_qoh()))
	{
		display_error(_("Line $line cannot be processed because there is insufficient quantity for items marked."));
		return false;
	}
	if ($_SESSION['Items']->payment_terms['cash_sale'] == 0) {

		if (strlen($delto) <= 1) {
			display_error(_("On line $line you must enter the person or company to whom delivery should be made to."));
			return false;
		}
		
                if ($_SESSION['Items']->trans_type != ST_SALESQUOTE && strlen($deladdress) <= 1) {
			display_error( _("On line $line you should enter the street address in the box provided. Orders cannot be accepted without a valid street address."));
			return false;
		}

		if (empty($freightcost)||($freightcost = ""))
                {
                    $freightcost = price_format(0);
                }
                
		if (!is_numeric($freightcost)) {
			display_error(_("On line $line the shipping cost of $freightcost entered is expected to be numeric."));
			return false;
		}
		
                if (!is_date($deldate)) {
			if ($_SESSION['Items']->trans_type==ST_SALESQUOTE)
				display_error(_("On line $line the valid date is invalid."));
			else	
				display_error(_("On line $line the delivery date is invalid."));
			return false;
		}
		
                if (date1_greater_date2($date, $deldate)) {
			if ($_SESSION['Items']->trans_type==ST_SALESQUOTE)
				display_error(_("On line $line the requested valid date is before the date of the quotation."));
			else	
				display_error(_("On line $line the requested delivery date is before the date of the order."));
			return false;
		}
	}
	else
	{
		if (!db_has_cash_accounts())
		{
			display_error(_("On line $line you need to define a cash account for your Sales Point."));
			return false;
		}	
	}	
	
	if (!db_has_currency_rates($_SESSION['Items']->customer_currency, $date))
		return false;
	
   	if ($_SESSION['Items']->get_items_total() < 0) {
		display_error("On line $line the invoice total amount cannot be less than zero.");
		return false;
	}
	return true;
}

function check_import_item_data($line_no, $item_code, $item_description, $quantity, $unit, $price, $discountpercentage)
{
	global $SysPrefs, $allow_negative_prices;
	$is_inventory_item = is_inventory_item($item_code);
	if(empty($item_description)) {
		display_error( _("Item description cannot be empty."));
		return false;
	}
	elseif (!is_numeric($quantity) || !is_numeric($discountpercentage)) {
		display_error( _("The item could not be updated because you are attempting to set the quantity ordered to less than 0, or the discount percent to more than 100."));
		return false;
	} elseif (!is_numeric($price) && (!$allow_negative_prices || $is_inventory_item)) {
		display_error( _("Price for inventory item must be entered and can not be less than 0"));
		return false;
	} elseif (isset($line_no) && isset($_SESSION['Items']->line_items[$line_no])
	    && !is_numeric($_SESSION['Items']->line_items[$line_no]->qty_done)) {
		display_error(_("You are attempting to make the quantity ordered a quantity less than has already been delivered. The quantity delivered cannot be modified retrospectively."));
		return false;
	}

	$cost_home = get_standard_cost($item_code); // Added 2011-03-27 Joe Hunt
	$cost = $cost_home / get_exchange_rate_from_home_currency($_SESSION['Items']->customer_currency, $_SESSION['Items']->document_date);
        if (($price) < $cost)
	{
		$dec = user_price_dec();
                $curr = $_SESSION['Items']->customer_currency;
                $price = number_format2($price, $dec);
                if ($cost_home == $cost)
			$std_cost = number_format2($cost_home, $dec);
		else
		{
			$price = $curr . " " . $price;
                        $std_cost = $curr . " " . number_format2($cost, $dec);
		}
               display_notification_centered(sprintf(_("Item $item_code's price on line $line_no of %s is below Standard Cost of %s"), $price, $std_cost));
	}
        
	return true;
}

function copy_to_cart($customer_id, $branchNo, $sales_type_name, $reference, $date, $payment_id, $dimension_id, $dimension2_id, $freightcost, $delfrom, $deldate, $delto, $deladdress, $contactphone, $email, $custref, $shipvia, $comments,$exrate)
{
	        
        $cart = &$_SESSION['Items'];
        $cart->customer_id = $customer_id;
        $myrow = get_customer($customer_id);
        $cart->customer_name = $myrow["name"];
        $cart->Branch = $branchNo;
        //sales_type eg. Retail, Wholesale id=1 or 2 respectively 
        $cart->sales_type_name = $sales_type_name;
        $cart->sales_type = get_sales_type_id($sales_type_name);
        //$cart->sales_type = 1; //assigned to order_type
        $cart->reference = $reference;
        $cart->document_date = $date;
        //initialise newpayment
	$newpayment = false;

	if (!empty($payment_id) && ($cart->payment != $payment_id)) {
		$cart->payment = $payment_id;
		$cart->payment_terms = get_payment_terms($payment_id);
		$newpayment = true;
	}
        
	if ($cart->payment_terms['cash_sale']) 
        {
		if ($newpayment) {
			$cart->due_date = $cart->document_date;
			$cart->phone = $cart->cust_ref = $cart->delivery_address = '';
			$cart->ship_via = 0;
			$cart->deliver_to = '';
		}
                
	} else {
		$cart->due_date = $deldate;
		$cart->cust_ref = $custref;
		$cart->deliver_to = $delto;
		$cart->delivery_address = $deladdress;
		$cart->phone = $contactphone;
		$cart->ship_via = $shipvia;
	}
        
	$cart->Location = $delfrom;
	$cart->freight_cost = $freightcost;
	if (!empty($email))
		$cart->email =$email;
	else
		$cart->email = '';
	if ($cart->trans_type!=ST_SALESORDER && $cart->trans_type!=ST_SALESQUOTE) { // 2008-11-12 Joe Hunt
		$cart->dimension_id = $dimension_id;
		$cart->dimension2_id = $dimension2_id;
	}
           
        $cart->ex_rate = $exrate;
        $cart->Comments =  $comments;
        $_SESSION['Items'] = $cart;
}

function get_sales_type_id($sales_type_name)
{
	$sql = "SELECT id FROM ".TB_PREF."sales_types WHERE sales_type=".db_escape($sales_type_name);
	
	$result = db_query($sql, "could not get sales type id");
	
	$row = db_fetch_row($result);
	return $row[0];
}

function customer_branch_exists($customer_id, $branchNo)
{
        $sql = "SELECT * FROM ".TB_PREF."cust_branch WHERE branch_code=".db_escape($branchNo)." AND debtor_no = ".db_escape($customer_id);
        $result = db_query($sql, "could not query customer branch records.");
	if (db_num_rows($result) > 0) {return true;} else {return false;} 	
}


