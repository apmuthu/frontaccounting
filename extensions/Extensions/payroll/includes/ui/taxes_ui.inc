<?php

$payroll_tax_base = array(
  1 => _('Base Salary'),
  2 => _('Taxable Salary'),
);

$payroll_tax_deduction = array(
  1 => _('Tax'),
  2 => _('Deduction'),
);

$payroll_tax_responsibility = array(
  1 => _('Employee'),
  2 => _('Employer'),
);

$payroll_tax_period = array(
    1 => _('Annual'),
    2 => _('Semi-Annual'),
    4 => _('Quarterly'),
    12 => _('Monthly')
);


//-----------------------------------------------------------------------------------------------
function payroll_tax_types_list($name, $selected_id=null, $new_item=false, $submit_on_change=false, $show_inactive = false) {
	global $all_items;

	$sql = "SELECT id, name, inactive FROM ".TB_PREF."payroll_tax_type";

	$options = array(
		'spec_option'=>$new_item ? _("New tax type") : false,
		'spec_id' => '',
		'select_submit'=> $submit_on_change,
		'show_inactive' => $show_inactive,
	    );
	return combo_input($name, $selected_id, $sql, 'id', 'code', $options);
}

function payroll_tax_types_list_cells($label, $name, $selected_id=null, $new_item=false, $submit_on_change=false, $show_inactive = false) {
	if ($label != null)
		echo "<td>$label</td>\n";
	echo "<td>";
	echo payroll_tax_types_list($name, $selected_id, $new_item, $submit_on_change, $show_inactive);
	echo "</td>\n";
}



//-----------------------------------------------------------------------------------------------
function payroll_tax_resp_list_row($label, $name, $selected_id=null, $submit_on_change=false) {
	global $payroll_tax_responsibility;
		
	echo "<tr><td class='label'>$label</td><td>";
	$options = array(
	    'select_submit'=> $submit_on_change
	);
	echo array_selector($name, $selected_id, $payroll_tax_responsibility, $options );
	echo "</td></tr>\n";
}

//-----------------------------------------------------------------------------------------------
function payroll_tax_deduction_list_row($label, $name, $selected_id=null, $submit_on_change=false) {
	global $payroll_tax_deduction;
		
	echo "<tr><td class='label'>$label</td><td>";
	$options = array(
	    'select_submit'=> $submit_on_change
	);
	echo array_selector($name, $selected_id, $payroll_tax_deduction, $options );
	echo "</td></tr>\n";
}

//-----------------------------------------------------------------------------------------------
function payroll_tax_base_list_row($label, $name, $selected_id=null, $submit_on_change=false) {
	global $payroll_tax_base;
		
	echo "<tr><td class='label'>$label</td><td>";
	$options = array(
	    'select_submit'=> $submit_on_change
	);
	echo array_selector($name, $selected_id, $payroll_tax_base, $options );
	echo "</td></tr>\n";
}

//-----------------------------------------------------------------------------------------------
function payroll_tax_period_list_row($label, $name, $selected_id=null, $submit_on_change=false) {
	global $payroll_tax_period;
		
	echo "<tr><td class='label'>$label</td><td>";
	$options = array(
	    'select_submit'=> $submit_on_change
	);
	echo array_selector($name, $selected_id, $payroll_tax_period, $options );
	echo "</td></tr>\n";
}
?>