<?php
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
			global $path_to_root, $help_base_url, $db_connections;
			$local_path_to_root = $path_to_root;
			global $leftmenu_save, $app_title, $version;

			// Build screen header
			$leftmenu_save = "";
			$sel_app = $_SESSION['sel_app'];
			echo "<div id='maincontainer'> \n";

			echo "<div id='topsection'> \n";
			echo "  <div class='innertube'> \n";
			echo "    <h1>" . $app_title . " " . $version . "</h1>\n";
			echo "  </div>\n";
			echo "  <div id='topinfo'>" . $db_connections[$_SESSION["wa_current_user"]->company]["name"] . " | " . $_SERVER['SERVER_NAME'] . " | ".show_users_online()."</div>\n";
			echo "  <div id='iconlink'>";
	   		// Logout on main window only
	   		if (!$no_menu) {
        		echo "    <a class='shortcut' href='$local_path_to_root/access/logout.php?'><img src='$local_path_to_root/themes/grayred/images/system-shutdown.png' title='"._("Logout")."' /></a>";
     		}
  			// Popup help
     		if ($help_base_url != null) {
			  echo "<a target = '_blank' onclick=" .'"'."javascript:openWindow(this.href,this.target); return false;".'" '. "href='". help_url()."'><img src='$local_path_to_root/themes/grayred/images/help-browser.png' title='"._("Help")."' /></a>\n";
	   		}
     		echo "  </div>\n"; // iconlink
     		echo "  </div>\n";

     		if (!$no_menu)
     		{
                        $applications = $_SESSION['App']->applications;
                        $leftmenu_save .= "<div id='leftcolumn'>\n";
                        $leftmenu_save .= "  <div id='ddblueblockmenu'>\n";

                        $leftmenu_save .= "    <div class='menutitle'>Applications</div>\n";
                        $leftmenu_save .= "    <ul>\n";

                        foreach($applications as $app)
                        {
                            $acc = access_string($app->name);
                            $leftmenu_save .= "      <li>\n";
                            $leftmenu_save .= "        <a class='"
                            	.($sel_app == $app->id ? 'selected' : 'menu_tab')
								."' href='$local_path_to_root/index.php?application=".$app->id.
                            SID ."'$acc[1]>" .$acc[0] . "</a>\n";
                            if ($sel_app == $app->id)
                            {
                                $curr_app_name = $acc[0];
                                $curr_app_link = $app->id;
                            }
                            $leftmenu_save .= "      </li>\n";
                        }
                        $leftmenu_save .= "    </ul>\n";
                        

                        $leftmenu_save .= "    <div class='menutitle'>" . $_SESSION["wa_current_user"]->name . "</div>\n";
                        $leftmenu_save .= "    <ul>\n";
                        $leftmenu_save .= "      <li><a class='shortcut' href='$local_path_to_root/admin/display_prefs.php?'>"._("Preferences")."</a></li>\n";
                        $leftmenu_save .= "      <li><a class='shortcut' href='$local_path_to_root/admin/change_current_user_password.php?selected_id=".$_SESSION["wa_current_user"]->username."'>"._("Change password")."</a></li>\n";
                        $leftmenu_save .= "      <li><a class='shortcut' href='$local_path_to_root/access/logout.php?'>"._("Logout")."</a></li>\n";
                        $leftmenu_save .= "    </ul>\n";

                        $leftmenu_save .= "  </div>\n";
                        $leftmenu_save .= "</div>\n";
                }



			echo "\n<div id='contentwrapper'>\n";
			if ($title && !$no_menu) {
				echo "  <div id='contentcolumn'>\n";
				echo "    <div class='innertube'>\n";
				echo (user_hints() ? "<span id='hints' style='float:right;'></span>" : "");
				echo "      <p class='breadcrumb'>\n";
				echo "        <a class='shortcut' href='$local_path_to_root/index.php?application=".$curr_app_link. SID ."'>" . $curr_app_name . "</a>\n";
				if ($no_menu)
					echo "<br>";
				elseif ($title && !$is_index)
					echo "        <a href='#'>" . $title . "</a>\n";
				$indicator = "$path_to_root/themes/".user_theme(). "/images/ajax-loader.gif";
				echo "        <span style='padding-left:200px;'><img id='ajaxmark' src='$indicator' align='center' style='visibility:hidden;'></span>";
				echo "      </p>\n";
     		}
		}

		function menu_footer($no_menu, $is_index)
		{
			global $leftmenu_save;

			if (!$no_menu)
			{
				echo "    </div>\n";
				echo "  </div>\n";
			}
			echo "</div>\n";
			echo "</div>\n";
			if (!$no_menu)
				echo $leftmenu_save;
/*
				if (isset($_SESSION['wa_current_user']))
					echo "<td class=bottomBarCell>" . Today() . " | " . Now() . "</td>\n";
				echo "<td align='center' class='footer'><a target='_blank' href='$power_url'><font color='#ffffff'>$app_title $version - " . _("Theme:") . " " . user_theme() . "</font></a></td>\n";
				echo "<td align='center' class='footer'><a target='_blank' href='$power_url'><font color='#ffff00'>$power_by</font></a></td>\n";
*/
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
				echo "      <div class='shiftcontainer'>\n";
				echo "        <div class='shadowcontainer'>\n";
				echo "          <div class='innerdiv'>\n";
				echo "            <b>" . str_replace(' ','&nbsp;',$module->name) . "</b><br />\n";
				echo "            <div class='buttonwrapper'>\n";

				foreach ($module->lappfunctions as $appfunction)
				{
					$this->renderButtonsForAppFunctions($appfunction);
				}

				foreach ($module->rappfunctions as $appfunction)
				{
					$this->renderButtonsForAppFunctions($appfunction);
				}

				echo "            </div>\n";
				echo "          </div>\n";
				echo "        </div>\n";
				echo "      </div>\n";
				echo "      <br />\n";
			}
		}

		function renderButtonsForAppFunctions($appfunction)
		{
			if ($_SESSION["wa_current_user"]->can_access_page($appfunction->access))
			{
				if ($appfunction->label != "")
				{
					$lnk = access_string($appfunction->label);
					echo "              <a class='boldbuttons' href='$appfunction->link'$lnk[1]><span>" . str_replace(' ','&nbsp;',$lnk[0]) . "</span></a>\n";
				}
			}
			else	
				echo "<a class='boldbuttons'  href='#' title='"._("Inactive")."' alt='"._("Inactive")."'><span style='color:#cccccc;'>".access_string($appfunction->label, true)."</span></a>\n";
		}
	}

?>