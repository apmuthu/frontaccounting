<?php
define('SS_PAYROLL', 71 << 8);

class payroll_app extends application
{
    function payroll_app() {
        global $path_to_root;

        $this->application("payroll", _($this->help_context = "P&ayroll"));

        $this->add_module(_("Transactions"));
        $this->add_lapp_function(0, _("&Create Paychecks"), $path_to_root . '/modules/payroll/paycheck.php', 'SA_PAYROLL', MENU_TRANSACTION);
        $this->add_lapp_function(0, _("Pay Payroll &Liabilities"), $path_to_root . '/modules/payroll/payroll_liabilities.php', 'SA_PAYROLL', MENU_TRANSACTION);

        $this->add_module(_("Inquiries and Reports"));
        $this->add_lapp_function(1, _("Form 941"), $path_to_root . '/modules/payroll/form_941.php', 'SA_PAYROLL', MENU_INQUIRY);
        $this->add_lapp_function(1, _("Form W2"), $path_to_root . '/modules/payroll/form_w2.php', 'SA_PAYROLL', MENU_INQUIRY);

        $this->add_module(_("Maintenance"));
        $this->add_lapp_function(2, _("&Employees"), $path_to_root . '/modules/payroll/employees.php', 'SA_PAYROLL', MENU_MAINTENANCE);
        $this->add_rapp_function(2, _("Deprecated - Payroll Taxes"), $path_to_root . '/modules/payroll/payroll_taxes.php', 'SA_PAYROLL', MENU_MAINTENANCE);
        //$this->add_rapp_function(2, _("Payroll Tax Groups"),
        //        $path_to_root.'/modules/payroll/payroll_tax_groups.php', 'SA_PAYROLL', MENU_MAINTENANCE);
        //$this->add_rapp_function(2, _("File Template"),
        //        $path_to_root.'/modules/payroll/template.php', 'SA_PAYROLL', MENU_MAINTENANCE);

        $this->add_lapp_function(2, _("Pay Types"), $path_to_root . '/modules/payroll/managePayType.php', 'SA_PAYROLL', MENU_MAINTENANCE);
        $this->add_rapp_function(2, _("&Taxes & Deductions"), $path_to_root . '/modules/payroll/manageTaxes.php', 'SA_PAYROLL', MENU_MAINTENANCE);

        $this->add_extensions();
    }
}

class hooks_payroll extends hooks
{
    var $module_name = 'payroll'; // extension module name.

    function install_tabs($app) {
        set_ext_domain('modules/payroll'); // set text domain for gettext
        $app->add_application(new payroll_app); // add menu tab defined by example_class
        set_ext_domain();
    }

    function install_access() {
        $security_sections[SS_PAYROLL] = _("Payroll");
        $security_areas['SA_PAYROLL']  = array(
            SS_PAYROLL | 1,
            _("Process Payroll and Reports ")
        );
        return array(
            $security_areas,
            $security_sections
        );
    }

    function activate_extension($company, $check_only = true) {
        global $db_connections;
        
        $updates = array(
            'payroll.sql' => array(
                'payroll'
            )
        );
        return $this->update_databases($company, $updates, $check_only);
    }

}

?>