<?php

define('SS_ASSETREGISTER', 101<<8);

class hooks_asset_register extends hooks {
	var $module_name = 'asset_register'; 

	/*
		Install additonal menu options provided by module
	*/
	function install_options($app) {
		global $path_to_root;

		switch($app->id) {
			case 'stock':
				$app->add_rapp_function(2, _('&Asset Type Entries'), $path_to_root.'/modules/asset_register/asset_types.php', 'SA_ASSETTYPE',
					MENU_MAINTENANCE);
				$app->add_rapp_function(2, _('&Assets Entries'), $path_to_root.'/modules/asset_register/assets.php', 'SA_ASSETS',
					MENU_ENTRY);
				break;
			case 'GL':
				$app->add_rapp_function(0, _('&Amortisation Posting'), $path_to_root.'/modules/asset_register/amortisation_post.php', 'SA_AMORTISATION',
					MENU_TRANSACTION);
				break;
		}
	}

	function install_access()
	{

		$security_sections[SS_ASSETREGISTER] = _("Asset Register");

		$security_areas['SA_ASSETTYPE'] = array(SS_ASSETREGISTER|1, _("Asset Type Entries"));
		$security_areas['SA_ASSETS'] = array(SS_ASSETREGISTER|2, _("Assets Entries"));
		$security_areas['SA_AMORTISATION'] = array(SS_ASSETREGISTER|3, _("Amortisation Posting"));

		return array($security_areas, $security_sections);
	}

	/* This method is called on extension activation for company. 	*/
	function activate_extension($company, $check_only=true)
	{
		global $db_connections;

		$updates = array(
			'update.sql' => array('assets')
		);

		return $this->update_databases($company, $updates, $check_only);
	}
}
?>
