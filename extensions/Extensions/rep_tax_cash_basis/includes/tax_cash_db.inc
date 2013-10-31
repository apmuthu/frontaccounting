<?php
// ----------------------------------------------------------------
// $ Revision:  1.0 $
// Creator: Alastair Robertson
// date_:   2011-10-22
// Title:   D/b access for Tax inquiry & detail report (cash basis)
// Free software under GNU GPL
// ----------------------------------------------------------------

function get_tax_cash_summary($from, $to)
{

    $sql = "SELECT SUM(gross_output) gross_output,
               SUM(net_output) net_output,
               SUM(payable) payable,
               SUM(gross_input) gross_input,
               SUM(net_input) net_input,
               SUM(collectible) collectible,
               rate,
               id,
               name
        FROM (".tax_cash_sql($from, $to).") taxrec
        GROUP BY id, name, rate";
//display_error($sql);
    return db_query($sql,"Cannot retrieve tax summary");
}

function get_tax_cash_details($from, $to)
{

    $sql = "SELECT *
        FROM (".tax_cash_sql($from, $to).") taxrec
        ORDER BY name, output desc, trans_date, rate";
//display_error($sql);
    return db_query($sql,"Cannot retrieve tax details");
}

function tax_cash_sql($from, $to) {

    $fromdate = date2sql($from);
    $todate = date2sql($to);

    $sql = "SELECT
            'Output',
            ca.amt gross_output,
            (ca.amt/(ttd.net_amount+ttd.amount)) * ttd.net_amount * ex_rate net_output,
            (ca.amt/(ttd.net_amount+ttd.amount)) * ttd.amount*ex_rate payable,
            0 gross_input,
            0 net_input,
            0 collectible,
            ttd.rate,
            bt.type,
            bt.person_type_id,
            bt.person_id,
            ttd.trans_no,
            tt.id,
            tt.name,
            bt.trans_date
        FROM ".TB_PREF."bank_trans bt
        INNER JOIN ".TB_PREF."cust_allocations ca
            ON bt.type = ca.trans_type_from
            AND bt.trans_no = ca.trans_no_from
        INNER JOIN ".TB_PREF."debtor_trans dt
            ON dt.type = ca.trans_type_from
            AND dt.trans_no = ca.trans_no_from
        INNER JOIN ".TB_PREF."trans_tax_details ttd
            ON ttd.trans_type = ca.trans_type_to
            AND ttd.trans_no = ca.trans_no_to
        INNER JOIN ".TB_PREF."tax_types tt
            ON tt.id = ttd.tax_type_id
        WHERE bt.trans_date >= '$fromdate'
            AND bt.trans_date <= '$todate'
    UNION ALL
        SELECT
            'Output',
            bt.amount*ex_rate gross_output,
            ttd.net_amount*ex_rate net_output,
            ttd.amount*ex_rate payable,
            0 gross_input,
            0 net_input,
            0 collectible,
            ttd.rate,
            bt.type,
            bt.person_type_id,
            bt.person_id,
            ttd.trans_no,
            tt.id,
            tt.name,
            bt.trans_date
        FROM ".TB_PREF."bank_trans bt
        INNER JOIN ".TB_PREF."trans_tax_details ttd
            ON ttd.trans_type = bt.type
            AND ttd.trans_no = bt.trans_no
        INNER JOIN ".TB_PREF."tax_types tt
            ON tt.id = ttd.tax_type_id
        WHERE bt.type = ".BT_CREDIT."
            AND bt.person_type_id <> ".PT_SUPPLIER."
            AND bt.trans_date >= '$fromdate'
            AND bt.trans_date <= '$todate'
    UNION ALL
        SELECT
            'Output',
            bt.amount*ex_rate gross_output,
            ttd.net_amount*ex_rate net_output,
            ttd.amount*ex_rate payable,
            0 gross_input,
            0 net_input,
            0 collectible,
            ttd.rate,
            bt.type,
            bt.person_type_id,
            bt.person_id,
            ttd.trans_no,
            tt.id,
            tt.name,
            bt.trans_date
        FROM ".TB_PREF."bank_trans bt
        INNER JOIN ".TB_PREF."trans_tax_details ttd
            ON ttd.trans_type = bt.type
            AND ttd.trans_no = bt.trans_no
        INNER JOIN ".TB_PREF."tax_types tt
            ON tt.id = ttd.tax_type_id
        WHERE bt.type = ".BT_CHEQUE."
            AND bt.person_type_id = ".PT_CUSTOMER."
            AND bt.trans_date >= '$fromdate'
            AND bt.trans_date <= '$todate'
    UNION ALL
        SELECT
            'Input',
            0 gross_output,
            0 net_output,
            0 payable,
            sa.amt*ex_rate gross_input,
            ttd.net_amount*sa.amt/round(ov_amount+ov_gst+ov_discount,6)*ex_rate net_input,
            -1*ttd.amount*sa.amt/round(ov_amount+ov_gst+ov_discount,6)*ex_rate collectible,
            ttd.rate,
            bt.type,
            bt.person_type_id,
            bt.person_id,
            ttd.trans_no,
            tt.id,
            tt.name,
            bt.trans_date
        FROM ".TB_PREF."bank_trans bt
        INNER JOIN ".TB_PREF."supp_allocations sa
            ON bt.type = sa.trans_type_from
            AND bt.trans_no = sa.trans_no_from
        INNER JOIN ".TB_PREF."supp_trans st
            ON st.type = sa.trans_type_from
            AND st.trans_no = sa.trans_no_from
        INNER JOIN ".TB_PREF."trans_tax_details ttd
            ON ttd.trans_type = sa.trans_type_to
            AND ttd.trans_no = sa.trans_no_to
        INNER JOIN ".TB_PREF."tax_types tt
            ON tt.id = ttd.tax_type_id
        WHERE bt.trans_date >= '$fromdate'
            AND bt.trans_date <= '$todate'
    UNION ALL
        SELECT
            'Input',
            0 gross_output,
            0 net_output,
            0 payable,
            bt.amount*ex_rate gross_input,
            ttd.net_amount*ex_rate net_input,
            ttd.amount*ex_rate collectible,
            ttd.rate,
            bt.type,
            bt.person_type_id,
            bt.person_id,
            ttd.trans_no,
            tt.id,
            tt.name,
            bt.trans_date
        FROM ".TB_PREF."bank_trans bt
        INNER JOIN ".TB_PREF."trans_tax_details ttd
            ON ttd.trans_type = bt.type
            AND ttd.trans_no = bt.trans_no
        INNER JOIN ".TB_PREF."tax_types tt
            ON tt.id = ttd.tax_type_id
        WHERE bt.type <> ".BT_CREDIT."
            AND bt.person_type_id <> ".PT_CUSTOMER."
            AND bt.trans_date >= '$fromdate'
            AND bt.trans_date <= '$todate'
    UNION ALL
        SELECT
            'Input',
            0 gross_output,
            0 net_output,
            0 payable,
            bt.amount*ex_rate gross_input,
            ttd.net_amount*ex_rate net_input,
            ttd.amount*ex_rate collectible,
            ttd.rate,
            bt.type,
            bt.person_type_id,
            bt.person_id,
            ttd.trans_no,
            tt.id,
            tt.name,
            bt.trans_date
        FROM ".TB_PREF."bank_trans bt
        INNER JOIN ".TB_PREF."trans_tax_details ttd
            ON ttd.trans_type = bt.type
            AND ttd.trans_no = bt.trans_no
        INNER JOIN ".TB_PREF."tax_types tt
            ON tt.id = ttd.tax_type_id
        WHERE bt.type = ".BT_CHEQUE."
            AND bt.person_type_id = ".PT_SUPPLIER."
            AND bt.trans_date >= '$fromdate'
            AND bt.trans_date <= '$todate'
            ";
  return $sql;
}
?>