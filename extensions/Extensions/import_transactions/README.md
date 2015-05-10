## import_transactions

### Front Accounting (version 2.3.21 onwards): 
Import transactions from csv in 
* journal format, 
* payment format, 
* deposit format, or 
* adapted bank statement format.

### About Extension
* **Author:** Ross Addison <frontaccounting@bbqq.co.uk>
* **Source Code Repo:** https://github.com/rossaddison/import_transactions
* **Forum Post:** http://frontaccounting.com/punbb/viewtopic.php?id=5396
* **Compatibility:** FA v2.3.22+

### Features: 
* Trial check before importing. 
* Tabular display of journal entries, journals displayed as debits and credits using Front Accounting's 'items cart' class. 
* Importing of bank statements with additional columns for spreadsheet adjusted associated transaction account codes, customer, or supplier id's. 
* Additional Tax type column for VAT registered companies for vat inclusive income or expenses. 
* Inclusion of transactions automatically in an audit trail. 
* Display notifications identifying how tables within the database are being affected for a more transparent display to interested programmers. 
* Additional lookup tools for looking up customer id's, supplier id's, company setup information eg. fiscal year, and other tools that users will find useful for inclusion in their spreadsheet prior to conversion to csv. 
* Suitable validation checks for customers, suppliers, tax codes, references. 
* Multiline or singleline invoices can be imported. 
* Invoices can be either cash or credit. The payment id lookup tool should be used to determine what number you will associate with either cash or credit invoices.  For cash invoices, the payment id of 4 is used, and for credit invoices, arbitrarily 1 is used instead of 2 or 3.
* Example csv files are provided for each format, both for multiline and single line invoices. These can be used to test the package, and as templates for your own use.
* Line 65 in **import_transactions.php** (**all_delete($yes=false);**) can be removed after testing.
	