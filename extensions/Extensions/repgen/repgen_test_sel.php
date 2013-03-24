<?php 
/* Test the SQL Statement
 * repgen_test_sel.php for PHP Report Generator
   Bauer, 22.5.2001
   Version 0.1
*/

$page_security = 'SA_REPORT_GENERATOR';
$path_to_root="../..";
include_once($path_to_root . "/includes/session.inc");
add_access_extensions();

include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/admin/db/company_db.inc");
include_once($path_to_root . "/includes/ui.inc");

require_once("includes/repgen_const.inc");
require_once("includes/repgen_def.inc");

/* If this page is called directly, switch to repgen_main.php
*/

if ($sql == "") 
{
	$error = SQL_ERROR1;
	display_error($error);
	exit;
}  

page("Report Generator REPGEN", true);

display_heading(SQL_STATEMENT);

$sql = stripslashes($sql);
$sqle = urldecode($sql);
//   print the SQL-Command

display_notification($sqle);

$sql = str_replace("0_", TB_PREF, $sql);

$res = db_query($sql, SQL_ERROR);      // test, if SQL-statement is correct
$th = array();
$num = db_num_fields($res);
$i = 0;
while ($i < $num) 
{
    $meta = mysql_fetch_field($res, $i);
    $th[] = $meta->name;
    $i++;
}    
/*
 *
 * show 10 records of this resultset
 *
 *
*/
display_heading(SQL_ERG);

start_table(TABLESTYLE);
table_header($th);
$k=0;
for ($j=0; $j<10; $j++) 
{
	alt_table_row_color($k);
	$f = db_fetch_row($res);
	for ($i=0;$i<$num; $i++)     // write column names
    	label_cell($f[$i]);
    end_row();	
}

end_table(1);         

end_page();
?>