/****************************************************************************
Name: Zen Cart customer and order import
Based on osCommerce order import by Tom Moulton
modified for Zen Cart 1.3.9h and FrontAccounting 2.3.2 by ckrosco
Free software under GNU GPL
*****************************************************************************/

1. Unzip and upload entire /zen_orders directory to Frontaccounting /modules directory
  
2. FrontAccounting -> Setup -> Install/Activate Extensions

   Click on the icon in the right column corresponding to zen_orders

   Extensions drop down box -> Activated for (name of your business)

   Click on "active" box for zen_orders -> Update

3. FrontAccounting -> Setup -> Access Setup

   Select appropriate role click on Import Zen Cart Orders header and entry -> Save Role

   Logout and log back in

4. FrontAccounting -> Banking and General Ledger -> Import Zen Cart Orders

   Click on button -> Create Table
   
   Click on Configuration
 
   Fill in details for connecting to the Zen Cart databases -> Update Mysql

5. Customer Import must be done before Order Import

   Customer Import and Order Import will import data from the Zen Cart database and record the last customer number and order number imported.

   Your FrontAccounting inventory must correspond to your Zen Cart items before importing orders.  

----------------------------------------------------------

ZEN CART PREFIXES - IMPORTANT

This module assumes that the Zen Cart database tables don't use prefixes.
If you use prefixes, you will have to alter the code accordingly.