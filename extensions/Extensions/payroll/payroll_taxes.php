<?php
/*
  Form for entering Payroll Taxes
  Available tax types are tiered, percent with limit, and straight percentage

    Deprecated - this is going away, to be replaced by manageTaxes.php
*/

/////////////////////////////////////////////////////
//Includes
/////////////////////////////////////////////////////
$page_security = 'SA_PAYROLL';
$path_to_root = "../..";


//require($path_to_root . "/taxes/db/tax_types_db.inc");

include_once("includes/payroll_cart.inc");

include_once($path_to_root . "/includes/session.inc");
add_access_extensions();

include_once($path_to_root . "/includes/ui.inc");
include_once("includes/payroll_db.inc");
include_once("includes/payroll_option_arrays.inc");
/////////////////////////////////////////////////////
//Functions
/////////////////////////////////////////////////////

function list_payroll_taxes(){
  start_table(TABLESTYLE);

  $th = array(_("Description"), _("Tax Type"), _("Default Rate"), _("Threshold"),
	  _("Payroll GL Account"), _("Clearinghouse GL Account"), "","");//TODO look into clearinghouse account details for paying liabilities
  //inactive_control_column($th);
  table_header($th);

  $result = get_all_payroll_tax_types();//TODO make this just return one rate for listing purposes, return account names
  $k = 0;
  while ($myrow = db_fetch($result)){

    alt_table_row_color($k);

    label_cell($myrow["name"]);
    label_cell($myrow["type"]);
    label_cell('');//temp spacer
    label_cell('');//temp spacer
    label_cell('');//temp spacer
    //label_cell(percent_format($myrow["rate"]), "align=right");
    //label_cell($myrow["payroll_gl_code"] . "&nbsp;" . $myrow["PayrollAccountName"]);//TODO should we fetch the account names in get_all_payroll_tax_types
    label_cell($myrow["clearinghouse_gl_code"] . "&nbsp;" . get_gl_account_name($myrow["clearinghouse_gl_code"]));//or grab them like this?

    //inactive_control_cell($myrow["id"], $myrow["inactive"], 'tax_types', 'id');
    edit_button_cell("Edit".$myrow["id"], _("Edit"));
    delete_button_cell("Delete".$myrow["id"], _("Delete"));
    end_row();
  }
  //inactive_control_row($th);//TODO are we going to have active/inactive payroll taxes?
  end_table(2);
}

//--------------------------------------------------------------------------------------------
function display_main_payroll_tax_form($id){

  global $Ajax, $payroll_tax_type_array;

  if ($id == -1){ //not editing a record, new tax item
    $_POST['name'] = $_POST['allowance'] = $_POST['threshold'] = '';
  } else {
    $myrow = get_payroll_tax_type($id);
    $_POST['name'] = $myrow["name"];
    $_POST['tax_type'] = $myrow["type"];
    $_POST['allowance'] = $myrow["allowance"];
    $_POST['payroll_gl_code'] = $myrow["payroll_gl_code"];
    $_POST['clearinghouse_gl_code'] = $myrow["clearinghouse_gl_code"];
  }

  if (!isset($_POST['tax_type'])){
    $_POST['tax_type'] = '';
  }
  if (isset($_POST['_tax_type_update'])) {
    $Ajax->activate('type_table');
  }

  div_start("type_table");

  display_heading("Payroll Tax Entry");

  start_table(TABLESTYLE2);

  text_row(_("Description:"), 'name', $_POST['name'], 40, 80);

  payroll_combo_row(_("Type:"), 'tax_type', $_POST['tax_type'], $payroll_tax_type_array, true); //tiered, adv percent, percent, fixed amount
   switch($_POST['tax_type']){
    case 1 ://Tiered
      amount_row(_("Annual Allowance:"), 'allowance', $_POST['allowance']);
      break;
    case 2 ://Percentage with threshold
      small_amount_row(_("Tax Rate:"), 'rate', '', "", "%", user_percent_dec());//TODO what is user_percent_dec?
      amount_row(_("Threshold:"), 'threshold', $_POST['threshold']);
      break;
    case 3 ://Straight percentage
      small_amount_row(_("Tax Rate:"), 'rate', '', "", "%", user_percent_dec());//TODO what is user_percent_dec?
      break;
  }

  gl_all_accounts_list_row(_("Payroll Accrual Account:"), 'payroll_gl_code', null);//which account are we posting to?
  gl_all_accounts_list_row(_("Clearinghouse Account:"), 'clearinghouse_gl_code', null);//which account are we using to pay from? Money will be moved from accrual account to clearinghouse account when tax is paid.

  end_table(1);

  div_end();
}

//--------------------------------------------------------------------------------------------
function can_process(){

  if (strlen($_POST['name']) == 0){
    display_error(_("You have to call this tax something."));
    set_focus('name');
    return false;
  }
 
  //TODO run the rest of the checks

  return true;
}

//--------------------------------------------------------------------------------------------
function handle_submit(&$selected_id){//note: this is a pointer to $selected_id
  global $Ajax;


  if (!can_process())
    return;

display_notification("the handler made it past can_process with $selected_id");

  if ($selected_id == -1){ // a new record
    begin_transaction();
    add_payroll_tax_type($_POST['name'], $_POST['tax_type'], $_POST['payroll_gl_code'], $_POST['clearinghouse_gl_code'], $_POST['allowance']);

    $selected_id = $_POST['id'] = db_insert_id();

    if ($_POST['tax_type'] = 1){ // a tiered tax_type
      //loop through the cart and add each line item
      //add_tax_rates($_POST['id'], $_POST['rate'], $_POST['threshold'],  $_POST['status']);  
    } else {
      add_payroll_tax_rates($selected_id, $_POST['rate'], $_POST['threshold']); 
    }

    commit_transaction();

    display_notification(_("A new tax type has been added."));
		
    $Ajax->activate('_page_body');

  } else { //editing a record
    update_payroll_tax_type($_POST['name'], $_POST['tax_type'], $_POST['payroll_gl_code'], $_POST['clearinghouse_gl_code'], $_POST['allowance']);

    if ($_POST['tax_type'] = 1){ // a tiered tax_type
      //loop through the cart and add each line item
      //update_payroll_tax_rates($_POST['id'], $_POST['rate'], $_POST['threshold'],  $_POST['status']);  
    } else {
      update_payroll_tax_rates($selected_id, $_POST['rate'], $_POST['threshold']);
    }

    $Ajax->activate('id'); // in case of status change //html field name
    display_notification(_("The tax information has been updated."));
  }
}

/////////////////////////////////////////////////////
//Page Flow
/////////////////////////////////////////////////////

page(_($help_context = "Payroll Taxes"));//how do we make "help context"?

$selected_id = find_submit('Edit');//edit main tax type

//--------------------------------------------------------------------------------------------
if (isset($_POST['submit'])) 
{
	handle_submit($selected_id);
}
//--------------------------------------------------------------------------------------------

start_form();

display_note(_("To avoid problems with manual journal entry all tax types should have unique Payroll GL accounts."), 0, 1);

list_payroll_taxes();

display_main_payroll_tax_form($selected_id);

//display_rate_table($selected_id);

display_notification("selected id is currently $selected_id");

if ($selected_id == -1){
  submit_center('submit', _("Add New"), true, '', 'default');
} else {
  submit_center('submit', _("Update"), _('Update tax info'), @$_REQUEST['popup'] ? true : 'default');
}

//hidden('popup', @$_REQUEST['popup']);//what is the popup?
end_form();
end_page(@$_REQUEST['popup']);

?>