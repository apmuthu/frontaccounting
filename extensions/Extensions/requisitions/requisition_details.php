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
$page_security = 'SA_REQUISITIONS';
$path_to_root = "../..";
include($path_to_root . "/includes/session.inc");
add_access_extensions();

page(_($help_context = "Requisitions"));

include_once($path_to_root . "/modules/requisitions/includes/modules_db.inc");
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/includes/ui/ui_lists.inc");

simple_page_mode(true);
//-----------------------------------------------------------------------------------
if(isset($_GET['requisitionid'])) {
	$req = get_requisition($_GET['requisitionid']);
	if (!$req || $req['completed'])
	{
		display_error(sprintf(_("Requisition #%d is already completed or does not exists."), $_GET['requisitionid']));
		submenu_option(_( "Entry &New Requisition."), '/modules/requisitions/requisitions.php');
		display_footer_exit();
	}
	if(isset($_GET['complete']) && $_GET['complete'] == 'yes') {
			complete_requisition($_GET['requisitionid']);
			display_notification(sprintf(_("Requisition #%d has been completed."), $_GET['requisitionid']));
			submenu_option(_( "Entry &New Requisition."), '/modules/requisitions/requisitions.php');
			display_footer_exit();
	}
	else
		$_POST['requisitionid'] = $_GET['requisitionid'];
}

if ($Mode=='ADD_ITEM' || $Mode=='UPDATE_ITEM') 
{

	//initialise no input errors assumed initially before we test
	$input_error = 0;

	if (strlen($_POST['item_code']) == 0) 
	{
		$input_error = 1;
		display_error(_("The item of use cannot be empty."));
		set_focus('name');
	}
	if (strlen($_POST['estimate_price']) == 0) 
	{
		$input_error = 1;
		display_error(_("The estimated price be empty."));
		set_focus('rate');
	}

	if ($input_error != 1) 
	{
    	if ($selected_id != -1) 
    	{
    		update_requisition_detail($selected_id, $_POST['item_code'], $_POST['purpose'], $_POST['order_quantity'], input_num('estimate_price'));
			display_notification(_('Selected requisition details has been updated.'));
    	} 
    	else 
    	{
    		add_requisition_detail($_POST['requisitionid'], $_POST['item_code'], $_POST['purpose'], $_POST['order_quantity'], input_num('estimate_price'));
			display_notification(_('New requisition details has been added'));
    	}
    	
		$Mode = 'RESET';
	}
} 

//-----------------------------------------------------------------------------------

if ($Mode == 'Delete')
{
	delete_requisition_detail($selected_id);
	display_notification(_('Selected requisition detail has been deleted'));

	$Mode = 'RESET';
}

if ($Mode == 'RESET')
{
	$selected_id = -1;
	$sav = get_post('show_inactive');
	$requisitionid = $_POST['requisitionid'];
	unset($_POST);
	$_POST['requisitionid'] = $requisitionid;
}
//-----------------------------------------------------------------------------------

$result = get_one_requisition(get_post('requisitionid'));

start_table(TABLESTYLE, "width=50%");

$th = array(_("Point of use"), _("Narrative"), _("Application Date"), _("Completation"));
inactive_control_column($th);
table_header($th);
$k = 0;
while ($myrow = db_fetch($result)) 
{
	alt_table_row_color($k);	

	label_cell($myrow["point_of_use"]);
	label_cell($myrow["narrative"]);
	label_cell(sql2date($myrow["application_date"]));
	echo "<td><a href='requisition_details.php?complete=yes&requisitionid=".$myrow['requisition_id']."'>"._("Complete")."</a></td>\n";

	end_row();
}

end_table(1);

//-----------------------------------------------------------------------------------
echo "<hr/>\n";

$result = get_all_requisition_details(get_post('requisitionid'));

start_form();
start_table(TABLESTYLE, "width=50%");

$th = array(_("Item Code"), _("Item Name"), _("Purpose"), _("Qrder Quantity"), _("Estimate Price"), "", "");

table_header($th);
$k = 0;
while ($myrow = db_fetch($result)) 
{
	alt_table_row_color($k);	

	label_cell($myrow["item_code"]);
	label_cell($myrow["description"]);
	label_cell($myrow["purpose"]);
	label_cell($myrow["order_quantity"]);
	amount_cell($myrow["estimate_price"]);

 	edit_button_cell("Edit".$myrow['requisition_detail_id'], _("Edit"));
 	delete_button_cell("Delete".$myrow['requisition_detail_id'], _("Delete"));

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

		$_POST['item_code']  = $myrow["item_code"];
		$_POST['purpose']  = $myrow["purpose"];
		$_POST['order_quantity']  = $myrow["order_quantity"];
		$_POST['estimate_price']  = $myrow["estimate_price"];
	}
	hidden('selected_id', $selected_id);
} 

sales_local_items_list_row(_("Item :"), 'item_code', null, false, false);
text_row(_("Purpose :"), 'purpose', null, 50, 50);

	$res = get_item_edit_info(get_post('item_code'));
	$dec =  $res["decimals"] == '' ? 0 : $res["decimals"];
	$units = $res["units"] == '' ? _('kits') : $res["units"];

qty_row(_("Requisition Quantity:"), 'order_quantity', number_format2(1, $dec), '', $units, $dec);
amount_row(_("Estimate Price :"), 'estimate_price', null, null, null, 2);

hidden('requisitionid');

end_table(1);

submit_add_or_update_center($selected_id == -1, '', 'both');

end_form();

//------------------------------------------------------------------------------------

end_page();

?>
