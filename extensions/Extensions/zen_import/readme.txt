/****************************************************************************
Name: Zen Cart customer and order import
Based on osCommerce order import by Tom Moulton
modified for Zen Cart 1.5.1 and FrontAccounting 2.3.15 by ckrosco
Free software under GNU GPL
*****************************************************************************/

WHAT DOES THIS MODULE DO?

This module creates a table in your FrontAccounting database containing information about your Zen Cart database including the name of the database, the username, and the password.

It may be a good idea to set up a user with readonly permissions on your Zen Cart database, and use this to access your Zen Cart data.

Once set up, this module will import data from your Zen Cart database. Customer data and order data are imported separately.

Imported orders can be accessed through the FrontAccounting "Sales" tab e.g. "Delivery Against Sales Orders", and processed accordingly.

INSTALLATION:

1. FrontAccounting -> Setup -> Install/Activate Extensions

   Click on the icon in the right column corresponding to zen_orders

   Extensions drop down box -> Activated for (name of your business)

   Click on "active" box for zen_orders -> Update

2. FrontAccounting -> Setup -> Access Setup

   Select appropriate role click on Import Zen Cart Orders header and entry -> Save Role

   Logout and log back in

3. FrontAccounting -> Banking and General Ledger -> Import Zen Cart Orders

   Click on button -> Create Table
 
   Fill in details for connecting to the Zen Cart databases -> Update Mysql

4. BEFORE IMPORTING
 
   Your inventory must be present in FrontAccounting before you can import orders, and the inventory numbers must match the product numbers of your Zen Cart products.
   
5. Customer Import must be done before Order Import

   Customer Import and Order Import will import data from the Zen Cart database and record the last customer number and order number imported.

   Your FrontAccounting inventory must correspond to your Zen Cart items before importing orders.  

----------------------------------------------------------

ZEN CART PREFIXES - IMPORTANT

This module assumes your Zen Cart database tables do not use prefixes. 
If you use prefixes, you will have to alter the code accordingly.
