<?php

/* How to make new entries here for non-packaged languages:

-- 'code' should match the name of the directory for the language under \lang
.-- 'name' is the name that will be displayed in the language selection list (in Users and Display Setup)
-- 'rtl' only needs to be set for right-to-left languages like Arabic and Hebrew
-- 'encoding' used in translation file
-- 'version' always set to '' for manually installed languages.
-- 'path' installation path related to FA root (e.g. 'lang/en_US').
*/


$installed_languages = array (
  0 => 
  array (
    'code' => 'C',
    'name' => 'English',
    'encoding' => 'iso-8859-1',
  ),
  1 => 
  array (
    'code' => 'en_US',
    'name' => 'English US',
    'encoding' => 'utf-8',
	'path' => 'lang/en_US',
  ),
  2 => 
  array (
    'name' => 'Tamil',
    'package' => 'ta_IN',
    'code' => 'ta_IN',
    'encoding' => 'UTF-8',
    'version' => '2.3.24-5',
    'path' => 'lang/ta_IN',
  ),
);

$dflt_lang = 'C';
?>
