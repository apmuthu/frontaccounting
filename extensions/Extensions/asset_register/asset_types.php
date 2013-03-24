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
$page_security = 'SA_ASSETTYPE';
$path_to_root = "../..";
include($path_to_root . "/includes/session.inc");
add_access_extensions();
set_ext_domain('modules/asset_register');

page(_($help_context = "Asset Types"));

include_once($path_to_root . "/modules/asset_register/includes/modules_db.inc");
include_once($path_to_root . "/includes/ui.inc");

simple_page_mode(true);
//-----------------------------------------------------------------------------------

if ($Mode=='ADD_ITEM' || $Mode=='UPDATE_ITEM') 
{

	//initialise no input errors assumed initially before we test
	$input_error = 0;

	if (strlen($_POST['name']) == 0) 
	{
		$input_error = 1;
		display_error(_("The asset type name cannot be empty."));
		set_focus('name');
	}
	if (strlen($_POST['rate']) == 0) 
	{
		$input_error = 1;
		display_error(_("The depreciation rate cannot be empty."));
		set_focus('rate');
	}

	if ($input_error != 1) 
	{
    	if ($selected_id != -1) 
    	{
    		update_asset_type($selected_id, $_POST['name'], $_POST['rate'], $_POST['asset_account'], $_POST['depreciation_account'], 
				$_POST['accumulated_account'], $_POST['valuation_account'], $_POST['disposal_account']);
			display_notification(_('Selected asset type has been updated'));


    	} 
    	else 
    	{
    		add_asset_type($_POST['name'], $_POST['rate'], $_POST['asset_account'], $_POST['depreciation_account'], $_POST['accumulated_account'], 
				$_POST['valuation_account'], $_POST['disposal_account']);
			display_notification(_('New Asset type has been added'));
    	}
    	
		$Mode = 'RESET';
	}
} 

//-----------------------------------------------------------------------------------

function can_delete($selected_id)
{
	if (asset_types_in_assets($selected_id))
	{
		display_error(_("Cannot delete this asset type because assets transactions have been created referring to it."));
		return false;
	}
	
	return true;
}


//-----------------------------------------------------------------------------------

if ($Mode == 'Delete')
{
	if (can_delete($selected_id))
	{
		delete_asset_type($selected_id);
		display_notification(_('Selected asset type has been deleted'));
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

$result = get_all_asset_types(check_value('show_inactive'));

start_form();
start_table(TABLESTYLE, "width=30%");

$th = array(_("Asset Type Name"),_("Depreciation Rate"), "", "");
inactive_control_column($th);
table_header($th);
$k = 0;
while ($myrow = db_fetch($result)) 
{
	alt_table_row_color($k);	

	label_cell($myrow["asset_type_name"]);
	label_cell($myrow["depreciation_rate"]);
	inactive_control_cell($myrow["asset_type_id"], $myrow["inactive"], 'asset_types', 'asset_type_id');
 	edit_button_cell("Edit".$myrow['asset_type_id'], _("Edit"));
 	delete_button_cell("Delete".$myrow['asset_type_id'], _("Delete"));
	end_row();
}
inactive_control_row($th);
end_table(1);

//-----------------------------------------------------------------------------------

start_table(TABLESTYLE2);

if ($selected_id != -1) 
{
 	if ($Mode == 'Edit') {
		//editing an existing status code

		$myrow = get_asset_type($selected_id);

		$_POST['name']  = $myrow["asset_type_name"];
		$_POST['rate']  = $myrow["depreciation_rate"];

		$_POST['asset_account']  = $myrow["asset_account"];
		$_POST['depreciation_account']  = $myrow["depreciation_account"];
		$_POST['accumulated_account']  = $myrow["accumulated_account"];
		$_POST['valuation_account']  = $myrow["valuation_account"];
		$_POST['disposal_account']  = $myrow["disposal_account"];
	}
	hidden('selected_id', $selected_id);
} 

text_row(_("Asset Type:"), 'name', null, 50, 50);
percent_row(_("Depreciation Rate:"), 'rate', null, 50, 50);

gl_all_accounts_list_row(_("Asset Account:"), 'asset_account');
gl_all_accounts_list_row(_("Depreciation Account:"), 'depreciation_account');
gl_all_accounts_list_row(_("Accumulated Depreciation:"), 'accumulated_account');
gl_all_accounts_list_row(_("Asset Revaluation Account:"), 'valuation_account');
gl_all_accounts_list_row(_("Disposal Account:"), 'disposal_account');

end_table(1);

submit_add_or_update_center($selected_id == -1, '', 'both');

end_form();

//------------------------------------------------------------------------------------

end_page();

?>
