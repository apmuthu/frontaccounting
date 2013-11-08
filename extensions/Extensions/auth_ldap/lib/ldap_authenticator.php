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

include dirname(__FILE__).'/Ldap.php';

class ldap_authenticator
{
    protected $configuration;
    protected $company;

    /*
     * Static constructor
     */
    public static function create()
    {
        return new static();
    }

    /*
     * Set the configuration
     */
    public function setConfiguration($configuration)
    {
        if (!array_key_exists('default',$configuration)) {
            $configuration['default'] = array();
        }
        if (!array_key_exists('company',$configuration)) {
            $configuration['company'] = array();
        }
        $this->configuration = $configuration;
        return $this;
    }

    /*
     * Select the company
     */
    public function setCompany($company)
    {
        $this->company = $company;
        return $this;
    }

    /*
     * Is this module enabled for the selected company?
     */
    public function isEnabled()
    {
        return $this->getConfigValue('enabled');
    }

    /*
     * Log in the user.
     * Also clones the user details into the user table.
     */
    public function login($username, $password) {
        // login only succeeds when we bind to the server then
        // find a matching primary group
        $primaryGroup = false;
        $ldap = $this->newLdap($this->getConfigValue('ldap'));
        $ldap->setUser($username);
        $ldap->setPswd($password);
        if ($ldap->LdapConn()) {
            if ($ldap->LdapBind()) {
                $userGroups = $ldap->getMemberships($username);
                $primaryGroup = $this->findFirstMembership($userGroups);
            }
        }
        // if the user has a group we can map to a role
        if ($primaryGroup) {
            // create/update FA user from LDAP
            $this->syncUserToFA($ldap, trim($username), $password, $primaryGroup);
            // logged in OK
            return true;
        } else {
            // failed login
            return false;
        }
    }

    /*
     * Finds first group in group_role_map that exists in groups.
     * FIXME: doesn't validate that the corresponding role exists.
     */
    function findFirstMembership($groups)
    {
        $group_role_map = $this->getConfigValue('group_role_map');
        $firstgroup = false;
        foreach ($group_role_map as $group => $role) {
            if (!$firstgroup) {
                if (in_array($group,$groups)) {
                    $firstgroup = $group;
                }
            }
        }
        return $firstgroup;
    }

    /*
     * Create a new Ldap object, based on the supplied configuration
     */
    protected function newLdap($config) {
        $ldap = new Ldap();
        $ldap->setHost($config['host']);
        $ldap->setPort($config['port']);
        $ldap->setDomain($config['domain']);
        $ldap->setLdapPrefix($config['suffix']);
        $ldap->setWindows(false);  // FIXME: use configuration to determine this flag
        switch ($config['security']) {
            case 1: // TLS
                $ldap->setLdapTLS(true);
                $ldap->setLdapSecure(false);
                break;
            case 2: // SSL
                $ldap->setLdapTLS(false);
                $ldap->setLdapSecure(true);
                break;
            default: // unsecure
                $ldap->setLdapTLS(false);
                $ldap->setLdapSecure(false);
                break;
        }
        return $ldap;
    }

    /*
     * Create or update a user in FA from a user in LDAP
     */
    protected function syncUserToFA($ldap, $username, $password, $primaryGroup)
    {
        // FIXME: these should probably be fetched from the configuration variables
        // default user settings for LDAP-based users
        $language = 'en_GB';
        $profile = '';
        $rep_popup = '1';
        $pos = '1';
        $isActive = '1';
        $userArray = '';

        // settings available from LDAP
        $uid = $ldap->getAttribute('uid');
        $name = $ldap->getAttribute('sn') . " " . $ldap->getAttribute('givenname');
        $mobilephone = $ldap->getAttribute('mobile');
        $email = $ldap->getAttribute('mail');

        // connect to FA database
        set_global_connection();

        // get role ID from primary group
        $map = $this->getConfigValue('group_role_map');
        $userRole = $map[$primaryGroup];  // FIXME: should error if empty
        $sql = "SELECT id FROM ".TB_PREF."security_roles WHERE role = ".db_escape($userRole);
        $query = db_query($sql, "could not get user role for $userRole");
        $ret = db_fetch($query); // FIXME: should error if empty
        $role_id = $ret[0];

        // check for existing user in FA
        $user = get_user_by_login($username);
        // if user exists
        if ($user) {
            // update FA user from LDAP
            $dbid = $user[0];
            // FIXME: LDAP attribute IDs could be supplied in config for site-specific LDAP compatibility
            update_user(
                $dbid,
                $uid, $name,
                $mobilephone, $email,
                $role_id,
                $language, $profile, $rep_popup, $pos
            );
            // FIXME: update password hash?  what about re-auth requests?
        // else
        } else {
            // prepare to create FA user from LDAP
            // FIXME: LDAP attribute IDs could be supplied in config for site-specific LDAP compatibility
            add_user(
                $uid, $name,
                md5($password),  // FIXME: set invalid hash to prevent password ever being out of sync?
                $mobilephone, $email,
                $role_id,
                $language, $profile, $rep_popup, $pos
            );
        // endif
        }
    }

    /*
     * Get a configuration value for the selected company; if the current
     * company doesn't have the value set, use the default.
     */
    protected function getConfigValue($key)
    {
        if (array_key_exists($this->company,$this->configuration['company'])) {
            if (array_key_exists($key,$this->configuration['company'][$this->company])) {
                return $this->configuration['company'][$this->company][$key];
            }
        }
        if (array_key_exists($key,$this->configuration['default'])) {
            return $this->configuration['default'][$key];
        }
        return null;
    }
}
