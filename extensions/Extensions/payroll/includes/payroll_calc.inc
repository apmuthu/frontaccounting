<?php
/*
  Payroll calculation functions
*/

/////////////////////////////////////////////////////
//Functions
/////////////////////////////////////////////////////

//complex tiered percentage calculation
//--------------------------------------------------------------------------------------------
function calculate_tiered($gross, $tiered_array, $allowances, $per_allowance, $payfreq){
  //$tiered_array is an array of thresholds => percentages as annual figures
  //returns the amount of tax owed
  
  //get the allowance for this pay period
  $allowance = ($allowances * $per_allowance)/$payfreq;

  $net = $gross - $allowance;

  $tax = 0;
  $last_threshold = 0;
  foreach($tiered_array as $threshold => $percent){
    //convert the annual figures to pay period figures
    $period_threshold = round($threshold/$payfreq, 0);//round to whole dollars (per IRS tables)
    //compare pay to each threshold and calculate tax accordingly
    if ($net <= $period_threshold){
      $tax += round(($net-$last_threshold)*$percent/100, 2);
      break;
    } else {
      $tax += round(($period_threshold-$last_threshold)*$percent/100, 2);
    }
    $last_threshold = $period_threshold;
  }

  return $tax;
}

//advanced percentage calculation with a threshold
//--------------------------------------------------------------------------------------------
function calculate_adv_percent($gross, $rate_array, $ytd){//TODO $rate_array is not coming in correctly
  //$rate_array is an array of 1 threshold => percentage
  $threshold = key($rate_array);
  $percent = current($rate_array);

  //have we met the threshold?
  if ($ytd < $threshold){
    //will this paycheck push us over the threshold?
    if ($ytd + $gross >= $threshold){
      //yes, only calculate tax on the remaining amount
      $tax = round(($threshold - $ytd)*$percent/100, 2);
    } else {
      //no, calculate tax on the entire amount
      $tax = round($gross*$percent/100, 2);
    }
  } else {
    //threshold met, no more tax owed
    $tax = 0;
  }
  return $tax;
}

//simple percentage calculation
//--------------------------------------------------------------------------------------------
function calculate_percent($gross, $percent){
  $tax = round($gross*$percent/100, 2);
  return $tax;
}

?> 
