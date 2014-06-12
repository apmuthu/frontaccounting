<?php

global $reports;

$reports->addReport(RC_BANKING,"_cash_flow_statement",_('Cash Flow Statement'),
       array(  _('Report Period') => 'DATEENDM',
                       _('Dimension') => 'DIMENSIONS1',
                       _('Comments') => 'TEXTBOX',
                       _('Destination') => 'DESTINATION'));
?>
