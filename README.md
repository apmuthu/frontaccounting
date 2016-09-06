frontaccounting
===============

* This is an unofficial Git Repo for frontaccounting and it's extensions / utilities.
* Currently only the official v2.3.x branch is supported here.
* My mods and pending commits to the core are in the [FAMods](https://github.com/apmuthu/frontaccounting/blob/master/FAMods) folder and documented in the [FA 2.3 Support Wiki](https://github.com/apmuthu/frontaccounting/wiki).
* Column Widths for large transaction numbers in reports [discussed in the forum](http://frontaccounting.com/punbb/viewtopic.php?id=6456) can be [backported](https://github.com/apmuthu/frontac24/commit/08b81e2fe2536c7c9f7146184dfe4fc37b57c32d).
* DB Schema has been frozen for this version and any changes will break normal upgradeability.
* DB Schema can be optimised as in [FAMods/sql/alter_to_latest.sql](https://github.com/apmuthu/frontaccounting/blob/master/FAMods/sql/alter_to_latest2.3.sql)

Official Links:
===============
<ul>
<li>Home: http://www.frontaccounting.com</li>
<li>Releases: http://www.sf.net/projects/frontaccounting/files</li>
<li>Forums: http://frontaccounting.com/punbb</li>
<li>Wiki: http://frontaccounting.com/fawiki/</li>
<li>ERD in Wiki: http://frontaccounting.com/fawiki/index.php?n=Devel.ERDiagram23</li>
<li>Reports in Wiki: http://frontaccounting.com/fawiki/index.php?n=Help.ReportsAndAnalysis</li>
<li>Bugs: http://mantis.frontaccounting.com/</li>
<li>Extensions: http://anonymous:password@repo.frontaccounting.eu/2.3/</li> - updation stopped at the beginning of 2016 for this version.
</ul>

The official [FrontAccounting Source Tree](http://sourceforge.net/p/frontaccounting/git/ci/master/tree/) uses Git on SourceForge since 2015-03-29
and has been officially [mirrored on GitHub](https://github.com/FrontAccountingERP/FA) from 2015-03-29 onwards.

Caveats:
========
<ul>
<li>This repo will be updated only when I have the time.</li>
<li>It is meant to enable easy localised forking on GitHub from any release.</li>
<li>It can be used to study differences for migration between versions where individual proficiency in using GIT is better than in using Mercurial.</li>
<li>Like any development code repo, code here should be used with care.</li>
<li>Do not be fooled that any snapshot is well tested stable release, while in many times it is not.</li>
<li>Using full random snapshots of FA repo is officially unwelcome.</li>
<li>FA Repo code is placed here for study, development and local deployment only especially where internet is not available.</li>
<li>FA versions are not released too often in order to provide a minimal acceptable level of stability, which is important especially in accounting software.</li>
<li>Any changes in the code that are not yet in the official repo is listed in the [CHANGELOG_apmuthu.txt](https://github.com/apmuthu/frontaccounting/blob/master/FAMods/CHANGELOG_apmuthu.txt).</li>
</ul>

Third Party Connects
====================
<ul>
<li><b>WordPress Connect</b>: https://github.com/wp-plugins/frontaccounting-connect ( empty now ) | [WP SVN](http://plugins.svn.wordpress.org/frontaccounting-connect/trunk/)</li>
<li>Import active Frontaccounting items into wordpress as posts.</li>
</ul>
