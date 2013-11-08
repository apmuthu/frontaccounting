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

class Ldap {
    var $ldap;
    var $ldapTLS;
    var $ldapUseSecure;
    var $ldapHost;    
    var $ldapPort;
    var $ldapPortSecure;
    var $ldapUser;
    var $ldapPswd;
    var $ldapResource;
    var $ldapResultset;
    var $ldapWindows;
    var $ldapPrefix;
    var $ldapDomain;
    var $ldapModules;
    var $userAccountControl;
    
    // Class constructor
    function __construct(){
    	$this->ldapTLS = true;
        $this->ldapUseSecure = false;
        $this->ldapWindows = true;
        $this->ldapPort = 389;
        $this->ldapPortSecure = 636;
        $this->ldapResource = null;
        $this->ldapResultset = null;
        $this->ldapModules = array();
        $this->userAccountControl=512;
    }
    // Class Destructor
    function __destruct(){
        unset($this->Ldap);
        unset($this->ldapTLS);
        unset($this->ldapUseSecure);
        unset($this->ldapHost);
        unset($this->ldapPort);
        unset($this->ldapPortSecure);
        unset($this->ldapUser);
        unset($this->ldapPswd);
        unset($this->ldapResource);
        unset($this->ldapResultset);
        unset($this->ldapWindows);
        unset($this->ldapDomain);
        unset($this->ldapPrefix);
        unset($this->ldapModules);
        unset($this->userAccountControl);
    }
    // Set Ldap Host
    function setHost($host){
        if(!empty($host)){$this->ldapHost = $host;}
    }
    function getHost(){
        return $this->ldapHost;
    }
   
    // Set LdapPort
    function setPort($port){
        if(!empty($port)){$this->ldapPort = $port;}
    }
    
    function getPort(){
        return $this->ldapPort;
    }
    
    function setPortSecure($port){
        if(!empty($port)){$this->ldapPortSecure = $port;}
    }
    // Set LdapUser
    function setUser($user){
        if(!empty($user)){
            $this->ldapUser = $user;
        }else{
            return false;
        }
    }
    
     function getUser(){
        if(!empty($this->ldapUser)){
            return $this->ldapUser;
        }else{
            return false;
        }
    }
    
    // Set LdapPasswd
    function setPswd($pswd){
        if(!empty($pswd)){
            $this->ldapPswd = $pswd;
        }else{
            return false;
        }
    }
   
	function getPswd(){
        if(!empty($this->ldapPswd)){
            return true;
        }else{
            return false;
        }
    }
    
    function setLdapTLS($tls){
        if($tls == true || $tls == false){ $this->ldapTLS = $tls; }
    }
   
    function setLdapsecure($secure){
        if($secure == true || $secure == false){ $this->ldapUseSecure = $secure; }
    }
   
    function getPortSecure(){
        return $this->ldapPortSecure;
    }
    
    function setWindows($win){
        if($win == true || $win == false){$this->ldapWindows = $win;}
    }
    function getWindows(){
        return $this->ldapWindows;
    }
   
    function setDomain($domain){
        if(!empty($domain)){$this->ldapDomain = $domain;}
    }
    
    function getDomain(){
        return $this->ldapDomain;
    }
    
    function setLdapPrefix($ldapPrefix){
        if(!empty($ldapPrefix)){$this->ldapPrefix = $ldapPrefix;}
    }
    
    function getLdapPrefix() {
    	return $this->ldapPrefix;
    }
    
 	function setLdapModules($ldapModules){
        if(!empty($ldapModules)){$this->ldapModules = $ldapModules;}
    }
    
    function getLdapModules() {
    	return $this->ldapModules;
    }
    
    function setUserAccountControl($userAccountControl){
        if(!empty($userAccountControl)){$this->userAccountControl = $userAccountControl;}
    }
    
    function getUserAccountControl() {
    	return $this->userAccountControl;
    }    
   
    function LdapConn(){
        if($this->ldapUseSecure){
            if($this->ldapResource  = @ldap_connect($this->ldapHost, $this->ldapPortSecure)){
                if($this->ldapWindows == true){
                    ldap_set_option($this->ldapResource, LDAP_OPT_PROTOCOL_VERSION, 3);
                    ldap_set_option($this->ldapResource, LDAP_OPT_REFERRALS, 0);
                }             
                return true;
            }
        }else{
        	
            if($this->ldapResource  = @ldap_connect($this->ldapHost, $this->ldapPort)){            
                if($this->ldapWindows == true){
                    ldap_set_option($this->ldapResource, LDAP_OPT_PROTOCOL_VERSION, 3);
                    ldap_set_option($this->ldapResource, LDAP_OPT_REFERRALS, 0);
                    if ($this->ldapTLS == true) {
                    	if (!@ldap_start_tls($this->ldapResource))
                    		 @ldap_start_tls($this->ldapResource);
                    }
                }
                return true;
            }
        }
        return false;
    }
   
    function LdapBind(){
        if(!empty($this->ldapUser) && !empty($this->ldapPswd)){
        	
            if(@ldap_bind($this->ldapResource, $this->getLdapUserDn(), $this->ldapPswd)) {
                if ($this->ldapWindows) {
                    $filter = "(&(uid=$this->ldapUser)(userAccountControl=$this->userAccountControl))";
                } else {
                    $filter = "(&(uid=$this->ldapUser))";
                }
                
		        if($this->ldapResultset = @ldap_search($this->ldapResource, $this->getLdapPeopleDn(), $filter)) {
		        	$count = ldap_count_entries($this->ldapResource, $this->ldapResultset);
		        	
		        	if ($count > 0) {   			    			    	
			      		return true;
				    } else {
				      return false;
				    }
	            }else{
	                return false;
	            }
             }else{
	                return false;
	            }
        }else{
            if(@ldap_bind($this->ldapResource)){
                if ($this->ldapWindows) {
                    $filter = "(userAccountControl=$this->userAccountControl)";
                } else {
                    // FIXME: is this right for unauthenticated binding on OpenLDAP?
                    $filter = "()";
			    }
			    
			    if($this->ldapResultset = @ldap_search($this->ldapResource, $this->getLdapPeopleDn(), $filter)) {
		        	$count = ldap_count_entries($this->ldapResource, $this->ldapResultset);
		        	
		        	if ($count > 0) {   			    			    	
			      		return true;
				    } else {
				      return false;
				    }
	            }else{
	                return false;
	            }			    
            }else{
                return false;
            }
        }
    }

  
   function LdapLogin(){ 
        if(!empty($this->ldapUser) && !empty($this->ldapPswd)){ 
        	 
            if($this->ldapResultset = @ldap_bind($this->ldapResource, $this->getLdapUserDn(), $this->ldapPswd)) { 
                return true; 
            }else{ 
                return false; 
            } 
        }else{ 
            if($this->ldapResultset = @ldap_bind($this->ldapResource)){ 
                return true; 
            }else{ 
                return false; 
            } 
        } 
    } 
    
    function getldapUPN(){
        if(!empty($this->ldapDomain) && !empty($this->ldapUser)){
            return $this->ldapUser."@".$this->ldapDomain;                
        }
        return false;
    }
   
    function getAttribute($attr){
        /* The relevant object we are looking for to limit the scope */
        $filter = 'uid='.$this->ldapUser;
        /* We want to filter on one object so we dont get "All" information back.... Its Ldap Hell!*/
        $rObjs = array($attr);
        /* Execute the actual search on the directory */
        if($this->ldapResultset = @ldap_search($this->ldapResource, $this->getLdapPrefix(), $filter, $rObjs)){
            $userArr = ldap_get_entries($this->ldapResource, $this->ldapResultset);
        }
        /* Validate we have a result that matters */
        if($userArr['count'] > 0){
            if(@$userArr[0][$attr]['count'] > 0){
                return $userArr[0][$attr][0];
            }else{
                return false;
            }
        }else{
            return false;
        }   
    }
   
    function getAttributeKeyValuesArray($uid, $keyValuesArr) {
    	
    	$filter = "uid=" . $uid;
    	$attrs = array();
    	$return_attrs = array();
    	 
    	if($this->ldapResultset = @ldap_search($this->ldapResource, $this->getLdapPeopleDn(), $filter)) {
            $userArr = @ldap_first_entry($this->ldapResource, $this->ldapResultset);
    	
			$attribute = ldap_get_attributes( $this->ldapResource, $userArr );
			$count = $attribute['count'];

		   for ($j = 0; $j < $attribute["count"]; $j++){
		      $attr_name = $attribute[$j];
		      $attribute["$attr_name"]["count"] . "\n";
		      for ($k = 0; $k < $attribute["$attr_name"]["count"]; $k++) {
		      		if (in_array($attr_name, $keyValuesArr)) {
					    $return_attrs[$attr_name] = $attribute[$attr_name][$k];
					}
		      }
		   }
        }
    	
	   return $return_attrs;	   
    }
    
    function getMemberships($uid){
        /* The relevant object we are looking for to limit the scope */
        $filter = "(&({$this->makeMemberFilter($uid)})(objectClass={$this->getGroupObjectClass()}))";
                
        if($this->ldapResultset = @ldap_search($this->ldapResource, $this->getLdapPrefix(), $filter)) {
            $userArr = ldap_get_entries($this->ldapResource, $this->ldapResultset);
        }

        if($userArr['count'] > 0){
        	
        	for ($i=0; $i<$userArr["count"]; $i++) {	            
	            $memberships[$i]= $userArr[$i]["cn"][0];
			  //$memberships[$i]= $userArr[$i]["dn"];
	        }
            
            if(is_array($memberships)){
                return $memberships;
            }else{
                return false;
            }
        }else{
            return false;
        }   
    }
    
    function groupMemberOf($uid, $module) {
        
        $filter = "(&({$this->makeMemberFilter($uid)})(objectClass={$this->getGroupObjectClass()}))";
                
        if($this->ldapResultset = @ldap_search($this->ldapResource, $this->getLdapPrefix(), $filter)) {
            $userArr = ldap_get_entries($this->ldapResource, $this->ldapResultset);
        }

        if($userArr['count'] > 0){
        	
        	for ($i=0; $i<$userArr["count"]; $i++) {	            
	            if ($module == $userArr[$i]["cn"][0]) {
	            	return true;
	            	break;
	            }
	        }
        }
        
        return false;
    }
         
    function updateUser($uid, $userArr) {
    	
    	$filter = $uid;
    	$userRecord = array();
                
        if($this->ldapResultset = @ldap_search($this->ldapResource, $this->getLdapPrefix(), "(uid=$filter)")) {
            $userRecord = ldap_get_entries($this->ldapResource, $this->ldapResultset);
        }
        
         @ldap_modify($this->ldapResource,$userRecord[0]["dn"],$userArr);
         
         if(ldap_error($this->ldapResource) == "Success")
	      return true;
	    else
	      return false;
    }
    
    function createGroup($object_name, $members, $ldap_conn)
	{
		$group_cn = "cn=".$object_name."," . $this->getLdapGroupDn();
		
	    $addgroup_ad['cn']="$object_name";    
	    $addgroup_ad['objectClass'][0] = "top";
	    $addgroup_ad['objectClass'][1] ="{$this->getGroupObjectClass()}";
	    $addgroup_ad['member']=$members;
	
	    @ldap_add($this->ldapResource,$group_cn,$addgroup_ad);
	   
	    if(@ldap_error($this->ldapResource) == "Success")
	      return true;
	    else
	      return false;
	}
	
	function addMemberToGroup($object_name, $uid)
	{
		$group_cn = "cn=".$object_name."," . $this->getLdapGroupDn();
        $members = $this->getLdapUserDn($uid);
		
		$group_info['member'] = $members;
		@ldap_mod_add($this->ldapResource,$group_cn,$group_info);
		
		if(@ldap_error($this->ldapResource) == "Success")
	      return true;
	    else
	      return false;
	}
	
	function delMemberFromGroup($object_name, $uid)
	{
		$group_cn = "cn=".$object_name."," . $this->getLdapGroupDn();
        $members = $this->getLdapUserDn($uid);
		
		$group_info['member'] = $members;
		@ldap_mod_del($this->ldapResource,$group_cn,$group_info);
		
		if(@ldap_error($this->ldapResource) == "Success")
	      return true;
	    else
	      return false;
	}
    
    function searchByUser($user) {

        $filter = "uid=" . $user;
        $userArr = array();
        
        if($this->ldapResultset = @ldap_search($this->ldapResource, $this->getLdapPeopleDn(), $filter)) {
            $userArr = ldap_get_entries($this->ldapResource, $this->ldapResultset);
        }
        
        return $userArr;
    }
    
    
    function getCompanyInfo($company) {

        $companyArr = array();
        $filter = "ou=" . $company;
        
        if($this->ldapResultset = @ldap_search($this->ldapResource, $this->getLdapPrefix(), $filter)) {
            $companyArr = ldap_get_entries($this->ldapResource, $this->ldapResultset);
        }
        
        return $companyArr;
    }
    
     function getCompanyGroupsName($company){
        
        $companyArr = array();
        $groupsName = array();
        $filter = "(objectClass={$this->getGroupObjectClass()})";
        
        if($this->ldapResultset = @ldap_search($this->ldapResource, $this->getLdapGroupDn(), $filter)) {
            $companyArr = ldap_get_entries($this->ldapResource, $this->ldapResultset);
        }

        if($companyArr['count'] > 0){
        	
        	for ($i=0; $i<$companyArr["count"]; $i++) {
	            $groupsName[$i]= $companyArr[$i]["cn"][0];
	        }
        }
            
       return $groupsName;
    }
    
    function getLdapUserDn($uid=null){
        if(!empty($this->ldapPrefix)){
            if(!is_null($uid)){
            	return	"uid=" .$uid . "," . $this->getLdapPeopleDn();
            }
            if(!empty($this->ldapUser)){
            	return	"uid=" .$this->ldapUser . "," . $this->getLdapPeopleDn();
            }
        }
        return false;
    }
    
    function getLdapPeopleDn(){
        if(!empty($this->ldapPrefix)){
            	return	"ou=" . $this->getPeopleOU() . "," . $this->getLdapPrefix();
        }
        return false;
    }
    
     function getLdapGroupDn(){
        if(!empty($this->ldapPrefix)){            
            	return	"ou=" . $this->getGroupsOU() . "," . $this->getLdapPrefix();
        }
        return false;
    }

    function getPeopleOU(){
        if ($this->ldapWindows) {
            return 'people';
        } else {
            return 'Users';
        }
    }

    function getGroupsOU(){
        if ($this->ldapWindows) {
            return 'groups';
        } else {
            return 'Groups';
        }
    }

    function getGroupObjectClass(){
        if ($this->ldapWindows) {
            return 'groupOfNames';
        } else {
            return 'posixGroup';
        }
    }

    function makeMemberFilter($uid){
        if ($this->ldapWindows){
            return "member={$this->getLdapUserDn($uid)}";
        } else {
            return "memberUid=$uid";
        }
    }
}
