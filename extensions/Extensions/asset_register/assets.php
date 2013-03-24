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
$page_security = 'SA_ASSETS';
$path_to_root = "../..";
include($path_to_root . "/includes/session.inc");
add_access_extensions();
set_ext_domain('modules/asset_register');

$js = "";
if ($use_date_picker)
	$js .= get_js_date_picker();
page(_($help_context = "Assets"), false, false, "", $js);

include_once($path_to_root . "/modules/asset_register/includes/modules_db.inc");
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/modules/asset_register/includes/ui.inc");

simple_page_mode(true);
//-----------------------------------------------------------------------------------

if ($Mode=='ADD_ITEM' || $Mode=='UPDATE_ITEM') 
{

	//initialise no input errors assumed initially before we test
	$input_error = 0;

	if (strlen($_POST['name']) == 0) 
	{
		$input_error = 1;
		display_error(_("The asset name cannot be empty."));
		set_focus('name');
	}
	if (strlen($_POST['purchase_value']) == 0) 
	{
		$input_error = 1;
		display_error(_("The purchase value cannot be empty."));
		set_focus('rate');
	}

	if ($input_error != 1) 
	{
    	if ($selected_id != -1) 
    	{
    		update_asset($selected_id, $_POST['type'], $_POST['name'], $_POST['serial'], $_POST['purchase_date'], input_num('purchase_value'), 
				$_POST['tag'], $_POST['location'], $_POST['condition'], $_POST['acquisition'], input_num('disposal_amount'), $_POST['disposal_date']);
			display_notification(_('Selected asset type has been updated'));
    	} 
    	else 
    	{
    		add_asset($_POST['type'], $_POST['name'], $_POST['serial'], $_POST['purchase_date'], input_num('purchase_value'),  $_POST['tag'], 
				$_POST['location'], $_POST['condition'], $_POST['acquisition']);
			display_notification(_('New Asset type has been added'));
    	}
    	
		$Mode = 'RESET';
	}
} 

//-----------------------------------------------------------------------------------

function can_delete($selected_id)
{
	if (asset_in_amortisation($selected_id))
	{
		display_error(_("Cannot delete this asset because amortisation transactions have been created referring to it."));
		return false;
	}
	
	return true;
}


//-----------------------------------------------------------------------------------

if ($Mode == 'Delete')
{
	if (can_delete($selected_id))
	{
		delete_asset($selected_id);
		display_notification(_('Selected asset has been deleted'));
	}
	$Mode = 'RESET';
}

if ($Mode == 'RESET')
{
	$selected_id = -1;
	$sav = get_post('show_inactive');
	unset($_POST);
	$_POST['show_inactive'] = $sav;
}
//-----------------------------------------------------------------------------------

$result = get_all_assets(check_value('show_inactive'));

start_form();
start_table(TABLESTYLE, "width=75%");

$th = array(_("Asset Type"),_("Asset Name"),_("Serial Number"), _("Purchase Date"),_("Purchase Value"), _("Current Value"), "", "", _("A"));
inactive_control_column($th);
table_header($th);
$k = 0;
while ($myrow = db_fetch($result)) 
{
	
	alt_table_row_color($k);	

	label_cell($myrow["asset_type_name"]);
	label_cell($myrow["asset_name"]);
	label_cell($myrow["asset_serial"]);
	label_cell(sql2date($myrow["purchase_date"]));
	amount_cell($myrow["purchase_value"]);
	amount_cell($myrow["current_value"]);

 	edit_button_cell("Edit".$myrow['asset_id'], _("Edit"));
	inactive_control_cell($myrow["asset_id"], $myrow["inactive"], 'assets', 'asset_id');
 	delete_button_cell("Delete".$myrow['asset_id'], _("Delete"));

	echo "<td><a href='amortisation.php?assetid=".$myrow['asset_id']."'>A</a></td>\n";


	end_row();
}
inactive_control_row($th);
end_table(1);

//-----------------------------------------------------------------------------------

start_table(TABLESTYLE2);

// $_POST['location'] = "";
// $_POST['condition'] = _("Good");
// $_POST['acquisition'] = _("Purchase");
if ($selected_id != -1) 
{
 	if ($Mode == 'Edit') {
		//editing an existing status code

		$myrow = get_asset($selected_id);

		$_POST['type']  = $myrow["asset_type_id"];
		$_POST['name']  = $myrow["asset_name"];
		$_POST['serial']  = $myrow["asset_serial"];
		$_POST['tag']  = $myrow["tag_number"];
		$_POST['purchase_date'] = sql2date($myrow["purchase_date"]);
		$_POST['purchase_value'] = number_format2($myrow["purchase_value"], 2);
		$_POST['location'] = $myrow["asset_location"];
		$_POST['condition'] = $myrow["asset_condition"];
		$_POST['acquisition'] = $myrow["asset_acquisition"];
		$_POST['disposal_amount'] = number_format2($myrow["disposal_amount"], 2);
		$_POST['disposal_date'] = sql2date($myrow["disposal_date"]);
	}
	hidden('selected_id', $selected_id);
}

asset_type_list_row(_("Asset Type :"), 'type', null, true);
text_row(_("Asset Name :"), 'name', null, 50, 50);
text_row(_("Serial Number :"), 'serial', null, 50, 50);
text_row(_("Tag Number :"), 'tag', null, 50, 50);
date_row(_("Purchase Date :"), 'purchase_date', '', null, 0, 0, 0, null, true);
amount_row(_("Purchase Value :"), 'purchase_value', null, null, null, 2);
text_row(_("Location :"), 'location', null, 50, 50);
text_row(_("Condition :"), 'condition', null, 50, 50);
text_row(_("Acquisition :"), 'acquisition', null, 50, 50);

echo "<tr><td colspan='2'><hr/></td></tr>";

amount_row(_("Disposal Amount :"), 'disposal_amount', null, null, null, 2);
date_row(_("Disposal Date :"), 'disposal_date', '', null, 0, 0, 0, null, true);

end_table(1);

submit_add_or_update_center($selected_id == -1, '', 'both');

end_form();

//------------------------------------------------------------------------------------

end_page();

?>
