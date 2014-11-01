<?php
/**********************************************
Author: Andres Amaya
Name: Tax Types API
Free software under GNU GPL
***********************************************/

$path_to_root = "../..";

include_once($path_to_root . "/taxes/includes/db/item_tax_types_db.inc");

function taxtypes_all(){
	
	$taxtypes = get_all_item_tax_types();
	$ret = array();
	while($taxtype = db_fetch($taxtypes)){
		
		$ret[] = array(
			'id' => $taxtype['id'],
			'name' => $taxtype['name'],
			'exempt' => $taxtype['exempt']
		);
		
	}
	api_success_response(json_encode($ret));
	
}

?>