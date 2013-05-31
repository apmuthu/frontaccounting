<?php
/**********************************************************************
    Copyright (C) FrontAccounting, LLC.
	Released under the terms of the GNU General Public License, GPL, 
	as published by the Free Software Foundation, either version 3 
	of the License, or (at your option) any later version.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
    See the License here <http://www.gnu.org/licenses/gpl-3.0.html>.
***********************************************************************/
// Author: Joe Hunt, 09/13/2010


include_once('xpMenu.class.php');

	class renderer
	{
		function wa_header()
		{
			page(_($help_context = "Main Menu"), false, true);
		}

		function wa_footer()
		{
			end_page(false, true);
		}
		function shortcut($url, $label) 
		{
			echo "<li>";
			echo menu_link($url, $label);
			echo "</li>";
		}
		function menu_header($title, $no_menu, $is_index)
		{
			global $path_to_root, $help_base_url, $power_by, $version, $db_connections, $installed_extensions;
            if (!$no_menu) {
                echo "<script type='text/javascript' src='$path_to_root/themes/dashboard/js/jquery-1.3.2.js'></script>\n";
                echo "<script type='text/javascript' src='$path_to_root/themes/dashboard/js/jquery-ui-1.7.2.custom.min.js'></script>\n";
                echo "<script type='text/javascript' src='$path_to_root/themes/dashboard/js/jquery.json-2.2.min.js'></script>\n";
                echo "<script type='text/javascript' src='$path_to_root/themes/dashboard/js/dashboard.js'></script>\n";
                echo "<script type='text/javascript' src='https://www.google.com/jsapi'></script>\n";
            }

			$sel_app = $_SESSION['sel_app'];
			echo "<div class='fa-main'>\n";
			if (!$no_menu)
			{
				$applications = $_SESSION['App']->applications;
				$local_path_to_root = $path_to_root;
				$img = "<img src='$local_path_to_root/themes/exclusive_db/images/login.gif' width='14' height='14' border='0' alt='"._('Logout')."'>&nbsp;&nbsp;";
				$himg = "<img src='$local_path_to_root/themes/exclusive_db/images/help.gif' width='14' height='14' border='0' alt='"._('Help')."'>&nbsp;&nbsp;";
				echo "<div id='header'>\n";
				echo "<ul>\n";
				echo "  <li><a href='$path_to_root/admin/display_prefs.php?'>" . _("Preferences") . "</a></li>\n";
				echo "  <li><a href='$path_to_root/admin/change_current_user_password.php?selected_id=" . $_SESSION["wa_current_user"]->username . "'>" . _("Change password") . "</a></li>\n";
			 	if ($help_base_url != null)
					echo "  <li><a target = '_blank' onclick=" .'"'."javascript:openWindow(this.href,this.target); return false;".'" '. "href='". 
						help_url()."'>$himg" . _("Help") . "</a></li>";
				echo "  <li><a href='$path_to_root/access/logout.php?'>$img" . _("Logout") . "</a></li>";
				echo "</ul>\n";
				$indicator = "$path_to_root/themes/".user_theme(). "/images/ajax-loader.gif";
				echo "<h1>$power_by $version<span style='padding-left:300px;'><img id='ajaxmark' src='$indicator' align='center' style='visibility:hidden;'></span></h1>\n";
				echo "</div>\n"; // header
				echo "<div class='fa-menu'>";
				echo "<ul>\n";
				foreach($applications as $app)
				{
					if ($sel_app == $app->id)
						$sel_application = $app;
					$acc = access_string($app->name);
					echo "<li ".($sel_app == $app->id ? "class='active' " : "") . "><a href='$local_path_to_root/index.php?application=" . $app->id
						."'$acc[1]><b>" . $acc[0] . "</b></a></li>\n";
				}
				echo "</ul>\n"; 
				echo "</div>\n"; // menu
				echo "<div class='clear'></div>\n";
			}				
			echo "<div class='fa-body'>\n";
			if (!$no_menu)
			{		
				add_access_extensions();
				echo "<div class='fa-side'>\n";
				echo "<div class='fa-submenu'>\n";
				$app = $sel_application;
				$xpmenu = new xpMenu();
				$xpmenu->addMenu($sel_app);
				$acc = access_string($app->name);
				$imgs = array('orders'=>'invoice.gif', 'AP'=>'receive.gif', 'stock'=>'basket.png',
				 	'manuf'=>'cog.png', 'proj'=>'time.png', 'GL'=>'gl.png', 'system'=>'controller.png');
				if (!isset($imgs[$app->id]))
					$imgs[$app->id] = "controller.png";
				$xpmenu->addCategory($app->id, $acc[0], "$local_path_to_root/themes/exclusive_db/images/".$imgs[$app->id], $app->id);
				$i = $j = 0;
				if ($sel_app == "system")
					$imgs2 = array("page_edit.png", "page_edit.png", "page_edit.png", "page_edit.png", "folder.gif");
				else	
					$imgs2 = array("folder.gif", "report.png", "page_edit.png", "money.png", "folder.gif");
				foreach ($app->modules as $module)
				{
					$xpmenu->addOption($i++, $module->name, "$local_path_to_root/themes/exclusive_db/images/transparent.gif", "", $app->id, $sel_app);
					$apps = array();
					foreach ($module->lappfunctions as $appfunction)
						$apps[] = $appfunction;
					foreach ($module->rappfunctions as $appfunction)
						$apps[] = $appfunction;
					$application = array();	
					foreach ($apps as $application)	
					{
						$lnk = access_string($application->label);
						if ($_SESSION["wa_current_user"]->can_access_page($application->access))
						{
							if ($application->label != "")
							{
								$xpmenu->addOption($i++, $lnk[0], "$local_path_to_root/themes/exclusive_db/images/".$imgs2[$j], "$path_to_root/$application->link", $app->id, $sel_app);
							}
						}
						else	
							$xpmenu->addOption($i++, $lnk[0], "$local_path_to_root/themes/exclusive_db/images/".$imgs2[$j], "#", $app->id, $sel_app);
					}
					$j++;	
				}
				$txt = $xpmenu->javaScript();
				$txt .= $xpmenu->javaScript();
				$txt .= $xpmenu->style();
				$txt .= $xpmenu->mountMenu($sel_app, $sel_app);
				echo $txt;
				echo "</div>\n"; // submenu
				echo "<div class='clear'></div>\n";
				echo "</div>\n"; // fa-side
				echo "<div class='fa-content'>\n";
			}
			if ($no_menu)
				echo "<br>";
			elseif ($title && !$no_menu && !$is_index)
			{
				echo "<center><table id='title'><tr><td width='100%' class='titletext'>$title</td>"
				."<td align=right>"
				.(user_hints() ? "<span id='hints'></span>" : '')
				."</td>"
				."</tr></table></center>";
			}
		}

		function menu_footer($no_menu, $is_index)
		{
			global $path_to_root, $power_url, $power_by, $version, $db_connections;
			include_once($path_to_root . "/includes/date_functions.inc");

			if (!$no_menu)
				echo "</div>\n"; // fa-content
			echo "</div>\n"; // fa-body
			if (!$no_menu)
			{
				echo "<div class='fa-footer'>\n";
				if (isset($_SESSION['wa_current_user']))
				{
					echo "<span class='power'><a target='_blank' href='$power_url'>$power_by $version</a></span>\n";
					echo "<span class='date'>".Today() . "&nbsp;" . Now()."</span>\n";
					echo "<span class='date'>" . $db_connections[$_SESSION["wa_current_user"]->company]["name"] . "</span>\n";
					echo "<span class='date'>" . $_SERVER['SERVER_NAME'] . "</span>\n";
					echo "<span class='date'>" . $_SESSION["wa_current_user"]->name . "</span>\n";
					echo "<span class='date'>" . _("Theme:") . " " . user_theme() . "</span>\n";
					echo "<span class='date'>".show_users_online()."</span>\n";
				}
				echo "</div>\n"; // footer
			}
			echo "</div>\n"; // fa-main
		}

		// Display dashboard 
		function display_applications(&$waapp)
		{
            global $path_to_root, $use_popup_windows;
            include_once("$path_to_root/includes/ui.inc");
            include_once($path_to_root . "/reporting/includes/class.graphic.inc");

			$selected_app = $waapp->get_selected_application();
			if (!$_SESSION["wa_current_user"]->check_application_access($selected_app))
				return;

            // first have a look through the directory,
            // and remove old temporary pdfs and pngs
            $dir = company_path(). '/pdf_files';

            if ($d = @opendir($dir)) {
                while (($file = readdir($d)) !== false) {
                    if (!is_file($dir.'/'.$file) || $file == 'index.php') continue;
                // then check to see if this one is too old
                    $ftime = filemtime($dir.'/'.$file);
                 // seems 3 min is enough for any report download, isn't it?
                    if (time()-$ftime > 180){
                        unlink($dir.'/'.$file);
                    }
                }
                closedir($d);
            }

            //if ($selected_app->id == 'system') {
            //    include($path_to_root . "/includes/system_tests.inc");
            //    $title = "Display System Diagnostics";
            //    br(2);
            //    display_heading($title);
            //    br();
            //    display_system_tests();
            //    return;
            //}

            $dashboard_app = $waapp->get_application("Dashboard");
            echo '<div id="console" ></div>';

            $userid = $_SESSION["wa_current_user"]->user;
            $sql = "SELECT DISTINCT column_id FROM ".TB_PREF."dashboard_widgets"
                    ." WHERE user_id =".db_escape($userid)
                    ." AND app=".db_escape($selected_app->id)
                    ." ORDER BY column_id";
            $columns=db_query($sql);
	    $max_column_id = 6;
	    // This could be done in only one SQl query, but I want to modidy
	    // the code as less as I could.
	    while($column=db_fetch($columns)) {
		    $max_column_id = max($max_column_id, $column['column_id']);
	    }
		$column=-1;
	    while(++$column<$max_column_id)
              {
                  echo '<div class="column" id="column'.$column.'" >';
                  $sql = "SELECT * FROM ".TB_PREF."dashboard_widgets"
                        ." WHERE column_id=".db_escape($column)
                        ." AND user_id = ".db_escape($userid)
                        ." AND app=".db_escape($selected_app->id)
                        ." ORDER BY sort_no";
                  $items=db_query($sql);
                  while($item=db_fetch($items))
                  {
                      $widgetData = $dashboard_app->get_widget($item['widget']);
                      echo '
                      <div class="dragbox" id="item'.$item['id'].'">
                          <h2>'.$item['description'].'</h2>
                              <div id="widget_div_'.$item['id'].'" class="dragbox-content" ';
                      if($item['collapsed']==1)
                          echo 'style="display:none;" ';
                      echo '>';
                      if ($widgetData != null) {
                          if ($_SESSION["wa_current_user"]->can_access_page($widgetData->access))
                          {
                              include_once ($path_to_root . $widgetData->path);
                              $className = $widgetData->name;
                              $widgetObject = new $className($item['param']);
                              $widgetObject->render($item['id'],$item['description']);
                          } else {
                              echo "<center><br><br><br><b>";
                              echo _("The security settings on your account do not permit you to access this function");
                              echo "</b>";
                              echo "<br><br><br><br></center>";
                          }
                      }
                      echo '</div></div>';
                  }
                  echo '</div>';
              }
        }
	}
?>
