<?php
/**
 * Copyright (C) FrontAccounting, LLC.
 * @license <http://www.gnu.org/licenses/gpl-3.0.html>.
 */
 
/*******************************************************************************
 * Copyright(c) @2011 ANTERP SOLUTIONS. All rights reserved.
 *
 * Released under the terms of the GNU General Public License, GPL, 
 * as published by the Free Software Foundation, either version 3 
 * of the License, or (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
 * See the License here <http://www.gnu.org/licenses/gpl-3.0.html>.
 *
 * Authors		    tclim
 * Date Created     Aug 09, 2011 2:06:39 PM
 ******************************************************************************/

/**
 * Retrieve All Accounts
 * $searchBy		-	filter By
 * $pgIndex			-	Page index
 * $recordPerPage	-	Total Record Per Page
 * $return 			-	Array Object
 */
function get_all_account($searchBy, $pgIndex, $recordPerPage) {
	
	$total = $recordPerPage;
	
	// Get total count of records
	$sql = "SELECT count(dm.debtor_no) as total FROM ".TB_PREF."debtors_master dm WHERE dm.inactive = 0 ";
	if ($searchBy != '')
		$sql .= " AND dm.name LIKE " . db_escape($searchBy . "%");
	 
	$result = db_query($sql, "debtor master could not be retrieved");
		
	$row = db_fetch_row($sql);
		
	if (isset($row[0]))
		$total = $row[0];
 
	// counting the offset
	$offset = ($pgIndex + 1) * $recordPerPage;

	//Construct ResultSet
	$result = array("results"=>"0", "pgIndex"=>$offset, "recordPerPage"=>$recordPerPage);
			
	$sql = "SELECT dm.* FROM ".TB_PREF."debtors_master dm WHERE dm.inactive = 0 ";
	
	if ($searchBy != '')
		$sql .= " AND dm.name LIKE " . db_escape($searchBy . "%");
	
	$sql .= " LIMIT " . $pgIndex . ", " . $recordPerPage;
	
	$output = db_query($sql, "Cannot get all account $searchBy");
	
	if (count($output) > 0)
		$result = array("results"=> mysql_fetch_full_result_array($output), "pgIndex"=>$offset, "recordPerPage"=>$recordPerPage);
		
	return $result;	
}

/**
 * Retrieve Account By Account ID
 * $debtor_no		-	Account ID
 * $return 			-	Array Object
 */
function get_account_by_id($debtor_no) {
	
	//Construct ResultSet
	$result = array("results"=>"0");
	
	$sql = "SELECT dm.*,st.sales_type,cs.reason_description,terms.terms FROM ".TB_PREF."debtors_master dm LEFT JOIN ".TB_PREF."sales_types st ON st.id = dm.sales_type LEFT JOIN ".TB_PREF."credit_status cs ON cs.inactive = 0 AND cs.id = dm.credit_status LEFT JOIN ".TB_PREF."payment_terms terms ON terms.terms_indicator = dm.payment_terms WHERE dm.inactive = 0 AND dm.debtor_no = " .db_escape($debtor_no);		
			
	$output = db_query($sql, "Cannot get account by debtor_no $id");
	
	if (count($output) > 0)
		$result = array("results"=> mysql_fetch_full_result_array($output));
		
	return $result;	
}

/**
 * Retrieve Person Record By Account ID
 * $account_id		-	Account ID
 * $type			-	Type (customer/supplier/cust_branch)
 * $action			-	Action Type (general/order/invoice/delivery)
 * $return 			-	Array Object
 */
function get_person_by_account($account_id, $type = 'customer', $action = 'general') {
	
	$result = array();
	
	$sql = "SELECT person.* FROM ".TB_PREF."crm_persons person INNER JOIN ".TB_PREF."crm_contacts conts ON conts.person_id = person.id AND conts.type = " . db_escape($type) . " AND conts.action = " . db_escape($action) . " WHERE conts.entity_id = " .db_escape($account_id);

	$result = db_query($sql, "Cannot get contact by account $account_id");
	
	if (count($result) > 0)
		return mysql_fetch_full_result_array($result);
		
	return $result;	
}


/**
 * Retrieve All Contact Records
 * $searchBy		-	filter By
 * $type			-	Type (customer/supplier/cust_branch)
 * $action			-	Action Type (general/order/invoice/delivery)
 * $pgIndex			-	Page index
 * $recordPerPage	-	Total Record Per Page
 * $return 			-	Array Object
 */
function get_all_contact($searchBy, $type = 'customer', $action = '', $pgIndex, $recordPerPage) {
	
	$total = $recordPerPage;
	
	// Get total count of records	
	$sql = "SELECT count(DISTINCT(person.id)) as total FROM ".TB_PREF."crm_persons person INNER JOIN ".TB_PREF."crm_contacts conts ON conts.person_id = person.id AND conts.type = " . db_escape($type);
	
	if (trim($action) != '')
	 $sql .= " AND conts.action = " . db_escape($action);
	 
	if ($searchBy != '')
		$sql .= " WHERE conts.entity_id LIKE " . db_escape($searchBy . "%");
	 
	$result = db_query($sql, "crm_person could not be retrieved");
	$row = db_fetch_row($sql);
	
	if (isset($row[0]))
		$total = $row[0];
 
	// counting the offset
	$offset = ($pgIndex + 1) * $recordPerPage;

	//Construct ResultSet
	$result = array("results"=>"0", "pgIndex"=>$offset, "recordPerPage"=>$recordPerPage);
			
	$sql = "SELECT DISTINCT(person.id) as tid, person.*,dm.name as customer_name FROM ".TB_PREF."crm_persons person INNER JOIN ".TB_PREF."crm_contacts conts ON conts.person_id = person.id AND conts.type = " . db_escape($type);
	
	if (trim($action) != '')
	 $sql .= " AND conts.action = " . db_escape($action);
	 
	 $sql .= " INNER JOIN ".TB_PREF."debtors_master dm ON dm.debtor_no = conts.entity_id ";
	
	if ($searchBy != '')
		$sql .= " WHERE conts.entity_id LIKE " . db_escape($searchBy . "%");
	
	$sql .= " LIMIT " . $pgIndex . ", " . $recordPerPage;
	
	$output = db_query($sql, "Cannot get all contact $searchBy");
	
	if (count($output) > 0)
		$result = array("results"=> mysql_fetch_full_result_array($output), "pgIndex"=>$offset, "recordPerPage"=>$recordPerPage);
		
	return $result;	
}

/**
 * Retrieve All Contact By Account
 * $account_id		-	Account ID
 * $type			-	Type (customer/supplier/cust_branch)
 * $action			-	Action Type (general/order/invoice/delivery)
 * $pgIndex			-	Page index
 * $recordPerPage	-	Total Record Per Page
 * $return 			-	Array Object
 */
function get_contact_by_account($account_id, $type = 'customer', $action = '', $pgIndex, $recordPerPage) {
	
	$total = $recordPerPage;
	
	// Get total count of records
	$sql = "SELECT count(DISTINCT(conts.id)) as total FROM ".TB_PREF."crm_contacts conts WHERE conts.type = " . db_escape($type);
	
	if (trim($action) != '')
		$sql .= " AND conts.action = " . db_escape($action);
	
	$sql .= " AND conts.entity_id = " .db_escape($account_id);
	
	$result = db_query($sql, "crm_contacts could not be retrieved");
	$row = db_fetch_row($sql);
	
	if (isset($row[0]))
		$total = $row[0];
 
	// counting the offset
	$offset = ($pgIndex + 1) * $recordPerPage;

	//Construct ResultSet
	$result = array("results"=>"0", "pgIndex"=>$offset, "recordPerPage"=>$recordPerPage);
			
	$sql = "SELECT DISTINCT(person.id) as tid,person.*,dm.name as customer_name FROM ".TB_PREF."crm_persons person INNER JOIN ".TB_PREF."crm_contacts conts ON conts.person_id = person.id AND person.inactive = 0 AND conts.type = " . db_escape($type);
	
	if (trim($action) != '')
		$sql .= " AND conts.action = " . db_escape($action);
		
	$sql .= " INNER JOIN ".TB_PREF."debtors_master dm ON dm.debtor_no = conts.entity_id WHERE conts.entity_id = " .db_escape($account_id) . " LIMIT " . $pgIndex . ", " . $recordPerPage;
	
	$output = db_query($sql, "Cannot get contact by account $account_id");
	
	if (count($output) > 0)
		$result = array("results"=> mysql_fetch_full_result_array($output), "pgIndex"=>$offset, "recordPerPage"=>$recordPerPage);
		
	return $result;	
}

/**
 * Retrieve Contact By Contact ID
 * $id				-	ID
 * $return 			-	Array Object
 */
function get_contact_by_id($id) {
	
	//Construct ResultSet
	$result = array("results"=>"0");
			
	$sql = "SELECT person.*,dm.name as customer_name FROM ".TB_PREF."crm_persons person INNER JOIN ".TB_PREF."crm_contacts conts ON conts.person_id = person.id AND person.inactive = 0 INNER JOIN ".TB_PREF."debtors_master dm ON dm.debtor_no = conts.entity_id WHERE person.id = " .db_escape($id);

	$output = db_query($sql, "Cannot get contact by id $id");
	
	if (count($output) > 0)
		$result = array("results"=> mysql_fetch_full_result_array($output));
		
	return $result;	
}

/**
 * Retrieve All Suppliers Records
 * $searchBy		-	filter By
 * $pgIndex			-	Page index
 * $recordPerPage	-	Total Record Per Page
 * $return 			-	Array Object
 */
function get_all_suppliers($searchBy, $pgIndex, $recordPerPage) {
	
	$total = $recordPerPage;
	
	// Get total count of records
	$sql = "SELECT count(supp.supplier_id) as total FROM ".TB_PREF."suppliers supp WHERE supp.inactive = 0 ";
	if ($searchBy != '')
		$sql .= " AND supp.supp_name LIKE " . db_escape($searchBy . "%");
	 
	$result = db_query($sql, "suppliers could not be retrieved");
	$row = db_fetch_row($sql);
	
	if (isset($row[0]))
		$total = $row[0];
 
	// counting the offset
	$offset = ($pgIndex + 1) * $recordPerPage;

	//Construct ResultSet
	$result = array("results"=>"0", "pgIndex"=>$offset, "recordPerPage"=>$recordPerPage);
			
	$sql = "SELECT supp.* FROM ".TB_PREF."suppliers supp WHERE supp.inactive = 0 ";
	
	if ($searchBy != '')
		$sql .= " AND AND supp.supp_name LIKE " . db_escape($searchBy . "%");
	
	$sql .= " LIMIT " . $pgIndex . ", " . $recordPerPage;
	
	$output = db_query($sql, "Cannot get all suppliers $searchBy");
	
	if (count($output) > 0)
		$result = array("results"=> mysql_fetch_full_result_array($output), "pgIndex"=>$offset, "recordPerPage"=>$recordPerPage);
		
	return $result;	
}

/**
 * Retrieve Supplier By Supplier ID
 * $supplier_id		-	Supplier ID
 * $return 			-	Array Object
 */
function get_supplier_by_id($supplier_id) {
	
	//Construct ResultSet
	$result = array("results"=>"0");
	
	$sql = "SELECT supp.*,terms.terms FROM ".TB_PREF."suppliers supp LEFT JOIN ".TB_PREF."payment_terms terms ON terms.terms_indicator = supp.payment_terms WHERE supp.inactive = 0 AND supplier_id = " .db_escape($supplier_id);		
			
	$output = db_query($sql, "Cannot get supplier by supplier_id $supplier_id");
	
	if (count($output) > 0)
		$result = array("results"=> mysql_fetch_full_result_array($output));
		
	return $result;	
}

/**
 * Retrieve All Contact By Supplier
 * $supplier_id		-	Supplier ID
 * $type			-	Type (customer/supplier/cust_branch)
 * $action			-	Action Type (general/order/invoice/delivery)
 * $pgIndex			-	Page index
 * $recordPerPage	-	Total Record Per Page
 * $return 			-	Array Object
 */
function get_contact_by_supplier_id($supplier_id, $type = 'supplier', $action = '', $pgIndex, $recordPerPage) {
	
	$total = $recordPerPage;
	
	// Get total count of records
	$sql = "SELECT count(DISTINCT(conts.id)) as total FROM ".TB_PREF."crm_contacts conts WHERE conts.type = " . db_escape($type);
	
	if (trim($action) != '')
		$sql .= " AND conts.action = " . db_escape($action);
	
	$sql .= " AND conts.entity_id = " .db_escape($supplier_id);
	
	$result = db_query($sql, "supplier crm_contacts could not be retrieved");
	$row = db_fetch_row($sql);
	
	if (isset($row[0]))
		$total = $row[0];
 
	// counting the offset
	$offset = ($pgIndex + 1) * $recordPerPage;

	//Construct ResultSet
	$result = array("results"=>"0", "pgIndex"=>$offset, "recordPerPage"=>$recordPerPage);
			
	$sql = "SELECT DISTINCT(person.id) as tid, person.*,supp.supp_name FROM ".TB_PREF."crm_persons person INNER JOIN ".TB_PREF."crm_contacts conts ON conts.person_id = person.id AND person.inactive = 0 AND conts.type = " . db_escape($type);
	
	if (trim($action) != '')
		$sql .= " AND conts.action = " . db_escape($action);
	
	$sql .= " INNER JOIN ".TB_PREF."suppliers supp ON supp.supplier_id = conts.entity_id WHERE conts.entity_id = " .db_escape($supplier_id) . " LIMIT " . $pgIndex . ", " . $recordPerPage;

	$output = db_query($sql, "Cannot get contact by supplier $supplier_id");
	
	if (count($output) > 0)
		$result = array("results"=> mysql_fetch_full_result_array($output), "pgIndex"=>$offset, "recordPerPage"=>$recordPerPage);
		
	return $result;	
}

/**
 * Retrieve Supplier Contact By Contact ID
 * $id				-	Supplier Contact ID
 * $return 			-	Array Object
 */
function get_supplier_contact_by_id($id) {
	
	//Construct ResultSet
	$result = array("results"=>"0");
			
	$sql = "SELECT person.*, supp_name FROM ".TB_PREF."crm_persons person INNER JOIN ".TB_PREF."crm_contacts conts ON conts.person_id = person.id AND person.inactive = 0 INNER JOIN ".TB_PREF."suppliers supp ON supp.supplier_id = conts.entity_id WHERE person.id = " .db_escape($id);

	$output = db_query($sql, "Cannot get supplier contact by id $id");
	
	if (count($output) > 0)
		$result = array("results"=> mysql_fetch_full_result_array($output));
		
	return $result;	
}

/**
 * Retrieve All Suppliers Records
 * $searchBy		-	filter By
 * $pgIndex			-	Page index
 * $recordPerPage	-	Total Record Per Page
 * $return 			-	Array Object
 */
function getAllStockMaster($searchBy, $pgIndex, $recordPerPage) {
	
	$total = $recordPerPage;
	
	//Retrieve the default currency
	$currency_code = get_company_pref('curr_default');
	
	// Get total count of records
	$sql = "SELECT count(sm.stock_id) as total FROM ".TB_PREF."stock_master sm,".TB_PREF."prices p,".TB_PREF."item_tax_types itt,".TB_PREF."stock_category sc WHERE p.stock_id = sm.stock_id AND p.curr_abrev = " . db_escape($currency_code) . " AND itt.id=sm.tax_type_id AND sm.category_id = sc.category_id ";			
	
	if ($searchBy != '')
		$sql .= " AND ".TB_PREF."stock_master.stock_id LIKE " . db_escape($searchBy . "%");
	 
	$result = db_query($sql, "stock master could not be retrieved");
	$row = db_fetch_row($sql);
	
	if (isset($row[0]))
		$total = $row[0];
 
	// counting the offset
	$offset = ($pgIndex + 1) * $recordPerPage;

	//Construct ResultSet
	$result = array("results"=>"0", "pgIndex"=>$offset, "recordPerPage"=>$recordPerPage);
			
	$sql = "SELECT sm.stock_id,sm.description,sm.long_description,sm.units,(CASE sm.mb_flag WHEN 'D' THEN 'Service' WHEN 'M' THEN 'Manufactured' ELSE 'Purchased' END) as mb_flag,itt.name AS tax_type_name, sc.description as category, p.curr_abrev as curr_code, p.price as list_price FROM ".TB_PREF."stock_master sm,".TB_PREF."prices p,".TB_PREF."item_tax_types itt,".TB_PREF."stock_category sc WHERE p.stock_id = sm.stock_id AND p.curr_abrev = " . db_escape($currency_code) . " AND itt.id=sm.tax_type_id AND sm.category_id = sc.category_id ";
	
	if ($searchBy != '')
		$sql .= " AND ".TB_PREF."sm.stock_id LIKE " . db_escape($searchBy . "%");
	
	$sql .= " LIMIT " . $pgIndex . ", " . $recordPerPage;
	
	$output = db_query($sql, "Cannot get all stock master $searchBy");
	
	if (count($output) > 0)
		$result = array("results"=> mysql_fetch_full_result_array($output), "pgIndex"=>$offset, "recordPerPage"=>$recordPerPage);
		
	return $result;	
}

/**
 * Retrieve Supplier By Stock ID
 * $stock_id		-	Stock ID
 * $return 			-	Array Object
 */
function getStockMasterById($stock_id) {
	
	//Construct ResultSet
	$result = array("results"=>"0");
	
	$sql = "SELECT sm.stock_id,sm.description,sm.long_description,sm.units,(CASE sm.mb_flag WHEN 'D' THEN 'Service' WHEN 'M' THEN 'Manufactured' ELSE 'Purchased' END) as mb_flag,itt.name AS tax_type_name, sc.description as category, loc.loc_code, loc.location_name, reorders.reorder_level  FROM ".TB_PREF."stock_master sm,".TB_PREF."item_tax_types itt,".TB_PREF."stock_category sc, ".TB_PREF."locations loc, ".TB_PREF."loc_stock reorders WHERE itt.id=sm.tax_type_id AND sm.category_id = sc.category_id AND reorders.loc_code=loc.loc_code AND reorders.stock_id = sm.stock_id
		   AND sm.stock_id = " .db_escape($stock_id);
			
	$output = db_query($sql, "Cannot get Stock by stock_id $stock_id");
	
	$result = array();
	$rec = 0;
	
	while ($myrow = db_fetch($output))
	{
		//Retrieve On Demand Status
		$demand_qty = get_demand_qty($stock_id, $myrow["loc_code"]);
		$demand_qty += get_demand_asm_qty($stock_id, $myrow["loc_code"]);
		//Retrieve Quantity On Hand Status	
		$qoh = get_qoh_on_date($stock_id, $myrow["loc_code"]);
		//Retrieve On Order Status
		$qoo = get_on_porder_qty($stock_id, $myrow["loc_code"]);
		$qoo += get_on_worder_qty($stock_id, $myrow["loc_code"]);
			
		$output = array();
		$output['stock_id'] = $stock_id;
		$output['description'] = $myrow["description"];
		$output['long_description'] = $myrow["long_description"];
		$output['units'] = $myrow["units"];
		$output['mb_flag'] = $myrow["mb_flag"];		
		$output['tax_type_name'] = $myrow["tax_type_name"];
		$output['category'] = $myrow["category"];
		$output['location_name'] = $myrow["location_name"];		
		$output['reorder_level'] = $myrow["reorder_level"];
		$output['on_demand'] = $demand_qty==null?"0":$demand_qty;
		$output['qty_on_hand'] = $qoh==null?"0":$qoh;
		$output['on_order'] = $qoo==null?"0":$qoo;
		$output['available_stock'] = $qoh - $demand_qty;
		
		$result[$rec] = $output;
		$rec++;
	}
	
	if (count($result) > 0)
		$result = array("results"=> $result);
	
	return $result;	
}

/**
 * Retrieve Stock Status By Stock ID
 * $stock_id		-	Stock ID
 * $return 			-	Array Object
 */
function getAllStockStatus($arrObj) {
	
	//Retrieve the default currency
	$currency_code = get_company_pref('curr_default');
	
	
	$result = array();
	$rec = 0;
	foreach($arrObj['stocks'] as $p) {
		
		$description = '';
		$material_cost = 0;
		$price = 0;
		
		$loc_details = get_loc_details($p['stock_id']);
		
		$sql = "SELECT sm.description, sm.material_cost, p.price FROM ".TB_PREF."stock_master sm INNER JOIN ".TB_PREF."prices p ON p.stock_id = sm.stock_id WHERE p.stock_id = " . db_escape($p['stock_id']) . " AND p.curr_abrev=".db_escape($currency_code);
	
		$priceResult = db_query($sql,"price could not be retrieved");
	
		$priceRow = db_fetch_row($priceResult);
			
		if (isset($priceRow[0])) {
			$description = $priceRow[0];
			$material_cost = $priceRow[1];
			$price = $priceRow[2];
		}
		
		while ($myrow = db_fetch($loc_details))
		{
			//Retrieve On Demand Status
			$demand_qty = get_demand_qty($p['stock_id'], $myrow["loc_code"]);
			$demand_qty += get_demand_asm_qty($p['stock_id'], $myrow["loc_code"]);
			//Retrieve Quantity On Hand Status	
			$qoh = get_qoh_on_date($p['stock_id'], $myrow["loc_code"]);
			//Retrieve On Order Status
			$qoo = get_on_porder_qty($p['stock_id'], $myrow["loc_code"]);
			$qoo += get_on_worder_qty($p['stock_id'], $myrow["loc_code"]);
				
			$output = array();
			$output['stock_id'] = $p['stock_id'];
			$output['name'] = $description;
			$output['reorder_level'] = $myrow["reorder_level"];
			$output['on_demand'] = $demand_qty;
			$output['qty_on_hand'] = $qoh;
			$output['on_order'] = $qoo;
			$output['available_stock'] = $qoh - $demand_qty;
			$output['material_cost'] = $material_cost;
			$output['list_price'] = $price;
			$result[$rec] = $output;
			$rec++;
		}
	}
	
	return $result;	
}

/**
 * Retrieve All Purchase Order Records
 * $searchBy		-	filter By
 * $pgIndex			-	Page index
 * $recordPerPage	-	Total Record Per Page
 * $return 			-	Array Object
 */
function getAllPurchaseOrder($searchBy, $pgIndex, $recordPerPage) {
	
	$total = $recordPerPage;
	
	// Get total count of records
	$sql = "SELECT count(porder.order_no) FROM ".TB_PREF."purch_orders as porder, ".TB_PREF."purch_order_details as line, ".TB_PREF."suppliers as supplier, ".TB_PREF."locations as location
	  		WHERE (porder.order_no = line.order_no
			AND porder.supplier_id = supplier.supplier_id";
	
	if ($searchBy != '')
		$sql .= " AND porder.order_no = " . db_escape($searchBy);
				
	$sql .=	" AND location.loc_code = porder.into_stock_location) GROUP BY porder.order_no ORDER BY ord_date desc ";			
	 
	$result = db_query($sql, "purch_orders could not be retrieved");
	$row = db_fetch_row($sql);
	
	if (isset($row[0]))
		$total = $row[0];
 
	// counting the offset
	$offset = ($pgIndex + 1) * $recordPerPage;

	//Construct ResultSet
	$result = array("results"=>"0", "pgIndex"=>$offset, "recordPerPage"=>$recordPerPage);
			
	$sql = "SELECT 
		porder.order_no, 
		porder.reference, 
		supplier.supp_name, 
		location.location_name,
		porder.requisition_no, 
		porder.ord_date,
		porder.comments,
		porder.total,
		porder.delivery_address,
		supplier.curr_code, 
		Sum(line.unit_price*line.quantity_ordered) AS OrderValue,
		porder.into_stock_location
	 FROM ".TB_PREF."purch_orders as porder, ".TB_PREF."purch_order_details as line, ".TB_PREF."suppliers as supplier, ".TB_PREF."locations as location
	  WHERE (porder.order_no = line.order_no
		AND porder.supplier_id = supplier.supplier_id";
	
		if ($searchBy != '')
			$sql .= " AND porder.order_no = " . db_escape($searchBy);
			
	$sql .= " AND location.loc_code = porder.into_stock_location) GROUP BY porder.order_no ORDER BY ord_date desc  ";
	
	$sql .= " LIMIT " . $pgIndex . ", " . $recordPerPage;
	
	$output = db_query($sql, "Cannot get all purchase order $searchBy");
	
	if (count($output) > 0)
		$result = array("results"=> mysql_fetch_full_result_array($output), "pgIndex"=>$offset, "recordPerPage"=>$recordPerPage);
		
	return $result;	
}

/**
 * Retrieve Purchase Order By Order No
 * $order_no		-	Order No
 * $return 			-	Array Object
 */
function getPurchaseOrderByOrderNo($order_no) {
	
	//Construct ResultSet
	$result = array("results"=>"0");
			
	$sql = "SELECT 
		porder.order_no, 
		porder.reference, 
		supplier.supp_name, 
		location.location_name,
		porder.requisition_no, 
		porder.ord_date,
		porder.comments,
		porder.total,
		porder.delivery_address,  
		supplier.curr_code, 
		Sum(line.unit_price*line.quantity_ordered) AS OrderValue,
		porder.into_stock_location
	 	FROM ".TB_PREF."purch_orders as porder, ".TB_PREF."purch_order_details as line, ".TB_PREF."suppliers as supplier, ".TB_PREF."locations as location
	  	WHERE (porder.order_no = line.order_no
		AND porder.supplier_id = supplier.supplier_id
	 	AND porder.order_no = " . db_escape($order_no) . " AND location.loc_code = porder.into_stock_location) GROUP BY porder.order_no ORDER BY ord_date desc  ";
			
	$output = db_query($sql, "Cannot get all purchase order $order_no");
	
	if (count($output) > 0)
		$result = array("results"=> mysql_fetch_full_result_array($output));
		
	return $result;	
}

/*
 * Retrieve Purchase Order Details By Order No
 * $order_no		-	Order No
 * $arrObj			-	Array Object
 * $return 			-	Array Object
 */
function getPurchaseOrderItemDetailsByOrderNo($order_no) {
	//Construct ResultSet
	$result = array("results"=>"0");
	
	$arrObj = array("order_no"=>$order_no);
	
	$output = getPurchaseOrderItemDetails($arrObj);
	
	if (count($output) > 0)
		$result = array("results"=>$output);
	
	return $result;
	
}

/**
 * Retrieve All Sales Order Records
 * $order_no		-	Order No
 * $trans_type		-	Transaction Type
 * $pgIndex			-	Page index
 * $recordPerPage	-	Total Record Per Page
 * $return 			-	Array Object
 */
function getAllSalesOrder($order_no, $trans_type, $pgIndex, $recordPerPage) {
	
	$total = $recordPerPage;
	
	// Get total count of records
	$sql = "SELECT 
			count(sorder.order_no) as total
	 FROM ".TB_PREF."sales_orders as sorder, ".TB_PREF."sales_order_details as line, ".TB_PREF."debtors_master as debtor, ".TB_PREF."cust_branch as branch
		  WHERE (sorder.order_no = line.order_no";
		  
		if ($order_no != '')
			$sql .= " AND sorder.order_no = " . db_escape($order_no);
					
	$sql .= "	AND sorder.trans_type = line.trans_type
			 	AND sorder.trans_type = " . db_escape($trans_type);
	
		if (trim($trans_type) == '32') //Quotation
			$sql .= " AND sorder.delivery_date >= '" . date2sql(Today()) . "'";
	
	$sql .=  "	AND sorder.debtor_no = debtor.debtor_no
			 	AND sorder.branch_code = branch.branch_code
			 	AND debtor.debtor_no = branch.debtor_no) GROUP BY sorder.order_no,
					sorder.debtor_no,
					sorder.branch_code,
					sorder.customer_ref,
					sorder.ord_date,
					sorder.deliver_to";
	 
	$result = db_query($sql, "sales_order_details could not be retrieved");
	$row = db_fetch_row($sql);
	
	if (isset($row[0]))
		$total = $row[0];
 
	// counting the offset
	$offset = ($pgIndex + 1) * $recordPerPage;

	//Construct ResultSet
	$result = array("results"=>"0", "pgIndex"=>$offset, "recordPerPage"=>$recordPerPage);
			
	$sql = "SELECT 
			sorder.order_no,
			sorder.comments,
			sorder.reference,
			debtor.name,
			branch.br_name,sorder.customer_ref, sorder.ord_date,
			sorder.delivery_date,
			sorder.delivery_address,
			sorder.contact_phone,
			sorder.deliver_to,
			Sum(line.unit_price*line.quantity*(1-line.discount_percent))+freight_cost AS OrderValue,
			sorder.total,
			sorder.type,
			debtor.curr_code,
			Sum(line.qty_sent) AS TotDelivered,
			Sum(line.quantity) AS TotQuantity
	 FROM ".TB_PREF."sales_orders as sorder, ".TB_PREF."sales_order_details as line, ".TB_PREF."debtors_master as debtor, ".TB_PREF."cust_branch as branch
		  WHERE (sorder.order_no = line.order_no";
			
	if ($order_no != '')
			$sql .= " AND sorder.order_no = " . db_escape($order_no);
					
	$sql .= "	AND sorder.trans_type = line.trans_type
			 	AND sorder.trans_type = " . db_escape($trans_type);
			 	
	if (trim($trans_type) == '32') //Quotation
		$sql .= " AND sorder.delivery_date >= '" . date2sql(Today()) . "'";
	
	$sql .=  "	AND sorder.debtor_no = debtor.debtor_no
			 	AND sorder.branch_code = branch.branch_code
			 	AND debtor.debtor_no = branch.debtor_no) GROUP BY sorder.order_no,
					sorder.debtor_no,
					sorder.branch_code,
					sorder.customer_ref,
					sorder.ord_date,
					sorder.deliver_to ORDER BY sorder.order_no DESC ";	
			
	$sql .= " LIMIT " . $pgIndex . ", " . $recordPerPage;
	
	$output = db_query($sql, "Cannot get all sales order $order_no");
	
	if (count($output) > 0)
		$result = array("results"=> mysql_fetch_full_result_array($output), "pgIndex"=>$offset, "recordPerPage"=>$recordPerPage);
		
	return $result;	
}


/**
 * Retrieve Sales Order By Order No
 * $order_no		-	Order No
 * $trans_type		-	Transaction Type
 * $return 			-	Array Object
 */
function getSalesOrderByOrderNo($order_no, $trans_type) {
	
	//Construct ResultSet
	$result = array("results"=>"0");
			
	$sql = "SELECT 
			sorder.order_no,
			sorder.comments,
			sorder.reference,
			debtor.name,
			branch.br_name,sorder.customer_ref, sorder.ord_date,
			sorder.delivery_date,
			sorder.delivery_address,
			sorder.contact_phone,
			sorder.deliver_to,
			Sum(line.unit_price*line.quantity*(1-line.discount_percent))+freight_cost AS OrderValue,
			sorder.total,
			sorder.type,
			debtor.curr_code,
			Sum(line.qty_sent) AS TotDelivered,
			Sum(line.quantity) AS TotQuantity
	 FROM ".TB_PREF."sales_orders as sorder, ".TB_PREF."sales_order_details as line, ".TB_PREF."debtors_master as debtor, ".TB_PREF."cust_branch as branch
		  WHERE (sorder.order_no = line.order_no";
			
	if ($order_no != '')
			$sql .= " AND sorder.order_no = " . db_escape($order_no);
					
	$sql .= "	AND sorder.trans_type = line.trans_type
			 	AND sorder.trans_type = " . db_escape($trans_type);
	
	$sql .=  "	AND sorder.debtor_no = debtor.debtor_no
			 	AND sorder.branch_code = branch.branch_code
			 	AND debtor.debtor_no = branch.debtor_no) GROUP BY sorder.order_no,
					sorder.debtor_no,
					sorder.branch_code,
					sorder.customer_ref,
					sorder.ord_date,
					sorder.deliver_to ORDER BY sorder.order_no DESC ";	
			
	$output = db_query($sql, "Cannot get all sales order $order_no");
	
	if (count($output) > 0)
		$result = array("results"=> mysql_fetch_full_result_array($output));
		
	return $result;	
}


/**
 * Retrieve Sales Order Details By Order No
 * $order_no		-	Order No
 * $trans_type		-	Transaction Type
 * $arrObj			-	Array Object
 * $return 			-	Array Object
 */
function getSalesOrderItemDetailsByOrderNo($order_no, $trans_type) {
	//Construct ResultSet
	$result = array("results"=>"0");
	
	$arrObj = array("order_no"=>$order_no, "trans_type"=>$trans_type);
	
	$output = getSalesOrderItemDetails($arrObj);
	
	if (count($output) > 0)
		$result = array("results"=>$output);
	
	return $result;
	
}

/**
 * Retrieve All Invoice Records
 * $trans_no		-	Transaction No
 * $trans_type		-	Transaction Type
 * $pgIndex			-	Page index
 * $recordPerPage	-	Total Record Per Page
 * $return 			-	Array Object
 */
function getAllInvoice($trans_no, $trans_type, $pgIndex, $recordPerPage) {
	
	$total = $recordPerPage;
	
	// Get total count of records
	$sql = "SELECT 
  		count(trans.trans_no)
	 FROM ".TB_PREF."debtor_trans as trans
			LEFT JOIN ".TB_PREF."debtor_trans_details as line
				ON trans.trans_no=line.debtor_trans_no AND trans.type=line.debtor_trans_type,".TB_PREF."debtors_master as debtor, ".TB_PREF."cust_branch as branch
	  WHERE (debtor.debtor_no = trans.debtor_no
			AND trans.branch_code = branch.branch_code) AND trans.type = " . db_escape($trans_type) . " GROUP BY trans.trans_no, trans.type";
	 
	$result = db_query($sql, "debtor_trans could not be retrieved");
	$row = db_fetch_row($sql);
	
	if (isset($row[0]))
		$total = $row[0];
 
	// counting the offset
	$offset = ($pgIndex + 1) * $recordPerPage;

	//Construct ResultSet
	$result = array("results"=>"0", "pgIndex"=>$offset, "recordPerPage"=>$recordPerPage);
			
	$sql = "SELECT (CASE trans.type WHEN '10' THEN 'Sales Invoice' WHEN '11' THEN 'Customer Credit' WHEN '12' THEN 'Customer Payment' WHEN '13' THEN 'Delivery Note' ELSE 'Sales Invoice' END) as type_desc,
  		trans.type, 
		trans.trans_no, 
		trans.order_, 
		trans.reference,
		trans.tran_date, 
		trans.due_date, 
		debtor.name, 
		branch.br_name,
		debtor.curr_code,
		(trans.ov_amount + trans.ov_gst + trans.ov_freight 
			+ trans.ov_freight_tax + trans.ov_discount)	AS TotalAmount, trans.alloc AS Allocated,
		((trans.type = " . db_escape($trans_type) . ")
			AND trans.due_date < '" . date2sql(Today()) . "') AS OverDue,
		Sum(line.quantity-line.qty_done) AS Outstanding,
		commen.memo_ as comments
	 FROM ".TB_PREF."debtor_trans as trans
	 		LEFT JOIN ".TB_PREF."comments commen
				ON commen.type = trans.type
				AND commen.id = trans.trans_no
			LEFT JOIN ".TB_PREF."debtor_trans_details as line
				ON trans.trans_no=line.debtor_trans_no AND trans.type=line.debtor_trans_type,".TB_PREF."debtors_master as debtor, ".TB_PREF."cust_branch as branch
	  WHERE (debtor.debtor_no = trans.debtor_no
			AND trans.branch_code = branch.branch_code) AND trans.type = " . db_escape($trans_type) . " GROUP BY trans.trans_no, trans.type ORDER BY tran_date desc";
			
	$sql .= " LIMIT " . $pgIndex . ", " . $recordPerPage;
	
	$output = db_query($sql, "Cannot get all invoice $trans_no");
	
	if (count($output) > 0)
		$result = array("results"=> mysql_fetch_full_result_array($output), "pgIndex"=>$offset, "recordPerPage"=>$recordPerPage);
		
	return $result;	
}


/**
 * Retrieve Invoice By Transaction No
 * $trans_no		-	Transaction No
 * $trans_type		-	Transaction Type
 * $return 			-	Array Object
 */
function getInvoiceByTransNo($trans_no, $trans_type) {
	
	//Construct ResultSet
	$result = array("results"=>"0");
			
	$sql = "SELECT (CASE trans.type WHEN '10' THEN 'Sales Invoice' WHEN '11' THEN 'Customer Credit' WHEN '12' THEN 'Customer Payment' WHEN '13' THEN 'Delivery Note' ELSE 'Sales Invoice' END) as type_desc, trans.*,ov_amount+ov_gst+ov_freight+ov_freight_tax+ov_discount AS Total,cust.name AS DebtorName, cust.address, cust.curr_code, cust.tax_id , ".TB_PREF."shippers.shipper_name, ".TB_PREF."sales_types.sales_type, ".TB_PREF."sales_types.tax_included, branch.*, cust.discount, ".TB_PREF."tax_groups.name AS tax_group_name, ".TB_PREF."tax_groups.id AS tax_group_id, commen.memo_ as comments
		  	FROM ".TB_PREF."debtor_trans trans, ".TB_PREF."debtors_master cust, ".TB_PREF."shippers, ".TB_PREF."sales_types, ".TB_PREF."cust_branch branch, ".TB_PREF."tax_groups, ".TB_PREF."comments commen  WHERE trans.trans_no=" . db_escape($trans_no) . "
			AND trans.type=" . db_escape($trans_type) . "
			AND trans.debtor_no=cust.debtor_no AND ".TB_PREF."shippers.shipper_id=trans.ship_via
			AND ".TB_PREF."sales_types.id = trans.tpe
			AND branch.branch_code = trans.branch_code
			AND branch.tax_group_id = ".TB_PREF."tax_groups.id
			AND commen.type = trans.type
			AND commen.id = trans.trans_no";	
			
	$output = db_query($sql, "Cannot get invoice $trans_no");
	
	if (count($output) > 0)
		$result = array("results"=> mysql_fetch_full_result_array($output));
		
	return $result;	
}


/**
 * Retrieve Invoice Details By Transaction No
 * $trans_no		-	Transaction No
 * $trans_type		-	Transaction Type
 * $arrObj			-	Array Object
 * $return 			-	Array Object
 */
function getInvoiceItemDetailsByTransNo($trans_no, $trans_type) {
	//Construct ResultSet
	$result = array("results"=>"0");
	
	$arrObj = array("trans_no"=>$trans_no, "trans_type"=>$trans_type);
	
	$output = getInvoiceItemDetails($arrObj);
	
	if (count($output) > 0)
		$result = array("results"=>$output);
	
	return $result;
	
}

/**
 * Retrieve Prices Record By Stock ID
 * $arrObj			-	Array Object
 * $return 			-	Array Object
 */
function getPrice($arrObj, $module) {
	
	$result = array();
	$rec = 0;
	$baseCurrency = trim($arrObj['base_currency']);
	
	//Check if the base currency is empty. If yes, we need to retreive it from db
	if ($baseCurrency == '') {
		//Retrieve the default currency
		$baseCurrency = get_company_pref('curr_default');
	
	}
	
	//Custom group by currency code
	//This function is to solve the duplicate entry with different sales type
	//We should return the higher price
	$sql = "SELECT ".TB_PREF."sales_types.sales_type, ".TB_PREF."prices.* 
		FROM ".TB_PREF."prices, ".TB_PREF."sales_types 
		WHERE ".TB_PREF."prices.sales_type_id = ".TB_PREF."sales_types.id 
		AND stock_id=".db_escape($arrObj['stock_id']) . 
		" GROUP BY ".TB_PREF."prices.curr_abrev " .
		" ORDER BY curr_abrev, sales_type_id";
	
	$price_details = db_query($sql,"item prices could not be retrieved");
	

	while ($myrow = db_fetch($price_details))
	{
		$output = array();
		$output['line_item_type'] = $arrObj['module'];		
		$output['product_id'] = $arrObj['product_id'];
		
		if ($module == 'ITEM_SERVICE') {
			$output['service_code'] = $myrow['stock_id'];
		} else {
			$output['product_code'] = $myrow['stock_id'];
		}
		$output['sales_type'] = $myrow['sales_type'];
		$output['currency_code'] = $myrow['curr_abrev'];
		$output['list_price'] = $myrow['price'];
		
		if ($baseCurrency == trim($myrow['curr_abrev'])) {
			$output['base_currency'] = '1';
		} else {
			$output['base_currency'] = '0';
		}
		
		$result[$rec] = $output;
		$rec++;
	}
	
	return $result;	
}

/**
 * Retrieve Stock Status Record By Stock ID
 * $arrObj			-	Array Object
 * $return 			-	Array Object
 */
function getStockStatus($arrObj) {
	
	$result = array();
	$rec = 0;
	
	$loc_details = get_loc_details($arrObj['stock_id']);
	
	while ($myrow = db_fetch($loc_details))
	{
		//Retrieve On Demand Status
		$demand_qty = get_demand_qty($arrObj['stock_id'], $myrow["loc_code"]);
		$demand_qty += get_demand_asm_qty($arrObj['stock_id'], $myrow["loc_code"]);
		//Retrieve Quantity On Hand Status	
		$qoh = get_qoh_on_date($arrObj['stock_id'], $myrow["loc_code"]);
		//Retrieve On Order Status
		$qoo = get_on_porder_qty($arrObj['stock_id'], $myrow["loc_code"]);
		$qoo += get_on_worder_qty($arrObj['stock_id'], $myrow["loc_code"]);
			
		$output = array();
		$output['stock_id'] = $arrObj['stock_id'];
		$output['reorder_level'] = $myrow["reorder_level"];
		$output['on_demand'] = $demand_qty;
		$output['qty_on_hand'] = $qoh;
		$output['on_order'] = $qoo;
		$output['available_stock'] = $qoh - $demand_qty;
		
		$result[$rec] = $output;
		$rec++;
	}
	
	return $result;	
}

/**
 * Retrieve Purchase Order Details
 * $arrObj			-	Array Object
 * $return 			-	Array Object
 */
function getPurchaseOrderItemDetails($arrObj) {
	
	$result = array();
	$rec = 0;
	
	$sql = "SELECT ".TB_PREF."purch_order_details.*, units, " .TB_PREF."stock_master.units, " .TB_PREF."stock_master.mb_flag, " .TB_PREF."stock_master.long_description, '0' as discount_percent
		FROM ".TB_PREF."purch_order_details
		LEFT JOIN ".TB_PREF."stock_master
		ON ".TB_PREF."purch_order_details.item_code=".TB_PREF."stock_master.stock_id
		WHERE order_no = " . db_escape($arrObj['order_no']) . " ORDER BY po_detail_item";
	
	$po_details = db_query($sql,"item purchase orders could not be retrieved");
	
	while ($myrow = db_fetch($po_details))
	{
		$output = array();
		//$output['id'] = $myrow['id'];		
		$output['list_price'] = $myrow['unit_price'];
		$output['product_name'] = htmlSpecialChar($myrow['description']);
		$output['comment'] = htmlSpecialChar($myrow['long_description']);
		$output['qty'] = $myrow['quantity_ordered'];
		$output['discount_percent'] = $myrow['discount_percent'] * 100; //Convert into Percentage (%)
	
		switch (trim($myrow['mb_flag'])) {
			case "B" : //Product Category
				$output['product_code'] = $myrow['item_code'];
				$output['line_item_type'] = 'Products';
				break;
			case "D" : //Services Category
				$output['service_code'] = $myrow['item_code'];
				$output['line_item_type'] = 'Services';
				break;
		}
		
		$result[$rec] = $output;
		$rec++;
	}
	
	return $result;	
}

/**
 * Retrieve Sales Order Details
 * $arrObj			-	Array Object
 * $return 			-	Array Object
 */
function getSalesOrderItemDetails($arrObj) {
	
	$result = array();
	$rec = 0;
	
	$loc_details = get_sales_order_details($arrObj['order_no'], $arrObj['trans_type']);
	
	while ($myrow = db_fetch($loc_details))
	{
		$output = array();
		//$output['id'] = $myrow['id'];		
		$output['list_price'] = $myrow['unit_price'];
		$output['product_name'] = htmlSpecialChar($myrow['description']);
		$output['comment'] = htmlSpecialChar($myrow['long_description']);
		$output['qty'] = $myrow['quantity'];
		$output['discount_percent'] = $myrow['discount_percent'] * 100; //Convert into Percentage (%)
	
		switch (trim($myrow['mb_flag'])) {
			case "B" : //Product Category
				$output['product_code'] = $myrow['stk_code'];
				$output['line_item_type'] = 'Products';
				break;
			case "D" : //Services Category
				$output['service_code'] = $myrow['stk_code'];
				$output['line_item_type'] = 'Services';
				break;
		}
		
		$result[$rec] = $output;
		$rec++;
	}
	
	return $result;	
}

/**
 * Retrieve Invoice Details
 * $arrObj			-	Array Object
 * $return 			-	Array Object
 */
function getInvoiceItemDetails($arrObj) {
	
	$result = array();
	$rec = 0;
	
	$trans_details = get_customer_trans_details($arrObj['trans_type'], $arrObj['trans_no']);
	
	while ($myrow = db_fetch($trans_details))
	{
		$output = array();
		
		$output['product_code'] = $myrow['stock_id'];
		$output['product_name'] = htmlSpecialChar($myrow['description']);
		$output['comment'] = htmlSpecialChar($myrow['long_description']);
		$output['qty'] = $myrow['quantity'];
		$output['list_price'] = $myrow['unit_price'];
		$output['full_list_price'] = $myrow['FullUnitPrice'];		
		$output['discount_percent'] = $myrow['discount_percent'] * 100; //Convert into Percentage (%)
		$output['units'] = $myrow['units'];
		$output['unit_tax'] = $myrow['unit_tax'];
		switch (trim($myrow['mb_flag'])) {
			case "B" : //Product Category
				$output['product_code'] = $myrow['stock_id'];
				$output['line_item_type'] = 'Products';
				break;
			case "D" : //Services Category
				$output['service_code'] = $myrow['stock_id'];
				$output['line_item_type'] = 'Services';
				break;
		}
		
		$result[$rec] = $output;
		$rec++;
	}
	
	return $result;	
}


/**
 * Retrieve Sys Prefs Record
 * $arrObj			-	Array Object
 * $return 			-	Array Object
 */
function getSysPrefs($arrObj) {
	
	$result = array();
	
	$sql = "SELECT name,value FROM " .TB_PREF."sys_prefs ";
	if (isset($arrObj['category']) && trim($arrObj['category']) !='') {
			$sql .=" WHERE category IN (" . "'". implode("', '", $arrObj['category']) ."'". ")";
	}

	$sys_prefs_details = db_query($sql,"item purchase orders could not be retrieved");
	
	while ($myrow = db_fetch($sys_prefs_details))
	{
		$result[$myrow['name']] = $myrow['value'];
	}
	
	return $result;	
}


/**
 * This method is to Retrieve the Single ID from dynamic sql parameters
 * @return	-	id 
 */
function getId($sqlTemp) {
	global $db;
	
	$resultTemp = db_query($sqlTemp, "Could not connect database");

	$ret = db_fetch($resultTemp);

	if (isset ($ret[0]))
		return $ret[0];

	return null;
}

/**
 * Convert special character
 * @return	-	string
 */
function htmlSpecialChar($string)
{
   		return str_replace(array('&lt;', '&gt;', '&amp;', '&#039;', '&quot;','&lt;', '&gt;'), array("<", ">",'&','\'','"','<','>'), htmlspecialchars_decode($string, ENT_NOQUOTES));
}

/**
 * Construct Array Object
 * $result			-	Database ResultSet
 * $return 			-	Array Object
 */
function mysql_fetch_full_result_array($result)
{
    $table_result=array();
    $r=0;
    while($row = mysql_fetch_assoc($result)){
        $arr_row=array();
        $c=0;
        while ($c < mysql_num_fields($result)) {       
            $col = mysql_fetch_field($result, $c);   
            $arr_row[$col -> name] = htmlSpecialChar($row[$col -> name]);           
            $c++;
        }   
        $table_result[$r] = $arr_row;
        $r++;
    }   
    return $table_result;
}
?>
