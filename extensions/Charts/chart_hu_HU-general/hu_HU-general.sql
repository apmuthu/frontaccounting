# MySQL dump of database 'faupgrade' on host 'localhost'
# Backup Date and Time: 2010-08-06 13:56
# Built by FrontAccounting 2.3RC1
# http://frontaccounting.com
# Company: Company name
# User: 



### Structure of table `0_areas` ###

DROP TABLE IF EXISTS `0_areas`;

CREATE TABLE `0_areas` (
  `area_code` int(11) NOT NULL auto_increment,
  `description` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`area_code`),
  UNIQUE KEY `description` (`description`)
) ENGINE=MyISAM AUTO_INCREMENT=2  ;


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
) ENGINE=MyISAM  ;


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
) ENGINE=InnoDB  ;


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
) ENGINE=MyISAM AUTO_INCREMENT=3  ;


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
) ENGINE=InnoDB  ;


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
) ENGINE=MyISAM  ;


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
) ENGINE=InnoDB  ;


### Data of table `0_budget_trans` ###



### Structure of table `0_chart_class` ###

DROP TABLE IF EXISTS `0_chart_class`;

CREATE TABLE `0_chart_class` (
  `cid` varchar(3) NOT NULL,
  `class_name` varchar(60) NOT NULL default '',
  `ctype` tinyint(1) NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`cid`)
) ENGINE=MyISAM  ;


### Data of table `0_chart_class` ###

INSERT INTO `0_chart_class` VALUES ('1', 'Assets', '1', '0');
INSERT INTO `0_chart_class` VALUES ('2', 'Liabilities', '2', '0');
INSERT INTO `0_chart_class` VALUES ('3', 'Income', '4', '0');
INSERT INTO `0_chart_class` VALUES ('4', 'Costs', '6', '0');


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
) ENGINE=MyISAM  ;


### Data of table `0_chart_master` ###

INSERT INTO `0_chart_master` VALUES ('1111', '', 'Alapítás, átszervezés aktivált értéke', '11', '0');
INSERT INTO `0_chart_master` VALUES ('1131', '', 'Vagyoni értékű jogok', '11', '0');
INSERT INTO `0_chart_master` VALUES ('1141', '', 'Szellemi termékek', '114', '0');
INSERT INTO `0_chart_master` VALUES ('1171', '', 'Immateriális javak értékhelyesbítése', '117', '0');
INSERT INTO `0_chart_master` VALUES ('1181', '', 'Immateriális javak terven felüli értékcsökkenése', '118', '0');
INSERT INTO `0_chart_master` VALUES ('1191', '', 'Alapitás, átszervezés elszámolt értékcsökkenése', '119', '0');
INSERT INTO `0_chart_master` VALUES ('1193', '', 'Vagyoni értékű jogok elszámolt értékcsökkenése', '119', '0');
INSERT INTO `0_chart_master` VALUES ('1194', '', 'Szellemi termékek elszámolt értékcsökkenése', '119', '0');
INSERT INTO `0_chart_master` VALUES ('1311', '', 'Termelő gépek, berendezések', '131', '0');
INSERT INTO `0_chart_master` VALUES ('1321', '', 'Járművek', '132', '0');
INSERT INTO `0_chart_master` VALUES ('1371', '', 'Műszaki gépek, berendezések, járművek értékhelyesbít', '137', '0');
INSERT INTO `0_chart_master` VALUES ('1381', '', '', '138', '0');
INSERT INTO `0_chart_master` VALUES ('1391', '', 'Termelő gépek, berendezések elszámolt értékcsökkenés', '139', '0');
INSERT INTO `0_chart_master` VALUES ('1392', '', 'Járművek értékcsökkenése', '139', '0');
INSERT INTO `0_chart_master` VALUES ('1411', '', 'Egyéb gép, berendezése, szerszám', '141', '0');
INSERT INTO `0_chart_master` VALUES ('1421', '', 'Egyéb járművek', '142', '0');
INSERT INTO `0_chart_master` VALUES ('1431', '', 'Irodai, igazgatási berendezés, felszerelés', '143', '0');
INSERT INTO `0_chart_master` VALUES ('1451', '', 'Kisértékű gép, berendezés, felszerelés', '145', '0');
INSERT INTO `0_chart_master` VALUES ('1452', '', 'Kisértékű irodai, igazgatási berendezés, felszerelés', '145', '0');
INSERT INTO `0_chart_master` VALUES ('1471', '', 'Egyéb gép, berendezés, szerszám értékhelyesbítése', '147', '0');
INSERT INTO `0_chart_master` VALUES ('1472', '', 'Egyéb járművek értékhelyesbítése', '147', '0');
INSERT INTO `0_chart_master` VALUES ('1473', '', 'Irodai, igazgatási berendezés, felszerelés értékhelyesb', '147', '0');
INSERT INTO `0_chart_master` VALUES ('1481', '', 'Egyéb gép, berendezés, felszerelés terven felüli érté', '148', '0');
INSERT INTO `0_chart_master` VALUES ('1482', '', 'Egyéb járművek terven felüli értékcsökkenése', '148', '0');
INSERT INTO `0_chart_master` VALUES ('1483', '', 'Irodai, igazgatási berendezések terven felüli értékcsö', '148', '0');
INSERT INTO `0_chart_master` VALUES ('1491', '', 'Egyéb gép, berendezés, szerszám elszámolt értékcsökk', '149', '0');
INSERT INTO `0_chart_master` VALUES ('1492', '', 'Egyéb járművek elszámolt értékcsökkenése', '149', '0');
INSERT INTO `0_chart_master` VALUES ('1493', '', 'Irodai, igazgatási berendezés, felszerelés elszámolt ér', '149', '0');
INSERT INTO `0_chart_master` VALUES ('1495', '', 'Kisértékű tárgyi eszközök értékcsökkenése', '149', '0');
INSERT INTO `0_chart_master` VALUES ('1611', '', 'Befejezetlen beruházás', '161', '0');
INSERT INTO `0_chart_master` VALUES ('2690', '', 'Uton levo keszlet', '26', '0');
INSERT INTO `0_chart_master` VALUES ('2610', '', 'Áruk beszerzési áron', '26', '0');
INSERT INTO `0_chart_master` VALUES ('3111', '', 'Belföldi vevők', '311', '0');
INSERT INTO `0_chart_master` VALUES ('3150', '', 'Belföldi követelések értékvesztése és visszairása', '311', '0');
INSERT INTO `0_chart_master` VALUES ('3161', '', 'Külföldi vevők', '316', '0');
INSERT INTO `0_chart_master` VALUES ('3190', '', 'Külföldi követelések értékvesztése és visszairása', '316', '0');
INSERT INTO `0_chart_master` VALUES ('3211', '', 'Követelések anyavállalattal szemben', '321', '0');
INSERT INTO `0_chart_master` VALUES ('3251', '', 'Jegyzett, de még be nem fizetett tőke', '325', '0');
INSERT INTO `0_chart_master` VALUES ('3291', '', 'Követelések értékvesztése ', '329', '0');
INSERT INTO `0_chart_master` VALUES ('3311', '', 'Követelések egyéb részesedési viszonyban lévő vállal', '331', '0');
INSERT INTO `0_chart_master` VALUES ('3321', '', 'Jegyzett, de még be nem fizetett tőke', '332', '0');
INSERT INTO `0_chart_master` VALUES ('3391', '', 'Egyéb részesedési viszonyban lévő vállakozással szemb', '339', '0');
INSERT INTO `0_chart_master` VALUES ('3410', '', 'Belföldi váltókövetelések', '34', '0');
INSERT INTO `0_chart_master` VALUES ('3460', '', 'Külföldi váltókövetelések', '34', '0');
INSERT INTO `0_chart_master` VALUES ('3510', '', 'Immateriális javakra adott előleg', '35', '0');
INSERT INTO `0_chart_master` VALUES ('3520', '', 'Beruházásokra adott előleg', '35', '0');
INSERT INTO `0_chart_master` VALUES ('3530', '', 'Készletekre adott előleg', '35', '0');
INSERT INTO `0_chart_master` VALUES ('3540', '', 'Osztalék előleg', '35', '0');
INSERT INTO `0_chart_master` VALUES ('3550', '', 'VPOP ÁFA elszámolási számla', '35', '0');
INSERT INTO `0_chart_master` VALUES ('3560', '', 'Egyéb előlegek', '35', '0');
INSERT INTO `0_chart_master` VALUES ('3610', '', 'Munkavállalókkal szembeni követelés', '36', '0');
INSERT INTO `0_chart_master` VALUES ('3620', '', 'Költségvetési kiutálási igények', '36', '0');
INSERT INTO `0_chart_master` VALUES ('3630', '', 'Költségvetési kiutalási igények teljesitése', '36', '0');
INSERT INTO `0_chart_master` VALUES ('3640', '', 'Vevőtől kapott előleg ÁFÁ-ja', '36', '0');
INSERT INTO `0_chart_master` VALUES ('3661', '', 'Rövid lejáratra adott pénzkölcsön', '366', '0');
INSERT INTO `0_chart_master` VALUES ('3662', '', 'Rövid lejáratú betétek', '366', '0');
INSERT INTO `0_chart_master` VALUES ('3680', '', 'Egyéb követelések', '366', '0');
INSERT INTO `0_chart_master` VALUES ('3690', '', 'Egyéb követelések értékvesztése és visszairása', '366', '0');
INSERT INTO `0_chart_master` VALUES ('3710', '', 'Részesedés kapcsolt vállakozásban', '37', '0');
INSERT INTO `0_chart_master` VALUES ('3720', '', 'Egyéb részesedés', '37', '0');
INSERT INTO `0_chart_master` VALUES ('3790', '', 'Értékpapirok értékvesztése és visszairása', '37', '0');
INSERT INTO `0_chart_master` VALUES ('3811', '', 'Főpénztár', '381', '0');
INSERT INTO `0_chart_master` VALUES ('3822', '', 'USD valutapénztár', '382', '0');
INSERT INTO `0_chart_master` VALUES ('3821', '', 'EURO valutapénztár', '382', '0');
INSERT INTO `0_chart_master` VALUES ('3841', '', 'Bankszámla (Ft)', '384', '0');
INSERT INTO `0_chart_master` VALUES ('3861', '', 'Bankszámla (EUR)', '386', '0');
INSERT INTO `0_chart_master` VALUES ('3862', '', 'Deviza betétszámla USD', '386', '0');
INSERT INTO `0_chart_master` VALUES ('3893', '', 'Átvezetés Bank (HUF) - Bank (EUR)', '389', '0');
INSERT INTO `0_chart_master` VALUES ('3891', '', 'Átvezetés Bank (HUF) - Pénztár (HUF)', '389', '0');
INSERT INTO `0_chart_master` VALUES ('3892', '', 'Átvezetés Bank (EUR) - Pénztár (EUR)', '389', '0');
INSERT INTO `0_chart_master` VALUES ('3894', '', 'Átvezetés Pénztár (HUF) - Pénztár (EUR)', '389', '0');
INSERT INTO `0_chart_master` VALUES ('3895', '', 'Átvezetés Bank (HUF) - Bank (USD)', '389', '0');
INSERT INTO `0_chart_master` VALUES ('3896', '', 'Bankkártya átvezetés', '389', '0');
INSERT INTO `0_chart_master` VALUES ('3920', '', 'Költségek ráforditások aktiv időbeli elhatárolása', '39', '0');
INSERT INTO `0_chart_master` VALUES ('3910', '', 'Bevételek aktiv időbeli elhatárolása', '39', '0');
INSERT INTO `0_chart_master` VALUES ('3930', '', 'Halasztott ráforditások', '39', '0');
INSERT INTO `0_chart_master` VALUES ('4110', '', 'Jegyzett tőke', '41', '0');
INSERT INTO `0_chart_master` VALUES ('4120', '', 'Tőketartalék', '41', '0');
INSERT INTO `0_chart_master` VALUES ('4130', '', 'Eredménytartalék', '41', '0');
INSERT INTO `0_chart_master` VALUES ('4140', '', 'Lekötött tartalék', '41', '0');
INSERT INTO `0_chart_master` VALUES ('4170', '', 'Értékelési tartalék', '41', '0');
INSERT INTO `0_chart_master` VALUES ('4190', '', 'Mérleg szerinti eredmény', '41', '0');
INSERT INTO `0_chart_master` VALUES ('4210', '', 'Céltartalékok várható kötelezettségekre', '42', '0');
INSERT INTO `0_chart_master` VALUES ('4220', '', 'Céltartalékok a jövőbeni költségekre', '42', '0');
INSERT INTO `0_chart_master` VALUES ('4230', '', 'Egyéb céltartalékok', '42', '0');
INSERT INTO `0_chart_master` VALUES ('4421', '', 'Hosszú lejáratra kapott kölcsönök', '442', '0');
INSERT INTO `0_chart_master` VALUES ('4431', '', 'Beruházási és fejlesztési hitelek', '443', '0');
INSERT INTO `0_chart_master` VALUES ('4441', '', 'Egyéb hosszú lejáratú hitel', '444', '0');
INSERT INTO `0_chart_master` VALUES ('4461', '', 'Tartós kötelezettség', '446', '0');
INSERT INTO `0_chart_master` VALUES ('4471', '', 'Tartós kötelezettség egyéb vállakozással szemben', '447', '0');
INSERT INTO `0_chart_master` VALUES ('4491', '', 'Egyéb hosszú lejáratú kötelezettség', '449', '0');
INSERT INTO `0_chart_master` VALUES ('4511', '', 'Vevőktől kapott előleg', '451', '0');
INSERT INTO `0_chart_master` VALUES ('4541', '', 'Belföldi szállítók', '454', '0');
INSERT INTO `0_chart_master` VALUES ('4542', '', 'Külföldi szállítók', '454', '0');
INSERT INTO `0_chart_master` VALUES ('4551', '', 'Pénzügyi lízing (éven belüli)', '455', '0');
INSERT INTO `0_chart_master` VALUES ('4561', '', 'Rövid lejáratú kötelezettség', '456', '0');
INSERT INTO `0_chart_master` VALUES ('4571', '', 'Rövid lejáratú kötelezettség egyéb', '457', '0');
INSERT INTO `0_chart_master` VALUES ('4591', '', 'Egyéb rövid lejáratú kötelezettség', '459', '0');
INSERT INTO `0_chart_master` VALUES ('4611', '', 'Társasági adó', '461', '0');
INSERT INTO `0_chart_master` VALUES ('4619', '', 'Társasági adó megfizetése', '461', '0');
INSERT INTO `0_chart_master` VALUES ('4621', '', 'Munkaviszonyból származó SZJA', '462', '0');
INSERT INTO `0_chart_master` VALUES ('4629', '', 'SZJA befizetés', '462', '0');
INSERT INTO `0_chart_master` VALUES ('4631', '', 'Nyugdíjbiztosítás', '463', '0');
INSERT INTO `0_chart_master` VALUES ('4632', '', 'Egészségbiztosítás', '463', '0');
INSERT INTO `0_chart_master` VALUES ('4633', '', 'Munkaadói járulék', '463', '0');
INSERT INTO `0_chart_master` VALUES ('4634', '', 'Munkavállalói járulék', '463', '0');
INSERT INTO `0_chart_master` VALUES ('4635', '', 'Szakképzési hozzájárulás', '463', '0');
INSERT INTO `0_chart_master` VALUES ('4636', '', 'Rehabilitációs hozzájárulás', '463', '0');
INSERT INTO `0_chart_master` VALUES ('4637', '', 'EHO', '463', '0');
INSERT INTO `0_chart_master` VALUES ('4638', '', 'Önellenörzési, késedelmi pótlék', '463', '0');
INSERT INTO `0_chart_master` VALUES ('4641', '', 'Nyugdíjbiztosítás teljesitése', '464', '0');
INSERT INTO `0_chart_master` VALUES ('4642', '', 'EEgészségbiztosítás teljesitése', '464', '0');
INSERT INTO `0_chart_master` VALUES ('4643', '', 'Munkaadói járulék teljesitése', '464', '0');
INSERT INTO `0_chart_master` VALUES ('4644', '', 'Munkavállalói járulék teljesitése', '464', '0');
INSERT INTO `0_chart_master` VALUES ('4645', '', 'Szakképzési hozzájárulás teljesitése', '464', '0');
INSERT INTO `0_chart_master` VALUES ('4646', '', 'Rehabilitációs hozzájárulás teljesitése', '464', '0');
INSERT INTO `0_chart_master` VALUES ('4647', '', 'EHO teljesitése', '464', '0');
INSERT INTO `0_chart_master` VALUES ('4648', '', 'Önellenörzési, késedelmi pótlék teljesitése', '464', '0');
INSERT INTO `0_chart_master` VALUES ('4651', '', 'VPOP elszámolási számla', '465', '0');
INSERT INTO `0_chart_master` VALUES ('4661', '', 'Előzetesen felszámítottt ÁFA 20%', '466', '0');
INSERT INTO `0_chart_master` VALUES ('4662', '', 'Előzetesen felszámítottt ÁFA 5%', '466', '0');
INSERT INTO `0_chart_master` VALUES ('4663', '', 'Előzetesen felszámítottt ÁFA 0%', '466', '0');
INSERT INTO `0_chart_master` VALUES ('4664', '', 'Előzetesen felszámítottt ÁFA adómentes', '466', '0');
INSERT INTO `0_chart_master` VALUES ('4671', '', 'Fizetendő ÁFA 20%', '467', '0');
INSERT INTO `0_chart_master` VALUES ('4672', '', 'Fizetendő ÁFA 5%', '467', '0');
INSERT INTO `0_chart_master` VALUES ('4673', '', 'Fizetendő ÁFA 0%', '467', '0');
INSERT INTO `0_chart_master` VALUES ('4674', '', 'Fizetendő ÁFA adómentes', '467', '0');
INSERT INTO `0_chart_master` VALUES ('4680', '', 'ÁFA elszámolási számla', '467', '0');
INSERT INTO `0_chart_master` VALUES ('4691', '', 'Iparűzési adó', '469', '0');
INSERT INTO `0_chart_master` VALUES ('4692', '', 'Gépjárműadó', '469', '0');
INSERT INTO `0_chart_master` VALUES ('4693', '', 'Kommunális adó', '469', '0');
INSERT INTO `0_chart_master` VALUES ('47101', '', 'Jövedelem elszámolás január', '471', '0');
INSERT INTO `0_chart_master` VALUES ('47102', '', 'Jövedelem elszámolás február', '471', '0');
INSERT INTO `0_chart_master` VALUES ('47103', '', 'Jövedelem elszámolás március', '471', '0');
INSERT INTO `0_chart_master` VALUES ('47104', '', 'Jövedelem elszámolás április', '471', '0');
INSERT INTO `0_chart_master` VALUES ('47105', '', 'Jövedelem elszámolás május', '471', '0');
INSERT INTO `0_chart_master` VALUES ('47106', '', 'Jövedelem elszámolás június', '471', '0');
INSERT INTO `0_chart_master` VALUES ('47107', '', 'Jövedelem elszámolás július', '471', '0');
INSERT INTO `0_chart_master` VALUES ('47108', '', 'Jövedelem elszámolás augusztus', '471', '0');
INSERT INTO `0_chart_master` VALUES ('47109', '', 'Jövedelem elszámolás szeptember', '471', '0');
INSERT INTO `0_chart_master` VALUES ('47110', '', 'Jövedelem elszámolás október', '471', '0');
INSERT INTO `0_chart_master` VALUES ('47111', '', 'Jövedelem elszámolás november', '471', '0');
INSERT INTO `0_chart_master` VALUES ('47112', '', 'Jövedelem elszámolás december', '471', '0');
INSERT INTO `0_chart_master` VALUES ('4721', '', 'Fel nem vett járandóság', '472', '0');
INSERT INTO `0_chart_master` VALUES ('47311', '', 'Nyugdíjbiztosítási Alap kötelezettség', '4731', '0');
INSERT INTO `0_chart_master` VALUES ('47319', '', 'Nyugdíjbiztosítási Alap kötelezettség teljesitése', '4731', '0');
INSERT INTO `0_chart_master` VALUES ('47321', '', 'Egészségbiztosítási Alap kötelezettség', '4731', '0');
INSERT INTO `0_chart_master` VALUES ('47329', '', 'Egészségbiztosítási Alap kötelezettség teljesitése', '4732', '0');
INSERT INTO `0_chart_master` VALUES ('47331', '', 'Magánnyugdíjpénztár', '4733', '0');
INSERT INTO `0_chart_master` VALUES ('4781', '', 'Osztalék', '478', '0');
INSERT INTO `0_chart_master` VALUES ('4799', '', 'Technikai számla', '479', '0');
INSERT INTO `0_chart_master` VALUES ('4810', '', 'Költségek, ráforditások passzív időbeli elhatárolása', '48', '0');
INSERT INTO `0_chart_master` VALUES ('4820', '', 'Árbevételek passzív időbeli elhatárolása', '48', '0');
INSERT INTO `0_chart_master` VALUES ('4830', '', 'Halasztott bevételek', '48', '0');
INSERT INTO `0_chart_master` VALUES ('4910', '', 'Nyitómérleg számla', '48', '0');
INSERT INTO `0_chart_master` VALUES ('4920', '', 'Záró mérleg számla', '49', '0');
INSERT INTO `0_chart_master` VALUES ('4930', '', 'Adózott eredmény elszámolási számla', '49', '0');
INSERT INTO `0_chart_master` VALUES ('5110', '', 'Anyagköltség', '51', '0');
INSERT INTO `0_chart_master` VALUES ('5120', '', 'Energia, szemét, közüzemi díj', '51', '0');
INSERT INTO `0_chart_master` VALUES ('5130', '', 'Üzemanyag', '51', '0');
INSERT INTO `0_chart_master` VALUES ('5140', '', 'Nyomtatványok, irodaszerek', '51', '0');
INSERT INTO `0_chart_master` VALUES ('5150', '', 'Tisztítószer', '51', '0');
INSERT INTO `0_chart_master` VALUES ('5160', '', 'Szakkönyv, folyóirat', '51', '0');
INSERT INTO `0_chart_master` VALUES ('5190', '', 'Egyéb anyagköltség', '51', '0');
INSERT INTO `0_chart_master` VALUES ('5211', '', 'Belföldi szállítási költség', '521', '0');
INSERT INTO `0_chart_master` VALUES ('5212', '', 'Külföldi szállítási költség', '521', '0');
INSERT INTO `0_chart_master` VALUES ('5221', '', 'Irodabérleti díj', '522', '0');
INSERT INTO `0_chart_master` VALUES ('5241', '', 'Belföldi utazási költség', '524', '0');
INSERT INTO `0_chart_master` VALUES ('5242', '', 'Külföldi utazási költség', '524', '0');
INSERT INTO `0_chart_master` VALUES ('5251', '', 'Reklám költség', '525', '0');
INSERT INTO `0_chart_master` VALUES ('5252', '', 'Hirdetés költsége', '525', '0');
INSERT INTO `0_chart_master` VALUES ('5261', '', 'Oktatás költsége', '526', '0');
INSERT INTO `0_chart_master` VALUES ('5271', '', 'Posta költség', '527', '0');
INSERT INTO `0_chart_master` VALUES ('5281', '', 'Telefonköltség', '528', '0');
INSERT INTO `0_chart_master` VALUES ('5282', '', 'Internet költség', '528', '0');
INSERT INTO `0_chart_master` VALUES ('52901', '', 'Könyvvezetés költsége', '529', '0');
INSERT INTO `0_chart_master` VALUES ('52902', '', 'Ügyvédi költség', '529', '0');
INSERT INTO `0_chart_master` VALUES ('52903', '', 'Tanácsadás', '529', '0');
INSERT INTO `0_chart_master` VALUES ('52904', '', 'Vámügyintézés', '529', '0');
INSERT INTO `0_chart_master` VALUES ('5299', '', 'Egyéb igénybevett szolgáltatás', '529', '0');
INSERT INTO `0_chart_master` VALUES ('5311', '', 'Illetékek, tagdíjak', '531', '0');
INSERT INTO `0_chart_master` VALUES ('5321', '', 'Bankköltség', '532', '0');
INSERT INTO `0_chart_master` VALUES ('5331', '', 'Vagyonbiztosítás', '533', '0');
INSERT INTO `0_chart_master` VALUES ('5391', '', 'Faktordíj', '539', '0');
INSERT INTO `0_chart_master` VALUES ('5410', '', 'Bérköltség (munkavállaló, tag)', '54', '0');
INSERT INTO `0_chart_master` VALUES ('5420', '', 'Megbizási jogviszony költsége', '54', '0');
INSERT INTO `0_chart_master` VALUES ('5450', '', 'Prémium', '54', '0');
INSERT INTO `0_chart_master` VALUES ('5510', '', 'Étkezési jegy', '55', '0');
INSERT INTO `0_chart_master` VALUES ('5520', '', 'Reprezentáció', '55', '0');
INSERT INTO `0_chart_master` VALUES ('5590', '', 'Egyéb személyi jellegű kifizetés', '55', '0');
INSERT INTO `0_chart_master` VALUES ('5611', '', 'Nyugdíjbiztosítási járulék', '561', '0');
INSERT INTO `0_chart_master` VALUES ('5612', '', 'Egészségbiztosítási járulék', '561', '0');
INSERT INTO `0_chart_master` VALUES ('5621', '', 'Tételes EHO', '562', '0');
INSERT INTO `0_chart_master` VALUES ('5622', '', 'Százalékos EHO', '562', '0');
INSERT INTO `0_chart_master` VALUES ('5630', '', 'Munkaadói járulék', '562', '0');
INSERT INTO `0_chart_master` VALUES ('5640', '', 'Szakképzési hozzájárulás', '562', '0');
INSERT INTO `0_chart_master` VALUES ('5650', '', 'Rehabilitációs hozzájárulás', '562', '0');
INSERT INTO `0_chart_master` VALUES ('5690', '', 'Egyéb bérjárulékok', '562', '0');
INSERT INTO `0_chart_master` VALUES ('5710', '', 'Terv szerinti értékcsökkenési leirás', '57', '0');
INSERT INTO `0_chart_master` VALUES ('5720', '', 'Kisértékű eszközök értékcsökkenése', '57', '0');
INSERT INTO `0_chart_master` VALUES ('8110', '', 'Anyagköltség', '81', '0');
INSERT INTO `0_chart_master` VALUES ('8120', '', 'Igénybevett szolgáltatás', '81', '0');
INSERT INTO `0_chart_master` VALUES ('8130', '', 'Eladott szolgáltatások értéke', '81', '0');
INSERT INTO `0_chart_master` VALUES ('8140', '', 'ELÁBÉ', '81', '0');
INSERT INTO `0_chart_master` VALUES ('8150', '', 'Eladott (közvetitett) szolgáltatás értéke', '81', '0');
INSERT INTO `0_chart_master` VALUES ('8611', '', 'Értékesitett immateriális javak nyilvántartási értéke', '861', '0');
INSERT INTO `0_chart_master` VALUES ('8612', '', 'Értékesitett tárgyi eszközök nyilvántartási értéke', '861', '0');
INSERT INTO `0_chart_master` VALUES ('8631', '', 'késedelmi kamatok', '863', '0');
INSERT INTO `0_chart_master` VALUES ('8641', '', 'Céltartalék képzése', '864', '0');
INSERT INTO `0_chart_master` VALUES ('8651', '', 'Követelések értékvesztése', '865', '0');
INSERT INTO `0_chart_master` VALUES ('8652', '', 'Immateriális javak terven felüli értékcsökkenése', '865', '0');
INSERT INTO `0_chart_master` VALUES ('8653', '', 'Tárgyi eszközök terven felüli értékcsökkenése', '865', '0');
INSERT INTO `0_chart_master` VALUES ('8661', '', 'Iparűzési adó', '866', '0');
INSERT INTO `0_chart_master` VALUES ('8662', '', 'Gépjárműadó', '866', '0');
INSERT INTO `0_chart_master` VALUES ('8663', '', 'Kommunális adó', '866', '0');
INSERT INTO `0_chart_master` VALUES ('8681', '', 'Le nem vonható ÁFA', '868', '0');
INSERT INTO `0_chart_master` VALUES ('8682', '', 'Önellenörzési pótlék', '868', '0');
INSERT INTO `0_chart_master` VALUES ('8691', '', 'Káresemények', '869', '0');
INSERT INTO `0_chart_master` VALUES ('8694', '', 'Előző évet terhelő ráforditások', '869', '0');
INSERT INTO `0_chart_master` VALUES ('8699', '', 'Egyéb ráforditások', '869', '0');
INSERT INTO `0_chart_master` VALUES ('8698', '', 'Kerekitési különbözet', '869', '0');
INSERT INTO `0_chart_master` VALUES ('8710', '', 'Fizetett osztalék, részesedés', '87', '0');
INSERT INTO `0_chart_master` VALUES ('8720', '', 'Részesedések, értékpapirok, bankbetétek értékvesztés', '87', '0');
INSERT INTO `0_chart_master` VALUES ('8730', '', 'Befektett pénzügyi eszközök árfolyam vesztesége', '87', '0');
INSERT INTO `0_chart_master` VALUES ('8741', '', 'Fizetett kamatok kapcsolt vállakozásnak', '874', '0');
INSERT INTO `0_chart_master` VALUES ('8742', '', 'Fizetett kamatok egyéb vállakozásoknak', '874', '0');
INSERT INTO `0_chart_master` VALUES ('8743', '', 'Pénzintézetnek fizetett kamatok', '874', '0');
INSERT INTO `0_chart_master` VALUES ('8744', '', 'Magénszemélyeknek fizetett kamatok', '874', '0');
INSERT INTO `0_chart_master` VALUES ('8761', '', 'Deviza és valutakészletek átváltási árfolyamveszteség', '876', '0');
INSERT INTO `0_chart_master` VALUES ('8762', '', 'Követelések és kötelezettségek árfolyamvesztesége', '876', '0');
INSERT INTO `0_chart_master` VALUES ('8791', '', 'Faktordíj', '879', '0');
INSERT INTO `0_chart_master` VALUES ('8820', '', 'Társaságba bevitt vagyontárgyak nyilvántartás szerinti ', '881', '0');
INSERT INTO `0_chart_master` VALUES ('8830', '', 'Véglegesen átadott pénzeszköz', '881', '0');
INSERT INTO `0_chart_master` VALUES ('8840', '', 'Elengedett követelés', '881', '0');
INSERT INTO `0_chart_master` VALUES ('8890', '', 'Egyéb rendkívüli ráforditások', '881', '0');
INSERT INTO `0_chart_master` VALUES ('8910', '', 'Társasági adó', '89', '0');
INSERT INTO `0_chart_master` VALUES ('9112', '', 'Belföldi szolgáltatás árbevétele', '911', '0');
INSERT INTO `0_chart_master` VALUES ('9111', '', 'Belföldi termekértékesítés árbevétele', '911', '0');
INSERT INTO `0_chart_master` VALUES ('9311', '', 'Export termekértékesítés árbevétele', '931', '0');
INSERT INTO `0_chart_master` VALUES ('9312', '', 'Export szolgáltatás árbevétele', '931', '0');
INSERT INTO `0_chart_master` VALUES ('9611', '', 'Értékesitett immateriális javak bevétele', '961', '0');
INSERT INTO `0_chart_master` VALUES ('9612', '', 'Értékesitett tárgyi eszközök bevétele', '961', '0');
INSERT INTO `0_chart_master` VALUES ('9631', '', 'Kapott késedelmi kamatok', '963', '0');
INSERT INTO `0_chart_master` VALUES ('9641', '', 'Céltartalék képzése', '964', '0');
INSERT INTO `0_chart_master` VALUES ('9651', '', 'Követelések értékvesztésének visszairása', '965', '0');
INSERT INTO `0_chart_master` VALUES ('9652', '', 'Immateriális javak terven felüli értékcsökkenésének v', '965', '0');
INSERT INTO `0_chart_master` VALUES ('9653', '', 'Tárgyi eszközök terven felüli érétkcsökkenésének vi', '965', '0');
INSERT INTO `0_chart_master` VALUES ('9691', '', 'Káresemények bevételei', '965', '0');
INSERT INTO `0_chart_master` VALUES ('9698', '', 'Kerekítési különbözet', '965', '0');
INSERT INTO `0_chart_master` VALUES ('9699', '', 'Egyéb bevételek', '969', '0');
INSERT INTO `0_chart_master` VALUES ('9710', '', 'Kapott osztalék, részesedés', '97', '0');
INSERT INTO `0_chart_master` VALUES ('9720', '', 'Részesedések, értékpapirok, bankbetétek értékvesztés', '97', '0');
INSERT INTO `0_chart_master` VALUES ('9730', '', 'Befektetett pénzügyi eszközök árfolyam nyeresége', '97', '0');
INSERT INTO `0_chart_master` VALUES ('9741', '', 'Kapott kamatok kapcsolt vállalkozástól', '974', '0');
INSERT INTO `0_chart_master` VALUES ('9742', '', 'Kapott kamatok egyéb vállakozástól', '974', '0');
INSERT INTO `0_chart_master` VALUES ('9743', '', 'Kapott kamatok pénzintézettől', '974', '0');
INSERT INTO `0_chart_master` VALUES ('9744', '', 'Magánszemélytől kapott kamatok', '974', '0');
INSERT INTO `0_chart_master` VALUES ('9761', '', 'Deviza és valutakészlet átváltási árfolyamnyeresége', '976', '0');
INSERT INTO `0_chart_master` VALUES ('9762', '', 'Követelések és kötelezettségek árfolyamnyeresége', '976', '0');
INSERT INTO `0_chart_master` VALUES ('9791', '', 'Egyéb pénzügyi bevételek', '979', '0');
INSERT INTO `0_chart_master` VALUES ('9810', '', 'Ellenérték nélkül kapott eszközök értéke', '98', '0');
INSERT INTO `0_chart_master` VALUES ('9820', '', 'Társaságba bevitt vagyontárgyak szerződés szerinti ért', '98', '0');
INSERT INTO `0_chart_master` VALUES ('9830', '', 'Véglegesen kapott pénzeszköz', '98', '0');
INSERT INTO `0_chart_master` VALUES ('9840', '', 'Elengedett kötelezettség', '98', '0');
INSERT INTO `0_chart_master` VALUES ('9890', '', 'Egyéb rendkívüli bevételek', '98', '0');


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
) ENGINE=MyISAM AUTO_INCREMENT=4734  ;


### Data of table `0_chart_types` ###

INSERT INTO `0_chart_types` VALUES ('11', 'Immateriális javak', '1', '', '0');
INSERT INTO `0_chart_types` VALUES ('114', 'Szellemi termékek', '1', '', '0');
INSERT INTO `0_chart_types` VALUES ('117', 'Immateriális javak értékhelyesbítése', '1', '', '0');
INSERT INTO `0_chart_types` VALUES ('118', 'Immateriális javak terven felüli értékcsökkenése', '1', '', '0');
INSERT INTO `0_chart_types` VALUES ('119', 'Immateriális javak értékcsökkenése', '1', '', '0');
INSERT INTO `0_chart_types` VALUES ('12', 'Ingatlanok', '1', '', '0');
INSERT INTO `0_chart_types` VALUES ('13', 'Műszaki gépek, berendezések, járművek', '1', '', '0');
INSERT INTO `0_chart_types` VALUES ('131', 'Termelő gépek, berendezések', '1', '13', '0');
INSERT INTO `0_chart_types` VALUES ('132', 'Járművek', '1', '13', '0');
INSERT INTO `0_chart_types` VALUES ('137', 'Műszaki gépek, berendezések járművek értékhelyesb.', '1', '13', '0');
INSERT INTO `0_chart_types` VALUES ('138', 'Műszaki gépek, berendezések, járművek terven felüli é', '1', '13', '0');
INSERT INTO `0_chart_types` VALUES ('139', 'Műszaki gépek, berendezések, járművek értékcsökk.', '1', '13', '0');
INSERT INTO `0_chart_types` VALUES ('14', 'Egyéb gépek, berendezések, járművek', '1', '', '0');
INSERT INTO `0_chart_types` VALUES ('141', 'Egyéb gép, berendezés, szerszám', '1', '14', '0');
INSERT INTO `0_chart_types` VALUES ('142', 'Egyéb járművek', '1', '14', '0');
INSERT INTO `0_chart_types` VALUES ('143', 'Irodai, igazgatási berendezés, felszerelés', '1', '14', '0');
INSERT INTO `0_chart_types` VALUES ('145', 'Kisértékű tárgyi eszköz', '1', '14', '0');
INSERT INTO `0_chart_types` VALUES ('147', 'Egyéb gépek, berendezések, járművek értékhelyesbíté', '1', '14', '0');
INSERT INTO `0_chart_types` VALUES ('148', 'Egyéb gépek, berendezések, járművek terven felüli ért', '1', '', '0');
INSERT INTO `0_chart_types` VALUES ('149', 'Egyéb gépek, berendezések, járművek elszámolt értékc', '1', '14', '0');
INSERT INTO `0_chart_types` VALUES ('15', 'Beruházások', '1', '', '0');
INSERT INTO `0_chart_types` VALUES ('161', 'Befejezetlen beruházások', '1', '15', '0');
INSERT INTO `0_chart_types` VALUES ('21', 'Anyagok', '1', '', '0');
INSERT INTO `0_chart_types` VALUES ('26', 'Kereskedelmi áruk', '1', '', '0');
INSERT INTO `0_chart_types` VALUES ('31', 'Követelések áruszállításból, szolgáltatásból', '1', '', '0');
INSERT INTO `0_chart_types` VALUES ('311', 'Belföldi vevők', '1', '31', '0');
INSERT INTO `0_chart_types` VALUES ('316', 'Külföldi vevők', '1', '31', '0');
INSERT INTO `0_chart_types` VALUES ('32', 'Követelések kapcsolt vállakozással szemben', '1', '', '0');
INSERT INTO `0_chart_types` VALUES ('321', 'Követelések', '1', '32', '0');
INSERT INTO `0_chart_types` VALUES ('325', 'Jegyzett de be nem fizetett tőke', '1', '32', '0');
INSERT INTO `0_chart_types` VALUES ('329', 'Követelések értékvesztése', '1', '32', '0');
INSERT INTO `0_chart_types` VALUES ('33', 'Követelések egyéb részesedési viszonyban lévő vállal', '1', '', '0');
INSERT INTO `0_chart_types` VALUES ('331', 'Követelések egyéb részesedési viszonyban lévő vállal', '1', '33', '0');
INSERT INTO `0_chart_types` VALUES ('332', 'Jegyzett, de még be nem fizetett tőke egyéb részesedési', '1', '33', '0');
INSERT INTO `0_chart_types` VALUES ('339', 'Egyéb részesedési viszonyban lévő vállakozással szemb', '1', '33', '0');
INSERT INTO `0_chart_types` VALUES ('34', 'Váltókövetelések', '1', '', '0');
INSERT INTO `0_chart_types` VALUES ('35', 'Adott előlegek', '1', '', '0');
INSERT INTO `0_chart_types` VALUES ('36', 'Egyéb követelések', '1', '', '0');
INSERT INTO `0_chart_types` VALUES ('366', 'Rövid lejáratra adott pénzkölcsönök', '1', '36', '0');
INSERT INTO `0_chart_types` VALUES ('37', 'Értékpapirok', '1', '', '0');
INSERT INTO `0_chart_types` VALUES ('38', 'Pénzeszközök', '1', '', '0');
INSERT INTO `0_chart_types` VALUES ('381', 'Pénztárak', '1', '38', '0');
INSERT INTO `0_chart_types` VALUES ('382', 'Valutapénztárak', '1', '38', '0');
INSERT INTO `0_chart_types` VALUES ('384', 'Elszámolási betétszámlák (Ft)', '1', '38', '0');
INSERT INTO `0_chart_types` VALUES ('386', 'Deviza betétszámlák', '1', '38', '0');
INSERT INTO `0_chart_types` VALUES ('389', 'Átvezetési számlák', '1', '38', '0');
INSERT INTO `0_chart_types` VALUES ('39', 'Aktiv időbeli elhatárolások', '1', '', '0');
INSERT INTO `0_chart_types` VALUES ('41', 'Saját tőke', '2', '', '0');
INSERT INTO `0_chart_types` VALUES ('42', 'Céltartalékok', '2', '', '0');
INSERT INTO `0_chart_types` VALUES ('43', 'Hátrasorolt kötelezettségek', '2', '', '0');
INSERT INTO `0_chart_types` VALUES ('44', 'Hosszú lejáratú kötelezettségek', '2', '', '0');
INSERT INTO `0_chart_types` VALUES ('442', 'Hosszú lejáratra kapott kölcsönök', '2', '44', '0');
INSERT INTO `0_chart_types` VALUES ('443', 'Beruházási fejlesztési hitelek', '2', '44', '0');
INSERT INTO `0_chart_types` VALUES ('444', 'Egyéb hosszú lejáratú hitelek', '2', '44', '0');
INSERT INTO `0_chart_types` VALUES ('446', 'Tartós kötelezettség kapcsolt vállalkozással szemben', '2', '44', '0');
INSERT INTO `0_chart_types` VALUES ('447', 'Tartós kötelezettség egyéb vállalkozással szemben', '2', '44', '0');
INSERT INTO `0_chart_types` VALUES ('449', 'Egyéb hosszú lejáratú kötelezettség', '2', '44', '0');
INSERT INTO `0_chart_types` VALUES ('45', 'Rövid lejáratú kötelezettségek', '2', '', '0');
INSERT INTO `0_chart_types` VALUES ('451', 'Vevőktől kapott előlegek', '2', '45', '0');
INSERT INTO `0_chart_types` VALUES ('452', 'Rövid lejáratú kölcsönök', '2', '45', '0');
INSERT INTO `0_chart_types` VALUES ('453', 'Rövid lejáratú hitelek', '2', '45', '0');
INSERT INTO `0_chart_types` VALUES ('454', 'Kötelezettségek áruszállításból és szolgáltatás ny', '2', '45', '0');
INSERT INTO `0_chart_types` VALUES ('455', 'Pénzügyi lízing miatti kötelezettség', '2', '45', '0');
INSERT INTO `0_chart_types` VALUES ('456', 'Rövid lejáratú kötelezettség kapcsolt vállalkozással ', '2', '45', '0');
INSERT INTO `0_chart_types` VALUES ('457', 'Rövid lejáratú kötelezettség egyéb vállakozással sze', '2', '45', '0');
INSERT INTO `0_chart_types` VALUES ('459', 'Egyéb rövid lejáratú kötelezettség', '2', '45', '0');
INSERT INTO `0_chart_types` VALUES ('46', 'Adóhatósággal szembeni kötelezettségek', '2', '', '0');
INSERT INTO `0_chart_types` VALUES ('461', 'Társasági adó elszámolása', '2', '46', '0');
INSERT INTO `0_chart_types` VALUES ('462', 'SZJA elszámolás', '2', '46', '0');
INSERT INTO `0_chart_types` VALUES ('463', 'Költségvetési befizetési kötelezettség', '2', '46', '0');
INSERT INTO `0_chart_types` VALUES ('464', 'Költségvetési befizetési kötelezettség teljesitése', '2', '46', '0');
INSERT INTO `0_chart_types` VALUES ('465', 'VPOP elszámolási számla', '2', '46', '0');
INSERT INTO `0_chart_types` VALUES ('466', 'Előzetesen felszámítottt ÁFA', '2', '46', '0');
INSERT INTO `0_chart_types` VALUES ('467', 'Fizetendő ÁFA', '2', '46', '0');
INSERT INTO `0_chart_types` VALUES ('469', 'Helyi adók elszámolási számla', '2', '46', '0');
INSERT INTO `0_chart_types` VALUES ('47', 'Egyéb kötelezettségek', '2', '', '0');
INSERT INTO `0_chart_types` VALUES ('471', 'Jövedelem elszámolási számla', '2', '47', '0');
INSERT INTO `0_chart_types` VALUES ('472', 'Fel nem vett járandóság', '2', '47', '0');
INSERT INTO `0_chart_types` VALUES ('473', 'Nyugdíj- és egészségbiztosítás', '2', '47', '0');
INSERT INTO `0_chart_types` VALUES ('4731', 'Nyugdíjbiztosítási Alap', '2', '473', '0');
INSERT INTO `0_chart_types` VALUES ('4732', 'Egészségbiztosítási Alap', '2', '473', '0');
INSERT INTO `0_chart_types` VALUES ('4733', 'Magánnyugdíjpénztár', '2', '473', '0');
INSERT INTO `0_chart_types` VALUES ('478', 'Osztalékelszámolási számla', '2', '47', '0');
INSERT INTO `0_chart_types` VALUES ('479', 'Egyéb rövid lejáratú kötelezettség', '2', '47', '0');
INSERT INTO `0_chart_types` VALUES ('48', 'Passzív időbeli elhatárolások', '2', '', '0');
INSERT INTO `0_chart_types` VALUES ('49', 'Évi mérlegszámlák', '2', '', '0');
INSERT INTO `0_chart_types` VALUES ('51', 'Anyagjellegű költségek', '4', '', '0');
INSERT INTO `0_chart_types` VALUES ('52', 'Igénybevett szolgáltatások költségei', '4', '', '0');
INSERT INTO `0_chart_types` VALUES ('521', 'Szállítási, rakodási költség', '4', '52', '0');
INSERT INTO `0_chart_types` VALUES ('522', 'Bérleti díjak', '4', '52', '0');
INSERT INTO `0_chart_types` VALUES ('524', 'Utazási és szállás költség', '4', '52', '0');
INSERT INTO `0_chart_types` VALUES ('525', 'Hirdetés és reklám költség', '4', '52', '0');
INSERT INTO `0_chart_types` VALUES ('526', 'Oktatás, továbbképzés költsége', '4', '52', '0');
INSERT INTO `0_chart_types` VALUES ('527', 'Posta költség', '4', '52', '0');
INSERT INTO `0_chart_types` VALUES ('528', 'Kommunikációs költségek', '4', '52', '0');
INSERT INTO `0_chart_types` VALUES ('529', 'Egyéb igénybevett szolgáltatások', '4', '52', '0');
INSERT INTO `0_chart_types` VALUES ('53', 'Egyéb szolgáltatások költségei', '4', '', '0');
INSERT INTO `0_chart_types` VALUES ('531', 'Hatósági, igazgatási, szolg. illeték', '4', '53', '0');
INSERT INTO `0_chart_types` VALUES ('532', 'Bankköltség', '4', '53', '0');
INSERT INTO `0_chart_types` VALUES ('533', 'Biztosítási díjak', '4', '53', '0');
INSERT INTO `0_chart_types` VALUES ('539', 'Egyéb szolgáltatások ', '4', '53', '0');
INSERT INTO `0_chart_types` VALUES ('54', 'Bérköltség', '4', '', '0');
INSERT INTO `0_chart_types` VALUES ('55', 'Személyi jellegű egyéb kifizetés', '4', '', '0');
INSERT INTO `0_chart_types` VALUES ('56', 'Bérjárulékok', '4', '', '0');
INSERT INTO `0_chart_types` VALUES ('561', 'Nyugdíj és egészségbiztosítás', '4', '56', '0');
INSERT INTO `0_chart_types` VALUES ('562', 'EHO', '4', '56', '0');
INSERT INTO `0_chart_types` VALUES ('57', 'Értékcsökkenési leirás', '4', '', '0');
INSERT INTO `0_chart_types` VALUES ('81', 'Anyagjellegű ráforditások', '4', '', '0');
INSERT INTO `0_chart_types` VALUES ('86', 'Egyéb ráforditások', '4', '', '0');
INSERT INTO `0_chart_types` VALUES ('861', 'Értékesitett eszközök nyilvántartási értéke', '4', '86', '0');
INSERT INTO `0_chart_types` VALUES ('863', 'Egyéb eredményt csökkentő tételek', '4', '86', '0');
INSERT INTO `0_chart_types` VALUES ('864', 'Céltartalék képzése', '4', '86', '0');
INSERT INTO `0_chart_types` VALUES ('865', 'Értékvesztés, terven felüli értékcsökkenés', '4', '86', '0');
INSERT INTO `0_chart_types` VALUES ('866', 'Önkormányzatokkal elszámolt adók, illetékek', '4', '86', '0');
INSERT INTO `0_chart_types` VALUES ('868', 'Állami költségvetéssel elszámolt adók', '4', '86', '0');
INSERT INTO `0_chart_types` VALUES ('869', 'Különféle egyéb ráforditások', '4', '86', '0');
INSERT INTO `0_chart_types` VALUES ('87', 'Pénzügyi műveletek ráforditásai', '4', '', '0');
INSERT INTO `0_chart_types` VALUES ('874', 'Fizetendő kamatok és kamatjellegű ráforditások', '4', '87', '0');
INSERT INTO `0_chart_types` VALUES ('876', 'Átváltáskori és értékesitéskori árfolyamveszteségek', '4', '87', '0');
INSERT INTO `0_chart_types` VALUES ('879', 'Egyéb pénzügyi ráforditások', '4', '87', '0');
INSERT INTO `0_chart_types` VALUES ('88', 'Rendkivüli ráforditások', '4', '', '0');
INSERT INTO `0_chart_types` VALUES ('881', 'Térités nélkül átadott eszközök nyilvántartási ért', '4', '88', '0');
INSERT INTO `0_chart_types` VALUES ('89', 'Nyereséget terhelő adók', '4', '', '0');
INSERT INTO `0_chart_types` VALUES ('91', 'Értékesités árbevétele', '3', '', '0');
INSERT INTO `0_chart_types` VALUES ('911', 'Belföldi értékesités árbevétele', '3', '91', '0');
INSERT INTO `0_chart_types` VALUES ('93', 'Export értékesités árbevétele', '3', '', '0');
INSERT INTO `0_chart_types` VALUES ('931', 'Export értékesités árbevétele', '3', '93', '0');
INSERT INTO `0_chart_types` VALUES ('96', 'Egyéb bevételek', '3', '', '0');
INSERT INTO `0_chart_types` VALUES ('961', 'Értékesitett eszközök bevétele', '3', '96', '0');
INSERT INTO `0_chart_types` VALUES ('963', 'Egyéb eredményt növelő tételek', '3', '96', '0');
INSERT INTO `0_chart_types` VALUES ('964', 'Céltartalék képzése', '3', '96', '0');
INSERT INTO `0_chart_types` VALUES ('965', '', '3', '96', '0');
INSERT INTO `0_chart_types` VALUES ('969', 'Különféle egyéb bevételek', '3', '96', '0');
INSERT INTO `0_chart_types` VALUES ('97', 'Pénzügyi bevételek', '3', '', '0');
INSERT INTO `0_chart_types` VALUES ('974', 'Kapott kamatok és kamatjellegű ráforditások', '3', '97', '0');
INSERT INTO `0_chart_types` VALUES ('976', 'Átváltáskori és értékesitéskori árfolyamnyereség', '3', '97', '0');
INSERT INTO `0_chart_types` VALUES ('979', 'Egyéb pénzügyi bevételek', '3', '97', '0');
INSERT INTO `0_chart_types` VALUES ('98', 'Rendkivüli bevételek', '3', '', '0');


### Structure of table `0_comments` ###

DROP TABLE IF EXISTS `0_comments`;

CREATE TABLE `0_comments` (
  `type` int(11) NOT NULL default '0',
  `id` int(11) NOT NULL default '0',
  `date_` date default '0000-00-00',
  `memo_` tinytext,
  KEY `type_and_id` (`type`,`id`)
) ENGINE=InnoDB  ;


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
) ENGINE=MyISAM AUTO_INCREMENT=5  ;


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
) ENGINE=InnoDB AUTO_INCREMENT=13  ;


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
) ENGINE=InnoDB AUTO_INCREMENT=7  ;


### Data of table `0_crm_contacts` ###

INSERT INTO `0_crm_contacts` VALUES ('1', '1', 'customer', 'general', '1');
INSERT INTO `0_crm_contacts` VALUES ('2', '2', 'customer', 'general', '2');
INSERT INTO `0_crm_contacts` VALUES ('3', '3', 'cust_branch', 'general', '1');
INSERT INTO `0_crm_contacts` VALUES ('4', '4', 'cust_branch', 'general', '2');
INSERT INTO `0_crm_contacts` VALUES ('5', '5', 'cust_branch', 'general', '3');
INSERT INTO `0_crm_contacts` VALUES ('6', '6', 'supplier', 'general', '1');


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
) ENGINE=InnoDB AUTO_INCREMENT=7  ;


### Data of table `0_crm_persons` ###

INSERT INTO `0_crm_persons` VALUES ('1', 'Kiss Anna', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '0');
INSERT INTO `0_crm_persons` VALUES ('2', 'Kis Virág', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '0');
INSERT INTO `0_crm_persons` VALUES ('3', 'Kis Virág', 'Main Branch', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '0');
INSERT INTO `0_crm_persons` VALUES ('4', 'Kis Virág', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '0');
INSERT INTO `0_crm_persons` VALUES ('5', 'Kiss Anna', 'Main Branch', NULL, 'Budapest 1042', NULL, NULL, NULL, NULL, NULL, '', '0');
INSERT INTO `0_crm_persons` VALUES ('6', 'Adoniss', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '0');


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
) ENGINE=MyISAM  ;


### Data of table `0_currencies` ###

INSERT INTO `0_currencies` VALUES ('Euro', 'EUR', '?', 'Europe', 'Cents', '0', '1');
INSERT INTO `0_currencies` VALUES ('Pounds', 'GBP', '?', 'England', 'Pence', '0', '1');
INSERT INTO `0_currencies` VALUES ('US Dollars', 'USD', '$', 'United States', 'Cents', '0', '1');
INSERT INTO `0_currencies` VALUES ('Hungarian Forint', 'HUF', 'Ft', 'Magyarország', 'fillér', '0', '1');


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
) ENGINE=InnoDB  ;


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
) ENGINE=MyISAM AUTO_INCREMENT=4  ;


### Data of table `0_cust_branch` ###

INSERT INTO `0_cust_branch` VALUES ('1', '2', 'Kis Virág', '', '1', '1', 'Main Branch', 'DEF', '2', '9111', '9111', '3111', '9111', '1', '0', '', '0', NULL, '0', 'Kis Virág');
INSERT INTO `0_cust_branch` VALUES ('2', '2', 'Kis Virág', '', '1', '1', '', 'DEF', '3', '9111', '9111', '3111', '9111', '1', '0', '', '0', NULL, '0', 'Kis Virág');
INSERT INTO `0_cust_branch` VALUES ('3', '1', 'Kiss Anna', 'Budapest 1042', '1', '1', 'Main Branch', 'DEF', '3', '', '9111', '3111', '9111', '1', '0', 'Budapest 1042', '0', NULL, '0', 'Kiss Anna');


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
) ENGINE=InnoDB  ;


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
) ENGINE=InnoDB  ;


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
) ENGINE=MyISAM AUTO_INCREMENT=3  ;


### Data of table `0_debtors_master` ###

INSERT INTO `0_debtors_master` VALUES ('1', 'Kiss Anna', 'Budapest 1042', '', 'HUF', '1', '0', '0', '1', '4', '0', '0', '1000', NULL, '0', 'Kiss Anna');
INSERT INTO `0_debtors_master` VALUES ('2', 'Kis Virág', NULL, '', 'HUF', '1', '0', '0', '1', '4', '0', '0', '1000', NULL, '0', 'Kis Virág');


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
) ENGINE=InnoDB  ;


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
) ENGINE=MyISAM  ;


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
) ENGINE=InnoDB AUTO_INCREMENT=2  ;


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
) ENGINE=InnoDB  ;


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
) ENGINE=InnoDB  ;


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
) ENGINE=InnoDB  ;


### Data of table `0_grn_items` ###



### Structure of table `0_groups` ###

DROP TABLE IF EXISTS `0_groups`;

CREATE TABLE `0_groups` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `description` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `description` (`description`)
) ENGINE=MyISAM AUTO_INCREMENT=4  ;


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
) ENGINE=MyISAM AUTO_INCREMENT=2  ;


### Data of table `0_item_codes` ###

INSERT INTO `0_item_codes` VALUES ('1', '1', '1', 'Kék papír', '1', '1', '0', '0');


### Structure of table `0_item_tax_type_exemptions` ###

DROP TABLE IF EXISTS `0_item_tax_type_exemptions`;

CREATE TABLE `0_item_tax_type_exemptions` (
  `item_tax_type_id` int(11) NOT NULL default '0',
  `tax_type_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`item_tax_type_id`,`tax_type_id`)
) ENGINE=InnoDB  ;


### Data of table `0_item_tax_type_exemptions` ###

INSERT INTO `0_item_tax_type_exemptions` VALUES ('2', '1');
INSERT INTO `0_item_tax_type_exemptions` VALUES ('3', '1');
INSERT INTO `0_item_tax_type_exemptions` VALUES ('4', '1');
INSERT INTO `0_item_tax_type_exemptions` VALUES ('5', '1');


### Structure of table `0_item_tax_types` ###

DROP TABLE IF EXISTS `0_item_tax_types`;

CREATE TABLE `0_item_tax_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(60) NOT NULL default '',
  `exempt` tinyint(1) NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6  ;


### Data of table `0_item_tax_types` ###

INSERT INTO `0_item_tax_types` VALUES ('1', 'Fizetendő áfamentes 0%', '1', '0');
INSERT INTO `0_item_tax_types` VALUES ('2', 'Előzetesen felszámított EU 20%', '0', '0');
INSERT INTO `0_item_tax_types` VALUES ('3', 'Előzetesen felszámított 20%', '0', '0');
INSERT INTO `0_item_tax_types` VALUES ('4', 'Fizetendő 20%', '0', '0');
INSERT INTO `0_item_tax_types` VALUES ('5', 'Előzetesen felszámított BFOR20', '0', '0');


### Structure of table `0_item_units` ###

DROP TABLE IF EXISTS `0_item_units`;

CREATE TABLE `0_item_units` (
  `abbr` varchar(20) NOT NULL,
  `name` varchar(40) NOT NULL,
  `decimals` tinyint(2) NOT NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`abbr`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM  ;


### Data of table `0_item_units` ###

INSERT INTO `0_item_units` VALUES ('ea.', 'Each', '0', '0');
INSERT INTO `0_item_units` VALUES ('db/pc', 'darab', '0', '0');


### Structure of table `0_loc_stock` ###

DROP TABLE IF EXISTS `0_loc_stock`;

CREATE TABLE `0_loc_stock` (
  `loc_code` char(5) NOT NULL default '',
  `stock_id` char(20) NOT NULL default '',
  `reorder_level` bigint(20) NOT NULL default '0',
  PRIMARY KEY  (`loc_code`,`stock_id`),
  KEY `stock_id` (`stock_id`)
) ENGINE=InnoDB  ;


### Data of table `0_loc_stock` ###

INSERT INTO `0_loc_stock` VALUES ('DEF', '1', '0');


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
) ENGINE=MyISAM  ;


### Data of table `0_locations` ###

INSERT INTO `0_locations` VALUES ('DEF', 'Default', 'N/A', '', '', '', '', '', '0');


### Structure of table `0_movement_types` ###

DROP TABLE IF EXISTS `0_movement_types`;

CREATE TABLE `0_movement_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=2  ;


### Data of table `0_movement_types` ###

INSERT INTO `0_movement_types` VALUES ('1', 'Adjustment', '0');


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
) ENGINE=MyISAM AUTO_INCREMENT=5  ;


### Data of table `0_payment_terms` ###

INSERT INTO `0_payment_terms` VALUES ('1', 'Due 15th Of the Following Month', '0', '17', '0');
INSERT INTO `0_payment_terms` VALUES ('2', 'Due By End Of The Following Month', '0', '30', '0');
INSERT INTO `0_payment_terms` VALUES ('3', 'Payment due within 10 days', '10', '0', '0');
INSERT INTO `0_payment_terms` VALUES ('4', 'Cash Only', '1', '0', '0');


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
) ENGINE=MyISAM AUTO_INCREMENT=3  ;


### Data of table `0_prices` ###

INSERT INTO `0_prices` VALUES ('1', '1', '1', 'HUF', '0');
INSERT INTO `0_prices` VALUES ('2', '1', '1', 'EUR', '0');


### Structure of table `0_print_profiles` ###

DROP TABLE IF EXISTS `0_print_profiles`;

CREATE TABLE `0_print_profiles` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `profile` varchar(30) NOT NULL,
  `report` varchar(5) default NULL,
  `printer` tinyint(3) unsigned default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `profile` (`profile`,`report`)
) ENGINE=MyISAM AUTO_INCREMENT=10  ;


### Data of table `0_print_profiles` ###

INSERT INTO `0_print_profiles` VALUES ('1', 'Out of office', NULL, '0');
INSERT INTO `0_print_profiles` VALUES ('2', 'Sales Department', NULL, '0');
INSERT INTO `0_print_profiles` VALUES ('3', 'Central', NULL, '2');
INSERT INTO `0_print_profiles` VALUES ('4', 'Sales Department', '104', '2');
INSERT INTO `0_print_profiles` VALUES ('5', 'Sales Department', '105', '2');
INSERT INTO `0_print_profiles` VALUES ('6', 'Sales Department', '107', '2');
INSERT INTO `0_print_profiles` VALUES ('7', 'Sales Department', '109', '2');
INSERT INTO `0_print_profiles` VALUES ('8', 'Sales Department', '110', '2');
INSERT INTO `0_print_profiles` VALUES ('9', 'Sales Department', '201', '2');


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
) ENGINE=MyISAM AUTO_INCREMENT=4  ;


### Data of table `0_printers` ###

INSERT INTO `0_printers` VALUES ('1', 'QL500', 'Label printer', 'QL500', 'server', '127', '20');
INSERT INTO `0_printers` VALUES ('2', 'Samsung', 'Main network printer', 'scx4521F', 'server', '515', '5');
INSERT INTO `0_printers` VALUES ('3', 'Local', 'Local print server at user IP', 'lp', '', '515', '10');


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
) ENGINE=MyISAM  ;


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
) ENGINE=InnoDB  ;


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
) ENGINE=InnoDB  ;


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
) ENGINE=MyISAM AUTO_INCREMENT=4  ;


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
) ENGINE=MyISAM AUTO_INCREMENT=4  ;


### Data of table `0_quick_entry_lines` ###



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
) ENGINE=InnoDB  ;


### Data of table `0_recurrent_invoices` ###



### Structure of table `0_refs` ###

DROP TABLE IF EXISTS `0_refs`;

CREATE TABLE `0_refs` (
  `id` int(11) NOT NULL default '0',
  `type` int(11) NOT NULL default '0',
  `reference` varchar(100) NOT NULL default '',
  PRIMARY KEY  (`id`,`type`),
  KEY `Type_and_Reference` (`type`,`reference`)
) ENGINE=InnoDB  ;


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
) ENGINE=InnoDB  ;


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
) ENGINE=InnoDB  ;


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
) ENGINE=MyISAM AUTO_INCREMENT=2  ;


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
) ENGINE=MyISAM AUTO_INCREMENT=3  ;


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
) ENGINE=MyISAM AUTO_INCREMENT=2  ;


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
) ENGINE=MyISAM AUTO_INCREMENT=11;


### Data of table `0_security_roles` ###

INSERT INTO `0_security_roles` VALUES(1, 'Inquiries', 'Inquiries', '768;2816;3072;3328;5632;5888;8192;8448;10752;11008;13312;15872;16128', '257;258;259;260;513;514;515;516;517;518;519;520;521;522;523;524;525;773;774;2822;3073;3075;3076;3077;3329;3330;3331;3332;3333;3334;3335;5377;5633;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8450;8451;10497;10753;11009;11010;11012;13313;13315;15617;15618;15619;15620;15621;15622;15623;15624;15625;15626;15873;15882;16129;16130;16131;16132', 0);
INSERT INTO `0_security_roles` VALUES(2, 'System Administrator', 'System Administrator', '256;512;768;2816;3072;3328;5376;5632;5888;7936;8192;8448;10496;10752;11008;13056;13312;15616;15872;16128', '257;258;259;260;513;514;515;516;517;518;519;520;521;522;523;524;525;526;769;770;771;772;773;774;2817;2818;2819;2820;2821;2822;2823;3073;3074;3082;3075;3076;3077;3078;3079;3080;3081;3329;3330;3331;3332;3333;3334;3335;5377;5633;5634;5635;5636;5637;5641;5638;5639;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8195;8196;8197;8449;8450;8451;10497;10753;10754;10755;10756;10757;11009;11010;11011;11012;13057;13313;13314;13315;15617;15618;15619;15620;15621;15622;15623;15624;15628;15625;15626;15627;15873;15874;15875;15876;15877;15878;15879;15880;15883;15881;15882;16129;16130;16131;16132', 0);
INSERT INTO `0_security_roles` VALUES(3, 'Salesman', 'Salesman', '768;3072;5632;8192;15872', '773;774;3073;3075;3081;5633;8194;15873', 0);
INSERT INTO `0_security_roles` VALUES(4, 'Stock Manager', 'Stock Manager', '2816;3072;3328;5632;5888;8192;8448;10752;11008;13312;15872;16128', '2818;2822;3073;3076;3077;3329;3330;3330;3330;3331;3331;3332;3333;3334;3335;5633;5640;5889;5890;5891;8193;8194;8450;8451;10753;11009;11010;11012;13313;13315;15882;16129;16130;16131;16132', 0);
INSERT INTO `0_security_roles` VALUES(5, 'Production Manager', 'Production Manager', '512;2816;3072;3328;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '521;523;524;2818;2819;2820;2821;2822;2823;3073;3074;3076;3077;3078;3079;3080;3081;3329;3330;3330;3330;3331;3331;3332;3333;3334;3335;5633;5640;5640;5889;5890;5891;8193;8194;8196;8197;8450;8451;10753;10755;11009;11010;11012;13313;13315;15617;15619;15620;15621;15624;15624;15876;15877;15880;15882;16129;16130;16131;16132', 0);
INSERT INTO `0_security_roles` VALUES(6, 'Purchase Officer', 'Purchase Officer', '512;2816;3072;3328;5376;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '521;523;524;2818;2819;2820;2821;2822;2823;3073;3074;3076;3077;3078;3079;3080;3081;3329;3330;3330;3330;3331;3331;3332;3333;3334;3335;5377;5633;5635;5640;5640;5889;5890;5891;8193;8194;8196;8197;8449;8450;8451;10753;10755;11009;11010;11012;13313;13315;15617;15619;15620;15621;15624;15624;15876;15877;15880;15882;16129;16130;16131;16132', 0);
INSERT INTO `0_security_roles` VALUES(7, 'AR Officer', 'AR Officer', '512;768;2816;3072;3328;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '521;523;524;771;773;774;2818;2819;2820;2821;2822;2823;3073;3073;3074;3075;3076;3077;3078;3079;3080;3081;3081;3329;3330;3330;3330;3331;3331;3332;3333;3334;3335;5633;5633;5634;5637;5638;5639;5640;5640;5889;5890;5891;8193;8194;8194;8196;8197;8450;8451;10753;10755;11009;11010;11012;13313;13315;15617;15619;15620;15621;15624;15624;15873;15876;15877;15878;15880;15882;16129;16130;16131;16132', 0);
INSERT INTO `0_security_roles` VALUES(8, 'AP Officer', 'AP Officer', '512;2816;3072;3328;5376;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '257;258;259;260;521;523;524;769;770;771;772;773;774;2818;2819;2820;2821;2822;2823;3073;3074;3082;3076;3077;3078;3079;3080;3081;3329;3330;3331;3332;3333;3334;3335;5377;5633;5635;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8196;8197;8449;8450;8451;10497;10753;10755;11009;11010;11012;13057;13313;13315;15617;15619;15620;15621;15624;15876;15877;15880;15882;16129;16130;16131;16132', 0);
INSERT INTO `0_security_roles` VALUES(9, 'Accountant', 'New Accountant', '512;768;2816;3072;3328;5376;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '257;258;259;260;521;523;524;771;772;773;774;2818;2819;2820;2821;2822;2823;3073;3074;3075;3076;3077;3078;3079;3080;3081;3329;3330;3331;3332;3333;3334;3335;5377;5633;5634;5635;5637;5638;5639;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8196;8197;8449;8450;8451;10497;10753;10755;11009;11010;11012;13313;13315;15617;15618;15619;15620;15621;15624;15873;15876;15877;15878;15880;15882;16129;16130;16131;16132', 0);
INSERT INTO `0_security_roles` VALUES(10, 'Sub Admin', 'Sub Admin', '512;768;2816;3072;3328;5376;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '257;258;259;260;521;523;524;771;772;773;774;2818;2819;2820;2821;2822;2823;3073;3074;3082;3075;3076;3077;3078;3079;3080;3081;3329;3330;3331;3332;3333;3334;3335;5377;5633;5634;5635;5637;5638;5639;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8196;8197;8449;8450;8451;10497;10753;10755;11009;11010;11012;13057;13313;13315;15617;15619;15620;15621;15624;15873;15874;15876;15877;15878;15879;15880;15882;16129;16130;16131;16132', 0);


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
) ENGINE=MyISAM AUTO_INCREMENT=2  ;


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
) ENGINE=MyISAM  ;


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
) ENGINE=MyISAM AUTO_INCREMENT=5  ;


### Data of table `0_stock_category` ###

INSERT INTO `0_stock_category` VALUES ('1', 'Components', '0', '1', 'each', 'B', '9111', '8140', '2690', '2690', '2690', '0', '0', '0');
INSERT INTO `0_stock_category` VALUES ('2', 'Charges', '0', '1', 'each', 'B', '9111', '8140', '2690', '2690', '2690', '0', '0', '0');
INSERT INTO `0_stock_category` VALUES ('3', 'Systems', '0', '1', 'each', 'B', '9111', '8140', '2690', '2690', '2690', '0', '0', '0');
INSERT INTO `0_stock_category` VALUES ('4', 'Services', '0', '1', 'each', 'B', '9111', '8140', '2690', '2690', '2690', '0', '0', '0');


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
) ENGINE=InnoDB  ;


### Data of table `0_stock_master` ###

INSERT INTO `0_stock_master` VALUES ('1', '1', '3', 'Kék papír', '', 'ea.', 'M', '9111', '8140', '2690', '2690', '2690', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');


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
) ENGINE=InnoDB  ;


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
) ENGINE=InnoDB  ;


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
) ENGINE=InnoDB  ;


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
) ENGINE=InnoDB  ;


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
) ENGINE=MyISAM AUTO_INCREMENT=2  ;


### Data of table `0_suppliers` ###

INSERT INTO `0_suppliers` VALUES ('1', 'Adoniss', '', '', '', '', '', '', '', 'HUF', '4', '0', '0', '0', '2', '0', '8140', '4541', '8140', '', '0', 'Adoniss');


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
) ENGINE=MyISAM  ;


### Data of table `0_sys_prefs` ###

INSERT INTO `0_sys_prefs` VALUES ('coy_name', 'setup.company', 'varchar', '60', 'Company name');
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
INSERT INTO `0_sys_prefs` VALUES ('curr_default', 'setup.company', 'char', '3', 'HUF');
INSERT INTO `0_sys_prefs` VALUES ('use_dimension', 'setup.company', 'tinyint', '1', '1');
INSERT INTO `0_sys_prefs` VALUES ('f_year', 'setup.company', 'int', '11', '1');
INSERT INTO `0_sys_prefs` VALUES ('no_item_list', 'setup.company', 'tinyint', '1', '0');
INSERT INTO `0_sys_prefs` VALUES ('no_customer_list', 'setup.company', 'tinyint', '1', '0');
INSERT INTO `0_sys_prefs` VALUES ('no_supplier_list', 'setup.company', 'tinyint', '1', '0');
INSERT INTO `0_sys_prefs` VALUES ('base_sales', 'setup.company', 'int', '11', '0');
INSERT INTO `0_sys_prefs` VALUES ('time_zone', 'setup.company', 'tinyint', '1', '0');
INSERT INTO `0_sys_prefs` VALUES ('add_pct', 'setup.company', 'int', '5', '-1');
INSERT INTO `0_sys_prefs` VALUES ('round_to', 'setup.company', 'int', '5', '1');
INSERT INTO `0_sys_prefs` VALUES ('login_tout', 'setup.company', 'smallint', '6', '600');
INSERT INTO `0_sys_prefs` VALUES ('past_due_days', 'glsetup.general', 'int', '11', '30');
INSERT INTO `0_sys_prefs` VALUES ('profit_loss_year_act', 'glsetup.general', 'varchar', '15', '9990');
INSERT INTO `0_sys_prefs` VALUES ('retained_earnings_act', 'glsetup.general', 'varchar', '15', '2050');
INSERT INTO `0_sys_prefs` VALUES ('bank_charge_act', 'glsetup.general', 'varchar', '15', '1430');
INSERT INTO `0_sys_prefs` VALUES ('exchange_diff_act', 'glsetup.general', 'varchar', '15', '9111');
INSERT INTO `0_sys_prefs` VALUES ('default_credit_limit', 'glsetup.customer', 'int', '11', '1000');
INSERT INTO `0_sys_prefs` VALUES ('accumulate_shipping', 'glsetup.customer', 'tinyint', '1', '0');
INSERT INTO `0_sys_prefs` VALUES ('legal_text', 'glsetup.customer', 'tinytext', '0', NULL);
INSERT INTO `0_sys_prefs` VALUES ('freight_act', 'glsetup.customer', 'varchar', '15', '8140');
INSERT INTO `0_sys_prefs` VALUES ('debtors_act', 'glsetup.sales', 'varchar', '15', '3111');
INSERT INTO `0_sys_prefs` VALUES ('default_sales_act', 'glsetup.sales', 'varchar', '15', '9111');
INSERT INTO `0_sys_prefs` VALUES ('default_sales_discount_act', 'glsetup.sales', 'varchar', '15', '9111');
INSERT INTO `0_sys_prefs` VALUES ('default_prompt_payment_act', 'glsetup.sales', 'varchar', '15', '9111');
INSERT INTO `0_sys_prefs` VALUES ('default_delivery_required', 'glsetup.sales', 'smallint', '6', '1');
INSERT INTO `0_sys_prefs` VALUES ('default_dim_required', 'glsetup.dims', 'int', '11', '20');
INSERT INTO `0_sys_prefs` VALUES ('pyt_discount_act', 'glsetup.purchase', 'varchar', '15', '8140');
INSERT INTO `0_sys_prefs` VALUES ('creditors_act', 'glsetup.purchase', 'varchar', '15', '4541');
INSERT INTO `0_sys_prefs` VALUES ('po_over_receive', 'glsetup.purchase', 'int', '11', '10');
INSERT INTO `0_sys_prefs` VALUES ('po_over_charge', 'glsetup.purchase', 'int', '11', '10');
INSERT INTO `0_sys_prefs` VALUES ('allow_negative_stock', 'glsetup.inventory', 'tinyint', '1', '0');
INSERT INTO `0_sys_prefs` VALUES ('default_inventory_act', 'glsetup.items', 'varchar', '15', '2690');
INSERT INTO `0_sys_prefs` VALUES ('default_cogs_act', 'glsetup.items', 'varchar', '15', '8140');
INSERT INTO `0_sys_prefs` VALUES ('default_adj_act', 'glsetup.items', 'varchar', '15', '2690');
INSERT INTO `0_sys_prefs` VALUES ('default_inv_sales_act', 'glsetup.items', 'varchar', '15', '9111');
INSERT INTO `0_sys_prefs` VALUES ('default_assembly_act', 'glsetup.items', 'varchar', '15', '2690');
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
) ENGINE=InnoDB  ;


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
) ENGINE=MyISAM  ;


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
) ENGINE=MyISAM  ;


### Data of table `0_tags` ###



### Structure of table `0_tax_group_items` ###

DROP TABLE IF EXISTS `0_tax_group_items`;

CREATE TABLE `0_tax_group_items` (
  `tax_group_id` int(11) NOT NULL default '0',
  `tax_type_id` int(11) NOT NULL default '0',
  `rate` double NOT NULL default '0',
  PRIMARY KEY  (`tax_group_id`,`tax_type_id`)
) ENGINE=InnoDB  ;


### Data of table `0_tax_group_items` ###

INSERT INTO `0_tax_group_items` VALUES ('2', '1', '20');
INSERT INTO `0_tax_group_items` VALUES ('3', '1', '5');


### Structure of table `0_tax_groups` ###

DROP TABLE IF EXISTS `0_tax_groups`;

CREATE TABLE `0_tax_groups` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(60) NOT NULL default '',
  `tax_shipping` tinyint(1) NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4  ;


### Data of table `0_tax_groups` ###

INSERT INTO `0_tax_groups` VALUES ('2', 'Előzetesen felszámított 20%', '0', '0');
INSERT INTO `0_tax_groups` VALUES ('3', 'Fizetendő 20%', '0', '0');


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
) ENGINE=InnoDB AUTO_INCREMENT=4  ;


### Data of table `0_tax_types` ###

INSERT INTO `0_tax_types` VALUES ('1', '20', '4661', '4671', 'VAT', '0');
INSERT INTO `0_tax_types` VALUES ('2', '5', '4662', '4667', 'VAT', '0');
INSERT INTO `0_tax_types` VALUES ('3', '0', '4663', '4673', 'VAT', '0');


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
) ENGINE=InnoDB  ;


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
) ENGINE=MyISAM  ;


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
) ENGINE=MyISAM AUTO_INCREMENT=2  ;


### Data of table `0_users` ###

INSERT INTO `0_users` VALUES ('1', 'admin', '5f4dcc3b5aa765d61d8327deb882cf99', 'Administrator', '2', '', 'info@startit.hu', 'hu_HU', '2', '2', '0', '0', 'default', 'A4', '2', '2', '6', '1', '1', '1', '1', '2009-06-27 14:27:12', '10', '1', '1', '', '1', '0', 'orders', '0');


### Structure of table `0_voided` ###

DROP TABLE IF EXISTS `0_voided`;

CREATE TABLE `0_voided` (
  `type` int(11) NOT NULL default '0',
  `id` int(11) NOT NULL default '0',
  `date_` date NOT NULL default '0000-00-00',
  `memo_` tinytext NOT NULL,
  UNIQUE KEY `id` (`type`,`id`)
) ENGINE=InnoDB  ;


### Data of table `0_voided` ###



### Structure of table `0_wo_issue_items` ###

DROP TABLE IF EXISTS `0_wo_issue_items`;

CREATE TABLE `0_wo_issue_items` (
  `id` int(11) NOT NULL auto_increment,
  `stock_id` varchar(40) default NULL,
  `issue_id` int(11) default NULL,
  `qty_issued` double default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  ;


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
) ENGINE=InnoDB  ;


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
) ENGINE=InnoDB  ;


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
) ENGINE=InnoDB  ;


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
) ENGINE=MyISAM  ;


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
) ENGINE=InnoDB  ;


### Data of table `0_workorders` ###

