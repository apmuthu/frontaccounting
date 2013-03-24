<?php

global $reports, $dim;

$reports->addReport(RC_SUPPLIER, "_cheque_print",'&Cheque Printing',
    array( 'Cheque No.' => 'TEXT',  
    	'Payment' => 'REMITTANCE'));
?>
