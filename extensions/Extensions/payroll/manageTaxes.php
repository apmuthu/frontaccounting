<?php


$page_security = 'SA_PAYROLL';
$path_to_root = "../..";

include_once($path_to_root . "/includes/session.inc");
add_access_extensions();

page(_($help_context = "Taxes/Deductions"));

include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/modules/payroll/includes/payroll_db.inc");
include_once($path_to_root . "/modules/payroll/includes/payroll_ui.inc");





$new_tax_type = get_post('tax_type_id')=='' || get_post('cancel');


//--------------------------------------------------------------------------------------------------
if (list_updated('tax_type_id')) {
	$Ajax->activate('tax_table');
	$Ajax->activate('controls');
	$Ajax->activate('tax_rate_table');
}

function clear_data() {
	unset($_POST);
}


if (get_post('addupdate')) {
   	$input_error = 0;
	if ($_POST['code'] == '') {
      	    $input_error = 1;
      	    display_error( _("Tax Code cannot be empty."));
	    set_focus('code');
   	} elseif ($_POST['name'] == '') {
      	    $input_error = 1;
      	    display_error( _("Tax Name cannot be empty."));
	    set_focus('name');
   	}

	if ($input_error == 0) {
     	    if ($new_tax_type) {
		add_payroll_tax_type($_POST['code'], $_POST['name'], $_POST['type'], $_POST['responsibility'],
				$_POST['tax_base'], $_POST['accrual_gl_code'], $_POST['expense_gl_code'], $_POST['tax_period']);
		display_notification(_("New Tax type has been added."));
       	    } else {
       		update_payroll_tax_type($_POST['tax_type_id'], $_POST['code'], $_POST['name'], $_POST['type'], $_POST['responsibility'],
				$_POST['tax_base'], $_POST['accrual_gl_code'], $_POST['expense_gl_code'], $_POST['tax_period']);
		update_record_status($_POST['tax_type_id'], get_post('inactive'), 'payroll_tax_type', 'id');
	  	display_notification(_("The tax type has been updated."));
       	    }
	    $new_tax_type = true;
	    clear_data();
	    $Ajax->activate('_page_body');
	}
}

//--------------------------------------------------------------------------------------------------
/*
if (get_post('delete')) {
	if (check_role_used(get_post('role'))) {
		display_error(_("This role is currently assigned to some users and cannot be deleted"));
 	} else {
		delete_security_role(get_post('role'));
		display_notification(_("Security role has been sucessfully deleted."));
		unset($_POST['role']);
	}
	$Ajax->activate('_page_body');
}
*/
if (get_post('cancel')) {
	unset($_POST['tax_type_id']);
	$Ajax->activate('_page_body');
}

if (!isset($_POST['tax_type_id']) || list_updated('tax_type_id')) {
	$tax_type_id = get_post('tax_type_id');

	unset($_POST);
	if ($tax_type_id) {
		$row = get_payroll_tax_type($tax_type_id);
		$_POST['code'] = $row['code'];
		$_POST['name'] = $row['name'];
		$_POST['inactive'] = $row['inactive'];
		$_POST['type'] = $row['type'];
		$_POST['tax_base'] = $row['tax_base'];
		$_POST['responsibility'] = $row['responsibility'];
		$_POST['accrual_gl_code'] = $row['accrual_gl_code'];
		$_POST['expense_gl_code'] = $row['expense_gl_code'];
		$_POST['tax_period'] = $row['tax_period'];
	} else {
		$_POST['code'] = $_POST['name'] = '';
		unset($_POST['inactive']);
	}

	$_POST['tax_type_id'] = $tax_type_id;
}


// tax_table_data editing
// SC: in development
if (get_post('Deletexx')) {
    display_notification(_("DEV: a row is deleted."));
}
//--------------------------------------------------------------------------------------------------

start_form();

start_table(TABLESTYLE_NOBORDER);
start_row();
payroll_tax_types_list_cells(_("Tax Type:"). "&nbsp;", 'tax_type_id', null, true, true, check_value('show_inactive'));
$new_tax_type = get_post('tax_type_id')=='';
check_cells(_("Show inactive:"), 'show_inactive', null, true);
end_row();
end_table();
echo "<hr>";

if (get_post('_show_inactive_update')) {
	$Ajax->activate('tax_type_id');
	set_focus('tax_type_id');
}

if (find_submit('_Section')) {
	$Ajax->activate('tax_table');
	$Ajax->activate('tax_rate_table');
}

if (!isset($_POST['type']))
	$_POST['type'] = 0;

if (!isset($_POST['responsibility']))
	$_POST['responsibility'] = 0;

if (!isset($_POST['tax_base']))
	$_POST['tax_base'] = 0;

if (!isset($_POST['tax_period']))
	$_POST['tax_period'] = 1;
//-----------------------------------------------------------------------------------------------
div_start('tax_table');
//start_table(TABLESTYLE2);
start_outer_table(TABLESTYLE2);

table_section(1);

text_row(_("Tax code:"), 'code', null, 3, 5);
text_row(_("Tax Name:"), 'name', null, 50, 52);
gl_all_accounts_list_row(_("Accrual Account:"), 'accrual_gl_code', null);
gl_all_accounts_list_row(_("Expense Account:"), 'expense_gl_code', null);
record_status_list_row(_("Current status:"), 'inactive');

table_section(2);

payroll_tax_deduction_list_row(_('Tax/Deduction:'), 'type', $_POST['type'], false);
payroll_tax_resp_list_row(_('Tax Responsibility:'), 'responsibility', $_POST['responsibility'], false);
payroll_tax_base_list_row(_('Tax Base:'), 'tax_base', $_POST['tax_base'], false);
payroll_tax_period_list_row(_('Figures Given As:'), 'tax_period', $_POST['tax_period'], false);

end_outer_table(1);


//record_status_list_row(_("Current status:"), 'inactive');
end_table(1);


div_start('tax_rate_table');
if ($new_tax_type) {
    display_note(_("Values for tax rates can be entered after Tax Type is saved."), 0, 1);
}
start_table(TABLESTYLE, "width=50%");
$th = array (_('Variable'), _('From'), _('To'), _('Fixed Tax Amount'), _('Subtract for variable'), _('Fixed Tax pct.'), _('Variable Tax pct.'), '','');
table_header($th);
if (!$new_tax_type) {
//    $res = get_tax_table_data($tax_type_id);
    start_row();
    //SC: play here it should display values existing in database
    echo "<td>XX</td><td>YY</td><td>ZZ</td><td>QQ</td><td>WW</td><td>TT</td><td>MM</td>";
    edit_button_cell("Edit".'xx', _("Edit"));
    delete_button_cell("Delete".'xx', _("Delete"));
    end_row();
    
    //SC: add a line of tax_rate_data editing/insertion
    $var = 'XX';
    start_row();
    amount_cells_ex(null, $var, 6, null, null/*init*/, null, null, null);
    amount_cells_ex(null, $var, 6, null, null/*init*/, null, null, null);
    amount_cells_ex(null, $var, 6, null, null/*init*/, null, null, null);
    amount_cells_ex(null, $var, 6, null, null/*init*/, null, null, null);
    amount_cells_ex(null, $var, 6, null, null/*init*/, null, null, null);
    amount_cells_ex(null, $var, 6, null, null/*init*/, null, null, null);
    amount_cells_ex(null, $var, 6, null, null/*init*/, null, null, null);

    echo "<td colspan=2>";
    submit("Add", "Add");
    echo "</td>";
    end_row();
}
end_table(1);
div_end();

echo "<hr>";
div_start('controls');
if ($new_tax_type) {
    submit_center_first('Update', _("Update view"), '', null);
    submit_center_last('addupdate', _("Add new Tax Type"), '', 'default');
} else {
    submit_center_first('addupdate', _("Save Tax Type"), '', 'default');
    submit('Update', _("Update view"), true, '', null);
    submit('delete', _("Delete This Tax Type"), true, '', true);
    submit_center_last('cancel', _("Cancel"), _("Cancel Edition"), 'cancel');
}

div_end();

end_form();
end_page();


?>