<?php
/**********************************************************************
// Creator: Alastair Robertson
// date_:   2013-01-30
// Title:   Customers widget for dashboard
// Free software under GNU GPL
***********************************************************************/

global $path_to_root;
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/modules/dashboard/includes/dashboard_ui.inc");

class customers
{
    var $page_security = 'SA_CUSTPAYMREP';

    var $top;
    var $graph_type;
    var $data_filter;

    function customers($params='')
    {
        if (isset($params))
        {
            $data=json_decode(html_entity_decode($params, ENT_QUOTES));
            if ($data != null) {
                if ($data->top != '')
                    $this->top = $data->top;
                $this->graph_type = $data->graph_type;
                if ($data->data_filter != '')
                    $this->data_filter = $data->data_filter;
            }
        }
    }

    function render($id, $title)
    {
        global $path_to_root;
        include_once($path_to_root."/reporting/includes/class.graphic.inc");

        if (!defined('FLOAT_COMP_DELTA'))
            define('FLOAT_COMP_DELTA', 0.004);
        if (!isset($this->top))
            $this->top = 10;

        $begin = begin_fiscalyear();
        $today = Today();
        $begin1 = date2sql($begin);
        $today1 = date2sql($today);
        $sql = "SELECT SUM((ov_amount + ov_discount) * rate * IF(trans.type = ".ST_CUSTCREDIT.", -1, 1)) AS total,d.debtor_no, d.name"
            ." FROM ".TB_PREF."debtor_trans AS trans, ".TB_PREF."debtors_master AS d"
            ." WHERE trans.debtor_no=d.debtor_no"
            ." AND (trans.type = ".ST_SALESINVOICE." OR trans.type = ".ST_CUSTCREDIT.")"
            ." AND tran_date >= '$begin1' AND tran_date <= '$today1'";
        if ($this->data_filter != '')
            $sql .= ' AND '.$this->data_filter;
        $sql .= " GROUP by d.debtor_no ORDER BY total DESC, d.debtor_no "
            ." LIMIT ".$this->top;
        $result = db_query($sql);

        if ($this->graph_type=='Table') {
            $th = array(null, _("Customer"), _("Amount"));
            start_table(TABLESTYLE, "width=98%");
            table_header($th);
            $k = 0; //row colour counter
            $i = 0;
            while ($myrow = db_fetch($result))
            {
                alt_table_row_color($k);
            	label_cell(viewer_link($myrow["debtor_no"], 'sales/inquiry/customer_inquiry.php?customer_id='.$myrow["debtor_no"]));
            	label_cell(viewer_link($myrow["name"], 'sales/inquiry/customer_inquiry.php?customer_id='.$myrow["debtor_no"]));
            	amount_cell($myrow['total']);
                end_row();
            }
            end_table(1);
        } else {
            $pg = new graph();
            $i = 0;
            while ($myrow = db_fetch($result))
            {
                $pg->x[$i] = $myrow["debtor_no"]." ".$myrow["name"];
                $pg->y[$i] = $myrow['total'];
                $i++;
            }
            $pg->title     = $title;
            $pg->axis_x    = _("Customer");
            $pg->axis_y    = _("Amount");
            $pg->graphic_1 = $today;
            $pg->type      = 2;
            $pg->skin      = 1;
            $pg->built_in  = false;
            $filename = company_path(). "/pdf_files/". uniqid("").".png";
            $pg->display($filename, true);
            echo "<img src='$filename' border='0' alt='$title' style='max-width:100%'>";
        }
    }

    function edit_param()
    {
        global $top;
        $graph_types = array(
            'ColumnChart' => _("Column Chart"),
            'Table' => _("Table")
        );

        $_POST['top'] = $this->top;
        $_POST['data_filter'] = $this->data_filter;
        text_row_ex(_("Number of customers:"), 'top', 2);
        text_row_ex(_("Filter:"), 'data_filter', 50);
        select_row(_("Graph Type:"), "graph_type", null, $graph_types, null);
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
                        'data_filter' => $_POST['data_filter'],
                        'graph_type' => $_POST['graph_type']);
        return json_encode($param);
    }

}
