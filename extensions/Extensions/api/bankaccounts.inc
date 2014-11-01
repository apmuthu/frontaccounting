<?php
/**********************************************
Author: Andres Amaya
Name: Bank Accounts API
Free software under GNU GPL
***********************************************/

$path_to_root = "../..";

include_once($path_to_root . "/gl/includes/db/gl_db_bank_accounts.inc");

function bankaccounts_all()
{

	$banks = get_bank_accounts(false);
	$ret = array();
	while($bank = db_fetch($banks)){
		
		$ret[] = array(
			'id' => $bank['id'],
			'account_type' => $bank['account_type'],
			'account_code' => $bank['account_code'],
			'bank_account_name' => $bank['bank_account_name'],
			'bank_name' => $bank['bank_name'],
			'bank_account_number' => $bank['bank_account_number'],
			'bank_curr_code' => $bank['bank_curr_code'],
			'bank_address' => $bank['bank_address'],
			'dflt_curr_act' => $bank['dflt_curr_act']
		);
		
	}
	api_success_response(json_encode($ret));
	
}

function bankaccounts_get($id)
{
	
	$bank = get_bank_account($id);
	if(!$bank) $bank = array();
	api_success_response(json_encode($bank));
	
}

?>