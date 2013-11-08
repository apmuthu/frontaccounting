Features
========

  * Works with OpenLDAP+Samba (currently untested with Microsoft AD, but
    new code written while trying to retain AD compatibility)

  * Can enable/disable per-company

  * Can map any LDAP group to each FrontAccounting role

  * Cam map multiple LDAP groups to each FrontAccounting role

  * Can have different LDAP group maps for each company

  * Can optionally use different LDAP servers for each company



Installation notes
==================

  * This extension *must* be activated for Company 0, or it won't work
    for any company.

  * It looks like this extension doesn't need to be activated for other
    companies, but will still work for any of them.

  * Best practice, though, would be to activate for all companies and
    use config_ldap.php to control per-company activation.

  * If installing manually, make sure you update installed_extensions.php
    for each company, too.



Configuration notes
===================

  * Configuration file is config_ldap.php

  * Supplied config_ldap.php has a complete configuration in it, but
    you should tweak it to your needs



Caveats
=======

  * First matching group sets the user's role

  * More than one group may map to a role, however, a group can map to
    only one role

  * Sub-keys in company-specific config aren't merged with default config
    (eg: if you supply a group_role_map with only one entry, that will be
    the entire map for that company; you won't have the default map's
    entries plus that entry...)

  * Whether a user is active/inactive in LDAP probably overrides the
    active/inactive flag in FrontAccounting



Security caveats
================

  * BE CAREFUL WHEN DEACTIVATING THIS EXTENSION: PREVIOUSLY DISABLED
    USERS MAY BECOME ACTIVE AGAIN!  Here's why:

    When a user logs in while the extension is activated, the user is
    automatically added to FrontAccounting.  If you then deactivate this
    extension, the user will still be able to log in!  Even worst:
    if you have disabled a user via LDAP then deactivate this extension,
    that user will probably be able to log in to FrontAccounting again.


