<?php
define ('SS_IMPORTMULTIJOURNAL', 101<<8);

class hooks_import_transactions extends hooks {
	var $module_name = 'import_transations'; 

	/*
		Install additonal menu options provided by module
	*/
	function install_options($app) {
		global $path_to_root;

		switch($app->id) {
			case 'GL':
				$app->add_rapp_function(2, _('Import &Transactions'), 
					$path_to_root.'/modules/import_transactions/import_multijournalentries.php', 'SA_CSVMULTIJOURNALIMPORT');
		}
	}

	function install_access()
	{
		$security_sections[SS_IMPORTMULTIJOURNAL] =	_("Import Transactions");

		$security_areas['SA_CSVMULTIJOURNALIMPORT'] = array(SS_IMPORTMULTIJOURNAL|101, _("Import Transactions"));

		return array($security_areas, $security_sections);
	}
}
?>