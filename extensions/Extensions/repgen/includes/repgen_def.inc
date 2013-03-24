<?php
/* Include Datei repgen_def.inc for PHP Report Generator
   Bauer, 09.11.2002
   Version 0.44
*/
///////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////

foreach($_GET as $name => $value)
	$$name = $value;

foreach($_POST as $name => $value)
	$$name = $value;

foreach($_SERVER as $name => $value)
	$$name = $value;

foreach($_ENV as $name => $value)
	$$name = $value;

//error_reporting(E_ALL);
//ini_set("display_errors", "on");

if (!isset($id_new))
	$id_new = "";
if (!isset($short))
	$short = "";
if (!isset($long))
	$long = "";
if (!isset($author))
	$author = "";
if (!isset($date_))
	$date_ = "";
if (!isset($print_format))
	$print_format = "";
if (!isset($print_size))
	$print_size = "";
if (!isset($report_type))
	$report_type = "";
if (!isset($sql))
	$sql = "";
if (!isset($group))
	$group = "";
if (!isset($group_type))
	$group_type = "";

define("REPGENDIR",dirname($PHP_SELF));  // Directory of Repgen, should be altered if you use another directory
//////////////////////////////////////////////////////////////////////////
define("VERSION","Version 2.0");    // Version Number

?>