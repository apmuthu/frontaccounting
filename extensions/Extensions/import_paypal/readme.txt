// ----------------------------------------------------------------
// $ Revision:  1.1 $
// Creator: Alastair Robertson (frontaccounting@kwikpay.co.nz)
// date_:   2012-04-08
// Title:   Import PayPal transactions
// Free software under GNU GPL
// ----------------------------------------------------------------


Summary:
---------

This module provides reads a CSV file of transaction history downloaded from a PayPal account and imports them into FrontAccounting. 

- Receipts are imported either as simple bank receipts or it can create customers, sales orders, invoices, payments and allocate the payments to the invoices. 
- Payments from the PayPal account to third parties are displayed on a form to collect the expense account for the payment. The expense account and payee are saved so the account can be provided as a default if a payment is made to the same payee in a future import.
- Withdrawals from the PayPal account are processed as bank transfers to a nominated bank account

The module activation creates two tables:
- import_paypal which temporarily stores imported payment transactions for expense accounts to be added
- import_paypal_accounts which permanently saves the expense account selected for each payee/memo

NOTE: is the option to create invoices is selected, the item codes defined in FA must be the same as the item codes used in PayPal.

PayPal Import Options:
---------------------

This form is added to the Setup menu.

Create Customers/Invoices: tick this check box if you want to create customer records and invoices for each payment received, otherwise only a bank deposit will be created for each payment received
Use Paypal Transaction Id: tick this box to us the PayPal transaction reference in all FA transactions
Receipts Date Today: tick this box if you want to record all receipts with today's date

PayPal File

Company Name Column: enter the name of the PayPal CSV file column that contains the customer's company name. If this is bank, the CSV file Name columne will be used as the customer's company name

Customers

Sales Type: default sales type for customer records created by the import
Sales Person: default salesman for created customers
Sales Area: default sales area for created customers
Credit Status: default credit status
Default Location: default inventory location
Default Shipper: default shipper for sales orders

Accounts

Bank Account: bank account created for PayPal transactions
Sales Account: default sales account for bank receipts
Sales Tax Account: default sales tax account for bank receipt tax lines
Shipping Account: used in bank receipts if PayPal transaction includes a shipping fee
Insurance Account: used in bank receipts if PayPal transaction includes an insurance amount
Withdrawal Account: bank account to which PayPal withdrawals are transferred

Tax

Add Tax to Receipts: tick this box if the PayPal transaction does not include sales tax, but you need to account for sales tax in the bank receipt
Tax Included in Paypal Amount: tick this box if the PayPal payment transaction is gross
Default Tax Type: tax type to use for generated tax calculations
Default Tax Group: tax group  to use for generated tax calculations
Default Item Tax Group: item tax group  to use for generated tax calculations

PayPal Import Transactions:
---------------------------

This form is added to the Banking and General Ledger menu.

The first step requests the file to import. This file is created from the PayPal history download page, after selecting CSV - all activity as the file format.

A first pass of the file extracts any payment transactions to a temporary table, and if there are any, then displays all the payment transactions, with a selection list to accept the payment's expense account. When all payments have had expense accounts selected, or there are no payments requiring expense accounts, the file is then processed on a second pass.

PayPal Payments:
A bank payment is created for each payment, with the expense selected account.

PayPal Receipts:
If the customer/invoice options was selected in the setup, a customer, branch and contact is created for each receipt, followed by a direct sales invoice, a customer payment and allocation.
If the customer/invoice setup option was not ticked, a bank receipt is created, crediting the sales account specified in the setup, plus the shipping account if the receipt included a shipping amount, and an insurance account line if the receipt included an insurance amount. If the 'add tax to receipts' option was selected, tax is calculated and added to the transaction. Any paypal fees are debited to the fees account and net receipt debited to the paypal bank account.

PayPal Withdrawals:
A bank transfer is created crediting the PayPal account and debiting the destination bank account.

Revision:
---------
1.1  Reorganise processing to reduce memory usage: create customer records in first pass
     Update function calls for FA 4.3.18 changes
	 