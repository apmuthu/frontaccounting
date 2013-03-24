<?php
define ('SS_ZENORDERS', 101<<8);

class hooks_zen_import extends hooks {
	var $module_name = 'Import Zen Cart Orders'; 

	/*
		Install additonal menu options provided by module
	*/
	function install_options($app) {
		global $path_to_root;

		switch($app->id) {
			case 'GL':
				$app->add_rapp_function(2, _('Import Zen Cart Orders'), 
					$path_to_root.'/modules/zen_import/zencart.php', 'SA_ZENIMPORT');
		}
	}

	function install_access()
	{
		$security_sections[SS_ZENORDERS] = _("Import Zen Cart Orders");

		$security_areas['SA_ZENIMPORT'] = array(SS_ZENORDERS|101, _("Import Zen Cart Orders"));

		return array($security_areas, $security_sections);
	}
}
?>