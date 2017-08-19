<?php
/*
  Cart functions for payroll items
  paycheck_item is for getting employees ready for paycheck processing
  tiered_item is for inputting and modifying tiered tax rates

*/

/////////////////////////////////////////////////////
//Includes
/////////////////////////////////////////////////////



/////////////////////////////////////////////////////
//Classes
/////////////////////////////////////////////////////
//based on includes/ui/items_cart.inc
class payroll_cart {

  var $trans_type;
  var $employees;
  var $taxes;
  var $tiered_items;
  var $period_start;
  var $period_end;
  var $trans_date;
  var $account;

  function payroll_cart($type){
    $this->trans_type = $type;
    $this->clear_items();
  }

  // ------------ employee functions ------------------------
  function add_employee($id, $name, $payfreq, $status, $allowances, $pay_array, $ytd){
    $this->employees[$id] = new employee($id, $name, $payfreq, $status, $allowances, $pay_array, $ytd);
  }

  function count_employees(){
    return count($this->employees);
  }

  function check_employee($id, $switch){
    $this->employees[$id]->checked = $switch == 1 ? 1:0;
  }

  // ------------ tax functions -----------------------------
  function add_tax($id, $name, $type, $responsibility, $allowance, $payroll_account, $rates){
    $this->taxes[$id] = new tax($id, $name, $type, $responsibility, $allowance, $payroll_account, $rates);
  }


/*  // ------------ tiered rate functions ---------------------
  function add_tiered_item($status, $rate, $threshold){

    if (isset($status) && isset($rate)  && isset($threshold))
      {
	
	$this->tiered_items[] = new tiered_item($status, $rate, $threshold);
	return true;
      } else {
	// shouldn't come here under normal circumstances
	display_error("unexpected - invalid parameters in add_tiered_item($status, $rate, $threshold,...)", "", true);
      }

      return false;
  }

  //---------------------------------------------------
  function update_tiered_item($index, $status, $rate, $threshold){
    $this->tiered_items[$index]->dimension_id = $status;
  }

  //---------------------------------------------------
  function remove_tiered_item($index){
    array_splice($this->tiered_items, $index, 1);
  }

  //---------------------------------------------------
  function count_tiered_items(){
    return count($this->tiered_items);
  }
*/
  // ------------ common functions --------------------------

  
  function render_unto_caesar(){//calculate all the taxes owed
    foreach($this->employees as $employee){
      if ($employee->checked){
	$employee->net_pay = $employee->gross;
	foreach ($this->taxes as $tax){
	  switch($tax->type){
	    case 1:
	      if ($employee->status != 0){
		$amount = calculate_tiered($employee->gross, 
					  $tax->rates[$employee->status], 
					  $employee->allowances, 
					  $tax->allowance, 
					  $employee->payfreq);
	      } else {
		$amount = 0;
	      }
	      continue;
	    case 2:
	      $amount = calculate_adv_percent($employee->gross, $tax->rates, $employee->ytd);
	      continue;
	    case 3:
	      $amount = calculate_percent($employee->gross, $tax->rates);
	      continue;
	  }
	  if ($tax->responsibility == 'er'){
	    $employee->er_taxes_array[$tax->name] = $amount;
	  } else if ($tax->responsibility == 'ee'){
	    $employee->ee_taxes_array[$tax->name] = $amount;
	    $employee->net_pay -= $amount;
	  }
	}
      }
    }

  }

  function clear_items(){
    unset($this->employees);
      $this->employees = array();

    unset($this->tiered_items);
      $this->tiered_items = array();
  }

}

//--------------------------------------------------------------------------------------------
class employee {
  var $id; 
  var $name; 
  var $comp_items;//payroll type name => (pay_type_id, pay_type, pay_rate, units)
  var $payfreq;
  var $status;
  var $allowances;
  var $gross;
  var $net_pay;
  var $ytd;
  var $checked;


  var $ee_taxes_array;//employee liabilites as liability => amount
  var $ee_deductions_array;//employee deductions as deduction => amount
  var $er_taxes_array;//employer liabilites as liability => amount


 
  function employee($id, $name, $payfreq, $status, $allowances, $pay_array, $ytd){
    $this->id = $id;
    $this->name = $name;
    $this->payfreq = $payfreq;
    $this->status = $status;
    $this->allowances = $allowances;
    $this->comp_items = $pay_array;
    $this->ytd = $ytd;
  }
  
  //class functions
  //---------------------------------------------------
  function add_gross_pay($pay_type_name, $units){
    $type = $this->comp_items[$pay_type_name]['pay_type'];
    $rate = $this->comp_items[$pay_type_name]['pay_rate'];
    $this->comp_items[$pay_type_name]['units'] = $units;
    $freq = $this->payfreq;
    
    switch ($type){
      case 1://yearly rate, units are just stored for tracking purposes
	//gross is figured by annual pay/frequency
	$gross = $rate/$freq;
	break;
      case 2://pay per unit type
	$gross = $rate*$units;
	break;
      case 3://lump sum
	$gross = $units;
	break;
    }
  
    $this->gross += $gross;
    
  }

  //---------------------------------------------------
  function get_employee_tax_total(){
    $tax = 0;
    foreach ($this->ee_taxes_array as $liability => $amount){
      $tax += $amount;
    }
    return $tax;
  }

  //---------------------------------------------------
  function get_employer_tax_total(){
    $tax = 0;
    foreach ($this->er_taxes_array as $liability => $amount){
      $tax += $amount;
    }    
    return $tax;
  }
}


//--------------------------------------------------------------------------------------------
class tax {

  var $id;
  var $name;
  var $type;
  var $responsibility;
  var $allowance;
  var $payroll_account;
  var $rates;


  function tax($id, $name, $type, $responsibility, $allowance, $payroll_account, $rates){
    $this->id = $id;
    $this->name = $name;
    $this->type = $type;
    $this->responsibility = $responsibility;
    $this->allowance = $allowance;
    $this->payroll_account = $payroll_account;
    $this->rates = $rates;
  }

  //class functions
  //---------------------------------------------------


}


//--------------------------------------------------------------------------------------------
class tiered_item {

  var $type_id;
  var $rate_id;
  var $status;
  var $rate;
  var $threshold;

  function tiered_item($status, $rate, $threshold){
    //$this->type_id = $type_id;
    //$this->rate_id = $rate_id;
    $this->status = $status;
    $this->rate = $rate;
    $this->threshold = $threshold;
  }
}

?> 
