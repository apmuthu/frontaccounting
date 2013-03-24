<?php
/**********************************************************************
// Creator: Alastair Robertson
// date_:   2013-01-30
// Title:   Reminder List widget for dashboard
// Free software under GNU GPL
***********************************************************************/

global $path_to_root;
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/modules/dashboard/includes/dashboard_ui.inc");

class reminders
{
    var $page_security = 'SA_DASHBOARDREMINDERS';

    var $days_future;
    var $data_filter;

    function reminders($params='')
    {
        if (isset($params))
        {
            $data=json_decode(html_entity_decode($params, ENT_QUOTES));
            if ($data != null) {
                if ($data->data_filter != '')
                    $this->data_filter = $data->data_filter;
                if ($data->days_future != '')
                    $this->days_future = $data->days_future;
            }
        }
    }

    function render($id, $title)
    {
        global $path_to_root;
        include_once($path_to_root."/includes/ui.inc");

        $end_date = date2sql(add_days(Today(), $this->days_future));
        $role_id = $_SESSION["wa_current_user"]->access;
        $sql = "SELECT id, description, next_date FROM ".TB_PREF."dashboard_reminders "
              ." WHERE next_date < '$end_date'"
              ." AND role_id = '$role_id'";
        if ($this->data_filter != '')
            $sql .= ' AND '.$this->data_filter;
        $sql .= " ORDER BY next_date";
        $result = db_query($sql);
        br();
        $th = array(_("Actioned"),_("Date"), _("Description"));
        start_table(TABLESTYLE,"id='reminder' width=98%");
        table_header($th);
        $k = 0; //row colour counter
        while ($myrow = db_fetch($result))
        {
            $nextdate = sql2date($myrow["next_date"]);
            if (date1_greater_date2(Today(), $nextdate)) {
                $extra = "class='reminder_overdue'";
            } elseif (Today() == $nextdate) {
                $extra = "class='reminder_due'";
            } else {
                $extra = "class='reminder'";
            }
            alt_table_row_color($k);
            $js = 'setTimeout(function(){updateToDoData('.$myrow["id"].');}, 0);';
            check_cells(null, null, null, $js);
            label_cell($nextdate, $extra);
            label_cell("<pre>".$myrow["description"]."</pre>",$extra);
            end_row();
        }
        end_table(1);
    }

    function edit_param()
    {

        $_POST['data_filter'] = $this->data_filter;
        $_POST['days_future'] = $this->days_future;
        text_row_ex(_("Days in future:"), 'days_future', 2);
        text_row_ex(_("Filter:"), 'data_filter', 50);
    }

    function validate_param()
    {
        $input_error = 0;
        //if (!is_numeric($_POST['top']))
        //  {
        //      $input_error = 1;
        //      display_error( _("The number of weeks must be numeric."));
        //      set_focus('top');
        //  }

        //  if ($_POST['top'] == '')
        //      $_POST['top'] = 10;

          return $input_error;
      }

    function save_param()
    {
        $param = array('data_filter' => $_POST['data_filter'],
                        'days_future' => $_POST['days_future']);
        return json_encode($param);
    }

}
