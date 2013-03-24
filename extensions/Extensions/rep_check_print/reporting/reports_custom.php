<?php

global $reports, $dim;

$reports->addReport(RC_SUPPLIER, "_check_print",_('Printable &Check'),
    array(  _('Payment') => 'REMITTANCE',
            _('Destination') => 'DESTINATION'));
?>
