<?php
/**********************************************************************
// Creator: Alastair Robertson
// date_:   2013-01-30
// Title:   Dimensions widget for dashboard
// Free software under GNU GPL
***********************************************************************/

global $path_to_root;
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/modules/dashboard/includes/dashboard_ui.inc");

class dimensions
{
    var $page_security = 'SA_DIMENSIONREP';

    var $top;
    var $graph_type;
    var $data_filter;

    function dimensions($params='')
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
        if (!isset($this->top))
            $this->top = 10;

        global $path_to_root;

        $pg = new graph();

        $begin = begin_fiscalyear();
        $today = Today();
        $begin1 = date2sql($begin);
        $today1 = date2sql($today);
        $sql = "SELECT SUM(-t.amount) AS total, d.reference, d.name FROM
            ".TB_PREF."gl_trans AS t,".TB_PREF."dimensions AS d WHERE
            (t.dimension_id = d.id OR t.dimension2_id = d.id) AND
            t.tran_date >= '$begin1' AND t.tran_date <= '$today1' ";
        if ($this->data_filter != '')
            $sql .= ' AND '.$this->data_filter;
        $sql .= "GROUP BY d.id ORDER BY total DESC LIMIT ".$this->top;
        $result = db_query($sql, "Transactions could not be calculated");

        if ($this->graph_type=='Table') {
            $title = _("Top 10 Dimensions in fiscal year");
            br(2);
            display_heading($title);
            br();
            $th = array(_("Dimension"), _("Amount"));
            start_table(TABLESTYLE, "width=98%");
            table_header($th);
            $k = 0; //row colour counter
            while ($myrow = db_fetch($result))
            {
                alt_table_row_color($k);
                label_cell($myrow['reference']." ".$myrow["name"]);
                amount_cell($myrow['total']);
                end_row();
            }
            end_table(2);
        } else {
            $pg = new graph();
            $i = 0;
            while ($myrow = db_fetch($result))
            {
                $pg->x[$i] = $myrow['reference']." ".$myrow["name"];
                $pg->y[$i] = abs($myrow['total']);
                $i++;
            }
            $pg->title     = $title;
            $pg->axis_x    = _("Dimension");
            $pg->axis_y    = _("Amount");
            $pg->graphic_1 = $today;
            $pg->type      = 5;
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
            'PieChart' => _("Pie Chart"),
            'Table' => _("Table")
        );
        $_POST['top'] = $this->top;
        $_POST['graph_type'] = $this->graph_type;
        $_POST['data_filter'] = $this->data_filter;
        text_row_ex(_("Number of items:"), 'top', 2);
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
                        'graph_type' => $_POST['graph_type'],
        'data_filter' => $_POST['data_filter']);
        return json_encode($param);
    }

}
