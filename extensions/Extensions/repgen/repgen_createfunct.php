<?php
// session_start();
/* Create a new funct or alter a stored function
 * repgen_createfunction.php for PHP Report Generator
   Bauer, 5.2.2002
   Version 0.2
*/

/*
 *
 *
 * 1. A section where utility functions are defined.
 * 2. A section that is called only after the submit.
 * 3. And a final section that is called when the script runs first time and
 *    every time after the submit.
 *
 * Scripts organized in this way will allow the user perpetual
 * editing and they will reflect submitted changes immediately
 * after a form submission.
 *
 * We consider this to be the standard organization of table editor
 * scripts.
 *
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
require_once("includes/repgen.inc");

function check_short($short)
{ // controls, that short-name of blocks does not be twice
	global $id_new;
	if (empty($short))
		return false;
	$query = "SELECT attrib,id FROM xx_reports WHERE typ='funct'";
	$res = db_query($query);
	while ($f = db_fetch($res))
	{
		$h=explode("|",$f["attrib"]);
		if (($h[0] == $short) && (trim($f["id"]) != $id_new))
			return false;
	}
	return true;
}

function m_s($a1,$a2)
{   // sets "selected" in select box when $a1 == $a2
   	if ($a1 == $a2)
   		return "selected";
   	else
   		return "";
}

function store($id, $info)
{   // stores the records 'block' in the database
   	db_query("BEGIN");
   	$query="DELETE FROM xx_reports WHERE (id ='".$id."' AND typ='funct')";
   	db_query($query);
   	$query="INSERT INTO xx_reports VALUES ('".$id."','funct','".$info."')";
   	db_query($query);
   	db_query("COMMIT");
}

if (!isset($funct))
	$funct = "";
if (!empty($funct))
	$funct = stripslashes($funct);  // strip $funct

###
### Submit Handler
###

## Check if there was a submission

if (isset($select))
{
	// go to the page for selection of an old report without storing the content of this page


	$url = REPGENDIR."/repgen_select.php";
	$url= "http://$HTTP_HOST".$url;
	header("Location: ".$url);  // switches to repgen_select.php
	exit;
}
if (isset($store))
{
	// go to page for definition of String-items
	if (!check_short($short) )
	{
		$error = ID_ERROR_BLOCK;
	}
	else if (stristr($funct," ".$short."("))
	{  	// $short == functionname?
		$info = $short."|".$date_."|".$author."|".$long."|".addslashes($funct) ;
		store($id_new,$info);
		$url= REPGENDIR."/repgen_select.php";
		$url= "http://$HTTP_HOST".$url;
		header("Location: ".$url);  // switches to repgen_strings.php
   	}
   	else
   		$error = ERROR_FUNC.$short."(){...}";
}
if (isset($test))
{
	if (stristr($funct," ".$short."("))
	{  // $short == functionname?
		global $php_errormsg;
		@eval( $funct);       //declare funct
		$h_a =strtok($funct,"(");  // look if the funct has a parameter
		$h_a= strtok(")");     // $h_a is now the parameter

		if (!empty($h_a))
		{   // first parameter is $this
		  	$func = '$field='.$short.'($this);';// two parameters
		}
		else
		{
			$func = '$field='.$short.'();';
		}
		@eval($func);                       // call funct
		$error=$php_errormsg;
  	}
}

page("Report Generator REPGEN");

### Output key administration forms, including all updated
### information, if we come here after a submission...


if (!empty($long))
	display_heading(ALTER_FUNCT.":   ".$long);
else
	display_heading(CREATE_FUNCT);
if (!empty($error))
{
	display_error($error);
	$error = NULL;
}
else if (!empty($funct))
	display_notification(PHP_OK.$field);

if (empty($funct))
{
    $res = db_query("SELECT attrib FROM xx_reports WHERE id = '$id_new'");
    $f = db_fetch($res);
    $h = explode("|",$f["attrib"]);
    if (!isset($h[4]))
    	$h[4] = "";
    $funct = stripslashes($h[4]);
}

start_form(false, false, "repgen_createfunct.php", "edit");

start_table(TABLESTYLE2);
label_row(ID_FUNCT, $id_new.hidden("date_", date("Y-m-d"), false).hidden("id", $id_new,false).hidden("id_new", $id_new,false));
text_row(SHORT, "short", $short, 10, 10);
text_row(LONG, "long", $long, 40, 40);
text_row(AUTHOR, "author", $author, 20, 20);
label_row(DATE, today());
textarea_row(ALTER_FUNCT, "funct", $funct, 50, 10);
end_table(1);

display_note(FUNC_DECL, 0, 1);

start_table(TABLESTYLE);
start_row();
submit_cells("select", SELECT_CR);
submit_cells("store", PAGE_STORE);
submit_cells("test", PAGE_TEST);
end_row();
end_table();
end_form();

end_page();
?>