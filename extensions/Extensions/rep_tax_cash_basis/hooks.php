<?php
// ----------------------------------------------------------------
// $ Revision:  1.0 $
// Creator: Alastair Robertson
// date_:   2011-10-22
// Free software under GNU GPL
// Title:   Hooks for tax details (cash basis) inquiry
// Free software under GNU GPL
// ----------------------------------------------------------------

define ('SS_TAXREPCASH', 101<<8);
class hooks_rep_tax_cash_basis extends hooks {
	var $module_name = 'Cash Basis Tax Reporting'; 

	/*
		Install additonal menu options provided by module
	*/
	function install_options($app) {
		global $path_to_root;

		switch($app->id) {
			case 'GL':
				$app->add_lapp_function(1, _('Tax Inquiry (Cash Basis)'), 
					$path_to_root.'/modules/rep_tax_cash_basis/tax_inquiry_cash.php', 'SA_TAXREPCASH');
		}
	}

	function install_access()
	{
		$security_sections[SS_TAXREPCASH] =	_("Tax Inquiry (Cash Basis)");

		$security_areas['SA_TAXREPCASH'] = array(SS_TAXREPCASH|101, _("Tax Inquiry (Cash Basis)"));

		return array($security_areas, $security_sections);
	}
}
?>