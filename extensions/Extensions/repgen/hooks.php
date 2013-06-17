<?php
define('SS_REPORT_GENERATOR',	130<<8);

class hooks_repgen extends hooks {
	var $module_name = 'repgen';
	
	/*
		Install additonal menu options provided by module
	*/
	function install_options($app) {
		global $path_to_root;
		
		switch($app->id) {
			case 'system':
				$app->add_rapp_function( 2, _("&Report Generator"), 
					$path_to_root.'/modules/repgen/repgen_select.php', 'SA_REPORT_GENERATOR');
		}
	}

	function install_access()
	{

		$security_sections[SS_REPORT_GENERATOR] =	_("Report Generator");

		$security_areas['SA_REPORT_GENERATOR'] = array(SS_REPORT_GENERATOR|130, _("Report Generator"));

		return array($security_areas, $security_sections);
	}

	/* This method is called on extension activation for company. 	*/
	function activate_extension($company, $check_only=true)
	{
		global $db_connections;

		$updates = array(
			'reports.sql' => array('reports')
		);

		return $this->update_databases($company, $updates, $check_only);
	}
}
