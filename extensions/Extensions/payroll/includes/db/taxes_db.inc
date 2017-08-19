<?php

/////////////////////////////////////////////////////
//Payroll Tax Database Functions
/////////////////////////////////////////////////////

//--------------------------------------------------------------------------------------------
function add_payroll_tax_type ($code, $name, $type, $responsibility, $tax_base, $accrual_gl_code, $expense_gl_code, $tax_period) {
    $sql = "INSERT INTO ".TB_PREF."payroll_tax_type (code, name, type, responsibility, tax_base, accrual_gl_code, expense_gl_code, tax_period)
	VALUES (".
	db_escape($code).", ".
	db_escape($name).", ".
	db_escape($type).", ".
	db_escape($responsibility).", ".
	db_escape($tax_base).", ".
	db_escape($accrual_gl_code).", ".
	db_escape($expense_gl_code).", ".
	db_escape($tax_period).")";

    db_query($sql,"The tax type could not be added");
}

//-----------------------------------------------------------------------------------------------------------
function update_payroll_tax_type($id, $code, $name, $type, $responsibility, $tax_base, $accrual_gl_code, $expense_gl_code, $tax_period) {
    $sql = "UPDATE ".TB_PREF."payroll_tax_type SET
	    code = ".db_escape($code).",
	    name = ".db_escape($name).",
	    type = ".db_escape($type).",
	    responsibility = ".db_escape($responsibility).",
	    tax_base = ".db_escape($tax_base).",
	    accrual_gl_code = ".db_escape($accrual_gl_code).",
	    expense_gl_code = ".db_escape($expense_gl_code).",
	    tax_period = ".db_escape($tax_period)."
	    WHERE id = ".db_escape($id);
	
	db_query($sql, "could not update the tax type");
}

//-----------------------------------------------------------------------------------------------------------
function get_payroll_tax_type($id) {
    $sql = "SELECT * FROM ".TB_PREF."payroll_tax_type WHERE id=".db_escape($id);
    $result = db_query($sql, "could not get tax type");
    return db_fetch($result);
}

//-----------------------------------------------------------------------------------------------------------
function get_payroll_tax_types() {
    $sql = "SELECT * FROM ".TB_PREF."payroll_tax_type";
    return db_query($sql, "could not get taxes");
}
//-----------------------------------------------------------------------------------------------------------
/*
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `tt_id` INT(11) NOT NULL, -- foreign key payroll_tax_type
  `bracket` VARCHAR(3) NOT NULL, -- user assigned unique code
  `value_from` FLOAT, -- from this value this bracket applies
  `value_to` FLOAT, -- until this value this bracked applies
  `tax_amount` FLOAT, -- on this bracket, there is this fixed amount as tax
  `variable_from` FLOAT, -- what exceeds this amount is charged by percent
  `fixed_tax_percent` FLOAT, -- percent of charge
  `variable` FLOAT, -- variable parameter
  `variable_tax_percent` FLOAT, -- percent of charge, to be multiplied by variable
*/
function add_payroll_tax_table_data($table_id, $value_from, $value_to, $tax_amount, $variable_from, $fixed_tax_percent, $variable, $variable_tax_percent) {
 // SC: TODO: something relevant here
}

function update_payroll_tax_table_data($id, $table_id, $value_from, $value_to, $tax_amount, $variable_from, $fixed_tax_percent, $variable, $variable_tax_percent) {
 // SC: TODO: something relevant here
}

function delete_payroll_tax_table_data() {
 // SC: TODO: something relevant here
}

function get_tax_table_data($tt_id) {
    $sql = "SELECT * FROM ".TB_PREF."payroll_tax_rate WHERE tt_id=".db_escape($tt_id);
    return db_query($sql, "could not get tax table data");
}

function db_has_payroll_tax_types(){
    return check_empty_result("SELECT COUNT(*) FROM ".TB_PREF."payroll_tax_type");
}

//JM 23/04/12 - consolidating db includes
//all the following were extracted from the main payroll_db.inc and may or may not still be in use
//at the very least, these will need to be updated with the new table schema

//JM - this will be replaced by add_payroll_tax_table_data above 
//--------------------------------------------------------------------------------------------
function add_payroll_tax_rates($type_id, $rate, $threshold, $status=''){

  $sql = "INSERT INTO ".TB_PREF."payroll_tax_rates (type_id, rate, threshold, status)
	  VALUES ( $type_id, ".db_escape($rate).", ".db_escape($threshold).", ".db_escape($status).")";

  db_query($sql,"The tax rates could not be added");

}

//for retrieving tax rates and thresholds - JM - will be replaced by get_tax_table_data above
//--------------------------------------------------------------------------------------------
function get_payroll_tax_rates($id)
{

  $sql = "SELECT rate, threshold, status FROM ".TB_PREF."payroll_tax_rates WHERE type_id = $id ORDER BY status, threshold";

  $result = db_query($sql, "could not get tax rates");
      
  //$rates = array();
  while($myrow = db_fetch($result)){
    if (($myrow['status'] != null) && ($myrow['threshold'] != null)){
      $rates[$myrow['status']][$myrow['threshold']] = $myrow['rate'];
    } else if (($myrow['status'] == null) && ($myrow['threshold'] != null)){
      $rates[$myrow['threshold']] = $myrow['rate'];
    } else if (($myrow['status'] == null) && ($myrow['threshold'] == null)){
      $rates = $myrow['rate'];
    }
  }

  return $rates;
}
?>