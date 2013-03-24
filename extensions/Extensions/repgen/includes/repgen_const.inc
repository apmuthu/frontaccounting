<?php
/* Include Datei repgen_const.inc for PHP Report Generator
   Bauer, 22.1.2002
   Version 0.2
*/

/*   REPGEN constants. For other language copy the file <language>.inc over repgen_const.inc
*/
$GetText->add_domain($_SESSION['language']->code, $path_to_root.'/modules/repgen/lang');

// used in repgen_main
define("CREATE",_("Create a Report")); // button create
define("SELECT",_("Select a report for work")); // button select
define("FIRST",_("we need some data, please insert:"));

// used in repgen_select
define ("CHANGE" , _("Edit"));  // Constant for change button value
define ("DELETE" , _("Delete")); // Constant for delete Butteon value
define ("COPY" , _("Copy")); // Constant for copy Button value
define ("COPYV" , _("Cp of")); // Constant for copy-text
define ("SEL_SELECT",_("If you want to change or delete a stored report, then
choose beneath."));
define ("SEL_COLOR",_("(Green are the Blocks, orange the Functions and gray the reports shown.)"));
                                           // table heads
define ("SHORT" , _("Shortname"));      // Head of 1. col
define ("LONG" , _("Long name"));       // Head of 2. col
define ("AUTHOR" , _("Author"));               // Head od 3. col
define ("CREATIONDATE" , _("Creation date"));    // Head of 4. col
define ("DESCRIPT",_("Selection of the Reports"));   // Head of page
define ("LOGOUT",_("Exit the program"));  // Logout of program
define ("NEW_",_("Create a new report"));  // Create new Report
define ("NEWBLOCK",_("Create a new Block"));  // Create new Block
define ("NEWFUNCT",_("Create a new Function"));  // Create new function

// used in repgen_create
define ("CREATE_BLOCK",_("Common Data of a Block")); // common data of block
define ("ALTER_BLOCK",_("Common Data of the Block ")); // common data of block
define ("ID_BLOCK", _("ID-Number of the Block"));                  // Label of ID
define ("CREATE_FUNCT",_("Common Data of a Function ")); // common data of function
define ("ALTER_FUNCT",_("Common Data of the Function ")); // common data of function
define ("ID_FUNCT", _("ID-Number of the Function"));                  // Label of ID

define ("CREATE_HEAD",_("Common data of the report")); // common data of report
define ("ALTER_HEAD",_("Common data of the old report ")); // common data of report
define ("ID" , _("ID-Number of the report"));                  // Label of ID
define ("DATE" , _("Creation Date"));                     // Label of DAte
define ("PRINT_FORMAT" , _("Printer Orientation"));        // Label of Printer
define ("REPORT_TYPE" , _("Report type"));              // Label of Report type
define ("SQL" , _("SQL-Statement for record selection"));         // Label of Paper-width
define ("GROUP_NAME" , _("Name of the group field"));         // Label of Group
define ("GROUP_TYPE" , _("Group type"));              // Label of Group type
define ("GROUP_ERROR" , _("Error: Group type = 'New Page on group change' and no field!"));  // Error message of missing Group field
define ("NO_PAGE", _("No new page when group changes")); // Label of nopage-select
define ("NEW_PAGE", _("New Page on group change")); // Label of newpage-select
define ("TEST_SEL" , _("Test the SQL-Statement"));         // Value of Test-SQL Statement-Button
define ("PAGE_REC", _("Page per record"));                  // Label of report_type single
define ("LINE_REC", _("Line per record"));                  // Label of report_type class
define ("GRID_REC", _("Line per record with grid"));                  // Label of report_type classtable
define ("BEAM_REC", _("Line per record with bar"));                  // Label of report_type classbeam
define ("BEAMGRID_REC", _("Line per record with bar and grid"));     // Label of report_type classgrid
define ("SELECT_CR", _("Back to Report Selection(without storage)")); // Label of back-button
define ("PAGE_STORE" , _("Store and back to Report Selection"));         // Value of Store-Button
define ("PAGE_TEST" , _("Test of the Function"));         // Value of Test-Button
define ("PAGE_STRINGS" , _("Page Definition for Strings"));         // Value of button page_strings
define ("PAGE_GRAPHICS" , _("Page Definition for Graphics"));         // Value of button page_graphics
define ("PHP_ERROR", _("PHP-Error in Function: "));            // Error message of PHP-Error
define ("PHP_OK", _("PHP: Function is OK. The result is: "));           // Message 'ok' of function
define ("ERR_FIELD", _("The field \$field is not part of the function."));           // Message missing $field
define ("A4FORMAT1", _("Paper Format"));              // Paperformat
define ("ID_ERROR", _("ID-Number and SQL-statement must not be empty, or the short-name has been used before !!!!")); // Error Message: ID missing
define ("ID_ERROR_BLOCK", _("The Short-Name of the Block  has been used before!!!!")); // Error Message: ID missing
define ("ERROR_FUNC", _("The name of the Function must be equal to the short-name:")); // Error Message: Functionname <> shortname
define ("FUNC_DECL", _("A Function has to be declared, which gives a String as <BR> as a result. The Function name has to be equal to the short-name!<BR>Please Test the function!<BR> If there is a fatal run-time error (e.g. redeclaration of a function) the system may die!!"));
define ("NOTSTORED",_(" The values have NOT been stored!")); // Error -> not stored
define ("SQL_ERROR",_(" has an Error"));  // SQL Error message
define ("SQL_ERROR1",_(" SQL Error: SQL Statement is empty!"));  // SQL Error message
// used in repgen_test_sel
define ("SQL_STATEMENT",_("You have written this SQL-Statement: "));
define ("SQL_ERG",_("The first 10 records of the result set are: "));

// used in repgen_strings and repgen_graphics
define ("ITEM_DEF",_("Definition of a new Item of the report "));
define ("ITEM_CHAR",_("for Characters "));
define ("ITEM_LINE",_("for Graphics "));
define ("ALTERNATIVE",_( " Or as Alternative in Mode Detail "));
define ("ORDER", _(" Order"));
define ("NUMBER",_("Number of Char"));
define ("AND_", _("AND"));
define ("ALIGN", _("Alignment"));
define ("ELEMENT",_("Elementtype"));
define ("VALUE_", _("Value"));
define ("WIDTH", _("Width in points"));
define ("DBFELD",_("DB-Field"));
define ("ITEM_HEAD",_("Table of stored Items "));
define ("OPTIONAL",_("Optional"));
define ("SUBSTRING",_("Substring"));
define ("FROM",_("from"));
define ("TO",_("to"));
define ("TOTAL",_("Use only, if DB-Field is numeric"));

       //        Headers of the table columns
define ("IT_TYP",_("Type "));
define ("IT_ART",_("Mode "));
define ("IT_FONT",_("Font "));
define ("IT_FONT_SIZE",_("FontSize "));
define ("IT_ORD",_("Order"));
define ("IT_LEN",_("Number of Ch. "));
define ("IT_X1",_("X "));
define ("IT_X2",_("X2/Width "));
define ("IT_Y1",_("Y "));
define ("IT_Y2",_("Y2/Height "));
define ("IT_WIDTH",_("Line-width"));
define ("IT_STRING",_("String/Fieldname "));
define ("IT_LINE",_("Line-width "));
define ("IT_STORE",_("                 Store Item                   "));
define ("IT_BACK"  ,_("         Back to select a report             "));
define ("IT_PRINT", _("Show the report"));    // Button druck
define ("IT_HELP", _("X1/Y1 and X2/Y2 are the ends of a line. <BR> X1/Y1 and width/height give the dimensions of a rectangle."));
define ("ERROR_EMPTY",_("Please insert a value in X or the Number of Ch. and Type !"));
define ("ERROR_EMPTY_LINE",_("Insert please values for X1/Y1 and X2/Y2 and line-width!"));
define ("ERROR_ORDER",_("A value for Order etc. must only be inserted, if Mode=Detail and no value for Y has been given!"));
define ("ERROR_XY",_("Please insert a value for X and Y!"));
define ("ERROR_MIX",_("In lines of mode 'Detail' the items with X/Y-values and Orders must not be mixed!"));
define ("ERROR_VALUE",_("No Value for Item-type 'String' has been declared!"));
define ("ERROR_TO",_("Error in Substring: To-Value is lower than From-Value!"));
define ("ERROR_TOTAL",_("Error in Total: Total can only be used with mode 'DE'!"));

define ("BGCOLOR1", "#CCCCCC");   // Background1 of tables
define ("BGCOLOR2", "#DDDDDD");   // Background2 of tables
define ("BGCOLORH", "#D3DCE3");   // Background of Header of tables

// used in repgen_del
define ("BACK" , _("Back to report selection(without deletion)"));  // Constant for back button value
define ("DEL_BACK" , _("D E L E T E")); // Constant for delete Button value

define("DEL_REPORT",_("Do you really want to delete the report %s ?"));
define("DEL_BLOCK", _("Do you really want to delete the block %s ?"));
define("DEL_FUNC",_("Do you really want to delete the function %s ?"));

?>