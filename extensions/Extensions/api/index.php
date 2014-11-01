<?php
/**********************************************
Author: Andres Amaya
Name: SASYS REST API
Free software under GNU GPL
***********************************************/

global $security_areas, $security_groups, $security_headings, $path_to_root, $db, $db_connections;

$path_to_root = "../..";

$page_security = 'SA_API';
ini_set('xdebug.auto_trace', 2);
include_once ($path_to_root . "/modules/api/session-custom.inc");
include_once ($path_to_root . "/modules/api/Slim/Slim.php");
\Slim\Slim::registerAutoloader();

include_once ($path_to_root . "/modules/api/util.php");

include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/data_checks.inc");

$rest = new \Slim\Slim(array(
		'log.enabled' => true,
    	'mode' => 'debug',
    	'debug' => true
    ));
$rest->setName('SASYS');

// API Login Hook
api_login();

// API Routes
// ------------------------------- Items -------------------------------
// Get Items
$rest->get('/inventory/', function() use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/inventory.inc");
	inventory_all();
	
});
// Get Specific Item by Stock Id
$rest->get('/inventory/:id', function($id) use ($rest) {
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/inventory.inc");
	inventory_get($id);

});
// Add Item
$rest->post('/inventory/', function() use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/inventory.inc");
	inventory_add();
	
});
// Edit Specific Item
$rest->put('/inventory/:id', function($id) use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/inventory.inc");
	inventory_edit($id);
	
});
// Delete Specific Item
$rest->delete('/inventory/:id', function($id) use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/inventory.inc");
	inventory_delete($id);
	
});
// ------------------------------- Items -------------------------------

// ------------------------------- Inventory Movements -------------------------------
// Get Inventory Movement Types
$rest->get('/movementtypes/', function() use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/inventory.inc");
	inventory_movementstype_all();
	
});
// ------------------------------- Inventory Movements -------------------------------

// ------------------------------- Inventory Locations -------------------------------
// Get Locations
$rest->get('/locations/', function() use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/inventory.inc");
	inventory_locations_all();
	
});
// ------------------------------- Inventory Locations -------------------------------

// ------------------------------- Stock Adjustments -------------------------------
// Add Stock Adjustment
$rest->post('/stock/', function() use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/inventory.inc");
	stock_adjustment_add();
	
});
// ------------------------------- Stock Adjustments -------------------------------

// ------------------------------- Item Categories -------------------------------
// Get Items Categories
$rest->get('/category/', function() use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/category.inc");
	category_all();
	
});
// Get Specific Item Category
$rest->get('/category/:id', function($id) use ($rest) {
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/category.inc");
	category_get($id);

});
// Add Item Category
$rest->post('/category/', function() use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/category.inc");
	category_add();
	
});
// Edit Item Category
$rest->put('/category/:id', function($id) use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/category.inc");
	category_edit($id);
	
});
// Delete Item Category
$rest->delete('/category/:id', function($id) use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/category.inc");
	category_delete($id);
	
});
// ------------------------------- Item Categories -------------------------------

// ------------------------------- Tax Types -------------------------------
// Tax Types
// Get All Item Tax Types
$rest->get('/taxtypes/', function() use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/taxtypes.inc");
	taxtypes_all();
	
});
// ------------------------------- Tax Types -------------------------------

// ------------------------------- Tax Groups -------------------------------
// Tax Groups
// Get All Tax Groups
$rest->get('/taxgroups/', function() use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/taxgroups.inc");
	taxgroups_all();
	
});
// ------------------------------- Tax Groups -------------------------------

// ------------------------------- Customers -------------------------------
// Customers
// Get Customer General Info
$rest->get('/customers/:id', function($id) use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/customers.inc");
	customer_get($id);
	
});
// Add Customer
$rest->post('/customers/', function($id) use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/customers.inc");
	customer_add();
	
});
// Edit Customer
$rest->put('/customers/:id', function($id) use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/customers.inc");
	customer_edit($id);
	
});
// Delete Customer
$rest->delete('/customers/:id', function($id) use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/suppliers.inc");
	customer_delete($id);
	
});
// Get Customer Branches
$rest->get('/customers/:id/branches/', function($id) use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/customers.inc");
	customer_branches_get($id);
	
});
// ------------------------------- Customers -------------------------------

// ------------------------------- Suppliers -------------------------------
// Suppliers
// Get Supplier General Info
$rest->get('/suppliers/:id', function($id) use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/suppliers.inc");
	supplier_get($id);
	
});
// Add Supplier
$rest->post('/suppliers/', function($id) use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/suppliers.inc");
	supplier_add();
	
});
// Edit Supplier
$rest->put('/suppliers/:id', function($id) use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/suppliers.inc");
	supplier_edit($id);
	
});
// Delete Supplier
$rest->delete('/suppliers/:id', function($id) use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/suppliers.inc");
	supplier_delete($id);
	
});
// Get Supplier Contacts
$rest->get('/suppliers/:id/contacts/', function($id) use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/suppliers.inc");
	supplier_contacts_get($id);
	
});
// ------------------------------- Suppliers -------------------------------

// ------------------------------- Bank Accounts -------------------------------
// Bank Accounts
// Get All Bank Accounts
$rest->get('/bankaccounts/', function() use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/bankaccounts.inc");
	bankaccounts_all();
	
});
// Get Specific Bank Account
$rest->get('/bankaccounts/:id', function($id) use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/bankaccounts.inc");
	bankaccounts_get($id);
	
});
// ------------------------------- Bank Accounts -------------------------------

// ------------------------------- GL Accounts -------------------------------
// GL Accounts
// Get GL Accounts
$rest->get('/glaccounts/', function() use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/glaccounts.inc");
	glaccounts_all();
	
});
// Get Specific GL Account
$rest->get('/glaccounts/:id', function($id) use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/glaccounts.inc");
	glaccounts_get($id);
	
});
// Get GL Account Types
$rest->get('/glaccounttypes/', function() use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/glaccounts.inc");
	glaccounttypes_all();
	
});
// ------------------------------- GL Accounts -------------------------------

// ------------------------------- Currencies -------------------------------
// Currencies
// Get All Currencies
$rest->get('/currencies/', function() use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/currencies.inc");
	currencies_all();
	
});
// Get Specific Currency
$rest->get('/currencies/:id', function($id) use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/currencies.inc");
	currencies_get($id);
	
});
// Get Last Exchange Rate
$rest->get('/exrates/:curr_abrev', function($curr_abrev) use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/currencies.inc");
	currencies_last_exrate($curr_abrev);
	
});
// ------------------------------- Currencies -------------------------------

// ------------------------------- Inventory Costs -------------------------------
// Inventory Costs
// Get Item Cots
$rest->get('/itemcosts/:id', function($id) use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/items.inc");
	itemcosts_get($id);
	
});
// Update Item Cost
$rest->put('/itemcosts/:id', function($id) use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/items.inc");
	itemcosts_update($id);
	
});
// ------------------------------- Inventory Costs -------------------------------

// ------------------------------- Assets -------------------------------
// Fixed Assets
// Get Fixed Asset
$rest->get('/assets/:id', function($id) use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/assets.inc");
	assets_get($id);
	
});
// Insert Fixed Asset
$rest->post('/assets/', function() use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/assets.inc");
	assets_add();
	
});
// Get Asset Types
$rest->get('/assettypes/', function() use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/assets.inc");
	assettypes_get();
	
});
// ------------------------------- Assets -------------------------------

// ------------------------------- Sales Quotes -------------------------------
// Sales Quotes
// Get Sales Quote Header and Details
$rest->get('/salesquotes/:id', function($id) use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/salesquotes.inc");
	salesquotes_get($id);
	
});
// Insert Sales Quote
$rest->post('/salesquotes/', function() use ($rest){
	
	global $path_to_root;
	include_once ($path_to_root . "/modules/api/salesquotes.inc");
	salesquotes_add();
	
});
// ------------------------------- Sales Quotes -------------------------------

// Init API
$rest->run();

?>