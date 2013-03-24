/****************************************************************************
Author: Joe Hunt
Name: Report Generator REPGEN based on Mr. Bauer's Report Generator from 2002
Free software under GNU GPL
*****************************************************************************/

If you haven't already, unzip the file 'repgen.zip' in a temporary folder.

In FrontAccounting, choose Setup > Install/Activate Extensions.

Recommended settings during install:

Name: Report Generator

Folder: repgen   (should follow unix folder convention)

Menu Tab: Setup

Menu Link Text: Report Generator

Module file: Browse for the file: repgen_select.php on you local harddisk.

Access Levels Extensions: acc_levels.php  (from unzipped extension file)

SQL file: Browse for the SQL file reports.sql on your local harddisk.

Click 'Add new' (or 'Update' if upgrading from a previous version).

After you have added the Report Generator, select 'Activaded for ...'.

--- Before you use the Report Generator ---

Upload all the files from your local temporary folder for the Report Generator to the
server folder /modules/repgen.

Go into Setup - 'Access Setup'. Select a role and mark the 'Report Generator' if
this role should have access to the Report Generator.
Logout and Login again with a user with the Report Generator access.

Read the documentation in manual.html.

Now you are ready to use the Report Generator. This is a comprehensive Report Generator!!!

Have fun!!
