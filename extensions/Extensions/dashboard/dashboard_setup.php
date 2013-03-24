<?php
/**********************************************************************
// Creator: Alastair Robertson
// date_:   2013-01-30
// Title:   Dashboard setup
// Free software under GNU GPL
***********************************************************************/
$page_security = 'SA_DASHBOARDSETUP';
$path_to_root="../..";
include($path_to_root . "/includes/session.inc");
add_access_extensions();

page(_($help_context = "Dashboard Setup"));

include($path_to_root . "/includes/ui.inc");
include($path_to_root . "/modules/dashboard/includes/dashboard_ui.inc");
include($path_to_root . "/modules/dashboard/includes/dashboard_db.inc");

simple_page_mode(true);
$userid = $_SESSION["wa_current_user"]->user;
$app = $_SESSION["App"]->applications["Dashboard"];
$widgetObject = null;

//------------------------------
//	Helper to translate record content to more intuitive form
//

//-------------------------------------------------------------------------------------------

if ($Mode=='ADD_ITEM' || $Mode=='UPDATE_ITEM')
{

	$input_error = 0;

    $widget = $app->get_widget($_POST["widget"]);
    include_once ($path_to_root.$widget->path);
    $className = $widget->name;
    $widgetObject = new $className();
    if ($widgetObject->validate_param() == 1)
        $input_error = 1;

	if ($input_error != 1)
	{
        $selected_id = get_post('selected_id');
        $widget_app = get_post('widget_app');
        $column_id = input_num('column_id');
        $sort_no = input_num('sort_no');
        $collapsed = get_post('collapsed');
        $widget = get_post('widget');
        $description = get_post('description');
        $param = $widgetObject->save_param();

    	if ($selected_id != -1 && !empty($selected_id))
    	{
    	     update_dashboard_widget($selected_id, $widget_app, $userid, $column_id, $sort_no, $collapsed, $widget, $description, $param);
 		     $note = _('Selected widget has been updated');
    	}
    	else
    	{
			add_dashboard_widget($widget_app, $userid, $column_id, $sort_no, $collapsed, $widget, $description, $param);
			$note = _('New widget has been added');
    	}
    	//run the sql from either of the above possibilites
		display_notification($note);
 		$Mode = 'RESET';
	}
}

if ($Mode == 'Delete')
{
	delete_dashboard_widget($selected_id);
	display_notification(_('Selected widget has been deleted'));

	$Mode = 'RESET';
}

if ($Mode == 'RESET')
{
	$selected_id = -1;
	unset($_POST);
}
//-------------------------------------------------------------------------------------------------

$result = get_dashboard_widgets_all($userid);

start_form();
start_table(TABLESTYLE);
$th = array(_("Application"), _("Widget"), _("Description"),_("Column"), _("Sequence"), _("Collapsed"),  "", "");
inactive_control_column($th);
table_header($th);

$k = 0; //row colour counter
while ($myrow = db_fetch($result))
{

	alt_table_row_color($k);
	$widget = $app->get_widget($myrow["widget"]);
    include_once ($path_to_root . $widget->path);
    label_cell($app->apps[$myrow["app"]]);
    label_cell($widget->title);
    label_cell($myrow["description"]);
    label_cell($myrow["column_id"],"align='center'");
    label_cell($myrow["sort_no"],"align='center'");
    echo "<td align='center'><input"
        .($myrow["collapsed"] == 1 ? ' checked':'')
        ." type='checkbox' value='1'"
        ."disabled='disabled' /></td>";
    edit_button_cell("Edit".$myrow["id"], _("Edit"));
 	delete_button_cell("Delete".$myrow["id"], _("Delete"));
    end_row();

}

end_table(1);

//-------------------------------------------------------------------------------------------------
if (list_updated('widget')) {
    $Ajax->activate('edits');
}

div_start('edits');

start_table(TABLESTYLE2);
$_POST['param'] = '';

if ($selected_id != -1)
{
	if ($Mode == 'Edit') {
		//editing an existing payment widget
		$myrow = get_dashboard_widget($selected_id);

        $_POST['widget_app']  = $myrow["app"];
        $_POST['column_id']  = $myrow["column_id"];
        $_POST['sort_no'] = $myrow["sort_no"];
        $_POST['description'] = $myrow["description"];
	    $_POST['widget'] = $myrow["widget"];
        $_POST['sort_no'] = $myrow["sort_no"];
        $_POST['param'] = $myrow["param"];
	}
	hidden('selected_id', $selected_id);
}

$widget = $app->get_widget(isset($_POST['widget']) ? $_POST['widget'] : $app->widgets[0]->name);
widget_list_row($app->get_widget_list(), _("Widget:"), 'widget', null, true);
text_row_ex(_("Title:"), 'description', 40);
select_row(_("Application Tab:"), "widget_app", null, $app->apps, null);
text_row_ex(_("Column:"), 'column_id', 1);
text_row_ex(_("Sequence:"), 'sort_no', 1);
check_row(_("Collapsed:"), 'collapsed');
include_once ($path_to_root.$widget->path);
$className = $widget->name;
$widgetObject = new $className($_POST['param']);
$widgetObject->edit_param();

end_table(1);
div_end();

submit_add_or_update_center($selected_id == -1, '', 'both');

end_form();

end_page();

?>
