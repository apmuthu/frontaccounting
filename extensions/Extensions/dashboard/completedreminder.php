<?php
// ----------------------------------------------------------------
// $ Revision:  1.0 $
// Creator: Alastair Robertson
// date_:   2013-02-07
// Title:   Dashboard reminders, process actioned
// Free software under GNU GPL
// ----------------------------------------------------------------
if(!$_POST["data"]){
    echo "Invalid data";
    exit;
}

$post=stripslashes($_POST["data"]);
$id=json_decode($post);

$page_security = 'SA_DASHBOARDREMINDERS';
$path_to_root="../..";
include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/modules/dashboard/includes/dashboard_db.inc");
add_access_extensions();

$myrow = get_dashboard_reminder($id);
$role_id  = $myrow["role_id"];
$next_date  = sql2date($myrow["next_date"]);
$description = $myrow["description"];
$frequency = $myrow["frequency"];
$param = $myrow["param"];
$data = json_decode(html_entity_decode($param));
$occurrence = intval(coalesce($data,'occurence', '1'));
switch ($frequency)
{
    case 'daily':
        $next_date = add_days($next_date, 1);
        break;
    case 'weekly':
        $next_date = add_days($next_date, 7 * $occurrence);
        break;
    case 'monthly':
        $next_date = add_months($next_date, $occurrence);
        break;
    case 'yearly':
        $next_date = add_months($next_date, 12);
        break;
}
update_dashboard_reminder($id, $role_id, $next_date, $description, $frequency, $param);

echo "success";

?>