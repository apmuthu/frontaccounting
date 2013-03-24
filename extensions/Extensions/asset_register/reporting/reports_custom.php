<?php

global $reports, $dim;

$reports->addReport(RC_INVENTORY, "_assets_list", _('Assets List'),
       array( _('Comments') => 'TEXTBOX', _('Destination') => 'DESTINATION'));
?>
