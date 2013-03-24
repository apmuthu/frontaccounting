# MySQL dump of database 'fatest' on host 'localhost'
# Backup Date and Time: 2010-08-13 11:18
# Built by FrontAccounting 2.3RC1
# http://frontaccounting.com
# Company: IRON
# User: Administrator



### Structure of table `0_areas` ###

DROP TABLE IF EXISTS `0_areas`;

CREATE TABLE `0_areas` (
  `area_code` int(11) NOT NULL auto_increment,
  `description` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`area_code`),
  UNIQUE KEY `description` (`description`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ;


### Data of table `0_areas` ###

INSERT INTO `0_areas` VALUES ('1', 'USA', '0');


### Structure of table `0_attachments` ###

DROP TABLE IF EXISTS `0_attachments`;

CREATE TABLE `0_attachments` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `description` varchar(60) NOT NULL default '',
  `type_no` int(11) NOT NULL default '0',
  `trans_no` int(11) NOT NULL default '0',
  `unique_name` varchar(60) NOT NULL default '',
  `tran_date` date NOT NULL default '0000-00-00',
  `filename` varchar(60) NOT NULL default '',
  `filesize` int(11) NOT NULL default '0',
  `filetype` varchar(60) NOT NULL default '',
  PRIMARY KEY  (`id`),
  KEY `type_no` (`type_no`,`trans_no`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;


### Data of table `0_attachments` ###



### Structure of table `0_audit_trail` ###

DROP TABLE IF EXISTS `0_audit_trail`;

CREATE TABLE `0_audit_trail` (
  `id` int(11) NOT NULL auto_increment,
  `type` smallint(6) unsigned NOT NULL default '0',
  `trans_no` int(11) unsigned NOT NULL default '0',
  `user` smallint(6) unsigned NOT NULL default '0',
  `stamp` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `description` varchar(60) default NULL,
  `fiscal_year` int(11) NOT NULL,
  `gl_date` date NOT NULL default '0000-00-00',
  `gl_seq` int(11) unsigned default NULL,
  PRIMARY KEY  (`id`),
  KEY `Seq` (`fiscal_year`,`gl_date`,`gl_seq`),
  KEY `Type_and_Number` (`type`,`trans_no`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


### Data of table `0_audit_trail` ###



### Structure of table `0_bank_accounts` ###

DROP TABLE IF EXISTS `0_bank_accounts`;

CREATE TABLE `0_bank_accounts` (
  `account_code` varchar(15) NOT NULL default '',
  `account_type` smallint(6) NOT NULL default '0',
  `bank_account_name` varchar(60) NOT NULL default '',
  `bank_account_number` varchar(100) NOT NULL default '',
  `bank_name` varchar(60) NOT NULL default '',
  `bank_address` tinytext,
  `bank_curr_code` char(3) NOT NULL default '',
  `dflt_curr_act` tinyint(1) NOT NULL default '0',
  `id` smallint(6) NOT NULL auto_increment,
  `last_reconciled_date` timestamp NOT NULL default '0000-00-00 00:00:00',
  `ending_reconcile_balance` double NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `bank_account_name` (`bank_account_name`),
  KEY `bank_account_number` (`bank_account_number`),
  KEY `account_code` (`account_code`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;


### Data of table `0_bank_accounts` ###



### Structure of table `0_bank_trans` ###

DROP TABLE IF EXISTS `0_bank_trans`;

CREATE TABLE `0_bank_trans` (
  `id` int(11) NOT NULL auto_increment,
  `type` smallint(6) default NULL,
  `trans_no` int(11) default NULL,
  `bank_act` varchar(15) NOT NULL default '',
  `ref` varchar(40) default NULL,
  `trans_date` date NOT NULL default '0000-00-00',
  `bank_trans_type_id` int(10) unsigned default NULL,
  `amount` double default NULL,
  `dimension_id` int(11) NOT NULL default '0',
  `dimension2_id` int(11) NOT NULL default '0',
  `person_type_id` int(11) NOT NULL default '0',
  `person_id` tinyblob,
  `reconciled` date default NULL,
  PRIMARY KEY  (`id`),
  KEY `bank_act` (`bank_act`,`ref`),
  KEY `type` (`type`,`trans_no`),
  KEY `bank_act_2` (`bank_act`,`reconciled`),
  KEY `bank_act_3` (`bank_act`,`trans_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


### Data of table `0_bank_trans` ###


### Structure of table `0_bom` ###

DROP TABLE IF EXISTS `0_bom`;

CREATE TABLE `0_bom` (
  `id` int(11) NOT NULL auto_increment,
  `parent` char(20) NOT NULL default '',
  `component` char(20) NOT NULL default '',
  `workcentre_added` int(11) NOT NULL default '0',
  `loc_code` char(5) NOT NULL default '',
  `quantity` double NOT NULL default '1',
  PRIMARY KEY  (`parent`,`component`,`workcentre_added`,`loc_code`),
  KEY `component` (`component`),
  KEY `id` (`id`),
  KEY `loc_code` (`loc_code`),
  KEY `parent` (`parent`,`loc_code`),
  KEY `workcentre_added` (`workcentre_added`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;


### Data of table `0_bom` ###



### Structure of table `0_budget_trans` ###

DROP TABLE IF EXISTS `0_budget_trans`;

CREATE TABLE `0_budget_trans` (
  `counter` int(11) NOT NULL auto_increment,
  `type` smallint(6) NOT NULL default '0',
  `type_no` bigint(16) NOT NULL default '1',
  `tran_date` date NOT NULL default '0000-00-00',
  `account` varchar(15) NOT NULL default '',
  `memo_` tinytext NOT NULL,
  `amount` double NOT NULL default '0',
  `dimension_id` int(11) default '0',
  `dimension2_id` int(11) default '0',
  `person_type_id` int(11) default NULL,
  `person_id` tinyblob,
  PRIMARY KEY  (`counter`),
  KEY `Type_and_Number` (`type`,`type_no`),
  KEY `Account` (`account`,`tran_date`,`dimension_id`,`dimension2_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


### Data of table `0_budget_trans` ###



### Structure of table `0_chart_class` ###

DROP TABLE IF EXISTS `0_chart_class`;

CREATE TABLE `0_chart_class` (
  `cid` varchar(3) NOT NULL,
  `class_name` varchar(60) NOT NULL default '',
  `ctype` tinyint(1) NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`cid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;


### Data of table `0_chart_class` ###

INSERT INTO `0_chart_class` VALUES ('1', 'Aktywa', '1', '0');
INSERT INTO `0_chart_class` VALUES ('2', 'Pasywa', '2', '0');
INSERT INTO `0_chart_class` VALUES ('3', 'Przychody', '4', '0');
INSERT INTO `0_chart_class` VALUES ('4', 'Koszty', '6', '0');


### Structure of table `0_chart_master` ###

DROP TABLE IF EXISTS `0_chart_master`;

CREATE TABLE `0_chart_master` (
  `account_code` varchar(15) NOT NULL default '',
  `account_code2` varchar(15) NOT NULL default '',
  `account_name` varchar(60) NOT NULL default '',
  `account_type` varchar(10) NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`account_code`),
  KEY `account_name` (`account_name`),
  KEY `accounts_by_type` (`account_type`,`account_code`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;


### Data of table `0_chart_master` ###

INSERT INTO `0_chart_master` VALUES ('001000000', '', '¦rodki Trwa³e', '1', '0');
INSERT INTO `0_chart_master` VALUES ('001010000', '', 'Grunty w³asne i prawa wieczystego u¿ytkowania gruntów', '1', '0');
INSERT INTO `0_chart_master` VALUES ('001020000', '', 'Budynki, locale i obiekty in¿ynierii l±dowej i wodnej', '1', '0');
INSERT INTO `0_chart_master` VALUES ('001030000', '', 'Urz±dzenia techniczne i maszyny', '1', '0');
INSERT INTO `0_chart_master` VALUES ('001040000', '', '¦rodki transportu', '1', '0');
INSERT INTO `0_chart_master` VALUES ('001050000', '', 'Inne ¶rodki trwa³e', '1', '0');
INSERT INTO `0_chart_master` VALUES ('002000000', '', 'Warto¶ci niematerialne i prawne', '1', '0');
INSERT INTO `0_chart_master` VALUES ('002010000', '', 'Koszty zakoñczonych prac rozwojowych', '1', '0');
INSERT INTO `0_chart_master` VALUES ('002020000', '', 'Nabyta warto¶æ firmy', '1', '0');
INSERT INTO `0_chart_master` VALUES ('002080000', '', 'Inne warto¶ci niematerialne i prawne', '1', '0');
INSERT INTO `0_chart_master` VALUES ('002090000', '', 'Zaliczki na warto¶ci niematerialne i prawne', '1', '0');
INSERT INTO `0_chart_master` VALUES ('003000000', '', 'D³ugoterminowe aktywa finansowe', '1', '0');
INSERT INTO `0_chart_master` VALUES ('003010000', '', 'W jednostkach powi±zanych', '1', '0');
INSERT INTO `0_chart_master` VALUES ('003010100', '', 'Udzia³y lub akcje', '1', '0');
INSERT INTO `0_chart_master` VALUES ('003010200', '', 'Inne papiery warto¶ciowe', '1', '0');
INSERT INTO `0_chart_master` VALUES ('003010300', '', 'Udzielone porzyczki', '1', '0');
INSERT INTO `0_chart_master` VALUES ('003010400', '', 'Inne d³ugoterminowe aktywa finansowe', '1', '0');
INSERT INTO `0_chart_master` VALUES ('003020000', '', 'W pozosta³ych jednostkach', '1', '0');
INSERT INTO `0_chart_master` VALUES ('003020100', '', 'Udzia³y lub akcje', '1', '0');
INSERT INTO `0_chart_master` VALUES ('003020200', '', 'Inne papiery warto¶ciowe', '1', '0');
INSERT INTO `0_chart_master` VALUES ('003020300', '', 'Udzielone po¿yczki', '1', '0');
INSERT INTO `0_chart_master` VALUES ('003020400', '', 'Inne d³ugoterminowe aktywa finansowe', '1', '0');
INSERT INTO `0_chart_master` VALUES ('003090000', '', 'Inne investycje d³ugoterminowe', '1', '0');
INSERT INTO `0_chart_master` VALUES ('003090100', '', 'Inne rodzaje d³ugoterminowych aktywów finansowych', '1', '0');
INSERT INTO `0_chart_master` VALUES ('004000000', '', 'Investycje w nieruchomo¶ci i prawa', '1', '0');
INSERT INTO `0_chart_master` VALUES ('004010000', '', 'Nieruchomo¶ci', '1', '0');
INSERT INTO `0_chart_master` VALUES ('004020000', '', 'Warto¶ci niematerialne i prawne', '1', '0');
INSERT INTO `0_chart_master` VALUES ('005000000', '', 'D³ugoterminowe rozliczenia miêdzyokresowe', '1', '0');
INSERT INTO `0_chart_master` VALUES ('005010000', '', 'Aktywa z tytu³u odroczonego podatku dochodowego', '1', '0');
INSERT INTO `0_chart_master` VALUES ('005020000', '', 'Inne rozliczenia miêdzyokresowe', '1', '0');
INSERT INTO `0_chart_master` VALUES ('006000000', '', 'Nale¿no¶ci d³ugoterminowe', '1', '0');
INSERT INTO `0_chart_master` VALUES ('006010000', '', 'Od jednostek powi±zanych', '1', '0');
INSERT INTO `0_chart_master` VALUES ('006020000', '', 'Od pozosta³ych jednostek', '1', '0');
INSERT INTO `0_chart_master` VALUES ('007000000', '', 'Odpisy umorzeniowe ¶rodków trwa³ych oraz warto¶ci niemateria', '1', '0');
INSERT INTO `0_chart_master` VALUES ('007010000', '', 'Odpisy umorzeniowe warto¶ci gruntów i prawa wieczystego u¿yt', '1', '0');
INSERT INTO `0_chart_master` VALUES ('007020000', '', 'Odpisy umorzeniowe budynków, lokali i obiektów in¿ynierii l±', '1', '0');
INSERT INTO `0_chart_master` VALUES ('007030000', '', 'Odpisy umorzeniowe urz±dzeñ technicznych i maszyn', '1', '0');
INSERT INTO `0_chart_master` VALUES ('007040000', '', 'Odpisy umorzeniowe ¶rodków transportu', '1', '0');
INSERT INTO `0_chart_master` VALUES ('007050000', '', 'Odpisy umorzeniowe ulepszeñ obcych ¶rodków trwa³ych', '1', '0');
INSERT INTO `0_chart_master` VALUES ('007090000', '', 'Odpisy umorzeniowe innych ¶rodków trwa³ych', '1', '0');
INSERT INTO `0_chart_master` VALUES ('008000000', '', '¦rodki trwa³e w budowie', '1', '0');
INSERT INTO `0_chart_master` VALUES ('008010000', '', 'Inwestycje budowy ¶rodka trwa³ego', '1', '0');
INSERT INTO `0_chart_master` VALUES ('008020000', '', 'Ulepszenia ¶rodka trwa³ego', '1', '0');
INSERT INTO `0_chart_master` VALUES ('008030000', '', 'Nak³ady na budowê ¶rodka trwa³ego', '1', '0');
INSERT INTO `0_chart_master` VALUES ('008040000', '', 'Zaliczki na ¶rodki trwa³e w budowie', '1', '0');
INSERT INTO `0_chart_master` VALUES ('008050000', '', 'Ulepszenia obcych ¶rodków trwa³ych', '1', '0');
INSERT INTO `0_chart_master` VALUES ('009000000', '', 'Odpisy aktualizuj±ce d³ugoterminowe aktywa finansowe', '1', '0');
INSERT INTO `0_chart_master` VALUES ('009010000', '', 'Odpisy aktualizuj±ce udzia³y i akcje w obcych jednostkach', '1', '0');
INSERT INTO `0_chart_master` VALUES ('009020000', '', 'Odpisy aktualizuj±ce lokaty', '1', '0');
INSERT INTO `0_chart_master` VALUES ('009030000', '', 'Odpisy aktualizuj±ce udzielone porzyczki d³ugoterminowe', '1', '0');
INSERT INTO `0_chart_master` VALUES ('009090000', '', 'Odpisy aktualizuj±ce inne rodzaje d³ugoterminowych aktywów f', '1', '0');
INSERT INTO `0_chart_master` VALUES ('110000000', '', '¦rodki pieniê¿ne w kasie', '2', '0');
INSERT INTO `0_chart_master` VALUES ('110010000', '', 'Kasa krajowych ¶rodków pieniê¿nych', '2', '0');
INSERT INTO `0_chart_master` VALUES ('110020000', '', 'Kasa zagranicznych ¶rodków pieniê¿nych', '2', '0');
INSERT INTO `0_chart_master` VALUES ('113000000', '', 'Rachunki i kredyty bankowe', '2', '0');
INSERT INTO `0_chart_master` VALUES ('113010000', '', 'Rachunek bie¿±cy', '2', '0');
INSERT INTO `0_chart_master` VALUES ('113020000', '', 'Rachunek ¶rodków wyodrêbnionych i zablokowanych', '2', '0');
INSERT INTO `0_chart_master` VALUES ('113030000', '', 'Rachunki kredytów bankowych', '2', '0');
INSERT INTO `0_chart_master` VALUES ('113040000', '', 'Rachunek ¶rodków walutowych', '2', '0');
INSERT INTO `0_chart_master` VALUES ('114000000', '', 'Krótkoterminowe aktywa finansowe', '2', '0');
INSERT INTO `0_chart_master` VALUES ('114010000', '', 'Krótkoterminowe aktywa finansowe w jednostkach powi±zanych', '2', '0');
INSERT INTO `0_chart_master` VALUES ('114010100', '', 'Udzia³y lub akcje', '2', '0');
INSERT INTO `0_chart_master` VALUES ('114010200', '', 'Inne papiery warto¶ciowe', '2', '0');
INSERT INTO `0_chart_master` VALUES ('114010300', '', 'Udzielone po¿yczki', '2', '0');
INSERT INTO `0_chart_master` VALUES ('114010400', '', 'Inne krótkoterminowe aktywa finansowe', '2', '0');
INSERT INTO `0_chart_master` VALUES ('114020000', '', 'Krótkoterminowe aktywa finansowe w pozosta³ych jednostkach', '2', '0');
INSERT INTO `0_chart_master` VALUES ('114020100', '', 'Udzia³y lub akcje', '2', '0');
INSERT INTO `0_chart_master` VALUES ('114020200', '', 'Inne papiery warto¶ciowe', '2', '0');
INSERT INTO `0_chart_master` VALUES ('114020400', '', 'Inne krótkoterminowe aktywa finansowe', '2', '0');
INSERT INTO `0_chart_master` VALUES ('115000000', '', 'Inne ¶rodki pieniê¿ne', '2', '0');
INSERT INTO `0_chart_master` VALUES ('116000000', '', 'Inne aktywa pieniê¿ne', '2', '0');
INSERT INTO `0_chart_master` VALUES ('117000000', '', 'Inne inwestycje krótkoterminowe', '2', '0');
INSERT INTO `0_chart_master` VALUES ('118000000', '', 'Krótkoterminowe rozliczenia miêdzyokresowe', '2', '0');
INSERT INTO `0_chart_master` VALUES ('220000000', '', 'Nale¿no¶ci krótkoterminowe', '3', '0');
INSERT INTO `0_chart_master` VALUES ('220010000', '', 'Nale¿no¶ci od jednostek powi±zanych', '3', '0');
INSERT INTO `0_chart_master` VALUES ('220010100', '', 'Nale¿no¶ci z tytu³u dostaw i us³ug', '3', '0');
INSERT INTO `0_chart_master` VALUES ('220010110', '', 'Nale¿no¶ci z tytu³u dostaw i us³ug, o okresie sp³aty do 12 m', '3', '0');
INSERT INTO `0_chart_master` VALUES ('220010120', '', 'Nale¿no¶ci z tytu³u dostaw i us³ug, o okresie sp³aty powy¿ej', '3', '0');
INSERT INTO `0_chart_master` VALUES ('220010200', '', 'Inne nale¿no¶ci', '3', '0');
INSERT INTO `0_chart_master` VALUES ('220010210', '', 'Zobowi±zania z tytu³u pokrycia kosztów ogólnego zarz±du', '3', '0');
INSERT INTO `0_chart_master` VALUES ('220010220', '', 'Zobowi±zania z tytu³u rozliczeñ VAT', '3', '0');
INSERT INTO `0_chart_master` VALUES ('221010000', '', 'Nale¿no¶ci od pozosta³ych jednostek', '3', '0');
INSERT INTO `0_chart_master` VALUES ('221020100', '', 'Nale¿no¶ci z tytu³u dostaw i us³ug', '3', '0');
INSERT INTO `0_chart_master` VALUES ('221020110', '', 'Nale¿no¶ci z tytu³u dostaw i us³ug, o okresie sp³aty do 12 m', '3', '0');
INSERT INTO `0_chart_master` VALUES ('221020120', '', 'Nale¿no¶ci z tytu³u dostaw i us³ug, o okresie sp³aty powy¿ej', '3', '0');
INSERT INTO `0_chart_master` VALUES ('221020200', '', 'Nale¿no¶ci z tytu³u podatków, dotacji, ce³, ubezpieczeñ spo³', '3', '0');
INSERT INTO `0_chart_master` VALUES ('221020300', '', 'Zaliczki przekazane dostawcom', '3', '0');
INSERT INTO `0_chart_master` VALUES ('221020400', '', 'Nale¿no¶ci dochodzone na drodze s±dowej', '3', '0');
INSERT INTO `0_chart_master` VALUES ('221020500', '', 'Inne nale¿no¶ci', '3', '0');
INSERT INTO `0_chart_master` VALUES ('222000000', '', 'Zobowi±zania krótkoterminowe', '3', '0');
INSERT INTO `0_chart_master` VALUES ('222010000', '', 'Zobowi±zania wobec jednostek powiazanych', '3', '0');
INSERT INTO `0_chart_master` VALUES ('222010100', '', 'Zobowi±zania z tytu³u dostaw i us³ug', '3', '0');
INSERT INTO `0_chart_master` VALUES ('222010200', '', 'Zobowi±zania o okresie wymagalno¶ci do 12 miesiêcy', '3', '0');
INSERT INTO `0_chart_master` VALUES ('222010300', '', 'Zobowi±zania o okresie wymagalno¶ci powy¿ej 12 miesiêcy', '3', '0');
INSERT INTO `0_chart_master` VALUES ('222010400', '', 'Inne zobowi±zania', '3', '0');
INSERT INTO `0_chart_master` VALUES ('222020000', '', 'Zobowi±zania wobec pozosta³ych jednostek', '3', '0');
INSERT INTO `0_chart_master` VALUES ('222020100', '', 'Kredyty i po¿yczki', '3', '0');
INSERT INTO `0_chart_master` VALUES ('222020200', '', 'Zobowi±zania z tytu³u emisji d³u¿nych papierów warto¶ciowych', '3', '0');
INSERT INTO `0_chart_master` VALUES ('222020300', '', 'Inne zobowi±zania finasowe', '3', '0');
INSERT INTO `0_chart_master` VALUES ('222020400', '', 'Zobowiazania z tytu³u dostaw i us³ug', '3', '0');
INSERT INTO `0_chart_master` VALUES ('222020500', '', 'Zobowi±zania o okresie wymagalno¶ci do 12 miesiêcy ', '3', '0');
INSERT INTO `0_chart_master` VALUES ('222020600', '', 'Zobowi±zania o okresie wymagalno¶ci powy¿ej 12 miesiêy', '3', '0');
INSERT INTO `0_chart_master` VALUES ('222020700', '', 'Zaliczki otrzmane na dostawy', '3', '0');
INSERT INTO `0_chart_master` VALUES ('222020800', '', 'Zobowi±zania wekslowe', '3', '0');
INSERT INTO `0_chart_master` VALUES ('222020900', '', 'Zobowi±zania z tytu³u podatków, ce³, ubezpieczeñ i innych ¶w', '3', '0');
INSERT INTO `0_chart_master` VALUES ('222021000', '', 'Zobowi±zania z tytu³u wynagrodzeñ', '3', '0');
INSERT INTO `0_chart_master` VALUES ('222021100', '', 'Inne zobowi±zania', '3', '0');
INSERT INTO `0_chart_master` VALUES ('223000000', '', 'Rozrachunki publicznoprawne', '3', '0');
INSERT INTO `0_chart_master` VALUES ('223010000', '', 'Rozrachunki z urzêdem skarbowym z tytu³u VAT', '3', '0');
INSERT INTO `0_chart_master` VALUES ('223020000', '', 'Rozliczenie nale¿nego VAT', '3', '0');
INSERT INTO `0_chart_master` VALUES ('223020100', '', 'Rozliczenie nale¿nego VAT-22%', '3', '0');
INSERT INTO `0_chart_master` VALUES ('223020200', '', 'Rozliczenie nale¿nego VAT-7%', '3', '0');
INSERT INTO `0_chart_master` VALUES ('223020300', '', 'Rozliczenie nale¿nego VAT-0%', '3', '0');
INSERT INTO `0_chart_master` VALUES ('223030000', '', 'Rozliczenie naliczonego VAT', '3', '0');
INSERT INTO `0_chart_master` VALUES ('223030100', '', 'Rozliczenie naliczonego VAT-22%', '3', '0');
INSERT INTO `0_chart_master` VALUES ('223030200', '', 'Rozliczenie naliczonego VAT-7%', '3', '0');
INSERT INTO `0_chart_master` VALUES ('223030300', '', 'Rozliczenie naliczonego VAT-0%', '3', '0');
INSERT INTO `0_chart_master` VALUES ('223040000', '', 'Korekty naliczonego VAT', '3', '0');
INSERT INTO `0_chart_master` VALUES ('223050000', '', 'Rozrachunki z Urzêdem Celnym', '3', '0');
INSERT INTO `0_chart_master` VALUES ('223060000', '', 'Rozrachunki z Urzêdem Skarbowym z tytu³u znaków akcyzy', '3', '0');
INSERT INTO `0_chart_master` VALUES ('223070000', '', 'Rozrachunki z Urzêdem Skarbowym z tytu³u podatku akcyzowego', '3', '0');
INSERT INTO `0_chart_master` VALUES ('223080000', '', 'Rozliczenie znaków akcyzy', '3', '0');
INSERT INTO `0_chart_master` VALUES ('223090000', '', 'Rozrachunki z ZUS', '3', '0');
INSERT INTO `0_chart_master` VALUES ('223100000', '', 'Rozrachunki z Urzêdem Skarbowym z tytu³u podatku dochodowego', '3', '0');
INSERT INTO `0_chart_master` VALUES ('224000000', '', 'Rozrachunki z pracownikami', '3', '0');
INSERT INTO `0_chart_master` VALUES ('224010000', '', 'Rozrachunki z tytu³u wynagrodzeñ', '3', '0');
INSERT INTO `0_chart_master` VALUES ('224020000', '', 'Rozrachunki z tytu³u po¿yczek udzielonych pracownikom', '3', '0');
INSERT INTO `0_chart_master` VALUES ('224090000', '', 'Inne rozrachunki z pracownikami', '3', '0');
INSERT INTO `0_chart_master` VALUES ('225000000', '', 'Zobowi±zania d³ugoterminowe', '3', '0');
INSERT INTO `0_chart_master` VALUES ('225010000', '', 'Zobowi±zania wobec jednostek powi±zanych', '3', '0');
INSERT INTO `0_chart_master` VALUES ('225010100', '', 'Zobowi±zania z tytu³u wyodrêbnienia sk³adników maj±tkowych', '3', '0');
INSERT INTO `0_chart_master` VALUES ('225010200', '', 'Zobowi±zania z tytu³u podzia³u zysku', '3', '0');
INSERT INTO `0_chart_master` VALUES ('225020000', '', 'Zobowi±zania wobec pozosta³ych jednostek', '3', '0');
INSERT INTO `0_chart_master` VALUES ('225020100', '', 'Kredyty i po¿yczki otrzymane', '3', '0');
INSERT INTO `0_chart_master` VALUES ('225020200', '', 'Kredyty i po¿yczki udzielone', '3', '0');
INSERT INTO `0_chart_master` VALUES ('225020300', '', 'Zobowi±zania z tytu³u emisji d³u¿nych papierów warto¶ciowych', '3', '0');
INSERT INTO `0_chart_master` VALUES ('225020400', '', 'Inne zobowi±zania kredytowe', '3', '0');
INSERT INTO `0_chart_master` VALUES ('225020500', '', 'Inne zobowi±zania', '3', '0');
INSERT INTO `0_chart_master` VALUES ('225030000', '', 'Rozrachunki z tytu³u wp³at na kapita³ zak³adowy', '3', '0');
INSERT INTO `0_chart_master` VALUES ('225040000', '', 'Rozrachunki z tytu³u wk³adów niepieniê¿nych na kapita³ zak³a', '3', '0');
INSERT INTO `0_chart_master` VALUES ('225050000', '', 'Rozrachunki z tytu³u podwy¿szenia kapita³u ze ¶rodków w³asny', '3', '0');
INSERT INTO `0_chart_master` VALUES ('225060000', '', 'Rozrachunki z tytu³u umorzenia udzia³ów w³asnych', '3', '0');
INSERT INTO `0_chart_master` VALUES ('225070000', '', 'Rozrachunki z tytu³u dywident', '3', '0');
INSERT INTO `0_chart_master` VALUES ('225080000', '', 'Rozrachunki z tytu³u dop³at i zwrotu dop³at', '3', '0');
INSERT INTO `0_chart_master` VALUES ('225090000', '', 'Pozosta³e rozrachunki ze wspólnikami', '3', '0');
INSERT INTO `0_chart_master` VALUES ('229000000', '', 'Odpisy aktualizuj±ce rozrachunki', '3', '0');
INSERT INTO `0_chart_master` VALUES ('330000000', '', 'Rozliczenie zakupu', '4', '0');
INSERT INTO `0_chart_master` VALUES ('330010000', '', 'Rozliczenie warto¶ci materia³ów i towarów w drodze', '4', '0');
INSERT INTO `0_chart_master` VALUES ('330020000', '', 'Warto¶ci dostaw niefakturowanych', '4', '0');
INSERT INTO `0_chart_master` VALUES ('330030000', '', 'Przychody wszelkich dostaw i us³ug i ich rozliczanie', '4', '0');
INSERT INTO `0_chart_master` VALUES ('330040000', '', 'Odhylenia cen ewidencyjnych od rzeczywistych cen nabycia lub', '4', '0');
INSERT INTO `0_chart_master` VALUES ('330050000', '', 'Koszty zakupu zawarte w fakturach dostawców', '4', '0');
INSERT INTO `0_chart_master` VALUES ('330060000', '', 'Op³aty manipulacyjne policzone przez Urz±d Celny', '4', '0');
INSERT INTO `0_chart_master` VALUES ('330070000', '', 'Niedobory, szkody i nadwy¿ki w transporcie', '4', '0');
INSERT INTO `0_chart_master` VALUES ('330080000', '', 'Znaki akcyzy wed³ug dokumentu SAD', '4', '0');
INSERT INTO `0_chart_master` VALUES ('330090000', '', 'Reklamacje faktur dostawców', '4', '0');
INSERT INTO `0_chart_master` VALUES ('331000000', '', 'Materia³y', '4', '0');
INSERT INTO `0_chart_master` VALUES ('331010000', '', 'Materia³y w magazynach w³asnych', '4', '0');
INSERT INTO `0_chart_master` VALUES ('331020000', '', 'Materia³y w magazynach obcych', '4', '0');
INSERT INTO `0_chart_master` VALUES ('331030000', '', 'Materia³y w przerobie', '4', '0');
INSERT INTO `0_chart_master` VALUES ('333000000', '', 'Towary', '4', '0');
INSERT INTO `0_chart_master` VALUES ('333010000', '', 'Towary w magazynach w³asnych', '4', '0');
INSERT INTO `0_chart_master` VALUES ('333020000', '', 'Towary w magazynach obcych', '4', '0');
INSERT INTO `0_chart_master` VALUES ('333030000', '', 'Towary w detalu', '4', '0');
INSERT INTO `0_chart_master` VALUES ('334000000', '', 'Odchylenia od cen ewidencyjnych materia³ów i towarów', '4', '0');
INSERT INTO `0_chart_master` VALUES ('334010000', '', 'Odpisy aktualizuj±ce warto¶æ materia³ów', '4', '0');
INSERT INTO `0_chart_master` VALUES ('334020000', '', 'Odpisy aktualizuj±ce warto¶æ towarów', '4', '0');
INSERT INTO `0_chart_master` VALUES ('440000000', '', 'Koszty wed³ug rodzajów', '5', '0');
INSERT INTO `0_chart_master` VALUES ('440010000', '', 'Zu¿ycie materia³ów i energii', '5', '0');
INSERT INTO `0_chart_master` VALUES ('440010100', '', 'Zu¿ycie materia³ów biurowych', '5', '0');
INSERT INTO `0_chart_master` VALUES ('440020000', '', 'Us³ugi obce', '5', '0');
INSERT INTO `0_chart_master` VALUES ('440020100', '', 'Us³ugi celne', '5', '0');
INSERT INTO `0_chart_master` VALUES ('440020200', '', 'Us³ugi telekomunikacyjne', '5', '0');
INSERT INTO `0_chart_master` VALUES ('440020300', '', 'Us³ugi pocztowe', '5', '0');
INSERT INTO `0_chart_master` VALUES ('440020400', '', 'Us³ugi kurierskie i transportowe', '5', '0');
INSERT INTO `0_chart_master` VALUES ('440020500', '', 'Analizy sanitarne', '5', '0');
INSERT INTO `0_chart_master` VALUES ('440020600', '', 'Us³ugi graficzne i drukarskie', '5', '0');
INSERT INTO `0_chart_master` VALUES ('440030000', '', 'Podatki i op³aty', '5', '0');
INSERT INTO `0_chart_master` VALUES ('440030100', '', 'Op³aty i prowizje bankowe', '5', '0');
INSERT INTO `0_chart_master` VALUES ('440030200', '', 'Op³aty s±dowe, prawnicze i notarialne', '5', '0');
INSERT INTO `0_chart_master` VALUES ('440030300', '', 'Op³aty skarbowe', '5', '0');
INSERT INTO `0_chart_master` VALUES ('440030400', '', 'Koncesje', '5', '0');
INSERT INTO `0_chart_master` VALUES ('440040000', '', 'Wynagrodzenia za pracê', '5', '0');
INSERT INTO `0_chart_master` VALUES ('441000000', '', '¦wiadczenia na rzecz pracowników', '5', '0');
INSERT INTO `0_chart_master` VALUES ('442000000', '', 'Amortyzacja', '5', '0');
INSERT INTO `0_chart_master` VALUES ('443000000', '', 'Pozosta³e', '5', '0');
INSERT INTO `0_chart_master` VALUES ('449000000', '', 'Rozliczenie kosztów', '5', '0');
INSERT INTO `0_chart_master` VALUES ('449010000', '', 'Nie podlegaj±ce rozliczeniu w czasie', '5', '0');
INSERT INTO `0_chart_master` VALUES ('449020000', '', 'Przypadaj±ce na przysz³e okresy', '5', '0');
INSERT INTO `0_chart_master` VALUES ('449030000', '', 'Koszty zgromadzone', '5', '0');
INSERT INTO `0_chart_master` VALUES ('449040000', '', 'Koszty nie wliczane do warto¶ci sprzeda¿y', '5', '0');
INSERT INTO `0_chart_master` VALUES ('550000000', '', 'Koszty dzia³alno¶ci podstawowej-produkcyjnej', '6', '0');
INSERT INTO `0_chart_master` VALUES ('550010000', '', 'Rozliczone koszta dzia³alno¶ci', '6', '0');
INSERT INTO `0_chart_master` VALUES ('550020000', '', 'Koszty nie zakoñczonych d³ugotrwa³ych us³ug', '6', '0');
INSERT INTO `0_chart_master` VALUES ('550030000', '', 'Straty zwi±zane z wykonaniem d³ugotrwa³ych us³ug', '6', '0');
INSERT INTO `0_chart_master` VALUES ('552000000', '', 'Koszty dzia³alno¶ci podstawowej-handlowej', '6', '0');
INSERT INTO `0_chart_master` VALUES ('552010000', '', 'Koszty utrzymania punktów sprzeda¼y detalicznej', '6', '0');
INSERT INTO `0_chart_master` VALUES ('550200000', '', 'Koszty utrzymania hurtowni', '6', '0');
INSERT INTO `0_chart_master` VALUES ('552030000', '', 'Koszty sprzeda¿y wyrobów', '6', '0');
INSERT INTO `0_chart_master` VALUES ('552040000', '', 'Podatek akcyzowy', '6', '0');
INSERT INTO `0_chart_master` VALUES ('552050000', '', 'Op³aty celne', '6', '0');
INSERT INTO `0_chart_master` VALUES ('553000000', '', 'Koszty dzia³alno¶ci pomocniczej', '6', '0');
INSERT INTO `0_chart_master` VALUES ('553010000', '', '¦wiadczenia us³ug transportowych', '6', '0');
INSERT INTO `0_chart_master` VALUES ('555000000', '', 'Koszty zarz±du', '6', '0');
INSERT INTO `0_chart_master` VALUES ('555010000', '', 'Koszty zarz±dzania jednostk±', '6', '0');
INSERT INTO `0_chart_master` VALUES ('555020000', '', '¦wiadczenia us³ug na potrzeby reprezentacji i reklamy', '6', '0');
INSERT INTO `0_chart_master` VALUES ('558000000', '', 'Rozliczenie kosztów dzia³alno¶ci', '6', '0');
INSERT INTO `0_chart_master` VALUES ('660000000', '', 'Pó³produkty i produkty w toku', '7', '0');
INSERT INTO `0_chart_master` VALUES ('661000000', '', 'Produkty gotowe', '7', '0');
INSERT INTO `0_chart_master` VALUES ('661010000', '', 'Wyroby gotowe', '7', '0');
INSERT INTO `0_chart_master` VALUES ('661020000', '', 'Wyroby poza jednostk±', '7', '0');
INSERT INTO `0_chart_master` VALUES ('662000000', '', 'Odchylenia od cen ewidencyjnych produktów', '7', '0');
INSERT INTO `0_chart_master` VALUES ('662010000', '', 'Odchylenia od cen evidencyjnych wyrobów gotowych', '7', '0');
INSERT INTO `0_chart_master` VALUES ('662020000', '', 'Odhylenia od cen evidencyjnych pó³fabrykatów', '7', '0');
INSERT INTO `0_chart_master` VALUES ('664000000', '', 'Rozliczenia miêdzyokresowe kosztów', '7', '0');
INSERT INTO `0_chart_master` VALUES ('664010000', '', 'Czynne rozliczenia miêdzyokresowe kosztów', '7', '0');
INSERT INTO `0_chart_master` VALUES ('664020000', '', 'Bierne rozliczenia miêdzyokresowe kosztów', '7', '0');
INSERT INTO `0_chart_master` VALUES ('665000000', '', 'Pozosta³e rozliczenia miêdzyokresowe', '7', '0');
INSERT INTO `0_chart_master` VALUES ('665010000', '', 'Czynne rozliczenia przysz³ych okresów', '7', '0');
INSERT INTO `0_chart_master` VALUES ('665020000', '', 'Bierne rozliczenia przysz³ych okresów', '7', '0');
INSERT INTO `0_chart_master` VALUES ('770000000', '', 'Sprzeda¿ produktów', '8', '0');
INSERT INTO `0_chart_master` VALUES ('770010000', '', 'Sprzeda¿ produktów na kraj', '8', '0');
INSERT INTO `0_chart_master` VALUES ('770020000', '', 'Sprzeda¿ produktów na eksport', '8', '0');
INSERT INTO `0_chart_master` VALUES ('770030000', '', 'Sprzeda¿ us³ug na kraj', '8', '0');
INSERT INTO `0_chart_master` VALUES ('770040000', '', 'Sprzeda¿ us³ug na eksport', '8', '0');
INSERT INTO `0_chart_master` VALUES ('770100000', '', 'Koszty sprzedanych produktów', '8', '0');
INSERT INTO `0_chart_master` VALUES ('770110000', '', 'Koszt w³asny sprzeda¿y produktów na kraj', '8', '0');
INSERT INTO `0_chart_master` VALUES ('770120000', '', 'Koszt w³asny sprzeda¿y produktów na eksport', '8', '0');
INSERT INTO `0_chart_master` VALUES ('770130000', '', 'Koszt w³asny sprzeda¿y us³ug na kraj', '8', '0');
INSERT INTO `0_chart_master` VALUES ('770140000', '', 'Koszt w³asny sprzeda¿y us³ug na export', '8', '0');
INSERT INTO `0_chart_master` VALUES ('773000000', '', 'Sprzeda¿ towarów', '8', '0');
INSERT INTO `0_chart_master` VALUES ('773010000', '', 'Sprzeda¿ hurtowa towarów', '8', '0');
INSERT INTO `0_chart_master` VALUES ('773020000', '', 'Sprzeda¿ detaliczna towarów', '8', '0');
INSERT INTO `0_chart_master` VALUES ('773030000', '', 'Sprzeda¿ wysy³kowa towarów', '8', '0');
INSERT INTO `0_chart_master` VALUES ('773040000', '', 'Prowizja komisowa', '8', '0');
INSERT INTO `0_chart_master` VALUES ('773100000', '', 'Warto¶æ sprzedanych towarów w cenach zakupu', '8', '0');
INSERT INTO `0_chart_master` VALUES ('773110000', '', 'Warto¶æ sprzedanych towarów w sprzeda¿y hurtowej', '8', '0');
INSERT INTO `0_chart_master` VALUES ('773120000', '', 'Warto¶æ sprzedanych towarów w sprzeda¿y detalicznej', '8', '0');
INSERT INTO `0_chart_master` VALUES ('773130000', '', 'Warto¶æ sprzedanych towarów w sprzeda¿y wysy³kowej', '8', '0');
INSERT INTO `0_chart_master` VALUES ('773140000', '', 'Prowizja komisowa', '8', '0');
INSERT INTO `0_chart_master` VALUES ('774000000', '', 'Sprzeda¿ materia³ów', '8', '0');
INSERT INTO `0_chart_master` VALUES ('774010000', '', 'Materia³y', '8', '0');
INSERT INTO `0_chart_master` VALUES ('774020000', '', 'Opakowania', '8', '0');
INSERT INTO `0_chart_master` VALUES ('774030000', '', 'Odpady', '8', '0');
INSERT INTO `0_chart_master` VALUES ('774100000', '', 'Warto¶æ sprzedanych materia³ów', '8', '0');
INSERT INTO `0_chart_master` VALUES ('774110000', '', 'Warto¶æ w cenach zakupu sprzedanych materia³ów', '8', '0');
INSERT INTO `0_chart_master` VALUES ('774120000', '', 'Warto¶æ w cenach zakupu sprzedanych opakowañ', '8', '0');
INSERT INTO `0_chart_master` VALUES ('774130000', '', 'Warto¶æ w cenach zakupu sprzedanych odpadów', '8', '0');
INSERT INTO `0_chart_master` VALUES ('775000000', '', 'Przychody finansowe', '8', '0');
INSERT INTO `0_chart_master` VALUES ('775010000', '', 'Kwoty nale¿ne ze sprzeda¿y aktywów finansowych', '8', '0');
INSERT INTO `0_chart_master` VALUES ('775020000', '', 'Kwoty nale¿ne z tytu³u dywident', '8', '0');
INSERT INTO `0_chart_master` VALUES ('775030000', '', 'Otrzymane odsetki', '8', '0');
INSERT INTO `0_chart_master` VALUES ('775040000', '', 'Przychody ze zbycia investycji', '8', '0');
INSERT INTO `0_chart_master` VALUES ('775050000', '', 'Aktualizacja warto¶ci investycji-przychody', '8', '0');
INSERT INTO `0_chart_master` VALUES ('775060000', '', 'Dodatnie ró¿nice kursu walut', '8', '0');
INSERT INTO `0_chart_master` VALUES ('775070000', '', 'Pozosta³e przychody finansowe', '8', '0');
INSERT INTO `0_chart_master` VALUES ('775100000', '', 'Koszty finansowe', '8', '0');
INSERT INTO `0_chart_master` VALUES ('775110000', '', 'Warto¶æ sprzedanych investycji', '8', '0');
INSERT INTO `0_chart_master` VALUES ('775120000', '', 'Odpisy z tytu³u utraty warto¶ci investycji-koszty', '8', '0');
INSERT INTO `0_chart_master` VALUES ('775130000', '', 'Odsetki zap³acone', '8', '0');
INSERT INTO `0_chart_master` VALUES ('775140000', '', 'Ujemne ró¿nice kursu walut', '8', '0');
INSERT INTO `0_chart_master` VALUES ('775190000', '', 'Pozosta³e koszty finansowe', '8', '0');
INSERT INTO `0_chart_master` VALUES ('776000000', '', 'Pozosta³e przychody operacyjne', '8', '0');
INSERT INTO `0_chart_master` VALUES ('776010000', '', 'Przychody ze zbycia niefinansowych aktywów trwa³ych', '8', '0');
INSERT INTO `0_chart_master` VALUES ('776020000', '', 'Otrzymane dotacje', '8', '0');
INSERT INTO `0_chart_master` VALUES ('776030000', '', 'Przychody z us³ug socjalnych', '8', '0');
INSERT INTO `0_chart_master` VALUES ('776040000', '', 'Przychody ze wzrostu warto¶ci niefinansowych aktywów trwa³yc', '8', '0');
INSERT INTO `0_chart_master` VALUES ('776090000', '', 'Inne pozosta³e przychody operacyjne', '8', '0');
INSERT INTO `0_chart_master` VALUES ('776100000', '', 'Pozosta³e koszty operacyjne', '8', '0');
INSERT INTO `0_chart_master` VALUES ('776110000', '', 'Warto¶æ sprzedanych niefinansowych aktywów trwa³ych', '8', '0');
INSERT INTO `0_chart_master` VALUES ('776120000', '', 'Dotacje przekazane', '8', '0');
INSERT INTO `0_chart_master` VALUES ('776130000', '', 'Odpisy z tytu³u utraty warto¶ci aktywów niefinansowych', '8', '0');
INSERT INTO `0_chart_master` VALUES ('776140000', '', 'Inne pozosta³e koszty operacyjne', '8', '0');
INSERT INTO `0_chart_master` VALUES ('777000000', '', 'Zyski nadzwyczajne', '8', '0');
INSERT INTO `0_chart_master` VALUES ('777100000', '', 'Straty nadzwyczajne', '8', '0');
INSERT INTO `0_chart_master` VALUES ('779000000', '', 'Obroty wewnêtrzne', '8', '0');
INSERT INTO `0_chart_master` VALUES ('779010000', '', 'Koszt wyrobów w³asnej produkcji wydanych do w³asnych sklepów', '8', '0');
INSERT INTO `0_chart_master` VALUES ('779020000', '', '¦wiadczenia na rzecz ¶rodków trwa³ych w budowie', '8', '0');
INSERT INTO `0_chart_master` VALUES ('779040000', '', 'Koszt niedoborów produktów', '8', '0');
INSERT INTO `0_chart_master` VALUES ('779050000', '', 'Koszt zaniechania okre¶lonego rodzaju dzia³alno¶ci', '8', '0');
INSERT INTO `0_chart_master` VALUES ('779100000', '', 'Koszt obrotów wewnêtrznych', '8', '0');
INSERT INTO `0_chart_master` VALUES ('779110000', '', 'Koszt wytworzenia wyrobów gotowych wydanych do w³asnych skle', '8', '0');
INSERT INTO `0_chart_master` VALUES ('779120000', '', 'Koszt wytworzenia ¶wiadczeñ na rzecz ¶rodków trwa³ych w budo', '8', '0');
INSERT INTO `0_chart_master` VALUES ('779130000', '', 'Koszt wytworzenia zakoñczonych prac rozwojowych', '8', '0');
INSERT INTO `0_chart_master` VALUES ('779140000', '', 'Koszt wytworzenia produktów uznanych za niedobory', '8', '0');
INSERT INTO `0_chart_master` VALUES ('779150000', '', 'Koszt zaniechania okre¶lonego rodzaju dzia³alno¶ci', '8', '0');
INSERT INTO `0_chart_master` VALUES ('880000000', '', 'Kapita³ podstawowy', '9', '0');
INSERT INTO `0_chart_master` VALUES ('880010000', '', 'Kapita³ zak³adowy', '9', '0');
INSERT INTO `0_chart_master` VALUES ('881000000', '', 'Fundusze wydzielone jednostkom zale¿nym', '9', '0');
INSERT INTO `0_chart_master` VALUES ('882000000', '', 'Nale¿ne wp³aty na kapita³ podstawowy', '9', '0');
INSERT INTO `0_chart_master` VALUES ('883000000', '', 'Fundusze wydzielone jednostkom zale¿nym', '9', '0');
INSERT INTO `0_chart_master` VALUES ('884000000', '', 'Kapita³ zapasowy', '9', '0');
INSERT INTO `0_chart_master` VALUES ('885000000', '', 'Kapita³ rezerwowy', '9', '0');
INSERT INTO `0_chart_master` VALUES ('886000000', '', 'Kapita³ z aktualizacji wyceny', '9', '0');
INSERT INTO `0_chart_master` VALUES ('887000000', '', 'Rozliczenia wyniku finansowego', '9', '0');
INSERT INTO `0_chart_master` VALUES ('888000000', '', 'Rezerwy', '9', '0');
INSERT INTO `0_chart_master` VALUES ('888010000', '', 'Rezerwa z tytu³u odroczonego podatku dochodowego', '9', '0');
INSERT INTO `0_chart_master` VALUES ('888020000', '', 'Rezerwa na ¶wiadczenia', '9', '0');
INSERT INTO `0_chart_master` VALUES ('888020100', '', 'Rezerwa d³ugoterminowa na ¶wiadczenia emerytalne i podobne', '9', '0');
INSERT INTO `0_chart_master` VALUES ('888020200', '', 'Rezerwa krótkoterminowa na ¶wiadczenia emerytalne i podobne', '9', '0');
INSERT INTO `0_chart_master` VALUES ('889090000', '', 'Pozosta³e rezerwy', '9', '0');
INSERT INTO `0_chart_master` VALUES ('889090100', '', 'Pozosta³e rezerwy d³ugoterminowe', '9', '0');
INSERT INTO `0_chart_master` VALUES ('889090200', '', 'Pozosta³e rezerwy krótkoterminowe', '9', '0');
INSERT INTO `0_chart_master` VALUES ('890000000', '', 'Rozliczenia miêdzyokresowe', '9', '0');
INSERT INTO `0_chart_master` VALUES ('890010000', '', 'Ujemna warto¶æ firmy', '9', '0');
INSERT INTO `0_chart_master` VALUES ('890020000', '', 'Inne rozliczenia miêdzyokresowe', '9', '0');
INSERT INTO `0_chart_master` VALUES ('890020100', '', 'Inne rozliczenia miêdzyokresowe d³ugoterminowe', '9', '0');
INSERT INTO `0_chart_master` VALUES ('890020200', '', 'Inne rozliczenia miêdzyokresowe krótkoterminowe', '9', '0');
INSERT INTO `0_chart_master` VALUES ('891000000', '', 'Fundusze specjalne', '9', '0');
INSERT INTO `0_chart_master` VALUES ('892000000', '', 'Wynik finansowy', '9', '0');
INSERT INTO `0_chart_master` VALUES ('893000000', '', 'Odpisy z zysku netto w ci±gu roku obrotowego', '9', '0');
INSERT INTO `0_chart_master` VALUES ('893010000', '', 'Podatek dochodowy', '9', '0');
INSERT INTO `0_chart_master` VALUES ('893020000', '', 'Inne obowi±zkowe obci±¿enia wyniku finansowego', '9', '0');


### Structure of table `0_chart_types` ###

DROP TABLE IF EXISTS `0_chart_types`;

CREATE TABLE `0_chart_types` (
  `id` varchar(10) NOT NULL,
  `name` varchar(60) NOT NULL default '',
  `class_id` varchar(3) NOT NULL default '',
  `parent` varchar(10) NOT NULL default '-1',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `name` (`name`),
  KEY `class_id` (`class_id`)
) ENGINE=MyISAM AUTO_INCREMENT=53 DEFAULT CHARSET=latin1 ;


### Data of table `0_chart_types` ###

INSERT INTO `0_chart_types` VALUES ('1', 'Aktywa Trwa³e', '1', '', '0');
INSERT INTO `0_chart_types` VALUES ('2', '¦rodki pieniê¿ne, rachunki bankowe oraz inne krótkoterminowe', '1', '', '0');
INSERT INTO `0_chart_types` VALUES ('3', 'Rozrachunki i roszczenia', '2', '', '0');
INSERT INTO `0_chart_types` VALUES ('4', 'Materia³y i towary', '1', '', '0');
INSERT INTO `0_chart_types` VALUES ('5', 'Koszty wed³ug rodzajów i ich rozliczeñ', '4', '', '0');
INSERT INTO `0_chart_types` VALUES ('6', 'Koszty wed³ug typów dzia³alno¶ci i ich rozliczenie', '4', '', '0');
INSERT INTO `0_chart_types` VALUES ('7', 'Produkty i rozliczenia miêdzyokresowe', '1', '', '0');
INSERT INTO `0_chart_types` VALUES ('8', 'Przychody i koszty zwi±zane z ich osi±gniêciem', '3', '', '0');
INSERT INTO `0_chart_types` VALUES ('9', 'Kapita³y w³asne i wynik finansowy', '2', '', '0');


### Structure of table `0_comments` ###

DROP TABLE IF EXISTS `0_comments`;

CREATE TABLE `0_comments` (
  `type` int(11) NOT NULL default '0',
  `id` int(11) NOT NULL default '0',
  `date_` date default '0000-00-00',
  `memo_` tinytext,
  KEY `type_and_id` (`type`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


### Data of table `0_comments` ###


### Structure of table `0_credit_status` ###

DROP TABLE IF EXISTS `0_credit_status`;

CREATE TABLE `0_credit_status` (
  `id` int(11) NOT NULL auto_increment,
  `reason_description` char(100) NOT NULL default '',
  `dissallow_invoices` tinyint(1) NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `reason_description` (`reason_description`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 ;


### Data of table `0_credit_status` ###

INSERT INTO `0_credit_status` VALUES ('1', 'Good History', '0', '0');
INSERT INTO `0_credit_status` VALUES ('3', 'No more work until payment received', '1', '0');
INSERT INTO `0_credit_status` VALUES ('4', 'In liquidation', '1', '0');


### Structure of table `0_crm_categories` ###

DROP TABLE IF EXISTS `0_crm_categories`;

CREATE TABLE `0_crm_categories` (
  `id` int(11) NOT NULL auto_increment COMMENT 'pure technical key',
  `type` varchar(20) NOT NULL COMMENT 'contact type e.g. customer',
  `action` varchar(20) NOT NULL COMMENT 'detailed usage e.g. department',
  `name` varchar(30) NOT NULL COMMENT 'for category selector',
  `description` tinytext NOT NULL COMMENT 'usage description',
  `system` tinyint(1) NOT NULL default '0' COMMENT 'nonzero for core system usage',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `type` (`type`,`action`),
  UNIQUE KEY `type_2` (`type`,`name`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1 ;


### Data of table `0_crm_categories` ###

INSERT INTO `0_crm_categories` VALUES ('1', 'cust_branch', 'general', 'General', 'General contact data for customer branch (overrides company setting)', '1', '0');
INSERT INTO `0_crm_categories` VALUES ('2', 'cust_branch', 'invoice', 'Invoices', 'Invoice posting (overrides company setting)', '1', '0');
INSERT INTO `0_crm_categories` VALUES ('3', 'cust_branch', 'order', 'Orders', 'Order confirmation (overrides company setting)', '1', '0');
INSERT INTO `0_crm_categories` VALUES ('4', 'cust_branch', 'delivery', 'Deliveries', 'Delivery coordination (overrides company setting)', '1', '0');
INSERT INTO `0_crm_categories` VALUES ('5', 'customer', 'general', 'General', 'General contact data for customer', '1', '0');
INSERT INTO `0_crm_categories` VALUES ('6', 'customer', 'order', 'Orders', 'Order confirmation', '1', '0');
INSERT INTO `0_crm_categories` VALUES ('7', 'customer', 'delivery', 'Deliveries', 'Delivery coordination', '1', '0');
INSERT INTO `0_crm_categories` VALUES ('8', 'customer', 'invoice', 'Invoices', 'Invoice posting', '1', '0');
INSERT INTO `0_crm_categories` VALUES ('9', 'supplier', 'general', 'General', 'General contact data for supplier', '1', '0');
INSERT INTO `0_crm_categories` VALUES ('10', 'supplier', 'order', 'Orders', 'Order confirmation', '1', '0');
INSERT INTO `0_crm_categories` VALUES ('11', 'supplier', 'delivery', 'Deliveries', 'Delivery coordination', '1', '0');
INSERT INTO `0_crm_categories` VALUES ('12', 'supplier', 'invoice', 'Invoices', 'Invoice posting', '1', '0');


### Structure of table `0_crm_contacts` ###

DROP TABLE IF EXISTS `0_crm_contacts`;

CREATE TABLE `0_crm_contacts` (
  `id` int(11) NOT NULL auto_increment,
  `person_id` int(11) NOT NULL default '0' COMMENT 'foreign key to crm_contacts',
  `type` varchar(20) NOT NULL COMMENT 'foreign key to crm_categories',
  `action` varchar(20) NOT NULL COMMENT 'foreign key to crm_categories',
  `entity_id` varchar(11) default NULL COMMENT 'entity id in related class table',
  PRIMARY KEY  (`id`),
  KEY `type` (`type`,`action`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


### Data of table `0_crm_contacts` ###



### Structure of table `0_crm_persons` ###

DROP TABLE IF EXISTS `0_crm_persons`;

CREATE TABLE `0_crm_persons` (
  `id` int(11) NOT NULL auto_increment,
  `ref` varchar(30) NOT NULL,
  `name` varchar(60) NOT NULL,
  `name2` varchar(60) default NULL,
  `address` tinytext,
  `phone` varchar(30) default NULL,
  `phone2` varchar(30) default NULL,
  `fax` varchar(30) default NULL,
  `email` varchar(100) default NULL,
  `lang` char(5) default NULL,
  `notes` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `ref` (`ref`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


### Data of table `0_crm_persons` ###



### Structure of table `0_currencies` ###

DROP TABLE IF EXISTS `0_currencies`;

CREATE TABLE `0_currencies` (
  `currency` varchar(60) NOT NULL default '',
  `curr_abrev` char(3) NOT NULL default '',
  `curr_symbol` varchar(10) NOT NULL default '',
  `country` varchar(100) NOT NULL default '',
  `hundreds_name` varchar(15) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  `auto_update` tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (`curr_abrev`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;


### Data of table `0_currencies` ###

INSERT INTO `0_currencies` VALUES ('PLN', 'PLN', '', '', '', '0', '1');
INSERT INTO `0_currencies` VALUES ('Euro', 'EUR', '?', 'Europe', 'Cents', '0', '1');
INSERT INTO `0_currencies` VALUES ('Pounds', 'GBP', '?', 'England', 'Pence', '0', '1');
INSERT INTO `0_currencies` VALUES ('US Dollars', 'USD', '$', 'United States', 'Cents', '0', '1');


### Structure of table `0_cust_allocations` ###

DROP TABLE IF EXISTS `0_cust_allocations`;

CREATE TABLE `0_cust_allocations` (
  `id` int(11) NOT NULL auto_increment,
  `amt` double unsigned default NULL,
  `date_alloc` date NOT NULL default '0000-00-00',
  `trans_no_from` int(11) default NULL,
  `trans_type_from` int(11) default NULL,
  `trans_no_to` int(11) default NULL,
  `trans_type_to` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `From` (`trans_type_from`,`trans_no_from`),
  KEY `To` (`trans_type_to`,`trans_no_to`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


### Data of table `0_cust_allocations` ###



### Structure of table `0_cust_branch` ###

DROP TABLE IF EXISTS `0_cust_branch`;

CREATE TABLE `0_cust_branch` (
  `branch_code` int(11) NOT NULL auto_increment,
  `debtor_no` int(11) NOT NULL default '0',
  `br_name` varchar(60) NOT NULL default '',
  `br_address` tinytext NOT NULL,
  `area` int(11) default NULL,
  `salesman` int(11) NOT NULL default '0',
  `contact_name` varchar(60) NOT NULL default '',
  `default_location` varchar(5) NOT NULL default '',
  `tax_group_id` int(11) default NULL,
  `sales_account` varchar(15) NOT NULL default '',
  `sales_discount_account` varchar(15) NOT NULL default '',
  `receivables_account` varchar(15) NOT NULL default '',
  `payment_discount_account` varchar(15) NOT NULL default '',
  `default_ship_via` int(11) NOT NULL default '1',
  `disable_trans` tinyint(4) NOT NULL default '0',
  `br_post_address` tinytext NOT NULL,
  `group_no` int(11) NOT NULL default '0',
  `notes` tinytext,
  `inactive` tinyint(1) NOT NULL default '0',
  `branch_ref` varchar(30) NOT NULL,
  PRIMARY KEY  (`branch_code`,`debtor_no`),
  KEY `branch_code` (`branch_code`),
  KEY `branch_ref` (`branch_ref`),
  KEY `group_no` (`group_no`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;


### Data of table `0_cust_branch` ###



### Structure of table `0_debtor_trans` ###

DROP TABLE IF EXISTS `0_debtor_trans`;

CREATE TABLE `0_debtor_trans` (
  `trans_no` int(11) unsigned NOT NULL default '0',
  `type` smallint(6) unsigned NOT NULL default '0',
  `version` tinyint(1) unsigned NOT NULL default '0',
  `debtor_no` int(11) unsigned default NULL,
  `branch_code` int(11) NOT NULL default '-1',
  `tran_date` date NOT NULL default '0000-00-00',
  `due_date` date NOT NULL default '0000-00-00',
  `reference` varchar(60) NOT NULL default '',
  `tpe` int(11) NOT NULL default '0',
  `order_` int(11) NOT NULL default '0',
  `ov_amount` double NOT NULL default '0',
  `ov_gst` double NOT NULL default '0',
  `ov_freight` double NOT NULL default '0',
  `ov_freight_tax` double NOT NULL default '0',
  `ov_discount` double NOT NULL default '0',
  `alloc` double NOT NULL default '0',
  `rate` double NOT NULL default '1',
  `ship_via` int(11) default NULL,
  `dimension_id` int(11) NOT NULL default '0',
  `dimension2_id` int(11) NOT NULL default '0',
  `payment_terms` int(11) default NULL,
  PRIMARY KEY  (`type`,`trans_no`),
  KEY `debtor_no` (`debtor_no`,`branch_code`),
  KEY `tran_date` (`tran_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


### Data of table `0_debtor_trans` ###



### Structure of table `0_debtor_trans_details` ###

DROP TABLE IF EXISTS `0_debtor_trans_details`;

CREATE TABLE `0_debtor_trans_details` (
  `id` int(11) NOT NULL auto_increment,
  `debtor_trans_no` int(11) default NULL,
  `debtor_trans_type` int(11) default NULL,
  `stock_id` varchar(20) NOT NULL default '',
  `description` tinytext,
  `unit_price` double NOT NULL default '0',
  `unit_tax` double NOT NULL default '0',
  `quantity` double NOT NULL default '0',
  `discount_percent` double NOT NULL default '0',
  `standard_cost` double NOT NULL default '0',
  `qty_done` double NOT NULL default '0',
  `src_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `Transaction` (`debtor_trans_type`,`debtor_trans_no`),
  KEY `src_id` (`src_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


### Data of table `0_debtor_trans_details` ###


### Structure of table `0_debtors_master` ###

DROP TABLE IF EXISTS `0_debtors_master`;

CREATE TABLE `0_debtors_master` (
  `debtor_no` int(11) NOT NULL auto_increment,
  `name` varchar(100) NOT NULL default '',
  `address` tinytext,
  `tax_id` varchar(55) NOT NULL default '',
  `curr_code` char(3) NOT NULL default '',
  `sales_type` int(11) NOT NULL default '1',
  `dimension_id` int(11) NOT NULL default '0',
  `dimension2_id` int(11) NOT NULL default '0',
  `credit_status` int(11) NOT NULL default '0',
  `payment_terms` int(11) default NULL,
  `discount` double NOT NULL default '0',
  `pymt_discount` double NOT NULL default '0',
  `credit_limit` float NOT NULL default '1000',
  `notes` tinytext,
  `inactive` tinyint(1) NOT NULL default '0',
  `debtor_ref` varchar(30) NOT NULL,
  PRIMARY KEY  (`debtor_no`),
  KEY `name` (`name`),
  UNIQUE KEY `debtor_ref` (`debtor_ref`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ;


### Data of table `0_debtors_master` ###



### Structure of table `0_dimensions` ###

DROP TABLE IF EXISTS `0_dimensions`;

CREATE TABLE `0_dimensions` (
  `id` int(11) NOT NULL auto_increment,
  `reference` varchar(60) NOT NULL default '',
  `name` varchar(60) NOT NULL default '',
  `type_` tinyint(1) NOT NULL default '1',
  `closed` tinyint(1) NOT NULL default '0',
  `date_` date NOT NULL default '0000-00-00',
  `due_date` date NOT NULL default '0000-00-00',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `reference` (`reference`),
  KEY `date_` (`date_`),
  KEY `due_date` (`due_date`),
  KEY `type_` (`type_`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


### Data of table `0_dimensions` ###



### Structure of table `0_exchange_rates` ###

DROP TABLE IF EXISTS `0_exchange_rates`;

CREATE TABLE `0_exchange_rates` (
  `id` int(11) NOT NULL auto_increment,
  `curr_code` char(3) NOT NULL default '',
  `rate_buy` double NOT NULL default '0',
  `rate_sell` double NOT NULL default '0',
  `date_` date NOT NULL default '0000-00-00',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `curr_code` (`curr_code`,`date_`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;


### Data of table `0_exchange_rates` ###



### Structure of table `0_fiscal_year` ###

DROP TABLE IF EXISTS `0_fiscal_year`;

CREATE TABLE `0_fiscal_year` (
  `id` int(11) NOT NULL auto_increment,
  `begin` date default '0000-00-00',
  `end` date default '0000-00-00',
  `closed` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `begin` (`begin`),
  UNIQUE KEY `end` (`end`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ;


### Data of table `0_fiscal_year` ###

INSERT INTO `0_fiscal_year` VALUES ('1', '2008-01-01', '2008-12-31', '0');


### Structure of table `0_gl_trans` ###

DROP TABLE IF EXISTS `0_gl_trans`;

CREATE TABLE `0_gl_trans` (
  `counter` int(11) NOT NULL auto_increment,
  `type` smallint(6) NOT NULL default '0',
  `type_no` bigint(16) NOT NULL default '1',
  `tran_date` date NOT NULL default '0000-00-00',
  `account` varchar(15) NOT NULL default '',
  `memo_` tinytext NOT NULL,
  `amount` double NOT NULL default '0',
  `dimension_id` int(11) NOT NULL default '0',
  `dimension2_id` int(11) NOT NULL default '0',
  `person_type_id` int(11) default NULL,
  `person_id` tinyblob,
  PRIMARY KEY  (`counter`),
  KEY `Type_and_Number` (`type`,`type_no`),
  KEY `dimension_id` (`dimension_id`),
  KEY `dimension2_id` (`dimension2_id`),
  KEY `tran_date` (`tran_date`),
  KEY `account_and_tran_date` (`account`,`tran_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


### Data of table `0_gl_trans` ###



### Structure of table `0_grn_batch` ###

DROP TABLE IF EXISTS `0_grn_batch`;

CREATE TABLE `0_grn_batch` (
  `id` int(11) NOT NULL auto_increment,
  `supplier_id` int(11) NOT NULL default '0',
  `purch_order_no` int(11) default NULL,
  `reference` varchar(60) NOT NULL default '',
  `delivery_date` date NOT NULL default '0000-00-00',
  `loc_code` varchar(5) default NULL,
  PRIMARY KEY  (`id`),
  KEY `delivery_date` (`delivery_date`),
  KEY `purch_order_no` (`purch_order_no`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


### Data of table `0_grn_batch` ###



### Structure of table `0_grn_items` ###

DROP TABLE IF EXISTS `0_grn_items`;

CREATE TABLE `0_grn_items` (
  `id` int(11) NOT NULL auto_increment,
  `grn_batch_id` int(11) default NULL,
  `po_detail_item` int(11) NOT NULL default '0',
  `item_code` varchar(20) NOT NULL default '',
  `description` tinytext,
  `qty_recd` double NOT NULL default '0',
  `quantity_inv` double NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `grn_batch_id` (`grn_batch_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


### Data of table `0_grn_items` ###



### Structure of table `0_groups` ###

DROP TABLE IF EXISTS `0_groups`;

CREATE TABLE `0_groups` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `description` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `description` (`description`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 ;


### Data of table `0_groups` ###

INSERT INTO `0_groups` VALUES ('1', 'Small', '0');
INSERT INTO `0_groups` VALUES ('2', 'Medium', '0');
INSERT INTO `0_groups` VALUES ('3', 'Large', '0');


### Structure of table `0_item_codes` ###

DROP TABLE IF EXISTS `0_item_codes`;

CREATE TABLE `0_item_codes` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `item_code` varchar(20) NOT NULL,
  `stock_id` varchar(20) NOT NULL,
  `description` varchar(200) NOT NULL default '',
  `category_id` smallint(6) unsigned NOT NULL,
  `quantity` double NOT NULL default '1',
  `is_foreign` tinyint(1) NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `stock_id` (`stock_id`,`item_code`),
  KEY `item_code` (`item_code`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;


### Data of table `0_item_codes` ###



### Structure of table `0_item_tax_type_exemptions` ###

DROP TABLE IF EXISTS `0_item_tax_type_exemptions`;

CREATE TABLE `0_item_tax_type_exemptions` (
  `item_tax_type_id` int(11) NOT NULL default '0',
  `tax_type_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`item_tax_type_id`,`tax_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


### Data of table `0_item_tax_type_exemptions` ###



### Structure of table `0_item_tax_types` ###

DROP TABLE IF EXISTS `0_item_tax_types`;

CREATE TABLE `0_item_tax_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(60) NOT NULL default '',
  `exempt` tinyint(1) NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


### Data of table `0_item_tax_types` ###



### Structure of table `0_item_units` ###

DROP TABLE IF EXISTS `0_item_units`;

CREATE TABLE `0_item_units` (
  `abbr` varchar(20) NOT NULL,
  `name` varchar(40) NOT NULL,
  `decimals` tinyint(2) NOT NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`abbr`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;


### Data of table `0_item_units` ###

INSERT INTO `0_item_units` VALUES ('szt', 'Sztuka', '0', '0');


### Structure of table `0_loc_stock` ###

DROP TABLE IF EXISTS `0_loc_stock`;

CREATE TABLE `0_loc_stock` (
  `loc_code` char(5) NOT NULL default '',
  `stock_id` char(20) NOT NULL default '',
  `reorder_level` bigint(20) NOT NULL default '0',
  PRIMARY KEY  (`loc_code`,`stock_id`),
  KEY `stock_id` (`stock_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


### Data of table `0_loc_stock` ###



### Structure of table `0_locations` ###

DROP TABLE IF EXISTS `0_locations`;

CREATE TABLE `0_locations` (
  `loc_code` varchar(5) NOT NULL default '',
  `location_name` varchar(60) NOT NULL default '',
  `delivery_address` tinytext NOT NULL,
  `phone` varchar(30) NOT NULL default '',
  `phone2` varchar(30) NOT NULL default '',
  `fax` varchar(30) NOT NULL default '',
  `email` varchar(100) NOT NULL default '',
  `contact` varchar(30) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`loc_code`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;


### Data of table `0_locations` ###

INSERT INTO `0_locations` VALUES ('DEF', 'Domy¶lna', 'N/A', '', '', '', '', '', '0');


### Structure of table `0_movement_types` ###

DROP TABLE IF EXISTS `0_movement_types`;

CREATE TABLE `0_movement_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ;


### Data of table `0_movement_types` ###

INSERT INTO `0_movement_types` VALUES ('1', 'Korekta', '0');


### Structure of table `0_payment_terms` ###

DROP TABLE IF EXISTS `0_payment_terms`;

CREATE TABLE `0_payment_terms` (
  `terms_indicator` int(11) NOT NULL auto_increment,
  `terms` char(80) NOT NULL default '',
  `days_before_due` smallint(6) NOT NULL default '0',
  `day_in_following_month` smallint(6) NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`terms_indicator`),
  UNIQUE KEY `terms` (`terms`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 ;


### Data of table `0_payment_terms` ###

INSERT INTO `0_payment_terms` VALUES ('1', 'Do 15go Nasêpnego Miesi±ca', '0', '17', '0');
INSERT INTO `0_payment_terms` VALUES ('2', 'Do koñca nastêpnego Miesi±ca', '0', '30', '0');
INSERT INTO `0_payment_terms` VALUES ('3', '10 dni', '10', '0', '0');
INSERT INTO `0_payment_terms` VALUES ('4', 'Gotówka', '1', '0', '0');

### Structure of table `0_prices` ###

DROP TABLE IF EXISTS `0_prices`;

CREATE TABLE `0_prices` (
  `id` int(11) NOT NULL auto_increment,
  `stock_id` varchar(20) NOT NULL default '',
  `sales_type_id` int(11) NOT NULL default '0',
  `curr_abrev` char(3) NOT NULL default '',
  `price` double NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `price` (`stock_id`,`sales_type_id`,`curr_abrev`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;


### Data of table `0_prices` ###



### Structure of table `0_print_profiles` ###

DROP TABLE IF EXISTS `0_print_profiles`;

CREATE TABLE `0_print_profiles` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `profile` varchar(30) NOT NULL,
  `report` varchar(5) default NULL,
  `printer` tinyint(3) unsigned default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `profile` (`profile`,`report`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=latin1 ;


### Data of table `0_print_profiles` ###

INSERT INTO `0_print_profiles` VALUES ('1', 'Poza biurem', NULL, '0');
INSERT INTO `0_print_profiles` VALUES ('2', 'Dzia³ Handlowy', NULL, '0');
INSERT INTO `0_print_profiles` VALUES ('3', 'Centrala', NULL, '2');
INSERT INTO `0_print_profiles` VALUES ('4', '', '104', '2');
INSERT INTO `0_print_profiles` VALUES ('5', 'Dzia³ Handlowy', '105', '2');
INSERT INTO `0_print_profiles` VALUES ('6', 'Dzia³ Handlowy', '107', '2');
INSERT INTO `0_print_profiles` VALUES ('7', 'Dzia³ Handlowy', '109', '2');
INSERT INTO `0_print_profiles` VALUES ('8', 'Dzia³ Handlowy', '110', '2');
INSERT INTO `0_print_profiles` VALUES ('9', 'Dzia³ Handlowy', '201', '2');


### Structure of table `0_printers` ###

DROP TABLE IF EXISTS `0_printers`;

CREATE TABLE `0_printers` (
  `id` tinyint(3) unsigned NOT NULL auto_increment,
  `name` varchar(20) NOT NULL,
  `description` varchar(60) NOT NULL,
  `queue` varchar(20) NOT NULL,
  `host` varchar(40) NOT NULL,
  `port` smallint(11) unsigned NOT NULL,
  `timeout` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 ;


### Data of table `0_printers` ###

INSERT INTO `0_printers` VALUES ('1', 'QL500', 'Drukarka etykiet', 'QL500', 'server', '127', '20');
INSERT INTO `0_printers` VALUES ('2', 'Samsung', 'G³ó³na drukarka sieciowa', 'scx4521F', 'server', '515', '5');
INSERT INTO `0_printers` VALUES ('3', 'Local', 'Lokalna drukarka pod IP u¿ytkownika', 'lp', '', '515', '10');


### Structure of table `0_purch_data` ###

DROP TABLE IF EXISTS `0_purch_data`;

CREATE TABLE `0_purch_data` (
  `supplier_id` int(11) NOT NULL default '0',
  `stock_id` char(20) NOT NULL default '',
  `price` double NOT NULL default '0',
  `suppliers_uom` char(50) NOT NULL default '',
  `conversion_factor` double NOT NULL default '1',
  `supplier_description` char(50) NOT NULL default '',
  PRIMARY KEY  (`supplier_id`,`stock_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;


### Data of table `0_purch_data` ###



### Structure of table `0_purch_order_details` ###

DROP TABLE IF EXISTS `0_purch_order_details`;

CREATE TABLE `0_purch_order_details` (
  `po_detail_item` int(11) NOT NULL auto_increment,
  `order_no` int(11) NOT NULL default '0',
  `item_code` varchar(20) NOT NULL default '',
  `description` tinytext,
  `delivery_date` date NOT NULL default '0000-00-00',
  `qty_invoiced` double NOT NULL default '0',
  `unit_price` double NOT NULL default '0',
  `act_price` double NOT NULL default '0',
  `std_cost_unit` double NOT NULL default '0',
  `quantity_ordered` double NOT NULL default '0',
  `quantity_received` double NOT NULL default '0',
  PRIMARY KEY  (`po_detail_item`),
  KEY `order` (`order_no`,`po_detail_item`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


### Data of table `0_purch_order_details` ###



### Structure of table `0_purch_orders` ###

DROP TABLE IF EXISTS `0_purch_orders`;

CREATE TABLE `0_purch_orders` (
  `order_no` int(11) NOT NULL auto_increment,
  `supplier_id` int(11) NOT NULL default '0',
  `comments` tinytext,
  `ord_date` date NOT NULL default '0000-00-00',
  `reference` tinytext NOT NULL,
  `requisition_no` tinytext,
  `into_stock_location` varchar(5) NOT NULL default '',
  `delivery_address` tinytext NOT NULL,
  `total` double NOT NULL default '0',
  `tax_included` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`order_no`),
  KEY `ord_date` (`ord_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


### Data of table `0_purch_orders` ###



### Structure of table `0_quick_entries` ###

DROP TABLE IF EXISTS `0_quick_entries`;

CREATE TABLE `0_quick_entries` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `type` tinyint(1) NOT NULL default '0',
  `description` varchar(60) NOT NULL,
  `base_amount` double NOT NULL default '0',
  `base_desc` varchar(60) default NULL,
  `bal_type` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `description` (`description`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 ;


### Data of table `0_quick_entries` ###

### Structure of table `0_quick_entry_lines` ###

DROP TABLE IF EXISTS `0_quick_entry_lines`;

CREATE TABLE `0_quick_entry_lines` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `qid` smallint(6) unsigned NOT NULL,
  `amount` double default '0',
  `action` varchar(2) NOT NULL,
  `dest_id` varchar(15) NOT NULL default '',
  `dimension_id` smallint(6) unsigned default NULL,
  `dimension2_id` smallint(6) unsigned default NULL,
  PRIMARY KEY  (`id`),
  KEY `qid` (`qid`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 ;


### Structure of table `0_recurrent_invoices` ###

DROP TABLE IF EXISTS `0_recurrent_invoices`;

CREATE TABLE `0_recurrent_invoices` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `description` varchar(60) NOT NULL default '',
  `order_no` int(11) unsigned NOT NULL,
  `debtor_no` int(11) unsigned default NULL,
  `group_no` smallint(6) unsigned default NULL,
  `days` int(11) NOT NULL default '0',
  `monthly` int(11) NOT NULL default '0',
  `begin` date NOT NULL default '0000-00-00',
  `end` date NOT NULL default '0000-00-00',
  `last_sent` date NOT NULL default '0000-00-00',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `description` (`description`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


### Data of table `0_recurrent_invoices` ###



### Structure of table `0_refs` ###

DROP TABLE IF EXISTS `0_refs`;

CREATE TABLE `0_refs` (
  `id` int(11) NOT NULL default '0',
  `type` int(11) NOT NULL default '0',
  `reference` varchar(100) NOT NULL default '',
  PRIMARY KEY  (`id`,`type`),
  KEY `Type_and_Reference` (`type`,`reference`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


### Data of table `0_refs` ###

### Structure of table `0_sales_order_details` ###

DROP TABLE IF EXISTS `0_sales_order_details`;

CREATE TABLE `0_sales_order_details` (
  `id` int(11) NOT NULL auto_increment,
  `order_no` int(11) NOT NULL default '0',
  `trans_type` smallint(6) NOT NULL default '30',
  `stk_code` varchar(20) NOT NULL default '',
  `description` tinytext,
  `qty_sent` double NOT NULL default '0',
  `unit_price` double NOT NULL default '0',
  `quantity` double NOT NULL default '0',
  `discount_percent` double NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `sorder` (`trans_type`,`order_no`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


### Data of table `0_sales_order_details` ###



### Structure of table `0_sales_orders` ###

DROP TABLE IF EXISTS `0_sales_orders`;

CREATE TABLE `0_sales_orders` (
  `order_no` int(11) NOT NULL,
  `trans_type` smallint(6) NOT NULL default '30',
  `version` tinyint(1) unsigned NOT NULL default '0',
  `type` tinyint(1) NOT NULL default '0',
  `debtor_no` int(11) NOT NULL default '0',
  `branch_code` int(11) NOT NULL default '0',
  `reference` varchar(100) NOT NULL default '',
  `customer_ref` tinytext NOT NULL,
  `comments` tinytext,
  `ord_date` date NOT NULL default '0000-00-00',
  `order_type` int(11) NOT NULL default '0',
  `ship_via` int(11) NOT NULL default '0',
  `delivery_address` tinytext NOT NULL,
  `contact_phone` varchar(30) default NULL,
  `contact_email` varchar(100) default NULL,
  `deliver_to` tinytext NOT NULL,
  `freight_cost` double NOT NULL default '0',
  `from_stk_loc` varchar(5) NOT NULL default '',
  `delivery_date` date NOT NULL default '0000-00-00',
  `payment_terms` int(11) default NULL,
  `total` double NOT NULL default '0',
  PRIMARY KEY  (`trans_type`,`order_no`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


### Data of table `0_sales_orders` ###



### Structure of table `0_sales_pos` ###

DROP TABLE IF EXISTS `0_sales_pos`;

CREATE TABLE `0_sales_pos` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `pos_name` varchar(30) NOT NULL,
  `cash_sale` tinyint(1) NOT NULL,
  `credit_sale` tinyint(1) NOT NULL,
  `pos_location` varchar(5) NOT NULL,
  `pos_account` smallint(6) unsigned NOT NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `pos_name` (`pos_name`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ;


### Data of table `0_sales_pos` ###

INSERT INTO `0_sales_pos` VALUES ('1', 'Default', '1', '1', 'DEF', '1', '0');


### Structure of table `0_sales_types` ###

DROP TABLE IF EXISTS `0_sales_types`;

CREATE TABLE `0_sales_types` (
  `id` int(11) NOT NULL auto_increment,
  `sales_type` char(50) NOT NULL default '',
  `tax_included` int(1) NOT NULL default '0',
  `factor` double NOT NULL default '1',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `sales_type` (`sales_type`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 ;


### Data of table `0_sales_types` ###

INSERT INTO `0_sales_types` VALUES ('1', 'Retail', '0', '1', '0');
INSERT INTO `0_sales_types` VALUES ('2', 'Wholesale', '0', '1', '0');


### Structure of table `0_salesman` ###

DROP TABLE IF EXISTS `0_salesman`;

CREATE TABLE `0_salesman` (
  `salesman_code` int(11) NOT NULL auto_increment,
  `salesman_name` char(60) NOT NULL default '',
  `salesman_phone` char(30) NOT NULL default '',
  `salesman_fax` char(30) NOT NULL default '',
  `salesman_email` varchar(100) NOT NULL default '',
  `provision` double NOT NULL default '0',
  `break_pt` double NOT NULL default '0',
  `provision2` double NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`salesman_code`),
  UNIQUE KEY `salesman_name` (`salesman_name`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ;


### Data of table `0_salesman` ###

INSERT INTO `0_salesman` VALUES ('1', 'Sales Person', '', '', '', '5', '1000', '4', '0');


### Structure of table `0_security_roles` ###

DROP TABLE IF EXISTS `0_security_roles`;

CREATE TABLE `0_security_roles` (
  `id` int(11) NOT NULL auto_increment,
  `role` varchar(30) NOT NULL,
  `description` varchar(50) default NULL,
  `sections` text,
  `areas` text,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `role` (`role`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 ;


### Data of table `0_security_roles` ###

INSERT INTO `0_security_roles` VALUES ('1', 'Przegl±danie', 'Przegladanie danych', '768;2816;3072;3328;5632;5888;8192;8448;10752;11008;13312;15872;16128', '257;258;259;260;513;514;515;516;517;518;519;520;521;522;523;524;525;526;773;774;2818;2822;3073;3075;3076;3077;3081;3329;3330;3331;3332;3333;3334;3335;5377;5633;5640;5889;5891;7937;7938;7939;7940;8193;8194;8450;8451;10497;10753;11009;11010;11012;13057;13313;13315;15617;15618;15619;15620;15621;15622;15623;15624;15628;15625;15626;15627;15629;15873;15882;16129;16130;16131;16132;25702;25703;25704;25956;25957', '0');
INSERT INTO `0_security_roles` VALUES ('2', 'Ksiêgowy', 'Ksiêgowo¶æ', '512;768;2816;3072;3328;5376;5632;5888;7936;8192;8448;10496;10752;11008;13312;15616;15872;16128', '257;258;259;260;513;519;520;521;522;523;524;525;769;771;772;773;774;2817;2818;2819;2820;2821;2822;2823;3073;3074;3075;3076;3077;3078;3079;3080;3081;3329;3330;3331;3332;3333;3334;3335;5377;5633;5634;5635;5636;5637;5638;5639;5640;5889;5891;7937;7938;7939;7940;8193;8194;8195;8196;8197;8449;8450;8451;10497;10753;10754;10755;10756;10757;11009;11010;11012;13057;13313;13314;13315;15617;15618;15619;15620;15621;15622;15623;15624;15625;15626;15873;15874;15875;15876;15877;15878;15879;15880;15881;15882;16129;16130;16131;16132;25702;25703;25704;25956;25957', '0');
INSERT INTO `0_security_roles` VALUES ('3', 'Administrator systemu', 'Pe³ne uprawnienia', '256;512;768;2816;3072;3328;5376;5632;5888;7936;8192;8448;10496;10752;11008;13056;13312;15616;15872;16128', '257;258;259;260;513;514;515;516;517;518;519;520;521;522;523;524;525;526;769;770;771;772;773;774;2817;2818;2819;2820;2821;2822;2823;3073;3074;3082;3075;3076;3077;3078;3079;3080;3081;3329;3330;3331;3332;3333;3334;3335;5377;5633;5634;5635;5636;5637;5641;5638;5639;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8195;8196;8197;8449;8450;8451;10497;10753;10754;10755;10756;10757;11009;11010;11011;11012;13057;13313;13314;13315;15617;15618;15619;15620;15621;15622;15623;15624;15628;15625;15626;15627;15629;15873;15874;15875;15876;15877;15878;15879;15880;15883;15881;15882;15884;16129;16130;16131;16132;25702;25703;25704;25956;25957', '0');

### Structure of table `0_shippers` ###

DROP TABLE IF EXISTS `0_shippers`;

CREATE TABLE `0_shippers` (
  `shipper_id` int(11) NOT NULL auto_increment,
  `shipper_name` varchar(60) NOT NULL default '',
  `phone` varchar(30) NOT NULL default '',
  `phone2` varchar(30) NOT NULL default '',
  `contact` tinytext NOT NULL,
  `address` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`shipper_id`),
  UNIQUE KEY `name` (`shipper_name`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ;


### Data of table `0_shippers` ###

INSERT INTO `0_shippers` VALUES ('1', 'Default', '', '', '', '', '0');


### Structure of table `0_sql_trail` ###

DROP TABLE IF EXISTS `0_sql_trail`;

CREATE TABLE `0_sql_trail` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `sql` text NOT NULL,
  `result` tinyint(1) NOT NULL,
  `msg` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;


### Data of table `0_sql_trail` ###



### Structure of table `0_stock_category` ###

DROP TABLE IF EXISTS `0_stock_category`;

CREATE TABLE `0_stock_category` (
  `category_id` int(11) NOT NULL auto_increment,
  `description` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  `dflt_tax_type` int(11) NOT NULL default '1',
  `dflt_units` varchar(20) NOT NULL default 'each',
  `dflt_mb_flag` char(1) NOT NULL default 'B',
  `dflt_sales_act` varchar(15) NOT NULL default '',
  `dflt_cogs_act` varchar(15) NOT NULL default '',
  `dflt_inventory_act` varchar(15) NOT NULL default '',
  `dflt_adjustment_act` varchar(15) NOT NULL default '',
  `dflt_assembly_act` varchar(15) NOT NULL default '',
  `dflt_dim1` int(11) default NULL,
  `dflt_dim2` int(11) default NULL,
  `dflt_no_sale` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`category_id`),
  UNIQUE KEY `description` (`description`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 ;


### Data of table `0_stock_category` ###

INSERT INTO `0_stock_category` VALUES ('1', 'Elementy', '0', '1', 'each', 'B', '333010000', '440020400', '331000000', '331000000', '331000000', '0', '0', '0');
INSERT INTO `0_stock_category` VALUES ('2', 'Op³aty', '0', '1', 'each', 'B', '333010000', '440020400', '331000000', '331000000', '331000000', '0', '0', '0');
INSERT INTO `0_stock_category` VALUES ('3', 'System', '0', '1', 'each', 'B', '333010000', '440020400', '331000000', '331000000', '331000000', '0', '0', '0');
INSERT INTO `0_stock_category` VALUES ('4', 'Us³ugi', '0', '1', 'each', 'B', '333010000', '440020400', '331000000', '331000000', '331000000', '0', '0', '0');


### Structure of table `0_stock_master` ###

DROP TABLE IF EXISTS `0_stock_master`;

CREATE TABLE `0_stock_master` (
  `stock_id` varchar(20) NOT NULL default '',
  `category_id` int(11) NOT NULL default '0',
  `tax_type_id` int(11) NOT NULL default '0',
  `description` varchar(200) NOT NULL default '',
  `long_description` tinytext NOT NULL,
  `units` varchar(20) NOT NULL default 'each',
  `mb_flag` char(1) NOT NULL default 'B',
  `sales_account` varchar(15) NOT NULL default '',
  `cogs_account` varchar(15) NOT NULL default '',
  `inventory_account` varchar(15) NOT NULL default '',
  `adjustment_account` varchar(15) NOT NULL default '',
  `assembly_account` varchar(15) NOT NULL default '',
  `dimension_id` int(11) default NULL,
  `dimension2_id` int(11) default NULL,
  `actual_cost` double NOT NULL default '0',
  `last_cost` double NOT NULL default '0',
  `material_cost` double NOT NULL default '0',
  `labour_cost` double NOT NULL default '0',
  `overhead_cost` double NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  `no_sale` tinyint(1) NOT NULL default '0',
  `editable` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`stock_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


### Data of table `0_stock_master` ###



### Structure of table `0_stock_moves` ###

DROP TABLE IF EXISTS `0_stock_moves`;

CREATE TABLE `0_stock_moves` (
  `trans_id` int(11) NOT NULL auto_increment,
  `trans_no` int(11) NOT NULL default '0',
  `stock_id` char(20) NOT NULL default '',
  `type` smallint(6) NOT NULL default '0',
  `loc_code` char(5) NOT NULL default '',
  `tran_date` date NOT NULL default '0000-00-00',
  `person_id` int(11) default NULL,
  `price` double NOT NULL default '0',
  `reference` char(40) NOT NULL default '',
  `qty` double NOT NULL default '1',
  `discount_percent` double NOT NULL default '0',
  `standard_cost` double NOT NULL default '0',
  `visible` tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (`trans_id`),
  KEY `type` (`type`,`trans_no`),
  KEY `Move` (`stock_id`,`loc_code`,`tran_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


### Data of table `0_stock_moves` ###



### Structure of table `0_supp_allocations` ###

DROP TABLE IF EXISTS `0_supp_allocations`;

CREATE TABLE `0_supp_allocations` (
  `id` int(11) NOT NULL auto_increment,
  `amt` double unsigned default NULL,
  `date_alloc` date NOT NULL default '0000-00-00',
  `trans_no_from` int(11) default NULL,
  `trans_type_from` int(11) default NULL,
  `trans_no_to` int(11) default NULL,
  `trans_type_to` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `From` (`trans_type_from`,`trans_no_from`),
  KEY `To` (`trans_type_to`,`trans_no_to`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


### Data of table `0_supp_allocations` ###

### Structure of table `0_supp_invoice_items` ###

DROP TABLE IF EXISTS `0_supp_invoice_items`;

CREATE TABLE `0_supp_invoice_items` (
  `id` int(11) NOT NULL auto_increment,
  `supp_trans_no` int(11) default NULL,
  `supp_trans_type` int(11) default NULL,
  `gl_code` varchar(15) NOT NULL default '',
  `grn_item_id` int(11) default NULL,
  `po_detail_item_id` int(11) default NULL,
  `stock_id` varchar(20) NOT NULL default '',
  `description` tinytext,
  `quantity` double NOT NULL default '0',
  `unit_price` double NOT NULL default '0',
  `unit_tax` double NOT NULL default '0',
  `memo_` tinytext,
  PRIMARY KEY  (`id`),
  KEY `Transaction` (`supp_trans_type`,`supp_trans_no`,`stock_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


### Data of table `0_supp_invoice_items` ###


### Structure of table `0_supp_trans` ###

DROP TABLE IF EXISTS `0_supp_trans`;

CREATE TABLE `0_supp_trans` (
  `trans_no` int(11) unsigned NOT NULL default '0',
  `type` smallint(6) unsigned NOT NULL default '0',
  `supplier_id` int(11) unsigned default NULL,
  `reference` tinytext NOT NULL,
  `supp_reference` varchar(60) NOT NULL default '',
  `tran_date` date NOT NULL default '0000-00-00',
  `due_date` date NOT NULL default '0000-00-00',
  `ov_amount` double NOT NULL default '0',
  `ov_discount` double NOT NULL default '0',
  `ov_gst` double NOT NULL default '0',
  `rate` double NOT NULL default '1',
  `alloc` double NOT NULL default '0',
  `tax_included` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`type`,`trans_no`),
  KEY `supplier_id` (`supplier_id`),
  KEY `SupplierID_2` (`supplier_id`,`supp_reference`),
  KEY `type` (`type`),
  KEY `tran_date` (`tran_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


### Data of table `0_supp_trans` ###



### Structure of table `0_suppliers` ###

DROP TABLE IF EXISTS `0_suppliers`;

CREATE TABLE `0_suppliers` (
  `supplier_id` int(11) NOT NULL auto_increment,
  `supp_name` varchar(60) NOT NULL default '',
  `address` tinytext NOT NULL,
  `supp_address` tinytext NOT NULL,
  `gst_no` varchar(25) NOT NULL default '',
  `contact` varchar(60) NOT NULL default '',
  `supp_account_no` varchar(40) NOT NULL default '',
  `website` varchar(100) NOT NULL default '',
  `bank_account` varchar(60) NOT NULL default '',
  `curr_code` char(3) default NULL,
  `payment_terms` int(11) default NULL,
  `tax_included` tinyint(1) NOT NULL default '0',
  `dimension_id` int(11) default '0',
  `dimension2_id` int(11) default '0',
  `tax_group_id` int(11) default NULL,
  `credit_limit` double NOT NULL default '0',
  `purchase_account` varchar(15) NOT NULL default '',
  `payable_account` varchar(15) NOT NULL default '',
  `payment_discount_account` varchar(15) NOT NULL default '',
  `notes` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  `supp_ref` varchar(30) NOT NULL,
  PRIMARY KEY  (`supplier_id`),
  KEY `supp_ref` (`supp_ref`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;


### Data of table `0_suppliers` ###



### Structure of table `0_sys_prefs` ###

DROP TABLE IF EXISTS `0_sys_prefs`;

CREATE TABLE `0_sys_prefs` (
  `name` varchar(35) NOT NULL default '',
  `category` varchar(30) default NULL,
  `type` varchar(20) NOT NULL default '',
  `length` smallint(6) default NULL,
  `value` tinytext,
  PRIMARY KEY  (`name`),
  KEY `category` (`category`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;


### Data of table `0_sys_prefs` ###

INSERT INTO `0_sys_prefs` VALUES ('coy_name', 'setup.company', 'varchar', '60', 'Training Co.');
INSERT INTO `0_sys_prefs` VALUES ('gst_no', 'setup.company', 'varchar', '25', NULL);
INSERT INTO `0_sys_prefs` VALUES ('coy_no', 'setup.company', 'varchar', '25', NULL);
INSERT INTO `0_sys_prefs` VALUES ('tax_prd', 'setup.company', 'int', '11', '1');
INSERT INTO `0_sys_prefs` VALUES ('tax_last', 'setup.company', 'int', '11', '1');
INSERT INTO `0_sys_prefs` VALUES ('postal_address', 'setup.company', 'tinytext', '0', 'N/A');
INSERT INTO `0_sys_prefs` VALUES ('phone', 'setup.company', 'varchar', '30', NULL);
INSERT INTO `0_sys_prefs` VALUES ('fax', 'setup.company', 'varchar', '30', NULL);
INSERT INTO `0_sys_prefs` VALUES ('email', 'setup.company', 'varchar', '100', NULL);
INSERT INTO `0_sys_prefs` VALUES ('coy_logo', 'setup.company', 'varchar', '100', NULL);
INSERT INTO `0_sys_prefs` VALUES ('domicile', 'setup.company', 'varchar', '55', NULL);
INSERT INTO `0_sys_prefs` VALUES ('curr_default', 'setup.company', 'char', '3', 'PLN');
INSERT INTO `0_sys_prefs` VALUES ('use_dimension', 'setup.company', 'tinyint', '1', '1');
INSERT INTO `0_sys_prefs` VALUES ('f_year', 'setup.company', 'int', '11', '1');
INSERT INTO `0_sys_prefs` VALUES ('no_item_list', 'setup.company', 'tinyint', '1', '0');
INSERT INTO `0_sys_prefs` VALUES ('no_customer_list', 'setup.company', 'tinyint', '1', '0');
INSERT INTO `0_sys_prefs` VALUES ('no_supplier_list', 'setup.company', 'tinyint', '1', '0');
INSERT INTO `0_sys_prefs` VALUES ('base_sales', 'setup.company', 'int', '11', '-1');
INSERT INTO `0_sys_prefs` VALUES ('time_zone', 'setup.company', 'tinyint', '1', '0');
INSERT INTO `0_sys_prefs` VALUES ('add_pct', 'setup.company', 'int', '5', '-1');
INSERT INTO `0_sys_prefs` VALUES ('round_to', 'setup.company', 'int', '5', '1');
INSERT INTO `0_sys_prefs` VALUES ('login_tout', 'setup.company', 'smallint', '6', '600');
INSERT INTO `0_sys_prefs` VALUES ('past_due_days', 'glsetup.general', 'int', '11', '30');
INSERT INTO `0_sys_prefs` VALUES ('profit_loss_year_act', 'glsetup.general', 'varchar', '15', '9990');
INSERT INTO `0_sys_prefs` VALUES ('retained_earnings_act', 'glsetup.general', 'varchar', '15', '2050');
INSERT INTO `0_sys_prefs` VALUES ('bank_charge_act', 'glsetup.general', 'varchar', '15', '1430');
INSERT INTO `0_sys_prefs` VALUES ('exchange_diff_act', 'glsetup.general', 'varchar', '15', '333010000');
INSERT INTO `0_sys_prefs` VALUES ('default_credit_limit', 'glsetup.customer', 'int', '11', '1000');
INSERT INTO `0_sys_prefs` VALUES ('accumulate_shipping', 'glsetup.customer', 'tinyint', '1', '0');
INSERT INTO `0_sys_prefs` VALUES ('legal_text', 'glsetup.customer', 'tinytext', '0', NULL);
INSERT INTO `0_sys_prefs` VALUES ('freight_act', 'glsetup.customer', 'varchar', '15', '440020400');
INSERT INTO `0_sys_prefs` VALUES ('debtors_act', 'glsetup.sales', 'varchar', '15', '006000000');
INSERT INTO `0_sys_prefs` VALUES ('default_sales_act', 'glsetup.sales', 'varchar', '15', '333010000');
INSERT INTO `0_sys_prefs` VALUES ('default_sales_discount_act', 'glsetup.sales', 'varchar', '15', '333010000');
INSERT INTO `0_sys_prefs` VALUES ('default_prompt_payment_act', 'glsetup.sales', 'varchar', '15', '333010000');
INSERT INTO `0_sys_prefs` VALUES ('default_delivery_required', 'glsetup.sales', 'smallint', '6', '1');
INSERT INTO `0_sys_prefs` VALUES ('default_dim_required', 'glsetup.dims', 'int', '11', '20');
INSERT INTO `0_sys_prefs` VALUES ('pyt_discount_act', 'glsetup.purchase', 'varchar', '15', '440020400');
INSERT INTO `0_sys_prefs` VALUES ('creditors_act', 'glsetup.purchase', 'varchar', '15', '001000000');
INSERT INTO `0_sys_prefs` VALUES ('po_over_receive', 'glsetup.purchase', 'int', '11', '10');
INSERT INTO `0_sys_prefs` VALUES ('po_over_charge', 'glsetup.purchase', 'int', '11', '10');
INSERT INTO `0_sys_prefs` VALUES ('allow_negative_stock', 'glsetup.inventory', 'tinyint', '1', '0');
INSERT INTO `0_sys_prefs` VALUES ('default_inventory_act', 'glsetup.items', 'varchar', '15', '331000000');
INSERT INTO `0_sys_prefs` VALUES ('default_cogs_act', 'glsetup.items', 'varchar', '15', '440020400');
INSERT INTO `0_sys_prefs` VALUES ('default_adj_act', 'glsetup.items', 'varchar', '15', '331000000');
INSERT INTO `0_sys_prefs` VALUES ('default_inv_sales_act', 'glsetup.items', 'varchar', '15', '333010000');
INSERT INTO `0_sys_prefs` VALUES ('default_assembly_act', 'glsetup.items', 'varchar', '15', '331000000');
INSERT INTO `0_sys_prefs` VALUES ('default_workorder_required', 'glsetup.manuf', 'int', '11', '20');
INSERT INTO `0_sys_prefs` VALUES ('version_id', 'system', 'varchar', '11', '2.3rc');
INSERT INTO `0_sys_prefs` VALUES ('auto_curr_reval', 'setup.company', 'smallint', '6', '1');


### Structure of table `0_sys_types` ###

DROP TABLE IF EXISTS `0_sys_types`;

CREATE TABLE `0_sys_types` (
  `type_id` smallint(6) NOT NULL default '0',
  `type_no` int(11) NOT NULL default '1',
  `next_reference` varchar(100) NOT NULL default '',
  PRIMARY KEY  (`type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


### Data of table `0_sys_types` ###

INSERT INTO `0_sys_types` VALUES ('0', '17', '1');
INSERT INTO `0_sys_types` VALUES ('1', '7', '1');
INSERT INTO `0_sys_types` VALUES ('2', '4', '1');
INSERT INTO `0_sys_types` VALUES ('4', '3', '1');
INSERT INTO `0_sys_types` VALUES ('10', '16', '1');
INSERT INTO `0_sys_types` VALUES ('11', '2', '1');
INSERT INTO `0_sys_types` VALUES ('12', '6', '1');
INSERT INTO `0_sys_types` VALUES ('13', '1', '1');
INSERT INTO `0_sys_types` VALUES ('16', '2', '1');
INSERT INTO `0_sys_types` VALUES ('17', '2', '1');
INSERT INTO `0_sys_types` VALUES ('18', '1', '1');
INSERT INTO `0_sys_types` VALUES ('20', '6', '1');
INSERT INTO `0_sys_types` VALUES ('21', '1', '1');
INSERT INTO `0_sys_types` VALUES ('22', '3', '1');
INSERT INTO `0_sys_types` VALUES ('25', '1', '1');
INSERT INTO `0_sys_types` VALUES ('26', '1', '1');
INSERT INTO `0_sys_types` VALUES ('28', '1', '1');
INSERT INTO `0_sys_types` VALUES ('29', '1', '1');
INSERT INTO `0_sys_types` VALUES ('30', '0', '1');
INSERT INTO `0_sys_types` VALUES ('32', '0', '1');
INSERT INTO `0_sys_types` VALUES ('35', '1', '1');
INSERT INTO `0_sys_types` VALUES ('40', '1', '1');


### Structure of table `0_tag_associations` ###

DROP TABLE IF EXISTS `0_tag_associations`;

CREATE TABLE `0_tag_associations` (
  `record_id` varchar(15) NOT NULL,
  `tag_id` int(11) NOT NULL,
  UNIQUE KEY `record_id` (`record_id`,`tag_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;


### Data of table `0_tag_associations` ###



### Structure of table `0_tags` ###

DROP TABLE IF EXISTS `0_tags`;

CREATE TABLE `0_tags` (
  `id` int(11) NOT NULL auto_increment,
  `type` smallint(6) NOT NULL,
  `name` varchar(30) NOT NULL,
  `description` varchar(60) default NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `type` (`type`,`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;


### Data of table `0_tags` ###



### Structure of table `0_tax_group_items` ###

DROP TABLE IF EXISTS `0_tax_group_items`;

CREATE TABLE `0_tax_group_items` (
  `tax_group_id` int(11) NOT NULL default '0',
  `tax_type_id` int(11) NOT NULL default '0',
  `rate` double NOT NULL default '0',
  PRIMARY KEY  (`tax_group_id`,`tax_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


### Data of table `0_tax_group_items` ###

INSERT INTO `0_tax_group_items` VALUES ('1', '1', '22');
INSERT INTO `0_tax_group_items` VALUES ('1', '2', '7');
INSERT INTO `0_tax_group_items` VALUES ('1', '3', '0');
INSERT INTO `0_tax_group_items` VALUES ('2', '3', '0');
INSERT INTO `0_tax_group_items` VALUES ('3', '1', '22');


### Structure of table `0_tax_groups` ###

DROP TABLE IF EXISTS `0_tax_groups`;

CREATE TABLE `0_tax_groups` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(60) NOT NULL default '',
  `tax_shipping` tinyint(1) NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 ;


### Data of table `0_tax_groups` ###

INSERT INTO `0_tax_groups` VALUES ('1', 'Sprzeda¿ krajowa', '0', '0');
INSERT INTO `0_tax_groups` VALUES ('2', 'Eksport', '0', '0');
INSERT INTO `0_tax_groups` VALUES ('3', 'Us³ugi transportowe', '1', '0');


### Structure of table `0_tax_types` ###

DROP TABLE IF EXISTS `0_tax_types`;

CREATE TABLE `0_tax_types` (
  `id` int(11) NOT NULL auto_increment,
  `rate` double NOT NULL default '0',
  `sales_gl_code` varchar(15) NOT NULL default '',
  `purchasing_gl_code` varchar(15) NOT NULL default '',
  `name` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`,`rate`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 ;


### Data of table `0_tax_types` ###

INSERT INTO `0_tax_types` VALUES ('1', '22', '223020100', '223030100', 'VAT', '0');
INSERT INTO `0_tax_types` VALUES ('2', '7', '223020200', '223030200', 'VAT', '0');
INSERT INTO `0_tax_types` VALUES ('3', '0', '223020300', '223030300', 'VAT', '0');


### Structure of table `0_trans_tax_details` ###

DROP TABLE IF EXISTS `0_trans_tax_details`;

CREATE TABLE `0_trans_tax_details` (
  `id` int(11) NOT NULL auto_increment,
  `trans_type` smallint(6) default NULL,
  `trans_no` int(11) default NULL,
  `tran_date` date NOT NULL,
  `tax_type_id` int(11) NOT NULL default '0',
  `rate` double NOT NULL default '0',
  `ex_rate` double NOT NULL default '1',
  `included_in_price` tinyint(1) NOT NULL default '0',
  `net_amount` double NOT NULL default '0',
  `amount` double NOT NULL default '0',
  `memo` tinytext,
  PRIMARY KEY  (`id`),
  KEY `Type_and_Number` (`trans_type`,`trans_no`),
  KEY `tran_date` (`tran_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


### Data of table `0_trans_tax_details` ###



### Structure of table `0_useronline` ###

DROP TABLE IF EXISTS `0_useronline`;

CREATE TABLE `0_useronline` (
  `id` int(11) NOT NULL auto_increment,
  `timestamp` int(15) NOT NULL default '0',
  `ip` varchar(40) NOT NULL default '',
  `file` varchar(100) NOT NULL default '',
  PRIMARY KEY  (`id`),
  KEY `timestamp` (`timestamp`),
  KEY `ip` (`ip`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;


### Data of table `0_useronline` ###



### Structure of table `0_users` ###

DROP TABLE IF EXISTS `0_users`;

CREATE TABLE `0_users` (
  `id` smallint(6) NOT NULL auto_increment,
  `user_id` varchar(60) NOT NULL default '',
  `password` varchar(100) NOT NULL default '',
  `real_name` varchar(100) NOT NULL default '',
  `role_id` int(11) NOT NULL default '1',
  `phone` varchar(30) NOT NULL default '',
  `email` varchar(100) default NULL,
  `language` varchar(20) default NULL,
  `date_format` tinyint(1) NOT NULL default '0',
  `date_sep` tinyint(1) NOT NULL default '0',
  `tho_sep` tinyint(1) NOT NULL default '0',
  `dec_sep` tinyint(1) NOT NULL default '0',
  `theme` varchar(20) NOT NULL default 'default',
  `page_size` varchar(20) NOT NULL default 'A4',
  `prices_dec` smallint(6) NOT NULL default '2',
  `qty_dec` smallint(6) NOT NULL default '2',
  `rates_dec` smallint(6) NOT NULL default '4',
  `percent_dec` smallint(6) NOT NULL default '1',
  `show_gl` tinyint(1) NOT NULL default '1',
  `show_codes` tinyint(1) NOT NULL default '0',
  `show_hints` tinyint(1) NOT NULL default '0',
  `last_visit_date` datetime default NULL,
  `query_size` tinyint(1) default '10',
  `graphic_links` tinyint(1) default '1',
  `pos` smallint(6) default '1',
  `print_profile` varchar(30) NOT NULL default '1',
  `rep_popup` tinyint(1) default '1',
  `sticky_doc_date` tinyint(1) default '0',
  `startup_tab` varchar(20) NOT NULL default 'orders',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `user_id` (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ;


### Data of table `0_users` ###

INSERT INTO `0_users` VALUES ('1', 'admin', '5f4dcc3b5aa765d61d8327deb882cf99', 'Administrator', '3', '', 'adm@adm.com', 'pl_PL', '0', '0', '0', '0', 'default', 'Letter', '2', '2', '4', '1', '1', '0', '0', '2010-08-13 11:11:28', '10', '1', '1', '1', '1', '0', 'orders', '0');


### Structure of table `0_voided` ###

DROP TABLE IF EXISTS `0_voided`;

CREATE TABLE `0_voided` (
  `type` int(11) NOT NULL default '0',
  `id` int(11) NOT NULL default '0',
  `date_` date NOT NULL default '0000-00-00',
  `memo_` tinytext NOT NULL,
  UNIQUE KEY `id` (`type`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


### Data of table `0_voided` ###



### Structure of table `0_wo_issue_items` ###

DROP TABLE IF EXISTS `0_wo_issue_items`;

CREATE TABLE `0_wo_issue_items` (
  `id` int(11) NOT NULL auto_increment,
  `stock_id` varchar(40) default NULL,
  `issue_id` int(11) default NULL,
  `qty_issued` double default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


### Data of table `0_wo_issue_items` ###



### Structure of table `0_wo_issues` ###

DROP TABLE IF EXISTS `0_wo_issues`;

CREATE TABLE `0_wo_issues` (
  `issue_no` int(11) NOT NULL auto_increment,
  `workorder_id` int(11) NOT NULL default '0',
  `reference` varchar(100) default NULL,
  `issue_date` date default NULL,
  `loc_code` varchar(5) default NULL,
  `workcentre_id` int(11) default NULL,
  PRIMARY KEY  (`issue_no`),
  KEY `workorder_id` (`workorder_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


### Data of table `0_wo_issues` ###



### Structure of table `0_wo_manufacture` ###

DROP TABLE IF EXISTS `0_wo_manufacture`;

CREATE TABLE `0_wo_manufacture` (
  `id` int(11) NOT NULL auto_increment,
  `reference` varchar(100) default NULL,
  `workorder_id` int(11) NOT NULL default '0',
  `quantity` double NOT NULL default '0',
  `date_` date NOT NULL default '0000-00-00',
  PRIMARY KEY  (`id`),
  KEY `workorder_id` (`workorder_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


### Data of table `0_wo_manufacture` ###



### Structure of table `0_wo_requirements` ###

DROP TABLE IF EXISTS `0_wo_requirements`;

CREATE TABLE `0_wo_requirements` (
  `id` int(11) NOT NULL auto_increment,
  `workorder_id` int(11) NOT NULL default '0',
  `stock_id` char(20) NOT NULL default '',
  `workcentre` int(11) NOT NULL default '0',
  `units_req` double NOT NULL default '1',
  `std_cost` double NOT NULL default '0',
  `loc_code` char(5) NOT NULL default '',
  `units_issued` double NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `workorder_id` (`workorder_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


### Data of table `0_wo_requirements` ###



### Structure of table `0_workcentres` ###

DROP TABLE IF EXISTS `0_workcentres`;

CREATE TABLE `0_workcentres` (
  `id` int(11) NOT NULL auto_increment,
  `name` char(40) NOT NULL default '',
  `description` char(50) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;


### Data of table `0_workcentres` ###



### Structure of table `0_workorders` ###

DROP TABLE IF EXISTS `0_workorders`;

CREATE TABLE `0_workorders` (
  `id` int(11) NOT NULL auto_increment,
  `wo_ref` varchar(60) NOT NULL default '',
  `loc_code` varchar(5) NOT NULL default '',
  `units_reqd` double NOT NULL default '1',
  `stock_id` varchar(20) NOT NULL default '',
  `date_` date NOT NULL default '0000-00-00',
  `type` tinyint(4) NOT NULL default '0',
  `required_by` date NOT NULL default '0000-00-00',
  `released_date` date NOT NULL default '0000-00-00',
  `units_issued` double NOT NULL default '0',
  `closed` tinyint(1) NOT NULL default '0',
  `released` tinyint(1) NOT NULL default '0',
  `additional_costs` double NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `wo_ref` (`wo_ref`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


### Data of table `0_workorders` ###

