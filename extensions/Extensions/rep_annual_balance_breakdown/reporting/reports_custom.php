<?php

global $reports, $dim;

$reports->addReport(RC_GL,"_annual_balance_breakdown",_('Annual &Balance Breakdown - Detailed'),
       array(  _('Report Period') => 'DATEENDM',
                       _('Dimension')." 1" =>  'DIMENSIONS1',
                       _('Dimension')." 2" =>  'DIMENSIONS2',
                       _('Comments') => 'TEXTBOX',
                       _('Destination') => 'DESTINATION'));
?>
