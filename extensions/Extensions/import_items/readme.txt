/****************************************************************************
Author: Joe Hunt
Name: Import of CSV formatted items
Free software under GNU GPL
*****************************************************************************/

--------------------------------------------------------------------------------
Version 2.2 by Tom Moulton 1/15/2010

Supports import/export for FA 2.3

Fixed bug for BUY (Purchasing Price Import)

--------------------------------------------------------------------------------
VERSION 2 by Tom Moulton 5/2009

This version supports importing Items, Sales Kits and BOM

The fields used will be different depending upon what is being imported.
It will still be a good idea to have a fixed number of (empty) fields to keep parsing simple.

The first field is the record type and that will decide what the rest of the line means.

TYPE = BOM

BOM;PARENT;COMPONENT;WORK CENTER;dummy;dummy;QUANTITY;dummy;dummy;dummy;

The loc_code will be selected from a Pull-Down menu as a default for the entire import.
The work center will be added if needed.

TYPE = UOM

UOM;ABBR;NAME;dummy;dummy;dummy;DECIMAL PLACES;dummy;dummy;dummy;

TYPE = KIT

KIT;ITEM_CODE;STOCK_ID;Description;Category;dummy;Quantity;dummy;Currency;Price;

Where ITEM_CODE is the code for a Kit and Stock_id is a part of that kit (Quantity each)
The Currency and Price, if present will update the price of the kit.


TYPE = FOREIGN

FOREIGN;ITEM_CODE;STOCK_ID;Description;Category;dummy;Quantity;dummy;dummy;dummy;

Where ITEM_CODE is the upc/etc code for an item and Stock_id is the item as we know it

ITEM;ITEM_CODE;STOCK_ID;Description;Category;units;dummy;MB_FLAG;Currency;Price;

Where Item_Code = STOCK_ID of the item.

TYPE = BUY

BUY;STOCK_ID;dummy;Description;Supplier Name;Supplier Units;Conversion Factor;dummy;Currency;Price;

Where Supplier must alrady exist

The rest should be as described elsewhere.

-----
ITEM Export

SELECT 'ITEM', sm.stock_id as item_code, sm.stock_id, sm.description, sc.description as category, sm.units, '' as dummy, sm.mb_flag, p.price, d.name as dimension FROM `4_stock_master` sm left join `4_stock_category` sc on sm.category_id = sc.category_id left join `4_dimensions` d on sm.dimension_id = d.id left join 4_prices as p on sm.stock_id = p.stock_id WHERE sm.inactive = 0

BOM

SELECT b.parent, b.component, b.loc_code, '' as dummy1, '' as dummy2, b.quantity, '' as dummy3, '' as dummy4, '' as dummy5 from 4_bom b left join 4_stock_master sm on sm.stock_id = b.parent where sm.inactive = 0 


UOM

SELECT 'UOM', abbr, name, '' as dummy1, '' as dummy2, '' as dummy3, decimals, '' as dummy4, '' as dummy5, '' as dummy6 FROM `4_item_units` WHERE `inactive` = 0

KIT - To Do


FOREIGN

SELECT * FROM `4_item_codes` WHERE `is_foreign` = 1 and `inactive` = 0

==============================================
=======================================
Version 1 by Joe Hunt

Recommended settings during install:

Menu Tab: Items and Inventory

Name: Import of CSV formatted items

Folder: import_items   (should follow unix folder convention)

Browse for the file: import_items.php on you local harddisk.

Press the Install button.

--- Before you use the Import Items module ---

Do a Company Backup from the Setup tab, Backup and Restore.

The comma separated file should be of the following type:
1. line should contain the following description: 

id; description; category; units; mb_flag; currency; price;

In this case the separator is ';', id is the Stock ID, description is the Stock description,
category is a category you want to put your Stock. If this category doesn't exist it will
be created during import. units is the unit for the Stock. 

The mb_flag is M for Manufacturered, B for Purchased or S for Service (no inventory)

currency is the currency for the price.
Leave empty for company currency.
price is the stock price. If you don't want the price to be entered, leave it empty.

Example of a CSV import file:

id; description; category; units; mb_flag; currency; price;
21; Item21; MyCat; each; B; ; 300;
22; Item22; MyCat; each; B; ; 200;
23; Item23; MyCat; each; B; ; 300;
24; Item24; MyCat; each; B; ; 200;
25; Item25; MyCat; each; B; ; 300;
26; Item26; MyCat; each; B; ; 200;

When the Import file is ready (you might prepare it in a spreadsheet if it is a huge one),
you are ready to go into the Import Module via Items and Inventory, right section.
First you see the default accounts for the various operations for the stocks. Leave them
as is, if you are satisfied with them.
The field separator is set to ';'. If you have used another separator, select it here.
Be aware, that if you have chosen ',' as a separator, you should enclose the fields with
double quotes ("Item21") because it might be common to put a comma inside a description.
Next you should select a Location to put the stocks into (the 'B' ones), Item Tax Type and
Sales Type. Last you browse to the CSV file and put it here.

If the items exist, they will be updated with the information here.

Now you are ready to press the Import CSV file button (Did you take a backup??)

Have fun!!

PS. The language inside the Import CSV file does NOT follow the traditional GETTEXT translations.
If you want to translate to another language, please rename the texts inside the file 
import_items.php to your own language. 
If you make improvements to this module, please share it with us!!. 
We will then incorporate it into the module.

Contributor: Tom Moulton

Upgrade code to v2.1 database, perform same actions done during upgrade to create item_codes table

Also here is osCommerce SQL to dump items.

Remember to add trailing ";", also extra spaces on non-quoted strings may be a problem.

SELECT p.products_model, pd.products_name, cd.categories_name, 'each', 'B', 'USD', p.products_price FROM
products p left join products_description pd on p.products_id = pd.products_id and pd.language_id = 1
left join products_to_categories pc on p.products_id = pc.products_id
left join categories_description cd on pc.categories_id = cd.categories_id and cd.language_id = 1
where p.products_status = 1

The mb_flag is M for Manufacturered, B for Purchased or S for Service

tom
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
