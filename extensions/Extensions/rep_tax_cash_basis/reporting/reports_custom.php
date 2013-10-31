<?php
// ----------------------------------------------------------------
// $ Revision:  1.0 $
// Creator: Alastair Robertson
// date_:   2011-10-22
// Title:   Report hook for tax details (cash basis)
// Free software under GNU GPL
// ----------------------------------------------------------------

global $reports, $dim;

$reports->addReport(RC_GL, "_tax_details_cash", _('Tax Details (Cash Basis)'),
	array(	_('Start Date') => 'DATEBEGINTAX',
			_('End Date') => 'DATEENDTAX',
            _('Net Output/Input Amounts') => 'YES_NO',
			_('Comments') => 'TEXTBOX',
			_('Destination') => 'DESTINATION'));
?>
