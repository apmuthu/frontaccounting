<?php

global $reports;

$reports->addReport(RC_GL,"_annual_expense_breakdown",_('Annual &Expense Breakdown - Detailed'),
       array(  _('Report Period') => 'DATEENDM',
                       _('Dimension') => 'DIMENSIONS1',
                       _('Comments') => 'TEXTBOX',
                       _('Destination') => 'DESTINATION'));
?>
