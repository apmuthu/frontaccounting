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

page(_($help_context = "Amortisation Schedule"));

include_once($path_to_root . "/modules/asset_register/includes/modules_db.inc");
include_once($path_to_root . "/includes/ui.inc");

simple_page_mode(true);
//-----------------------------------------------------------------------------------
if(isset($_GET['assetid'])) {
	$_POST['assetid'] = $_GET['assetid'];
}

if ($Mode=='ADD_ITEM' || $Mode=='UPDATE_ITEM') 
{

	//initialise no input errors assumed initially before we test
	$input_error = 0;

	if (strlen($_POST['valuationyear']) == 0) 
	{
		$input_error = 1;
		display_error(_("The valuation year cannot be empty."));
		set_focus('valuationyear');
	}
	if (strlen($_POST['assetvalue']) == 0) 
	{
		$input_error = 1;
		display_error(_("The asset value cannot be empty."));
		set_focus('assetvalue');
	}

	if ($input_error != 1) 
	{
    	if ($selected_id != -1) 
    	{
    		update_asset_valuation($selected_id, $_POST['valuationyear'], input_num('assetvalue'));
			display_notification(_('Selected asset type has been updated'));
    	} 
    	else 
    	{
    		add_asset_valuation($_POST['assetid'], $_POST['valuationyear'], input_num('assetvalue'));
			display_notification(_('New Asset value has been added'));
    	}
    	
		$Mode = 'RESET';
	}
} 


//-----------------------------------------------------------------------------------

if ($Mode == 'Delete')
{
	delete_asset_valuation($selected_id);
	display_notification(_('Selected asset valuation has been deleted'));

	$Mode = 'RESET';
}


//-----------------------------------------------------------------------------------
if(isset($_GET['mortise'])) {
	if ($_GET['mortise'] == 'yes') {
		$amzresult = get_amortise($_POST['assetid']);
	}
}

$result = get_one_asset($_POST['assetid']);

start_form();
start_table(TABLESTYLE, "width=75%");

$th = array(_("Asset Type"),_("Asset Name"),_("Serial Number"), _("Purchase Date"), _("Purchase Price"), _("Amortise"));
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
	echo "<td><a href='amortisation.php?mortise=yes&assetid=".$myrow['asset_id']."'>A</a></td>\n";

	end_row();
}
end_table(1);

//-------------------------------------------------------------------------------------------------------------------
$vresult = get_all_asset_valuations($_POST['assetid']);

start_form();
start_table(TABLESTYLE, "width=50%");

$th = array(_("Valuation Year"),_("Asset Value"),_("Value Change"), "");
inactive_control_column($th);
table_header($th);
$k = 0;
while ($myrow = db_fetch($vresult)) 
{
	
	alt_table_row_color($k);	

	label_cell($myrow["valuation_year"]);
	amount_cell($myrow["asset_value"]);
	amount_cell($myrow["value_change"]);
 	delete_button_cell("Delete".$myrow['asset_valuation_id'], _("Delete"));

	end_row();
}
end_table(1);

start_table(TABLESTYLE2);

if ($selected_id != -1) 
{
 	if ($Mode == 'Edit') {
		//editing an existing status code

		$myrow = get_asset_valuation($selected_id);

		$_POST['valuationyear'] = $myrow["valuation_year"];
		$_POST['assetvalue'] = number_format2($myrow["asset_value"], 2);
	}
	hidden('selected_id', $selected_id);
} 

text_row(_("Year of Valuation :"), 'valuationyear', null, 50, 50);
amount_row(_("Asset Value :"), 'assetvalue', null, null, null, 2);

echo "<input type='hidden' id='assetid' name='assetid' value='".$_POST['assetid']."'/>";


end_table(1);

submit_add_or_update_center($selected_id == -1, '', 'both');

end_form();

// ---------------------------------------------------------------------------------------------

echo "<hr/>\n";

$aresult = get_all_amortisation($_POST['assetid']);

start_form();
start_table(TABLESTYLE, "width=50%");

$th = array(_("Year"),_("Asset Value"),_("Depreciation"));
inactive_control_column($th);
table_header($th);
$k = 0;
while ($myrow = db_fetch($aresult)) 
{
	
	alt_table_row_color($k);	

	label_cell($myrow["amortisation_year"]);
	amount_cell($myrow["asset_value"]);
	amount_cell($myrow["amount"]);

	end_row();
}
end_table(1);


end_page();

?>
