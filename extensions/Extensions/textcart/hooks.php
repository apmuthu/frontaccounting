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

class hooks_textcart extends hooks {
	var $module_name = 'textcart';

	function install_options($app) {
		$local = array(
			'inventory/adjustments.php',
			'inventory/transfers.php',
			'purchasing/po_entry_items.php',
			'sales/sales_order_entry.php'
		);
		// supersede some url's with provided by textcart extension
		foreach($app->modules as $id => $mod)
		{
			foreach($mod->lappfunctions as $fun=>$option)
				if (in_array(strtok($option->link,'?'), $local))
					$app->modules[$id]->lappfunctions[$fun]->link =
						'modules/textcart/'.$app->modules[$id]->lappfunctions[$fun]->link;
			foreach($mod->rappfunctions as $fun=>$option)
				if (in_array(strtok($option->link,'?'), $local))
					$app->modules[$id]->rappfunctions[$fun]->link =
						'modules/textcart/'.$app->modules[$id]->rappfunctions[$fun]->link;

		}
	}
}
?>