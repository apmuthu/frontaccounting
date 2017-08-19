<?php
$page_security = 'SA_PAYROLL';
$path_to_root = "../..";

include_once($path_to_root . "/includes/session.inc");
add_access_extensions();

page(_($help_context = "Pay Types"));

include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/modules/payroll/includes/payroll_db.inc");
include_once($path_to_root . "/modules/payroll/includes/payroll_ui.inc");

simple_page_mode(true);
//----------------------------------------------------------------------------------------------------
function can_process() {
    if (strlen($_POST['code']) == 0) {
	display_error(_("The Pay Type code cannot be empty."));
	set_focus('code');
	return false;
    }

    if (strlen($_POST['name']) == 0) {
	display_error(_("The Pay Type name cannot be empty."));
	set_focus('name');
	return false;
    }
    return true;
}

//----------------------------------------------------------------------------------------------------

if ($Mode=='ADD_ITEM' && can_process()) {
	add_payroll_pay_type($_POST['code'], $_POST['name'], isset($_POST['taxable']) ? 1:0, $_POST['cmethod'],
		    $_POST['account_code'], input_num('default_rate'), isset($_POST['required']) ? 1:0, isset($_POST['automatic']) ? 1:0);
	display_notification(_('New pay type has been added'));
	$Mode = 'RESET';
}

//----------------------------------------------------------------------------------------------------

if ($Mode=='UPDATE_ITEM' && can_process()) {
	update_payroll_pay_type($selected_id, $_POST['code'], $_POST['name'], isset($_POST['taxable']) ? 1:0, $_POST['cmethod'],
		    $_POST['account_code'], input_num('default_rate'), isset($_POST['required']) ? 1:0, isset($_POST['automatic']) ? 1:0);
	display_notification(_('Selected Pay type has been updated'));
	$Mode = 'RESET';
}

//----------------------------------------------------------------------------------------------------

if ($Mode == 'Delete') {
    // PREVENT DELETES IF DEPENDENT RECORDS
/*
    if (key_in_foreign_table($selected_id, 'debtor_trans', 'tpe')) {
	display_error(_("Cannot delete this sale type because customer transactions have been created using this sales type."));
    } else {
	if (key_in_foreign_table($selected_id, 'debtors_master', 'sales_type')) {
	    display_error(_("Cannot delete this sale type because customers are currently set up to use this sales type."));
	} else {
	    delete_other_income_type($selected_id);
	    display_notification(_('Selected sales type has been deleted'));
	}
    } //end if sales type used in debtor transactions or in customers set up
*/
    //SC: 18.04.2012: deletion without check only in development
    delete_payroll_pay_type($selected_id);
    display_notification(_('DEVELOPMENT: Selected sales type has been deleted - without checks'));
    $Mode = 'RESET';
}

if ($Mode == 'RESET') {
	$selected_id = -1;
	$sav = get_post('show_inactive');
	unset($_POST);
	$_POST['show_inactive'] = $sav;
}
//----------------------------------------------------------------------------------------------------

$result = get_all_payroll_pay_type(check_value('show_inactive'));

start_form();
start_table(TABLESTYLE, "width=50%");

$th = array (_('Code'), _('Name'), _('Taxable'), _('Comp. Method'), _('Account Code'), _('Def. rate'), _('Req'), _('Auto'), '','');
inactive_control_column($th);
table_header($th);

$k=0;
while ($myrow = db_fetch($result)) {
    alt_table_row_color($k);
    label_cell($myrow['code']);
    label_cell($myrow['name']);
    label_cell($myrow['taxable'] ? _('Yes'):_('No'), 'align=center');
    label_cell($payroll_paytype_cmethod[$myrow['cmethod']]);
    label_cell($myrow['account_code']);
    amount_cell($myrow['default_rate']);
    label_cell($myrow['required'] ? _('Yes'):_('No'), 'align=center');
    label_cell($myrow['automatic'] ? _('Yes'):_('No'), 'align=center');

    inactive_control_cell($myrow["id"], $myrow["inactive"], 'payroll_pay_type', 'id');
    edit_button_cell("Edit".$myrow['id'], _("Edit"));
    delete_button_cell("Delete".$myrow['id'], _("Delete"));
    end_row();
}
inactive_control_row($th);
end_table(1);


//----------------------------------------------------------------------------------------------------

if (!isset($_POST['taxable']))
	$_POST['taxable'] = 0;
if (!isset($_POST['cmethod']))
	$_POST['cmethod'] = 0;

if (!isset($_POST['required']))
	$_POST['required'] = 0;
if (!isset($_POST['automatic']))
	$_POST['automatic'] = 0;
if (!isset($_POST['default_rate']))
	$_POST['default_rate'] = '';

start_table(TABLESTYLE2);

if ($selected_id != -1) {
    if ($Mode == 'Edit') {
	$myrow = get_payroll_pay_type($selected_id);
		$_POST['code']  = $myrow['code'];
		$_POST['name']  = $myrow['name'];
		$_POST['taxable']  = $myrow['taxable'];
		$_POST['cmethod']  = $myrow['cmethod'];
		$_POST['account_code']  = $myrow['account_code'];
		$_POST['default_rate'] = $myrow['default_rate'];
		$_POST['required'] = $myrow['required'];
		$_POST['automatic'] = $myrow['automatic'];

	}
	hidden('selected_id', $selected_id);
//} else {
//    $_POST['factor']  = number_format2(1,4);
}

text_row_ex(_("Pay Type Code:"), 'code', 5);
text_row_ex(_("Pay Type Name:"), 'name', 50, 100);
check_row(_("Taxable:"), 'taxable', $_POST['taxable']);
check_row(_("Required:"), 'required', $_POST['required']);
check_row(_("Automatic:"), 'automatic', $_POST['automatic']);
amount_row(_("Default rate:"), 'default_rate', $_POST['default_rate']);
payroll_paytype_cmethod_list_row(_('Computing Method:'), 'cmethod', $_POST['cmethod'], false);
gl_all_accounts_list_row(_("Default Expense Account:"), 'account_code', null);//which account are we posting to?

end_table(1);

submit_add_or_update_center($selected_id == -1, '', 'both');

end_form();

end_page();

?>
