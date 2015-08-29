// ----------------------------------------------------------------
// $ Revision:  1.1 $
// Creator: Alastair Robertson (frontaccounting@kwikpay.co.nz)
//			Based on TCLim's suggestions in the FA forum, 
//			and Joe Hunt's Exclusive theme
//			and the work of many others
// date_:   2013-02-17
// Title:   Dashboard module
// Free software under GNU GPL
// ----------------------------------------------------------------


Summary:
---------

This module provides setup and support functions for the Dashboard theme. Both require each other to work. You need to install both the Dashboard module and Dashboard theme. 

The Dashboard theme changes each application main page into a dashboard displaying a number of widgets. 

Each widget can be configured separately for each user of the system. All users should be given 'Dashboard Setup' access so they can select which widgets are displayed on each page, and the information the widget contains.

Bank Balances:
-------------
This displays a list of all the bank accounts with their balance as at today.

Bank Transactions:
-----------------
This widget displays  a table similar to the Bank Account Inquiry screen. In the configuration you can select which bank account, and how many days in the past and future are to be displayed.

Customers:
---------
Lists the top x customers by sales in the current fiscal year, either as a table or column chart.

Daily Bank Balances:
-------------------
Displays a table of a selected bank accounts balances for a specified period. It can be displayed as a table, line or bar chart.

Daily Sales:
-----------
This lists the gross sales for each day of the week, as a table, line or bar chart.

Dimensions:
----------
This lists GL totals by dimension as a table or pie chart.

GL Return:
----------
This shows the total assets, liabilities, equity, income and expenses with the total return, as either a table or pie chart.

Items:
------
Lists the top x product items either sold or manufactured, as a table or pie chart.

Purchase Invoices:
-----------------
Lists the top x outstanding purchase invoices as a table or column chart

Reminders:
---------
This shows a list of tasks that you can maintain by user role, with a date required and frequency. Go to Setup, Reminder Setup to define the reminder tasks for all roles. For each user, the reminder widget displays the outstanding tasks, with overdue tasks shown in red, today's tasks in blue and future tasks in black. When the user clicks on the task actioned check box, the next date for the task will be set according to it's defined frequency, and it is removed from the user's reminder list.

Sales Invoices:
--------------
Lists the top x outstanding sales invoices as a table or column chart

Suppliers:
---------
Lists the top x suppliers by purchases in the current fiscal year, either as a table or column chart.

Weekly Sales:
-----------
This lists the gross sales for each week, as a table, line or bar chart.


Revision:
---------
1.1  Fix sql table definition, changing tinyint(4) to tinyint(1) and remove autoincrement initialisation
     Bank balances widget showing yesterday's balance
	 Customers widget add link to customer transactions
	 Suppliers widget add link to supplier transactions
	 Daily bank balances widget not working for secondary companies, add link to bank transactions
	 Reminder rescheduling not working for periods greater than 1 month, week or day