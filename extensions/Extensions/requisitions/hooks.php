<?php

define('SS_REQUISITIONS', 101<<8); 

class hooks_requisitions extends hooks {
	var $module_name = 'requisitions'; 

	/*
		Install additonal menu options provided by module
	*/
	function install_options($app) {
		global $path_to_root;

		switch($app->id) {
			case 'AP':
				$app->add_rapp_function(0, _('Requisitions Entries'), $path_to_root.'/modules/requisitions/requisitions.php',
					'SA_REQUISITIONS',	MENU_TRANSACTION);
				$app->add_rapp_function(0, _('Requisitions Allocation'), $path_to_root.'/modules/requisitions/requisition_allocations.php',
					 'SA_REQUISITION_ALLOCATIONS', MENU_TRANSACTION);
				break;
		}
	}

	function install_access()
	{

		$security_sections[SS_REQUISITIONS] = _("Requisitions");

		$security_areas['SA_REQUISITIONS'] = array(SS_REQUISITIONS|1, _("Requisitions Entries"));
		$security_areas['SA_REQUISITION_ALLOCATIONS'] = array(SS_REQUISITIONS|1, _("Requisitions Allocations"));

		return array($security_areas, $security_sections);
	}

	/* This method is called on extension activation for company. 	*/
	function activate_extension($company, $check_only=true)
	{
		global $db_connections;

		$updates = array(
			'update.sql' => array('requisitions')
		);

		return $this->update_databases($company, $updates, $check_only);
	}
}
?>
