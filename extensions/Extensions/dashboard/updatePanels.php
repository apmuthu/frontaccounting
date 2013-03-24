<?php
// ----------------------------------------------------------------
// $ Revision:  1.0 $
// Creator: Alastair Robertson
// date_:   2013-02-07
// Title:   Dashboard widgets, save positions
// Free software under GNU GPL
// ----------------------------------------------------------------
if(!$_POST["data"]){
    echo "Invalid data";
    exit;
}

$post=stripslashes($_POST["data"]);
$data=json_decode($post);

$page_security = 'SA_DASHBOARDSETUP';
$path_to_root="../..";
include_once($path_to_root . "/includes/session.inc");
add_access_extensions();

foreach($data->items as $item)
{
	$sql="UPDATE ".TB_PREF."dashboard_widgets SET column_id=".$item->column.", sort_no=".$item->order.", collapsed=".$item->collapsed." WHERE id=".$item->id;
	db_query($sql) or die('Error updating widget DB');
}
echo "success";

?>