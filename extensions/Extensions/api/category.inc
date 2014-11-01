<?php
/**********************************************
Author: Andres Amaya
Name: Items Category API
Free software under GNU GPL
***********************************************/

$path_to_root = "../..";

include_once($path_to_root . "/inventory/includes/db/items_category_db.inc");

function category_all(){

	$categos = get_item_categories(false);
	$ret = array();
	while($cat = db_fetch($categos)){
		
		$ret[] = array(
			'category_id' => $cat['category_id'],
			'description' => $cat['description'],
			'dflt_tax_type' => $cat['dflt_tax_type'],
			'dflt_units' => $cat['dflt_units'],
			'dflt_mb_flag' => $cat['dflt_mb_flag'],
			'dflt_sales_act' => $cat['dflt_sales_act'],
			'dflt_cogs_act' => $cat['dflt_cogs_act'],
			'dflt_inventory_act' => $cat['dflt_inventory_act'],
			'dflt_adjustment_act' => $cat['dflt_adjustment_act'],
			'dflt_assembly_act' => $cat['dflt_assembly_act'],
			'dflt_no_sale' => $cat['dflt_no_sale']
		);
		
	}
	api_success_response(json_encode($ret));
	
}

function category_get($id)
{
	
	$catego = get_item_category($id);
	if(!$catego) $catego = array();
	api_success_response(json_encode($catego));
	
}

function category_add()
{

	$app = \Slim\Slim::getInstance('SASYS');
	$req = $app->request();
	$info = $req->post();
	
	// Validate Required Fields
	if(!isset($info['description'])){
		api_error(412, 'Description is required');
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
	$description, $tax_type_id, $sales_account, 
	$cogs_account, $inventory_account, $adjustment_account, $assembly_account, 
	$units, $mb_flag, $dim1, $dim2, $no_sale
	*/
	add_item_category($info['description'], $info['tax_type_id'], 
		$info['sales_account'],
		$info['cogs_account'], 
		$info['inventory_account'],
		$info['adjustment_account'],
		$info['assembly_account'],
		$info['units'],
		$info['mb_flag'],
		0, // dimension 1
		0, // dimension2
		0 // no sale
		);
	
	$id = db_insert_id();
	$catego = get_item_category($id);
	
	if($catego != null){
		api_create_response(json_encode($catego));
	}else {
		api_error(500, 'Could Not Save to Database');
	}
	
}

function category_edit($id){
	
	$app = \Slim\Slim::getInstance('SASYS');
	$req = $app->request();
	$info = $req->post();
	
	$catego = get_item_category($id);
	if($catego == null){
		api_error(400, 'Invalid Category ID');
	}
	
	// Validate Required Fields
	if(!isset($info['description'])){
		api_error(412, 'Description is required');
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
	$id, $description, $tax_type_id, 
	$sales_account, $cogs_account, $inventory_account, $adjustment_account, 
	$assembly_account, $units, $mb_flag, $dim1, $dim2, $no_sale
	*/
	update_item_category($id, $info['description'], $info['tax_type_id'], 
		$info['sales_account'],
		$info['cogs_account'], 
		$info['inventory_account'],
		$info['adjustment_account'],
		$info['assembly_account'],
		$info['units'],
		$info['mb_flag'],
		0, // dimension 1
		0, // dimension2
		0 // no sale
		);
	
	api_success_response("Category has been updated");
	
}

function category_delete($id){
	
	$app = \Slim\Slim::getInstance('SASYS');
	$req = $app->request();
	$info = $req->post();
	
	$catego = get_item_category($id);
	if($catego == null){
		api_error(400, 'Invalid Category ID');
	}
	
	delete_item_category($id);
	
	$catego = get_item_category($id);
	
	if($catego != null){
		api_error(500, 'Could Not Delete from Database: ');
	}else {
		api_success_response("Category has been deleted");
	}
	
}

?>