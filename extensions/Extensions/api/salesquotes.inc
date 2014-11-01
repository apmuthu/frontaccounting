<?php
/**********************************************
Author: Andres Amaya
Name: Sales Quotes API
Free software under GNU GPL
***********************************************/

$path_to_root = "../..";

include_once($path_to_root . "/sales/includes/cart_class.inc");
include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/sales/includes/sales_db.inc");

function salesquotes_get($id){
	
	try{
		$doc = new Cart(ST_SALESQUOTE, $id);
	
		$sub_tot = $doc->get_items_total() + $doc->freight_cost;
		$display_sub_tot = price_format($sub_tot);
		
		$display_total = $doc->get_trans_total();
		
		$ret = array();
		$ret['trans_type'] = $doc->trans_type;
		$ret['trans_no'] = $id;
		$ret['line_items'] = $doc->line_items;
		$ret['document_date'] = $doc->document_date;
		$ret['due_date'] = $doc->due_date;
		$ret['sales_type'] = $doc->sales_type;
		$ret['sales_type_name'] = $doc->sales_type_name;
		$ret['tax_included'] = $doc->tax_included;
		$ret['customer_currency'] = $doc->customer_currency;
		$ret['default_discount'] = $doc->default_discount;
		$ret['customer_name'] = $doc->customer_name;
		$ret['customer_id'] = $doc->customer_id;
		$ret['Branch'] = $doc->Branch;
		$ret['email'] = $doc->email;
		$ret['deliver_to'] = $doc->deliver_to;
		$ret['delivery_address'] = $doc->delivery_address;
		$ret['phone'] = $doc->phone;
		$ret['cust_ref'] = $doc->cust_ref;
		$ret['reference'] = $doc->reference;
		$ret['Comments'] = $doc->Comments;
		$ret['Location'] = $doc->Location;
		$ret['location_name'] = $doc->location_name;
		$ret['order_no'] = $doc->order_no;
		$ret['ship_via'] = $doc->ship_via;
		$ret['freight_cost'] = $doc->freight_cost;
		$ret['tax_group_id'] = $doc->tax_group_id;
		$ret['tax_group_name'] = $doc->tax_group_name;
		$ret['tax_group_array'] = $doc->tax_group_array;
		$ret['price_factor'] = $doc->price_factor;
		$ret['pos'] = $doc->pos;
		$ret['cash_discount'] = $doc->cash_discount;
		$ret['dimension_id'] = $doc->dimension_id;
		$ret['dimension2_id'] = $doc->dimension2_id;
		$ret['payment'] = $doc->payment;
		$ret['payment_terms'] = $doc->payment_terms;
		$ret['credit'] = $doc->credit;
		$ret['sub_tot'] = $sub_tot;
		$ret['display_total'] = $display_total;
	} catch(Exception $e){
		api_error(404, $e->getMessage());
	}
	
	api_success_response(json_encode($ret));
	
}


function salesquotes_add($id){
	
	/*
		
		Items[], reference, Comments, document_date, delivery_date, cust_ref, delivery_address, phone, ship_via, Location, freight_cost, email,
		customer_id, Branch, sales_type, trans_type=QUOTE, dimension_id, dimension2_id, payment, payment_terms
		
	*/
	
	
	
}

?>