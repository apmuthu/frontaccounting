<?php
/**********************************************
Author: Andres Amaya
Name: Fixed Assets API
Free software under GNU GPL
***********************************************/

$path_to_root = "../..";

include_once($path_to_root . "/modules/asset_register/includes/db/assets_db.inc");
include_once($path_to_root . "/modules/asset_register/includes/db/asset_types_db.inc");

function assets_get($id)
{

	$asset = get_asset($id);
	api_success_response(json_encode( $asset ));

}

function assets_add()
{

	$app = \Slim\Slim::getInstance('SASYS');
	$req = $app->request();
	$info = $req->post();

	// Validate Required Fields
	if(!isset($info['asset_type_id'])){
		api_error(412, 'Asset Type is required [asset_type_id]');
	}
	if(!isset($info['asset_name'])){
		api_error(412, 'Asset Name is required [asset_name]');
	}
	if(!isset($info['asset_serial'])){
		api_error(412, 'Asset Serial Number is required [asset_serial]');
	}
	if(!isset($info['purchase_date'])){
		api_error(412, 'Purchase Date is required [purchase_date]');
	}
	if(!isset($info['purchase_value'])){
		api_error(412, 'Purchase Value is required [purchase_value]');
	}
	if(!isset($info['tag_number'])){
		api_error(412, 'Tag Number is required [tag_number]');
	}
	if(!isset($info['asset_location'])){
		api_error(412, 'Asset Location is required [asset_location]');
	}
	if(!isset($info['asset_condition'])){
		api_error(412, 'Asset Condition is required [asset_condition]');
	}
	if(!isset($info['asset_acquisition'])){
		api_error(412, 'Asset Acquisition is required [asset_acquisition]');
	}

	/*
	$type, $name, $serial, $purchase_date, $purchase_value, $tag, $location, $condition, $acquisition

	asset_type_id,  asset_name,  asset_serial,  purchase_date,  purchase_value,
			tag_number, asset_location, asset_condition, asset_acquisition
	*/
	add_asset($info['asset_type_id'], $info['asset_name'],
		$info['asset_serial'],
		$info['purchase_date'],
		$info['purchase_value'],
		$info['tag_number'],
		$info['asset_location'],
		$info['asset_condition'],
		$info['asset_acquisition']
		);

	$id = db_insert_id();
	$asset = get_asset($id);

	if($asset != null){
		api_create_response(json_encode($asset));
	}else {
		api_error(500, 'Could Not Save to Database');
	}

}

function assettypes_get()
{

	$assettypes = get_all_asset_types();
	$ret = array();
	while($atype = db_fetch($assettypes)){
		// asset_type_name, depreciation_rate, asset_account, depreciation_account, accumulated_account, valuation_account, disposal_account
		$ret[] = array(
			'asset_type_id' => $atype['asset_type_id'],
			'asset_type_name' => $atype['asset_type_name'],
			'depreciation_rate' => $atype['depreciation_rate'],
			'depreciation_account' => $atype['depreciation_account'],
			'accumulated_account' => $atype['accumulated_account'],
			'valuation_account' => $atype['valuation_account'],
			'disposal_account' => $atype['disposal_account'],
			'asset_account' => $atype['asset_account']
		);

	}
	api_success_response(json_encode($ret));

}

?>