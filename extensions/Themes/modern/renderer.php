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
			global $path_to_root, $help_base_url, $power_by, $version, $db_connections;
			
			$sel_app = $_SESSION['sel_app'];
			echo "<div id='page'>\n";
			if (!$no_menu)
			{
				$applications = $_SESSION['App']->applications;
				$local_path_to_root = $path_to_root;
				$img = "<img src='$local_path_to_root/themes/modern/images/login.gif' width='14' height='14' border='0' alt='"._('Logout')."'>&nbsp;&nbsp;";
				$himg = "<img src='$local_path_to_root/themes/modern/images/help.gif' width='14' height='14' border='0' alt='"._('Help')."'>&nbsp;&nbsp;";
				echo "<div id='header'>\n";
				echo "<ul>\n";
				echo "  <li><a class='shortcut' href='$path_to_root/admin/display_prefs.php?'>" . _("Preferences") . "</a></li>\n";
				echo "  <li><a class='shortcut' href='$path_to_root/admin/change_current_user_password.php?selected_id=" . $_SESSION["wa_current_user"]->username . "'>" . _("Change password") . "</a></li>\n";
			 	if ($help_base_url != null)
					echo "  <li><a target = '_blank' onclick=" .'"'."javascript:openWindow(this.href,this.target); return false;".'" '. "href='". 
						help_url()."'>$himg" . _("Help") . "</a></li>";
				echo "  <li><a class='shortcut' href='$path_to_root/access/logout.php?'>$img" . _("Logout") . "</a></li>";
				echo "</ul>\n";
				$indicator = "$path_to_root/themes/".user_theme(). "/images/ajax-loader.gif";
				echo "<h1>$power_by $version<span style='padding-left:280px;'><img id='ajaxmark' src='$indicator' align='center' style='visibility:hidden;'></span></h1>\n";
				echo "</div>\n"; // header
				echo "<div class='clear'></div>\n";
				echo "<ul id='menu'>\n";
				foreach($applications as $app)
				{
					$acc = access_string($app->name);
					echo "<li ".($sel_app == $app->id ? "class='current' " : "") . "><a class='"
						.($sel_app == $app->id ? 'selected' : 'menu_tab')
						."' href='$local_path_to_root/index.php?application=" . $app->id
						. "'$acc[1]><b>" . $acc[0] . "</b></a></li>\n";
				}
				echo "</ul>\n"; // menu
				echo "<div class='clear'></div>\n";
				echo "<div id='menu2'>\n";
				echo "<ul>\n";
				switch ($sel_app) // shortcuts
				{
					case "orders":
						echo "<li><a class='shortcut' href='$local_path_to_root/sales/sales_order_entry.php?NewOrder=Yes'>"._("Sales Order")."</a></li>\n";
						echo "<li><a class='shortcut' href='$local_path_to_root/sales/sales_order_entry.php?NewInvoice=0'>"._("Direct Invoice")."</a></li>\n";
						echo "<li><a class='shortcut' href='$local_path_to_root/sales/customer_payments.php?'>"._("Payments")."</a></li>\n";
						echo "<li><a class='shortcut' href='$local_path_to_root/sales/inquiry/sales_orders_view.php?'>"._("Sales Order Inquiry")."</a></li>\n";
						echo "<li><a class='shortcut' href='$local_path_to_root/sales/inquiry/customer_inquiry.php?'>"._("Transactions")."</a></li>\n";
						echo "<li><a class='shortcut' href='$local_path_to_root/sales/manage/customers.php?'>"._("Customers")."</a></li>\n";
						echo "<li><a class='shortcut' href='$local_path_to_root/sales/manage/customer_branches.php?'>"._("Branch")."</a></li>\n";
						echo "<li><a class='shortcut' href='$local_path_to_root/reporting/reports_main.php?Class=0'>"._("Reports and Analysis")."</a></li>\n";
						break;
					case "AP":	
						echo "<li><a class='shortcut' href='$local_path_to_root/purchasing/po_entry_items.php?NewOrder=0'>"._("Purchase Order")."</a></li>\n";
						echo "<li><a class='shortcut' href='$local_path_to_root/purchasing/inquiry/po_search.php?'>"._("Receive")."</a></li>\n";
						echo "<li><a class='shortcut' href='$local_path_to_root/purchasing/supplier_invoice.php?New=1'>"._("Supplier Invoice")."</a></li>\n";
						echo "<li><a class='shortcut' href='$local_path_to_root/purchasing/supplier_payment.php?'>"._("Payments")."</a></li>\n";
						echo "<li><a class='shortcut' href='$local_path_to_root/purchasing/inquiry/supplier_inquiry.php?'>"._("Transactions")."</a></li>\n";
						echo "<li><a class='shortcut' href='$local_path_to_root/purchasing/manage/suppliers.php?'>"._("Suppliers")."</a></li>\n";
						echo "<li><a class='shortcut' href='$local_path_to_root/reporting/reports_main.php?Class=1'>"._("Reports and Analysis")."</a></li>\n";
						break;
					case "stock":	
						echo "<li><a class='shortcut' href='$local_path_to_root/inventory/adjustments.php?NewAdjustment=1'>"._("Inventory Adjustments")."</a></li>\n";
						echo "<li><a class='shortcut' href='$local_path_to_root/inventory/inquiry/stock_movements.php?'>"._("Inventory Item Movements")."</a></li>\n";
						echo "<li><a class='shortcut' href='$local_path_to_root/inventory/manage/items.php?'>"._("Items")."</a></li>\n";
						echo "<li><a class='shortcut' href='$local_path_to_root/inventory/prices.php?'>"._("Sales Pricing")."</a></li>\n";
						echo "<li><a class='shortcut' href='$local_path_to_root/reporting/reports_main.php?Class=2'>"._("Reports and Analysis")."</a></li>\n";
						break;
					case "manuf":	
						echo "<li><a class='shortcut' href='$local_path_to_root/manufacturing/work_order_entry.php?'>"._("Work Order Entry")."</a></li>\n";
						echo "<li><a class='shortcut' href='$local_path_to_root/manufacturing/search_work_orders.php?outstanding_only=1'>"._("Ourstanding Work Orders")."</a></li>\n";
						echo "<li><a class='shortcut' href='$local_path_to_root/manufacturing/search_work_orders.php?'>"._("Work Order Inquiry")."</a></li>\n";
						echo "<li><a class='shortcut' href='$local_path_to_root/manufacturing/manage/bom_edit.php?'>"._("Bills Of Material")."</a></li>\n";
						echo "<li><a class='shortcut' href='$local_path_to_root/reporting/reports_main.php?Class=3'>"._("Reports and Analysis")."</a></li>\n";
						break;
					case "proj":	
						echo "<li><a class='shortcut' href='$local_path_to_root/dimensions/dimension_entry.php?'>"._("Dimension Entry")."</a></li>\n";
						echo "<li><a class='shortcut' href='$local_path_to_root/dimensions/inquiry/search_dimensions.php?'>"._("Dimension Inquiry")."</a></li>\n";
						echo "<li><a class='shortcut' href='$local_path_to_root/reporting/reports_main.php?Class=4'>"._("Reports and Analysis")."</a></li>\n";
						break;
					case "GL":	
						echo "<li><a class='shortcut' href='$local_path_to_root/gl/gl_bank.php?NewPayment=Yes'>"._("Payments")."</a></li>\n";
						echo "<li><a class='shortcut' href='$local_path_to_root/gl/gl_bank.php?NewDeposit=Yes'>"._("Deposits")."</a></li>\n";
						echo "<li><a class='shortcut' href='$local_path_to_root/gl/gl_journal.php?NewJournal=Yes'>"._("Journal Entry")."</a></li>\n";
						echo "<li><a class='shortcut' href='$local_path_to_root/gl/inquiry/bank_inquiry.php?'>"._("Bank Account Inquiry")."</a></li>\n";
						echo "<li><a class='shortcut' href='$local_path_to_root/gl/inquiry/gl_account_inquiry.php?'>"._("GL Account Inquiry")."</a></li>\n";
						echo "<li><a class='shortcut' href='$local_path_to_root/gl/inquiry/gl_trial_balance.php?'>"._("Trial Balance")."</a></li>\n";
						echo "<li><a class='shortcut' href='$local_path_to_root/gl/manage/exchange_rates.php?'>"._("Exchange Rates")."</a></li>\n";
						echo "<li><a class='shortcut' href='$local_path_to_root/gl/manage/gl_accounts.php?'>"._("GL Accounts")."</a></li>\n";
						echo "<li><a class='shortcut' href='$local_path_to_root/reporting/reports_main.php?Class=6'>"._("Reports and Analysis")."</a></li>\n";
						break;
					case "system":	
						echo "<li><a class='shortcut' href='$local_path_to_root/admin/company_preferences.php?'>"._("Company Setup")."</a></li>\n";
						echo "<li><a class='shortcut' href='$local_path_to_root/admin/gl_setup.php?'>"._("General GL")."</a></li>\n";
						echo "<li><a class='shortcut' href='$local_path_to_root/taxes/tax_types.php?'>"._("Taxes")."</a></li>\n";
						echo "<li><a class='shortcut' href='$local_path_to_root/taxes/tax_groups.php?'>"._("Tax Groups")."</a></li>\n";
						echo "<li><a class='shortcut' href='$local_path_to_root/admin/forms_setup.php?'>"._("Forms Setup")."</a></li>\n";
						break;
				}		
				echo "</ul>\n";
				echo "</div>\n"; // menu2
				echo "<div class='clear'></div>\n";
			}
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
			global $path_to_root, $power_url, $power_by, $version, $db_connections;
			include_once($path_to_root . "/includes/date_functions.inc");

			if ($no_menu == false)
			{
				echo "<div id='footer'>\n";
				if (isset($_SESSION['wa_current_user']))
				{
					echo "<span class='power'><a target='_blank' href='$power_url'>$power_by $version</a></span>\n";
					echo "<span class='date'>".Today() . "&nbsp;" . Now()."</span>\n";
					echo "<span class='date'>" . $db_connections[$_SESSION["wa_current_user"]->company]["name"] . "</span>\n";
					echo "<span class='date'>" . $_SERVER['SERVER_NAME'] . "</span>\n";
					echo "<span class='date'>" . $_SESSION["wa_current_user"]->name . "</span>\n";
					echo "<span class='date'>" . _("Theme:") . " " . user_theme() . "</span>\n";
					echo "<span class='date'>" . show_users_online() . "</span>\n";
				}
				echo "</div>\n"; // footer
			}
			echo "</div>\n"; // page
		}

		function display_applications(&$waapp)
		{
			global $path_to_root;

			$sel_app = $waapp->get_selected_application();

			if (!$_SESSION["wa_current_user"]->check_application_access($sel_app))
				return;

			if (method_exists($sel_app, 'render_index'))
			{
				$sel_app->render_index();
				return;
			}

			foreach ($sel_app->modules as $module)
			{
				// image
				echo "<table width='95%' align='center'><tr>";
				echo "<td valign='top' class='menu_group'>";
				echo "<table border=0 width='100%'>";
				echo "<tr><td class='menu_group'>";
				echo $module->name;
				echo "</td></tr><tr>";
				echo "<td width='50%' class='menu_group_items'>";
				$img = "<img src='$path_to_root/themes/modern/images/folder.gif' width='14' height='14' border='0'>&nbsp;&nbsp;";
				if ($_SESSION["language"]->dir == "rtl")
					$class = "right";
				else
					$class = "left";
				foreach ($module->lappfunctions as $appfunction)
				{
					if ($appfunction->label == "")
						echo "<div class='empty'>&nbsp;<br></div>\n";
					elseif ($_SESSION["wa_current_user"]->can_access_page($appfunction->access))
						echo "<div>".$img.menu_link($appfunction->link, $appfunction->label."</div>");
					else	
						echo "<div>".$img."<span class='inactive'>".access_string($appfunction->label, true)."</span></div>\n";
				}
				echo "</td>\n";
				if (sizeof($module->rappfunctions) > 0)
				{
					echo "<td width='50%' class='menu_group_items'>";
					foreach ($module->rappfunctions as $appfunction)
					{
						if ($appfunction->label == "")
							echo "<div class='empty'>&nbsp;<br></div>\n";
						elseif ($_SESSION["wa_current_user"]->can_access_page($appfunction->access))
							echo "<div>".$img.menu_link($appfunction->link, $appfunction->label."</div>");
						else	
							echo "<div>".$img."<span class='inactive'>".access_string($appfunction->label, true)."</span></div>\n";
					}
					echo "</td>\n";
				}
				echo "</tr></table></td></tr></table>\n";
			}	
		}
	}

?>