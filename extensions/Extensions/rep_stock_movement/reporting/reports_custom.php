<?php

global $reports, $dim;
			
$reports->addReport(RC_INVENTORY,"_stock_movement",_('Stock &Movement Report'),
	array(	_('Inventory Category') => 'CATEGORIES',
			_('Location') => 'LOCATIONS',
			_('From Date') => 'DATE',
			_('To Date') => 'DATE',
			_('Comments') => 'TEXTBOX',
			_('Destination') => 'DESTINATION'));				
?>
