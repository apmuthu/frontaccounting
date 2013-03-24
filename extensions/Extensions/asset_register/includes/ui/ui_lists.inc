<?php

include_once($path_to_root . "/includes/ui.inc");

function asset_type_list($name, $selected_id=null, $submit_on_change=false)
{
	$sql = "SELECT asset_type_id, asset_type_name, inactive FROM ".TB_PREF."asset_types";

// default to the company currency
return combo_input($name, $selected_id, $sql, 'asset_type_id', 'asset_type_name',
	array(
		'select_submit'=> $submit_on_change,
		'default' => 1,
		'async' => false
	) );
}

function asset_type_list_cells($label, $name, $selected_id=null, $submit_on_change=false)
{
	if ($label != null)
		echo "<td>$label</td>\n";
	echo "<td>";
	echo asset_type_list($name, $selected_id, $submit_on_change);
	echo "</td>\n";
}

function asset_type_list_row($label, $name, $selected_id=null, $submit_on_change=false)
{
	echo "<tr><td class='label'>$label</td>";
	asset_type_list_cells(null, $name, $selected_id, $submit_on_change);
	echo "</tr>\n";
}

?>
