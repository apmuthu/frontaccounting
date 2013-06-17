<?php
/* Include Datei repgen.inc for PHP Report Generator
   Bauer, 7.2.2002, Revised by Joe Hunt for FA 2.0, 21.08.2008 using TCPDF
   changed 19.11.2002
   Version 0.44
   Bauer (total, wordwrap)
*/
require_once($path_to_root."/admin/db/fiscalyears_db.inc");
require_once "repgen_def.inc";
define('K_PATH_FONTS', "../../reporting/fonts/");
require_once $path_to_root."/reporting/includes/pdf_report.inc";   // PDF class
// Define constants
define("RH","RH"); // Repport Header konstante
define("PH","PH"); // Page Header konstante
define("GH","GH"); // Group Header konstante
define("DE","DE"); // Detail Header konstante
define("GF","GF"); // Group Foot konstante
define("PF","PF"); // Page Foot konstante
define("RF","RF"); // Report Foot konstante
//      Konstante for Report file
define("SEL","select"); 	// select konstante
define("INFO","info");  	// info  konstante
define("GROUP","group"); 	// group konstante
define("ITEM","item");  	// item konstante
define("STR","String"); 	// Type of item
define("TERM","Term");  	// Type of item
define("TEXT","Textarea"); 	// Type of item
define("LINE","Line");  	// Type of item
define("RECT","Rect");  	// Type of item
define("IMAGE","Img");  	// Type of item
define("DB","DB"); 			// Type of item
define("BLOCK","Block"); 	// Type of item

define("CLASS_","class");  		// Type of report(more records on a page)
define("TABLE","classtable");  	// Type of report(more records on a page) with Boxes
define("BEAM","classbeam");    	// type of report with BEAM
define("GRID","classgrid");    	// type of report with BEAM and BOXES
define("SINGLE","single"); 		//type of report( one record on a page)
define("NEWPAGE","newpage"); 	// type of group-print(every group begins on a new page
define("NOPAGE","nopage");   	// type of group-print(no new page beginning)
define("DISTANCE",5);         	// Distanz between fields in Report
define("BLOCKDIST",5);      	// Distance of Blocks
define("POS_TOP",30);      	// First Print Position in a page
define ("POS_BOTTOM",30);      	// last Print Position in a page
define ("POS_LEFT",30);      	// first Print Position at left of line
define ("POS_RIGHT",30);      	// last Print Position at right of line
define ("YDIST",4);           	// distance between two lines

$p_formate = array("a4"=>"595|842","letter"=>"612|792"); // Paperformat
/*
 *
 * Class Item stores one Item of the report
 *
 *
 *
*/
class item
{
	/* this is an Item of the Report
	*/
	var $type;         	// Itemtype: String = S, Term = T or DB-Feld = D
	var $art;          	// Art: Page Head = PH   Group Head = GH
                   		//      Detail = DE      Group Foor = GF
                   		//      PageFoot = PF
	var $fontname;     	//  Fontname
	var $fontsize;     	// Fontsize
	var $fieldlength;  	//  Number of Characters of the field
	var $xpos;         	// x-Position of first character in points or
                   		//            column number, if Group
	var $ypos;         	// y-Position of first character in points or
                   		//            line number, if Group
	var $string;       	// String to print or Term to print or DB-fieldname to print
                   		//        depending on $type
	var $term;         	// Function code if $type = term
	var $ord;          	// Order of Item in Detail
	var $from;          	// 2. value for substring of text
	var $to;          	// 3. value for substring of text
	//-----------------     for Total sums -----------
	var $total_item;    // true:this item wants total sum
	var $o_score;      	// line over the sum
	var $u_score;      	// line under the score
	var $bold;         	// should be printed bold
	//---------------     end of toal sum ----------------
	var $filename;     	// filename of Jpeg-image
	function get_type(){return $this->type;}
	function set_type($t){$this->type = $t;}
	function get_art(){return $this->art;}
	function set_art($a){$this->art = $a;}
	function get_fontname(){return $this->fontname;}
	function set_fontname($f){$this->fontname = $f;}
	function get_fontsize(){ return $this->fontsize;}
	function set_fontsize($s){ $this->fontsize = $s;}
	function get_fieldlength(){return $this->fieldlength;}
	function set_fieldlength($f){$this->fieldlength = $f;}
	function get_xpos(){  return $this->xpos;}
	function set_xpos($x){ $this->xpos = $x;settype($this->xpos, "double");}
	function get_ypos(){ return $this->ypos;}
	function set_ypos($t){ $this->ypos = $t;settype($this->ypos, "double");}
	function get_string(){ return $this->string;}
	function set_string($t){ $this->string = $t;}
	function get_ord(){ return $this->ord;}
	function set_ord($t){ $this->ord = $t;}
	function get_from(){ return $this->from;}
	function set_from($n){$this->from= $n;}
	function get_to(){ return $this->to;}
	function set_to($n){$this->to= $n;}

	function get_total_item(){ return $this->total_item;}
	function set_total_item($n){$this->total_item= $n;}
	function get_o_score(){ return $this->o_score;}
	function set_o_score($n){$this->o_score= $n;}
	function get_u_score(){ return $this->u_score;}
	function set_u_score($n){$this->u_score= $n;}
	function get_bold(){ return $this->bold;}
	function set_bold($n){$this->bold= $n;}

	function get_term(){ return $this->term;}
	function set_term($n){$this->term = $n;}

}
/*
 *
 * Class Report reads a report-defintion from the table reports and interprets all read items
 *
 *
 *
*/

class report
{
	//  class for reports
	var $begin = true;   //  switch for beginning
	var $with_ord = false; // switch for ord
	var $name;           //  reportname
	var $long_name;      // long report name
	var $date_;           // Creation date of the report
	var $author;         // author of the report
	var $report_format;  // Format of the report Portrait or Landscape
	var $height;         // Height of one page in points
	var $width;          // Width of one page in points
	var $paper_format;    // Format of paper (a4,a3..)
	var $select;         // select-command for the data
	var $report_type;     // Type of report (class or single)
	var $pdf;            // PDF-pointer
	var $group;          // fieldname of group
	var $group_old = "";      // old group for changing group
	var $group_new;      // new group for changing group
	var $group_type;     // Type of group: newpage -> new page for every group
                     //                nopage  -> group on the same page
	var $rh_items=array();       // report header Items array
	var $ph_items=array();       // page header Items array
	var $gh_items=array();       // group header Items array
	var $de_items=array();       // detail header Items array
	var $gf_items=array();       // group footer Items array
	var $pf_items=array();       // page footer Items array
	var $rf_items=array();       // report footer Items array
	var $block_items=array();       // block Items array
	var $rh_i_items;     // report header index for items;
	var $ph_i_items;     // page header index for items;
	var $gh_i_items;     // group header index for items;
	var $de_i_items;     // detail index for items;
	var $gf_i_items;     // group foot index for items;
	var $pf_i_items;     // page foot index for items;
	var $rf_i_items;     // report foot index for items;
	var $a = array();
	// variables for drawing the Table in classtables
	var $x_tab = array(); // values of vertical line in table
	var $y_dist;          // distance between two horizontal lines
	var $y_pos;	      // current y position
	var $x_left=POS_LEFT;
	var $x_right=POS_RIGHT;
	var $y_top=POS_TOP;
	var $y_bottom=POS_BOTTOM;
	var $str_type = array(STR,DB,TERM,TEXT);
	var $dark=false;      // $dark = true  -> gray background
	var $subtotal = array(); // for subtotals of numeric fields
	var $total = array();    // for totals of numeric fields
	var $subcount; // counts number of records of groups
	var $count;    // counts number of records of the report
	var $res=array();
	var $f=array();


	function get_name(){ return $this->name; }
	function set_name($n){  $this->name= $n;}
	function get_long_name(){ return $this->long_name;}
	function set_long_name($n){ $this->long_name= $n;}
	function get_datum(){  return $this->date;}
	function set_datum($d){  $this->date= $d;}
	function get_author(){  if ($this->author == "") return "author"; else return $this->author;}
	function set_author($n){ $this->author= $n;}
	function get_report_format(){ return $this->report_format;}
	function set_report_format($f){  $this->report_format= $f;}
	function get_paper_format(){ return $this->paper_format;}
	function set_paper_format($f){  $this->paper_format= $f;}
	function get_height(){return $this->height;}
	function set_height($n){  $this->height= $n; settype($this->height, "double");}
	function get_width(){return $this->width;}
	function set_width($n){ $this->width= $n;settype($this->width, "double");}
	function get_select(){return $this->select;}
	function set_select($n){  $this->select= $n;}
	function get_group(){ return $this->group;}
	function set_group($n){$this->group= $n;}
	function is_set_group(){ $t=true; if (empty($this->group)) $t = false; return $t;}
	function get_report_typ(){ return $this->report_type;}
	function set_report_typ($n){$this->report_type= $n;}
	function get_group_new(){ return $this->group_new;}
	function set_group_new($n){$this->group_new= $n;}
	function get_group_old(){ return $this->group_old;}
	function set_group_old($n){$this->group_old= $n;}
	function get_group_type(){ return $this->group_type;}
	function set_group_type($n){$this->group_type= $n;}
	function set_margins($l, $t, $r, $b){$this->x_left=$l;$this->y_top=$t;$this->x_right=$r;$this->bottom=$b;}

	function sort_de_items()
	{
		$h_item = array();
		$l=0;
		foreach ($this->de_items as $a)
		{
    		$key= $a->get_ord().$l;  // make key for sort of ordered fields
    		$l++;
    		$h_item[$key] = $a;
		}
		ksort($h_item);
		$this->de_items = array_values($h_item);
  	}   // sort of de_items

	function get_first_item($s)
	{
        //  returns the first item of the specified type $s
		if ($this->get_item_count($s) == 0)
        	return null;
    	switch ($s)
    	{
      		case RH: $a = $this->rh_items[0];$this->rh_i_items = 0;break;
      		case PH: $a = $this->ph_items[0];$this->ph_i_items = 0;break;
      		case GH: $a = $this->gh_items[0];$this->gh_i_items = 0; break;
      		case DE: $a = $this->de_items[0];$this->de_i_items = 0; break;
      		case GF: $a = $this->gf_items[0];$this->gf_i_items = 0; break;
      		case PF: $a = $this->pf_items[0];$this->pf_i_items = 0; break;
      		case RF: $a = $this->rf_items[0];$this->rf_i_items = 0; break;
    	}
    	return $a;
    }
	function get_next_item($s)
	{
        // returns next item of the specified type $s
    	switch ($s)
    	{
      		case RH: $a = $this->rh_items;$this->rh_i_items ++; $i = $this->rh_i_items;break;
      		case PH: $a = $this->ph_items;$this->ph_i_items ++; $i = $this->ph_i_items;break;
      		case GH: $a = $this->gh_items;$this->gh_i_items ++; $i = $this->gh_i_items; break;
      		case DE: $a = $this->de_items;$this->de_i_items ++; $i = $this->de_i_items; break;
      		case GF: $a = $this->gf_items;$this->gf_i_items ++; $i = $this->gf_i_items; break;
      		case PF: $a = $this->pf_items;$this->pf_i_items ++; $i = $this->pf_i_items; break;
      		case RF: $a = $this->rf_items;$this->rf_i_items ++; $i = $this->rf_i_items; break;

    	}
    	if ($i < $this->get_item_count($s))
         	return $a[$i];
       	else
       		return null;
	}
	function get_item_count($s)
	{
         // returns the number of items in the specified typ $s

    	switch ($s)
    	{
      		case RH: $a = sizeof($this->rh_items);break;
      		case PH: $a = sizeof($this->ph_items);break;
      		case GH: $a = sizeof($this->gh_items); break;
      		case DE: $a = sizeof($this->de_items); break;
      		case GF: $a = sizeof($this->gf_items); break;
      		case PF: $a = sizeof($this->pf_items); break;
      		case RF: $a = sizeof($this->rf_items);break;

    	}
    	return $a;
  	}
	function set_item($s,$item)
	{
    	// $s is type
    	// $item is item

    	switch ($s)
    	{
      		case RH: array_push($this->rh_items,$item); break;
      		case PH: array_push($this->ph_items,$item); break;
      		case GH: array_push($this->gh_items,$item); break;
      		case DE: array_push($this->de_items,$item);break;
      		case GF: array_push($this->gf_items,$item); break;
      		case PF: array_push($this->pf_items,$item); break;
      		case RF: array_push($this->rf_items,$item); break;
      		case BLOCK: array_push($this->block_items,$item); break;
    	}
  	}
	function insert_blocks()
	{  // read blocks and insert into item arrays
    	$blocks = array();
    	// read all stored blocks and save id and attrib in $blocks
    	$query = "SELECT * FROM xx_reports WHERE typ = 'block'";
    	$res = db_query($query);
    	while($f = db_fetch($res))
    	{
       		$h = explode("|", $f["attrib"]);
       		$blocks[$h[0]] = trim($f["id"]);    // $h[0] is short name of block
    	}

    	foreach ($this->block_items as $item)
    	{
    		// get  items from block_array
    		// and read their items from the reports table
       		$h = $item->get_string();
       		$id = $blocks[$h];
       		$query = "SELECT * FROM xx_reports WHERE id = '$id' AND typ <> 'block'";
       		$res = db_query($query);
       		while ($f = db_fetch($res))
       		{
         		// insert the read items into the appropriate array
                $h = explode("|",$f["attrib"]);
                for ($i = 0; $i < 16; $i++)
                {
                	if (!isset($h[$i]))
                		$h[$i] = "";
                }
                $it = new item;
                $it->set_type($h[0]);
                $it->set_art($h[1]);
                $it->set_fontname($h[2]);
                $it->set_fontsize($h[3]);
                $it->set_fieldlength((int)$h[4]);
                $it->set_xpos($h[5]);
                $it->set_ypos($h[6]);
                $it->set_string($h[7]);
                $it->set_ord($h[8]);    // order of item in DE
                $it->set_from($h[10]);
                $it->set_to($h[11]);
                $it->set_total_item($h[12]);
               	$it->set_o_score($h[13]);
                $it->set_u_score($h[14]);
                $it->set_bold($h[15]);
                $this->set_item($h[1],$it);  // otherwise add item to the ph, de,... array
       		}
   		}

	}
	function make_terms_block(&$it,&$blocks)
	{
    	for ($i=0; $i<count($it); $i++)
    	{        // seek in block
       		if ($it[$i]->get_type() == TERM)
       		{
            	$h = $it[$i]->get_string();
            	$it[$i]->set_term($blocks[$h]);  // Code is in $term
       		}
    	}
	}

	function make_terms()
	{   // replace $item->string with the functioncode, if set_type = term
    	$blocks = array();
    	// read all stored blocks and save $short and Code in $blocks
    	$query = "SELECT * FROM xx_reports WHERE typ = 'funct'";
    	$res = db_query($query);
    	while($f = db_fetch($res))
    	{
       		$h = explode("|",$f["attrib"]);
       		$blocks[$h[0]] = $h[4];    // $h[0] is short name of block, $h[4] is function
       		eval(html_entity_decode($blocks[$h[0]]));   // declare function,  only once per run
    	}
    	$this->make_terms_block($this->rh_items,$blocks);
    	$this->make_terms_block($this->ph_items,$blocks);
    	$this->make_terms_block($this->gh_items,$blocks);
    	$this->make_terms_block($this->de_items,$blocks);
    	$this->make_terms_block($this->gf_items,$blocks);
    	$this->make_terms_block($this->pf_items,$blocks);
    	$this->make_terms_block($this->rf_items,$blocks);
	}
	function do_report($id)
	{
    	// reads report from database and store in variables
    	global $p_formate;
    	$this->count = 0;   // number of records = 0
    	$query = "SELECT typ, attrib FROM xx_reports WHERE id = '".$id."'";
    	$res = db_query($query, "EXIT!!!");
    	if (db_num_rows($res) == 0)
    	{
        	// report is not declared
        	display_error("<BR> Report does not exist !! id=".$id);
        	exit;
    	}
    	while ($f = db_fetch($res))
    	{
        	// read the report, store values
    		$typ = trim($f["typ"]);
    		$attrib = trim($f["attrib"]);
    		switch ($typ)
    		{
        		case SEL :           // select record
                	$this->set_select(strtr($attrib,"^","'"));
                    break;
        		case INFO   :        // info record
                    $h = explode("|",$attrib);
                	for ($i = 0; $i < 16; $i++)
                	{
                		if (!isset($h[$i]))
                			$h[$i] = "";
                	}
                    $this->set_name($h[0]);
                    $this->set_datum($h[1]);
                    $this->set_author($h[2]);
                    $this->set_long_name($h[3]);
                    $this->set_paper_format($h[5]);
                    $h1 = $p_formate[$h[5]];
                    $h2 = explode("|", $h1);
                    $this->set_width($h2[0]);
                    $this->set_height($h2[1]);
                    $this->set_report_format($h[4]);
                    if (strtolower($h[4])== "landscape")
                    {
                    	$a=$this->get_width();
                        $this->set_width($this->get_height());
                       	$this->set_height($a);
                    }
                    $this->set_report_typ($h[6]);
                    break;
        		case GROUP  :         // group record
                    $h = explode("|",$attrib);
                    $this->set_group($h[0]);
                    $this->set_group_type($h[1]);
                    break;
        		case ITEM   :        // item record
                    $h = explode("|",$attrib);
                	for ($i = 0; $i < 16; $i++)
                	{
                		if (!isset($h[$i]))
                			$h[$i] = "";
                	}
                    $it = new item;
                    $it->set_type($h[0]);
                    $it->set_art($h[1]);
                    $it->set_fontname($h[2]);
                    $it->set_fontsize($h[3]);
                    $it->set_fieldlength((int)$h[4]);
                    $it->set_xpos($h[5]);
                    $it->set_ypos($h[6]);
                    $it->set_string($h[7]);
                    $it->set_ord($h[8]);    // order of item in DE
                    if (!empty($h[8]))
                    	$this->with_ord = true;
                    $it->set_from($h[10]);
                    $it->set_to($h[11]);
                    $it->set_total_item($h[12]);
                    $it->set_o_score($h[13]);
                    $it->set_u_score($h[14]);
                    $it->set_bold($h[15]);
                    if ($it->get_total_item() == "true")
                    {
			    		$this->subtotal[$it->get_string()] = 0;
			    		$this->total[$it->get_string()] =0;
					}
					if ($it->get_type() == BLOCK)
					{  // add item to block-array
			   			$this->set_item(BLOCK,$it);
			   		}
					else
					{
                        $this->set_item($h[1],$it);  // otherwise add item to the ph, de,... array
			   		}
                    break;

        		default:
        			break;
    		}
   		}// end of while

		$this->insert_blocks();  // inserts blocks into item-array
		$this->make_terms();
		$this->sort_de_items();
  	}
	/*
	 *     methods for printing
	 *
	 *
	*/

	function print_string_wrap($string, $x, $y,$fs,$width,$mode)
	{
 		// prints a string at the given position
		// translates Umlaute into pdf-format
		//   $uml = sprintf("%c%c%c%c%c%c%c",138,128,154,133,159,134,167);
		//   $str=strtr($string,"äÄöÖüÜß", $uml);

    	switch ($mode)
    	{
        	case "l": $m = 'left'; break;
			case "c": $m = 'center'; break;
			case "r": $m = 'right'; break;
			default : $m = 'left'; break;
		}
     	$r = $string;
     	$y1 = $y;
     	while ($r != '')
     	{
            $r=$this->pdf->addTextWrap($x,$y1,$width, $fs,$r,$m,0,0,true);
	    	$y1=$y1 - $fs;
	    }
	}

	function print_string($string, $x, $y, $fs)
	{
 		// prints a string at the given position
		// translates Umlaute into pdf-format
		//   $uml = sprintf("%c%c%c%c%c%c%c",138,128,154,133,159,134,167);
		//   $str=strtr($string,"äÄöÖüÜß", $uml);

   		$this->pdf->addText($x, $y, $fs, $string);
	}

	function set_font($font='', $size=9)
	{   // sets the fontname
		$style = '';
		$font = strtolower($font);
		$fpos = strpos($font, "-");
		if ($fpos > 1)
		{
			if (stripos($font, "-bolditalic"))
				$style = "BI";
			elseif (stripos($font, "-bold"))
				$style = "bold";
			elseif (stripos($font, "-italic"))
				$style = "italic";
			$font = substr($font, 0, $fpos);
		}
		if ($font == "helvetica")
			$font = "";
        $this->pdf->selectFont($font, $style) ;
		$this->pdf->SetFontSize($size);
 	}

	function print_line($x1, $y1, $x2, $y2, $width)
	{
		// draws line from $x1/$y1 to $x2/$y2
    	$x1n = $x1;
    	settype($x1n,"double");
    	$y1n = $y1;
    	settype($y1n,"double");
    	$x2n = $x2;
    	settype($x2n,"double");
    	$y2n = $y2;
    	settype($y2n,"double");
    	$widthn = $width;
    	settype($widthn, "double");  // width of line in points
    	if ($widthn <= 0)
    		$widthn = 1.0;
			
    	$this->pdf->setLineStyle(array('width' => (int)$widthn));
    	$this->pdf->line($x1n, $y1n,$x2n, $y2n);
	}

	function print_rect($linewidth, $x1,$y1,$width,$height)
	{
 		// prints Rect from $x1/$y1 with width and height
    	$x1n = $x1;
    	settype($x1n,"double");
    	$y1n = $y1;
    	settype($y1n,"double");
    	$heightn = $height;
    	settype($heightn,"double");
    	$widthn  = $width;
    	settype($widthn,"double");
    	$linewidthn = $linewidth;
    	settype($linewidthn,"double");
 		$this->pdf->setLineStyle(array('width' => $linewidthn));
    	$this->pdf->rectangle($x1n, $y1n, $widthn, $heightn);

	}

	function print_table($pos, $h)
	{ // draws a grid around the table
    	$linewidthn = 1.0;
    	$x_size = sizeof($this->x_tab);

    	// horizontal lines
    	//$pos1 = $pos  + $this->y_dist - YDIST + 1;
    	//$pos1 = $pos  + $this->y_dist + YDIST - 3;
    	$pos1 = $pos + $this->y_dist + 2;
    	//$pos2 = $pos - $h ;
    	$pos2 = $pos - $h + 2 * YDIST;
    	$this->print_line($this->x_tab[0], $pos1, $this->x_tab[$x_size-1],  $pos1,$linewidthn);
    	$this->print_line($this->x_tab[0], $pos2, $this->x_tab[$x_size-1],  $pos2,$linewidthn);
        // vertical lines
    	for ($i=0;$i < $x_size; $i++)
    	{
         	$this->print_line( $this->x_tab[$i], $pos1, $this->x_tab[$i], $pos2,$linewidthn);
    	}

	}

	function print_background($pos,$h,&$dark)
	{   //prints with underground $pos=linke obere Ecke, $h=Tiefe
    	$x_size = sizeof($this->x_tab);
    	$width = $this->x_tab[$x_size-1] - $this->x_tab[0];
    	if ($dark)
    	{
        	$color = array(220,220,220);
    	}
    	else
    	{
            $color = array(255,255,255);
        }
        $pos1 = $pos + $this->y_dist + 2;
    	$pos2 = $pos - $h + 2 * YDIST;
   		$this->pdf->rectangle($this->x_tab[0],$pos1,$width,$pos2,'F', null, $color);
   		if ($dark) // fake for not continuing dark color the rest of page.
   			$this->pdf->rectangle($this->x_tab[0],$pos2-1,$width,$pos2-2,'F', null, array(255,255,255));
   		$dark= !$dark;
	}
	function calculate_function($item)
	{
		// calculates the value of a term and gives it back
        $h = stripslashes($item->get_term());

        $h_a = strtok($h, "(");  // look if the function has a parameter
        $h_a = strtok(")");      // $h_a is now the parameter

        if (!empty($h_a))
        {    					// first parameter is $this
        	if (strlen($h_a))
        	{ 					// one parameter = $this ,
            	$func = '$field='.$item->get_string().'($this);';
            }
        }
        else
        {
        	$func = '$field='.$item->get_string().'();';
        }
        if (function_exists($item->get_string()))
        {
            eval($func);   // execute function
        }
        else
        {
        	$field="Error: Function does not exist!";
        }
    	return $field;
    }

	function do_print_item($item, $xpos, $ypos, $height)
	{
		// prints an item with the current data
 		$f = $item->get_type();
		switch ($f)
		{
			case STR :
				$field = $item->get_string();break; // String item
			case TERM:  // print Terms in String
			case TEXT:  // print Terms in Textarea with wrap
				$field = $this->calculate_function($item);
				break; // function call()

			case DB  :  // Database field name
				$field = trim($this->f[$item->get_string()]);
				if ($item->get_total_item() == "true")
				{     // sum up for total fields
					$this->subtotal[$item->get_string()] += $field;
					$this->total[$item->get_string()] += $field;
				}
				break;
			default:
				break;
		}
		// shorten $field, if needed
		$sv = $item->get_from();
		$sb = $item->get_to();
		if (!(empty($sv) || empty($sb)))
		{
			$field = substr($field,$sv - 1,$sb - $sv + 1);
		}

		if (in_array($f,$this->str_type))
		{     // print strings  String modus
			$fn = $item->get_fontname();
			$fs = $item->get_fontsize();
			$this->set_font($fn, $fs);
			$fl = $item->get_fieldlength();

			if ($fl == "")
			{
				$this->print_string($field,$xpos,$ypos,$fs);  // for compatibility reason included
			}
			else
			{
				// we should print boxed
				list($fl,$mode) = sscanf($fl,"%d%s");
				if (empty($fl))
					$mode="l";    // default is left mode
				if ($f != TEXT)
				{
					$fh = str_repeat("w", (int)$fl);
					$w =$this->pdf->getStringWidth($fh);
					$this->print_string_wrap($field, $xpos , $ypos,  $item->get_fontsize(),$w, $mode);
				}
				else
				{   // Term in Textarea
					$this->print_string_wrap($field, $xpos, $ypos,$item->get_fontsize(),$fl,$mode);
				}
			}
		}
		else
		{ // Line-Modus
			$space_help = $this->y_pos;
			switch ($f)
			{
				case LINE:
					$art = $item->get_art();
					if ($art == RH)
					{
						$x = $this->x_left;
						$y = $this->get_height() - $this->x_left;
						$x2 = $this->get_width() - $this->x_right;
						$y2 = $y + 1;
						$width = 2;
					}
					elseif ($art == RF)
					{
						$x = $this->x_left;
						$y = $this->y_pos - 4;
						$x2 = $this->get_width() - $this->x_right;
						$y2 = $y;
						$width = 2;
					}
					elseif ($art == PH)
					{
						$x = $this->x_left;
						//$y = $this->get_height() - $this->x_left;
						$y = $this->y_pos + 11;
						$x2 = $this->get_width() - $this->x_right;
						$y2 = $y;
						$width = 1;
						$this->print_line($x, $y, $x2, $y2, $width);
						$y = $y - 16;
						$y2 = $y;
						$width = 1;
					}
					elseif ($art == GH)
					{
						$x = $this->x_left;
						$y = $this->y_pos - 3;
						$x2 = $this->get_width() - $this->x_right;
						$y2 = $y;
						$width = 1;
					}
					elseif ($art == GF)
					{
						$x = $this->x_left;
						$y = $this->y_pos + 15;
						$x2 = $this->get_width() - $this->x_right;
						$y2 = $y;
						$width = 1;
					}
					else
					{
						$x = $item->get_fontsize();
						$y = $item->get_fieldlength();
						$x2 = $item->get_xpos();
						$y2 = $item->get_ypos();
						$width = $item->get_fontname;
					}
					$this->print_line($x, $y, $x2, $y2, $width);
					break;
				case RECT:
					$this->print_rect($item->get_fontname(), $item->get_fontsize(),
						$item->get_fieldlength() + $space_help,	$item->get_xpos(), $item->get_ypos());
					break;
				case IMAGE:
					if (!file_exists($item->get_string()))
					{
						echo ERROR_FILE_EXISTS.$item->get_string()."!";
					}
					$fileinfo = pathinfo($item->get_string());
					$type = strtolower($fileinfo['extension']);
					if (isset($fileinfo['extension']) && (!empty($fileinfo['extension'])) &&
						($type == 'jpg' || $type == 'png'))
					{
						if ($type == 'jpg')
							$this->pdf->addJpegFromFile($item->get_string(), $item->get_xpos(), $item->get_ypos(),
								$item->get_fontsize(), $item->get_fieldlength());
						else
							$this->pdf->addPngFromFile($item->get_string(), $item->get_xpos(), $item->get_ypos(),
								$item->get_fontsize(), $item->get_fieldlength());
					}
					else
					{
						echo ERROR_FILENAME.$item->get_string()."!";
					}
					break;
				default:
					break;
			}
		}
	}
	function de_space()
	{
		// returns the overall heigth of the next detail line
      	$it = $this->get_first_item(DE);
       	$max = 0;
       	if ($it == null)
       		return 0;
       	do
       	{    // go through all items
       		if ($it == null)
       			break;
            $rows = 0;
           	if (in_array($it->get_type(), array(LINE, RECT, IMAGE)))
           	{ // graphic element found
                if ($it->get_type() == LINE)
                {
                    $y_h = max($it->get_fieldlength(), $it->get_ypos());
                    $max = max($y_h, $max);
                }
                else
                { // for rect and image
                    $max = max($max, $it->get_fieldlength() + $it->get_ypos() + 3.0);
                }
                continue;  // max height of graphic element is included
            }
            switch ($it->get_type())
            {
               	case STR:
               		$r = trim($it->get_string());  // get Item values
                    break;
               	case TERM:
               	case TEXT:
               		$r = trim($this->calculate_function($it));
                    break;
               	case DB:
                    $r = trim($this->f[$it->get_string()]);  // get Item values
                    break;
               	default:
               		break;
            }
			$fl = $it->get_fieldlength();
	    	$fs = $it->get_fontsize();
            list($fl,$mode) = sscanf($fl,"%d%s");  // part justification
            if (strlen($r) > $fl)
            {   // need wordwrap
              	$fh = str_repeat("w", (int)$fl);   // get the width of the item
              	$this->set_font($it->get_fontname(), $fs);
              	$fspix = $this->pdf->GetStringWidth($fh);
				while ($r != "")
				{
					$r2 = $this->pdf->CalcTextWrap($r, $fspix, true);
					$r = $r2[1];
					$rows++;
				}
	      		$rows --;
           	}
	   		$rows ++;
           	$height = $rows * $fs; // height = number of lines * fontsize + distance
           	$max = max($max, $height);    // $max is greatest height of an item
       	}
       	while ($it = $this->get_next_item(DE));
    	$it = $this->get_first_item(DE);
    	if ($it == null)
    		return 0;  // no items
		return $max;
	}

	function paragraph_space($typ)
	{ // returns needed space for a paragraph in points without textwrap for DE
  		$it = $this->get_first_item($typ);
  		$max = 0;
  		if ($it == null)
  			return 0;
  		do
  		{
       		if ($it == null)
       			return $max;
       		if (in_array($it->get_type(), array(LINE, RECT, IMAGE)))
       		{ // graphic element found
                if ($it->get_type() == LINE)
                {  // line: max = max(y1|y2|max)
                	$y_h = max($it->get_fieldlength(), $it->get_ypos());
                    $max = max($y_h, $max);
                }
                else
                { // for rect and image: max=max(y1+height,max)
                    $max = max($max, $it->get_fieldlength() + $it->get_ypos()+ 3.0);
                }
                continue;
         	}
       		$yp = abs($it->get_ypos()) + $it->get_fontsize() ;
       		$max = max($max,$yp);
  		}
  		while ($it = $this->get_next_item($typ));
  		return $max;
	}

	function print_new_page()
	{
        // prints Page footer, closes page, open new page and prints Page Header
        $this->do_print(PF);
        $this->do_print(PH);
	  	$this->dark = false;
	}
	function make_x_tab()
	{   // calculates the highest fontsize in a line and
    	// establish the array x_tab
    	$ah = $this->get_first_item(DE);
    	$i = 0;
    	$x_pos = $this->x_left-2;
    	if ($ah == null)
    	{  // empty paragraph
           	$this->x_tab[$i] = $x_pos;
           	return;      // #######        exit, because no item in paragraph
        }
    	do
    	{
    		if ($ah == null)
    		{
           		$this->x_tab[$i] = $x_pos;
    			break;
    		}
     		if (in_array($ah->get_type(), $this->str_type))
     		{
          		$wh1= $ah->get_xpos();  // Compiler needed  this construction with empty
	  			if (empty($wh1))
	  			{      // no xpos for this item -> order number must exist
	     			$this->x_tab[$i] = $x_pos ;    // set x_pos for lines in table
             		$fh = str_repeat("w", $ah->get_fieldlength());
             		$this->set_font($ah->get_fontname(), $ah->get_fontsize());
             		$ah->set_xpos($x_pos + 2.0);
             		$w = $this->pdf->getStringWidth($fh);
	     			$x_pos = $x_pos + $w + DISTANCE;
	  			}
	  			else
	  			{
              		$this->x_tab[$i] = $ah->get_xpos() -2;  // vertical line in table
              		$fh = str_repeat("w",$ah->get_fieldlength());
              		$this->set_font($ah->get_fontname(), $ah->get_fontsize());
              		$w =$this->pdf->getStringWidth($fh);
	      			$x_pos = max($x_pos,$this->x_tab[$i] + $w + DISTANCE);
	  			}
          		$i++;
     		}
    	}
    	while ($ah = $this->get_next_item(DE));
    	if ($i == 1)
    	{
            $this->x_tab[1] = $this->get_width() - $this->x_right;
    	}
    	else
    	{
      		$this->x_tab[$i] = $x_pos;  // most right vertical line
    	}
    	sort($this->x_tab);    // Sort the array, so that x_tab[0] has the lowest value
    	reset($this->x_tab);
	}

	function print_record($table, $height)
	{ // prints one record in detail block
       	if (($this->y_pos - $this->de_space()) < ($this->y_bottom + $this->paragraph_space(PF)))
       	{
             $this->print_new_page();
             $this->y_pos -= $this->paragraph_space(DE);
       	}
       	if (($this->get_report_typ() == BEAM) || ($this->get_report_typ() == GRID))
       	{// print background
		 	$this->print_background($this->y_pos, $height,$this->dark);
		 	$this->print_table($this->y_pos, $height);
   			$this->pdf->SetFillColor(255,255,255);
		}

       	$ah = $this->get_first_item(DE);
       	$i = 0;
       	while ($ah != null)
       	{
        	// navigate thru all items
         	if ($table)
         	{
                $this->do_print_item($ah, $ah->get_xpos(),$this->y_pos+$ah->get_ypos(), $height);
                $i++;
         	}
         	else
         	{
               	$this->do_print_item($ah, $ah->get_xpos(),$ah->get_ypos(), $height);
         	}
       		$ah = $this->get_next_item(DE);
       	}
       	$this->count++;
       	$this->subcount++;
	}

	function print_class_detail()
	{
        //  DE loops through all data records
       	$this->y_dist = $this->paragraph_space(DE); // space for first DE-Line
		$this->make_x_tab();                        // creates $this->x_tab[] too
       	$this->y_pos -= $this->y_dist;
       	do
       	{          // get new record
   			$height = $this->de_space();  				// height of DE with text-wrap
           	if ($this->is_set_group())
           	{  // work with group
              	$this->set_group_new(trim($this->f[$this->get_group()]));
              	if ($this->get_group_new() != $this->get_group_old())
              	{  // group is changed
                 	$hi =  trim($this->get_group_old());
                 	if ($hi != "")
                 	{                    // Not first page of report
                     	$this->y_pos -= $this->y_dist ;
                     	$this->do_print(GF);     // print group footer
                     	if ( $this->get_group_type() == NEWPAGE)
                     	{
                         	$this->print_new_page();      // new page opened
                     	}
                 	}
       				$this->set_group_old($this->get_group_new());
                 	$this->do_print(GH);     // print group header
                 	$this->y_pos -= $this->y_dist;
              	}     // end of work for group change

           	}
           	// end of group work
           	$this->print_record(true, $height);
	   		$this->y_pos = $this->y_pos - $height - $this->y_dist + YDIST + 2;
      	}
      	while ($this->f = db_fetch($this->res));// of do
	}

	function print_single_detail()
	{   // prints a detail on a page
      	//  loops through all data records
       	$this->make_x_tab();                        // creates $this->x_tab[] too
       	do
       	{
           	// get new record
         	$this->print_record(false,0);
         	$this->pdf->newPage();
         	$this->y_pos = $this->get_height() - $this->y_top - DISTANCE;
      	}
      	while ($this->f = db_fetch($this->res));
	}

	function print_totals($pos, $tot)
	{
       	// prints all totals in one line. $tot==0: print $this->totals. $tot==1: print $this->subtotals
       	if ($tot == 0)
       	{
          	$tothelp = $this->total;
	  	}
	  	else
	  	{
	  		$tothelp = $this->subtotal;
       	}
       	while (list($key, $value) = each($tothelp))
       	{
          	// seek item where $key == $item->get_string() and get x/y, font, fontsize
           	$ah = $this->get_first_item(DE);
           	$i = 0;
           	if ($ah == null)
           		break;
	   		while ($key != $ah->get_string())
	   		{
	       		$ah = $this->get_next_item(DE);
	       		if ($ah == null)
	       			break;
	       		$i++;
	    	}
	   		// item is found
	   		if ($ah->get_xpos() == "")
	   			$xpos = $this->xtab[$i];
	     	else
	     		$xpos= $ah->get_xpos();
           	list($fl,$mode) = sscanf($ah->get_fieldlength(), "%d%s");
           	$fh = str_repeat("w",$fl);
			$fs = $ah->get_fontname();
	   		if ($ah->get_bold() == "true")
	   		{  	// total shall be printed bold
	      		// set the font to bold
	      		if (!strstr($fs, "Bold"))
	      		{
	          		// Insert 'Bold' in fontname
		  			$fpos = strcspn($fs,"-") ;
		  			$fs1 = substr($fs,0,$fpos)."-Bold".substr($fs,$fpos+1);
		  			$fs = trim($fs1);
              	}
	   		}
   			$this->set_font($fs, $ah->get_fontsize());
           	$w = $this->pdf->getStringWidth($fh);
	   		$xpos2 = $xpos + $w;
	   		if ($ah->get_o_score() == "true")
	   		{
	      		$ypos = $pos + $ah->get_fontsize() + 2;
	      		$this->print_line($xpos, $ypos ,$xpos2,$ypos,1);
	   		}
	   		if ($ah->get_u_score() == "true")
	   		{
	      		$this->print_line($xpos, $pos - 2, $xpos2, $pos - 2, 1);
	   		}
           	$this->print_string_wrap(trim($value),$xpos, $pos,$ah->get_fontsize(),$w,$mode);
           	if ($tot == 1)
           	{
                 $this->subtotal[$key] = 0;
           	}
       	}
	}

	// methods to print a report
	function do_print($type)
	{
  		// prints paragraph from the given type
    	switch ($type)
    	{
      		case RH:
      			$a = $this->rh_items;
               	$this->y_pos = $this->get_height() - $this->y_top -(4 * DISTANCE);
      			break;
      		case PH:
      			$a = $this->ph_items;
               	if ($this->begin)
               	{
               		$this->begin = false;
               		$space = $this->paragraph_space(RH);
               	}
	       		else
	       		{
                  	$this->pdf->newPage();
                  	$space = 0;
		  		}
               	$this->y_pos = $this->get_height() - $this->y_top - $space - (6*DISTANCE);
               break;
      		case GH:
      			$a = $this->gh_items;
      			$this->y_pos = $this->y_pos -$this->paragraph_space(GH)-DISTANCE;
      			$this->subcount=0;
	       		break;
      		case DE:
      			$a = $this->de_items;
      			break;
      		case GF:
      			$a = $this->gf_items;
      			$this->y_pos = $this->y_pos -$this->paragraph_space(GF)+DISTANCE;
               	break;
      		case RF:
      			$a = $this->rf_items;
      			$this->y_pos = $this->y_pos -$this->paragraph_space(RF)-DISTANCE;
      			break;
      		case PF:
      			$a = $this->pf_items;
      			$this->y_pos = $this->y_bottom;
      			break;
      		default: break;
  		}
   		if ($type == DE)
   		{    // only for Detail items
      		$h = $this->report_type;
      		if ($h == CLASS_ || $h == TABLE || $h == BEAM || $h == GRID)
      		{
            	$this->print_class_detail(); // some records on a page
      		}
      		else
      		{
            	$this->print_single_detail();    //single record on a page
      		} // end of Detail-work
   		}
   		else
    	{   // all item-types <> DE
     		if ($this->y_pos < $this->y_bottom)
     		{    // begin new page
               	$this->print_new_page();
     		}
     		if ($type == RF)
     		{
       			// print totals
       			$this->print_totals($this->y_pos,0);
       		}
   			if ($type == GF)
   			{     // prints totals in Group foot
       			$this->print_totals($this->y_pos,1);

   			}
			for ($i=0;$i < $this->get_item_count($type); $i++)
			{
				$this->do_print_item($a[$i], $a[$i]->get_xpos(), $this->y_pos +$a[$i]->get_ypos(), $this->de_space());
				// print all items of this paragraph
     		}
   		}
  		$this->y_pos -= $this->y_dist;
  		if ($type == PH)
  			$this->y_pos -= BLOCKDIST;
 	}

	function create_page()
	{   // prints a complete report, because in the paragraph for Detail(DE) is
	    // a loop through all records. Here the first Page Header and the last Page footer ist printed.
	    // executes the select for data-source.
	    $sql = $this->get_select();
		$sql = str_replace("0_", TB_PREF, $sql);

	    $this->res = db_query($sql, "EXIT3 !!!");
	    if (db_num_rows($this->res) == 0)
	    {
	        display_error("$sql No Data Records found !!!");
	        exit;
	    }
	    $this->f = db_fetch($this->res);
	    $this->y_pos = $this->get_height() - $this->y_top;
	    if ($this->is_set_group())
	    {  	// work with group
	        $this->set_group_new(trim($this->f[$this->get_group()]));
	    }
	 	// new page and page header
	   	if (!empty($this->rh_items))
	   	{
	       	$this->do_print(RH);
	    }
	    $this->do_print(PH);
	    if (!empty($this->de_items))
	    {
	       	$this->do_print(DE);          // most work is done here
	    }
	    if (!empty($this->gf_items))
	    {
	       	$this->do_print(GF);
	    }
	    if (!empty($this->pf_items))
	    {
	      	$this->do_print(PF);
	    }
	    if (!empty($this->rf_items))
	    {
	       	$this->do_print(RF);
	    }
	}

}  // end of class report

function create_report($id, $file)
  //   $id is the id-number of the report in the database
{
	global $pdf_debug, $fh;
	 //$d = true;  // switch for debug
	$d = $pdf_debug; // from FA config.php
    // create report-instantiation
  	$rep = new report();

	$rep->pdf = new Cpdf('A4', $_SESSION['language']->code); //$l

   	$rep->pdf->newPage();
  	$rep->do_report($id);
    $rep->pdf->setPageFormat($rep->get_paper_format(), $rep->get_report_format());
  	$rep->set_font();
  	$rep->set_margins(POS_LEFT,POS_TOP,POS_RIGHT,POS_BOTTOM);
  	$rep->pdf->addInfo("Author",$rep->get_author());
  	$rep->pdf->addInfo("Creator",$rep->get_author());
  	$rep->pdf->addInfo("Title",$rep->get_name());
  	$rep->pdf->addInfo("Subject",$rep->get_name());
  	$rep->pdf->addInfo("Keywords",$rep->get_name());
  	$rep->create_page();

 	if (isset($d) && $d)
	{
  		$pdfcode = $rep->pdf->Output('', 'S');
  		$pdfcode = str_replace("\n","\n<br>",htmlspecialchars($pdfcode));
  		echo '<html><body>';
  		echo trim($pdfcode);
  		echo '</body></html>';
	}
	else
	{
  		$tmp = $rep->pdf->Output($file, 'F');
  	
  		$hfile = basename($file);
		header('Content-type: application/pdf');
		header("Content-Disposition: inline; filename=$hfile");
		header('Expires: 0');
		header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
		header('Pragma: public');
		$rep->pdf->Stream();

	}
}

// only for testing:
//create_report("report_id");
?>
