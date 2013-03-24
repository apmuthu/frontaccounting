<?php
/**********************************************************************
// Creator: Alastair Robertson
// date_:   2013-01-30
// Title:   Sales invoices widget for dashboard
// Free software under GNU GPL
***********************************************************************/

global $path_to_root;
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/modules/dashboard/includes/dashboard_ui.inc");

class salesinvoices
{
    var $page_security = 'SA_CUSTPAYMREP';

    var $data_filter;

    function salesinvoices($params='')
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

        if (!defined('FLOAT_COMP_DELTA'))
            define('FLOAT_COMP_DELTA', 0.004);

        $today = date2sql(Today());
        $sql = "SELECT trans.trans_no, trans.reference, trans.tran_date, trans.due_date, debtor.debtor_no,
            debtor.name, branch.br_name, debtor.curr_code,
            (trans.ov_amount + trans.ov_gst + trans.ov_freight
                + trans.ov_freight_tax + trans.ov_discount) AS total,
            (trans.ov_amount + trans.ov_gst + trans.ov_freight
                + trans.ov_freight_tax + trans.ov_discount - trans.alloc) AS remainder,
            DATEDIFF('$today', trans.due_date) AS days
            FROM ".TB_PREF."debtor_trans as trans, ".TB_PREF."debtors_master as debtor,
                ".TB_PREF."cust_branch as branch
            WHERE debtor.debtor_no = trans.debtor_no AND trans.branch_code = branch.branch_code
                AND trans.type = ".ST_SALESINVOICE." AND (trans.ov_amount + trans.ov_gst + trans.ov_freight
                + trans.ov_freight_tax + trans.ov_discount - trans.alloc) > ".FLOAT_COMP_DELTA."
                AND DATEDIFF('$today', trans.due_date) > 0 ORDER BY days DESC";
        if ($this->data_filter != '')
            $sql .= ' AND '.$this->data_filter;
        $result = db_query($sql);
        $title = db_num_rows($result) . _(" Overdue Sales Invoices");
        br(1);
        display_heading($title);
        br();
        $th = array("#", _("Date"), _("Due Date"), _("Customer"), _("Currency"),
            _("Total"), _("Remainder"), _("Days"));
        start_table(TABLESTYLE,"width=98%");
        table_header($th);
        $k = 0; //row colour counter
        while ($myrow = db_fetch($result))
        {
            alt_table_row_color($k);
            label_cell(get_trans_view_str(ST_SALESINVOICE, $myrow["trans_no"]));
            label_cell(sql2date($myrow['tran_date']));
            label_cell(sql2date($myrow['due_date']));
            $name = $myrow["debtor_no"]." ".$myrow["name"];
            label_cell($name);
            label_cell($myrow['curr_code']);
            amount_cell($myrow['total']);
            amount_cell($myrow['remainder']);
            label_cell($myrow['days'], "align='right'");
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
