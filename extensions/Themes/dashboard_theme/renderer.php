<?php
/**********************************************************************
// Creator: Alastair Robertson
// date_:   2013-01-30
// Title:   Dashboard theme renderer
// Free software under GNU GPL
***********************************************************************/
	class renderer
	{
		function get_icon($category)
		{
			global  $path_to_root, $show_menu_category_icons;

			if ($show_menu_category_icons)
				$img = $category == '' ? 'right.gif' : $category.'.png';
			else
				$img = 'right.gif';
			return "<img src='$path_to_root/themes/dashboard/images/$img' style='vertical-align:middle;' border='0'>&nbsp;&nbsp;";
		}

		function wa_header()
		{

		  page(_($help_context = "Main Menu"), false, true);
		}

		function wa_footer()
		{
			end_page(false, true);
		}

		function menu_header($title, $no_menu, $is_index)
		{
			global $path_to_root, $help_base_url, $db_connections;
            if (!$no_menu) {
                echo "<script type='text/javascript' src='$path_to_root/themes/dashboard/js/jquery-1.3.2.js'></script>\n";
                echo "<script type='text/javascript' src='$path_to_root/themes/dashboard/js/jquery-ui-1.7.2.custom.min.js'></script>\n";
                echo "<script type='text/javascript' src='$path_to_root/themes/dashboard/js/jquery.json-2.2.min.js'></script>\n";
                echo "<script type='text/javascript' src='$path_to_root/themes/dashboard/js/dashboard.js'></script>\n";
                echo "<script type='text/javascript' src='https://www.google.com/jsapi'></script>\n";
            }

            add_access_extensions();

            echo "<table class='callout_main' border='0' cellpadding='0' cellspacing='0'>\n";
			echo "<tr>\n";
			echo "<td colspan='2' rowspan='2'>\n";

			echo "<table class='main_page' border='0' cellpadding='0' cellspacing='0'>\n";
			echo "<tr>\n";
			echo "<td>\n";
			echo "<table width='100%' border='0' cellpadding='0' cellspacing='0'>\n";
			echo "<tr>\n";
			echo "<td class='quick_menu'>\n";
			if (!$no_menu)
			{
				$applications = $_SESSION['App']->applications;
				$local_path_to_root = $path_to_root;
				$img = "<img src='$local_path_to_root/themes/dashboard/images/login.gif' width='14' height='14' border='0' alt='"._('Logout')."'>&nbsp;&nbsp;";
				$himg = "<img src='$local_path_to_root/themes/dashboard/images/help.gif' width='14' height='14' border='0' alt='"._('Help')."'>&nbsp;&nbsp;";
				$sel_app = $_SESSION['sel_app'];
				echo "<table cellpadding=0 cellspacing=0 width='100%'><tr><td>";
				echo "<div class=tabs>";
				foreach($applications as $app)
				{
                    if ($_SESSION["wa_current_user"]->check_application_access($app))
                    {
                            if ($sel_app == $app->id)
                                $sel_application = $app;
                            $acc = access_string($app->name);
    						echo "<a class='".($sel_app == $app->id ? 'selected' : 'menu_tab')
    							."' href='$local_path_to_root/index.php?application=".$app->id
    							."'$acc[1]>" .$acc[0] . "</a>";
    				}
				}
				echo "</div>";

				echo "</td></tr></table>";

				echo "<table class=logoutBar>";
				echo "<tr><td class=headingtext3>" . $db_connections[$_SESSION["wa_current_user"]->company]["name"] . " | " . $_SERVER['SERVER_NAME'] . " | " . $_SESSION["wa_current_user"]->name . "</td>";
				$indicator = "$path_to_root/themes/".user_theme(). "/images/ajax-loader.gif";
				echo "<td class='logoutBarRight'><img id='ajaxmark' src='$indicator' align='center' style='visibility:hidden;'></td>";
				echo "  <td class='logoutBarRight'><a class='shortcut' href='$path_to_root/admin/display_prefs.php?'>" . _("Preferences") . "</a>&nbsp;&nbsp;&nbsp;\n";
				echo "  <a class='shortcut' href='$path_to_root/admin/change_current_user_password.php?selected_id=" . $_SESSION["wa_current_user"]->username . "'>" . _("Change password") . "</a>&nbsp;&nbsp;&nbsp;\n";

				if ($help_base_url != null)
				{
					echo "$himg<a target = '_blank' onclick=" .'"'."javascript:openWindow(this.href,this.target); return false;".'" '. "href='". help_url()."'>" . _("Help") . "</a>&nbsp;&nbsp;&nbsp;";
				}
				echo "$img<a class='shortcut' href='$local_path_to_root/access/logout.php?'>" . _("Logout") . "</a>&nbsp;&nbsp;&nbsp;";
				echo "</td></tr></table>";

				echo "</td></tr></table>";
                echo "</td></tr><tr><td>\n";
                //echo "<script language='javascript'>\$(document).ready(function(){\$('#fa-submenu').hoverAccordion({activateItem:1,speed:'fast'});});</script>";
                echo "<script language='javascript'>"
."\$(document).ready(function()\n"
."{\n"
    ."\$('#fa-submenu p.menu_head').click(function()\n"
    ."{\n"
        ."\$(this).css({backgroundImage:'none'}).next('div.menu_body').slideDown(300).siblings('div.menu_body').slideUp('slow');\n"
        ."\$(this).siblings().css({backgroundImage:'url($local_path_to_root/themes/dashboard/images/collapse2.png)'});\n"
    ."});\n"
    ."\$('#first').css({backgroundImage:'none'}).next('div.menu_body').slideDown('fast').siblings('div.menu_body').slideUp('fast');"
."});\n</script>";
                echo "<table width='100%'><tr><td valign='top' width='15%'>";
                echo "<div style='display:block;'>\n";
                echo "<div id='fa-submenu' class='menu_list'>\n";
                $first = "id='first'";
                foreach ($sel_application->modules as $module)
                {
                    echo "<p ".$first." class='menu_head'>".$module->name."</p>\n";
                    echo "<div class='menu_body'>\n";
                    $first = "";
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
                                echo "<a href='".$path_to_root."/".$application->link."'>".$lnk[0]."</a>";
                            }
                        }
                    elseif (!$_SESSION["wa_current_user"]->hide_inaccessible_menu_items())
                        echo "<a href='#' class='disabled'>".$lnk[0]."</a>";
                    }
                    echo "</div>";
                }
                echo "</div>"; // submenu
                echo "</div >\n";
                echo "</td><td valign='top'>";
            }

			if ($no_menu) {
                echo "</td></tr></table>";
                echo "<br>";
			}
			elseif ($title && !$is_index)
			{
			    // here starts form
			    echo "<div class='dataform'>";
                echo "<center><table id='title'><tr><td width='100%' class='titletext'>$title</td>"
                ."<td align=right>"
                .(user_hints() ? "<span id='hints'></span>" : '')
                ."</td>"
                ."</tr></table></center>";
			}

		}



		function menu_footer($no_menu, $is_index)
		{
			global $version, $allow_demo_mode, $app_title, $power_url,
				$power_by, $path_to_root, $Pagehelp, $Ajax;
			include_once($path_to_root . "/includes/date_functions.inc");
            echo "</div>"; // column
			echo "</td></tr><tr><td colspan='2'>";

			if ($no_menu == false)
			{
				if ($is_index)
					echo "<table class=bottomBar>\n";
				else
					echo "<table class=bottomBar2>\n";
				echo "<tr>";
				if (isset($_SESSION['wa_current_user'])) {
					$phelp = implode('; ', $Pagehelp);
					echo "<td class=bottomBarCell>" . Today() . " | " . Now() . "</td>\n";
					$Ajax->addUpdate(true, 'hotkeyshelp', $phelp);
					echo "<td id='hotkeyshelp'>".$phelp."</td>";
				}
				echo "</tr></table>\n";
			}
			echo "</td></tr></table></td>\n";
			echo "</table>\n";
			if ($no_menu == false)
			{
				echo "<table align='center' id='footer'>\n";
				echo "<tr>\n";
				echo "<td align='center' class='footer'><a target='_blank' href='$power_url'><font color='#ffffff'>$app_title $version - " . _("Theme:") . " " . user_theme() ." - ".show_users_online(). "</font></a></td>\n";
				echo "</tr>\n";
				echo "<tr>\n";
				echo "<td align='center' class='footer'><a target='_blank' href='$power_url'><font color='#ffff00'>$power_by</font></a></td>\n";
				echo "</tr>\n";
				if ($allow_demo_mode==true)
				{
					echo "<tr>\n";
					echo "</tr>\n";
				}
				echo "</table><br><br>\n";
			}
		}

		function display_applications(&$waapp)
		{
            global $path_to_root, $use_popup_windows;
            include_once("$path_to_root/includes/ui.inc");
            include_once($path_to_root . "/reporting/includes/class.graphic.inc");

			$selected_app = $waapp->get_selected_application();
			if (!$_SESSION["wa_current_user"]->check_application_access($selected_app))
				return;

			if (method_exists($selected_app, 'render_index'))
			{
				$selected_app->render_index();
				return;
			}
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

            while($column=db_fetch($columns))
              {
                  echo '<div class="column" id="column'.$column['column_id'].'" >';
                  $sql = "SELECT * FROM ".TB_PREF."dashboard_widgets"
                        ." WHERE column_id=".db_escape($column['column_id'])
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