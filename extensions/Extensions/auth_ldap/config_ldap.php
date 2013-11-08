<?php
/*******************************************************************************
 * Copyright(c) 2013
 *
 * Released under the terms of the GNU General Public License, GPL, 
 * as published by the Free Software Foundation, either version 3 
 * of the License, or (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
 * See the License here <http://www.gnu.org/licenses/gpl-3.0.html>.
 *
 * Authors       msquared
 * Date Created  Nov 8, 2013
 ******************************************************************************/

$_ldap_config = array (
    // default configuration for all companies
    'default' => array (
        // LDAP authentication enabled?
        'enabled' => true,
        // LDAP configuration
        'ldap' => array (
            'host' => 'ldap',
            'port' => 389,
            'domain' => 'mycompany.com.au',
            'suffix' => 'dc=mycompany,dc=com,dc=au',
            'security' => 0,  // 0 = none, 1 = TLS, 2 = SSL
        ),
        // Map LDAP groups to FA roles
        // (first matching group sets the user's role)
        'group_role_map' => array (
            'Accounts Payable' => 'AP Officer',
            'Accounts Receivable' => 'AR Officer',
            'Sales' => 'Salesman',
            'Stores' => 'Purchase Officer',
            'Managers' => 'System Administrator',
            'Wheel' => 'System Administrator',
        ),
    ),
    // per-company overrides
    // (you can override 'enabled', 'ldap', or 'group_role_map' keys)
    'company' => array (
/*
        // example: this company doesn't use any LDAP authentication
        1 => array (
            'enabled' => false,
        ),
        // example: this company has some separate groups just for this company
        4 => array (
            'group_role_map' => array (
                'OtherCompany Accounts Payable' => 'AP Officer',
                'OtherCompany Accounts Receivable' => 'AR Officer',
                'OtherCompany Sales' => 'Salesman',
                'OtherCompany Stores' => 'Purchase Officer',
                'Managers' => 'System Administrator',
                'Wheel' => 'System Administrator',
            ),
        ),
*/
    ),
);

?>
