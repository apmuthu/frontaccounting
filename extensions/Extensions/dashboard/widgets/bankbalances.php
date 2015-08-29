<?php
/**********************************************************************
// Creator: Alastair Robertson
// date_:   2013-01-30
// Title:   Bank balances widget for dashboard
// Free software under GNU GPL
***********************************************************************/

global $path_to_root;
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/modules/dashboard/includes/dashboard_ui.inc");

class bankbalances
{
    var $page_security = 'SA_GLANALYTIC';

    var $data_filter;

    function bankbalances($params='')
    {
        if (isset($params))
        {
            $data=json_decode(html_entity_decode($params, ENT_QUOTES));
            if ($data != null) {
                if ($data->data_filter != '')
                    $this->data_filter = $data->data_filter;
            }
        }
    }

    function render($id, $title)
    {
        global $path_to_root;
        include_once($path_to_root."/includes/ui.inc");

        $today = date2sql(Today());
        $sql = "SELECT bank_act, bank_account_name, SUM(amount) balance FROM ".TB_PREF."bank_trans bt"
              ." INNER JOIN ".TB_PREF."bank_accounts ba ON bt.bank_act = ba.id"
              ." WHERE trans_date <= '$today'"
              ." AND inactive <> 1";
        if ($this->data_filter != '')
            $sql .= ' AND '.$this->data_filter;
        $sql .= " GROUP BY bank_act, bank_account_name"
                ." ORDER BY bank_account_name";
        $result = db_query($sql);
        br();
        $th = array(_("Account"), _("Balance"));
        start_table(TABLESTYLE,"width=98%");
        table_header($th);
        $k = 0; //row colour counter
        while ($myrow = db_fetch($result))
        {
            alt_table_row_color($k);
            label_cell(viewer_link($myrow["bank_account_name"], 'gl/inquiry/bank_inquiry.php?bank_account='.$myrow["bank_act"]));
            amount_cell($myrow['balance']);
            end_row();
        }
        end_table(1);
    }

    function edit_param()
    {

        $_POST['data_filter'] = $this->data_filter;
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
        $param = array('data_filter' => $_POST['data_filter']);
        return json_encode($param);
    }

}
