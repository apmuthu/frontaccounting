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

		function menu_header($title, $no_menu, $is_index)
		{
			global $path_to_root, $help_base_url, $db_connections, $app_title, $version;

			$sel_app = $_SESSION['sel_app'];
			echo "<div id='content'>\n";
			if (!$no_menu)
			{
				$applications = $_SESSION['App']->applications;
				echo "<div id='top'>\n";
				echo "<p>" . $db_connections[$_SESSION["wa_current_user"]->company]["name"] . " | " . $_SERVER['SERVER_NAME'] . " | " . $_SESSION["wa_current_user"]->name . "</p>\n";
				echo "<ul>\n";
				echo "  <li><a class='shortcut' href='$path_to_root/admin/display_prefs.php?'>" . _("Preferences") . "</a></li>\n";
				echo "  <li><a class='shortcut' href='$path_to_root/admin/change_current_user_password.php?selected_id=" . $_SESSION["wa_current_user"]->username . "'>" . _("Change password") . "</a></li>\n";
			 	if ($help_base_url != null)
					echo "  <li><a target = '_blank' onclick=" .'"'."javascript:openWindow(this.href,this.target); return false;".'" '. "href='". help_url()."'>" . _("Help") . "</a></li>";
				echo "  <li><a class='shortcut' href='$path_to_root/access/logout.php?'>" . _("Logout") . "</a></li>";
				echo "</ul>\n";
				echo "</div>\n";
				echo "<div id='logo'>\n";
				$indicator = "$path_to_root/themes/".user_theme(). "/images/ajax-loader.gif";
				echo "<h1>$app_title $version<span style='padding-left:280px;'><img id='ajaxmark' src='$indicator' align='center' style='visibility:hidden;'></span></h1>\n";
				echo "<p id='slogan'>" . _("Theme:") . " " . user_theme() . "</p>\n";
				echo "</div>\n";
				$local_path_to_root = $path_to_root;

				echo "<ul id='_tabs'>\n";
				foreach($applications as $app)
				{
					$acc = access_string($app->name);
					echo "<li><a class='".($sel_app == $app->id ? 'selected' : 'menu_tab')
						."' href='$local_path_to_root/index.php?application=" . $app->id
							."'$acc[1]>" . $acc[0] . "</a></li>\n";
				}
				echo "</ul>\n";
			}
			echo "<div id='wrapper'>\n";
			if ($no_menu)
				echo "<br>";
			elseif ($title && !$is_index)
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
			global $path_to_root, $power_url, $power_by;
			include_once($path_to_root . "/includes/date_functions.inc");

			if ($no_menu == false)
			{
				echo "<div id='footer'>\n";
				if (isset($_SESSION['wa_current_user']))
				{
					echo "<span class='power'><a target='_blank' href='$power_url'>$power_by</a></span\n";
					echo "<span class='date'>".Today() . " | " . Now()."</span>\n";
					echo "<span class='date'>".show_users_online()."</span>\n";
				}
				echo "</div>\n";
			}
			echo "</div>\n";
			echo "</div>\n";
		}

		function display_applications(&$waapp)
		{

			$selected_app = $waapp->get_selected_application();

			if (!$_SESSION["wa_current_user"]->check_application_access($selected_app))
				return;

			if (method_exists($selected_app, 'render_index'))
			{
				$selected_app->render_index();
				return;
			}

			foreach ($selected_app->modules as $module)
			{
				// image
				echo "<table width='100%'><tr>";
				echo "<td valign='top' class='menu_group'>";
				echo "<table border=0 width='100%'>";
				echo "<tr><td class='menu_group'>";
				echo $module->name;
				echo "</td></tr><tr>";
				echo "<td width='50%' class='menu_group_items'>";
				echo "<ul>\n";
				if ($_SESSION["language"]->dir == "rtl")
					$class = "right";
				else
					$class = "left";
				foreach ($module->lappfunctions as $appfunction)
				{
					if ($appfunction->label == "")
						echo "<li class='empty'>&nbsp;</li>\n";
					elseif ($_SESSION["wa_current_user"]->can_access_page($appfunction->access))
						echo "<li>".menu_link($appfunction->link, $appfunction->label)."</li>";
					else	
						echo "<li><span class='inactive'>".access_string($appfunction->label, true)."</span></li>\n";
				}
				echo "</ul></td>\n";
				if (sizeof($module->rappfunctions) > 0)
				{
					echo "<td width='50%' class='menu_group_items'>";
					echo "<ul>\n";
					foreach ($module->rappfunctions as $appfunction)
					{
						if ($appfunction->label == "")
							echo "<li class='empty'>&nbsp;</li>\n";
						elseif ($_SESSION["wa_current_user"]->can_access_page($appfunction->access))
							echo "<li>".menu_link($appfunction->link, $appfunction->label)."</li>";
						else	
							echo "<li><span class='inactive'>".access_string($appfunction->label, true)."</span></li>\n";
					}
					echo "</ul></td>\n";
				}
				echo "</tr></table></td></tr></table>\n";
			}
		}
	}

?>