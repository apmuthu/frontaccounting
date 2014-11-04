<?php
// ----------------------------------------------------------------
// $ Revision:  1.0 $
// Creator: Maxime Bourget
// date_:   2014-10-19
// Title:   Email Customer
// Free software under GNU GPL
// ----------------------------------------------------------------
define ('SS_EMAIL_CUSTOMER', 103<<8);

class hooks_rep_email_customers extends hooks {
	var $module_name = 'rep_email_customers';

	/*
		Install additonal menu options provided by module
	*/
		function install_tabs($app) {
				global $path_to_root;

		}


		function install_access()
	{
				$security_sections[SS_EMAIL_CUSTOMER] =  _("Email Customer Report");
		$security_areas['SA_EMAIL_CUSTOMER_EMAIL'] = array(SS_EMAIL_CUSTOMER|1, _("send emails."));

		return array($security_areas, $security_sections);
	}
}

