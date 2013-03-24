<?php

global $reports, $dim;
			
$reports->addReport(RC_INVENTORY,"_dated_stock",_('Dated Stock Sheet'),
	array(	_('Date') => 'DATE',
			_('Inventory Category') => 'CATEGORIES',
			_('Location') => 'LOCATIONS',
			_('Comments') => 'TEXTBOX',
			_('Destination') => 'DESTINATION'));				
?>
