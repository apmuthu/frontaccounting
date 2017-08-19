<?php
/*
  Paycheck.php
  Begin to process paychecks
    list employees, enter hours, set pay period
    submit for calculation and review
*/

/////////////////////////////////////////////////////
//Includes
/////////////////////////////////////////////////////
$page_security = 'SA_PAYROLL';
$path_to_root="../..";

require("includes/payroll_cart.inc");

include($path_to_root . "/includes/session.inc");
add_access_extensions();

$js = "";
if ($use_popup_windows)
	$js .= get_js_open_window(900, 500);
if ($use_date_picker)
	$js .= get_js_date_picker();

include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/includes/data_checks.inc");

require("includes/payroll_calc.inc");
require("includes/payroll_db.inc");

/////////////////////////////////////////////////////
//UI Functions
/////////////////////////////////////////////////////

function display_payperiod_settings(){

  start_outer_table(TABLESTYLE2);
  table_section(1);
  date_row("Pay Period Ends:", 'PayPeriodEnd');//TODO suggest day after end of last pay period?
  date_row("Check date:", "CheckDate");

  table_section(2);
  bank_accounts_list_row("Bank Account:", "BankAccount");//, $selected_id); //TODO get the last used (or default) bank account
  end_outer_table(1);
}

//display the employees paytable for input and review
//--------------------------------------------------------------------------------------------
function list_employees_pay_table($table){
    
    div_start('pay_table');

    start_table(TABLESTYLE);//width? , "width=60%"

    if ($table == 'begin'){

      $temp_pay_type_array = array("Salary", "Hourly", "Overtime");//TODO grab this from the db - these should only be pay types that are currently assigned to employees
      $th = array(("check"),_("Name"));
      foreach($temp_pay_type_array as $header){
	$th[] = $header;
      }

    } else if ($table == 'review'){

      $th = array(_("Name"), _("Gross Pay"),_("Taxes"), _("Deductions"), _("Net Pay"), _("Employer Taxes"));

    }

    table_header($th);

    $k = 0;
    foreach ($_SESSION['paychecks']->employees as $employee){
      
      alt_table_row_color($k);
      
      if ($table == 'begin'){

	check_cells(null, "check".$employee->id, $employee->checked, true, '', "width=15 align=center");//to select which employees to pay
	label_cell($employee->name);
	  
	foreach($temp_pay_type_array as $type){
	  if (array_key_exists($type, $employee->comp_items)){
	    
	    text_cells(null, $type.$employee->id, isset($employee->comp_items[$type]['units']) ? $employee->comp_items[$type]['units'] : "get_last_units()", 8, 4);//TODO pre-fill this with hours from last paycheck?
	  } else {
	    label_cell('');//blank cell for non $type employees
	  }
	}

      } else if ($table == 'review'){
	if ($employee->checked){
	  label_cell($employee->name);//TODO make this a link for a popup window with paycheck details
	  label_cell($employee->gross);  
	  label_cell($employee->get_employee_tax_total());
	  label_cell("0");//TODO calculate deductions
	  label_cell($employee->net_pay);
	  label_cell($employee->get_employer_tax_total());
	}

      }
      end_row();
    }

    end_table(1);
    //div_end();

   // div_start('controls');
      if ($table == 'begin'){
	submit_center('PreProcess', _("Proceed"), true, true, 'default');
      } else if ($table == 'review'){
	submit_center_first('Start', _("Back"), true, true, 'default');
	submit_center_last('Process', _("Process"), true, true, 'default');
      }
    div_end();

}

/////////////////////////////////////////////////////
//Data Functions
/////////////////////////////////////////////////////
//--------------------------------------------------------------------------------------------
function create_payroll_cart(){

  if (isset($_SESSION['paychecks'])){//necessary?
    unset ($_SESSION['paychecks']);
  }
  
  $cart = new payroll_cart('paycheck');

  $result = get_all_employees();
  while ($myrow = db_fetch($result)){
    $cart->add_employee($myrow['emp_id'], 
			$myrow['emp_first_name']." ".$myrow['emp_last_name'], 
			$myrow['emp_payfrequency'], 
			$myrow['emp_filingstatus'], 
			$myrow['emp_allowances'],
 			get_employee_pay_array($myrow['emp_id']),
			get_employee_ytd($myrow['emp_id']));
  }
  
  $result = get_all_payroll_tax_types();
  while ($myrow = db_fetch($result)){
    $cart->add_tax($myrow['id'], 
		   $myrow['name'], 
		   $myrow['type'], 
		   $myrow['responsibility'], 
		   $myrow['allowance'], 
		   $myrow['payroll_gl_code'],
		   get_payroll_tax_rates($myrow['id']));
  }

  $_SESSION['paychecks'] = &$cart;
}


/////////////////////////////////////////////////////
//Page Director
/////////////////////////////////////////////////////
//page has just loaded
page("Enter Paycheck Information");
start_form();

//display top table with pay period date, check date, and bank account info
display_payperiod_settings();

//build the employee cart
//--------------------------------------------------------------------------------------------
if ((isset($_GET['NewCart'])) && ($_GET['NewCart']== true)){//TODO a better way to do this. The cart only needs to be initiated once, when the page is first loaded
  create_payroll_cart();
}

//display bottom table with employee info
//display the employee list and await user input for hours, etc
//--------------------------------------------------------------------------------------------
if(((!isset($_POST['PreProcess'])) && (!isset($_POST['Process']))) || (isset($_POST['Process']))){//this should only be displayed before we get the hours and checks

  if (!$_SESSION['paychecks']->count_employees())
    display_notification("There are no employees to pay.");
  else
  list_employees_pay_table('begin');

  $Ajax->activate('pay_table');
}

//update the "checked" status of each employee on form change
//--------------------------------------------------------------------------------------------
if ($id = find_submit("_check")){
  $switch = get_post("check".$id);
  if ($id != -1){
    $_SESSION['paychecks']->check_employee($id, $switch);
  }
}

//check that we have some selected employee(s) and that they have some units entered
//--------------------------------------------------------------------------------------------
if(isset($_POST['PreProcess'])){
  $temp_pay_type_array = array("Salary", "Hourly", "Overtime");//TODO grab this from the db
  $check_test = 0;
  foreach($_SESSION['paychecks']->employees as $employee){ //see if any employee is checked 
    if ($employee->checked){
      $employee->gross = 0;//in case we need to go back through to correct errors
      $check_test = 1;
      $units_test = 0;// test going into the next loop
      foreach($employee->comp_items as $name => $comp_item){
	      	if ((strlen($_POST[$name.$employee->id])>0) && (check_num($name.$employee->id, 0))){
	  //$comp_item[$name]['units'] = ;
	  $employee->add_gross_pay($name, $_POST[$name.$employee->id]);
	  $units_test = 1;
	} else if ((strlen($_POST[$name.$employee->id])>0) && (!check_num($name.$employee->id, 0))){//something has been entered, but it isn't numeric or it's negative
	  display_error("Units entered for ".$employee->name." must be numeric and not less than zero");
	  unset($_POST['PreProcess']);
	  break 2;
	}
      }//end foreach "comp_item" test
      if(!$units_test){//employee has been checked, but has no units listed
	display_error($employee->name." has been selected, but no hours/units have been entered");
	unset($_POST['PreProcess']);
	break;
      }
    }//end if "checked" test
  }//end foreach employee

  if(!$check_test){
    display_error("No employees have been selected");
    unset($_POST['PreProcess']);
  }

}

//test has passed, so figure the calculations for review
//--------------------------------------------------------------------------------------------
if(isset($_POST['PreProcess'])){

  $_SESSION['paychecks']->render_unto_caesar();
  
  list_employees_pay_table('review');

  $Ajax->activate('pay_table');
}

//enter the paycheck(s) to the db as journal entries
//--------------------------------------------------------------------------------------------
if(isset($_POST['Process'])){

  //TODO send all the paycheck information to the db in a journal entry per employee

  display_notification("Paychecks have been entered");
  
  //completed, unset the cart
  //unset($_SESSION['paychecks']);
}


end_form();
end_page();

?>  
 
