<?php

global $reports;

$reports->addReport(RC_CUSTOMER, "_email_customers", _('Email Customers'),
	array(  _('Customer') => 'CUSTOMERS_NO_FILTER',
			_('Email Subject') => 'TEXT',
			_('Email Body') => 'TEXTBOX',
			_('email Customers') => 'YES_NO',
			_('Areas') => 'AREAS',
			_('Filter Areas') => 'YES_NO',
			_('Price List') => 'SALESTYPES',
			_('Filter Price List') => 'YES_NO',
			_('Salesmen') => 'SALESMEN',
));


