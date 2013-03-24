<?php
/*******************************************************************************
 * Copyright(c) @2011 ANTERP SOLUTIONS. All rights reserved.
 *
 * Released under the terms of the GNU General Public License, GPL, 
 * as published by the Free Software Foundation, either version 3 
 * of the License, or (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
 * See the License here <http://www.gnu.org/licenses/gpl-3.0.html>.
 *
 * Authors		    tclim
 * Date Created     Jun 12, 2011 2:06:39 PM
 ******************************************************************************/
 
//This part is to configure for LDAP Server

// LDAP Server
define("_LDAP_HOST", "localhost");                                                          	//LDAP Server Host
define("_LDAP_PORT", "389");                                                                   	//LDAP Port
define("_LDAP_DOMAIN", "example.com");                                                       	//LDAP Domain Name
define("_LDAP_SUFFIX", "dc=example,dc=com");                                                   	//LDAP Suffix
define("_LDAP_MODULE", "acct");                                                                 //LDAP Module
define("_LDAP_AUTH", "0");                                                                      //LDAP Authentication (1 = Yes, 0 = No)
define("_LDAP_SECURE_CONN", "0");                                                               //LDAP Secure Connection.  0 = no, 1 = TLS, 2 = SSL

?>
