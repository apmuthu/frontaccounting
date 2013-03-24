<?php
/**********************************************************************
// Creator: Alastair Robertson
// date_:   2013-01-30
// Title:   Bank transactions widget for dashboard
// Free software under GNU GPL
***********************************************************************/

global $path_to_root;
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/includes/sysnames.inc");
include_once($path_to_root . "/modules/dashboard/includes/dashboard_ui.inc");

class banktransactions
{
    var $page_security = 'SA_GLANALYTIC';

    var $data_filter;
    var $days_past;
    var $days_future;
    var $bank_act;

    function banktransactions($params='')
    {
        if (isset($params))
        {
            $data=json_decode(html_entity_decode($params, ENT_QUOTES));
            if ($data != null) {
                if ($data->data_filter != '')
                    $this->data_filter = $data->data_filter;
                $this->bank_act = $data->bank_act;
                if ($data->days_past != '')
                    $this->days_past = $data->days_past;
                if ($data->days_future != '')
                    $this->days_future = $data->days_future;
            }
        }
    }

    function render($id, $title)
    {
        global $path_to_root, $systypes_array;
        include_once($path_to_root."/includes/ui.inc");

        $start_date = add_days(Today(), -$this->days_past);
        $end_date = add_days(Today(), $this->days_future);

        $result = get_bank_trans_for_bank_account($this->bank_act, $start_date, $end_date);

        start_table(TABLESTYLE,'width=98%');

        $th = array(_("#"), _("Date"),
            _("Receipt"), _("Payment"), _("Balance"), _("Person/Item"), _("Memo"), "");
        table_header($th);

        $bfw = get_balance_before_for_bank_account($this->bank_act, $start_date);

        $credit = $debit = 0;
        start_row("class='inquirybg' style='font-weight:bold'");
        label_cell(_("Opening Balance")." - ".$start_date, "colspan=4");
        display_debit_or_credit_cells($bfw);
        label_cell("");
        label_cell("", "colspan=2");

        end_row();
        $running_total = $bfw;
        if ($bfw > 0 )
            $debit += $bfw;
        else
            $credit += $bfw;
        $j = 1;
        $k = 0; //row colour counter
        while ($myrow = db_fetch($result))
        {

            alt_table_row_color($k);

            $running_total += $myrow["amount"];

            label_cell(get_trans_view_str($myrow["type"],$myrow["trans_no"]));
            $trandate = sql2date($myrow["trans_date"]);
            label_cell($trandate);
            display_debit_or_credit_cells($myrow["amount"]);
            amount_cell($running_total);
            label_cell(payment_person_name($myrow["person_type_id"],$myrow["person_id"]));
            label_cell(get_comments_string($myrow["type"], $myrow["trans_no"]));
            label_cell(get_gl_view_str($myrow["type"], $myrow["trans_no"]));
            end_row();
            if ($myrow["amount"] > 0 )
                $debit += $myrow["amount"];
            else
                $credit += $myrow["amount"];

            if ($j == 12)
            {
                $j = 1;
                table_header($th);
            }
            $j++;
        }
        //end of while loop

        start_row("class='inquirybg' style='font-weight:bold'");
        label_cell(_("Ending Balance")." - ". $end_date, "colspan=4");
        amount_cell($debit+$credit);
        label_cell("");
        label_cell("", "colspan=2");
        end_row();
        end_table(2);
    }

    function edit_param()
    {

        $_POST['data_filter'] = $this->data_filter;
        $_POST['days_past'] = $this->days_past;
        $_POST['days_future'] = $this->days_future;
        $_POST['bank_act'] = $this->bank_act;
        text_row_ex(_("Days in past:"), 'days_past', 2);
        text_row_ex(_("Days in future:"), 'days_future', 2);
        bank_accounts_list_cells(_("Account:"), 'bank_act', null);
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
        $param = array('days_past' => $_POST['days_past'],
                        'days_future' => $_POST['days_future'],
                        'bank_act' => $_POST['bank_act'],
                        'data_filter' => $_POST['data_filter']);
        return json_encode($param);
    }

}
