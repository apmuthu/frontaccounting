# MySQL dump of database 'administration' on host 'localhost'
# Backup Date and Time: 2013-01-06 20:31
# Built by Finyu.nl 2.3.12
# http://www.mpe-solutions.nl
# Company: Naam Administratie
# User: 


### Structure of table `0_areas` ###

DROP TABLE IF EXISTS `0_areas`;

CREATE TABLE `0_areas` (
  `area_code` int(11) NOT NULL auto_increment,
  `description` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`area_code`),
  UNIQUE KEY `description` (`description`)
) ENGINE=MyISAM;

### Data of table `0_areas` ###

INSERT INTO `0_areas` VALUES
('1', 'Nederland', '0'),
('2', 'Binnen EU', '0'),
('3', 'Buiten EU', '0');


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
) ENGINE=MyISAM;

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
) ENGINE=InnoDB;

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
) ENGINE=MyISAM;

### Data of table `0_bank_accounts` ###

INSERT INTO `0_bank_accounts` VALUES
('1010', '2', 'XYZ Bank betaalrekening', '12345678', 'XYZ Bank', 'Adres bank 1\n1234 AB PLAATS BANK', 'EUR', '1', '1', '0000-00-00 00:00:00', '0', '0'),
('1000', '3', 'Kas', 'N/A', 'N/A', 'N/A', 'EUR', '0', '2', '0000-00-00 00:00:00', '0', '0'),
('1020', '0', 'XYZ Bank spaarrekening', '12345678', 'XYZ Bank', 'Adres bank 1 \n1234 AB PLAATS BANK', 'EUR', '0', '4', '0000-00-00 00:00:00', '0', '0');

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
) ENGINE=InnoDB ;

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
) ENGINE=MyISAM ;

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
) ENGINE=InnoDB ;

### Data of table `0_budget_trans` ###


### Structure of table `0_chart_class` ###

DROP TABLE IF EXISTS `0_chart_class`;

CREATE TABLE `0_chart_class` (
  `cid` varchar(3) NOT NULL,
  `class_name` varchar(60) NOT NULL default '',
  `ctype` tinyint(1) NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`cid`)
) ENGINE=MyISAM ;

### Data of table `0_chart_class` ###

INSERT INTO `0_chart_class` VALUES
('1', 'Activa', '1', '0'),
('2', 'Passiva', '2', '0'),
('4', 'Opbrengsten', '4', '0'),
('6', 'Kosten', '6', '0'),
('3', 'Eigen Vermogen', '3', '0'),
('5', 'Kostprijs Omzet', '5', '0'),
('7', 'Overige', '6', '0');

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
) ENGINE=MyISAM ;

### Data of table `0_chart_master` ###

INSERT INTO `0_chart_master` VALUES
('5001', '', 'Opslag indirecte fabricagekosten', '96', '0'),
('5000', '', 'Indirecte fabricagekosten', '96', '0'),
('4860', '', 'Afschrijving niet aan de bedrijfsuitoefening dienstbare acti', '62', '0'),
('4855', '', 'Afschrijving materiele vaste activa in uitvoering', '62', '0'),
('4850', '', 'Afschrijving andere vaste bedrijfsmiddelen', '62', '0'),
('4845', '', 'Afschrijving vervoermiddelen', '62', '0'),
('4840', '', 'Afschrijving software', '62', '0'),
('4835', '', 'Afschrijving computers', '62', '0'),
('4830', '', 'Afschrijving inventaris', '62', '0'),
('4825', '', 'Afschrijving machines en installaties', '62', '0'),
('4820', '', 'Afschrijving bedrijfsgebouwen en -terreinen', '62', '0'),
('4805', '', 'Afschrijving overige immateriele vaste activa', '62', '0'),
('4800', '', 'Afschrijving goodwill', '62', '0'),
('4699', '', 'Overige algemene kosten', '646', '0'),
('4620', '', 'Voorziening dubieuze debiteuren', '646', '0'),
('4615', '', 'Incassokosten', '646', '0'),
('4610', '', 'Boetes', '646', '0'),
('4600', '', 'Contributies en abonnementen', '646', '0'),
('4605', '', 'Vergunningen', '646', '0'),
('4599', '', 'Overige IT- en communicatiekosten', '645', '0'),
('4520', '', 'Webhosting', '645', '0'),
('4515', '', 'Automatisering', '645', '0'),
('4510', '', 'Internetverbinding', '645', '0'),
('4499', '', 'Overige marketing- en verkoopkosten', '644', '0'),
('4500', '', 'Telefoonkosten', '645', '0'),
('4420', '', 'Transport- en verzendkosten', '644', '0'),
('4415', '', 'Congressen en seminars', '644', '0'),
('4410', '', 'Drukwerk', '644', '0'),
('4405', '', 'Sponsoring', '644', '0'),
('4400', '', 'Reclame', '644', '0'),
('4399', '', 'Overige reis- en verblijfkosten', '643', '0'),
('4330', '', 'Overnachtingen', '643', '0'),
('4320', '', 'Auto onderhoud en overige kosten', '643', '0'),
('4325', '', 'Eten en drinken', '643', '0'),
('4310', '', 'Auto brandstofkosten', '643', '0'),
('4315', '', 'Auto verzekering en wegenbelasting', '643', '0'),
('4300', '', 'Representatiekosten', '643', '0'),
('4305', '', 'Auto leasekosten', '643', '0'),
('4220', '', 'Porti', '642', '0'),
('4299', '', 'Overige advies- en administratiekosten', '642', '0'),
('4215', '', 'Kantoorartikelen', '642', '0'),
('4205', '', 'Advieskosten', '642', '0'),
('4210', '', 'Notarius- en advocaatkosten', '642', '0'),
('4200', '', 'Administratiekosten', '642', '0'),
('4199', '', 'Overige huisvestingskosten', '641', '0'),
('4145', '', 'Dotatie groot onderhoud huisvesting', '641', '0'),
('4140', '', 'Belastingen en heffingen huisvesting', '641', '0'),
('4135', '', 'Klein onderhoud/reparaties', '641', '0'),
('4130', '', 'Erfpacht', '641', '0'),
('4125', '', 'Verzekering', '641', '0'),
('4105', '', 'Gas, water en elektra', '641', '0'),
('4120', '', 'Schoonmaak', '641', '0'),
('4100', '', 'Huur', '641', '0'),
('4099', '', 'Overige sociale lasten', '61', '0'),
('4080', '', 'Pensioenlasten', '61', '0'),
('4085', '', 'Ziekengeld verzekering', '61', '0'),
('4075', '', 'Eindheffing loonheffing', '61', '0'),
('4070', '', 'Premies sociale verzekeringen', '61', '0'),
('4069', '', 'Overige personeelskosten', '60', '0'),
('4040', '', 'Reiskosten (km-vergoeding)', '60', '0'),
('4045', '', 'Onkostenvergoeding', '60', '0'),
('4030', '', 'Vakantiedagen', '60', '0'),
('4035', '', 'Ontslagvergoeding', '60', '0'),
('4020', '', 'Uitzendkrachten', '60', '0'),
('4025', '', 'Vakantiegeld', '60', '0'),
('4015', '', 'Managementvergoeding', '60', '0'),
('4010', '', 'Bonussen', '60', '0'),
('4005', '', 'Bruto salarissen directie', '60', '0'),
('3400', '', 'Onderhanden projecten', '15', '0'),
('4000', '', 'Bruto salarissen personeel', '60', '0'),
('3300', '', 'Vooruitbetaald op voorraden', '14', '0'),
('3200', '', 'Gereed product en handelsgoederen', '14', '0'),
('3100', '', 'Onderhanden werk/product in bewerking', '14', '0'),
('3000', '', 'Grond- en hulpstoffen ', '14', '0'),
('2030', '', 'Tussenrekening 3', '163', '0'),
('2040', '', 'Tussenrekening 4', '163', '0'),
('2010', '', 'Tussenrekening 1', '163', '0'),
('2020', '', 'Tussenrekening 2', '163', '0'),
('2000', '', 'Kruisposten', '18', '0'),
('1899', '', 'Te corrigeren BTW ', '234', '0'),
('1885', '', 'Vermindering volgens de kleineondernemersregeling', '234', '0'),
('1880', '', 'Leveringen/diensten waarbij heffing OB naar u is verlegd', '234', '0'),
('1875', '', 'Verwervingen van goederen uit landen binnen de EU', '234', '0'),
('1870', '', 'Leveringen uit landen buiten de EU (invoer)', '234', '0'),
('1865', '', 'Leveringen naar landen binnen de EU', '234', '0'),
('1860', '', 'Leveringen naar landen buiten de EU (uitvoer)', '234', '0'),
('1855', '', 'BTW Prive gebruik', '234', '0'),
('1850', '', 'BTW Buitenland', '234', '0'),
('1820', '', 'BTW Laag (6%) te vorderen', '234', '0'),
('1825', '', 'BTW Laag (6%) te betalen', '234', '0'),
('1810', '', 'BTW Hoog (21%) te vorderen', '234', '0'),
('1815', '', 'BTW Hoog (21%) te betalen', '234', '0'),
('1800', '', 'BTW Afdracht', '234', '0'),
('1730', '', 'Te betalen premies en sociale lasten werkgever', '233', '0'),
('1720', '', 'Te betalen loonheffing', '233', '0'),
('1700', '', 'Ingehouden loonheffing', '233', '0'),
('1710', '', 'Te betalen pensioenpremies', '233', '0'),
('1695', '', 'R/C Aandeelhouder', '235', '0'),
('1699', '', 'Overige kortlopende schulden ', '235', '0'),
('1690', '', 'R/C Prive', '235', '0'),
('1685', '', 'R/C Personeel', '235', '0'),
('1680', '', 'Schulden aan verbonden partijen (kortlopend)', '235', '0'),
('1675', '', 'Vooruitontvangen bedragen', '235', '0'),
('1670', '', 'Kortlopend deel langlopende schulden', '235', '0'),
('1665', '', 'Te betalen vennootschapsbelasting', '235', '0'),
('1660', '', 'Te betalen netto lonen', '235', '0'),
('1655', '', 'Te betalen bankrente', '235', '0'),
('1605', '', 'Nog te ontvangen inkoopfacturen', '232', '0'),
('1650', '', 'Overlopende passiva', '235', '0'),
('1399', '', 'Overige overlopende activa', '163', '0'),
('1600', '', 'Handelscrediteuren', '232', '0'),
('1370', '', 'Vraagposten', '163', '0'),
('1365', '', 'Vooruitbetaalde kosten', '163', '0'),
('1360', '', 'Nog te ontvangen bankrente', '163', '0'),
('1355', '', 'Nog te ontvangen goederen en diensten', '163', '0'),
('1350', '', 'Nog te factureren omzet', '163', '0'),
('1349', '', 'Overige kortlopende vorderingen', '162', '0'),
('1330', '', 'Te vorderen vennootschapsbelasting', '162', '0'),
('1325', '', 'R/C personeel', '162', '0'),
('1320', '', 'Kortlopende vorderingen op participanten', '162', '0'),
('1315', '', 'Kortlopende vorderingen op overige deelnemingen', '162', '0'),
('1310', '', 'Kortlopende vorderingen op groepsmaatschappijen', '162', '0'),
('1306', '', 'Voorziening voor dubieuze debiteuren', '161', '0'),
('1305', '', 'Dubieuze debiteuren', '161', '0'),
('1300', '', 'Handelsdebiteuren', '161', '0'),
('1299', '', 'Overige effecten zonder beursnotering', '17', '0'),
('1210', '', 'Overige effecten met beursnotering', '17', '0'),
('1205', '', 'Effecten zonder beursnotering van verbonden partijen', '17', '0'),
('1200', '', 'Effecten met beursnotering van verbonden partijen ', '17', '0'),
('1050', '', 'Rekening courant kredietinstellingen', '231', '0'),
('1020', '', 'Bank spaarrekening', '18', '0'),
('1030', '', 'Wissels en cheques', '18', '0'),
('999', '', 'Onverdeelde resultaat huidig boekjaar', '90', '0'),
('1000', '', 'Kas', '18', '0'),
('1010', '', 'Bank betaalrekening', '18', '0'),
('845', '', 'Overige reserve', '305', '0'),
('900', '', 'Onverdeeld resultaat voorgaande boekjaren', '305', '0'),
('830', '', 'Herinvesteringreserve', '304', '0'),
('840', '', 'Algemene reserve', '305', '0'),
('820', '', 'Wettelijke reserve', '304', '0'),
('825', '', 'Statutaire reserve', '304', '0'),
('800', '', 'Agioreserve', '302', '0'),
('810', '', 'Herwaardering reserve', '303', '0'),
('799', '', 'Overige langlopende schulden ', '22', '0'),
('725', '', 'Schulden aan verbonden partijen (langlopend)', '22', '0'),
('720', '', 'Langlopende schuld aan kredietinstellingen', '22', '0'),
('710', '', 'Andere obligaties en onderhandse leningen', '22', '0'),
('705', '', 'Converteerbare leningen', '22', '0'),
('699', '', 'Overige voorzieningen', '21', '0'),
('700', '', 'Hypothecaire lening', '22', '0'),
('640', '', 'Voorziening verlieslatende contracten', '21', '0'),
('620', '', 'Voorziening groot onderhoud', '21', '0'),
('630', '', 'Voorziening belastinglatentie', '21', '0'),
('610', '', 'Garantievoorziening', '21', '0'),
('600', '', 'Pensioenvoorziening', '21', '0'),
('535', '', 'Fiscale oudedagreserve (FOR)', '301', '0'),
('599', '', 'Overige prive kapitaal', '301', '0'),
('530', '', 'Prive ziektekosten', '301', '0'),
('520', '', 'Prive stortingen', '301', '0'),
('525', '', 'Prive belastingen', '301', '0'),
('515', '', 'Prive opnamen', '301', '0'),
('510', '', 'Kapitaal eigenaar 2', '301', '0'),
('505', '', 'Kapitaal eigenaar 1', '301', '0'),
('500', '', 'Aandelenkapitaal', '301', '0'),
('350', '', 'Overige (langlopende) vorderingen en leningen', '13', '0'),
('340', '', 'Overige (langlopende) effecten', '13', '0'),
('330', '', 'Vorderingen op andere deelnemingen en participanten', '13', '0'),
('320', '', 'Andere deelnemingen', '13', '0'),
('310', '', 'Vorderingen op overige verbonden maatschappijen', '13', '0'),
('300', '', 'Deelnemingen in overige verbonden maatschappijen', '13', '0'),
('281', '', 'Cum afschrijving niet aan de bedrijfsuitoefening dienstbare ', '12', '0'),
('280', '', 'Aanschafwaarde niet aan de bedrijfsuitoefening dienstbare ac', '12', '0'),
('271', '', 'Cum afschrijving materiele vaste activa in uitvoering', '12', '0'),
('270', '', 'Aanschafwaarde materiele vaste activa in uitvoering', '12', '0'),
('261', '', 'Cum afschrijving andere vaste bedrijfsmiddelen', '12', '0'),
('260', '', 'Aanschafwaarde andere vaste bedrijfsmiddelen', '12', '0'),
('251', '', 'Cum afschrijving vervoermiddelen', '12', '0'),
('250', '', 'Aanschafwaarde vervoermiddelen', '12', '0'),
('241', '', 'Cum afschrijving software', '12', '0'),
('240', '', 'Aanschafwaarde software', '12', '0'),
('231', '', 'Cum afschrijving computers', '12', '0'),
('230', '', 'Aanschafwaarde computers', '12', '0'),
('221', '', 'Cum afschrijving inventaris en inrichting', '12', '0'),
('220', '', 'Aanschafwaarde inventaris en inrichting', '12', '0'),
('211', '', 'Cum afschrijving machines en installaties', '12', '0'),
('210', '', 'Aanschafwaarde machines en installaties', '12', '0'),
('201', '', 'Cum afschrijving bedrijfsgebouwen en -terreinen', '12', '0'),
('200', '', 'Aanschafwaarde bedrijfsgebouwen en -terreinen', '12', '0'),
('130', '', 'Vooruitbetaald op immateriele vaste activa', '11', '0'),
('120', '', 'Goodwill', '11', '0'),
('110', '', 'Concessies, vergunningen en intellectueel eigendom', '11', '0'),
('100', '', 'Ontwikkelingskosten', '11', '0'),
('5010', '', 'Indirecte verkoopkosten', '96', '0'),
('5011', '', 'Opslag indirecte verkoopkosten', '96', '0'),
('5099', '', 'Overboekingsrekening kosten', '96', '0'),
('6000', '', 'Fabricagerekening/kosten', '97', '0'),
('6005', '', 'Gecalculeerde fabricagekosten', '97', '0'),
('6010', '', 'Verbruik grondstoffen', '97', '0'),
('6011', '', 'Directe lonen', '97', '0'),
('6012', '', 'Toeslag indirecte fabricagekosten', '97', '0'),
('6020', '', 'Standaard verbruik grondstoffen', '97', '0'),
('6021', '', 'Standaard verbruik directe lonen', '97', '0'),
('6022', '', 'Standaardtoeslag indirecte fabricagekosten', '97', '0'),
('6099', '', 'Overboekingsrekening fabricage', '97', '0'),
('7000', '', 'Mutatie onderhanden werk', '50', '0'),
('7010', '', 'Mutatie voorraad gereed product', '50', '0'),
('8000', '', 'Omzet dienstverlening', '40', '0'),
('8010', '', 'Omzet verkoop goederen', '40', '0'),
('8020', '', 'Omzet overige', '40', '0'),
('8100', '', 'Kostprijs omzet dienstverlening', '50', '0'),
('8110', '', 'Kostprijs omzet verkoop goederen', '50', '0'),
('8120', '', 'Kostprijs omzet overige', '50', '0'),
('8150', '', 'Ontvangen inkoopkortingen', '50', '0'),
('8160', '', 'Voorraadverschillen', '50', '0'),
('8300', '', 'Verstrekte kortingen bij verkoop', '40', '0'),
('8310', '', 'Verstrekte kortingen betaling debiteuren', '40', '0'),
('8800', '', 'Overige buitengewone baten', '41', '0'),
('8810', '', 'Overige buitengewone lasten', '41', '0'),
('8820', '', 'Opbrengst kleinondernemersregeling BTW', '41', '0'),
('8900', '', 'Resultaat deelnemingen', '90', '0'),
('9000', '', 'Rentebaten bankrekeningen', '70', '0'),
('9005', '', 'Rentebaten debiteuren', '70', '0'),
('9010', '', 'Rentebaten overige', '70', '0'),
('9015', '', 'Rentelasten bankrekeningen', '70', '0'),
('9020', '', 'Rentelasten crediteuren', '70', '0'),
('9025', '', 'Rentelasten overige', '70', '0'),
('9030', '', 'Koersverschillen', '70', '0'),
('9035', '', 'Betalingsverschillen', '70', '0'),
('9040', '', 'Bankkosten', '70', '0'),
('9099', '', 'Overige financiele baten en -lasten', '70', '0'),
('9600', '', 'Vennootschapsbelasting', '80', '0'),
('9699', '', 'Overige winstbelasting', '80', '0');

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
) ENGINE=MyISAM;

### Data of table `0_chart_types` ###

INSERT INTO `0_chart_types` VALUES
('18', 'LIQUIDE MIDDELEN', '1', '', '0'),
('14', 'VOORRADEN', '1', '', '0'),
('12', 'MATERIELE VASTE ACTIVA', '1', '', '0'),
('23', 'KORTLOPENDE SCHULDEN', '2', '', '0'),
('22', 'LANGLOPENDE SCHULDEN', '2', '', '0'),
('301', 'GESTORT EN OPGEVRAAGD KAPITAAL', '3', '30', '0'),
('305', 'OVERIGE RESERVES', '3', '30', '0'),
('40', 'OMZET', '4', '', '0'),
('50', 'KOSTPRIJS VERKOPEN', '5', '', '0'),
('60', 'LONEN EN SALARISSEN', '6', '', '0'),
('641', 'HUISVESTINGSKOSTEN', '6', '64', '0'),
('61', 'SOCIALE LASTEN', '6', '', '0'),
('642', 'ADVIES- EN ADMINISTRATIEKOSTEN', '6', '64', '0'),
('231', 'BANKEN / KREDIETINSTELLINGEN', '2', '23', '0'),
('63', 'OVERIGE WAARDEVERANDERINGEN', '6', '', '0'),
('64', 'OVERIGE BEDRIJFSKOSTEN', '6', '', '0'),
('16', 'OVERIGE VORDERINGEN', '1', '', '0'),
('15', 'ONDERHANDEN PROJECTEN', '1', '', '0'),
('70', 'FINANCIELE BATEN EN -LASTEN', '7', '', '0'),
('645', 'IT- EN COMMUNICATIEKOSTEN', '6', '64', '0'),
('62', 'AFSCHRIJVINGEN OP VASTE ACTIVA', '6', '', '0'),
('234', 'BTW', '2', '23', '0'),
('95', 'SYSTEEMREKENINGEN', '7', '', '0'),
('233', 'LOONHEFFING / SOCIALE LASTEN', '2', '23', '0'),
('13', 'FINANCIELE VASTE ACTIVA', '1', '', '0'),
('11', 'IMMATERIELE VASTE ACTIVA', '1', '', '0'),
('17', 'EFFECTEN', '1', '', '0'),
('30', 'EIGEN VERMOGEN', '3', '', '0'),
('302', 'AGIO', '3', '30', '0'),
('303', 'HERWAARDERING RESERVES', '3', '30', '0'),
('304', 'WETTELIJKE EN STATUTAIRE RESERVES', '3', '30', '0'),
('21', 'VOORZIENINGEN', '2', '', '0'),
('232', 'HANDELSCREDITEUREN / LEVERANCIERS', '2', '23', '0'),
('235', 'OVERIGE SCHULDEN / OVERLOPENDE PASSIVA', '2', '23', '0'),
('643', 'REIS- EB VERBLIJFKOSTEN', '6', '64', '0'),
('644', 'MARKETING- EN VERKOOPKOSTEN', '6', '64', '0'),
('646', 'OVERIGE BEDRIJFSKOSTEN', '6', '64', '0'),
('80', 'WINSTBELASTINGEN', '7', '', '0'),
('90', 'RESULTAAT', '7', '', '0'),
('41', 'OVERIGE OPBRENGSTEN', '4', '', '0'),
('161', 'HANDELSDEBITEUREN', '1', '16', '0'),
('162', 'OVERIGE VORDERINGEN', '1', '16', '0'),
('163', 'OVERLOPENDE ACTIVA', '1', '16', '0'),
('96', 'VERDELING INDIRECTE KOSTEN', '7', '95', '0'),
('97', 'FABRICAGEREKENINGEN', '7', '95', '0');

### Structure of table `0_comments` ###

DROP TABLE IF EXISTS `0_comments`;

CREATE TABLE `0_comments` (
  `type` int(11) NOT NULL default '0',
  `id` int(11) NOT NULL default '0',
  `date_` date default '0000-00-00',
  `memo_` tinytext,
  KEY `type_and_id` (`type`,`id`)
) ENGINE=InnoDB ;

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
) ENGINE=MyISAM;

### Data of table `0_credit_status` ###

INSERT INTO `0_credit_status` VALUES
('1', 'Geen bijzonderheden ten aanzien van betaalgedrag', '0', '0'),
('3', 'Geen nieuwe orders totdat oude orders zijn betaald', '1', '0'),
('4', 'Geen orders aannemen!', '1', '0');

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
) ENGINE=InnoDB;

### Data of table `0_crm_categories` ###

INSERT INTO `0_crm_categories` VALUES
('1', 'cust_branch', 'general', 'General', 'General contact data for customer branch (overrides company setting)', '1', '0'),
('2', 'cust_branch', 'invoice', 'Invoices', 'Invoice posting (overrides company setting)', '1', '0'),
('3', 'cust_branch', 'order', 'Orders', 'Order confirmation (overrides company setting)', '1', '0'),
('4', 'cust_branch', 'delivery', 'Deliveries', 'Delivery coordination (overrides company setting)', '1', '0'),
('5', 'customer', 'general', 'Algemeen', 'Algemene contactpersoon', '1', '0'),
('6', 'customer', 'order', 'Verkopen', 'Verkoop contactpersoon', '1', '0'),
('7', 'customer', 'delivery', 'Deliveries', 'Delivery coordination', '1', '0'),
('8', 'customer', 'invoice', 'Administratie', 'Administratieve contactpersoon', '1', '0'),
('9', 'supplier', 'general', 'General', 'General contact data for supplier', '1', '0'),
('10', 'supplier', 'order', 'Orders', 'Order confirmation', '1', '0'),
('11', 'supplier', 'delivery', 'Deliveries', 'Delivery coordination', '1', '0'),
('12', 'supplier', 'invoice', 'Invoices', 'Invoice posting', '1', '0');

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
) ENGINE=InnoDB;

### Data of table `0_crm_contacts` ###

INSERT INTO `0_crm_contacts` VALUES
('1', '1', 'supplier', 'general', '1'),
('2', '2', 'supplier', 'general', '2'),
('3', '3', 'supplier', 'general', '3'),
('4', '4', 'cust_branch', 'general', '1'),
('5', '5', 'supplier', 'general', '4'),
('7', '6', 'customer', 'general', '3'),
('8', '7', 'cust_branch', 'general', '2'),
('9', '8', 'supplier', 'general', '5'),
('10', '1', 'cust_branch', 'general', '3'),
('11', '2', 'supplier', 'general', '6'),
('12', '3', 'supplier', 'general', '7'),
('13', '4', 'cust_branch', 'general', '4');

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
) ENGINE=InnoDB;

### Data of table `0_crm_persons` ###

INSERT INTO `0_crm_persons` VALUES
('1', 'Algemene debiteur', 'Algemene debiteur', NULL, 'Algemene debiteur', NULL, NULL, NULL, NULL, NULL, '', '0'),
('2', 'Algemene crediteur', '', NULL, 'Algemene crediteur', NULL, NULL, NULL, NULL, NULL, '', '0'),
('3', 'Algemene leverancier', '', NULL, 'Algemene leverancier', NULL, NULL, NULL, NULL, NULL, '', '0'),
('4', 'Algemene debiteur', 'Algemene debiteur', NULL, 'Algemene debiteur', NULL, NULL, NULL, NULL, NULL, '', '0');

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
) ENGINE=MyISAM ;

### Data of table `0_currencies` ###

INSERT INTO `0_currencies` VALUES
('Euro', 'EUR', '?', 'Nederland', 'Eurocent', '0', '1'),
('USD', 'USD', '$', 'United States', 'Cents', '0', '1'),
('GBP', 'GBP', '£', 'England', 'Pence', '0', '1'),
('JPY', 'JPY', '¥', 'Japan', 'Yen', '0', '1');

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
) ENGINE=InnoDB ;

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
) ENGINE=MyISAM;

### Data of table `0_cust_branch` ###

INSERT INTO `0_cust_branch` VALUES
('4', '5', 'Algemene debiteur', 'Algemene debiteur', '2', '5', '', 'DEF', '5', '', '8300', '1300', '8310', '3', '0', 'Algemene debiteur', '0', 'Algemene debiteur', '0', 'Algemene debiteur');

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
) ENGINE=InnoDB ;

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
) ENGINE=InnoDB ;

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
  UNIQUE KEY `debtor_ref` (`debtor_ref`),
  KEY `name` (`name`)
) ENGINE=MyISAM;

### Data of table `0_debtors_master` ###

INSERT INTO `0_debtors_master` VALUES
('5', 'Algemene debiteur', 'Algemene debiteur', '', 'EUR', '1', '0', '0', '1', '3', '0', '0', '1000', 'Algemene debiteur', '0', 'Algemene debiteur');

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
) ENGINE=InnoDB ;

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
) ENGINE=MyISAM;

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
) ENGINE=InnoDB;

### Data of table `0_fiscal_year` ###

INSERT INTO `0_fiscal_year` VALUES
('3', '2011-01-01', '2011-12-31', '1'),
('4', '2012-01-01', '2012-12-31', '1'),
('5', '2013-01-01', '2013-12-31', '0');

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
) ENGINE=InnoDB ;

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
) ENGINE=InnoDB ;

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
) ENGINE=InnoDB ;

### Data of table `0_grn_items` ###


### Structure of table `0_groups` ###

DROP TABLE IF EXISTS `0_groups`;

CREATE TABLE `0_groups` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `description` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `description` (`description`)
) ENGINE=MyISAM;

### Data of table `0_groups` ###

INSERT INTO `0_groups` VALUES
('1', 'Klein', '0'),
('2', 'Middel', '0'),
('3', 'Groot', '0');

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
) ENGINE=MyISAM;

### Data of table `0_item_codes` ###

INSERT INTO `0_item_codes` VALUES
('23', 'ARBEID', 'ARBEID', 'Arbeid', '11', '1', '0', '0');

### Structure of table `0_item_tax_type_exemptions` ###

DROP TABLE IF EXISTS `0_item_tax_type_exemptions`;

CREATE TABLE `0_item_tax_type_exemptions` (
  `item_tax_type_id` int(11) NOT NULL default '0',
  `tax_type_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`item_tax_type_id`,`tax_type_id`)
) ENGINE=InnoDB ;

### Data of table `0_item_tax_type_exemptions` ###

INSERT INTO `0_item_tax_type_exemptions` VALUES
('9', '8'),
('9', '9'),
('10', '7'),
('10', '9'),
('12', '8'),
('12', '9'),
('13', '7'),
('13', '9'),
('15', '8'),
('15', '9'),
('16', '7'),
('16', '9');

### Structure of table `0_item_tax_types` ###

DROP TABLE IF EXISTS `0_item_tax_types`;

CREATE TABLE `0_item_tax_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(60) NOT NULL default '',
  `exempt` tinyint(1) NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB;

### Data of table `0_item_tax_types` ###

INSERT INTO `0_item_tax_types` VALUES
('9', 'Goederen (21%)', '0', '0'),
('10', 'Goederen (6%)', '0', '0'),
('11', 'Goederen (0%)', '1', '0'),
('12', 'Diensten (21%)', '0', '0'),
('13', 'Diensten (6%)', '0', '0'),
('14', 'Diensten (0%)', '1', '0'),
('15', 'Overige (21%)', '0', '0'),
('16', 'Overige (6%)', '0', '0'),
('17', 'Overige (0%)', '1', '0');

### Structure of table `0_item_units` ###

DROP TABLE IF EXISTS `0_item_units`;

CREATE TABLE `0_item_units` (
  `abbr` varchar(20) NOT NULL,
  `name` varchar(40) NOT NULL,
  `decimals` tinyint(2) NOT NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`abbr`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM ;

### Data of table `0_item_units` ###

INSERT INTO `0_item_units` VALUES
('st', 'stuk', '0', '0'),
('jaar', 'jaar', '0', '0'),
('  ', '  ', '0', '0'),
('uur', 'uur', '1', '0');

### Structure of table `0_loc_stock` ###

DROP TABLE IF EXISTS `0_loc_stock`;

CREATE TABLE `0_loc_stock` (
  `loc_code` char(5) NOT NULL default '',
  `stock_id` char(20) NOT NULL default '',
  `reorder_level` bigint(20) NOT NULL default '0',
  PRIMARY KEY  (`loc_code`,`stock_id`),
  KEY `stock_id` (`stock_id`)
) ENGINE=InnoDB ;

### Data of table `0_loc_stock` ###

INSERT INTO `0_loc_stock` VALUES
('DEF', 'ARBEID', '0');

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
) ENGINE=MyISAM ;

### Data of table `0_locations` ###

INSERT INTO `0_locations` VALUES
('DEF', 'Algemeen', 'N/A', '', '', '', '', '', '0');

### Structure of table `0_movement_types` ###

DROP TABLE IF EXISTS `0_movement_types`;

CREATE TABLE `0_movement_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM;

### Data of table `0_movement_types` ###

INSERT INTO `0_movement_types` VALUES
('1', 'Correctie voorraad', '0');

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
) ENGINE=MyISAM;

### Data of table `0_payment_terms` ###

INSERT INTO `0_payment_terms` VALUES
('1', '60 dagen', '60', '0', '0'),
('2', '30 dagen', '30', '0', '0'),
('3', '14 dagen', '14', '0', '0'),
('4', 'Contant', '0', '0', '0'),
('5', 'Vooruitbetaling', '-1', '0', '0'),
('6', 'Incasso', '-1', '0', '0');

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
) ENGINE=MyISAM;

### Data of table `0_prices` ###

INSERT INTO `0_prices` VALUES
('25', 'ARBEID', '3', 'EUR', '50'),
('24', 'ARBEID', '1', 'EUR', '50');

### Structure of table `0_print_profiles` ###

DROP TABLE IF EXISTS `0_print_profiles`;

CREATE TABLE `0_print_profiles` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `profile` varchar(30) NOT NULL,
  `report` varchar(5) default NULL,
  `printer` tinyint(3) unsigned default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `profile` (`profile`,`report`)
) ENGINE=MyISAM;

### Data of table `0_print_profiles` ###

INSERT INTO `0_print_profiles` VALUES
('11', 'Standaard profiel', NULL, '0');

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
) ENGINE=MyISAM;

### Data of table `0_printers` ###


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
) ENGINE=MyISAM ;

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
) ENGINE=InnoDB ;

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
) ENGINE=InnoDB ;

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
) ENGINE=MyISAM;

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
) ENGINE=MyISAM;

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
) ENGINE=InnoDB ;

### Data of table `0_recurrent_invoices` ###


### Structure of table `0_refs` ###

DROP TABLE IF EXISTS `0_refs`;

CREATE TABLE `0_refs` (
  `id` int(11) NOT NULL default '0',
  `type` int(11) NOT NULL default '0',
  `reference` varchar(100) NOT NULL default '',
  PRIMARY KEY  (`id`,`type`),
  KEY `Type_and_Reference` (`type`,`reference`)
) ENGINE=InnoDB ;

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
) ENGINE=InnoDB ;

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
) ENGINE=InnoDB ;

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
) ENGINE=MyISAM;

### Data of table `0_sales_pos` ###

INSERT INTO `0_sales_pos` VALUES
('1', 'Standaard POS', '0', '1', 'DEF', '0', '0');

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
) ENGINE=MyISAM;

### Data of table `0_sales_types` ###

INSERT INTO `0_sales_types` VALUES
('1', 'Bedrijven', '0', '1', '0'),
('3', 'Particulieren', '1', '1', '0');

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
) ENGINE=MyISAM;

### Data of table `0_salesman` ###

INSERT INTO `0_salesman` VALUES
('5', 'Algemeen', 'Algemeen', 'Algemeen', 'Algemeen', '0', '0', '0', '0');

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
) ENGINE=MyISAM;

### Data of table `0_security_roles` ###

INSERT INTO `0_security_roles` VALUES
('1', 'Level 4 Ondersteuning', 'Level 4 Ondersteuning (alleen inzien)', '768;2816;3072;3328;5632;5888;8192;8448;10752;11008;13312;15872;16128', '257;258;259;260;513;514;515;516;517;518;519;520;521;522;523;524;525;526;773;774;2818;2822;3073;3075;3076;3077;3081;3329;3330;3331;3332;3333;3334;3335;5377;5633;5640;5889;5891;7937;7938;7939;7940;8193;8194;8450;8451;10497;10753;11009;11010;11012;13057;13313;13315;15617;15618;15619;15620;15621;15622;15623;15624;15628;15625;15626;15627;15629;15873;15882;16129;16130;16131;16132;746596;812132', '0'),
('2', 'Level 3 Boekhouding', 'Level 3 Boekhouding (gebruiker)', '512;768;2816;3072;3328;5376;5632;5888;7936;8192;8448;10496;10752;11008;13312;15616;15872;16128', '257;258;259;260;513;519;520;521;522;523;524;525;769;771;772;773;774;2817;2818;2819;2820;2821;2822;2823;3073;3074;3075;3076;3077;3078;3079;3080;3081;3329;3330;3331;3332;3333;3334;3335;5377;5633;5634;5635;5636;5637;5638;5639;5640;5889;5891;7937;7938;7939;7940;8193;8194;8195;8196;8197;8449;8450;8451;10497;10753;10754;10755;10756;10757;11009;11010;11012;13057;13313;13314;13315;15617;15618;15619;15620;15621;15622;15623;15624;15625;15626;15873;15874;15875;15876;15877;15878;15879;15880;15881;15882;16129;16130;16131;16132;746596;812132', '0'),
('3', 'Level 1 Beheerder', 'Level 1 Beheerder (systeem administrator)', '256;512;768;2816;3072;3328;5376;5632;5888;7936;8192;8448;10496;10752;11008;13056;13312;15616;15872;16128;746496;812032', '257;258;259;260;513;514;515;516;517;518;519;520;521;522;523;524;525;526;769;770;771;772;773;774;2817;2818;2819;2820;2821;2822;2823;3073;3074;3082;3075;3076;3077;3078;3079;3080;3081;3329;3330;3331;3332;3333;3334;3335;5377;5633;5634;5635;5636;5637;5641;5638;5639;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8195;8196;8197;8449;8450;8451;10497;10753;10754;10755;10756;10757;11009;11010;11011;11012;13057;13313;13314;13315;15617;15618;15619;15620;15621;15622;15623;15624;15628;15625;15626;15627;15629;15873;15874;15875;15876;15877;15878;15879;15880;15883;15881;15882;15884;16129;16130;16131;16132;746596;812132', '0'),
('4', 'Level 2 Hoofd adm', 'Level 2 Hoofd administratie', '512;768;2816;3072;3328;5376;5632;5888;7936;8192;8448;10496;10752;11008;13312;15616;15872;16128', '257;258;259;260;513;519;520;521;522;523;524;525;769;771;772;773;774;2817;2818;2819;2820;2821;2822;2823;3073;3074;3075;3076;3077;3078;3079;3080;3081;3329;3330;3331;3332;3333;3334;3335;5377;5633;5634;5635;5636;5637;5638;5639;5640;5889;5891;7937;7938;7939;7940;8193;8194;8195;8196;8197;8449;8450;8451;10497;10753;10754;10755;10756;10757;11009;11010;11012;13057;13313;13314;13315;15617;15618;15619;15620;15621;15622;15623;15624;15625;15626;15873;15874;15875;15876;15877;15878;15879;15880;15881;15882;16129;16130;16131;16132;746596;812132', '0'),
('5', 'Leesrechten', 'Leesrechten', '16128', '257;258;259;260;513;514;515;516;517;518;519;520;521;522;523;524;525;526;769;770;771;772;773;774;2817;2818;2819;2820;2821;2822;2823;3073;3074;3082;3075;3076;3077;3078;3079;3080;3081;3329;3330;3331;3332;3333;3334;3335;5377;5633;5634;5635;5636;5637;5641;5638;5639;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8195;8196;8197;8449;8450;8451;10497;10753;10754;10755;10756;10757;11009;11010;11011;11012;13057;13313;13314;13315;15617;15618;15619;15620;15621;15622;15623;15624;15628;15625;15626;15627;15629;15873;15874;15875;15876;15877;15878;15879;15880;15883;15881;15882;15884;16132;746596;812132;1205348;1205349;1205350;1598564;1664100;1664101', '0');

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
) ENGINE=MyISAM;

### Data of table `0_shippers` ###

INSERT INTO `0_shippers` VALUES
('3', 'Afhalen', 'Afhalen', 'Afhalen', 'Afhalen', 'Afhalen', '0'),
('2', 'TNT Post', '', '', '', '', '0'),
('4', 'Online (dienst)', 'Online', 'Online', 'Online', 'Online', '0');

### Structure of table `0_sql_trail` ###

DROP TABLE IF EXISTS `0_sql_trail`;

CREATE TABLE `0_sql_trail` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `sql` text NOT NULL,
  `result` tinyint(1) NOT NULL,
  `msg` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM ;

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
) ENGINE=MyISAM;

### Data of table `0_stock_category` ###

INSERT INTO `0_stock_category` VALUES
('11', 'Algemene dienstverlening', '0', '12', '  ', 'D', '8000', '8120', '3200', '8160', '6000', '0', '0', '0');

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
) ENGINE=InnoDB ;

### Data of table `0_stock_master` ###

INSERT INTO `0_stock_master` VALUES
('ARBEID', '11', '12', 'Arbeid', 'Arbeid', 'uur', 'D', '8000', '8120', '3200', '8160', '6000', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1');

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
) ENGINE=InnoDB ;

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
) ENGINE=InnoDB ;

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
) ENGINE=InnoDB ;

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
) ENGINE=InnoDB ;

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
) ENGINE=MyISAM;

### Data of table `0_suppliers` ###

INSERT INTO `0_suppliers` VALUES
('7', 'Algemene leverancier', 'Algemene leverancier', 'Algemene leverancier', '', '', '', '', 'Algemene leverancier', 'EUR', '3', '0', '0', '0', '5', '0', '', '1600', '8150', 'Algemene leverancier', '0', 'Algemene leverancier');

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
) ENGINE=MyISAM ;

### Data of table `0_sys_prefs` ###

INSERT INTO `0_sys_prefs` VALUES
('coy_name', 'setup.company', 'varchar', '60', 'Naam Administratie'),
('gst_no', 'setup.company', 'varchar', '25', 'NL001234567B01'),
('coy_no', 'setup.company', 'varchar', '25', '12345678'),
('tax_prd', 'setup.company', 'int', '11', '3'),
('tax_last', 'setup.company', 'int', '11', '0'),
('postal_address', 'setup.company', 'tinytext', '0', 'Vestigingsadres 1\r\n1234 AB WOONPLAATS\r\n\r\n'),
('phone', 'setup.company', 'varchar', '30', '012-3456789'),
('fax', 'setup.company', 'varchar', '30', '987-6543210'),
('email', 'setup.company', 'varchar', '100', 'e-mail@adres.nl'),
('coy_logo', 'setup.company', 'varchar', '100', NULL),
('domicile', 'setup.company', 'varchar', '55', 'Vestiginsplaats'),
('curr_default', 'setup.company', 'char', '3', 'EUR'),
('use_dimension', 'setup.company', 'tinyint', '1', '1'),
('f_year', 'setup.company', 'int', '11', '5'),
('no_item_list', 'setup.company', 'tinyint', '1', '0'),
('no_customer_list', 'setup.company', 'tinyint', '1', '0'),
('no_supplier_list', 'setup.company', 'tinyint', '1', '0'),
('base_sales', 'setup.company', 'int', '11', '0'),
('time_zone', 'setup.company', 'tinyint', '1', '0'),
('add_pct', 'setup.company', 'int', '5', '25'),
('round_to', 'setup.company', 'int', '5', '1'),
('login_tout', 'setup.company', 'smallint', '6', '1800'),
('past_due_days', 'glsetup.general', 'int', '11', '30'),
('profit_loss_year_act', 'glsetup.general', 'varchar', '15', '999'),
('retained_earnings_act', 'glsetup.general', 'varchar', '15', '900'),
('bank_charge_act', 'glsetup.general', 'varchar', '15', '9040'),
('exchange_diff_act', 'glsetup.general', 'varchar', '15', '9030'),
('default_credit_limit', 'glsetup.customer', 'int', '11', '1000'),
('accumulate_shipping', 'glsetup.customer', 'tinyint', '1', '0'),
('legal_text', 'glsetup.customer', 'tinytext', '0', 'Ons betalingstermijn is 30 dagen netto. Wij staan geregistreerd bij de Kamer van Koophandel te Rotterdam onder dossiernummer XXXXXXXX (zie: systeem- en grootboekinstellingen om deze tekst aan te passen)'),
('freight_act', 'glsetup.customer', 'varchar', '15', '4420'),
('debtors_act', 'glsetup.sales', 'varchar', '15', '1300'),
('default_sales_act', 'glsetup.sales', 'varchar', '15', '8020'),
('default_sales_discount_act', 'glsetup.sales', 'varchar', '15', '8300'),
('default_prompt_payment_act', 'glsetup.sales', 'varchar', '15', '8310'),
('default_delivery_required', 'glsetup.sales', 'smallint', '6', '7'),
('default_dim_required', 'glsetup.dims', 'int', '11', '20'),
('pyt_discount_act', 'glsetup.purchase', 'varchar', '15', '8150'),
('creditors_act', 'glsetup.purchase', 'varchar', '15', '1600'),
('po_over_receive', 'glsetup.purchase', 'int', '11', '10'),
('po_over_charge', 'glsetup.purchase', 'int', '11', '10'),
('allow_negative_stock', 'glsetup.inventory', 'tinyint', '1', '0'),
('default_inventory_act', 'glsetup.items', 'varchar', '15', '3200'),
('default_cogs_act', 'glsetup.items', 'varchar', '15', '8120'),
('default_adj_act', 'glsetup.items', 'varchar', '15', '8160'),
('default_inv_sales_act', 'glsetup.items', 'varchar', '15', '8000'),
('default_assembly_act', 'glsetup.items', 'varchar', '15', '6000'),
('default_workorder_required', 'glsetup.manuf', 'int', '11', '20'),
('version_id', 'system', 'varchar', '11', '2.3rc'),
('auto_curr_reval', 'setup.company', 'smallint', '6', '1'),
('grn_clearing_act', 'glsetup.purchase', 'varchar', '15', '0');

### Structure of table `0_sys_types` ###

DROP TABLE IF EXISTS `0_sys_types`;

CREATE TABLE `0_sys_types` (
  `type_id` smallint(6) NOT NULL default '0',
  `type_no` int(11) NOT NULL default '1',
  `next_reference` varchar(100) NOT NULL default '',
  PRIMARY KEY  (`type_id`)
) ENGINE=InnoDB ;

### Data of table `0_sys_types` ###

INSERT INTO `0_sys_types` VALUES
('0', '17', '1'),
('1', '7', 'BET2013001'),
('2', '4', 'ONTV2013001'),
('4', '3', '1'),
('10', '16', 'VF2013001'),
('11', '2', 'C2013001'),
('12', '6', 'DEB2013001'),
('13', '1', 'PB2013001'),
('16', '2', '1'),
('17', '2', '1'),
('18', '1', '1'),
('20', '6', 'IF2013001'),
('21', '1', 'C-IF2013001'),
('22', '3', 'LEV2013001'),
('25', '1', '1'),
('26', '1', 'WO2013001'),
('28', '1', '1'),
('29', '1', '1'),
('30', '0', 'VO2013001'),
('32', '0', 'OF2013001'),
('35', '1', '1'),
('40', '1', '1');

### Structure of table `0_tag_associations` ###

DROP TABLE IF EXISTS `0_tag_associations`;

CREATE TABLE `0_tag_associations` (
  `record_id` varchar(15) NOT NULL,
  `tag_id` int(11) NOT NULL,
  UNIQUE KEY `record_id` (`record_id`,`tag_id`)
) ENGINE=MyISAM ;

### Data of table `0_tag_associations` ###

INSERT INTO `0_tag_associations` VALUES
('1', '2');

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
) ENGINE=MyISAM;

### Data of table `0_tags` ###


### Structure of table `0_tax_group_items` ###

DROP TABLE IF EXISTS `0_tax_group_items`;

CREATE TABLE `0_tax_group_items` (
  `tax_group_id` int(11) NOT NULL default '0',
  `tax_type_id` int(11) NOT NULL default '0',
  `rate` double NOT NULL default '0',
  PRIMARY KEY  (`tax_group_id`,`tax_type_id`)
) ENGINE=InnoDB ;

### Data of table `0_tax_group_items` ###

INSERT INTO `0_tax_group_items` VALUES
('5', '7', '21'),
('5', '8', '6'),
('5', '9', '0'),
('6', '7', '21'),
('6', '8', '6'),
('6', '9', '0'),
('7', '7', '21'),
('7', '8', '6'),
('7', '9', '0');

### Structure of table `0_tax_groups` ###

DROP TABLE IF EXISTS `0_tax_groups`;

CREATE TABLE `0_tax_groups` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(60) NOT NULL default '',
  `tax_shipping` tinyint(1) NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB;

### Data of table `0_tax_groups` ###

INSERT INTO `0_tax_groups` VALUES
('5', 'Diensten', '0', '0'),
('6', 'Goederen', '0', '0'),
('7', 'Overige', '1', '0');

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
) ENGINE=InnoDB;

### Data of table `0_tax_types` ###

INSERT INTO `0_tax_types` VALUES
('7', '21', '1815', '1810', 'BTW hoog', '0'),
('8', '6', '1825', '1820', 'BTW laag', '0'),
('9', '0', '1800', '1800', 'BTW vrij', '0');

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
) ENGINE=InnoDB ;

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
) ENGINE=MyISAM ;

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
) ENGINE=MyISAM;

### Data of table `0_users` ###

INSERT INTO `0_users` VALUES
('7', 'admin', '5f4dcc3b5aa765d61d8327deb882cf99', '', '3', '', NULL, 'nl_NL', '1', '0', '1', '1', 'default', 'A4', '2', '2', '4', '1', '1', '0', '0', '2013-01-06 20:26:40', '10', '1', '1', '', '1', '0', 'orders', '0');

### Structure of table `0_voided` ###

DROP TABLE IF EXISTS `0_voided`;

CREATE TABLE `0_voided` (
  `type` int(11) NOT NULL default '0',
  `id` int(11) NOT NULL default '0',
  `date_` date NOT NULL default '0000-00-00',
  `memo_` tinytext NOT NULL,
  UNIQUE KEY `id` (`type`,`id`)
) ENGINE=InnoDB ;

### Data of table `0_voided` ###


### Structure of table `0_wo_issue_items` ###

DROP TABLE IF EXISTS `0_wo_issue_items`;

CREATE TABLE `0_wo_issue_items` (
  `id` int(11) NOT NULL auto_increment,
  `stock_id` varchar(40) default NULL,
  `issue_id` int(11) default NULL,
  `qty_issued` double default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB ;

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
) ENGINE=InnoDB ;

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
) ENGINE=InnoDB ;

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
) ENGINE=InnoDB ;

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
) ENGINE=MyISAM ;

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
) ENGINE=InnoDB ;

### Data of table `0_workorders` ###
