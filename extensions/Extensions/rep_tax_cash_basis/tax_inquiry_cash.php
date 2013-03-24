<?php
// ----------------------------------------------------------------
// $ Revision:  1.0 $
// Creator: Alastair Robertson
// date_:   2011-10-22
// Title:   Tax inquiry (cash basis)
// Free software under GNU GPL
// ----------------------------------------------------------------
$page_security = 'SA_TAXREPCASH';
$path_to_root="../..";
include_once($path_to_root . "/includes/session.inc");
add_access_extensions();

include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/includes/data_checks.inc");

include_once($path_to_root . "/modules/rep_tax_cash_basis/includes/tax_cash_db.inc");

$js = '';
set_focus('account');
if ($use_popup_windows)
	$js .= get_js_open_window(800, 500);
if ($use_date_picker)
	$js .= get_js_date_picker();

page(_($help_context = "Tax Inquiry (Cash Basis)"), false, false, '', $js);

//----------------------------------------------------------------------------------------------------
// Ajax updates
//
if (get_post('Show')) 
{
	$Ajax->activate('trans_tbl');
}

if (get_post('TransFromDate') == "" && get_post('TransToDate') == "")
{
	$date = Today();
	$row = get_company_prefs();
	$edate = add_months($date, -$row['tax_last']);
	$edate = end_month($edate);
	$bdate = begin_month($edate);
	$bdate = add_months($bdate, -$row['tax_prd'] + 1);
	$_POST["TransFromDate"] = $bdate;
	$_POST["TransToDate"] = $edate;
}	

//----------------------------------------------------------------------------------------------------

function tax_inquiry_controls()
{
    start_form();

    start_table(TABLESTYLE_NOBORDER);
	start_row();

	date_cells(_("from:"), 'TransFromDate', '', null, -30);
	date_cells(_("to:"), 'TransToDate');
    check_cells( _("Net Output/Input:"), 'NetAmounts', null);
	submit_cells('Show',_("Show"),'','', 'default');

    end_row();

	end_table();

    end_form();
}

//----------------------------------------------------------------------------------------------------

function show_results()
{
	global $path_to_root;

    /*Now get the transactions  */
	div_start('trans_tbl');
	start_table(TABLESTYLE);

    $netAmounts = check_value('NetAmounts');
    if ($netAmounts)
        $net = _("Net");
    else
        $net = _("Gross");
	$th = array(_("Type"), _("Description"), _("Tax")."<br>"._("Amount"), $net."<br>"._("Outputs")."/"._("Inputs"));
	table_header($th);
	$k = 0;
	$total = 0;
	$bdate = date2sql($_POST['TransFromDate']);
	$edate  = date2sql($_POST['TransToDate']);

	$taxes = get_tax_cash_summary($_POST['TransFromDate'], $_POST['TransToDate']);

	while ($tx = db_fetch($taxes))
	{

		$payable = $tx['payable'];
		$collectible = $tx['collectible'];
		$net = $collectible + $payable;
		$total += $net;
		alt_table_row_color($k);
		label_cell($tx['name'] . " " . $tx['rate'] . "%");
		label_cell(_("Charged on sales") . " (" . _("Output Tax")."):");
		amount_cell($payable);
		if ($netAmounts) {
    		amount_cell($tx['net_output']);
		} else {
            amount_cell($tx['gross_output']);
		}
		end_row();
		alt_table_row_color($k);
		label_cell($tx['name'] . " " . $tx['rate'] . "%");
		label_cell(_("Paid on purchases") . " (" . _("Input Tax")."):");
		amount_cell($collectible);
        if ($netAmounts) {
		    amount_cell($tx['net_input']);
        } else {
            amount_cell($tx['gross_input']);
        }
		end_row();
		alt_table_row_color($k);
		label_cell("<b>".$tx['name'] . " " . $tx['rate'] . "%</b>");
		label_cell("<b>"._("Net payable or collectible") . ":</b>");
		amount_cell($net, true);
		label_cell("");
		end_row();
	}	
	alt_table_row_color($k);
	label_cell("");
	label_cell("<b>"._("Total payable or refund") . ":</b>");
	amount_cell($total, true);
	label_cell("");
	end_row();

	end_table(2);
	div_end();
}

//----------------------------------------------------------------------------------------------------

tax_inquiry_controls();

show_results();

//----------------------------------------------------------------------------------------------------

end_page();

?>
