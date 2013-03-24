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
function add_requisition($point_of_use, $narrative, $details)
{
	$sql = "INSERT INTO ".TB_PREF."requisitions (point_of_use, narrative, details) VALUES (".
		db_escape($point_of_use).",".db_escape($narrative).",".db_escape($details).")";

	db_query($sql, "could not add requisitions");
}

function update_requisition($selected_id, $point_of_use, $narrative, $details)
{
	$sql = "UPDATE ".TB_PREF."requisitions SET point_of_use=".db_escape($point_of_use)
			.", narrative=".db_escape($narrative)
			.", details=".db_escape($details)
			."WHERE requisition_id=".db_escape($selected_id);

	db_query($sql, "could not update Requisition");
}

function get_all_requisitions($all=false)
{
	$sql = "SELECT * FROM ".TB_PREF."requisitions WHERE (completed = 0)";
	if (!$all) $sql .= " AND !inactive";

	return db_query($sql, "could not get all requisitions");
}

function get_one_requisition($selected_id)
{
	$sql = "SELECT * FROM ".TB_PREF."requisitions WHERE requisition_id=".db_escape($selected_id);

	return db_query($sql, "could not get Requisition");
}

function get_requisition($selected_id)
{
	$sql = "SELECT * FROM ".TB_PREF."requisitions WHERE requisition_id=".db_escape($selected_id);

	$result = db_query($sql, "could not get Requisition");

	return db_fetch($result);
}

function delete_requisition($selected_id)
{
	$sql="DELETE FROM ".TB_PREF."requisitions WHERE requisition_id=".db_escape($selected_id);

	db_query($sql, "could not delete Requisition");
}

function complete_requisition($selected_id)
{
	$sql = "UPDATE ".TB_PREF."requisitions SET completed =  1 WHERE requisition_id=".db_escape($selected_id);

	db_query($sql, "could not complete Requisition");
}

function generate_po()
{
	$sql = "SELECT ".TB_PREF."generate_po()";

	$result = db_query($sql, "could not process Requisition to Purchase Order");
	$row = db_fetch($result);
	return $row[0] == 'Done';
}

function requisitions_in_details($selected_id)
{
	$sql="SELECT COUNT(*) FROM ".TB_PREF."requisition_details WHERE requisition_id=".db_escape($selected_id);

	$result = db_query($sql, "could not query assets");
	$myrow = db_fetch_row($result);
	return ($myrow[0] > 0); 
}

?>
