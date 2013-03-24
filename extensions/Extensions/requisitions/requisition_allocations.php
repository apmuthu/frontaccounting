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
$page_security = 'SA_REQUISITION_ALLOCATIONS';
$path_to_root = "../..";
include($path_to_root . "/includes/session.inc");
add_access_extensions();

page(_($help_context = "Requisitions"));

include_once($path_to_root . "/modules/requisitions/includes/modules_db.inc");
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/includes/ui/ui_lists.inc");

simple_page_mode(true);
//-----------------------------------------------------------------------------------
if(isset($_GET['po'])) {
	if($_GET['po'] == 'yes') {
		if (generate_po())
			display_notification(_("Purchase orders has been generated."));
		else
			display_error(_("Purchase orders generation failed."));
	}
}

if ($Mode=='ADD_ITEM' || $Mode=='UPDATE_ITEM') 
{

	//initialise no input errors assumed initially before we test
	$input_error = 0;

	if (strlen($_POST['quantity']) == 0) 
	{
		$input_error = 1;
		display_error(_("The quantity of use cannot be empty."));
		set_focus('quantity');
	}
	if (strlen($_POST['price']) == 0) 
	{
		$input_error = 1;
		display_error(_("The price cannot be empty."));
		set_focus('price');
	}

	if ($input_error != 1) 
	{
    	if ($selected_id != -1) 
    	{
    		update_requisition_lpo($selected_id, $_POST['supplier_id'], $_POST['quantity'], input_num('price'));
			display_notification(_('Selected requisition details has been updated.'));
    	} 
    	
		$Mode = 'RESET';
	}
} 

//-----------------------------------------------------------------------------------

if ($Mode == 'RESET')
{
	$selected_id = -1;
	$sav = get_post('show_inactive');
	unset($_POST);
}
//-----------------------------------------------------------------------------------

$result = get_open_requisition_details();

start_form();
start_table(TABLESTYLE, "width=80%");

$th = array(_("RNo."), _("Point of Use"), _("Request Date"),_("Item Code"), _("Item Name"), _("Purpose"), _("Quantity"), _("Price"),  _("Supplier"), "");

table_header($th);
$k = 0;
while ($myrow = db_fetch($result)) 
{
	alt_table_row_color($k);	

	label_cell($myrow["requisition_id"]);
	label_cell($myrow["point_of_use"]);
	label_cell(sql2date($myrow["application_date"]));
	label_cell($myrow["item_code"]);
	label_cell($myrow["description"]);
	label_cell($myrow["purpose"]);
	label_cell($myrow["quantity"]);
	amount_cell($myrow["price"]);
	label_cell($myrow["supp_name"]);

 	edit_button_cell("Edit".$myrow['requisition_detail_id'], _("Edit"));

	end_row();
}
end_table(1);


//-----------------------------------------------------------------------------------

start_table(TABLESTYLE2);

if ($selected_id != -1) 
{
 	if ($Mode == 'Edit') {
		//editing an existing status code

		$myrow = get_requisition_detail($selected_id);

		$_POST['supplier_id']  = $myrow["supplier_id"];
		$_POST['item_code']  = $myrow["item_code"];
		$_POST['quantity']  = $myrow["quantity"];
		$_POST['price']  = $myrow["price"];
	}
	hidden('selected_id', $selected_id);
} 

supplier_list_row(_("Supplier : "), 'supplier_id', null, true, false);

	$res = get_item_edit_info(get_post('item_code'));
	$dec =  $res["decimals"] == '' ? 0 : $res["decimals"];
	$units = $res["units"] == '' ? _('kits') : $res["units"];

qty_row(_("Order Quantity:"), 'quantity', number_format2(1, $dec), '', $units, $dec);
amount_row(_("Order Price :"), 'price', null, null, null, 2);

end_table(1);

submit_add_or_update_center($selected_id == -1, '', 'both');

end_form();

echo "<div align='center'><a href='requisition_allocations.php?po=yes'>"._("Generate Purchase Orders")."</a></div>\n";
//------------------------------------------------------------------------------------

end_page();

?>
