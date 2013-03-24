<?php
/**********************************************************************
// Creator: Alastair Robertson
// date_:   2013-01-30
// Title:   Weekly Sales widget for dashboard
// Free software under GNU GPL
***********************************************************************/

global $path_to_root;
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/modules/dashboard/includes/dashboard_ui.inc");

class weeklysales
{
    var $page_security = 'SA_CUSTPAYMREP';

    var $top;
    var $orderby;
    var $orderby_seq;
    var $graph_type;
    var $data_filter;

    function weeklysales($params='')
    {
        if (isset($params))
        {
            $data=json_decode(html_entity_decode($params, ENT_QUOTES));
            if ($data != null) {
                if ($data->top != '')
                    $this->top = $data->top;
                if ($data->orderby != '')
                {
                  $this->orderby = $data->orderby;
                  if ($data->orderby_seq != '')
                      $this->orderby_seq = $data->orderby_seq;
                  else
                      $this->orderby_seq = 'ASC';
                }
                $this->graph_type = $data->graph_type;
                if ($data->data_filter != '')
                    $this->data_filter = $data->data_filter;
            }
        }
    }

    function render($id, $title)
    {
        $sql = '';
        if (isset($this->orderby))
            $sql .= 'SELECT  `Week End`, `Week no`, `Gross Sales`, `Net Sales`, `Tax` '
                .'FROM (';
        $sql .= 'SELECT max(bt.trans_date) `Week End`, '
            .'concat(cast(case when weekofyear(bt.trans_date) = 1 and month(bt.trans_date)=12 then year(bt.trans_date) + 1 else year(bt.trans_date) end as char),cast(weekofyear(bt.trans_date) as char)) `Week no`, '
            .'sum((ttd.net_amount+ttd.amount)*ex_rate) `Gross Sales`, '
            .'sum(ttd.net_amount*ex_rate) `Net Sales`, '
            .'sum(ttd.amount*ex_rate) `Tax` '
        .'FROM '.TB_PREF.'bank_trans bt '
        .'INNER JOIN '.TB_PREF.'cust_allocations ca '
            .'ON bt.type = ca.trans_type_from '
            .'AND bt.trans_no = ca.trans_no_from '
        .'INNER JOIN '.TB_PREF.'debtor_trans dt '
            .'ON dt.type = ca.trans_type_from '
            .'AND dt.trans_no = ca.trans_no_from '
        .'INNER JOIN '.TB_PREF.'debtors_master dm '
            .'ON dt.debtor_no = dm.debtor_no '
        .'INNER JOIN '.TB_PREF.'trans_tax_details ttd '
            .'ON ttd.trans_type = ca.trans_type_to '
            .'AND ttd.trans_no = ca.trans_no_to '
        .'INNER JOIN '.TB_PREF.'tax_types tt '
            .'ON tt.id = ttd.tax_type_id ';
        if ($this->data_filter != '')
            $sql .= ' WHERE '.$this->data_filter;
        $sql .= ' GROUP BY concat(cast(case when weekofyear(bt.trans_date) = 1 and month(bt.trans_date)=12 then year(bt.trans_date) + 1 else year(bt.trans_date) end as char),cast(weekofyear(bt.trans_date) as char)) ';
        if (isset($this->orderby))
            $sql .= ') items order by `'.$this->orderby.'` '.$this->orderby_seq;
        if (isset($this->top))
            $sql .= ' limit '.$this->top;
        $result = db_query($sql) or die(_('Error getting weekly sales data'));

        $rows = array();
        //flag is not needed
        $flag = true;
        $table = array();
        $table['cols'] = array(
            array('label' => 'Week End', 'type' => 'string'),
            array('label' => 'Gross Sales', 'type' => 'number')
        );

        $rows = array();
        while($r = db_fetch_assoc($result)) {
            $temp = array();
            // the following line will used to slice the Pie chart
            $temp[] = array('v' => (string) $r['Week End'], 'f' => sql2date($r['Week End']));
            $temp[] = array('v' => (float) $r['Gross Sales'], 'f' => number_format2($r['Gross Sales'], user_price_dec()));
            $rows[] = array('c' => $temp);
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
        global $top, $sequences, $asc_desc;

        $sequences = array(
            'Week End' => _("Week End Date"),
            'Gross Sales' => _("Gross Sales")
        );
        $asc_desc = array(
            'asc' => _("Ascending"),
            'desc' => _("Descending")
        );
        $graph_types = array(
            'LineChart' => _("Line Chart"),
            'ColumnChart' => _("Column Chart"),
            'Table' => _("Table")
        );
        $_POST['top'] = $this->top;
        $_POST['orderby'] = $this->orderby;
        $_POST['orderby_seq'] = $this->orderby_seq;
        $_POST['graph_type'] = $this->graph_type;
        $_POST['data_filter'] = $this->data_filter;
        text_row_ex(_("Number of weeks:"), 'top', 2);
        select_row(_("Sequence"), "orderby", null, $sequences, null);
        select_row(_("Order"), "orderby_seq", null, $asc_desc, null);
        text_row_ex(_("Filter:"), 'data_filter', 50);
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
        $param = array('top' => $_POST['top'],
                        'orderby' => $_POST['orderby'],
                        'orderby_seq' => $_POST['orderby_seq'],
                        'graph_type' => $_POST['graph_type'],
                        'data_filter' => $_POST['data_filter']);
        return json_encode($param);
    }

}
