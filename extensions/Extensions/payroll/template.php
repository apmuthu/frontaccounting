<?php
/*
  Template for payroll module pages
  This should include section dividers and common gettin' started kind of things
*/

/////////////////////////////////////////////////////
//Includes
/////////////////////////////////////////////////////
$page_security = 'SA_PAYROLL';
$path_to_root="../..";

include($path_to_root . "/includes/session.inc");
add_access_extensions();

include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/includes/data_checks.inc");


/////////////////////////////////////////////////////
//Functions
/////////////////////////////////////////////////////


//--------------------------------------------------------------------------------------------


//--------------------------------------------------------------------------------------------


/////////////////////////////////////////////////////
//Page Flow
/////////////////////////////////////////////////////
page("Page Title");

display_notification("a green notification");
display_error("a red error message");

//some changes by Serban - testing with git

end_page();

?>  