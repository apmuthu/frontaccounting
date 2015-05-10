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

include_once($path_to_root . "/modules/import_transactions/includes/import_sales_cart_class.inc");
include_once($path_to_root . "/includes/manufacturing.inc");

//--------------------------------------------------------------------------------
function import_add_to_order(&$order, $new_item, $new_item_qty, $price, $discount, $description='')
{
	// calculate item price to sum of kit element prices factor for 
	// value distribution over all exploded kit items
	 $std_price = get_kit_price($new_item, $order->customer_currency, 
		$order->sales_type,	$order->price_factor, get_post('OrderDate'), true);

	if ($std_price == 0)
		$price_factor = 0;
	else
		$price_factor = $price/$std_price;

	$kit = get_item_kit($new_item);
	$item_num = db_num_rows($kit);
        while($item = db_fetch($kit)) {
            	$std_price = get_kit_price($item['stock_id'], $order->customer_currency, 
			$order->sales_type,	$order->price_factor, get_post('OrderDate'), true);

		// rounding differences are included in last price item in kit
		$item_num--;
		if ($item_num) {
			$price -= $item['quantity']*$std_price*$price_factor;
			$item_price = $std_price*$price_factor;
		} else {
			if ($item['quantity']) 
				$price = $price/$item['quantity'];
			$item_price = $price;
		}
		$item_price = round($item_price, user_price_dec());

	 if (!$item['is_foreign'] && $item['item_code'] != $item['stock_id'])
	 {	// this is sales kit - recurse 
		import_add_to_order($order, $item['stock_id'], $new_item_qty*$item['quantity'],
			$item_price, $discount);
	 }
	 else
	 {	// stock item record eventually with foreign code

		// check duplicate stock item
		foreach ($order->line_items as $order_item)
		{
			if (strcasecmp($order_item->stock_id, $item['stock_id']) == 0)
			{
				display_warning(_("For Part :").$item['stock_id']. " " 
					. _("This item is already on this document. You have been warned."));
				break;
			}
		}
                $order->add_to_cart (count($order->line_items),	$item['stock_id'], 
			$new_item_qty*$item['quantity'], $item_price, $discount, 0,0, $description);
	 }
	}

}
//---------------------------------------------------------------------------------

function import_get_customer_details_to_order(&$order, $customer_id, $branch_id)
{
	global $SysPrefs;
	
	$ret_error = "";

	$myrow = get_customer_to_order($customer_id);

	$name = $myrow['name'];

	if ($myrow['dissallow_invoices'] == 1)
		$ret_error = _("The selected customer account is currently on hold. Please contact the credit control personnel to discuss.");

	$deliver = $myrow['address']; // in case no branch address use company address

	$order->set_customer($customer_id, $name, $myrow['curr_code'], 
		$myrow['discount'], $myrow['payment_terms'], $myrow['pymt_discount']);

	// the sales type determines the price list to be used by default
	$order->set_sales_type($myrow['salestype'], $myrow['sales_type'], $myrow['tax_included'],
	    $myrow['factor']);

	$order->credit = $myrow['cur_credit'];

	if ($order->trans_type != ST_SALESORDER && $order->trans_type != ST_SALESQUOTE)
	{
		$order->dimension_id = $myrow['dimension_id'];
		$order->dimension2_id = $myrow['dimension2_id'];
	}
	$result = get_branch_to_order($customer_id, $branch_id);

	if (db_num_rows($result) == 0)
	{
		return _("The selected customer and branch are not valid, or the customer does not have any branches.");
	}
	$myrow = db_fetch($result);
	// FIX - implement editable contact selector in sales order 
	$contact = get_branch_contacts($branch_id, 'order', $customer_id);
	$order->set_branch($branch_id, $myrow["tax_group_id"],
	$myrow["tax_group_name"], @$contact["phone"], @$contact["email"]);
	$address = trim($myrow["br_post_address"]) != '' ? $myrow["br_post_address"]
		: (trim($myrow["br_address"]) != '' ? $myrow["br_address"]:$deliver);
	$order->set_delivery($myrow["default_ship_via"], $myrow["br_name"],
		$address);
	if ($order->trans_type == ST_SALESINVOICE) {
		$order->due_date = get_invoice_duedate($order->payment, $order->document_date);
	}
	elseif ($order->trans_type == ST_SALESORDER)
		$order->due_date = add_days($order->document_date, $SysPrefs->default_delivery_required_by());
	if($order->payment_terms['cash_sale']) {
		$order->set_location($order->pos["pos_location"], $order->pos["location_name"]);
	} else
		$order->set_location($myrow["default_location"], $myrow["location_name"]);
	return $ret_error;
}

//---------------------------------------------------------------------------------

function import_sales_order_item_controls(&$order, &$rowcounter, $line_no=-1)
{
    global $Ajax;

	alt_table_row_color($rowcounter);

	$id = find_submit('Edit');
	if ($line_no!=-1 && $line_no == $id) // edit old line
	{
		$_POST['stock_id'] = $order->line_items[$id]->stock_id;
		$dec = get_qty_dec($_POST['stock_id']);
		$_POST['qty'] = number_format2($order->line_items[$id]->qty_dispatched, $dec);
		$_POST['price'] = price_format($order->line_items[$id]->price);
		$_POST['Disc'] = percent_format($order->line_items[$id]->discount_percent*100);
		$units = $order->line_items[$id]->units;
		$_POST['item_description'] = $order->line_items[$id]->item_description;
		hidden('stock_id', $_POST['stock_id']);
		label_cell($_POST['stock_id']);
		if ($order->line_items[$id]->descr_editable)
			text_cells(null,'item_description', null, 45, 150);
		else {
			hidden('item_description', $_POST['item_description']);
			label_cell($_POST['item_description']);
		}
//		} else {
//			sales_items_list_cells(null,'item_description', null, false, true);
//		}
		//label_cell($order->line_items[$line_no]->item_description, "nowrap");
	    $Ajax->activate('items_table');
	}
	else	// prepare new line
	{
		sales_items_list_cells(null,'stock_id', null, false, true, true);
		if (list_updated('stock_id')) {
			    $Ajax->activate('price');
			    $Ajax->activate('units');
			    $Ajax->activate('qty');
			    $Ajax->activate('line_total');
		}

		$item_info = get_item_edit_info($_POST['stock_id']);
		$units = $item_info["units"];
		$dec = $item_info['decimals'];
		$_POST['qty'] = number_format2(1, $dec);
		$price = get_kit_price($_POST['stock_id'],
			$order->customer_currency, $order->sales_type,
			$order->price_factor, get_post('OrderDate'));
		$_POST['price'] = price_format($price);
		// default to the customer's discount %
		$_POST['Disc'] = percent_format($order->default_discount * 100);
	}

	qty_cells(null, 'qty', $_POST['qty'], null, null, $dec);

	if ($order->trans_no!=0) {
		qty_cell($line_no==-1 ? 0 :$order->line_items[$line_no]->qty_done, false, $dec);
	}

	label_cell($units, '', 'units');

	amount_cells(null, 'price');

	small_amount_cells(null, 'Disc', percent_format($_POST['Disc']), null, null, user_percent_dec());

	$line_total = input_num('qty') * input_num('price') * (1 - input_num('Disc') / 100);

	amount_cell($line_total, false, '','line_total');

	if ($id!=-1)
	{
		button_cell('UpdateItem', _("Update"),
				_('Confirm changes'), ICON_UPDATE);
		button_cell('CancelItemChanges', _("Cancel"),
				_('Cancel changes'), ICON_CANCEL);
		hidden('LineNo', $line_no);
		set_focus('qty');
	}
	else
	{
		submit_cells('AddItem', _("Add Item"), "colspan=2 align='center'",
		    _('Add new item to document'), true);
	}

	end_row();
}

//--------------------------------------------------------------------------------

?>
