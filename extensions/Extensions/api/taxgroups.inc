<?php
/**********************************************
Author: Andres Amaya
Name: Tax Groups
Free software under GNU GPL
***********************************************/

$path_to_root = "../..";

include_once($path_to_root . "/taxes/includes/db/tax_groups_db.inc");

function taxgroups_all(){
	
	$taxgroups = get_all_tax_groups(false);
	$ret = array();
	while($taxgroup = db_fetch($taxgroups)){
		
		$ret[] = array(
			'id' => $taxgroup['id'],
			'name' => $taxgroup['name'],
			'tax_shipping' => $taxgroup['tax_shipping']
		);
		
	}
	api_success_response(json_encode($ret));
	
}

?>