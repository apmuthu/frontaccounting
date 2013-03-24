<?php
// session_start();
/* Create a new block or alter a stored block
 * repgen_createblock.php for PHP Report Generator
   Bauer, 22.1.2002
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
{ 	// controls, that short-name of blocks does not be twice
  	global $id_new;
    if (empty($short))
    	return false;
    $query = "SELECT attrib,id FROM xx_reports WHERE typ='block'";
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
   	$query="DELETE FROM xx_reports WHERE (id ='".$id."' AND typ='block')";
   	db_query($query);
   	$query="INSERT INTO xx_reports VALUES ('".$id."','block','".$info."')";
   	db_query($query);
   	db_query("COMMIT");
}

###
### Submit Handler
###

## Check if there was a submission

if (isset($select))
{
	// go to the page for selection of an old block without storing the content of this page
	$url = REPGENDIR."/repgen_select.php";
	header("Location: http://$HTTP_HOST".$url);  // switches to repgen_select.php
	exit;
}
if (isset($page_strings))
{
	// go to page for definition of String-items
	$error = "";
	if (!check_short($short))
	{
		$error = ID_ERROR;
	}
	else
	{
		// switches to repgen_strings.php (Definition of String-items of the block)
		$info = $short."|".$date_."|".$author."|".$long ;
		store($id_new,$info);
		$url=REPGENDIR."/repgen_strings.php";
		$url .= "?id_new=".$id_new."&long=".urlencode($long)."&report_type=".$report_type;
		header("Location: http://$HTTP_HOST".$url);  // switches to repgen_strings.php
		exit;
   	}
}
if (isset($page_graphics))
{
	// go to page for definition of Line-items
	if (!check_short($short))
	{
		$error = ID_ERROR;
	}
	else
	{
		// switches to repgen_graphics.php (Definition of items of the report)
		$info = $short."|".$date_."|".$author."|".$long ;
		store($id_new,$info);
		$url=REPGENDIR."/repgen_graphics.php?id_new=".$id_new;;
		header("Location: http://$HTTP_HOST".$url);  // switches to repgen_graphics.php
		 exit;
   	}
}

page("Report Generator REPGEN");

### Output key administration forms, including all updated
### information, if we come here after a submission...
?>

<script language="javascript"><!--
function num_test(feld) {
if (isNaN(feld.value) == true)
{ alert("Use only Numbers here!");
 feld.focus();
 return (false); }

}
//--></script>
<?php
if (!empty($long))
	display_heading(ALTER_BLOCK.":   ".$long);
else
	display_heading(CREATE_BLOCK);
if (!empty($error))
{
	display_error($error);
	$error = NULL;
}

start_form(false, false, REPGENDIR."/repgen_createblock.php", "edit");

start_table(TABLESTYLE2);
label_row(ID_BLOCK, $id_new);
hidden("id_new", $id_new);
text_row(SHORT, "short", $short, 10, 10);
text_row(LONG, "long", $long, 40, 40);
text_row(AUTHOR, "author", $author, 20, 20);
label_row(DATE, today().hidden("date_", date("Y-m-d"),false).hidden("id", $id_new,false));
end_table(1);

start_table(TABLESTYLE);
start_row();
submit_cells("select", SELECT_CR);
submit_cells("page_strings", PAGE_STRINGS);
submit_cells("page_graphics", PAGE_GRAPHICS);
end_row();
end_table();
end_form();

end_page();
?>