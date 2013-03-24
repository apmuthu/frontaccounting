<?php
// ----------------------------------------------------------------
// $ Revision:  1.0 $
// Creator: Alastair Robertson
// date_:   2013-01-30
// Title:   D/b access for dashboard
// Free software under GNU GPL
// ----------------------------------------------------------------


function get_dashboard_widgets_all($user_id) {

    $sql = "SELECT id,app,user_id,column_id,sort_no,collapsed,widget,description,param "
          ."FROM ".TB_PREF."dashboard_widgets "
          ."WHERE user_id = ".db_escape($user_id)
          ." ORDER BY app, column_id, sort_no";
    return db_query($sql,"Cannot retrieve dashboard widgets items");
}

function get_dashboard_widget($ref) {

    $sql = "SELECT id,app,user_id,column_id,sort_no,collapsed,widget,description,param "
          ."FROM ".TB_PREF."dashboard_widgets "
          ."WHERE id = ".db_escape($ref);
      $result = db_query($sql,"Cannot retrieve dashboard widget items");
    return db_fetch($result);
}

function add_dashboard_widget($app, $user_id, $column_id, $sort_no, $collapsed, $widget, $description, $param)
{
    $sql = "INSERT INTO ".TB_PREF."dashboard_widgets (app,user_id,column_id,sort_no,collapsed,widget,"
        ."description, param) "
        ."VALUES ("
        .db_escape($app) . ", " .db_escape($user_id) . ", " . db_escape($column_id) . ", "
        .db_escape($sort_no) . ", " . db_escape($collapsed) . ", "
        .db_escape($widget) . ", " . db_escape($description) . ", " . db_escape($param)
        .")";
    db_query($sql,"The widget could not be added");
}

function update_dashboard_widget($selected_id, $app, $user_id, $column_id, $sort_no, $collapsed, $widget, $description, $param)
{
    $sql = "UPDATE ".TB_PREF."dashboard_widgets SET user_id=" . db_escape($user_id)
        . ",app=" . db_escape($app)
        . ",column_id=" . db_escape($column_id)
        . ",sort_no=" . db_escape($sort_no)
        . ",collapsed=" . db_escape($collapsed)
        . ",widget=" . db_escape($widget)
        . ",description=" . db_escape($description)
        . ",param=" . db_escape($param)
        . " WHERE id = " .db_escape($selected_id);
    db_query($sql,"The widget could not be updated");
}

function delete_dashboard_widget($selected_id)
{
    $sql="DELETE FROM ".TB_PREF."dashboard_widgets WHERE id=".db_escape($selected_id);
    db_query($sql,"could not delete a widget");
}

function get_dashboard_reminders_all($role_id=null) {

    $sql = "SELECT dr.id,dr.role_id,sr.role,dr.next_date,dr.frequency,dr.description,dr.param "
          ."FROM ".TB_PREF."dashboard_reminders dr"
          ." INNER JOIN ".TB_PREF."security_roles sr "
          ." ON sr.id = dr.role_id";
    if(isset($role_id))
        $sql .= " WHERE dr.role_id = ".db_escape($role_id);
    $sql .=" ORDER BY sr.role, dr.next_date, dr.frequency";
    return db_query($sql,"Cannot retrieve dashboard reminders items");
}

function get_dashboard_reminder($ref) {

    $sql = "SELECT role_id,next_date,frequency,description,param "
          ."FROM ".TB_PREF."dashboard_reminders "
          ."WHERE id = ".db_escape($ref);
      $result = db_query($sql,"Cannot retrieve dashboard reminder items");
    return db_fetch($result);
}

function add_dashboard_reminder($role_id, $next_date, $description, $frequency,$param)
{
    $next = date2sql($next_date);
    $sql = "INSERT INTO ".TB_PREF."dashboard_reminders (role_id,next_date,frequency,description,param) "
        ."VALUES ("
        .db_escape($role_id) . ", " . db_escape($next) . ", "
        . db_escape($frequency) . ", " .db_escape($description) . ", "
        .db_escape($param)
        .")";
    db_query($sql,"The reminder could not be added");
}

function update_dashboard_reminder($selected_id, $role_id, $next_date, $description, $frequency, $param)
{
    $next = date2sql($next_date);
    $sql = "UPDATE ".TB_PREF."dashboard_reminders SET role_id=" . db_escape($role_id)
        . ",next_date=" . db_escape($next)
        . ",description=" . db_escape($description)
        . ",frequency=" . db_escape($frequency)
        . ",param=" . db_escape($param)
        . " WHERE id = " .db_escape($selected_id);
    db_query($sql,"The reminder could not be updated");
}

function delete_dashboard_reminder($selected_id)
{
    $sql="DELETE FROM ".TB_PREF."dashboard_reminders WHERE id=".db_escape($selected_id);
    db_query($sql,"could not delete a reminder");
}

function coalesce($obj, $var, $default=null)
{
    if (!isset($obj))
        return '';
    if (property_exists($obj,$var))
        return $obj->$var;
    if (isset($default))
        return $default;
    return '';
}
?>