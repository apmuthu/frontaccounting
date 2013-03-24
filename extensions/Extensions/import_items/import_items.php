<?php
/**********************************************
Author: Joe Hunt
Author: Tom Moulton - added Export of many types and import of the same
Name: Import of CSV formatted items
Free software under GNU GPL
***********************************************/
$page_security = 'SA_CSVIMPORT';
$path_to_root="../..";

include($path_to_root . "/includes/session.inc");
add_access_extensions();

include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/includes/data_checks.inc");

include_once($path_to_root . "/inventory/includes/inventory_db.inc");
include_once($path_to_root . "/inventory/includes/db/items_codes_db.inc");
include_once($path_to_root . "/dimensions/includes/dimensions_db.inc");

function get_add_workcenter($name) {
    $name = db_escape($name);
    $sql = "SELECT id FROM ".TB_PREF."workcentres WHERE UPPER( name ) = UPPER( $name )";
    $result = db_query($sql, "Can not search workcentres table");
    $row = db_fetch_row($result);
    if (!$row[0]) {
	$sql = "INSERT INTO ".TB_PREF."workcentres (name, description) VALUES ( $name, $name)";
	$result = db_query($sql, "Could not add workcenter");
	$id = db_insert_id();
        display_notification("Added $name as id $id");
    } else $id = $row[0];
    return $id;
}

function check_stock_id($stock_id) {
    $sql = "SELECT * FROM ".TB_PREF."stock_master where stock_id = $stock_id";
    $result = db_query($sql, "Can not look up stock_id");
    $row = db_fetch_row($result);
    if (!$row[0]) return 0;
    return 1;
}

function get_supplier_id($supplier) {
    $sql = "SELECT supplier_id FROM ".TB_PREF."suppliers where supp_name = $supplier";
    $result = db_query($sql, "Can not look up supplier");
    $row = db_fetch_row($result);
    if (!$row[0]) return 0;
    return $row[0];
}

function get_dimension_by_name($name) {
    if ($name = '') return 0;

    $sql = "SELECT * FROM ".TB_PREF."dimensions WHERE name=$name";
    $result = db_query($sql, "Could not find dimension");
    if ($db_num_rows($result) == 0) return -1;
    $row = db_fetch_row($result);
    if (!$row[0]) return -1;
    return $row[0];
}

function download_file($filename, $saveasname='')
{
    if (empty($filename) || !file_exists($filename))
    {
        return false;
    }
    if ($saveasname == '') $saveasname = basename($filename);
    header('Content-type: application/vnd.ms-excel');
    header('Content-Length: '.filesize($filename));
    header('Content-Disposition: attachment; filename="'.$saveasname.'"');
    readfile($filename);

    return true;
}

// change this from file to mysql $result
function download_csv($filename, $saveasname='')
{
    if (empty($filename) || !file_exists($filename))
    {
        return false;
    }
    if ($saveasname == '') $saveasname = basename($filename);
    header('Content-type: application/vnd.ms-excel');
    header('Content-Disposition: attachment; filename="'.$saveasname.'"');
// print all results, converting data as needed
    return true;
}

$action = 'import';
if (isset($_GET['action'])) $action = $_GET['action'];
if (isset($_POST['action'])) $action = $_POST['action'];

if (isset($_POST['export'])) {
    $etype = 0;
    if (isset($_POST['export_type'])) $etype = $_POST['export_type'];
    $sales_type_id = 0;
    if (isset($_POST['sales_type_id'])) $sales_type_id = $_POST['sales_type_id'];
    $currency = "USD";
    if (isset($_POST['currency'])) $currency = $_POST['currency'];
    if ($etype == 1) {
        $fname = "items.csv";
        $sql = "SELECT 'ITEM' as type, sm.stock_id as item_code, sm.stock_id, sm.description, sc.description as category, sm.units, '' as dummy, sm.mb_flag, '' as price, d.name as dimension FROM ".TB_PREF."stock_master sm left join ".TB_PREF."stock_category sc on sm.category_id = sc.category_id left join ".TB_PREF."dimensions d on sm.dimension_id = d.id left join ".TB_PREF."prices as p on sm.stock_id = p.stock_id WHERE sm.inactive = 0";
    }
    if ($etype == 2) {
        $fname = "prices_$sales_type_id.csv";
        $sql = "SELECT 'PRICE' as type, sm.stock_id, '' as dummy1, '' as dummy2, '' as dummy3, '' as dummy4, '' as dummy5, '' as dummy6, p.curr_abrev as currency, p.price FROM ".TB_PREF."stock_master sm left join ".TB_PREF."prices p on sm.stock_id = p.stock_id where sm.inactive = 0 AND p.sales_type_id = $sales_type_id";
    }
    if ($etype == 3) {
        $fname = "supp_prices.csv";
        $sql = "SELECT 'BUY' as type, pd.stock_id, '' as dummy, pd.supplier_description, s.supp_name as supplier, pd.suppliers_uom, pd.conversion_factor, '' as dummy1, '" . $currency ."', pd.price from ".TB_PREF."purch_data pd left join ".TB_PREF."suppliers s on pd.supplier_id = s.supplier_id where 1";
    }
    if ($etype == 4) {
        $fname = "uom.csv";
        $sql = "SELECT 'UOM' as type, abbr, name, '' as dummy1, '' as dummy2, '' as dummy3, decimals, '' as dummy4, '' as dummy5, '' as dummy6 FROM ".TB_PREF."item_units WHERE `inactive` = 0";
    }
    if ($etype == 5) {
        $fname = "kits.csv";
        $sql = "SELECT 'KIT' as type, i.item_code, i.stock_id, i.description, sc.description as category, '' as dummy, i.quantity, '' as dummy1, '' as dummy2, '' as dummy3 FROM ".TB_PREF."item_codes i left join ".TB_PREF."stock_category sc on i.category_id = sc.category_id WHERE i.item_code <> i.stock_id and i.is_foreign = 0 and i.inactive = 0";
    }
    if ($etype == 6) {
        $fname = "bom.csv";
        $sql = "SELECT 'BOM' as type, b.parent, b.component, b.loc_code, '' as dummy1, '' as dummy2, b.quantity, '' as dummy3, '' as dummy4, '' as dummy5 from ".TB_PREF."bom b left join ".TB_PREF."stock_master sm on sm.stock_id = b.parent where sm.inactive = 0";
    }
    if ($etype == 7) {
        $fname = "foreign.csv";
        $sql = "SELECT 'FOREIGN' as type, i.item_code, i.stock_id, i.description, sc.description as category, '' as dummy, i.quantity, '' as dummy1, '' as dummy2, '' as dummy3 FROM ".TB_PREF."item_codes i left join ".TB_PREF."stock_category sc on i.category_id = sc.category_id WHERE i.inactive = 0 AND i.is_foreign = 1";
    }

    $result = db_query($sql, "Could not select csv data");
    if (db_num_rows($result) > 0) {
        // header('Content-type: application/vnd.ms-excel');
        header('Content-type: text/x-csv');
        header('Content-Disposition: attachment; filename='.$fname);
        $i = 0;
        while ($csv = db_fetch_assoc($result)) {
            $hdr = '';
            $str = '';
            while (list($k, $d) = each($csv)) {
                if ($i == 0) $hdr .= $k . ",";
                $str .= htmlspecialchars_decode($d) . ",";
            }
            if ($i == 0) echo $hdr . "\n";
            echo $str."\n";
            $i++;
        }
        exit;
    } else display_notification("No Results to download.");
}

page("Import of CSV formatted Items");

if (isset($_POST['import'])) {
	if (isset($_FILES['imp']) && $_FILES['imp']['name'] != '') {
		$filename = $_FILES['imp']['tmp_name'];
		$sep = $_POST['sep'];

		$fp = @fopen($filename, "r");
		if (!$fp)
			die("can not open file $filename");

		$lines = $i = $j = $k = $b = $u = $p = $pr = $dm_n = 0;
		// type, item_code, stock_id, description, category, units, qty, mb_flag, currency, price
		while ($data = fgetcsv($fp, 4096, $sep)) {
			if ($lines++ == 0) continue;
			list($type, $code, $id, $description, $category, $units, $qty, $mb_flag, $currency, $price) = $data;
			$type = strtoupper($type);
			$mb_flag = strtoupper($mb_flag);

			if ($type == 'NOTE') continue; // a comment
			if ($type == 'BOM') {
			    $parent = db_escape($code);
			    $component = db_escape($id);
			    if (check_stock_id($component)) {
			        $workcenter = get_add_workcenter($description);
			        $sql = "SELECT * FROM ".TB_PREF."bom WHERE parent = UPPER( $parent ) and component = UPPER( $component )";
			        $result = db_query($sql, "Could not search BOM");
			        $row = db_fetch_row($result);
			        if (!$row[0]) $sql = "INSERT INTO ".TB_PREF."bom (parent, component, workcentre_added, loc_code, quantity) VALUES ($parent, $component, $workcenter, '{$_POST['location']}', $qty)";
			        else $sql = "UPDATE ".TB_PREF."bom SET workcentre_added = $workcenter, loc_code = '{$_POST['location']}', quantity = $qty WHERE parent = $parent AND component = $component";
			        db_query($sql, "Error adding/updating BOM");
			        $b++;
			    } else display_notification("Line $lines: BOM Component $component must be a STOCK_ID not ITEM_CODE");
			}

			if ($type == 'UOM') {
			    $abbr = db_escape($code);
			    $name = db_escape($id);
			    $dec = db_escape($qty);
			    $sql = "SELECT * FROM ".TB_PREF."item_units WHERE UPPER( abbr ) = UPPER( $abbr )";
			    $result = db_query($sql, "Unable to find units");
			    $row = db_fetch_row($result);
			    if (!$row[0]) $sql = "INSERT INTO ".TB_PREF."item_units (abbr, name, decimals) VALUES ( $abbr, $name, $dec )";
			    else $sql = "UPDATE ".TB_PREF."item_units SET decimals = $dec where abbr = $abbr";
			    db_query($sql, "Failed adding/updating UOM");
			    $u++;
			}
			if ($type == 'ITEM' || $type == 'KIT' || $type == 'FOREIGN') {
			    $sql = "SELECT category_id, description FROM ".TB_PREF."stock_category WHERE description='$category'";

			    $result = db_query($sql, "could not get stock category");

			    $row = db_fetch_row($result);
			    if (!$row) {
				add_item_category($category);
				$cat = db_insert_id();
			    } else $cat = $row[0];
			}
		        // type, item_code, stock_id, description, category, units, qty, mb_flag, currency, price
			if ($type == 'KIT' || $type == 'FOREIGN') { // Sales Kit or Foriegn Item Code
			    if ($type == 'FOREIGN') $foreign = 1;
			    else $foreign = 0;
			    $sql = "SELECT id from ".TB_PREF."item_codes WHERE item_code='$code' AND stock_id = '$id'";
			    $result = db_query($sql, "item code could not be retreived");
			    $row = db_fetch_row($result);
			    if (!$row) add_item_code($code, $id, $description, $cat, $qty, $foreign);
			    else update_item_code($row[0], $code, $id, $description, $cat, $qty, $foreign);
			    $k++;
			}
			if ($type == 'ITEM') {
                            $dim = 0;
                            if ($qty != '') {
			        $dim = get_dimension_by_name($qty);
                                if ($dim == -1) {
                                    $date = Today();
                                    $due = add_days($date, sys_prefs::default_dimension_required_by());
                                    $ref = references::get_next(systypes::dimension());
                                    $dim = add_dimension($ref, $qty, 1, $date, $due, "Added due to Item Import");
                                    $dim_n++;
                                }
                            }
			    $sql = "SELECT stock_id FROM ".TB_PREF."stock_master WHERE stock_id='$id'";
			    $result = db_query($sql,"item could not be retreived");
			    $row = db_fetch_row($result);
			    if (!$row) {
				    $sql = "INSERT INTO ".TB_PREF."stock_master (stock_id, description, long_description, category_id,
					    tax_type_id, units, mb_flag, sales_account, inventory_account, cogs_account,
					    adjustment_account, assembly_account, dimension_id, dimension2_id)
					    VALUES ('$id', " . db_escape($description) . ", '',
					    '$cat', {$_POST['tax_type_id']}, '$units', '$mb_flag',
					    '{$_POST['sales_account']}', '{$_POST['inventory_account']}', '{$_POST['cogs_account']}',
					    '{$_POST['adjustment_account']}', '{$_POST['assembly_account']}', $dim, 0)";

				    db_query($sql, "The item could not be added");
				    if ($mb_flag != "S") {
					    $sql = "INSERT INTO ".TB_PREF."loc_stock (loc_code, stock_id) VALUES ('{$_POST['location']}', '$id')";

					    db_query($sql, "The item locstock could not be added");
				    }

				    $i++;
			    } else {
				    $sql = "UPDATE ".TB_PREF."stock_master SET long_description='',
					    description=" . db_escape($description) .",
					    category_id='$cat',
					    sales_account='{$_POST['sales_account']}',
					    inventory_account='{$_POST['inventory_account']}',
					    cogs_account='{$_POST['cogs_account']}',
					    adjustment_account='{$_POST['adjustment_account']}',
					    assembly_account='{$_POST['assembly_account']}',
					    dimension_id=$dim,
					    dimension2_id=0,
					    units='$units',
					    mb_flag='$mb_flag',
					    tax_type_id={$_POST['tax_type_id']}
					    WHERE stock_id='$id'";

				    db_query($sql, "The item could not be updated");
				    display_notification("Line $lines: Update $id $descriptiont");
				    $j++;
			    }
			    $sql = "SELECT id from ".TB_PREF."item_codes WHERE item_code='$code' AND stock_id = '$id'";
			    $result = db_query($sql, "item code could not be retreived");
			    $row = db_fetch_row($result);
			    if (!$row) add_item_code($code, $id, $description, $cat, 1);
			    else update_item_code($row[0], $code, $id, $description, $cat, 1);
			}

			if ($type == 'ITEM' || $type == 'KIT' || $type == 'PRICE') {
			    if (isset($price) && $price != "") {
			        if ($currency == "") $currency = get_company_pref("curr_default");
			        else {
				    $row = get_currency($currency);
				    if (!$row) add_currency($currency, "", "", "", "");
			        }

				$sql = "SELECT * FROM ".TB_PREF."prices	WHERE stock_id='$code' AND sales_type_id={$_POST['sales_type_id']} AND
					curr_abrev='$currency'";

				$result = db_query($sql,"price could not be retreived");

				$row = db_fetch_row($result);
				if (!$row) add_item_price($code, $_POST['sales_type_id'], $currency, $price);
				else update_item_price($row[0], $_POST['sales_type_id'], $currency, $price);
				$pr++;
			    }
			}
			if ($type == 'BUY') {
				$code = db_escape($code);
				if (check_stock_id($code)) {
					$supplier_id = get_supplier_id(db_escape($category));
					if ($supplier_id == 0) display_notification("Supplier $category not found");
					else {
						$sql = "SELECT stock_id from ".TB_PREF."purch_data where supplier_id=$supplier_id AND stock_id=$code";
						$result = db_query($sql, "Could not lookup supplier purchasing data");
						$row = db_fetch_row($result);
						$descr = db_escape($description);
						$units = db_escape($units);
						$units = (int)$units;
						if ($units <= 0) $units = 1;
						if (!$row) $sql = "INSERT INTO ".TB_PREF."purch_data
							(supplier_id, stock_id, price, suppliers_uom, conversion_factor,
							supplier_description)
							VALUES ($supplier_id, $code, $price, $units, $qty, $descr)";
						else $sql = "UPDATE ".TB_PREF."purch_data SET price = $price,
							supplier_description = $descr, suppliers_uom = $units,
							conversion_factor = $qty
							WHERE supplier_id=$supplier_id AND stock_id=$code";
						db_query($sql, "Could not update supplier data");
					}
					$sql = "SELECT material_cost FROM ".TB_PREF."stock_master WHERE stock_id = $code";
					$result = db_query($sql);
					$myrow = db_fetch($result);
					$material_cost =  $myrow['material_cost'];
					if ($material_cost == 0 && isset($price) && $price != "") {
						if ($qty <= 0) $qty = 1;
						$my_price = $price / $qty;
						$sql = "UPDATE ".TB_PREF."stock_master SET material_cost = $my_price WHERE stock_id = $code";
						$result = db_query($sql);
					}
					$p++;
				} else display_notification("Stock Code $code does not exist");
			}
		}
		@fclose($fp);

		if ($i+$j > 0) display_notification("$i item posts created, $j item posts updated.");
		if ($dim_n > 0) display_notification("$dim_n Item Dimensions added.");
		if ($k > 0) display_notification("$k sales kit components added or updated.");
		if ($b > 0) display_notification("$b BOM components added or updated.");
		if ($u > 0) display_notification("$u Units of Measure added or updated.");
		if ($p > 0) display_notification("$p Purchasing Data items added or updated.");
		if ($pr > 0) display_notification("$pr Prices items added or updated for " . $_POST['sales_type_id']);

	} else display_error("No CSV file selected");
}

if ($action == 'import') echo 'Import';
else hyperlink_params($_SERVER['PHP_SELF'], _("Import"), "action=import", false);
echo '&nbsp;|&nbsp;';
if ($action == 'export') echo 'Export';
else hyperlink_params($_SERVER['PHP_SELF'], _("Export"), "action=export", false);
echo "<br><br>";

if ($action == 'import') {
    start_form(true);

    start_table(TABLESTYLE2, "width=40%");

    table_section_title("Default GL Accounts");

    $company_record = get_company_prefs();

    if (!isset($_POST['inventory_account']) || $_POST['inventory_account'] == "")
   	$_POST['inventory_account'] = $company_record["default_inventory_act"];

    if (!isset($_POST['cogs_account']) || $_POST['cogs_account'] == "")
   	$_POST['cogs_account'] = $company_record["default_cogs_act"];

    if (!isset($_POST['sales_account']) || $_POST['sales_account'] == "")
	$_POST['sales_account'] = $company_record["default_inv_sales_act"];

    if (!isset($_POST['adjustment_account']) || $_POST['adjustment_account'] == "")
	$_POST['adjustment_account'] = $company_record["default_adj_act"];

    if (!isset($_POST['assembly_account']) || $_POST['assembly_account'] == "")
	$_POST['assembly_account'] = $company_record["default_assembly_act"];
    if (!isset($_POST['sep']))
	$_POST['sep'] = ",";

    gl_all_accounts_list_row("Sales Account:", 'sales_account', $_POST['sales_account']);
    gl_all_accounts_list_row("Inventory Account:", 'inventory_account', $_POST['inventory_account']);
    gl_all_accounts_list_row("C.O.G.S. Account:", 'cogs_account', $_POST['cogs_account']);
    gl_all_accounts_list_row("Inventory Adjustments Account:", 'adjustment_account', $_POST['adjustment_account']);
    gl_all_accounts_list_row("Item Assembly Costs Account:", 'assembly_account', $_POST['assembly_account']);

    table_section_title("Separator, Location, Tax and Sales Type");
    text_row("Field separator:", 'sep', $_POST['sep'], 2, 1);
    locations_list_row("To Location:", 'location', null);
    item_tax_types_list_row("Item Tax Type:", 'tax_type_id', null);
    sales_types_list_row("Sales Type:", 'sales_type_id', null);
    label_row("CSV Import File:", "<input type='file' id='imp' name='imp'>");

    end_table(1);

    submit_center('import', "Import CSV File");

    end_form();
}
if ($action == 'export') {
    start_form(true);

    start_table(TABLESTYLE2, "width=40%");

    $company_record = get_company_prefs();
    $currency = $company_record["curr_default"];
    hidden('currency', $currency);

    table_section_title("Export Selection");
?>
<tr>
<td>Export Type:</td>
<td><select  name='export_type' class='combo' title='' >
<option value='1'>Item</option>
<option value='2'>Price List</option>
<option value='3'>Purchase Price</option>
<option value='4'>Units of Measure</option>
<option value='5'>Kit</option>
<option value='6'>Bill of Materials</option>
<option value='7'>Foreign Item Codes</option>
</select>
</td>
</tr>
<?php
    sales_types_list_row("Sales Type (for Price Lists):", 'sales_type_id', null);

    end_table(1);

    hidden('action', 'export');
    submit_center('export', "Export CSV File");

    end_form();
}

    end_page();
?>
