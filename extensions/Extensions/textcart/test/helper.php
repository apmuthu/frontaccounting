<?php
$path_to_root = '../../';
require_once 'includes/textcart_manager.inc';
/*** mock some FA functions ***/

function display_error($msg) {
}

/** create a date object **/
/** here, we just create a string **/
function __date($year, $month, $day) {
		return "Date: $year/$month/$day";
}
/*** end mock ***/

