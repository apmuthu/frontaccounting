/****************************************************************************
Author: Tom Hallman
Name: Import Multiple Journal Entries v2.3
Free software under GNU GPL
*****************************************************************************/

/////////////////
// Installation

1) If you haven't already, unzip the file 'import_multijournalentries22.zip'.
2) In FrontAccounting, choose Setup > Install/Activate Extensions.
3) Recommended settings for installation:
   - Name: Import Multiple Journal Entries
   - Folder: import_multijournalentries  (should follow unix folder convention)
   - Menu Tab: Banking and General Ledger
   - Menu Link Text: Import Multiple Journal Entries
   - Module file: import_multijournalentries.php  (from unzipped extension file)
   - Access Levels Extensions: acc_levels.php  (from unzipped extension file)
   - Click "Add new" (or "Update" if upgrading from a previous version)
4) Make sure the extension is activated by clicking the "Extensions" drop-down
   box at the top of the page and selecting "Activated for..."

////////////////
// File Format

This extension imports CSV files of the following format:
entryid,date,reference,accountcode,dimension1,dimension2,amount,memo

- 'entryid' can be any value, so long as it differs from all other entryids
  in the import file.  Every entryid will result in a separate journal entry
  being created with the specified transaction data within it.  
  Transactions with the same entryid must be grouped together within the
  import file.
- 'date' and 'reference' should be the same throughout a given entry.
- For proper use of all of these fields (except 'entryid'), see the 
  Journal Entry entry dialog within FrontAccounting under Banking and 
  General Ledger.
- entryid does *not* correspond to what the journal entry id will be within
  FrontAccounting. 

In the case above, the separator is a comma (,) though any separator will work.

Example import file:
entryid,date,reference,accountcode,dimension1,dimension2,amount,memo
1,10/5/2009,TD-1,10002,MyDim,,945.59,"My memo"
1,10/5/2009,TD-1,5600,MyDim2,,-400,""
1,10/5/2009,TD-1,5602,MyDim2,,-545.59,""
2,10/7/2009,TD-2,5602,,,-100,""
2,10/7/2009,TD-2,5602,MyDim,,100,"Reimbursement"

This file will result in two journal entries:
- One dated 10/5/2009 with reference TD-1 and three transactions
- One dated 10/7/2009 with reference TD-2 and two transactions

Note 1: Dimensions are expressed in references, not IDs!

Note 2: It is wise to enclose memos in double quotes ("my memo") so that
        it will be parsed properly in case it contains the field separator.

////////////////////////
// Using the Extension

Once you have an import file, open this extension.  (If you used the defaults,
it will be under Banking and General Ledger toward the bottom right.)

1) Select the field separator (a comma by default).
2) Select the import file.
3) Click "Perform Import".

/////////////
// Language

The language used inside this extension does NOT follow the traditional GETTEXT
translations found in most of FrontAccounting.  If you want to translate to
another language, please modify the import file directly.

/////////////////
// Improvements
 
If you make improvements to this extension, please share it with the rest of us! 
We will then incorporate it into the extension.
