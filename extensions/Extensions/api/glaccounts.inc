<?php
/**********************************************
Author: Andres Amaya
Name: GL Accounts API
Free software under GNU GPL
***********************************************/

$path_to_root = "../..";

include_once($path_to_root . "/gl/includes/db/gl_db_accounts.inc");
include_once($path_to_root . "/gl/includes/db/gl_db_account_types.inc");

function glaccounts_all()
{

	$accounts = get_gl_accounts();
	$ret = array();
	while($acct = db_fetch($accounts)){
		
		$ret[] = array(
			'account_code' => $acct['account_code'],
			'account_name' => $acct['account_name'],
			'account_type' => $acct['account_type'],
			'account_code2' => $acct['account_code2']
		);
		
	}
	api_success_response(json_encode($ret));

}

function glaccounts_get($id){
	
	$acct = get_gl_account($id);
	if(!$acct) $acct = array();
	api_success_response(json_encode($acct));
	
}

function glaccounttypes_all()
{

	$accttypes = get_account_types();
	$ret = array();
	while($type = db_fetch($accttypes)){
		
		$ret[] = array(
			'id' => $type['id'],
			'name' => $type['name'],
			'class_id' => $type['class_id'],
			'parent' => $$type['parent']
		);
		
	}
	api_success_response(json_encode($ret));
	
}

?>