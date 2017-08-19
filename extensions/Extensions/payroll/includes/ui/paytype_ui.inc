<?php

//computing method for other income type
$payroll_paytype_cmethod = array(
//    0 => _('not used'),
    1 => _('Base Salary'),  //
    2 => _('Contract Based'), // contract based
    3 => _('Fixed Amount'), // eg. transport allowance
    4 => _('Percent of base'), // eg. radiation exposure increase
    5 => _('multiply w/ # of working days'), // eg. lunch tickets
    6 => _('multiply w/ # of regular working hours'), // timesheet based
    7 => _('multiply w/ # of overtime hours'),

);


function payroll_paytype_cmethod_list_row($label, $name, $selected_id=null, $submit_on_change=false) {
	global $payroll_paytype_cmethod;
		
	echo "<tr><td class='label'>$label</td><td>";
	$options = array(
	    'select_submit'=> $submit_on_change
	);
	echo array_selector($name, $selected_id, $payroll_paytype_cmethod, $options);
	echo "</td></tr>\n";
}









?>