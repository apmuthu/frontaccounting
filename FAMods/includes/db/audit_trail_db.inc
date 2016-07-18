<?php
/**********************************************************************
	Copyright (C) FrontAccounting, LLC.
	Released under the terms of the GNU General Public License, GPL, 
	as published by the Free Software Foundation, either version 3 
	of the License, or (at your option) any later version.
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
	See the License here <http://www.gnu.org/licenses/gpl-3.0.html>.
***********************************************************************/

function add_audit_trail($trans_type, $trans_no, $trans_date, $descr='')
{
	$sql = "INSERT INTO ".TB_PREF."audit_trail"
		. " (type, trans_no, user, fiscal_year, gl_date, description, gl_seq)
			VALUES(".db_escape($trans_type).", ".db_escape($trans_no).","
			. $_SESSION["wa_current_user"]->user. ","
			. get_company_pref('f_year') .","
			. "'". date2sql($trans_date) ."',"
			. db_escape($descr). ", 0)";

	db_query($sql, "Cannot add audit info");
	
	// all audit records beside latest one should have gl_seq set to NULL
	// to avoid need for subqueries (not existing in MySQL 3) all over the code
	$sql = "UPDATE ".TB_PREF."audit_trail SET gl_seq = NULL"
		. " WHERE type=".db_escape($trans_type)." AND trans_no="
		.db_escape($trans_no)." AND id!=".db_insert_id();

	db_query($sql, "Cannot update audit gl_seq");
}

function get_audit_trail_all($trans_type, $trans_no)
{
	$sql = "SELECT * FROM ".TB_PREF."audit_trail"
		." WHERE type=".db_escape($trans_type)." AND trans_no="
		.db_escape($trans_no);

	return db_query($sql, "Cannot get all audit info for transaction");
}

function get_audit_trail_last($trans_type, $trans_no)
{
	$sql = "SELECT * FROM ".TB_PREF."audit_trail"
		." WHERE type=".db_escape($trans_type).
			" AND trans_no=".db_escape($trans_no)." AND NOT ISNULL(gl_seq)";

	$res = db_query($sql, "Cannot get last audit info for transaction");
	if ($res)
		$row = db_fetch($res);

	return $row;
}

/*
	Confirm and close for edition all transactions up to date $todate, 
	and reindex	journal.
*/
function close_transactions($todate) {
	$errors = 0;

	begin_transaction();

	$sql = "DROP TABLE IF EXISTS ".TB_PREF."audit_tmp";
	db_query($sql, "Cannot drop hold table if present");

	$sql2 = "CREATE TABLE ".TB_PREF."audit_tmp SELECT id, Counter AS gl_seq FROM 
		( SELECT id, gl_date, fiscal_year
			, (@counter:=IF(fiscal_year <> @lastyr, 1, @counter+1)) AS Counter
			, (@lastyr:=IF(fiscal_year <> @lastyr, fiscal_year, @lastyr)) AS LastYr FROM
			( SELECT DISTINCT a.id, a.gl_date, a.fiscal_year 
				FROM ".TB_PREF."gl_trans gl INNER JOIN ".TB_PREF."audit_trail a 
				  ON (gl.type=a.type AND gl.type_no=a.trans_no) 
				WHERE gl_date<='". date2sql($todate) ."' AND NOT ISNULL(gl_seq) 
				ORDER BY a.fiscal_year, a.gl_date, a.id) b, (SELECT (@lastyr:=0), (@counter:=1)
			) w
		) c";
	db_query($sql2, "Cannot create hold table for gl_seq sequential values");

	$sql3 = "UPDATE ".TB_PREF."audit_tmp a LEFT JOIN ".TB_PREF."audit_trail b USING (id) 
			SET b.gl_seq=a.gl_seq";
	$result = db_query($sql3, "Cannot update audit_trail.gl_seq from hold table");

	db_query($sql, "Cannot drop hold table");

	commit_transaction();
}

/*
	Reopen all transactions for edition up from date $fromdate
*/
function open_transactions($fromdate) {

	$sql = "UPDATE ".TB_PREF."audit_trail SET gl_seq=0 
		WHERE gl_date>='". date2sql($fromdate) ."' 
		AND !ISNULL(gl_seq) AND !ISNULL(fiscal_year)";

	$result = db_query($sql, "Cannot open transactions");
}

/*
	Closed transactions have gl_seq number assigned.
*/
function is_closed_trans($type, $trans_no) {
	$sql = "SELECT	gl_seq  FROM ".TB_PREF."audit_trail"
		. " WHERE type=".db_escape($type)
		." AND trans_no=".db_escape($trans_no)
		." AND gl_seq>0";

	$res = db_query($sql, "Cannot check transaction");

	return db_num_rows($res);
}

?>
