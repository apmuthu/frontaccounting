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
$page_security = 'SA_ASSETS';
$path_to_root = "../..";
include($path_to_root . "/includes/session.inc");
add_access_extensions();
set_ext_domain('modules/asset_register');

page(_($help_context = "Amortisation Schedule"));

include_once($path_to_root . "/modules/asset_register/includes/modules_db.inc");
include_once($path_to_root . "/includes/ui.inc");

simple_page_mode(true);

//-----------------------------------------------------------------------------------
if(!isset($_POST['year'])) {
	$_POST['year'] = date("Y");
}

echo "<div align='center'><FORM action='amortisation_post.php' method='post'>";
echo "    <LABEL for='year'>Year : </LABEL><INPUT type='text' name='year' value='".$_POST['year'];
echo "' id='year'>";
echo "    <INPUT type='submit' name='submit' value='Search'>";
echo "    <INPUT type='submit' name='amortise_post' value='Post'>";
echo "</FORM></div>";


echo "<hr/>\n";

//-----------------------------------------------------------------------------------

if(isset($_POST['amortise_post']) && isset($_POST['year'])) {
	if ($_POST['amortise_post'] == 'Post') {
		post_amortise($_POST['year']);
	}
}

$result = get_year_assets($_POST['year']);
start_form();
start_table(TABLESTYLE, "width=75%");

$th = array(_("Asset Type"),_("Asset Name"),_("Serial Number"), _("Purchase Date"), _("Purchase Price"), _("Disposal Date"), _("Disposal Amount"));
inactive_control_column($th);
table_header($th);
$k = 0;
while ($myrow = db_fetch($result)) 
{
	
	alt_table_row_color($k);	

	label_cell($myrow["asset_type_name"]);
	label_cell($myrow["asset_name"]);
	label_cell($myrow["asset_serial"]);
	label_cell(sql2date($myrow["purchase_date"]));
	amount_cell($myrow["purchase_value"]);
	label_cell(sql2date($myrow["disposal_date"]));
	amount_cell($myrow["disposal_amount"]);


	end_row();
}
end_table(1);

//-------------------------------------------------------------------------------------------------------------------
$vresult = get_year_asset_valuations($_POST['year']);

start_form();
start_table(TABLESTYLE, "width=75%");

$th = array(_("Name"),_("Serial Number"),_("Valuation Year"),_("Asset Value"),_("Value Change"));
inactive_control_column($th);
table_header($th);
$k = 0;
while ($myrow = db_fetch($vresult)) 
{
	
	alt_table_row_color($k);	

	label_cell($myrow["asset_name"]);
	label_cell($myrow["asset_serial"]);
	label_cell($myrow["valuation_year"]);
	amount_cell($myrow["asset_value"]);
	amount_cell($myrow["value_change"]);

	end_row();
}
end_table(1);

end_form();

// ---------------------------------------------------------------------------------------------

$aresult = get_year_amortisation($_POST['year']);

start_form();
start_table(TABLESTYLE, "width=75%");

$th = array(_("Name"),_("Serial Number"),_("Year"),_("Asset Value"),_("Depreciation"));
inactive_control_column($th);
table_header($th);
$k = 0;
while ($myrow = db_fetch($aresult)) 
{
	alt_table_row_color($k);	

	label_cell($myrow["asset_name"]);
	label_cell($myrow["asset_serial"]);
	label_cell($myrow["amortisation_year"]);
	amount_cell($myrow["asset_value"]);
	amount_cell($myrow["amount"]);

	end_row();
}
end_table(1);


end_page();

?>
