<?php
/**********************************************************************
// Creator: Alastair Robertson
// date_:   2013-01-30
// Title:   Daily bank balances widget for dashboard
// Free software under GNU GPL
***********************************************************************/

global $path_to_root;
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/modules/dashboard/includes/dashboard_ui.inc");

class dailybankbalances
{
    var $page_security = 'SA_GLANALYTIC';

    var $days_past;
    var $days_future;
    var $bank_act;
    var $graph_type;

    function dailybankbalances($params='')
    {
        if (isset($params))
        {
            $data=json_decode(html_entity_decode($params, ENT_QUOTES));
            if ($data != null) {
                $this->bank_act = $data->bank_act;
                $this->graph_type = $data->graph_type;
                if ($data->days_past != '')
                    $this->days_past = $data->days_past;
                if ($data->days_future != '')
                    $this->days_future = $data->days_future;
            }
        }
    }

    function render($id, $title)
    {
        global $path_to_root;
        include_once($path_to_root."/reporting/includes/class.graphic.inc");

        $today = date2sql(Today());
        if (!isset($data->days_past))
            $this->days_past = 30;
        if (!isset($data->days_future))
            $this->days_future = 30;

        $sql = "SELECT bank_act, bank_account_name, trans_date, amount"
              ." FROM ("
              ." SELECT bank_act, bank_account_name, null trans_date, SUM(amount) amount"
              ." FROM ".TB_PREF."bank_trans bt"
              ." INNER JOIN ".TB_PREF."bank_accounts ba ON bt.bank_act = ba.id"
              ." WHERE bank_act = ".$this->bank_act
              ." AND trans_date < now() - INTERVAL ".$this->days_past." DAY"
              ." GROUP BY bank_act, bank_account_name"
              ." UNION ALL"
              ." SELECT bank_act, bank_account_name, trans_date, SUM(amount) amount"
              ." FROM ".TB_PREF."bank_trans bt"
              ." INNER JOIN ".TB_PREF."bank_accounts ba ON bt.bank_act = ba.id"
              ." WHERE bank_act = ".$this->bank_act
              ." AND trans_date < now() + INTERVAL ".$this->days_future." DAY"
              ." AND trans_date > now() - INTERVAL ".$this->days_past." DAY"
              ." GROUP BY bank_act, trans_date, bank_account_name"
              ." ) trans"
              ." ORDER BY bank_account_name, trans_date";
        $result = db_query($sql);

        $rows = array();
        //flag is not needed
        $flag = true;
        $table = array();
        $table['cols'] = array(
            array('label' => 'Date', 'type' => 'string'),
            array('label' => 'Balance', 'type' => 'number')
        );

        $rows = array();
        $total = 0;
        $last_day = 0;
        $date = add_days(Today(), -$this->days_past);
        $balance_date = $date;
        while($r = db_fetch_assoc($result)) {
            if ($r['trans_date'] == null) {
                $total = $r['amount'];
            } else {
                $balance_date = sql2date($r['trans_date']);
                while (date1_greater_date2 ($balance_date, $date) ) {
                    $temp = array();
                    $temp[] = array('v' => (string) $date, 'f' => $date);
                    $temp[] = array('v' => (float) $total, 'f' => number_format2($total, user_price_dec()));
                    $rows[] = array('c' => $temp);
                    $date = add_days($date,1);
                }
                $total += $r['amount'];
                $temp = array();
                $temp[] = array('v' => (string) $balance_date, 'f' => $balance_date);
                $temp[] = array('v' => (float) $total, 'f' => number_format2($total, user_price_dec()));
                $rows[] = array('c' => $temp);
                $date = $balance_date;
            }
        }
        $end_date = add_days(Today(), $this->days_future);
        while (date1_greater_date2 ($end_date, $date)) {
            $temp = array();
            $temp[] = array('v' => (string) $date, 'f' => $date);
            $temp[] = array('v' => (float) $total, 'f' => number_format2($total, user_price_dec()));
            $rows[] = array('c' => $temp);
            $last_day++;
            $date = add_days($date,1);
        }

        $table['rows'] = $rows;
        $jsonTable = json_encode($table);

        $js =
"google.load('visualization', '1', {'packages':['corechart','table']});
google.setOnLoadCallback(drawChart".$id.");
function drawChart".$id."() {
  var data = new google.visualization.DataTable(".$jsonTable.");
  var options = {";
        if ($this->graph_type != 'Table')
            $js .="height: 300, ";
        $js .= "title: '".$title."'
    };
  var chart".$id." = new google.visualization.".$this->graph_type."(document.getElementById('widget_div_".$id."'));
  chart".$id.".draw(data, options);
}";
        add_js_source($js);
    }

    function edit_param()
    {
        $graph_types = array(
            'LineChart' => _("Line Chart"),
            'ColumnChart' => _("Column Chart"),
            'Table' => _("Table")
        );
        $_POST['days_past'] = $this->days_past;
        $_POST['days_future'] = $this->days_future;
        $_POST['bank_act'] = $this->bank_act;
        $_POST['graph_type'] = $this->graph_type;
        text_row_ex(_("Days in past:"), 'days_past', 2);
        text_row_ex(_("Days in future:"), 'days_future', 2);
        bank_accounts_list_cells(_("Account:"), 'bank_act', null);
        select_row(_("Graph Type"), "graph_type", null, $graph_types, null);
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
        $param = array('days_past' => $_POST['days_past'],
                        'days_future' => $_POST['days_future'],
                        'bank_act' => $_POST['bank_act'],
                        'graph_type' => $_POST['graph_type']);
        return json_encode($param);
    }

}
