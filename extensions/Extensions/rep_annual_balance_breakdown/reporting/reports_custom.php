<?php

global $reports, $dim;

$reports->addReport(RC_GL,"_annual_balance_breakdown",_('Annual &Balance Breakdown - Detailed'),
       array(  _('Report Period') => 'DATEENDM',
                       _('Dimension') => 'DIMENSIONS1',
                       _('Comments') => 'TEXTBOX',
                       _('Destination') => 'DESTINATION'));
?>
