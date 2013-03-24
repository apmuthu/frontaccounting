<?php
// =========================================================================
//
//  Please, don't remove this
//
//  Author:      				Enéas Gesing (eneasgesing at gmail dot com)
//	Web: 	     				http://www.portalsi.info
//	Name: 	     				xpMenu.class.php
// 	Description:   				An easy to use xp style menu generator class
//  License:      			GNU General Public License (GPL)
//  Release Date:               	December 27th / 2006
//  Last Update date: 		December 27th / 2006
//  Version:                    		1.0
//
// Tested on:
//		* Server Side:
//			* php 4.4.2
//			* php 5.2
//
//		* Client Side:
//			* Internet Explorer 7.0
//			* Mozilla Firefox 2
//			* Opera 9.02
//
//  If you make any modifications making it better, please let me know, send me mail: eneasgesing at gmail dot com
// ========================================================================

class xpMenu{

	// initialize variables for class use
	var $xpmenu = array();
	var $submenu_onmouseover;
	var $submenu_onmouseout;
	var $menu_backgroundcolor;
	var $option_backgroundcolor;
	var $menu_width;
	var $menu_height;
	var $option_width;
	var $option_height;
	var $menu_cursor;
	var $option_cursor;
	var $option_bordercolor;
	var $menu_topleftborder;
	var $menu_bottomrightborder;
	var $menu_expanded;

	/*
	Function : xpMenu()
	Parameters:
		none
	Return:
		none
	Description: Class Constructor Function - Sets variables used on the class
	PS.: You can change these values as you need (some values can be changed on style function)

	*/

	function xpMenu(){
		// cell color when mouse is over
		$this->submenu_onmouseover 	= '#D8E4F8';
		// cell color when mouse is out
		//$this->submenu_onmouseout		= '#F5F5F5';
		$this->submenu_onmouseout		= '#EBF0F3';
		// backgroundcolor of menu
		$this->menu_backgroundcolor		= 'buttonface';
		// backgroundcolor of options
		$this->option_backgroundcolor		= '#F5F5F5';
		// menu width
		$this->menu_width			= '100%';
		// option width
		$this->option_width			= '100%';
		// menu height
		//$this->menu_height			= '28px';
		$this->menu_height			= 'auto';
		// option height
		//$this->option_height			= '24px';
		$this->option_height			= 'auto';
		// menu cursor when mouseover
		$this->menu_cursor			= 'hand';
		// option cursor when mouseover
		$this->option_cursor			= 'hand';
		// border color of option
		$this->option_bordercolor		= '#FFFFFF';
		// menu top and left borders
		$this->menu_topleftborder		= '#F5F5F5';
		// menu bottom and right borders
		$this->menu_bottomrightborder		= 'buttonshadow';
		$this->menu_expanded = false;
	}

	/*
	Function : style()
	Parameters:
		none
	Return:
		string $style_css (contain css to put inside of HTML <head> tag)
	Description: Create the CSS for menu
	PS.: You can copy this and paste on your own CSS file (for this use the content of file extra/style.css without PHP vars)
	*/

	function style(){

		$style_css = '
		<style type="text/css">
		#leftcolumn a { color:#006699; text-decoration:none;}
		#leftcolumn  a:hover { color:#000000; text-decoration:none;}
		#leftcolumn  a:active { color:#000000; text-decoration:none;}

		.dynmenu
		{width: '.$this->menu_width.'; height: '.$this->menu_height.'; padding:2 5 3 16; border-right: '.$this->menu_bottomrightborder.' 1px solid; border-top: '.$this->menu_topleftborder.' 1px solid; border-left: '.$this->menu_topleftborder.' 1px solid; border-bottom: '.$this->menu_bottomrightborder.' 1px solid; background-color: '.$this->menu_backgroundcolor.'; cursor:'.$this->menu_cursor.'; color:#000000;}
		.dynoption
		{width: '.$this->option_width.'; height: '.$this->option_height.'; padding:2 5 3 16; border: 1 1 1 1 solid '.$this->option_bordercolor.'; background-color: '.$this->option_backgroundcolor.'; cursor:'.$this->option_cursor.'; overflow:hidden;}
		.dynoption2
		{width: '.$this->option_width.'; height: '.$this->option_height.'; padding:2 5 3 16; border: 1 1 1 1 solid '.$this->option_bordercolor.'; background-color: '.$this->option_backgroundcolor.'; color:black; font-weight: bold;}
		.dynoption3
		{width: '.$this->option_width.'; height: '.$this->option_height.'; padding:2 5 3 16; border: 1 1 1 1 solid '.$this->option_bordercolor.'; background-color: '.$this->option_backgroundcolor.';}
		.dynoptions {padding:1 1 1 1}
		</style>';
		return $style_css;
	}

	/*
	Function : javaScript()
	Parameters:
		none
	Return:
		string $javascript (contain javascript to put inside of HTML <head> tag)
	Description: Create the JavaScript for menu
	PS.: Don't change this if you don't know
	*/

	function javaScript(){

		$javascript = '
		<script language=\'javascript\'>
		// Impede Seleção
		document.onselectstart = function() { return false; }

		function SwitchMenu(obj,div){
			if(document.getElementById){
		    	var el  = document.getElementById(obj);
				var cat = "mdiv" + div;
		    	var ar  = document.getElementById(cat).getElementsByTagName("span");
		    	if(el.style.display != "block"){
					for (var i=0; i<ar.length; i++){
						var options = "dynoptions" + div
						if (ar[i].className== options)
							ar[i].style.display = "none";
		    			el.style.display = "block";
					}
		    	}else{
		    			el.style.display = "none";
		    	}		    
		    }
		}
		   </script>';
		return $javascript;
	}

	/*
	Function : addCategory()
	Parameters:
		string $a_name - shortened name of category (you can use any name, withou spaces or special characters)
		string $name - name that will be displayed on menu
		string $image - image that will be displayed on menu
	Return:
		none
	Description: Add a category on menu
	*/
	function addMenu($a_name){
		$this->xpmenu[$a_name] = array();
	}
	function addCategory($a_name, $name, $image, $menu){
	
		$array = array("name" => $name, "image" => $image, "options" => "");
		$this->xpmenu[$menu]["categories"]["$a_name"] 	= $array;
	}

	/*
	Function : addOption()
	Parameters:
		string $a_name - shortened name of option (you can use any name, withou spaces or special characters)
		string $name - name that will be displayed on menu
		string $image - image that will be displayed on menu
		string $link - option link on menu
		string $category - category to include the option
	Return:
		none
	Description: Add an option in a category on menu
	*/

	function addOption($a_name, $name, $image, $link, $category, $menu){

		$array = array("name" => $name, "image" => $image, "link" => $link);
		$this->xpmenu[$menu]["categories"]["$category"]["options"]["$a_name"] = $array;
	}

	/*
	Function : mountMenu()
	Parameters: none
	Return:
		string $return - menu contents
	Description: Generate the menu contents
	*/

	function mountMenu($key_m, $key_expanded=null){

		$menu = $this->xpmenu[$key_m];

		$return = '<div id="mdiv'.$key_m.'">';
		while (list ($key) = @each ($menu["categories"])) {

			// menu item
			$return .= '<div class="dynmenu" onclick="SwitchMenu(\''.$key.'\',\''.$key_m.'\')"><img style="vertical-align: middle" width=20 height=20 src="'.$menu["categories"][$key]['image'].'" border=0 hspace=5 vspace=3>'.$menu["categories"][$key]['name'].'</div>';
			// submenu items
			$return .= '<span class="dynoptions'.$key_m.'" id="'.$key.'" style="display: none;">';

			while (list ($key_s) = @each ($menu['categories'][$key]['options'])) {
				if ($menu["categories"][$key]['options'][$key_s]['link'] == "")
					$return .= '<div class="dynoption2" onmouseout="this.style.background=\''.$this->submenu_onmouseout.'\'" border=0 hspace=3><img style="vertical-align: middle" width=16 height=16 src="'.$menu["categories"][$key]['options'][$key_s]['image'].'" border=0 hspace=5 vspace=3>'.$menu["categories"][$key]['options'][$key_s]['name'].'</div>';
				elseif ($menu["categories"][$key]['options'][$key_s]['link'] == "#")	
					$return .= '<div class="dynoption3" onmouseover="this.style.background=\''.$this->submenu_onmouseover.'\'" onmouseout="this.style.background=\''.$this->submenu_onmouseout.'\'"><a style="color:gray;" href="'.$menu["categories"][$key]['options'][$key_s]['link'].'"><img style="vertical-align: middle" width=16 height=16 src="'.$menu["categories"][$key]['options'][$key_s]['image'].'" border=0 hspace=3>'.$menu["categories"][$key]['options'][$key_s]['name'].'</a></div>';
				else	
				{
					$txt = str_replace("<u>", "", $menu["categories"][$key]['options'][$key_s]['name']);
					$txt = str_replace("</u>", "", $txt);
					if (strlen($txt) > 30)
						$title = 'title="'.$txt.'"';
					else
						$title = "";
					$return .= '<div class="dynoption" onmouseover="this.style.background=\''.$this->submenu_onmouseover.'\'" onmouseout="this.style.background=\''.$this->submenu_onmouseout.'\'"><a '.$title.' href="'.$menu["categories"][$key]['options'][$key_s]['link'].'"><img style="vertical-align: middle" width=16 height=16 src="'.$menu["categories"][$key]['options'][$key_s]['image'].'" border=0 hspace=3>'.$menu["categories"][$key]['options'][$key_s]['name'].'</a></div>';
				}	
			}
			$return .= '</span>';
		}
		if (!$this->menu_expanded && $key_expanded != null)
		{
			$return .= '<script language=\'javascript\'>
			SwitchMenu(\''.$key_expanded.'\',\''.$key_m.'\');</script>';
			$this->menu_expanded = true;
		}
		$return .= '</div>';
		return $return;

	}
	
}

?>