<?php

global $reports, $dim;
			
$reports->addReport(RC_INVENTORY,"_sales_summary",_('&Sales Summary Report'),
	array(	_('Start Date') => 'DATEBEGINM',
			_('End Date') => 'DATEENDM',
			_('Inventory Category') => 'CATEGORIES',
			_('Comments') => 'TEXTBOX',
			_('Destination') => 'DESTINATION'));				
?>
