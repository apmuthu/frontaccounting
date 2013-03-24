<?php
define ('SS_OSCORDERS', 106<<8);
class hooks_osc_import extends hooks {
	var $module_name = 'osCommerce Order Import'; 

	/*
		Install additonal menu options provided by module
	*/
	function install_options($app) {
		global $path_to_root;

		switch($app->id) {
			case 'orders':
				$app->add_rapp_function(2, _('osCommerce Import'), 
					$path_to_root.'/modules/osc_import/osCommerce.php', 'SA_OSCORDERS');
		}
	}

	function install_access()
	{
		$security_sections[SS_OSCORDERS] =	_("osCommerce Order Import");

		$security_areas['SA_OSCORDERS'] = array(SS_OSCORDERS|106, _("osCommerce Order Import"));

		return array($security_areas, $security_sections);
	}
}
?>
