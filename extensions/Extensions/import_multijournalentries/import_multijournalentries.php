<?php
/**********************************************
Author: Tom Hallman
Name: Import Multiple Journal Entries/Deposits/Payments v2.3
Free software under GNU GPL
***********************************************/
$page_security = 'SA_CSVMULTIJOURNALIMPORT';
$path_to_root="../..";

include_once($path_to_root . "/includes/ui/items_cart.inc");
include_once($path_to_root . "/gl/includes/db/gl_db_trans.inc");
include_once($path_to_root . "/includes/session.inc");
add_access_extensions();

// Turn these next two lines on for debugging
//error_reporting(E_ALL);
//ini_set("display_errors", "on");

//--------------------------------------------------------------------------------------------------

function init_entry(&$entry,$type,$date,$reference) // See gl/gl_journal::create_cart() & gl/gl_bank::handle_new_order()
{
	$entry = new items_cart($type);
	$entry->order_id = 0;
	$entry->tran_date = $date;
	$entry->reference = $reference;
	$entry->memo_ = 'Imported via \'Import Multiple Journal Entries\' plugin';	
}

//--------------------------------------------------------------------------------------------------

function import_type_list_row($label, $name, $selected=null, $submit_on_change=false)
{
	$arr = array(
		ST_JOURNAL=> "Journal Entry",
		ST_BANKDEPOSIT=> "Deposit",
		ST_BANKPAYMENT=> "Payment"
	);

	echo "<tr><td class='label'>$label</td><td>";
	echo array_selector($name, $selected, $arr, 
		array(
			'select_submit'=> $submit_on_change,
			'async' => false,
		));
	echo "</td></tr>\n";
}

//--------------------------------------------------------------------------------------------------

function check_journal_entry(&$entry, $entryid)
{
	// Check that this journal entry adds up!
	if (abs($entry->gl_items_total()) > 0.0001)
	{
		display_error("Error: journal entry with entryid '$entryid' does not balance (import file: '{$_FILES['imp']['name']}')");
		return true;
	}
}

function write_trans($type, $entry, $curEntryId, $bank_account)
{
	if ($type == ST_JOURNAL)
	{
		if (!check_journal_entry($entry, $curEntryId));
			write_journal_entries($entry, false, false); // FA built-in function
	} 
	elseif ($type == ST_BANKDEPOSIT || $type == ST_BANKPAYMENT) {
		add_bank_transaction($entry->trans_type, $bank_account, $entry, $entry->tran_date, // FA built-in function
			false, false, false, $entry->reference, $entry->memo_, false);
	}

}
//--------------------------------------------------------------------------------------------------

function get_dimension_id_from_reference($ref)
{
	if ($ref == null || trim($ref) == '')
		return 0;

    $sql = "SELECT id FROM ".TB_PREF."dimensions WHERE reference LIKE ".db_escape($ref);

	$result = db_query($sql, "could not get dimension from reference");

	$row = db_fetch_row($result);

	return $row[0];
}

//--------------------------------------------------------------------------------------------------
// Begin the UI
include_once($path_to_root . "/includes/ui.inc");

page("Import Multiple Journal Entries / Deposits / Payments");

// If the import button was selected, we'll process the form here.  (If not, skip to actual content below.)
if (isset($_POST['import']))
{
	if (isset($_FILES['imp']) && $_FILES['imp']['name'] != '')
	{
		$filename = $_FILES['imp']['tmp_name'];
		$sep = $_POST['sep'];
		$type = $_POST['type'];
		$bank_account = isset($_POST['bank_account']) ? $_POST['bank_account'] : "";

		// Open the file
		$fp = @fopen($filename, "r");
		if (!$fp)
		{
			display_error("Error opening file $filename");
		} else {

			// Initialize first entryid & date to be null so that a new one is established
			$curEntryId = $curDate = null;

			// Prepare the DB to receive the imported journal entries 
			begin_transaction();

			// Process the import file
			$line = 0;
			$entryCount = 0;
			$error = false;
			$errCnt = 0;
			while ($data = fgetcsv($fp, 4096, $sep))
			{
				// Skip the first line, as it's a header
				if ($line++ == 0) continue;

				// Skip blank lines (which shouldn't happen in a well-formed CSV, but we'll be safe)
				if (count($data) == 1) continue;

				// Parse the row of data; Format: entryid,date,reference,accountcode,dimension1,dimension2,amount,memo
				list($entryid, $date, $reference, $code, $dim1_ref, $dim2_ref, $amt, $memo) = $data;

				// If the entryid has changed, create the current journal entry (if there was one) and start a new one
				if ($entryid != $curEntryId) {

					// Check that date is properly-formatted
					if (!is_date($date)) {
						display_error("Error: date '$date' not properly formatted (line $line in import file '{$_FILES['imp']['name']}')");
						$error = true;
					}

					// Check that the date is in range
					if (!is_date_in_fiscalyear($date)) {
						display_error("Error: date not in fiscal year (line $line in import file '{$_FILES['imp']['name']}')");
						$error = true;
					}

					// Assign a default reference if it is not specified
					if ($reference == '') {
						// If the entryid has shifted but date is the same, it needs another reference
						if ($date == $curDate)
							$refCount++;
						else // else the entryid and date have shifted, so we can start with a new reference
							$refCount = 1;
						list($day, $month, $year) = explode_date_to_dmy($date);
						$reference = "$month/$day-$refCount";
					}

					// Check that the reference is not in use
					global $Refs;
					if ($Refs->exists($type, $reference)) {
						display_error("Error: reference '$reference' is already in use (line $line in import file '{$_FILES['imp']['name']}')");
						$error = true;
					}

					// All good! Initialize a new entry  
					if ($curEntryId != null) {
						if (!$error)
						{
							write_trans($type, $entry, $curEntryId, $bank_account);
							$entryCount++;
						}
					}
					if ($error)
						$errCnt++;
					$error = false;
					init_entry($entry,$type,$date,$reference);
					$curEntryId = $entryid;
					$curDate = $date;
				}

				if ($entryid == '') {
					display_error("Error: entryid not specified (line $line in import file '{$_FILES['imp']['name']}')");
					$error = true;
				}
				// Check that the account code exists
				if (get_gl_account($code) == null) {
					display_error("Error: Could not find account code '$code' (line $line in import file '{$_FILES['imp']['name']}')");
					$error = true;
				}
				// Check that dimension 1 exists
				$dim1 = get_dimension_id_from_reference($dim1_ref); 
				if ($dim1_ref != '' && $dim1 == null) {
					display_error("Error: Could not find dimension with reference '$dim1_ref' (line $line in import file '{$_FILES['imp']['name']}')");
					$error = true;
				}
				// Check that dimension 2 exists
				$dim2 = get_dimension_id_from_reference($dim2_ref);
				if ($dim2_ref != '' && $dim2 == null) {
					display_error("Error: Could not find dimension with reference '$dim2_ref' (line $line in import file '{$_FILES['imp']['name']}')");
					$error = true;
				}

				if ($type == ST_BANKDEPOSIT)
					$amt = -$amt;

				// Add to the journal entry / deposit / payment
				if (!$error)
					$entry->add_gl_item($code, $dim1, $dim2, $amt, $memo);
			}

			// Process final entries in the file
			if (!$error)
			{
				if ($curEntryId != null) {
					write_trans($type, $entry, $curEntryId, $bank_account);
					$entryCount++;
				}
			} else 
				$errCnt++;

			@fclose($fp);

			// Commit import to database
			if (!$errCnt)
				commit_transaction();

			if ($type == ST_JOURNAL)
				$typeString = "journal entries";
			elseif ($type == ST_BANKDEPOSIT)
				$typeString = "deposits";
			elseif ($type == ST_BANKPAYMENT)
				$typeString = "payments";

			if (!$errCnt) {
				if ($entryCount > 0)
					display_notification_centered("$entryCount $typeString have been imported.");
				else
					display_error("Import file contained no $typeString.");
			}
		}
	}
	else
		display_error("No import file selected");
}

start_form(true);

start_table(TABLESTYLE2);

if (!isset($_POST['type']))
	$_POST['type'] = ST_JOURNAL;

if (!isset($_POST['sep']))
	$_POST['sep'] = ",";

table_section_title("Import Settings");
import_type_list_row("Import Type:", 'type', $_POST['type'], true);
if ($_POST['type'] != ST_JOURNAL)
	bank_accounts_list_row( $_POST['type'] == ST_BANKPAYMENT ? _("From:") : _("To:"), 'bank_account', null, false);
text_row("Field Separator:", 'sep', $_POST['sep'], 2, 1);
label_row("Import File:", "<input type='file' id='imp' name='imp'>");

end_table(1);

submit_center('import', "Perform Import");//,true,false,'process',ICON_SUBMIT);

end_form();

end_page();

?>
