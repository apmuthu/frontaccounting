<?php
/**********************************************
Author: Andres Amaya
Name: Items Costs API
Free software under GNU GPL
***********************************************/

$path_to_root = "../..";

include_once($path_to_root . "/includes/db/inventory_db.inc");
include_once($path_to_root . "/inventory/includes/db/items_trans_db.inc");

function itemcosts_get($id)
{

	$cost = get_standard_cost($id);
	api_success_response(json_encode( array('stock_id' => $id, 'standard_cost' => $cost) ));

}

function itemcosts_update($id){

	$app = \Slim\Slim::getInstance('SASYS');
	$req = $app->request();
	$info = $req->post();

	$oldcost = get_standard_cost($id);
	
	$update_no = stock_cost_update($id,
		    $info['material_cost'], $info['labour_cost'],
		    $info['overhead_cost'],	$old_cost);
	
	api_success_response(json_encode( array('stock_id' => $id, 'rate' => $rate) ));

}

?>