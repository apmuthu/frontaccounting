// ----------------------------------------------------------------
// $ Revision:  1.2 $
// Creator: Alastair Robertson (frontaccounting@kwikpay.co.nz)
// date_:   2011-10-22
// Title:   Cash basis tax reporting
// Free software under GNU GPL
// ----------------------------------------------------------------
/
Summary:
--------
This module provides a summary total inquiry screen and detail report for tax reporting on a cash basis.

It was created with New Zealand's simple GST tax system in mind, but is likely to work reasonably well in other jurisdictions as well. It reports payments and receipts that include a tax component when the transaction was recorded in the bank account, rather than when the sale or purchase was invoiced. For New Zealand the default reporting is on a gross basis, rather than net so the inquiry screen and detail report have the option of reporting on a gross (before tax is deducted), or net (after tax is deducted) and defaults to gross basis.

Implementation:

The reports uses the FA trans_tax_details table to identify transactions including a tax component. Separate queries are created to extract:

outputs:
- bank receipts for sales invoices, where the tax value is proportioned by the banked amount to invoice total ratio
- bank receipts for other transactions including a tax component such as cash sales
- bank payments to customers to reduce outputs by the value of refunds

inputs:
- bank payments for purchase invoices, where the tax is proportioned by the payment amount to invoice total ratio
- bank payments for other transactions including a tax component such as cash expenses
- bank receipts from suppliers to reduce inputs by the value of refunds

Revisions:
----------
1.1  customer payments were net of bank fee
1.2  Fix part allocation of customer/supplier invoice
     Use tax period default dates for report