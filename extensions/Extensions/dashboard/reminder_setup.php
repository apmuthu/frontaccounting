<?php
/**********************************************************************
// Creator: Alastair Robertson
// date_:   2013-01-30
// Title:   Dashboard reminder list setup
// Free software under GNU GPL
***********************************************************************/
$page_security = 'SA_DASHBOARDREMINDERS';
$path_to_root="../..";
include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/includes/date_functions.inc");
add_access_extensions();

include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/modules/dashboard/includes/dashboard_ui.inc");
include_once($path_to_root . "/modules/dashboard/includes/dashboard_db.inc");

$js = '';
if ($use_date_picker)
    $js .= get_js_date_picker();
page(_($help_context = "Reminders"), false, false, "", $js);

simple_page_mode(true);
$roleid = $_SESSION["wa_current_user"]->access;
$frequencies = array(
    'daily' => _("Daily"),
    'weekly' => _("Weekly"),
    'monthly' => _("Monthly"),
    'yearly' => _("Yearly"),
    'once' => _("Once")
);

//------------------------------
//	Helper to translate record content to more intuitive form
//

//-------------------------------------------------------------------------------------------

if ($Mode=='ADD_ITEM' || $Mode=='UPDATE_ITEM')
{

    $selected_id = get_post('selected_id');
    $role_id = get_post('role_id');
    $next_date = get_post('next_date');
    $description = get_post('description');
    $frequency = get_post('frequency');
    $occurrence = input_num('occurrence');
    $data = array('occurrence' => $occurrence);
    $param =  json_encode($data);

	if ($selected_id != -1 && !empty($selected_id))
	{
	     update_dashboard_reminder($selected_id, $role_id, $next_date, $description, $frequency, $param);
	     $note = _('Selected reminder has been updated');
	}
	else
	{
		add_dashboard_reminder($role_id, $next_date, $description, $frequency, $param);
		$note = _('New reminder has been added');
	}
	//run the sql from either of the above possibilites
	display_notification($note);
	$Mode = 'RESET';
}

if ($Mode == 'Delete')
{
	delete_dashboard_reminder($selected_id);
	display_notification(_('Selected reminder has been deleted'));

	$Mode = 'RESET';
}

if ($Mode == 'RESET')
{
	$selected_id = -1;
	unset($_POST);
}
//-------------------------------------------------------------------------------------------------

$result = get_dashboard_reminders_all();

start_form();
start_table(TABLESTYLE);
$th = array(_("Role"), _("Next Date"), _("Description"),_("Frequency"), "", "");
inactive_control_column($th);
table_header($th);

$k = 0; //row colour counter
while ($myrow = db_fetch($result))
{
	alt_table_row_color($k);
    label_cell($myrow["role"]);
    label_cell(sql2date($myrow["next_date"]));
    label_cell("<pre>".$myrow["description"]."</pre>");
    label_cell($frequencies[$myrow["frequency"]]);
    edit_button_cell("Edit".$myrow["id"], _("Edit"));
 	delete_button_cell("Delete".$myrow["id"], _("Delete"));
    end_row();

}

end_table(1);

//-------------------------------------------------------------------------------------------------
if (list_updated('frequency')) {
    $Ajax->activate('edits');
}

div_start('edits');

start_table(TABLESTYLE2);
$_POST['param'] = '';

if ($selected_id != -1)
{
	if ($Mode == 'Edit') {
		//editing an existing payment reminder
		$myrow = get_dashboard_reminder($selected_id);

        $_POST['role_id']  = $myrow["role_id"];
        $_POST['next_date']  = sql2date($myrow["next_date"]);
        $_POST['description'] = $myrow["description"];
        $_POST['frequency'] = $myrow["frequency"];
        $_POST['param'] = $myrow["param"];
        $data = json_decode(html_entity_decode($_POST['param']));
        $_POST['occurrence'] = coalesce($data,'occurrence');
	}
	hidden('selected_id', $selected_id);
}
label_cell(_("Role:"),"class='label'");
security_roles_list_cells(null, 'role_id');
date_row(_("Next Date"), 'next_date', '', null, 0, 0, 1001);
textarea_row(_("Description:"), 'description', null, 40, 5);
select_row(_("Frequency:"), "frequency", null, $frequencies, array(
            'select_submit'=> true));
switch ($_POST['frequency']) {
    case 'daily':
        text_row_ex(_("Recur every:"), 'occurrence', 3, null, null, null, null, _("days"));
        break;
    case 'weekly':
        text_row_ex(_("Recur every:"), 'occurrence', 3, null, null, null, null, _("weeks"));
        break;
    case 'monthly':
        text_row_ex(_("Recur every:"), 'occurrence', 3, null, null, null, null, _("months"));
        break;
    case 'yearly':
        break;
}

end_table(1);
div_end();

submit_add_or_update_center($selected_id == -1, '', 'both');

end_form();

end_page();

?>
