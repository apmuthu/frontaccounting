<?php

global $reports, $dim;
			
$reports->addReport(RC_BANKING, "_statement_reconcile", _('Bank Statement w/&Reconcile'),
	array(	_('Bank Accounts') => 'BANK_ACCOUNTS',
			_('Start Date') => 'DATEBEGINM',
			_('End Date') => 'DATEENDM',
			_('Comments') => 'TEXTBOX',
			_('Destination') => 'DESTINATION'));
?>
