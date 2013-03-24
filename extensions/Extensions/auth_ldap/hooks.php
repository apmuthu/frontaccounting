<?php
include dirname(__FILE__).'/config_ldap.php';
include dirname(__FILE__).'/lib/Ldap.php';

class hooks_auth_ldap extends hooks {
        var $module_name = 'auth_ldap'; // extension module name.

	/*
  	 * This method is to authenticate users login via OpenLDAP Server
  	 * $username		-	User ID
  	 * $password 		-	Password
  	 */
	function authenticate($login, $password)
	{
		if (_LDAP_AUTH)
			return null;

  		$ldap = new Ldap();
		$ldapAuth = false;
		$ldap->setHost(_LDAP_HOST);
		$ldap->setPort(_LDAP_PORT);
		$ldap->setDomain(_LDAP_DOMAIN);
		$ldap->setLdapPrefix(_LDAP_SUFFIX);
		$ldap->setLdapModules(_LDAP_MODULE);
		//$ldap->setUserAccountControl(512);
		$ldap->setWindows(true);
		$ldap->setUser(trim($user_id));
		$ldap->setPswd(trim($password));

		if (_LDAP_SECURE_CONN == 1) { //TLS Connection
			$ldap->setLdapTLS(true);
			$ldap->setLdapSecure(false);
		} else if (_LDAP_SECURE_CONN == 2) { //SSL Connection
			$ldap->setLdapTLS(false);
			$ldap->setLdapSecure(true);
		} else { //Unsecure Connection
			$ldap->setLdapTLS(false);
			$ldap->setLdapSecure(false);
		}

		// First check we actually have a username and password set inside the ldap object.
		if($ldap->getUser() && $ldap->getPswd()){
			if($ldap->LdapConn()){
				if($ldap->LdapBind()){
				//echo "Success!!!";
				$ldapAuth = $ldap->groupMemberOf($ldap->getUser(), _LDAP_MODULE);
				}
			}
		}
		//Completed Code for auth OpenLDAP

		//Checking the New Ldap User that does not exists in FA
		if ($ldapAuth) {
			set_global_connection();

			$ret = get_user_by_login($user_id);

			if ($ret) { //User exists

					$id = $ret[0];

					//Snychoronize Ldap Data to FA
					$this->_SyncLdapToUser($ldap, 'UDPT', $id, trim($user_id), $password);
			} else { //New users detected. We need to synchornize to FA Users

					//Snychoronize Ldap Data to FA
					$this->_SyncLdapToUser($ldap, 'ADD', "", trim($user_id), $password);
			}
			return true;
		} else {
			return false;
		}
  	}

  	/*
  	 * This method is to popular user data from LdapServer 
  	 * $user_id		-	User ID
  	 * $password 		-	Password
  	 */
	 function _SyncLdapToUser($ldap, $action, $id, $username, $password) {

		$groupSearch = $ldap->getLdapModules();
		$userRole = "Inquiries";
		$language = "en_US";
		$profile = "";
		$rep_popup = "1";
		$pos = "1";
		$isActive = "1";
		$userArray = "";

		//Get user group id from table user_group
		$sql = "SELECT id FROM ".TB_PREF."security_roles WHERE role = ".db_escape($userRole);

		$query = db_query($sql, "could not get user role for $userRole");

		$ret = db_fetch($query);
		$role_id = $ret[0];

		if ($action  == 'ADD') {
			//Insert New User to FA user table
			add_user($ldap->getAttribute('uid'), $ldap->getAttribute('sn') . " " . $ldap->getAttribute('givenname'), 
				md5($password), $ldap->getAttribute('mobile'), $ldap->getAttribute('mail'), $role_id, $language, $profile, $rep_popup, $pos);
		} else {
			update_user($id, $ldap->getAttribute('uid'), $ldap->getAttribute('sn') . " " . $ldap->getAttribute('givenname'), 
				$ldap->getAttribute('mobile'), $ldap->getAttribute('mail'), $role_id, $language, $profile, $rep_popup, $pos);
		}
  	}

}
?>
