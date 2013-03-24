<?php
/* Create a new report or alter a stored report
 * repgen_create.php for PHP Report Generator
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
{ 	// controls, that short-name of reports does not be twice
    global $id_new;
    if (empty($short))
    	return false;
    $query = "SELECT attrib,id FROM xx_reports WHERE typ='info'";
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

function store($id, $info, $sql,$group, $group_type)
{   // stores the records info, select and group in the database
   	db_query("BEGIN");
   	$query="DELETE FROM xx_reports WHERE (id ='".$id."' AND typ='info')";
   	db_query($query);
   	$sql=strtr($sql,"'","^");    // translate ' into ^
   	$query="INSERT INTO xx_reports VALUES ('".$id."','info','".$info."')";
   	db_query($query);

   	$query="DELETE FROM xx_reports WHERE (id ='".$id."' AND typ='select')";
   	db_query($query);
   	$sql=strtr($sql,"'","^");    // translate ' into !
   	$query="INSERT INTO xx_reports VALUES ('".$id."','select','".$sql."')";
   	db_query($query);
   	$query="DELETE FROM xx_reports WHERE (id ='".$id."' AND typ='group')";
   	db_query($query);
   	$g = $group."|".$group_type;
   	$query="INSERT INTO xx_reports VALUES ('".$id."','group','".$g."')";
   	db_query($query);
   	db_query("COMMIT");
}


###
### Submit Handler
###

## Check if there was a submission

if (isset($select))
{
	// go to the page for selection of an old report without storing the content of this page
	$url = REPGENDIR."/repgen_select.php";
	header("Location: http://$HTTP_HOST".$url);  // switches to repgen_del.php
	exit;
}
if (isset($page_strings))
{
	// go to page for definition of String-items
	// echo "We are here, database=$database, host=$host, user=$user, password=$password<br>";
	$error = "";
	if (!check_short($short) || empty($sql) or trim($sql) == "")
	{
		$error = ID_ERROR;
	}
	if (empty($group) && ($group_type == "newpage"))
	{
		$error = GROUP_ERROR;
	}
	if (empty($error))
	{
		// switches to repgen_strings.php (Definition of String-items of the report)
		//                   get_session_data();
		// test, if $sql is correct SQL Statement
		$sql = urldecode(stripslashes($sql));
		$sql1 = str_replace("0_", TB_PREF, $sql);
		db_query($sql1, "SQL-Statement : '".$sql."' ".SQL_ERROR.":<BR>".NOTSTORED);
		$info = $short."|".$date_."|".$author."|".$long."|".$print_format."|".$print_size."|".$report_type ;
		store($id_new,$info,$sql,$group,$group_type);
		$url=REPGENDIR."/repgen_strings.php";
		$url .= "?id_new=".$id_new."&long=".urlencode($long)."&report_type=".$report_type."&sql=".urlencode($sql);
		header("Location: http://$HTTP_HOST".$url);  // switches to repgen_strings.php
		exit;
	}
	else
	{
		$error .=  "<BR>".NOTSTORED;
	}
}
if (isset($page_graphics))
{
	// go to page for definition of Line-items
	if (!check_short($short) || empty($sql) || trim($sql) == "")
	{
		$error = ID_ERROR;
	}
	if (empty($error))
	{
		// switches to repgen_graphics.php (Definition of items of the report)
		// set_session_data();
		// test, if $sql is correct SQL Statement
		$sql = urldecode(stripslashes($sql));
		$sql1 = str_replace("0_", TB_PREF, $sql);
		db_query($sql1, "Entered values NOT saved!");
		$info = $short."|".$date_."|".$author."|".$long."|".$print_format."|".$print_size."|".$report_type ;
		store($id_new,$info,$sql,$group,$group_type);
		$url = REPGENDIR."/repgen_graphics.php?id_new=".$id_new."&long=".urlencode($long);
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
function openWindow2(url, title)
{
 var left = (screen.width - 800) / 2;
 var top = (screen.height - 450) / 2;
 document.edit.action = url;
 window.open('', title, 'width=800,height=450,left='+left+',top='+top+',screenX='+left+',screenY='+top+',status=no,scrollbars=yes');
 document.edit.target = title;
 document.edit.submit();
 document.edit.action = '<?php echo REPGENDIR; ?>/repgen_create.php';
 document.edit.target = '_self';
}
//-->
</script>

<?php
if (!empty($long))
	display_heading(ALTER_HEAD.":   ".$long);
else
	display_heading(CREATE_HEAD);
if (!empty($error))
{
	display_error($error);
	$error = NULL;
}
start_form(false, false, "repgen_create.php", "edit");

start_table(TABLESTYLE2);
label_row(ID, $id_new.hidden("id_new", $id_new,false));
text_row(SHORT, "short", $short, 10, 10);
text_row(LONG, "long", $long, 40, 40);
text_row(AUTHOR, "author", $author, 20, 20);
label_row(DATE, today());
text_row(GROUP_NAME, "group", $group, 20, 30, "bgcolor='#eeeeee'");
$txt = "<select name='group_type' size='1'>
	<option value = 'nopage' ".m_s($group_type,"nopage").">".NO_PAGE."</option>
	<option value = 'newpage' ".m_s($group_type,"newpage").">".NEW_PAGE."</option>
	</select>";
label_row(GROUP_TYPE, $txt, "bgcolor='#eeeeee'");
textarea_row(SQL, "sql", strtr(urldecode(stripslashes($sql)),"^","'"), 50, 10);
$txt = "<input type='button' name='test_sel' value='".TEST_SEL.
	"' onclick=\"openWindow2('".REPGENDIR."/repgen_test_sel.php"."', 'SQL');\" >";
label_row("&nbsp;", $txt);
label_row("&nbsp;", "&nbsp;");
$txt = "<select name='print_format' size='1'>
	<option value = 'portrait' ".m_s($print_format,"portrait").">Portrait</option>
	<option value = 'landscape' ".m_s($print_format,"landscape").">Landscape</option>
	</select>";
label_row(PRINT_FORMAT, $txt);
$txt = "<select name='print_size' size='1'>
	<option value = 'letter' ".m_s($print_size,"letter").">Letter</option>
	<option value = 'a4' ".m_s($print_size,"a4").">A4</option>
	</select>";
label_row(A4FORMAT1, $txt);
$txt = "<select name='report_type' size='1'>
	<option value = 'single' ".m_s($report_type,"single").">".PAGE_REC."</option>
	<option value = 'class' ".m_s($report_type,"class").">".LINE_REC."</option>
	<option value = 'classtable' ".m_s($report_type,"classtable").">".GRID_REC."</option>
	<option value = 'classbeam' ".m_s($report_type,"classbeam").">".BEAM_REC."</option>
	<option value = 'classgrid' ".m_s($report_type,"classgrid").">".BEAMGRID_REC."</option>
	</select>";
label_row(REPORT_TYPE, $txt.hidden("date_", date("Y-m-d"),false).hidden("id", $id,false));
end_table(2);
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