<?php
/*
 *  Werner Bauer
 *  5.2.2002
 *  file: repgen_seite.php
 *  Changed 19.11.2002 Version 0.44 Total, reportheader+footer
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

if (!isset($sel_art))
	$sel_art = "";
if (!isset($sel_font))
	$sel_font = "";
if (!isset($sel_fontsize))
	$sel_fontsize = "";
if (!isset($sel_typ))
	$sel_typ = "";
if (!isset($sel_center))
	$sel_center = "";
if (!isset($term))
	$term = "";
if (!isset($feld))
	$feld = "";
if (!isset($alternate))
	$alternate = "";
if (!isset($attrib))
	$attrib = "";
if (!isset($block))
	$block = "";

function m_s($a1,$a2)
{   // sets "selected" in select box when $a1 == $a2
   	if ($a1 == $a2)
   		return "selected";
   	else
   		return "";
}

function m_c($a1,$a2)
{   // sets "checked" in radio box when $a1 == $a2
   	if ($a1 == $a2)
   		return "checked";
   	else
   		return "";
}

function de_read($id_new)
{   // read all item-records and returns all DE-Attributs
    $ar = array();
    $res = db_query("SELECT attrib FROM xx_reports WHERE (id = '".$id_new."' AND typ='item')");
    while ($f = db_fetch($res))
    {
    	$attr = $f["attrib"];
        $attr_h = explode("|",$attr);
        if ($attr_h[1] == "DE")
        {   // nur art="DE" - Saetze interessieren
        	$ar[] = $attr;
        }
    }
    return $ar;
}
function is_ord($ar)
{  	// checks, if there is an DE-item with ord<> ""
    for ($i = 0; $i < sizeof($ar); $i++)
    {
        $attr_h = explode("|",$ar[$i]);   //
        if (!empty($attr_h[8]))
        	return true;
    }
    return false;
}

###
### Submit Handler
###

## Check if there was a submission
## Get a database connection

//while (is_array($HTTP_POST_VARS) && list($key, $val) = each($HTTP_POST_VARS))
while (is_array($_POST) && list($key, $val) = each($_POST))
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
            if (!isset($total))
               	$total = "";
            if (!isset($o_score))
               	$o_score = "";
            if (!isset($u_score))
               	$u_score = "";
            if (!isset($bold))
               	$bold = "";
            $is_ord = !(empty($number) || empty($ord)); //enter order = true
            $is_y1 = !empty($y1) ||($y1 == "0");
            $is_from = !empty($from) ||($from == "0");
            $is_to = !empty($to) ||($to == "0");
            if ((!$is_y1 || empty($x1)) && ! $is_ord)
            {  	// No Rf and x or y error
                $error = ERROR_XY;
                break;
            }
            if ((!empty($x1) && !empty($y1) && $is_ord))
            { 	// RF and x and y enter -> Error
                $error = ERROR_MIX;
                break;
            }
            if (($sel_art != "DE") && $is_ord)
            {  	// Rf only when art <> DE
                $error = ERROR_ORDER;
                break;
            }
            if ($report_type !="single")
            {
                if (empty($id_new) || (empty($number) && empty($x1)) || empty($number))
                { 	// no entrance
	             	$error = ERROR_EMPTY;
                    break;
	            }
                if ($is_from || $is_to)
                {  	// $from or $to have value
	            	$from = 0 + $from;
                    $to = 0 + $to;
                    if ($from < 1)
                    	$from = 1; // $from must be > 0
                    if ($to > $number)
                    	$to = $number; // $to must not > $number
                    if ($to == 0)
                    	$to = $number; // $to must not > 0
                    if ($from >= $to)
                    {
                        $error = ERROR_TO;
                        break;
                    }
                }
                $is_x = !empty($x1);
                $attr_ar= array();
                $attr_ar = de_read($id_new);      // reading Detail -items and return as array
                $ord_attr = is_ord($attr_ar);

                if (($is_x && $ord_attr) || ($is_x && $is_ord))
                {
                	// x and y entrance and art=DE, even if Rf is saved
                    $error = ERROR_MIX;
                    break;
                }
                if (($sel_typ == "String") && empty($value_))
                {
                    $error = ERROR_VALUE;
                    break;
                }
                if (($sel_typ == "Textarea") && empty($term) && empty($width))
                {
                    $error = ERROR_VALUE;
                    break;
                }

                if (($total == "true") && ($sel_art != "DE"))
                {
		          	$error = ERROR_TOTAL;
			  		break;
		  		}

                ////////////////// end of input-Test /////////////
                if ($sel_typ == "Textarea")
                {
                	$number = $width;
                }

                $attrib1 = $sel_typ."|".$sel_art."|".$sel_font."|".$sel_fontsize."|".$number.$sel_center."|".$x1."|".$y1."|";
                db_query("BEGIN");
                switch ($sel_typ)
                {
		   			case "DB":
		   				$attrib1 .= $feld;
		              	break;
		   			case "Term":
                   	case "Textarea":
                   		$attrib1 .= $term;
		              	break;
		   			case "String":
		   				$attrib1 .= $value_;
		              	break;
		   			case "Block":
		   				$attrib1 .= $block;
		              	break;
		   			default:
		   				$attrib1 .= $value_;
		              	break;
		  		}

                $attrib1 .= "|".$ord;   // new attrib is ready
                $attrib1 .= "|"; // no decode
                $attrib1 .= "|".$from."|".$to; // begin and end of substring
                $attrib1 .= "|".$total."|".$o_score."|".$u_score."|".$bold; // total sum for this item
                if ($alternate == "true")
                {   // coming from change
                    $query = "DELETE FROM xx_reports WHERE (id = '".$id_new."' AND attrib ='".$attriba."' AND typ='item')";
                    db_query($query);
                    $alternate = "false";
                }

                $query = "SELECT * FROM xx_reports WHERE (id = '".$id_new."' AND attrib ='".$attrib1."' AND typ='item')";
                $res = db_query($query);
                if (db_num_rows($res) == 0 )
                { 	// it is new item, store it
                  	if (empty($ord))
                  	{   // store X/Y -item
                     	$query = "INSERT INTO xx_reports VALUES('$id_new','item','$attrib1')";
                     	db_query($query);
                     	$error= NULL;
                  	}
                  	else
                  	{   // rearrange all items with correct ord ($h[8]) (there are only items with ord)
                      	$attr_h = array();
                      	for ($i = 0; $i < count($attr_ar); $i++)
                      	{  	// create array(ord => attrib) and delete records
                            $h = explode("|",$attr_ar[$i]);
                            $attr_h[$h[8]] = $attr_ar[$i];
                            $query = "DELETE FROM xx_reports WHERE (id = '".$id_new."' AND attrib ='".$attr_ar[$i]."' AND typ='item')";
                            db_query($query);
                      	}
                      	ksort($attr_h, SORT_STRING); // sort old items
                      	reset($attr_h);
                      	$li = 1;
                      	$entered = false;
                      	while (list($key, $attr) = each($attr_h))
                      	{ 	// write items back and insert the new at the right position
                       		$h = explode("|",$attr);
                       		if (($ord <= $h[8]) && !$entered)
                       		{  	// insert new item in the hole or before old item
                           		$hi = explode("|",$attrib1);
                           		$hi[8] = $li;
                           		$attrib1 = implode("|",$hi);
                           		$query = "INSERT INTO xx_reports VALUES('$id_new','item','$attrib1')";
                           		db_query($query);
                           		$entered = true;
                           		$li++;
                       		}
                       		$h[8] = $li;
                       		$attr = implode("|",$h);
                       		$query = "INSERT INTO xx_reports VALUES('$id_new','item','$attr')";
                       		db_query($query);
                       		$li++;
                      	}
                       	if ($ord > $h[8])
                       	{   // the new item has the greatest ord-number $ord of all items
                           	$hi = explode("|",$attrib1);
                           	$hi[8] = $li;
                           	$attrib1 = implode("|",$hi);
                           	$query = "INSERT INTO xx_reports VALUES('$id_new','item','$attrib1')";
                           	db_query($query);
                      	}
                  	}
                }
            }
          	db_query("COMMIT");
          	break;

  		case "alter":
            //  alters item into table reports
            $alternate = "true";
            $h = explode("|",$attrib);
			for ($i = 0; $i < 16; $i++)
			{
				if (!isset($h[$i]))
					$h[$i] = "";
			}
            $sel_typ=$h[0];
            $sel_art = $h[1];
            $sel_font = $h[2];
            $sel_fontsize = $h[3];
            $number = substr($h[4],0,strlen($h[4])-1);

            $sel_center = substr($h[4],strlen($h[4])-1,1);
            $x1 = $h[5];
            $y1 = $h[6];
            if ($sel_typ == "String" )
            	$value_ = $h[7];
            if ($sel_typ == "DB")
            	$feld = $h[7];
            if ($sel_typ == "Term")
            	$term = $h[7];
            if ($sel_typ == "Textarea")
            {
            	$term = $h[7];
                $width = $h[4]; // width stored in $number!
            }

		  	$ord = $h[8];
            $from = $h[10];
            if (trim($h[11]) !="")
            	$to = $h[11];
           	else
           		$to=""; // there could be a trailing space from the database
		  	$total = $h[12];
		  	$o_score = $h[13];
		  	$u_score = $h[14];
            if (trim($h[15]) != "")
            	$bold = $h[15];
            else
            	$bold=""; // there could be a trailing space from the database
          	break;
  		default:
          	break;
 	}
}
page("Report Generator REPGEN");

?>
<script language="javascript"><!--
function num_test(feld) {
if (isNaN(feld.value) == true)
{ alert("Use only Numbers here!");
 feld.focus();
 return (false); }
}

function displayReport(id) {
 document.strings.action= '<?php echo REPGENDIR."/repgen_print.php?id="; ?>'+id;
 window.open('','PDFWindow','toolbar=no,scrollbar=no,resizable=yes,menubar=no');
 document.strings.target='PDFWindow';
 document.strings.submit();
 document.strings.target='_self';
 document.strings.action='<?php echo REPGENDIR."/repgen_strings.php?report_type=".$report_type; ?>';
}
//--></script>

<?php
if (!empty($long))
	display_heading(ITEM_DEF.": ".$long);
else
	display_heading(ITEM_DEF);

display_heading(ITEM_CHAR);

if (!empty($error))
    display_error($error);

start_form(false, false, "repgen_strings.php?report_type=".$report_type, "strings");

start_table(TABLESTYLE2, "width=70%");

// <!--   Table 1 -->
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
$txt = "<td>Font <select name='sel_font' size='1' >
            <option value='Helvetica' ".m_s("Helvetica",$sel_font).">Helvetica</option>
            <option value='Helvetica-Bold' ".m_s("Helvetica-Bold",$sel_font).">Helvetica Bold</option>
            <option value='Helvetica-Italic' ".m_s("Helvetica-Italic",$sel_font).">Helvetica Italic</option>
            <option value='Helvetica-BoldItalic' ".m_s("Helvetic-BoldItalic",$sel_font).">Helvetica Bold Italic</option>";
            //<option value='Courier' ".m_s("Courier",$sel_font).">Courier</option>
            //<option value='Courier-Bold' ".m_s("Courier-Bold",$sel_font).">Courier Bold</option>
            //<option value='Courier-Italic' ".m_s("Courier-Italic",$sel_font).">Courier Italic</option>
            //<option value='Courier-BoldItalic' ".m_s("Courier-BoldItalic",$sel_font).">Courier Bold Italic</option>
            //<option value='Times' ".m_s("Times",$sel_font).">Times Roman</option>
            //<option value='Times-Bold' ".m_s("Times-Bold",$sel_font).">Times Bold</option>
            //<option value='Times-Italic' ".m_s("Times-Italic",$sel_font).">Times Italic</option>
            //<option value='Times-BoldItalic' ".m_s("Times-BoldItalic",$sel_font).">Times Bold</option>
            //<option value='Symbol' ".m_s("Symbol",$sel_font).">Symbol</option>
            //<option value='ZapfDingbats' ".m_s("ZapfDingbats",$sel_font).">ZapfDingBats</option>
$txt .= "</select></td>";
echo $txt;
$txt = "<td>Fontsize <select name='sel_fontsize' size='1' >\n";
for ($i = 0; $i < 7; $i++)
{
 	$h = $i + 6;
 	$txt .= "<option value= '".$h."' ".m_s($h,$sel_fontsize).">".$h."</option>\n";
}
for ($i = 0; $i < 9; $i++)
{
 	$h= 2 * $i + 14;
 	$txt .= "<option value='".$h."' ".m_s($h,$sel_fontsize).">".$h."</option>\n";
}
for ($i = 0; $i < 4; $i++)
{
 	$h = 4 * $i + 32;
 	$txt .= "<option value='".$h."' ".m_s($h,$sel_fontsize).">".$h."</option>\n";
}
for ($i = 0; $i < 5; $i++)
{
	$h = 6 * $i + 48;
 	$txt .= "<option value='".$h."' ".m_s($h,$sel_fontsize).">".$h."</option>\n";
}
$txt .= "</select></td>";
echo $txt;
echo "<td>\n";
// <!--   Table2 in the table1 -->
start_table(TABLESTYLE2);
start_row();
$txt = "<td nowrap colspan=4>X <input type='text' name='x1' size='4' maxlength='4' value='".(isset($x1) ? $x1 : "")."' onBlur='num_test(this);'>\n";
$txt .= "&nbsp;&nbsp;Y <input type='text' name='y1' size='4' maxlength='4' value='".(isset($y1) ? $y1 : "")."' onBlur='num_test(this);'></td>\n";
echo $txt;
end_row();
if ($report_type != "single")
{
	// don't show order-element
	text_row(ALTERNATIVE." ".ORDER, "ord", (isset($ord) ? $ord : ""), 2, 2, "onblur='num_test(this);'");
	// <!--   3. Line -->
	//start_row();
	//echo "<td>\n";
	//start_table(TABLESTYLE);
    // <!--   Third table in Table2 -->
	start_row();
	text_cells(NUMBER, "number", (isset($number) ? $number : ""), 2, 2, "onblur='num_test(this);'");
	$txt = "<select name='sel_center' size='1' >
                     <option value='l' ".m_s("l",$sel_center).">left</option>
                     <option value='c' ".m_s("c",$sel_center).">center</option>
                     <option value='r' ".m_s("r",$sel_center).">right</option>
                   </select>";
    label_cells(ALIGN, $txt);
    end_row();
}
start_row();
label_cell(OPTIONAL." ".SUBSTRING." ".FROM);
text_cells(null, "from", (isset($from) ? $from : ""), 2, 2, "onblur='num_test(this);'");
text_cells(TO, "to", (isset($to) ? $to : ""), 2, 2, "onblur='num_test(this);'");
end_row();
// <!--  end of 3. Line -->
end_table();
// <!--  end of inner table  -->
echo "</td>\n";
end_row();
end_table();
start_table(TABLESTYLE, "width=70%");
$th = array(ELEMENT, VALUE_);
table_header($th);
start_row();
$txt = "<input type='radio' name='sel_typ' value = 'String' ".(empty($sel_typ) ? " checked " : m_c("String",$sel_typ)).">String\n";
label_cell($txt);
text_cells(null, "value_", (isset($value_) ? $value_ : ""), 40, 80);
end_row();
start_row();
$txt = "<input type='radio' name='sel_typ' value = 'DB' ".m_c("DB",$sel_typ).">".DBFELD."\n";
label_cell($txt);
if (substr($id_new,0,1) != 'B')
{ 	// This is a report
	$sql1 = str_replace("0_", TB_PREF, $sql);
	$res = db_query($sql1);
	$num = db_num_fields($res);
	$txt = "<td><select name = 'feld' size='1'>\n";
	for ($i = 0; $i < $num; $i++)
	{
		$meta = mysql_fetch_field($res, $i);
		$txt .= "<option value=\"".$meta->name."\" ".m_s($meta->name,$feld)." > ".$meta->name."</option>\n";
	}
	$txt .= "</select>\n";
	echo $txt;
}
else
{
	$txt = "<td><input type='text' name='feld' size=40 maxlength=40 value = '".(isset($feld) ? $feld : "")."' >\n";
	echo $txt;
}
echo "<table>\n";
label_row(null, TOTAL, "", "colspan='3'");
start_row();
$txt = "<input type ='checkbox' name='total' value='true' ".(!empty($total) ? "checked" : "").">Total\n";
label_cell($txt, "colspan='3'");
end_row();
start_row();
$txt = "<input type ='checkbox' name='o_score' value='true' ".(!empty($o_score) ? "checked" : "").">Overscore\n";
label_cell($txt);
$txt = "<input type ='checkbox' name='u_score' value='true' ".(!empty($u_score) ? "checked" : "").">Underscore\n";
label_cell($txt);
$txt = "<input type ='checkbox' name='bold' value='true' ".(!empty($bold) ? "checked" : "").">Bold\n";
label_cell($txt);
end_row();
end_table();
echo "</td>\n";
end_row();
start_row();
$txt = "<input type='radio' name='sel_typ' value = 'Term' ".m_c("Term",$sel_typ).">Term\n";
label_cell($txt);
$txt = "<select name='term' size='1'>\n";
$res = db_query("SELECT attrib FROM xx_reports WHERE typ='funct'");
while ($f = db_fetch($res))
{
   	$a_h = explode("|",$f["attrib"]);
   	$txt .= "<option value=\"".$a_h[0]."\" ".m_s($a_h[0],$term)." > ". $a_h[0]. "</option>\n";
}
$txt .= "</select>\n";
label_cell($txt);
end_row();

if (($report_type == "single") && (substr($id_new,0,1) != 'B'))
{ 	//  show Textarea-element, if Report and single_typed
	start_row();
	$txt = "<input type='radio' name='sel_typ' value = 'Textarea' ".m_c("Textarea",$sel_typ).">Textarea\n";
	label_cell($txt);
	$txt = "<select name='textarea' size='1'>\n";
	$res = db_query("SELECT attrib FROM xx_reports WHERE typ='funct'");
	while ($f = db_fetch($res))
	{
	   	$a_h = explode("|",$f["attrib"]);
	   	$txt .= "<option value=\"".$a_h[0]."\" ".m_s($a_h[0],$term)." > ". $a_h[0]. "</option>\n";
	}
	$txt .= "</select>\n";
	$txt .= WIDTH."<input type='text' name='width' size=3 maxlength=3 value='".(isset($width) ? $width : "")."' onBlur='num_test(this);'>\n";
	label_cell($txt);
	end_row();
}
if (substr($id_new,0,1) != 'B')
{ 	// This is a report -> show block
	start_row();
	$txt = "<input type='radio' name='sel_typ' value = 'Block' ".m_c("Block",$sel_typ).">Block\n";
	label_cell($txt);
	$txt = "<select name='block' size='1'>\n";
	$res = db_query("SELECT * FROM xx_reports WHERE typ = 'block'");
	while ($f = db_fetch($res))
	{
	   	$h = explode("|",$f["attrib"]);
	   	$txt .= "<option value=\"".$h[0]."\" ".m_s($h[0],$block)." > ". $h[0]. "</option>\n";
	}
	$txt .= "</select>\n";
	label_cell($txt);
	end_row();
}
end_table(1);

start_table();
start_row();
label_cell(submit("insert", IT_STORE, false));
label_cell(submit("back", IT_BACK, false).hidden("alternate", $alternate,false).hidden("attriba", $attrib,false).
	hidden("id_new", $id_new,false).hidden("sql", $sql,false).hidden("long", $long));
if (!((substr($id_new,0,1) == 'B') || (substr($id_new,0,1 ) == 'F')))
{ 	// Only show test button for reports
	$txt = "<input name='druck' class='inputsubmit' type='button' value='".IT_PRINT."' onclick=\"displayReport('".$id_new."');\">\n";
	label_cell($txt);
}
end_row();
end_table();

echo "<hr size=1>\n";
end_form();

// <!--        End of input item form   -->
// <!--------------------------------------------------------------------->

display_heading(ITEM_HEAD);

start_table(TABLESTYLE, "width=70%");
$th = array(IT_TYP, IT_ART, IT_FONT, IT_FONT_SIZE, IT_ORD, IT_LEN, IT_X1, IT_Y1, "Total", IT_STRING, "Action", "");
table_header($th);
## Traverse the result set
$rec_ar = array();
$sort_ar = array("RH"=>"0","PH"=>"1","GH"=>"2","DE"=>"3","GF"=>"4","PF"=>"5","RF"=>"6");
$query="SELECT  * FROM xx_reports WHERE (typ = 'item' AND id='".$id_new."')";
$res = db_query($query);
while ($f = db_fetch($res))
{
    $in = $f["attrib"];
    $ine = explode("|",$in);
	for ($i = 0; $i < 16; $i++)
	{
		if (!isset($ine[$i]))
			$ine[$i] = "";
	}
    $in_index =	sprintf("%2s%2d%3d%3d%3d%3d%4s%1s%2%d%2d%1s%1s%1s%1s%5s",$sort_ar[$ine[1]],$ine[8],$ine[5],$ine[6],$ine[3],
    	$ine[4], $ine[0],$ine[9],$ine[10], $ine[11], $ine[12], $ine[13], $ine[14], $ine[15],$ine[2]);
        // for sort after 1) Art 2) Ord 3) X1 4) Y1 ....
    $rec_ar[$in_index] = $in;
}
ksort($rec_ar,SORT_STRING);
reset($rec_ar);
$k = 0;   // line-number
while (list ($key,$val) = each($rec_ar))
{
    $h = explode("|",$val);
	for ($i = 0; $i < 16; $i++)
	{
		if (!isset($h[$i]))
			$h[$i] = "";
	}
    $it_typ=$h[0];
    $it_art = $h[1];
    $it_font = $h[2];
    $it_fontsize = $h[3];
    $it_number = $h[4];
    $it_x1 = $h[5];
    $it_y1 = $h[6];
    if (in_array($it_typ, array("String","DB","Term","Block","Textarea")))
    	$it_str = $h[7];
    $it_ord = $h[8];
    $it_from = $h[10];
    $it_to = $h[11];
    $it_total = $h[12];
    $it_o_score = $h[13];
    $it_u_score = $h[14];
    $it_bold = $h[15];

 	// <!-- existing items -->
	alt_table_row_color($k);
	echo "<td style='width;0px;display:none;'>\n";
	start_form(false, false, "repgen_strings.php?report_type=".$report_type, "edit");
	echo "</td>\n";
 	label_cell($it_typ.hidden("id1", $id_new, false).hidden("attrib", $val, false).
 		hidden("id_new", $id_new, false).hidden("sql", $sql,false).hidden("long", $long, false));
 	label_cell($it_art);
 	label_cell($it_font);
 	label_cell($it_fontsize);
 	label_cell($it_ord);
 	label_cell($it_number);
 	label_cell($it_x1);
 	label_cell(($it_y1 != "" ? $it_y1 : "."));
	label_cell(($it_total != "" ? $it_total : "."));
    if (in_array($it_typ, array("Line","Rectangle")))
    	label_cell(".");
    else
    {
		if (!(empty($it_from) || empty($it_to)))
    		label_cell($it_str."(".$it_from."-".$it_to.")");
    	else
    		label_cell($it_str);
    }
	if (in_array($it_typ,array("String","DB","Term","Block","Textarea")))
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