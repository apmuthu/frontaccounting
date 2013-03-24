<?php
/*
 *  Werner Bauer
 *  5.2.2002
 *  file: repgen_seite.php
*   Changed 19.11.2002 Version 0.44: Report Header and footer
 *
 *  item definition routine for Report generator repgen.
 *
 *  shows all items of a report and enables creation of an item
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


function m_s($a1,$a2)
{   // sets "selected" in select box when $a1 == $a2
   	if ($a1 == $a2)
   		return "selected";
   	else
   		return "";
}

/* If this page is called direct, switch to repgen_index.php
*/

if (!isset($sel_art))
	$sel_art = "";
if (!isset($sel_typ))
	$sel_typ = "";
if (!isset($sel_font))
	$sel_font = "";
if (!isset($alternate))
	$alternate = "";
if (!isset($attrib))
	$attrib = "";


###
### Submit Handler
###

## Check if there was a submission

while (is_array($_POST) && list($key, $val) = each($_POST))
//while ( is_array($HTTP_POST_VARS) && list($key, $val) = each($HTTP_POST_VARS))
{
  	switch ($key)
  	{

      	// go back
  		case "back":
            $url=REPGENDIR."/repgen_select.php";
            header("Location: http://$HTTP_HOST".$url);  // switches to page 'select a report'
            exit;
          	break;
  		case "delete":
            // deletes item from table reports
           	$query= "DELETE FROM xx_reports WHERE (id ='$id1' AND attrib = '$attrib')";
           	db_query($query);
          	break;
  		case "insert":
            //  inserts item into table reports
            // test the input
            $attrib1 = $sel_typ."|".$sel_art."|".$width."|".$x1."|".$y1."|".$x2."|".$y2;
            if (!(empty($id_new) || empty($width) || empty($x1) || empty($y1) || empty($x2) || empty($y2)))
            {
            	// does item exist already?
                if ($alternate == "true")
                {
                    $query = "DELETE FROM xx_reports WHERE (id = '".$id_new."' AND attrib ='".$attriba."' AND typ='item')";
                    db_query($query);
                    $alternate = "false";
                }
				$query = "SELECT * FROM xx_reports WHERE (id = '".$id_new."' AND attrib ='".$attrib1."' AND typ='item')";
                $res = db_query($query);
                if (db_num_rows($res) == 0 )
                { 	// it is new item, store it
                	$query = "INSERT INTO xx_reports VALUES('$id_new','item','$attrib1')";
                    db_query($query);
                    $error= NULL;
                }
            }
            else
            	$error= ERROR_EMPTY_LINE;
          	break;
  		case "alter":
            //  alters item into table reports
            $alternate = "true";
            $h = explode("|",$attrib);
            for ($i = 0; $i < 7; $i++)
            {
            	if (!isset($h[$i]))
            		$h[$i] = "";
            }
            $sel_typ=$h[0];
            $sel_art = $h[1];
            $width = $h[2];
            $x1 = $h[3];
            $y1 = $h[4];
            $x2 = $h[5];
            $y2 = $h[6];
          	break;

  		default:
  			break;
 	}
}
page("Report Generator REPGEN");
?>
<script language="javascript"><!--
function num_test(field) {
if (isNaN(field.value) == true)
{ alert("Use only Numbers here!");
 field.focus();
 return (false); }
}
function displayReport(id) {
 document.graphics.action= '<?php echo REPGENDIR."/repgen_print.php?id="; ?>'+id;
 window.open('','PDFWindow','toolbar=no,scrollbar=no,resizable=yes,menubar=no');
 document.graphics.target='PDFWindow';
 document.graphics.submit();
 document.graphics.target='_self';
 document.graphics.action='<?php echo REPGENDIR."/repgen_graphics.php"; ?>';
}
//--></script>

<?php
if (!empty($long))
	display_heading(ITEM_DEF.": ".$long);
else
	display_heading(ITEM_DEF);

display_heading(ITEM_LINE);

if (!empty($error))
    display_error($error);

display_note(IT_HELP, 0, 1);

start_form(false, false, REPGENDIR."/repgen_graphics.php", "graphics");

start_table(TABLESTYLE2, "width=80%");

start_row();

if ($report_type == "single")
{
	$txt = "<td>".IT_ART." <select name='sel_art' size='1' >
           	<option value='DE'  selected>Detail</option>
          	</select></td>";
}
else
{
	$txt = "<td>".IT_ART." <select name='sel_art' size='1' >
           <option value='RH' ".m_s("RH",$sel_art).">Report Header</option>
           <option value='PH' ".m_s("PH",$sel_art).">Page Header</option>
           <option value='GH' ".m_s("GH",$sel_art).">Group Header</option>
           <option value='DE' ".m_s("DE",$sel_art).">Detail</option>
           <option value='GF' ".m_s("GF",$sel_art).">Group Footer</option>
           <option value='PF' ".m_s("PF",$sel_art).">Page Footer</option>
           <option value='RF' ".m_s("RF",$sel_art).">Report Footer</option>
          </select></td>";
}
echo $txt;
$txt = "<td>Type <select name='sel_typ' size='1' >
            <option value='Line' ".m_s("Line",$sel_typ).">Line</option>
            <option value='Rect' ".m_s("Rect",$sel_typ).">Rectangle</option>\n";
$txt .= "</select></td>";
echo $txt;
$txt = "<td>".IT_X1." <input type='text' name='x1' size='4' maxlength='4' value='".(isset($x1) ? $x1 : "")."' onBlur='num_test(this);'></td>\n";
echo $txt;
$txt = "<td>".IT_Y1." <input type='text' name='y1' size='4' maxlength='4' value='".(isset($y1) ? $y1 : "")."' onBlur='num_test(this);'></td>\n";
echo $txt;
$txt = "<td>".IT_X2." <input type='text' name='x2' size='4' maxlength='4' value='".(isset($x2) ? $x2 : "")."' onBlur='num_test(this);'></td>\n";
echo $txt;
$txt = "<td>".IT_Y2." <input type='text' name='y2' size='4' maxlength='4' value='".(isset($y2) ? $y2 : "")."' onBlur='num_test(this);'></td>\n";
echo $txt;
$txt = "<td>".IT_WIDTH." <input type='text' name='width' size='4' maxlength='4' value='".(isset($width) ? $width : "")."' onBlur='num_test(this);'></td>\n";
echo $txt;
end_row();
end_table(1);

start_table();
start_row();
label_cell(submit("insert", IT_STORE, false));
label_cell(submit("back", IT_BACK, false));
if (!((substr($id_new,0,1) == 'B') || (substr($id_new,0,1 ) == 'F')))
{ 	// Only show test button for reports
	$txt = "<input name='druck' class='inputsubmit' type='button' value='".IT_PRINT."' onclick=\"displayReport('".$id_new."');\">\n";
	label_cell($txt);
}
end_row();
end_table();

echo "<hr size=1>\n";

hidden("alternate", $alternate);
hidden("attriba", $attrib);
hidden("id_new", $id_new);

end_form();
// <!--        End of input item form   -->
// <!--------------------------------------------------------------------->

display_heading(ITEM_HEAD);

start_table(TABLESTYLE, "width=80%");
$th = array(IT_TYP, IT_ART, IT_FONT, IT_FONT_SIZE, IT_LEN, IT_STRING, IT_X1, IT_Y1, IT_X2, IT_Y2, IT_WIDTH, "Action", "");
table_header($th);

## Traverse the result set

$query="SELECT  * FROM xx_reports WHERE (typ = 'item' AND id='".$id_new."') ORDER BY attrib";
$res = db_query($query);
$k = 0;   // line-number
while ($f = db_fetch($res))
{
    $h = explode("|",$f["attrib"]);
	for ($i = 0; $i < 8; $i++)
	{
		if (!isset($h[$i]))
			$h[$i] = "";
	}
    $it_typ=$h[0];
    $it_art = $h[1];
    $it_font = $h[2];
    $it_fontsize = $h[3];
    $it_zahl = $h[4];
    $it_x1 = $h[5];
    $it_y1 = $h[6];
    if ($it_typ == "String" || $it_typ == "DB" || $it_typ == "Term")
    	$it_str = $h[7];

 	// <!-- existing items -->
	alt_table_row_color($k);
	echo "<td style='width;0px;display:none;'>\n";
 	start_form(false, false, "repgen_graphics.php", "edit".$f["id"]);
	echo "</td>\n";
	label_cell($it_typ.hidden("id1", $id_new,false).hidden("id_new", $id_new,false).
		hidden("attrib", $f["attrib"],false));
	label_cell($it_art);
	if (in_array($it_typ , array("String","DB","Term")))
	{
		label_cell($it_font);
		label_cell($it_fontsize);
		label_cell($it_zahl);
		label_cell($it_str);
		label_cell($it_x1);
 		label_cell(($it_y1 != "" ? $it_y1 : "."));
	}
	else
	{
		label_cell(".");
		label_cell(".");
		label_cell(".");
		label_cell(".");
		label_cell($it_fontsize);
		label_cell($it_zahl);
	}
	if ( in_array($it_typ, array("String","DB","Term","Block","Textarea")))
	{
		label_cell(".");
		label_cell(".");
		label_cell(".");
    }
    else
    {
		label_cell($it_x1);
		label_cell($it_y1);
		label_cell($it_font);
    }
	if (in_array($it_typ,array("Line","Rect")))
		label_cell(submit("alter", CHANGE, false));
	else
		label_cell(" ");
	label_cell(submit("delete", DELETE, false));
	echo "<td style='width;0px;display:none;'>\n";
	end_form();
	echo "</td>\n";
	end_row();
}  // end of while

end_table(1);

end_page();
?>