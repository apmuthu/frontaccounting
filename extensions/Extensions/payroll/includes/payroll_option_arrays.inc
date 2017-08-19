<?php
/////////////////////////////////////////////////////
//Arrays
/////////////////////////////////////////////////////
$states_array = array('AL'=>"Alabama",'AK'=>"Alaska",'AZ'=>"Arizona",'AR'=>"Arkansas",'CA'=>"California",
			'CO'=>"Colorado",'CT'=>"Connecticut",'DE'=>"Delaware",'DC'=>"District Of Columbia",'FL'=>"Florida",
			'GA'=>"Georgia",'HI'=>"Hawaii",'ID'=>"Idaho",'IL'=>"Illinois", 'IN'=>"Indiana", 
			'IA'=>"Iowa",  'KS'=>"Kansas",'KY'=>"Kentucky",'LA'=>"Louisiana",'ME'=>"Maine",
			'MD'=>"Maryland", 'MA'=>"Massachusetts",'MI'=>"Michigan",'MN'=>"Minnesota",'MS'=>"Mississippi",
			'MO'=>"Missouri",'MT'=>"Montana",'NE'=>"Nebraska",'NV'=>"Nevada",'NH'=>"New Hampshire",
			'NJ'=>"New Jersey",'NM'=>"New Mexico",'NY'=>"New York",'NC'=>"North Carolina",'ND'=>"North Dakota",
			'OH'=>"Ohio",'OK'=>"Oklahoma", 'OR'=>"Oregon",'PA'=>"Pennsylvania",'RI'=>"Rhode Island",
			'SC'=>"South Carolina",'SD'=>"South Dakota",'TN'=>"Tennessee",'TX'=>"Texas",'UT'=>"Utah",
			'VT'=>"Vermont",'VA'=>"Virginia",'WA'=>"Washington",'WV'=>"West Virginia",'WI'=>"Wisconsin",'WY'=>"Wyoming");

$rate_status_array = array('1'=>"Single",'2'=>"Married");

$paytype_array = array('1'=>"Salary",'2'=>"Per Unit", '3'=>"Lump Sum");//others?

$payroll_tax_type_array = array('1'=>"Tiered",'2'=>"Percent with Threshold", '3'=>"Percent", '4'=>"Fixed Amount");

/////////////////////////////////////////////////////
//Functions
/////////////////////////////////////////////////////
function get_payfreq_array(){
    $payfreq_array = array('260'=>"Daily",
			    '52'=>"Weekly",
			    '26'=>"Bi-weekly",
			    '24'=>"Semi-monthly",
			    '12'=>"Monthly",
			    '4'=>"Quarterly",
			    '1'=>"Annually");

    return $payfreq_array;
}

//--------------------------------------------------------------------------------------------
function get_filing_status_array(){
    $filing_status_array = array('1' => "Single", 
				 '2' => "Married", 
				 '0' => "Do Not Withold");

    return $filing_status_array;
}

//--------------------------------------------------------------------------------------------
function get_emp_role_array(){// so far, just informational - does not enter into any calculations JM 01/05/12
    $emp_role_array = array('1'=>"Regular",
			    '2'=>"Officer",
			    '3'=>"Statutory",
			    '4'=>"Owner");

    return $emp_role_array;
}
//--------------------------------------------------------------------------------------------
function payroll_combobox($name, $selected_id, $array, $echo=false){

  $string = "<select name=$name>";

  foreach($array as $key => $value){
    $selected = ($selected_id == $key)? ' selected="selected"' : '';
    $string .= '<option value="'.$key.'"'.$selected.'>'.$value.'</option>'."\n";
  }

  $string .= "</select>";

  if($echo)
    echo $string;//if we want to use this combobox directly
  else  
    return $string;
}

//function array_selector($name, $selected_id, $items, $options=null) from ui_lists.inc
//name is POST name
//selected_id is the item selected
//items is an array as value => description
//options is an array of optional functionality
//--------------------------------------------------------------------------------------------
function payroll_combo_cell($name, $selected_id, $array, $submit_on_change = false){

	echo "<td>";
	//echo payroll_combobox($name, $selected_id, $array);
	echo array_selector($name, $selected_id, $array, 
			    array( 'select_submit'=> $submit_on_change ) );
	echo "</td>\n";
}
//--------------------------------------------------------------------------------------------
function payroll_combo_row($label, $name, $selected_id, $array, $submit_on_change = false){

	echo "<tr><td class='label'>$label</td>";
	payroll_combo_cell($name, $selected_id, $array, $submit_on_change);
	echo "</tr>\n";
}



?>