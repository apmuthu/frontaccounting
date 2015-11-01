<?php

global $reports;

$reports->addReport(RC_GL,"_annual_expense_breakdown",_('Annual &Expense Breakdown - Detailed'),
       array(  _('Report Period') => 'DATEENDM',
                       _('Dimension')." 1" => 'DIMENSIONS1',
                       _('Dimension')." 2" => 'DIMENSIONS2',
                       _('Comments') => 'TEXTBOX',
                       _('Destination') => 'DESTINATION'));
?>
