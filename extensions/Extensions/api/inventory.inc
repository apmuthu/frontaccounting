<?php
/**********************************************
Author: Andres Amaya
Name: Inventory REST API
Free software under GNU GPL
***********************************************/

$path_to_root = "../..";

include_once($path_to_root . "/inventory/includes/inventory_db.inc");
include_once($path_to_root . "/inventory/includes/db/items_codes_db.inc");
include_once($path_to_root . "/inventory/includes/db/movement_types_db.inc");
include_once($path_to_root . "/inventory/includes/db/items_locations_db.inc");
include_once($path_to_root . "/includes/ui/items_cart.inc");

function inventory_all()
{

	$items = get_items();
	$ret = array();
	while($itm = db_fetch($items)){
		
		$ret[] = array(
			'stock_id' => $itm['stock_id'],
			'category_id' => $itm['category_id'],
			'tax_type_id' => $itm['tax_type_id'],
			'description' => $itm['description'],
			'long_description' => $itm['long_description'],
			'units' => $itm['units'],
			'mb_flag' => $itm['mb_flag'],
			'sales_account' => $itm['sales_account'],
			'cogs_account' => $itm['cogs_account'],
			'inventory_account' => $itm['inventory_account'],
			'sales_account' => $itm['sales_account'],
			'adjustment_account' => $itm['adjustment_account'],
			'actual_cost' => $itm['actual_cost'],
			'material_cost' => $itm['material_cost'],
			'labour_cost' => $itm['labour_cost'],
			'overhead_cost' => $itm['overhead_cost'],
			'inactive' => $itm['inactive'],
			'no_sale' => $itm['no_sale']
		);
		
	}
	api_success_response(json_encode($ret));

}

function inventory_get($id)
{
	
	$item = get_item($id);
	if(!$item) $item = array();
	api_success_response(json_encode($item));

}

function inventory_add()
{
	$app = \Slim\Slim::getInstance('SASYS');
	$req = $app->request();
	$info = $req->post();
	
	// Validate Required Fields
	if(!isset($info['stock_id'])){
		api_error(412, 'Stock Id is required');
	}
	if(!isset($info['description'])){
		api_error(412, 'Description is required');
	}
	if(!isset($info['long_description'])){
		$info['long_description'] = $info['description'];
	}
	if(!isset($info['category_id'])){
		api_error(412, 'Category Id is required');
	}
	if(!isset($info['tax_type_id'])){
		api_error(412, 'Tax Type is required');
	}
	if(!isset($info['units'])){
		api_error(412, 'Units is required');
	}
	if(!isset($info['mb_flag'])){
		api_error(412, 'MB Flag is required');
	}
	if(!isset($info['sales_account'])){
		api_error(412, 'Sales Account is required');
	}
	if(!isset($info['cogs_account'])){
		api_error(412, 'Cogs Account is required');
	}
	if(!isset($info['adjustment_account'])){
		api_error(412, 'Adjustment Account is required');
	}
	if(!isset($info['assembly_account'])){
		api_error(412, 'Assembly Account is required');
	}
	
	// TODO Validate Stock Id is Unique
	
	/*
	$stock_id, $description, $long_description, $category_id, 
	$tax_type_id, $units, $mb_flag,	$sales_account, $inventory_account, 
	$cogs_account, $adjustment_account,	$assembly_account, $dimension_id, 
	$dimension2_id, $no_sale, $editable
	*/
	add_item($info['stock_id'], $info['description'], $info['long_description'], $info['category_id'], $info['tax_type_id'], 
		$info['units'],
		$info['mb_flag'],
		$info['sales_account'],
		$info['inventory_account'],
		$info['cogs_account'], 
		$info['adjustment_account'],
		$info['assembly_account'],
		0, // dimension 1
		0, // dimension2
		0, // no sale
		1 // editable
		);
	
	$itm = get_item($info['stock_id']);
	
	if($itm != null){
		api_create_response(json_encode($itm));
	}else {
		api_error(500, 'Could Not Save to Database');
	}
	
}

function inventory_edit($id)
{

	$app = \Slim\Slim::getInstance('SASYS');
	$req = $app->request();
	$info = $req->post();
	
	$itm = get_item($id);
	if($itm == null){
		api_error(400, 'Invalid Stock Id');
	}
	
	// Validate Required Fields
	if(!isset($info['description'])){
		api_error(412, 'Description is required');
	}
	if(!isset($info['long_description'])){
		$info['long_description'] = $info['description'];
	}
	if(!isset($info['category_id'])){
		api_error(412, 'Category Id is required');
	}
	if(!isset($info['tax_type_id'])){
		api_error(412, 'Tax Type is required');
	}
	if(!isset($info['units'])){
		api_error(412, 'Units is required');
	}
	if(!isset($info['mb_flag'])){
		api_error(412, 'MB Flag is required');
	}
	if(!isset($info['sales_account'])){
		api_error(412, 'Sales Account is required');
	}
	if(!isset($info['cogs_account'])){
		api_error(412, 'Cogs Account is required');
	}
	if(!isset($info['adjustment_account'])){
		api_error(412, 'Adjustment Account is required');
	}
	if(!isset($info['assembly_account'])){
		api_error(412, 'Assembly Account is required');
	}
	
	/*
	$stock_id, $description, $long_description, $category_id, 
	$tax_type_id, $units='', $mb_flag='', $sales_account, $inventory_account, 
	$cogs_account, 	$adjustment_account, $assembly_account, $dimension_id, 
	$dimension2_id, $no_sale, $editable
	*/
	update_item($info['stock_id'], $info['description'], $info['long_description'], $info['category_id'], $info['tax_type_id'], 
		$info['units'],
		$info['mb_flag'],
		$info['sales_account'],
		$info['inventory_account'],
		$info['cogs_account'], 
		$info['adjustment_account'],
		$info['assembly_account'],
		0, // dimension 1
		0, // dimension2
		0, // no sale
		1 // editable
		);
	
	api_success_response("Item has been updated");

}

function inventory_delete($id)
{

	$app = \Slim\Slim::getInstance('SASYS');
	$req = $app->request();
	$info = $req->post();
	
	$itm = get_item($id);
	if($itm == null){
		api_error(400, 'Invalid Stock Id');
	}
	
	delete_item($id);
	
	$itm = get_item($info['stock_id']);
	
	if($itm != null){
		api_error(500, 'Could Not Delete from Database');
	}else {
		api_success_response("Item has been deleted");
	}

}

function inventory_movementstype_all()
{
	
	$movtypes = get_all_movement_type(false);
	$ret = array();
	while($mov = db_fetch($movtypes)){
		
		$ret[] = array(
			'id' => $mov['id'],
			'name' => $mov['name']
		);
		
	}
	api_success_response(json_encode($ret));
}

function inventory_locations_all()
{

	$locations = get_item_locations(false);
	$ret = array();
	while($loc = db_fetch($locations)){
		
		$ret[] = array(
			'loc_code' => $loc['loc_code'],
			'location_name' => $loc['location_name'],
			'delivery_address' => $$loc['inactive'],
			'phone' => $loc['phone'],
			'phone2' => $loc['phone2'],
			'fax' => $loc['fax'],
			'email' => $loc['email'],
			'contact' => $loc['contact']
		);
		
	}
	api_success_response(json_encode($ret));
	
}

function stock_adjustment_add($info)
{

	$app = \Slim\Slim::getInstance('SASYS');
	$req = $app->request();
	$info = $req->post();
	
	// Example
	//$ex = array('stock_id' => 'PLUMA', 'location' => 'DEF', 'date' => today(), 'type' => 1, 'reference' => '123qwe', 'quantity' => 555, 'standard_cost' => 10, 'increase' => 0, 'memo' => 'PRUEBA DESDE API 2');
	//echo base64_encode(json_encode($ex));	
	//print_r($info);
	
	// Validate Required Fields
	if(!isset($info['stock_id'])){
		api_error(412, 'Stock Id is required');
	}
	if(!isset($info['location'])){
		api_error(412, 'Location is required');
	}
	if(!isset($info['date'])){
		api_error(412, 'Date is required');
	}
	if(!isset($info['type'])){
		api_error(412, 'Movement Type is required');
	}
	if(!isset($info['reference'])){
		api_error(412, 'Reference is required');
	}
	if(!isset($info['quantity'])){
		api_error(412, 'Quantity is required');
	}
	if(!isset($info['standard_cost'])){
		$info['standard_cost'] = 0;
	}
	if(!isset($info['increase'])){
		api_error(412, 'Increase is required. (1 = true, 0 = false)');
	}
	if(!isset($info['memo'])){
		api_error(412, 'Memo is required');
	}
	
	// Create Adjustment Order
	unset ($_SESSION['adj_items']);
	$_SESSION['adj_items'] = new items_cart(ST_INVADJUST);
	$info['date'] = today();
	if (!is_date_in_fiscalyear($info['date']))
		$info['date'] = end_fiscalyear();
	$_SESSION['adj_items']->tran_date = $info['date'];  
	// This should never happen
	if ($_SESSION['adj_items']->find_cart_item($info['stock_id']))
         api_error(500, 'Item Already Exists In Cart');
	else
         $_SESSION['adj_items']->add_to_cart(count($_SESSION['adj_items']->line_items), $info['stock_id'], $info['quantity'], $info['standard_cost']);
	
	// Process Order
	$trans_no = add_stock_adjustment($_SESSION['adj_items']->line_items,
		$info['location'], $info['date'], $info['type'], $info['increase'],
		$info['reference'], $info['memo']);
		
	new_doc_date($info['date']);
	$_SESSION['adj_items']->clear_items();
	unset($_SESSION['adj_items']);
	
	api_create_response("Stock Adjustment has been added");
	
}

?>