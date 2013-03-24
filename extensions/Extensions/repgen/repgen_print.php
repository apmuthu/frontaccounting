<?php
// session_start();
/* Print a report
 * repgen_print.php for PHP Report Generator
   Bauer, 5.2.2002
   Version 0.2
*/
// this has to be an own page, because otherwise we could not get Content-type application/pdf
$path_to_root = "../..";
$page_security = 'SA_REPORT_GENERATOR';
include_once($path_to_root . "/includes/session.inc");
add_access_extensions();

include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/admin/db/company_db.inc");
include_once($path_to_root . "/includes/ui.inc");
require_once("includes/repgen.inc");
$id=$_GET['id'];
$file =  $comp_path.'/'.user_company(). '/pdf_files/'.$id.'.pdf';
create_report($id, $file);

?>



