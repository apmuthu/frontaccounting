<?php
// ----------------------------------------------------------------
// $ Revision:  1.0 $
// Creator: Alastair Robertson
// date_:   2011-10-28
// Title:   D/b access for paypal transaction import
// Free software under GNU GPL
// ----------------------------------------------------------------

function clear_paypal_items($user_id) {

    $sql = "DELETE FROM ".TB_PREF."import_paypal "
            . "WHERE user_id = ".db_escape($user_id);
    return db_query($sql,"Cannot clear paypal items");
}

function get_paypal_items($user_id) {

    $sql = "SELECT ref,date,person,memo,amount,account "
          ."FROM ".TB_PREF."import_paypal "
          ."WHERE user_id = ".db_escape($user_id);
          return $sql;
}
function get_paypal_item_by_ref($ref) {

    $sql = "SELECT id,user_id,date,ref,person,memo,amount,account "
          ."FROM ".TB_PREF."import_paypal "
          ."WHERE ref = ".db_escape($ref);
    $result = db_query($sql,"Cannot retrieve paypal items");
    return db_fetch($result);
}

function get_paypal_unconfirmed_count($user_id) {

    $sql = "SELECT COUNT(*) Total, "
          ."SUM(CASE WHEN account IS NULL OR account = '' THEN 1 ELSE 0 END) Pending "
          ."FROM ".TB_PREF."import_paypal "
          ."WHERE user_id = ".db_escape($user_id);

    $result = db_query($sql,"Cannot retrieve paypal unconfirmed");
    $row = db_fetch_row($result);
    return $row;
}

function find_customer_by_name($name) {
    $sql = "SELECT debtor_no "
            ."FROM ".TB_PREF."debtors_master dm "
            ."WHERE dm.name = ".db_escape($name);

    $result = db_query($sql,"Cannot customer by name");
    $row = db_fetch_row($result);
    return $row[0];
}

function find_customer_by_email($email) {
    $sql = "SELECT debtor_no "
            ."FROM ".TB_PREF."debtors_master dm "
            ."INNER JOIN ".TB_PREF."crm_contacts cc ON dm.debtor_no = cc.entity_id AND cc.type = 'customer' "
            ."INNER JOIN ".TB_PREF."crm_persons cp on cc.person_id = cp.id "
            ."WHERE cp.email = ".db_escape($email);

    $result = db_query($sql,"Cannot customer by email");
    $row = db_fetch_row($result);
    return $row[0];
}

function find_customer_branch_by_customer_id($customer_id) {
    $sql = "SELECT branch_code "
            ."FROM ".TB_PREF."cust_branch cb "
            ."WHERE cb.debtor_no = ".db_escape($customer_id)
            ." LIMIT 1 ";

    $result = db_query($sql,"Cannot branch by customer id");
    $row = db_fetch_row($result);
    return $row[0];
}

function find_unpaid_invoice_for_customer($customer_id) {
    $sql = "SELECT debtor_no "
            ."FROM ".TB_PREF."debtors_master dm "
            ."WHERE dm.debtor_ref = ".db_escape($ref);

    $result = db_query($sql,"Cannot customer by ref");
    $row = db_fetch_row($result);
    return $row[0];
}

function insert_paypal_item($user_id, $date, $ref, $person, $memo, $amount, $account) {
    // let account and confirmed get default value on initial insert
    $sql = "INSERT INTO ".TB_PREF."import_paypal"
          ."(user_id,date,ref,person,memo,amount)"
          ."VALUES (".db_escape($user_id).",".db_escape(date2sql($date)).","
          .db_escape($ref).",".db_escape($person).","
          .db_escape($memo).",".db_escape($amount).")";
    return db_query($sql,"Cannot insert paypal item");
}

function update_paypal_item_account($ref, $account) {

  $sql = "UPDATE ".TB_PREF."import_paypal "
            ."SET account = ".db_escape($account)
            ."WHERE ref = ".db_escape($ref);
    return db_query($sql,"Cannot update paypal account");
}

function update_paypal_item_default_account() {

    $sql = "UPDATE ".TB_PREF."import_paypal ip, ".TB_PREF."import_paypal_accounts ipa "
            ."SET ip.account = ipa.account "
            ."WHERE ip.memo = ipa.memo";
    db_query($sql,"Cannot update paypal account");

    $sql = "UPDATE ".TB_PREF."import_paypal ip, ".TB_PREF."import_paypal_accounts ipa "
        ."SET ip.account = ipa.account "
        ."WHERE ip.person = ipa.person "
        ."AND ip.account IS NULL";
    return db_query($sql,"Cannot update paypal account");
}
function save_paypal_item_account() {

    $sql = "UPDATE ".TB_PREF."import_paypal_accounts ipa, ".TB_PREF."import_paypal ip "
            ."SET ipa.account = ip.account "
            ."WHERE ip.memo = ipa.memo "
            ."AND ip.person = ipa.person ";
    db_query($sql,"Cannot update paypal account");

    $sql = "INSERT INTO ".TB_PREF."import_paypal_accounts "
            ."(person,memo,account) "
            ."SELECT DISTINCT ip.person, ip.memo, ip.account "
            ."FROM ".TB_PREF."import_paypal ip "
            ."LEFT JOIN ".TB_PREF."import_paypal_accounts ipa "
            ."ON ip.memo = ipa.memo "
            ."AND ip.person = ipa.person "
            ."WHERE ipa.id IS NULL";
    db_query($sql,"Cannot insert paypal accounts");
}
?>