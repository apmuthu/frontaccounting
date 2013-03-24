<?php
/* Selection of one of the stored reports
 * repgen_select.php for PHP Report Generator
   Bauer, 22.1.2002
   Version 0.2
*/

/*
 *  Select routine for Report generator repgen.
 *
 *  shows all reports with buttons for change, delete of every report and create
 *  a new report.
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

/* If this page is called direct, switch to repgen_main.php
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

function get_name($str)
{ // get name out of str
   $h = explode("|",$str);
   return $h[3];
}
function get_author($str)
{ // get author out of str
   $h = explode("|",$str);
   return $h[2];
}
function get_create_date($str)
{ // get date_ out of str
   $h = explode("|",$str);
   return sql2date($h[1]);
}
function get_short($str)
{ // get short out of str
   $h = explode("|",$str);
   return $h[0];
}

function get_print_format($str)
{ // get print_format out of str
   $h = explode("|",$str);
   return $h[4];
}
function get_print_size($str)
{ // get print_size out of str
   $h = explode("|",$str);
   return $h[5];
}
function get_report_type($str)
{ // get report_type out of str
   $h = explode("|",$str);
   return $h[6];
}

###
### Submit Handler
###

## Check if there was a submission
if (isset($change))
{
    $id = trim($id); $id_new=trim($id_new);
    $url = REPGENDIR."/repgen_create.php";
   	switch (substr($id,0,1))
   	{  // Change a Block
    	case 'B':
        	$url = REPGENDIR."/repgen_createblock.php";
            $url .= "?id_new=$id&short=".urlencode(get_short($attr))."&long=".urlencode(get_name($attr))."&author=".urlencode(get_author($attr));
            $url .= "&id=".$id;
            break;
        case 'F':   // Change Function
            $url = REPGENDIR."/repgen_createfunct.php";
            $url .= "?id_new=$id&short=".urlencode(get_short($attr))."&long=".urlencode(get_name($attr))."&author=".urlencode(get_author($attr));
            $url .= "&id=".$id;
            break;
        default:   // Change report
            $url = REPGENDIR."/repgen_create.php";
            $url .= "?id_new=$id&short=".urlencode(get_short($attr))."&long=".urlencode(get_name($attr))."&author=".urlencode(get_author($attr));
            $url .= "&print_format=".get_print_format($attr)."&print_size=".get_print_size($attr);
            $url .= "&report_type=".trim(get_report_type($attr))."&id=".$id;
            $query = "SELECT  * FROM xx_reports WHERE (typ = 'select' AND id = '".$id."' )";
            $res = db_query($query);
            $f = db_fetch($res);
            $url .= "&sql=".urlencode(trim($f["attrib"]));
            $query = "SELECT  * FROM xx_reports WHERE (typ = 'group' AND id = '".$id."' )";
            $res = db_query($query);
            $f = db_fetch($res);
            $h = explode("|", $f["attrib"]);
            $url .= "&group=".trim($h[0])."&group_type=".trim($h[1]);
	}
	//echo $url; exit;
	header("Location: http://$HTTP_HOST".$url);  // switches to repgen_create.php
    exit;
}
if (isset($delete))
{
    // deletes report(all records) with id from table reports
    $url = REPGENDIR."/repgen_del.php";
    $url .= "?id=".trim($id)."&attr=".urlencode($attr);
    header("Location: http://$HTTP_HOST".$url);  // switches to repgen_del.php
    exit;
}
if (isset($copy))
{
    // copy report(all records) with id from table reports
    // read the records of the selected report
    switch (substr($id,0,1))
    {
		case 'B':
			$type = 'block';
            break;
        case 'F':
        	$type = 'funct';
            break;
	    default:
	    	$type=  'info';
            break;
    }
	$query = "SELECT * FROM xx_reports WHERE id ='$id'";
    $res = db_query($query);
    $typ_ar = array();$attrib_ar = array();
    $l = 0;
    while ($f = db_fetch($res))
    {
    	$typ_ar[$l] = $f["typ"];
        $attrib_ar[$l] = $f["attrib"];
        if (trim($typ_ar[$l]) == $type)
        {
        	$h = explode("|",$attrib_ar[$l]);  // change short
            $h[0]= COPYV." ".$h[0];
            $h[1] = date("Y-m-d"); // correct creation date
            $attrib_ar[$l] = implode("|",$h);
        }
        $l++;
    }
    // change  $id to a new value and $short to "COPY".$short
    $res = db_query("SELECT typ,id FROM xx_reports WHERE typ = '$type'");
    $n = 0;
    while($f = db_fetch($res))
    {
    	$n = max($n, $f["id"]);
    }
    $n++;
	if (substr($id, 0, 1) == 'B')
		$n = 'B'.$n;
	if (substr($id, 0, 1) == 'F')
		$n = 'F'.$n;
    // write the records of the new report
    for ($k = 0; $k < $l; $k++)
    {
    	$query = "INSERT INTO xx_reports VALUES('$n','$typ_ar[$k]','$attrib_ar[$k]')";
        db_query($query);
    }
}
if (isset($new_))
{
    // create a new report Id
    $res = db_query("SELECT typ,id FROM xx_reports WHERE typ = 'info' ORDER BY id");
    $n = 0;
    while($f = db_fetch($res))
    {
    	$n = max($n, $f["id"]);
    }
    $n++;
    $url = REPGENDIR . "/repgen_create.php";
    $url .= "?id_new=$n&short=&long=&author=&group=&sql=&print_format=&print_size=&report_type=&id=&group_type=";
    header("Location: http://$HTTP_HOST".$url);  // switches to repgen_create.php
    exit;
}
if (isset($newblock))
{
    // create a new blockId, e.g. B3
    $res = db_query("SELECT id,typ FROM xx_reports WHERE typ = 'block'");
    $max = 0;
    while ($f = db_fetch($res))
    {
    	$n = trim($f["id"], "B");
    	$max = max($max, $n);
    }
    $n = $max + 1;
	$n = 'B'.$n;
    $url = REPGENDIR . "/repgen_createblock.php";
    $url .= "?id_new=$n&short=&long=&author=&group=&sqlf=&print_format=&print_size=&report_type=&id=&group_type=";
    header("Location: http://$HTTP_HOST".$url);  // switches to repgen_createblock.php
    exit;
}
if (isset($newfunct))
{
	// create a new funct e.g. F3
    $res = db_query("SELECT id,typ FROM xx_reports WHERE typ = 'funct'");
    $max = 0;
    while ($f = db_fetch($res))
    {
    	$n = trim($f["id"], "F");
    	$max = max($max, $n);
    }
    $n = $max + 1;
	$n = 'F'.$n;
    $url = REPGENDIR."/repgen_createfunct.php";
    $url .= "?id_new=$n&short=&long=&author=&group=&sql=&print_format=&print_size=&report_type=&id=&group_type=";
    header("Location: http://$HTTP_HOST".$url);  // switches to repgen_createfunct.php
    exit;
}
page("Report Generator REPGEN");

display_heading(DESCRIPT);

start_form(false, false, "repgen_select.php", "navigate");

start_table(TABLESTYLE2);

start_row();

submit_cells("new_", NEW_);
submit_cells("newblock", NEWBLOCK);
submit_cells("newfunct", NEWFUNCT);

end_row();

end_table(1);

display_note(SEL_SELECT);
display_note(SEL_COLOR);

end_form();
?>
<script language="javascript"><!--
function displayReport(f, id) {
 window.open('','PDFWindow','toolbar=no,scrollbar=no,resizable=yes,menubar=no');
 f.target='PDFWindow';
 f.action= '<?php echo REPGENDIR."/repgen_print.php?id="; ?>'+id;
 f.submit();
}
//--></script>
<?php

start_table(TABLESTYLE);
$th = array(LONG, SHORT, AUTHOR, CREATIONDATE, "Action", "", "", "");

table_header($th);

start_form(false, false, "", "edit");

  ## Traverse the result set
## Get a database connection
$query="SELECT  * FROM xx_reports WHERE (typ = 'info' OR typ = 'block' OR typ = 'funct') ORDER BY id";
$res = db_query($query);
while ($f = db_fetch($res))
{
	$attrib_h = $f["attrib"];
	$act = false;
   	switch (substr($f["id"], 0, 1))
   	{
       	case 'B':
       		$bgcolor="cfff8a";
            break;
       	case 'F':
       		$bgcolor="ffaa49";
            $h= explode("|",$attrib_h);
            $h[4]="";       // remove the PHP-statement part because of troubles with ' and "
            $attrib_h=implode("|",$h);
            break;
       	default:
       		$bgcolor="dedede";
       		$act = true;
            break;
   	}

	start_row("style='background-color:#{$bgcolor};'");
	echo "<td style='width;0px;display:none;'>\n";
	start_form(false, false, "repgen_select.php", "edit".$f["id"]);
	echo "</td>\n";
	label_cell(get_name($attrib_h), "nowrap");
	label_cell(get_short($attrib_h));
	label_cell(get_author($attrib_h));
	label_cell(get_create_date($attrib_h).hidden("id", $f["id"],false).hidden("attr", $attrib_h,false));
	if ($act)
  		label_cell("<input type=\"button\" class=\"inputsubmit\" name=\"run\" value=\""._("Run")."\" 
  			onclick=\"javascript:displayReport(document.edit, ".$f["id"].");\"");
	else
		label_cell("");
	submit_cells("change", CHANGE);
	submit_cells("delete", DELETE);
	submit_cells("copy", COPY);
	echo "<td style='width;0px;display:none;'>\n";
	end_form();
	echo "</td>\n";
	end_row();
}
end_form();

end_table(1);

end_page();

?>