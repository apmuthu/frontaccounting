<?php

$payroll_payfreq = array(
    '260'=>"Daily",
    '52'=>"Weekly",
    '26'=>"Bi-weekly",
    '24'=>"Semi-monthly",
    '12'=>"Monthly",
    '4'=>"Quarterly",
    '1'=>"Annually"
);

$payroll_filing_status= array(
    '1' => "Single", 
    '2' => "Married", 
    '0' => "Do Not Withold"
);

$payroll_emp_role = array(
    '1'=>"Regular",
    '2'=>"Officer",
    '3'=>"Statutory",
    '4'=>"Owner"
);


//--------------------------------------------------------------------------------------------
function payroll_payfreq_list_row($label, $name, $selected_id=null, $submit_on_change=false) {
	global $payroll_payfreq;
		
	echo "<tr><td class='label'>$label</td><td>";
	$options = array(
	    'select_submit'=> $submit_on_change
	);
	echo array_selector($name, $selected_id, $payroll_payfreq, $options );
	echo "</td></tr>\n";
}

//--------------------------------------------------------------------------------------------
function payroll_filing_status_list_row($label, $name, $selected_id=null, $submit_on_change=false) {
	global $payroll_filing_status;
		
	echo "<tr><td class='label'>$label</td><td>";
	$options = array(
	    'select_submit'=> $submit_on_change
	);
	echo array_selector($name, $selected_id, $payroll_filing_status, $options );
	echo "</td></tr>\n";
}

//--------------------------------------------------------------------------------------------
function payroll_emp_role_list_row($label, $name, $selected_id=null, $submit_on_change=false) {
	global $payroll_emp_role;
		
	echo "<tr><td class='label'>$label</td><td>";
	$options = array(
	    'select_submit'=> $submit_on_change
	);
	echo array_selector($name, $selected_id, $payroll_emp_role, $options );
	echo "</td></tr>\n";
}

//--------------------------------------------------------------------------------------------
function payroll_pay_type_list_row($label, $name, $selected_id=null, $submit_on_change=false) {
		
	echo "<tr><td class='label'>$label</td><td>";
	$options = array(
	    'select_submit'=> $submit_on_change
	);
	echo array_selector($name, $selected_id, get_pay_type_array(), $options );
	echo "</td></tr>\n";
}

//based on ui_lists.inc
//customer_list function
//--------------------------------------------------------------------------------------------
function employee_list($name, $selected_id=null, $spec_option=false, $submit_on_change=false, 
	$show_inactive=false, $editkey = false)
{
	global $all_items;

	$sql = "SELECT emp_id, CONCAT_WS(' ', emp_first_name, emp_last_name), inactive FROM ".TB_PREF."employees ";

	$mode = 0;//We don't have many employees, hardcoding to no search

	if ($editkey)
		set_editor('employee', $name, $editkey);//what is this? //set_editor defined in ui_controls.inc

	$ret = combo_input($name, $selected_id, $sql, 'emp_id', 'emp_first_name', //sql fields
	array(
	    //'format' => '_format_add_curr',
	    'order' => array('emp_first_name'),//order by sql field 
		'search_box' => $mode!=0,
		'type' => 1,
		'size' => 20,
		'spec_option' => $spec_option === true ? _("All Employees") : $spec_option,
		'spec_id' => $all_items,//what is this?
		'select_submit'=> $submit_on_change,
		'async' => false,
		'sel_hint' => $mode ? _('Press Space tab to filter by name fragment; F2 - entry new employee') :
		_('Select employee'),
		'show_inactive' => $show_inactive
	) );
	if ($editkey)
		$ret .= add_edit_combo('employee');
	return $ret;
}

//--------------------------------------------------------------------------------------------
function employee_list_cells($label, $name, $selected_id=null, $all_option=false, 
	$submit_on_change=false, $show_inactive=false, $editkey = false)
{
	if ($label != null)
		echo "<td>$label</td>\n";
	echo "<td nowrap>";
	echo employee_list($name, $selected_id, $all_option, $submit_on_change,
		$show_inactive, $editkey);
	echo "</td>\n";
}

?> 
