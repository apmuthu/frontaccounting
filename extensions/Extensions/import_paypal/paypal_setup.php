<?php
// ----------------------------------------------------------------
// $ Revision:  1.0 $
// Creator: Alastair Robertson
// date_:   2011-10-22
// Title:   Paypal setup options
// Free software under GNU GPL
// ----------------------------------------------------------------
$page_security = 'SA_PAYPALSETUP';
$path_to_root="../..";
include($path_to_root . "/includes/session.inc");
add_access_extensions();

page(_($help_context = "Paypal Import Setup"));

include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/includes/data_checks.inc");

include_once($path_to_root . "/admin/db/company_db.inc");

//-------------------------------------------------------------------------------------------------

function can_process()
{
	return true;
}

//-------------------------------------------------------------------------------------------------

if (isset($_POST['submit']) && can_process())
{
	update_company_prefs( get_post( array( 'paypal_bank_id', 'paypal_create_invoices', 'paypal_sales_act',
		'paypal_sales_tax_act', 'paypal_fee_act', 'paypal_shipping_act', 'paypal_insurance_act',
		'paypal_withdraw_id','use_paypal_trn_id', 'paypal_sales_type_id', 'paypal_add_tax', 'paypal_recpt_today',
		'paypal_tax_group_id', 'paypal_item_tax_id', 'paypal_tax_type_id', 'paypal_tax_included', 'paypal_name_col',
        'paypal_salesman', 'paypal_area', 'paypal_location', 'paypal_shipper', 'paypal_credit_status'
)));

	display_notification(_("The Paypal setup has been updated."));

} /* end of if submit */

//-------------------------------------------------------------------------------------------------

start_form();

start_outer_table(TABLESTYLE2);

table_section(1);

if (get_company_pref('paypal_bank_id') === null) {
    set_company_pref('paypal_bank_id', 'paypal.setup', 'int', 11, 0);
    refresh_sys_prefs();
}
if (get_company_pref('paypal_create_invoices') === null) {
    set_company_pref('paypal_create_invoices', 'paypal.setup', 'tinyint', 1, 0);
    refresh_sys_prefs();
}
if (get_company_pref('paypal_sales_act') === null) {
    set_company_pref('paypal_sales_act', 'paypal.setup', 'varchar', 15, 0);
    refresh_sys_prefs();
}
if (get_company_pref('paypal_sales_tax_act') === null) {
    set_company_pref('paypal_sales_tax_act', 'paypal.setup', 'varchar', 15, 0);
    refresh_sys_prefs();
}
if (get_company_pref('paypal_fee_act') === null) {
    set_company_pref('paypal_fee_act', 'paypal.setup', 'varchar', 15, 0);
    refresh_sys_prefs();
}
if (get_company_pref('paypal_shipping_act') === null) {
    set_company_pref('paypal_shipping_act', 'paypal.setup', 'varchar', 15, 0);
    refresh_sys_prefs();
}
if (get_company_pref('paypal_insurance_act') === null) {
    set_company_pref('paypal_insurance_act', 'paypal.setup', 'varchar', 15, 0);
    refresh_sys_prefs();
}
if (get_company_pref('paypal_withdraw_id') === null) {
    set_company_pref('paypal_withdraw_id', 'paypal.setup', 'int', 11, 0);
    refresh_sys_prefs();
}
if (get_company_pref('use_paypal_trn_id') === null) {
    set_company_pref('use_paypal_trn_id', 'paypal.setup', 'tinyint', 1, 0);
    refresh_sys_prefs();
}
if (get_company_pref('paypal_sales_type_id') === null) {
    set_company_pref('paypal_sales_type_id', 'paypal.setup', 'int', 11, 0);
    refresh_sys_prefs();
}
if (get_company_pref('paypal_add_tax') === null) {
    set_company_pref('paypal_add_tax', 'paypal.setup', 'tinyint', 1, 0);
    refresh_sys_prefs();
}
if (get_company_pref('paypal_recpt_today') === null) {
    set_company_pref('paypal_recpt_today', 'paypal.setup', 'tinyint', 1, 0);
    refresh_sys_prefs();
}
if (get_company_pref('paypal_tax_group_id') === null) {
    set_company_pref('paypal_tax_group_id', 'paypal.setup', 'int', 11, 0);
    refresh_sys_prefs();
}
if (get_company_pref('paypal_tax_type_id') === null) {
    set_company_pref('paypal_tax_type_id', 'paypal.setup', 'int', 11, 0);
    refresh_sys_prefs();
}
if (get_company_pref('paypal_item_tax_id') === null) {
    set_company_pref('paypal_item_tax_id', 'paypal.setup', 'int', 11, 0);
    refresh_sys_prefs();
}
if (get_company_pref('paypal_tax_included') === null) {
    set_company_pref('paypal_tax_included', 'paypal.setup', 'tinyint', 1, 0);
    refresh_sys_prefs();
}
if (get_company_pref('paypal_name_col') === null) {
    set_company_pref('paypal_name_col', 'paypal.setup', 'varchar', 55, '');
    refresh_sys_prefs();
}
if (get_company_pref('paypal_salesman') === null) {
    set_company_pref('paypal_salesman', 'paypal.setup', 'int', 11, 0);
    refresh_sys_prefs();
}
if (get_company_pref('paypal_area') === null) {
    set_company_pref('paypal_area', 'paypal.setup', 'int', 11, 0);
    refresh_sys_prefs();
}
if (get_company_pref('paypal_location') === null) {
    set_company_pref('paypal_location', 'paypal.setup', 'varchar', 5, '');
    refresh_sys_prefs();
}
if (get_company_pref('paypal_shipper') === null) {
    set_company_pref('paypal_shipper', 'paypal.setup', 'int', 11, '');
    refresh_sys_prefs();
}
if (get_company_pref('paypal_credit_status') === null) {
    set_company_pref('paypal_credit_status', 'paypal.setup', 'int', 11, '');
    refresh_sys_prefs();
}

$myrow = get_company_prefs();

$_POST['paypal_bank_id']  = $myrow["paypal_bank_id"];
$_POST['paypal_create_invoices'] = $myrow['paypal_create_invoices'];
$_POST['paypal_sales_act']  = $myrow["paypal_sales_act"];
$_POST['paypal_sales_tax_act']  = $myrow["paypal_sales_tax_act"];
$_POST['paypal_shipping_act']  = $myrow["paypal_shipping_act"];
$_POST['paypal_insurance_act']  = $myrow["paypal_insurance_act"];
$_POST['paypal_withdraw_id']  = $myrow["paypal_withdraw_id"];
$_POST['paypal_fee_act']  = $myrow["paypal_fee_act"];
$_POST['paypal_sales_type_id']  = $myrow["paypal_sales_type_id"];
$_POST['use_paypal_trn_id'] = $myrow['use_paypal_trn_id'];
$_POST['paypal_add_tax'] = $myrow['paypal_add_tax'];
$_POST['paypal_recpt_today'] = $myrow['paypal_recpt_today'];
$_POST['paypal_tax_group_id'] = $myrow['paypal_tax_group_id'];
$_POST['paypal_tax_type_id'] = $myrow['paypal_tax_type_id'];
$_POST['paypal_item_tax_id'] = $myrow['paypal_item_tax_id'];
$_POST['paypal_tax_included'] = $myrow['paypal_tax_included'];
$_POST['paypal_name_col'] = $myrow['paypal_name_col'];
$_POST['paypal_salesman'] = $myrow['paypal_salesman'];
$_POST['paypal_area'] = $myrow['paypal_area'];
$_POST['paypal_location'] = $myrow['paypal_location'];
$_POST['paypal_shipper'] = $myrow['paypal_shipper'];
$_POST['paypal_credit_status'] = $myrow['paypal_credit_status'];

//---------------

table_section_title(_("Options"));
check_row(_("Create Customers/Invoices:"), 'paypal_create_invoices', null);
check_row(_("Use Paypal Transaction Id:"), 'use_paypal_trn_id', null);
check_row(_("Receipts Date Today:"), 'paypal_recpt_today', null);
table_section_title(_("PayPal File"));
text_row_ex(_("Company Name Column:"), 'paypal_name_col', 25, 55);
table_section_title(_("Customers"));
sales_types_list_row("Sales Type:", 'paypal_sales_type_id', null);
sales_persons_list_row( _("Sales Person:"), 'paypal_salesman', null);
sales_areas_list_row( _("Sales Area:"), 'paypal_area', null);
credit_status_list_row(_("Credit Status:"), 'paypal_credit_status', null);
locations_list_row(_("Default Location:"), 'paypal_location', null);
shippers_list_row(_("Default Shipper:"), 'paypal_shipper', null);

table_section(2);

table_section_title(_("Accounts"));
bank_accounts_list_row(_("Bank Account:"), 'paypal_bank_id', $_POST['paypal_bank_id'], false);
gl_all_accounts_list_row(_("Sales Account:"), 'paypal_sales_act', $_POST['paypal_sales_act']);
gl_all_accounts_list_row(_("Sales Tax Account:"), 'paypal_sales_tax_act', $_POST['paypal_sales_tax_act']);
gl_all_accounts_list_row(_("Shipping Account:"), 'paypal_shipping_act', $_POST['paypal_shipping_act']);
gl_all_accounts_list_row(_("Fee Account:"), 'paypal_fee_act', $_POST['paypal_fee_act']);
gl_all_accounts_list_row(_("Insurance Account:"), 'paypal_insurance_act', $_POST['paypal_insurance_act']);
bank_accounts_list_row(_("Withdrawal Account:"), 'paypal_withdraw_id', $_POST['paypal_withdraw_id'], false);
table_section_title(_("Tax"));
check_row(_("Add Tax to Receipts:"), 'paypal_add_tax', null);
check_row(_("Tax Included in Paypal Amount:"), 'paypal_tax_included', null);
tax_types_list_row("Default Tax Type:", 'paypal_tax_type_id', null);
tax_groups_list_row("Default Tax Group:", 'paypal_tax_group_id', null);
item_tax_types_list_row("Default Item Tax Group:", 'paypal_item_tax_id', null);

end_outer_table(1);

submit_center('submit', _("Update"), true, '',  'default');

end_form();

//-------------------------------------------------------------------------------------------------

end_page();

?>
