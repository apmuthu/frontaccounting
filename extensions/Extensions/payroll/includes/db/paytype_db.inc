<?php

function add_payroll_pay_type($code, $name, $taxable, $cmethod, $account_code, $default_rate, $required, $automatic) {
	$sql = "INSERT INTO ".TB_PREF."payroll_pay_type (code, name, taxable, cmethod, account_code, default_rate, required, automatic, inactive) VALUES (".
	    db_escape($code).",".
	    db_escape($name).",".
	    db_escape($taxable).",".
	    db_escape($cmethod).",".
	    db_escape($account_code).",".
	    db_escape($default_rate).",".
	    db_escape($required).",".
	    db_escape($automatic).",0)";
	db_query($sql, "could not add pay type");
}

function update_payroll_pay_type($id, $code, $name, $taxable, $cmethod, $account_code, $default_rate, $required, $automatic) {
	$sql = "UPDATE ".TB_PREF."payroll_pay_type SET
	    code = ".db_escape($code).",
	    name = ".db_escape($name).",
	    taxable = ".db_escape($taxable).",
	    cmethod = ".db_escape($cmethod).",
	    account_code = ".db_escape($account_code).",
	    default_rate = ".db_escape($default_rate).",
	    required = ".db_escape($required).",
	    automatic = ".db_escape($automatic)."
	    WHERE id = ".db_escape($id);
	
	db_query($sql, "could not update pay type");
}

function get_all_payroll_pay_type($all=false) {
	$sql = "SELECT * FROM ".TB_PREF."payroll_pay_type";
	if (!$all)
		$sql .= " WHERE !inactive";
	
	return db_query($sql, "could not get all pay types");
} 

function get_payroll_pay_type($id) {
	$sql = "SELECT * FROM ".TB_PREF."payroll_pay_type WHERE id=".db_escape($id);
	$result = db_query($sql, "could not get pay type");
	return db_fetch($result);
}

function get_payroll_pay_type_name($id) {
	$sql = "SELECT name FROM ".TB_PREF."payroll_pay_type WHERE id=".db_escape($id);
	$result = db_query($sql, "could not get pay type");
	$row = db_fetch_row($result);
	return $row[0];
}

function get_payroll_pay_type_code($id) {
	$sql = "SELECT code FROM ".TB_PREF."payroll_pay_type WHERE id=".db_escape($id);
	$result = db_query($sql, "could not get pay type");
	$row = db_fetch_row($result);
	return $row[0];
}

function delete_payroll_pay_type($id) {
	$sql="DELETE FROM ".TB_PREF."payroll_pay_type WHERE id=".db_escape($id);
	db_query($sql,"the other income type could not be deleted");

//SC: TODO: delete this from employee-paytype map
}

//JM: 23/04/12 -- pulled from main payroll_db.inc
//--------------------------------------------------------------------------------------------
function get_pay_type_array(){
    $sql = "SELECT id, name FROM ".TB_PREF."payroll_pay_type";
    $result = db_query($sql, "could not get pay rates");
    $type_array = array();
    while($myrow = db_fetch($result)){
	$type_array[$myrow['id']] = $myrow['name'];
    }
    return $type_array;
}

function get_default_pay_rate($id){
    $sql = "SELECT default_rate FROM ".TB_PREF."payroll_pay_type WHERE id=".db_escape($id);
    $result = db_query($sql, "could not get pay rates");
    $row = db_fetch_row($result);
    if (!$row[0]) return 0;
    return $row[0];
}

function db_has_pay_types(){
    return check_empty_result("SELECT COUNT(*) FROM ".TB_PREF."payroll_pay_type");
}

?>