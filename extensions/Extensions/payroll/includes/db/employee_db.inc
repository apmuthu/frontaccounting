<?php

//JM: 23/04/12 - consolidation of db includes

/////////////////////////////////////////////////////
//Employee Database Functions
/////////////////////////////////////////////////////
function add_employee($firstname, $lastname, $address, $phone, $email, $bdate, $payfreq, 
	$filing_status, $allowances, $extra_witholding, $taxid, $role, $hire_date, $notes)
{
	$sql = "INSERT INTO ".TB_PREF."employees (emp_first_name, emp_last_name, emp_address, emp_phone, emp_email, emp_birthdate, 
			emp_payfrequency, emp_filingstatus, emp_allowances,
			emp_extrawitholding, emp_taxid, emp_type, emp_hiredate, emp_notes) VALUES ("
		.db_escape($firstname).", "
		.db_escape($lastname).", "
		.db_escape($address).", "
		.db_escape($phone).", "
		.db_escape($email).", '"
		.date2sql($bdate)."', "
		.db_escape($payfreq).", "
		.db_escape($filing_status).", "
		.db_escape($allowances).", "
		.db_escape($extra_witholding).", "
		.db_escape($taxid).", "
		.db_escape($role).", '"
		.date2sql($hire_date)."', "
		.db_escape($notes).")";

	db_query($sql,"The employee could not be added");
}


//--------------------------------------------------------------------------------------------
function update_employee($firstname, $lastname, $address, $phone, $email, $bdate, $payfreq, 
	$filing_status, $allowances, $extra_witholding, $taxid, $role, $hire_date, $notes, $selected_id, $inactive, $release_date )
{

	$sql = "UPDATE ".TB_PREF."employees SET
		emp_first_name=".db_escape($firstname).",
		emp_last_name=".db_escape($lastname).",
		emp_address=".db_escape($address).",
		emp_phone=".db_escape($phone).",
		emp_email=".db_escape($email).",
		emp_birthdate='".date2sql($bdate)."',
		emp_payfrequency=".db_escape($payfreq).",
		emp_filingstatus=".db_escape($filing_status).",
		emp_allowances=".db_escape($allowances).",
		emp_extrawitholding=".db_escape($extra_witholding).",
		emp_taxid=".db_escape($taxid).",
		emp_type=".db_escape($role).",
		emp_hiredate='".date2sql($hire_date)."',
		emp_releasedate='".date2sql($release_date)."',
		inactive=".db_escape($inactive).",
		emp_notes=".db_escape($notes)."
		WHERE emp_id=".db_escape($selected_id);

	db_query($sql,"The employee could not be updated");

}

//--------------------------------------------------------------------------------------------
function get_all_employees($active=true){
  //get only active employees by default
  if ($active == true)
    $act_sql = "WHERE inactive = 0";

  $sql = "SELECT emp_id, emp_first_name, emp_last_name, emp_payfrequency, emp_filingstatus, emp_allowances FROM ".TB_PREF."employees $act_sql";
  
  return db_query($sql, "The employee table is inaccessible");

}

//--------------------------------------------------------------------------------------------
function get_employee($employee_id)
{
	$sql = "SELECT * FROM ".TB_PREF."employees WHERE emp_id=".db_escape($employee_id);

	$result = db_query($sql, "could not get employee");

	return db_fetch($result);
}

//--------------------------------------------------------------------------------------------
function db_has_employees()
{
	return check_empty_result("SELECT COUNT(*) FROM ".TB_PREF."employees");
}


//--------------------------------------------------------------------------------------------
function get_employee_compensation($emp_id, $rate_id=null){

    $sql = "SELECT types.name, rates.pay_rate, rates.id, rates.pay_type_id
	    FROM ".TB_PREF."employee_pay_rates AS rates JOIN ".TB_PREF."payroll_pay_type AS types
	    ON rates.pay_type_id = types.id
	    WHERE rates.emp_id = $emp_id";
  
    if ($rate_id != null)
	$sql .= " AND rates.id = $rate_id";

    $result = db_query($sql, "could not get pay rates");

    return $result;

}


//--------------------------------------------------------------------------------------------
function add_employee_compensation($emp_id, $pay_type_id, $rate){

    $sql = "INSERT INTO ".TB_PREF."employee_pay_rates (emp_id, pay_type_id, pay_rate)
	    VALUES ($emp_id, $pay_type_id, ".db_escape($rate).")";

  db_query($sql,"The pay rate could not be added/updated");

}


//--------------------------------------------------------------------------------------------
function update_employee_compensation($emp_id, $pay_type_id, $rate, $rate_id){

    $sql = "UPDATE ".TB_PREF."employee_pay_rates SET
	    emp_id = $emp_id,
	    pay_type_id = $pay_type_id,
	    pay_rate = ".db_escape($rate)."
	    WHERE id = $rate_id";

  db_query($sql,"The pay rate could not be added/updated");

}

//--------------------------------------------------------------------------------------------
function remove_employee_compensation($rate_id){

  $sql = "DELETE FROM ".TB_PREF."employee_pay_rates WHERE id = $rate_id";

  db_query($sql, "could not get pay rates");

}



?>