<?php
// ----------------------------------------------------------------
// $ Revision:  1.0 $
// Creator: Alastair Robertson
// date_:   2013-01-07
// Title:   Dashboard hook
// Free software under GNU GPL
// ----------------------------------------------------------------
define ('SS_DASHBOARD', 150<<8);
include_once($path_to_root . "/modules/dashboard/dashboard.php");

class hooks_dashboard extends hooks {
	var $module_name = 'dashboard';

	/*
		Install additonal menu options provided by module
	*/
    function install_tabs($app) {
        $app->add_application(new dashboard_app);
    }

    function install_options($app) {
        global $path_to_root;

        switch($app->id) {
            case 'system':
                $app->add_lapp_function(1, _('Dashboard Setup'),
                $path_to_root.'/modules/dashboard/dashboard_setup.php', 'SA_DASHBOARDSETUP', MENU_MAINTENANCE);
                $app->add_lapp_function(1, _('Reminder Setup'),
                $path_to_root.'/modules/dashboard/reminder_setup.php', 'SA_DASHBOARDREMINDERS');
                break;
            case 'Dashboard':
                $app->add_widget('customers',_('Customers'),
                '/modules/dashboard/widgets/customers.php', 'SA_CUSTPAYMREP');
                $app->add_widget('salesinvoices',_('Overdue Sales Invoices'),
                '/modules/dashboard/widgets/salesinvoices.php', 'SA_CUSTPAYMREP');
                $app->add_widget('dailysales',_('Daily Sales'),
                '/modules/dashboard/widgets/dailysales.php', 'SA_CUSTPAYMREP');
                $app->add_widget('weeklysales',_('Weekly Sales'),
                '/modules/dashboard/widgets/weeklysales.php', 'SA_CUSTPAYMREP');
                $app->add_widget('suppliers',_('Suppliers'),
                '/modules/dashboard/widgets/suppliers.php', 'SA_SUPPPAYMREP');
                $app->add_widget('purchasesinvoices',_('Purchases Invoices'),
                '/modules/dashboard/widgets/purchasesinvoices.php', 'SA_SUPPPAYMREP');
                $app->add_widget('items',_('Items'),
                '/modules/dashboard/widgets/items.php', 'SA_SALESANALYTIC');
                $app->add_widget('bankbalances',_('Bank Balances'),
                '/modules/dashboard/widgets/bankbalances.php', 'SA_GLANALYTIC');
                $app->add_widget('dailybankbalances',_('Daily Bank Balances'),
                '/modules/dashboard/widgets/dailybankbalances.php', 'SA_GLANALYTIC');
                $app->add_widget('banktransactions',_('Bank Transactions'),
                '/modules/dashboard/widgets/banktransactions.php', 'SA_GLANALYTIC');
                $app->add_widget('glreturn',_('General Ledger Return'),
                '/modules/dashboard/widgets/glreturn.php', 'SA_GLANALYTIC');
                $app->add_widget('dimensions',_('Dimensions'),
                '/modules/dashboard/widgets/dimensions.php', 'SA_DIMENSIONREP');
                $app->add_widget('reminders',_('Reminders'),
                '/modules/dashboard/widgets/reminders.php', 'SA_SETUPDISPLAY');
                break;
        }
    }

    function install_access()
	{
        $security_sections[SS_DASHBOARD] =  _("Dashboard");

        $security_areas['SA_DASHBOARDSETUP'] = array(SS_DASHBOARD|100, _("Setup Dashboard"));
        $security_areas['SA_DASHBOARDREMINDERS'] = array(SS_DASHBOARD|101, _("Reminder Setup"));

		return array($security_areas, $security_sections);
	}

    /* This method is called on extension activation for company.   */
    function activate_extension($company, $check_only=true)
    {
        global $db_connections;

        $updates = array(
            'update.sql' => array('dashboard_widgets')
        );

        return $this->update_databases($company, $updates, $check_only);
    }

    function deactivate_extension($company, $check_only=true)
    {
        global $db_connections;

        $updates = array(
            'drop.sql' => array('ugly_hack') // FIXME: just an ugly hack to clean database on deactivation
        );

        return $this->update_databases($company, $updates, $check_only);
    }
}

?>