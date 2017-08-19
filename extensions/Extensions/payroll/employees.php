<?php
/*
  Add, Edit, and List Employees
  Database table is "employees"
  DB fields are in flux

  TODO - employee tax/deduction CRUD  
  
*/

/////////////////////////////////////////////////////
//Includes
/////////////////////////////////////////////////////
$page_security = 'SA_PAYROLL';
$path_to_root = "../..";

include($path_to_root . "/includes/db_pager.inc");//is this needed?
include_once($path_to_root . "/includes/session.inc");
add_access_extensions();


$js = "";
if ($use_popup_windows)
	$js .= get_js_open_window(900, 500);
if ($use_date_picker)
	$js .= get_js_date_picker();
	

include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/banking.inc");
include_once($path_to_root . "/includes/ui.inc");

include_once($path_to_root . "/modules/payroll/includes/payroll_db.inc");
include_once($path_to_root . "/modules/payroll/includes/payroll_ui.inc");


/////////////////////////////////////////////////////
//Data Functions
/////////////////////////////////////////////////////

//--------------------------------------------------------------------------------------------
function can_process()
{
	if (strlen($_POST['EmpFirstName']) == 0){
		display_error(_("Who is this? Surely they have a name?"));
		set_focus('EmpFirstName');
		return false;
	} 
	if (strlen($_POST['EmpLastName']) == 0){
		display_error(_("Who is this? Surely they have a name?"));
		set_focus('EmpLastName');
		return false;
	} 
	if (strlen($_POST['EmpAddress']) == 0){
		display_error(_("What? You hired a homeless guy?"));
		set_focus('EmpAddress');
		return false;
	} 

	if (!is_date($_POST['EmpHireDate']))
	{
		display_error( _("The date entered is in an invalid format."));
		set_focus('EmpHireDate');
		return false;
	}

	if (get_post('EmpInactive') == 1){
	    if (!is_date($_POST['EmpReleaseDate']))
	    {
		display_error( _("A valid release date must be entered for inactive employees."));
		set_focus('EmpReleaseDate');
		return false;
	    }
	}

	//if (!preg_match("/\d{3}[-\s]?\d{2}[-\s]?\d{4}/", $_POST['EmpTaxId'])){//this checks for Social Security Number (US) formatting. It's certainly too narrow a requirement for use in other countries at this point
	if (strlen($_POST['EmpTaxId']) == 0){//a more universal check - do we have _something_ for the tax id? If this is used, comment out or remove the "else" below and the pregmatch above
		display_error(_("Big Brother needs to see your identification."));
		set_focus('EmpTaxId');
		return false;
	}/* else {
		//let's format these consistantly
		$_POST['EmpTaxId'] = preg_replace("/(\d{3})[-\s]?(\d{2})[-\s]?(\d{4})/", "$1-$2-$3", $_POST['EmpTaxId']);
	}*/

	return true;
}

//--------------------------------------------------------------------------------------------
function can_delete_pay(){
  //TODO the pay rate should not be deleted if...?
  return true;
}

//--------------------------------------------------------------------------------------------
function handle_submit(&$selected_id)
{
	global $Ajax;

	if (!can_process())
		return;
		
	if ($selected_id) 
	{

		update_employee($_POST['EmpFirstName'], $_POST['EmpLastName'], $_POST['EmpAddress'], 
				$_POST['EmpPhone'], $_POST['EmpEmail'], $_POST['EmpBirthDate'],
				$_POST['EmpFrequency'], $_POST['EmpStatus'], $_POST['EmpAllowances'],
				input_num('EmpExtraWH'), $_POST['EmpTaxId'], $_POST['EmpRole'], $_POST['EmpHireDate'], 
				$_POST['EmpNotes'], $selected_id, get_post('EmpInactive'), get_post('EmpInactive') ? $_POST['EmpReleaseDate'] : null);

		//update_record_status($_POST['EmpId'], $_POST['EmpInactive'], 'employees', 'emp_id');//from sql_functions.inc
		//TODO update release date for inactive employees

		$Ajax->activate('EmpId'); // in case of status change //html field name
		display_notification(_("Employee has been updated."));
	} 
	else 
	{ 	//it is a new employee

		begin_transaction();
		add_employee($_POST['EmpFirstName'], $_POST['EmpLastName'], $_POST['EmpAddress'], $_POST['EmpPhone'], $_POST['EmpEmail'], $_POST['EmpBirthDate'],
				$_POST['EmpFrequency'], $_POST['EmpStatus'], $_POST['EmpAllowances'],
				input_num('EmpExtraWH'), $_POST['EmpTaxId'], $_POST['EmpRole'], $_POST['EmpHireDate'], $_POST['EmpNotes']);

		$selected_id = $_POST['EmpId'] = db_insert_id();
         
		commit_transaction();

		display_notification(_("A new employee has been added."));
		
		$Ajax->activate('_page_body');
	}
}

//--------------------------------------------------------------------------------------------
function handle_submit_pay($emp_id){

    global $Ajax;

    if (!check_num('rate', 0.01)){
	display_error(_("Oh dear. We really ought to pay this person <em>something</em>"));
	set_focus('rate');
    } else {
	if ($_POST['rate_id'] != -1) {//editing record
	    //display_notification("rate id is ".$_POST['rate_id']);
	    update_employee_compensation($emp_id, $_POST['pay_type'], input_num('rate'), $_POST['rate_id']);
	    display_notification(_("Pay rate has been updated."));
	} else {//new pay rate record
	    //display_notification("rate id is ".$_POST['rate_id']);
	    add_employee_compensation($emp_id, $_POST['pay_type'], input_num('rate'));
	    display_notification(_("Pay rate has been added."));
	}
	$Ajax->activate('_page_body');
    }
}

//--------------------------------------------------------------------------------------------
function handle_delete_pay($rate_id){

  global $Ajax;

  if(can_delete_pay()){//TODO not sure what needs to be checked first
    remove_employee_compensation($rate_id);
    display_notification("Pay rate has been deleted");
    $Ajax->activate('_page_body');
  } else {
    display_error("This compensation type cannot be deleted");
  }
}

/////////////////////////////////////////////////////
//UI Functions
/////////////////////////////////////////////////////
function employee_settings($selected_id){

	if (!$selected_id) 
	{
	 	//if (list_updated('EmpId') || !isset($_POST['EmpId'])) {//what is this?
			$_POST['EmpFirstName'] = $_POST['EmpLastName'] = $_POST['EmpAddress'] = $_POST['EmpPhone'] = $_POST['EmpEmail'] = 
			$_POST['EmpTaxId'] = $_POST['EmpRole'] = $_POST['EmpPayType'] =
			$_POST['EmpPayRate'] = $_POST['EmpFrequency'] = $_POST['EmpStatus'] =
			$_POST['EmpAllowances'] = $_POST['EmpExtraWH'] = $_POST['EmpNotes'] ='';
			$_POST['EmpBirthDate'] = $_POST['EmpHireDate'] = Today();
  
		//}
	}
	else 
	{
	    $myrow = get_employee($selected_id);
	    $_POST['EmpFirstName'] = $myrow["emp_first_name"];
	    $_POST['EmpLastName'] = $myrow["emp_last_name"];
	    $_POST['EmpAddress'] =  $myrow["emp_address"];
	    $_POST['EmpPhone'] =  $myrow["emp_phone"];
	    $_POST['EmpEmail'] = $myrow["emp_email"];
	    $_POST['EmpBirthDate'] = sql2date($myrow["emp_birthdate"]);
	    $_POST['EmpNotes'] =  $myrow["emp_notes"];
	    $_POST['EmpTaxId'] =  $myrow["emp_taxid"];
	    $_POST['EmpRole'] =  $myrow["emp_type"];
	    $_POST['EmpFrequency'] =  $myrow["emp_payfrequency"];
	    $_POST['EmpStatus'] = $myrow["emp_filingstatus"];
	    $_POST['EmpAllowances'] =  $myrow["emp_allowances"];
	    $_POST['EmpExtraWH'] = $myrow["emp_extrawitholding"];
	    $_POST['EmpHireDate'] = sql2date($myrow["emp_hiredate"]);
	    $_POST['EmpInactive'] = $myrow["inactive"];
	    $_POST['EmpReleaseDate'] = sql2date($myrow["emp_releasedate"]); 
	}

	div_start('emp_info');
	start_outer_table(TABLESTYLE2);
	table_section(1);
	table_section_title(_("Name and Address"));

	text_row(_("Employee First Name:"), 'EmpFirstName', $_POST['EmpFirstName'], 40, 80);
	text_row(_("Employee Last Name:"), 'EmpLastName', $_POST['EmpLastName'], 40, 80);
	textarea_row(_("Address:"), 'EmpAddress', $_POST['EmpAddress'], 35, 5);

	text_row(_("Phone:"), 'EmpPhone', $_POST['EmpPhone'], 40, 80);
	email_row(_("e-Mail:"), 'EmpEmail', $_POST['EmpEmail'], 40, 80);

	date_row(_("Birth Date:"), 'EmpBirthDate');
	textarea_row(_("General Notes:"), 'EmpNotes', null, 35, 5);

	
	table_section(2);

	table_section_title(_("Employment Information"));

	text_row(_("Tax ID:"), 'EmpTaxId', $_POST['EmpTaxId'], 11, 11);
	payroll_emp_role_list_row(_("Role:"), 'EmpRole', $_POST['EmpRole']); //Officer/Employee...
	payroll_payfreq_list_row(_("Pay Frequency:"), 'EmpFrequency', $_POST['EmpFrequency']);//weekly/biweekly/semi-monthly...
	payroll_filing_status_list_row(_("Filing Status:"), 'EmpStatus', $_POST['EmpStatus']);//Single, Married...
	text_row(_("Allowances:"), 'EmpAllowances', $_POST['EmpAllowances'], 2, 2);
	amount_row(_("Extra Witholding:"), 'EmpExtraWH', $_POST['EmpExtraWH']);

	table_section_title(_(" "));//just a spacer
	date_row(_("Hire Date:"), 'EmpHireDate');

	if ($selected_id) {
	    check_row('Inactive:', 'EmpInactive');
	    date_row(_("Release Date:"), 'EmpReleaseDate');
	}


	end_outer_table(1);
	div_end();

	div_start('controls');
	if (!$selected_id)
		submit_center('submit', _("Add New Employee"), true, '', 'default');
	else 
		submit_center('submit', _("Update Employee"), _('Update employee data'), @$_REQUEST['popup'] ? true : 'default');
	
	div_end();
}

//Entry form for employee compensation
//--------------------------------------------------------------------------------------------
function employee_comp($emp_id){

    global $Ajax;

    if(!db_has_pay_types()){
	display_error("No pay types have been defined");
	return;
    }

    br();
    //display the existing compensation rates for this employee
    start_table(TABLESTYLE);
    $th = array(_("Description"), _("Rate"), "", "");
    table_header($th);

    $result = get_employee_compensation($emp_id);
    $k = 0;
    while($myrow = db_fetch($result)){
      alt_table_row_color($k);
      label_cell($myrow["name"]);
      label_cell($myrow["pay_rate"]);
    
      edit_button_cell("EditPay".$myrow["id"], _("Edit Pay"));
      delete_button_cell("DeletePay".$myrow["id"], _("Delete Pay"));

      end_row();
    }
    end_table(1);

    if(!isset($_POST['rate_id'])){
	$_POST['pay_type'] = key(get_pay_type_array());
	$_POST['rate'] = get_default_pay_rate($_POST['pay_type']);
	$_POST['rate_id'] = -1;
    }

    //add or edit compensation
    div_start('comp_table');
    start_table(TABLESTYLE2);
    payroll_pay_type_list_row(_("Type:"), 'pay_type', $_POST['pay_type'], true);
    amount_row(_("Rate:"), 'rate', $_POST['rate']);
    hidden('rate_id', $_POST['rate_id']);
    end_table(1);  

    if (find_submit('EditPay') == -1)
	submit_center('SubmitPay', _("Add Compensation"), true, '', 'default');
    else
	submit_center('SubmitPay', _("Update Compensation"), true, '', 'default');

    div_end();
}

//Entry form for employee taxes and deductions
//--------------------------------------------------------------------------------------------
function employee_taxes($selected_id){

    if(!db_has_payroll_tax_types()){
	display_error("No tax types have been defined");
	return;
    }

}

/////////////////////////////////////////////////////
//Page Director
/////////////////////////////////////////////////////

page(_($help_context = "Manage Employees"), @$_REQUEST['popup'], false, "", $js); //TODO look into help_context and 'popup'

start_form();

$selected_id = get_post('EmpId','');

//top selector box for adding/editing employees
//--------------------------------------------------------------------------------------------
if (db_has_employees()){
	start_table(TABLESTYLE_NOBORDER);
	start_row();
	employee_list_cells(_("Select an employee: "), 'EmpId', null,
		_('New employee'), true, check_value('show_inactive'));
	check_cells(_("Show inactive:"), 'show_inactive', null, true);
	end_row();
	end_table();

	if (get_post('_show_inactive_update')) {
		$Ajax->activate('EmpId');
		set_focus('EmpId');
	}
} else {
    display_notification("Time to enter some employees, eh?");
    hidden('EmpId');
}

//--------------------------------------------------------------------------------------------

if (isset($_POST['submit'])) 
  handle_submit($selected_id);

//--------------------------------------------------------------------------------------------
$edit_id = find_submit("EditPay");
if ($edit_id != -1){
	$myrow = db_fetch(get_employee_compensation($selected_id, $edit_id));
	$_POST['pay_type'] = $myrow['pay_type_id'];
	$_POST['rate'] = $myrow['pay_rate'];
	$_POST['rate_id'] = $edit_id;
	$Ajax->activate('comp_table');
}

//--------------------------------------------------------------------------------------------
$delete_id = find_submit("DeletePay");
if ($delete_id != -1)
  handle_delete_pay($delete_id);

//--------------------------------------------------------------------------------------------
if (isset($_POST['SubmitPay'])){
  handle_submit_pay($selected_id);
}

//--------------------------------------------------------------------------------------------
if (get_post('_pay_type_update')) {
    $_POST['rate'] = get_default_pay_rate($_POST['pay_type']);
    $Ajax->activate('rate');
    set_focus('rate');
}

//--------------------------------------------------------------------------------------------
if (get_post('_EmpInactive_update')) {
    $Ajax->activate('EmpReleaseDate');
    set_focus('EmpReleaseDate');
}

//--------------------------------------------------------------------------------------------

if (!$selected_id)
  unset($_POST['_tabs_sel']); // force settings tab for new employee

tabbed_content_start('tabs', array(
		     'settings' => array(_('&General settings'), $selected_id),
		     'comp' => array(_('&Compensation'), $selected_id),
		     'taxes' => array(_('&Taxes & Deductions'), $selected_id) ));

  switch (get_post('_tabs_sel')) {
    default:
    case 'settings':
      employee_settings($selected_id);
      break;
    case 'comp':
      employee_comp($selected_id);
      break;
    case 'taxes':
      employee_taxes($selected_id);
      break;
  }

br();
tabbed_content_end();

//--------------------------------------------------------------------------------------------
hidden('popup', @$_REQUEST['popup']);//What is this?
end_form();
end_page(@$_REQUEST['popup']);

?>