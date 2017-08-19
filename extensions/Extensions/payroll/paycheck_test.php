<?php
/////////////////////////////////////////////////////
//Test for paycheck calculations
/////////////////////////////////////////////////////
$path_to_root="../..";
require("includes/payroll_cart.inc");
include($path_to_root . "/includes/session.inc");
require("includes/payroll_calc.inc");
require("includes/payroll_db.inc");

$gross = 866;
$allowances = 0;
$per_allowance = 3800;
$payfreq = 52;
$ytd = 6500;
echo "Gross pay is ".$gross."</br>";

  if (isset($_SESSION['paychecks'])){
    unset ($_SESSION['paychecks']);
  }
  
  $cart = new payroll_cart('paycheck');

  $result = get_all_employees();
  while ($myrow = db_fetch($result)){
    $cart->add_employee($myrow['emp_id'], $myrow['emp_name'], $myrow['emp_payfrequency'], $myrow['emp_filingstatus'], $myrow['emp_allowances']);
  }

  $_SESSION['paychecks'] = &$cart;

$cart->check_employee(1, 1);
$cart->employees[1]->comp_items['Salary']['units'] = 40;

foreach ($cart->employees as $employee){
  foreach ($employee->comp_items as $name => $comp_item){
  print_r($name);
  echo "</br>";
  print_r($comp_item['units']);
  echo "</br></br>";
  }
}


$fed_array = get_payroll_tax_rates_array(5, 2);

$fed = calculate_tiered($gross, $fed_array, $allowances, $per_allowance, $payfreq);
echo "Federal witholding tax for is ".$fed."</br>";

$sser_array = get_payroll_tax_rates_array(1);
$SSER = calculate_adv_percent($gross, $sser_array, $ytd);
echo "Social Security Employer tax is ".$SSER."</br>";

$ssee_array = get_payroll_tax_rates_array(2);
$SSEE = calculate_adv_percent($gross, $ssee_array, $ytd);
echo "Social Security Employee tax is ".$SSEE."</br>";

$mcer_rate = get_payroll_tax_rates_array(3);
$MCER = calculate_percent($gross, $mcer_rate);
echo "Medicare Employer tax is ".$MCER."</br>";

$mcee_rate = get_payroll_tax_rates_array(4);
$MCEE = calculate_percent($gross, $mcee_rate);
echo "Medicare Employee tax is ".$MCEE."</br>";

$futa_array = get_payroll_tax_rates_array(6);
$FUTA = calculate_adv_percent($gross, $futa_array, $ytd);
echo "FUTA is ".$FUTA."</br>";
$suta_array = get_payroll_tax_rates_array(7);
$SUTA = calculate_adv_percent($gross, $suta_array, $ytd);
echo "SUTA is ".$SUTA."</br></br>";

$net = $gross - $fed - $SSEE - $MCEE;
echo "Net pay is ".$net."</br>";

?>
