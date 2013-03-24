# MySQL dump of database 'fa_qs' on host 'localhost'
# Backup Date and Time: 2012-02-07 15:16
# Built by FrontAccounting 2.3.10
# http://frontaccounting.com
# Company: Training Co.
# User: Administrator

# Comment:
# 4.04.2012



### Structure of table `0_areas` ###

DROP TABLE IF EXISTS `0_areas`;

CREATE TABLE `0_areas` (
  `area_code` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`area_code`),
  UNIQUE KEY `description` (`description`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ;

### Data of table `0_areas` ###

INSERT INTO `0_areas` VALUES
('1', 'Global', '0');

### Structure of table `0_attachments` ###

DROP TABLE IF EXISTS `0_attachments`;

CREATE TABLE `0_attachments` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(60) NOT NULL DEFAULT '',
  `type_no` int(11) NOT NULL DEFAULT '0',
  `trans_no` int(11) NOT NULL DEFAULT '0',
  `unique_name` varchar(60) NOT NULL DEFAULT '',
  `tran_date` date NOT NULL DEFAULT '0000-00-00',
  `filename` varchar(60) NOT NULL DEFAULT '',
  `filesize` int(11) NOT NULL DEFAULT '0',
  `filetype` varchar(60) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `type_no` (`type_no`,`trans_no`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

### Data of table `0_attachments` ###


### Structure of table `0_audit_trail` ###

DROP TABLE IF EXISTS `0_audit_trail`;

CREATE TABLE `0_audit_trail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` smallint(6) unsigned NOT NULL DEFAULT '0',
  `trans_no` int(11) unsigned NOT NULL DEFAULT '0',
  `user` smallint(6) unsigned NOT NULL DEFAULT '0',
  `stamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `description` varchar(60) DEFAULT NULL,
  `fiscal_year` int(11) NOT NULL,
  `gl_date` date NOT NULL DEFAULT '0000-00-00',
  `gl_seq` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Seq` (`fiscal_year`,`gl_date`,`gl_seq`),
  KEY `Type_and_Number` (`type`,`trans_no`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_audit_trail` ###


### Structure of table `0_bank_accounts` ###

DROP TABLE IF EXISTS `0_bank_accounts`;

CREATE TABLE `0_bank_accounts` (
  `account_code` varchar(15) NOT NULL DEFAULT '',
  `account_type` smallint(6) NOT NULL DEFAULT '0',
  `bank_account_name` varchar(60) NOT NULL DEFAULT '',
  `bank_account_number` varchar(100) NOT NULL DEFAULT '',
  `bank_name` varchar(60) NOT NULL DEFAULT '',
  `bank_address` tinytext,
  `bank_curr_code` char(3) NOT NULL DEFAULT '',
  `dflt_curr_act` tinyint(1) NOT NULL DEFAULT '0',
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `last_reconciled_date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ending_reconcile_balance` double NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `bank_account_name` (`bank_account_name`),
  KEY `bank_account_number` (`bank_account_number`),
  KEY `account_code` (`account_code`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 ;

### Data of table `0_bank_accounts` ###

INSERT INTO `0_bank_accounts` VALUES
('512100', '3', 'Cont curent banca', 'RO12345678901234567890', 'sucursala', NULL, 'RON', '1', '2', '0000-00-00 00:00:00', '0', '0');

### Structure of table `0_bank_trans` ###

DROP TABLE IF EXISTS `0_bank_trans`;

CREATE TABLE `0_bank_trans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` smallint(6) DEFAULT NULL,
  `trans_no` int(11) DEFAULT NULL,
  `bank_act` varchar(15) NOT NULL DEFAULT '',
  `ref` varchar(40) DEFAULT NULL,
  `trans_date` date NOT NULL DEFAULT '0000-00-00',
  `amount` double DEFAULT NULL,
  `dimension_id` int(11) NOT NULL DEFAULT '0',
  `dimension2_id` int(11) NOT NULL DEFAULT '0',
  `person_type_id` int(11) NOT NULL DEFAULT '0',
  `person_id` tinyblob,
  `reconciled` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `bank_act` (`bank_act`,`ref`),
  KEY `type` (`type`,`trans_no`),
  KEY `bank_act_2` (`bank_act`,`reconciled`),
  KEY `bank_act_3` (`bank_act`,`trans_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_bank_trans` ###


### Structure of table `0_bom` ###

DROP TABLE IF EXISTS `0_bom`;

CREATE TABLE `0_bom` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent` char(20) NOT NULL DEFAULT '',
  `component` char(20) NOT NULL DEFAULT '',
  `workcentre_added` int(11) NOT NULL DEFAULT '0',
  `loc_code` char(5) NOT NULL DEFAULT '',
  `quantity` double NOT NULL DEFAULT '1',
  PRIMARY KEY (`parent`,`component`,`workcentre_added`,`loc_code`),
  KEY `component` (`component`),
  KEY `id` (`id`),
  KEY `loc_code` (`loc_code`),
  KEY `parent` (`parent`,`loc_code`),
  KEY `workcentre_added` (`workcentre_added`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 ;

### Data of table `0_bom` ###


### Structure of table `0_budget_trans` ###

DROP TABLE IF EXISTS `0_budget_trans`;

CREATE TABLE `0_budget_trans` (
  `counter` int(11) NOT NULL AUTO_INCREMENT,
  `type` smallint(6) NOT NULL DEFAULT '0',
  `type_no` bigint(16) NOT NULL DEFAULT '1',
  `tran_date` date NOT NULL DEFAULT '0000-00-00',
  `account` varchar(15) NOT NULL DEFAULT '',
  `memo_` tinytext NOT NULL,
  `amount` double NOT NULL DEFAULT '0',
  `dimension_id` int(11) DEFAULT '0',
  `dimension2_id` int(11) DEFAULT '0',
  `person_type_id` int(11) DEFAULT NULL,
  `person_id` tinyblob,
  PRIMARY KEY (`counter`),
  KEY `Type_and_Number` (`type`,`type_no`),
  KEY `Account` (`account`,`tran_date`,`dimension_id`,`dimension2_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_budget_trans` ###


### Structure of table `0_chart_class` ###

DROP TABLE IF EXISTS `0_chart_class`;

CREATE TABLE `0_chart_class` (
  `cid` varchar(3) NOT NULL,
  `class_name` varchar(60) NOT NULL DEFAULT '',
  `ctype` tinyint(1) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`cid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

### Data of table `0_chart_class` ###

INSERT INTO `0_chart_class` VALUES
('3', '3 Stocuri si productie in curs', '1', '0'),
('2', '2 Imobilizari', '1', '0'),
('1', '1 Capitaluri', '3', '0'),
('4', '4 Terti', '2', '0'),
('5', '5 Trezorerie', '1', '0'),
('6', '6 Cheltuieli', '6', '0'),
('7', '7 Venituri', '4', '0'),
('8', '8 Speciale', '4', '1'),
('9', '9 Gestiune', '4', '1');

### Structure of table `0_chart_master` ###

DROP TABLE IF EXISTS `0_chart_master`;

CREATE TABLE `0_chart_master` (
  `account_code` varchar(15) NOT NULL DEFAULT '',
  `account_code2` varchar(15) NOT NULL DEFAULT '',
  `account_name` varchar(60) NOT NULL DEFAULT '',
  `account_type` varchar(10) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`account_code`),
  KEY `account_name` (`account_name`),
  KEY `accounts_by_type` (`account_type`,`account_code`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

### Data of table `0_chart_master` ###

INSERT INTO `0_chart_master` VALUES
('140000', '', 'CASTIGURI SAU PIERDERI LEGATE DE EMITEREA, RASCUMPARAREA, VA', '14', '1'),
('129000', '', 'Repartizarea profitului', '129', '0'),
('121000', '', 'Profit sau pierdere', '121', '0'),
('120000', '', 'REZULTATUL EXERCITIULUI FINANCIAR', '12', '0'),
('117600', '', 'Rezultatul reportat provenit din trecerea la aplicarea Regl.', '1176', '1'),
('117400', '', 'Rezultatul reportat provenit din corectarea erorilor contabi', '1174', '1'),
('117200', '', 'Rezultatul reportat provenit din adoptarea pentru prima data', '1172', '1'),
('117100', '', 'Rezultatul reportat reprezentand profitul nerepartizat sau p', '1171', '0'),
('117000', '', 'Rezultatul reportat', '117', '0'),
('110000', '', 'REZULTATUL REPORTAT', '11', '0'),
('109200', '', 'Actiuni proprii detinute pe termen lung', '1092', '1'),
('109100', '', 'Actiuni proprii detinute pe termen scurt', '1091', '1'),
('109000', '', 'Actiuni proprii', '109', '1'),
('108200', '', 'Interese care nu controleaza - alte capitaluri proprii', '1082', '1'),
('108100', '', 'Interese care nu controleaza - rezultatul exercitiului finan', '1081', '1'),
('108000', '', 'Interese care nu controleaza', '108', '1'),
('107000', '', 'Rezerve din conversie', '107', '1'),
('106800', '', 'Alte rezerve', '1068', '0'),
('106700', '', 'Rezerve din dif. de curs valutar in relatie cu investitia ne', '1067', '1'),
('106500', '', 'Rezerve reprezentand surplusul realizat din rezerve din reev', '1065', '1'),
('106400', '', 'Rezerve de valoare justa', '1064', '1'),
('106300', '', 'Rezerve statutare sau contractuale', '1063', '1'),
('106100', '', 'Rezerve legale', '1061', '0'),
('106000', '', 'Rezerve', '106', '1'),
('105000', '', 'Rezerve din reevaluare', '105', '1'),
('104400', '', 'Prime de conversie a obligatiunilor in actiuni', '1044', '0'),
('104300', '', 'Prime de aport', '1043', '1'),
('104200', '', 'Prime de fuziune/divizare', '1042', '0'),
('104100', '', 'Prime de emisiune', '1041', '0'),
('104000', '', 'Prime de capital', '104', '0'),
('101600', '', 'Patrimoniul public', '1016', '1'),
('101500', '', 'Patrimoniul regiei', '1015', '1'),
('101200', '', 'Capital subscris varsat', '1012', '0'),
('101100', '', 'Capital subscris nevarsat', '1011', '0'),
('101000', '', 'Capital social', '101', '1'),
('100000', '', 'CAPITAL SI REZERVE', '10', '1'),
('141000', '', 'Castiguri legate de vanzarea sau anularea instrumentelor de ', '141', '1'),
('149000', '', 'Pierderi legate de emiterea, rascumpararea, vanzarea, cedare', '149', '1'),
('150000', '', 'PROVIZIOANE', '15', '1'),
('151000', '', 'Provizioane', '151', '1'),
('151100', '', 'Provizioane pentru litigii', '1511', '1'),
('151200', '', 'Provizioane pentru garantii acordate clientilor', '1512', '1'),
('151300', '', 'Provizioane pentru dezafectare imobilizari corporale si alte', '1513', '1'),
('151400', '', 'Provizioane pentru restructurare', '1514', '1'),
('151500', '', 'Provizioane pentru pensii si obligatii similare', '1515', '1'),
('151600', '', 'Provizioane pentru impozite', '1516', '1'),
('151800', '', 'Alte provizioane', '1518', '1'),
('160000', '', 'IMPRUMUTURI SI DATORII ASIMILATE', '16', '1'),
('161000', '', 'Imprumuturi din emisiuni de obligatiuni', '161', '1'),
('161400', '', 'Imprumuturi externe din emisiuni de obligatiuni garantate de', '1614', '1'),
('161500', '', 'Imprumuturi externe din emisiuni de obligatiuni garantate de', '1615', '1'),
('161700', '', 'Imprumuturi interne din emisiuni de obligatiuni garantate de', '1617', '1'),
('161800', '', 'Alte imprumuturi din emisiuni de obligatiuni', '1618', '1'),
('162000', '', 'Credite bancare pe termen lung', '162', '1'),
('162100', '', 'Credite bancare pe termen lung', '1621', '1'),
('162200', '', 'Credite bancare pe termen lung nerambursate la scadenta', '1622', '1'),
('162300', '', 'Credite externe guvernamentale', '1623', '1'),
('162400', '', 'Credite bancare externe garantate de stat', '1624', '1'),
('162500', '', 'Credite bancare externe garantate de banci', '1625', '1'),
('162600', '', 'Credite de la trezoreria statului', '1626', '1'),
('162700', '', 'Credite bancare interne garantate de stat', '1627', '1'),
('166000', '', 'Datorii care privesc imobilizarile financiare', '166', '1'),
('166100', '', 'Datorii fata de entititile afiliate', '1661', '1'),
('166300', '', 'Datorii fata de entititile de care compania este legata prin', '1663', '1'),
('167000', '', 'Alte imprumuturi si datorii asimilate', '167', '1'),
('168000', '', 'Dobanzi aferente imprumuturilor si datoriilor asimilate', '168', '1'),
('168100', '', 'Dobanzi aferente imprumuturilor din emisiuni de obligatiuni', '1681', '1'),
('168200', '', 'Dobanzi aferente creditelor bancare pe termen lung', '1682', '1'),
('168500', '', 'Dobanzi aferente datoriilor fata de entitatile afiliate', '1685', '1'),
('168600', '', 'Dobanzi aferente datoriilor fata de entitatile de care compa', '1686', '1'),
('168700', '', 'Dobanzi aferente altor imprumuturi si datorii asimilate', '1687', '1'),
('169000', '', 'Prime privind rambursarea obligatiunilor', '169', '1'),
('200000', '', 'IMOBILIZARI NECORPORALE', '20', '0'),
('201000', '', 'Cheltuieli de constituire', '201', '0'),
('203000', '', 'Cheltuieli de dezvoltare', '203', '1'),
('205000', '', 'Concesiuni, brevete, licente, marci comerciale, drepturi si ', '205', '0'),
('207000', '', 'Fond comercial', '207', '1'),
('207500', '', 'Fond comercial negativ', '2075', '0'),
('208000', '', 'Alte imobilizari necorporale', '208', '0'),
('210000', '', 'IMOBILIZARI CORPORALE', '21', '0'),
('211000', '', 'Terenuri si amenajari de terenuri', '211', '1'),
('211100', '', 'Terenuri', '2111', '1'),
('211200', '', 'Amenajari de terenuri', '2112', '1'),
('212000', '', 'Constructii', '212', '1'),
('213000', '', 'Instalatii tehnice, mijloace de transport, animale si planta', '213', '0'),
('213100', '', 'Echipamente tehnologice (masini, utilaje si instalatii de lu', '2131', '0'),
('213200', '', 'Aparate si instalatii de masurare, control si reglare', '2132', '0'),
('213300', '', 'Mijloace de transport', '2133', '0'),
('213400', '', 'Animale si plantatii', '2134', '1'),
('214000', '', 'Mobilier, ap. birotica, echipamente de protectie a valorilor', '214', '0'),
('220000', '', 'IMOBILIZARI CORPORALE IN CURS DE APROVIZIONARE', '22', '0'),
('223000', '', 'Instalatii tehnice, mijl. de transport, animale si plantatii', '223', '0'),
('224000', '', 'Mobilier, ap. birotica, echipamente de protectie a valorilor', '224', '0'),
('230000', '', 'IMOBILIZARI IN CURS SI AVANSURI PENTRU IMOBILIZARI', '23', '1'),
('231000', '', 'Imobilizari corporale in curs de executie', '231', '1'),
('232000', '', 'Avansuri acordate pentru imobilizari corporale', '232', '1'),
('233000', '', 'Imobilizari necorporale in curs de executie', '233', '1'),
('234000', '', 'Avansuri acordate pentru imobilizari necorporale', '234', '1'),
('260000', '', 'IMOBILIZARI FINANCIARE', '26', '1'),
('261000', '', 'Actiuni detinute la entititile afiliate', '261', '1'),
('263000', '', 'Interese de participare', '263', '1'),
('264000', '', 'Titluri puse in echivalenta', '264', '1'),
('265000', '', 'Alte titluri imobilizate', '265', '1'),
('267000', '', 'Creante imobilizate', '267', '1'),
('267100', '', 'Sume datorate de entititile afiliate', '2671', '1'),
('267200', '', 'Dobanda aferenta sumelor datorate de entititile afiliate', '2672', '1'),
('267300', '', 'Creante legate de interesele de participare', '2673', '1'),
('267400', '', 'Dobanda aferenta creantelor legate de interesele de particip', '2674', '1'),
('267500', '', 'Imprumuturi acordate pe termen lung', '2675', '1'),
('267600', '', 'Dobanda aferenta imprumuturilor acordate pe termen lung', '2676', '1'),
('267800', '', 'Alte creante imobilizate', '2678', '1'),
('267900', '', 'Dobanzi aferente altor creante imobilizate', '2679', '1'),
('269000', '', 'Varsaminte de efectuat pentru imobilizari financiare', '269', '1'),
('269100', '', 'Varsaminte de efectuat privind actiunile detinute la entitit', '2691', '1'),
('269200', '', 'Varsaminte de efectuat privind interesele de participare', '2692', '1'),
('269300', '', 'Varsaminte de efectuat pentru alte imobilizari financiare', '2693', '1'),
('280000', '', 'AMORTIZARI PRIVIND IMOBILIZARILE', '28', '0'),
('280001', '', 'Amortizari privind imobilizarile necorporale', '280', '0'),
('280100', '', 'Amortizarea cheltuielilor de constituire', '2801', '0'),
('280300', '', 'Amortizarea cheltuielilor de dezvoltare', '2803', '0'),
('280500', '', 'Amortizarea concesiunilor, brevetelor, licentelor, marcilor ', '2805', '0'),
('280700', '', 'Amortizarea fondului comercial', '2807', '0'),
('280800', '', 'Amortizarea altor imobilizari necorporale', '2808', '0'),
('281000', '', 'Amortizari privind imobilizarile corporale', '281', '0'),
('281100', '', 'Amortizarea amenajarilor de terenuri', '2811', '0'),
('281200', '', 'Amortizarea constructiilor', '2812', '0'),
('281300', '', 'Amortizarea instalatiilor, mijloacelor de transport, animale', '2813', '0'),
('281400', '', 'Amortizarea altor imobilizari corporale', '2814', '0'),
('290000', '', 'AJUSTARI PENTRU DEPRECIEREA SAU PIERDEREA DE VALOARE A IMOBI', '29', '1'),
('290001', '', 'Ajustari pentru deprecierea imobilizarilor necorporale', '290', '1'),
('290300', '', 'Ajustari pentru deprecierea cheltuielilor de dezvoltare', '2903', '1'),
('290500', '', 'Ajustari pentru deprecierea concesiunilor, brevetelor, licen', '2905', '1'),
('290700', '', 'Ajustari pentru deprecierea fondului comercial', '2907', '1'),
('290800', '', 'Ajustari pentru deprecierea altor imobilizari necorporale', '2908', '1'),
('291000', '', 'Ajustari pentru deprecierea imobilizarilor corporale', '291', '1'),
('291100', '', 'Ajustari pentru deprecierea terenurilor si amenajarilor de t', '2911', '1'),
('291200', '', 'Ajustari pentru deprecierea constructiilor', '2912', '1'),
('291300', '', 'Ajustari pentru deprecierea instalatiilor, mijloacelor de tr', '2913', '1'),
('291400', '', 'Ajustari pentru deprecierea altor imobilizari corporale', '2914', '1'),
('293000', '', 'Ajustari pentru deprecierea imobilizarilor in curs de execut', '293', '1'),
('293100', '', 'Ajustari pentru deprecierea imobilizarilor corporale in curs', '2931', '1'),
('293300', '', 'Ajustari pentru deprecierea imobilizarilor necorporale in cu', '2933', '1'),
('296000', '', 'Ajustari pentru pierderea de valoare a imobilizarilor financ', '296', '1'),
('296100', '', 'Ajustari pentru pierderea de valoare a actiunilor detinute l', '2961', '1'),
('296200', '', 'Ajustari pentru pierderea de valoare a intereselor de partic', '2962', '1'),
('296300', '', 'Ajustari pentru pierderea de valoare a altor titluri imobili', '2963', '1'),
('296400', '', 'Ajustari pentru pierderea de valoare a sumelor datorate de e', '2964', '1'),
('296500', '', 'Ajustari pentru pierderea de valoare a creantelor legate de ', '2965', '1'),
('296600', '', 'Ajustari pentru pierderea de valoare a imprumuturilor acorda', '2966', '1'),
('296800', '', 'Ajustari pentru pierderea de valoare a altor creante imobili', '2968', '1'),
('300000', '', 'STOCURI DE MATERII PRIME SI MATERIALE', '30', '0'),
('301000', '', 'Materii prime', '301', '0'),
('302000', '', 'Materiale consumabile', '302', '1'),
('302100', '', 'Materiale auxiliare', '3021', '1'),
('302200', '', 'Combustibili', '3022', '1'),
('302300', '', 'Materiale pentru ambalat', '3023', '1'),
('302400', '', 'Piese de schimb', '3024', '1'),
('302500', '', 'Seminte si materiale de plantat', '3025', '1'),
('302600', '', 'Furaje', '3026', '1'),
('302800', '', 'Alte materiale consumabile', '3028', '0'),
('303000', '', 'Materiale de natura obiectelor de inventar', '303', '0'),
('308000', '', 'Diferente de pret la materii prime si materiale', '308', '1'),
('320000', '', 'STOCURI IN CURS DE APROVIZIONARE', '32', '1'),
('321000', '', 'Materii prime in curs de aprovizionare', '321', '1'),
('322000', '', 'Materiale consumabile in curs de aprovizionare', '322', '1'),
('323000', '', 'Materiale de natura obiectelor de inventar in curs de aprovi', '323', '1'),
('326000', '', 'Animale in curs de aprovizionare', '326', '1'),
('327000', '', 'Marfuri in curs de aprovizionare', '327', '1'),
('328000', '', 'Ambalaje in curs de aprovizionare', '328', '1'),
('330000', '', 'PRODUCTIE IN CURS DE EXECUTIE', '33', '1'),
('331000', '', 'Produse in curs de executie', '331', '1'),
('332000', '', 'Servicii în curs de executie', '332', '1'),
('340000', '', 'PRODUSE', '34', '1'),
('341000', '', 'Semifabricate', '341', '1'),
('345000', '', 'Produse finite', '345', '1'),
('346000', '', 'Produse reziduale', '346', '1'),
('348000', '', 'Diferente de pret la produse', '348', '1'),
('350000', '', 'STOCURI AFLATE LA TERTI', '35', '1'),
('351000', '', 'Materii si materiale aflate la terti', '351', '1'),
('354000', '', 'Produse aflate la terti', '354', '1'),
('356000', '', 'Animale aflate la terti', '356', '1'),
('357000', '', 'Marfuri aflate la terti', '357', '1'),
('358000', '', 'Ambalaje aflate la terti', '358', '1'),
('360000', '', 'ANIMALE', '36', '1'),
('361000', '', 'Animale si pasari', '361', '1'),
('368000', '', 'Diferente de pret la animale si pasari', '368', '1'),
('370000', '', 'MARFURI', '37', '0'),
('371000', '', 'Marfuri', '371', '0'),
('378000', '', 'Diferente de pret la marfuri', '378', '1'),
('380000', '', 'AMBALAJE', '38', '1'),
('381000', '', 'Ambalaje', '381', '1'),
('388000', '', 'Diferente de pret la ambalaje', '388', '1'),
('390000', '', 'AJUSTARI PENTRU DEPRECIEREA STOCURILOR SI PRODUCTIEI IN CURS', '39', '1'),
('391000', '', 'Ajustari pentru deprecierea materiilor prime', '391', '1'),
('392000', '', 'Ajustari pentru deprecierea materialelor', '392', '1'),
('392100', '', 'Ajustari pentru deprecierea materialelor consumabile', '3921', '1'),
('392200', '', 'Ajustari pentru deprecierea materialelor de natura obiectelo', '3922', '1'),
('393000', '', 'Ajustari pentru deprecierea productiei in curs de executie', '393', '1'),
('394000', '', 'Ajustari pentru deprecierea produselor', '394', '1'),
('394100', '', 'Ajustari pentru deprecierea semifabricatelor', '3941', '1'),
('394500', '', 'Ajustari pentru deprecierea produselor finite', '3945', '1'),
('394600', '', 'Ajustari pentru deprecierea produselor reziduale', '3946', '1'),
('395000', '', 'Ajustari pentru deprecierea stocurilor aflate la terti', '395', '1'),
('395100', '', 'Ajustari pentru deprecierea materiilor si materialelor aflat', '3951', '1'),
('395200', '', 'Ajustari pentru deprecierea semifabricatelor aflate la terti', '3952', '1'),
('395300', '', 'Ajustari pentru deprecierea produselor finite aflate la tert', '3953', '1'),
('395400', '', 'Ajustari pentru deprecierea produselor reziduale aflate la t', '3954', '1'),
('395600', '', 'Ajustari pentru deprecierea animalelor aflate la terti', '3956', '1'),
('395700', '', 'Ajustari pentru deprecierea marfurilor aflate la terti', '3957', '1'),
('395800', '', 'Ajustari pentru deprecierea ambalajelor aflate la terti', '3958', '1'),
('396000', '', 'Ajustari pentru deprecierea animalelor', '396', '1'),
('397000', '', 'Ajustari pentru deprecierea marfurilor', '397', '1'),
('398000', '', 'Ajustari pentru deprecierea ambalajelor', '398', '1'),
('400000', '', 'FURNIZORI SI CONTURI ASIMILATE', '40', '0'),
('401000', '', 'Furnizori', '401', '0'),
('403000', '', 'Efecte de platit', '403', '0'),
('404000', '', 'Furnizori de imobilizari', '404', '0'),
('405000', '', 'Efecte de platit pentru imobilizari', '405', '1'),
('408000', '', 'Furnizori - facturi nesosite', '408', '0'),
('409000', '', 'Furnizori - debitori', '409', '0'),
('409100', '', 'Furnizori - debitori pentru cumparari de bunuri de natura st', '4091', '0'),
('409200', '', 'Furnizori - debitori pentru prestari de servicii', '4092', '0'),
('410000', '', 'CLIENTI SI CONTURI ASIMILATE', '41', '0'),
('411000', '', 'Clienti', '411', '0'),
('411100', '', 'Clienti', '4111', '0'),
('411800', '', 'Clienti incerti sau in litigiu', '4118', '0'),
('413000', '', 'Efecte de primit de la clienti', '413', '1'),
('418000', '', 'Clienti - facturi de intocmit', '418', '0'),
('419000', '', 'Clienti - creditori', '419', '0'),
('420000', '', 'PERSONAL SI CONTURI ASIMILATE', '42', '0'),
('421000', '', 'Personal - salarii datorate', '421', '0'),
('423000', '', 'Personal - ajutoare materiale datorate', '423', '1'),
('424000', '', 'Prime reprezentand participarea personalului la profit', '424', '1'),
('425000', '', 'Avansuri acordate personalului', '425', '0'),
('426000', '', 'Drepturi de personal neridicate', '426', '1'),
('427000', '', 'Retineri din salarii datorate tertilor', '427', '0'),
('428000', '', 'Alte datorii si creante in legatura cu personalul', '428', '0'),
('428100', '', 'Alte datorii in legatura cu personalul', '4281', '0'),
('428200', '', 'Alte creante in legatura cu personalul', '4282', '0'),
('430000', '', 'ASIGURARI SOCIALE, PROTECTIA SOCIALA SI CONTURI ASIMILATE', '43', '0'),
('431000', '', 'Asigurari sociale', '431', '0'),
('431100', '', 'Contributia unitatii la asigurarile sociale', '4311', '0'),
('431200', '', 'Contributia personalului la asigurarile sociale', '4312', '0'),
('431300', '', 'Contributia angajatorului pentru asigurarile sociale de sana', '4313', '0'),
('431400', '', 'Contributia angajatilor pentru asigurarile sociale de sanata', '4314', '0'),
('437000', '', 'Ajutor de somaj', '437', '0'),
('437100', '', 'Contributia unitatii la fondul de somaj', '4371', '0'),
('437200', '', 'Contributia personalului la fondul de somaj', '4372', '0'),
('438000', '', 'Alte datorii si creante sociale', '438', '0'),
('438100', '', 'Alte datorii sociale', '4381', '0'),
('438200', '', 'Alte creante sociale', '4382', '0'),
('440000', '', 'BUGETUL STATULUI, FONDURI SPECIALE SI CONTURI ASIMILATE', '44', '0'),
('441000', '', 'Impozitul pe profit/venit', '441', '0'),
('441100', '', 'Impozitul pe profit', '4411', '0'),
('441800', '', 'Impozitul pe venit', '4418', '0'),
('442000', '', 'Taxa pe valoarea adaugata', '442', '0'),
('442300', '', 'TVA de plata', '4423', '0'),
('442400', '', 'TVA de recuperat', '4424', '0'),
('442600', '', 'TVA deductibila', '4426', '0'),
('442700', '', 'TVA colectata', '4427', '0'),
('442800', '', 'TVA neexigibila', '4428', '0'),
('444000', '', 'Impozitul pe venituri de natura salariilor', '444', '0'),
('445000', '', 'Subventii', '445', '1'),
('445100', '', 'Subventii guvernamentale', '4451', '1'),
('445200', '', 'Imprumuturi nerambursabile cu caracter de subventii', '4452', '1'),
('445800', '', 'Alte sume primite cu caracter de subventii', '4458', '1'),
('446000', '', 'Alte impozite, taxe si varsaminte asimilate', '446', '0'),
('447000', '', 'Fonduri speciale - taxe si varsaminte asimilate', '447', '0'),
('448000', '', 'Alte datorii si creante cu bugetul statului', '448', '0'),
('448100', '', 'Alte datorii fata de bugetul statului', '4481', '0'),
('448200', '', 'Alte creante privind bugetul statului', '4482', '0'),
('450000', '', 'GRUP SI ACTIONARI/ASOCIATI', '45', '0'),
('451000', '', 'Decontari intre entitatile afiliate', '451', '1'),
('451100', '', 'Decontari intre entitatile afiliate', '4511', '1'),
('451800', '', 'Dobanzi aferente decontarilor intre entitatile afiliate', '4518', '1'),
('453000', '', 'Decontari privind interesele de participare', '453', '1'),
('453100', '', 'Decontari privind interesele de participare', '4531', '1'),
('453800', '', 'Dobanzi aferente decontarilor privind interesele de particip', '4538', '1'),
('455000', '', 'Sume datorate actionarilor/asociatilor', '455', '0'),
('455100', '', 'Actionari/asociati - conturi curente', '4551', '0'),
('455800', '', 'Actionari/asociati - dobanzi la conturi curente', '4558', '1'),
('456000', '', 'Decontari cu actionarii/asociatii privind capitalul', '456', '1'),
('457000', '', 'Dividende de plata', '457', '0'),
('458000', '', 'Decontari din operatii in participatie', '458', '1'),
('458100', '', 'Decontari din operatii in participatie - pasiv', '4581', '1'),
('458200', '', 'Decontari din operatii in participatie - activ', '4582', '1'),
('460000', '', 'DEBITORI SI CREDITORI DIVERSI', '46', '1'),
('461000', '', 'Debitori diversi', '461', '0'),
('462000', '', 'Creditori diversi', '462', '0'),
('470000', '', 'CONTURI DE SUBVENTII, REGULARIZARE SI ASIMILATE', '47', '1'),
('471000', '', 'Cheltuieli inregistrate in avans', '471', '0'),
('472000', '', 'Venituri inregistrate in avans', '472', '0'),
('473000', '', 'Decontari din operatii in curs de clarificare', '473', '0'),
('475000', '', 'SUBVENTII PENTRU INVESTITII', '475', '1'),
('475100', '', 'Subventii guvernamentale pentru investitii', '4751', '1'),
('475200', '', 'Imprumuturi nerambursabile cu caracter de subventii pentru i', '4752', '1'),
('475300', '', 'Donatii pentru investitii', '4753', '1'),
('475400', '', 'Plusuri de inventar de natura imobilizarilor', '4754', '1'),
('475800', '', 'Alte sume primite cu caracter de subventii pentru investitii', '4758', '1'),
('480000', '', 'DECONTARI IN CADRUL UNITATII', '48', '1'),
('481000', '', 'Decontari intre unitate si subunitati', '481', '1'),
('482000', '', 'Decontari intre subunitati', '482', '1'),
('490000', '', 'AJUSTARI PENTRU DEPRECIEREA CREANTELOR', '49', '1'),
('491000', '', 'Ajustari pentru deprecierea creantelor - clienti', '491', '1'),
('495000', '', 'Ajustari pentru deprecierea creantelor - decontari in cadrul', '495', '1'),
('496000', '', 'Ajustari pentru deprecierea creantelor - debitori diversi', '496', '1'),
('500000', '', 'INVESTITII PE TERMEN SCURT', '50', '1'),
('501000', '', 'Actiuni detinute la entitatile afiliate', '501', '1'),
('505000', '', 'Obligatiuni emise si rascumparate', '505', '1'),
('506000', '', 'Obligatiuni', '506', '1'),
('508000', '', 'Alte investitii pe termen scurt si creante asimilate', '508', '1'),
('508100', '', 'Alte titluri de plasament', '5081', '1'),
('508800', '', 'Dobanzi la obligatiuni si titluri de plasament', '5088', '1'),
('509000', '', 'Varsaminte de efectuat pentru investitiile pe termen scurt', '509', '1'),
('509100', '', 'Varsaminte de efectuat pentru actiunile detinute la entitati', '5091', '1'),
('509200', '', 'Varsaminte de efectuat pentru alte investitii pe termen scur', '5092', '1'),
('510000', '', 'CONTURI LA BANCI', '51', '0'),
('511000', '', 'Valori de incasat', '511', '1'),
('511200', '', 'Cecuri de incasat', '5112', '1'),
('511300', '', 'Efecte de incasat', '5113', '1'),
('511400', '', 'Efecte remise spre scontare', '5114', '1'),
('512000', '', 'Conturi curente la banci', '512', '0'),
('512100', '', 'Conturi la banci in lei', '5121', '0'),
('512400', '', 'Conturi la banci in valuta', '5124', '0'),
('512500', '', 'Sume in curs de decontare', '5125', '1'),
('518000', '', 'Dobanzi', '518', '1'),
('518600', '', 'Dobanzi de platit', '5186', '1'),
('518700', '', 'Dobanzi de incasat', '5187', '1'),
('519000', '', 'Credite bancare pe termen scurt', '519', '1'),
('519100', '', 'Credite bancare pe termen scurt', '5191', '1'),
('519200', '', 'Credite bancare pe termen scurt nerambursate la scadenta', '5192', '1'),
('519300', '', 'Credite externe guvernamentale', '5193', '1'),
('519400', '', 'Credite externe garantate de stat', '5194', '1'),
('519500', '', 'Credite externe garantate de banci', '5195', '1'),
('519600', '', 'Credite de la trezoreria statului', '5196', '1'),
('519700', '', 'Credite interne garantate de stat', '5197', '1'),
('519800', '', 'Dobanzi aferente creditelor bancare pe termen scurt', '5198', '1'),
('530000', '', 'CASA', '53', '1'),
('531000', '', 'Casa', '531', '1'),
('531100', '', 'Casa in lei', '5311', '0'),
('531400', '', 'Casa in valuta', '5314', '0'),
('532000', '', 'Alte valori', '532', '1'),
('532100', '', 'Timbre fiscale si postale', '5321', '1'),
('532200', '', 'Bilete de tratament si odihna', '5322', '1'),
('532300', '', 'Tichete si bilete de calatorie', '5323', '1'),
('532800', '', 'Alte valori', '5328', '1'),
('540000', '', 'ACREDITIVE', '54', '1'),
('541000', '', 'Acreditive', '541', '1'),
('541100', '', 'Acreditive in lei', '5411', '1'),
('541200', '', 'Acreditive in valuta', '5412', '1'),
('542000', '', 'Avansuri de trezorerie', '542', '0'),
('580000', '', 'VIRAMENTE INTERNE', '58', '1'),
('581000', '', 'Viramente interne', '581', '0'),
('590000', '', 'AJUSTARI PENTRU PIERDEREA DE VALOARE A CONTURILOR DE TREZORE', '59', '1'),
('591000', '', 'Ajustari pentru pierderea de valoare a actiunilor detinute l', '591', '1'),
('595000', '', 'Ajustari pentru pierderea de valoare a obligatiunilor emise ', '595', '1'),
('596000', '', 'Ajustari pentru pierderea de valoare a obligatiunilor', '596', '1'),
('598000', '', 'Ajustari pentru pierderea de valoare a altor investitii pe t', '598', '1'),
('600000', '', 'CHELTUIELI PRIVIND STOCURILE', '60', '0'),
('601000', '', 'Cheltuieli cu materiile prime', '601', '0'),
('602000', '', 'Cheltuieli cu materialele consumabile', '602', '0'),
('602100', '', 'Cheltuieli cu materialele auxiliare', '6021', '0'),
('602200', '', 'Cheltuieli privind combustibilii', '6022', '0'),
('602300', '', 'Cheltuieli privind materialele pentru ambalat', '6023', '0'),
('602400', '', 'Cheltuieli privind piesele de schimb', '6024', '0'),
('602500', '', 'Cheltuieli privind semintele si materialele de plantat', '6025', '1'),
('602600', '', 'Cheltuieli privind furajele', '6026', '1'),
('602800', '', 'Cheltuieli privind alte materiale consumabile', '6028', '0'),
('603000', '', 'Cheltuieli privind materialele de natura obiectelor de inven', '603', '0'),
('604000', '', 'Cheltuieli privind materialele nestocate', '604', '0'),
('605000', '', 'Cheltuieli privind energia si apa', '605', '0'),
('606000', '', 'Cheltuieli privind animalele si pasarile', '606', '1'),
('607000', '', 'Cheltuieli privind marfurile', '607', '0'),
('608000', '', 'Cheltuieli privind ambalajele', '608', '0'),
('609000', '', 'Reduceri comerciale primite', '609', '0'),
('610000', '', 'CHELTUIELI CU SERVICIILE EXECUTATE DE TERTI', '61', '0'),
('611000', '', 'Cheltuieli cu intretinerea si reparatiile', '611', '0'),
('612000', '', 'Cheltuieli cu redeventele, locatiile de gestiune si chiriile', '612', '0'),
('613000', '', 'Cheltuieli cu primele de asigurare', '613', '0'),
('614000', '', 'Cheltuieli cu studiile si cercetarile', '614', '0'),
('620000', '', 'CHELTUIELI CU ALTE SERVICII EXECUTATE DE TERTI', '62', '0'),
('621000', '', 'Cheltuieli cu colaboratorii', '621', '0'),
('622000', '', 'Cheltuieli privind comisioanele si onorariile', '622', '0'),
('623000', '', 'Cheltuieli de protocol, reclama si publicitate', '623', '0'),
('624000', '', 'Cheltuieli cu transportul de bunuri si personal', '624', '0'),
('625000', '', 'Cheltuieli cu deplasari, detasari si transferari', '625', '0'),
('626000', '', 'Cheltuieli postale si taxe de telecomunicatii', '626', '0'),
('627000', '', 'Cheltuieli cu serviciile bancare si asimilate', '627', '0'),
('628000', '', 'Alte cheltuieli cu serviciile executate de terti', '628', '0'),
('630000', '', 'CHELTUIELI CU ALTE IMPOZITE, TAXE SI VARSAMINTE ASIMILATE', '63', '0'),
('635000', '', 'Cheltuieli cu alte impozite, taxe si varsaminte asimilate', '635', '0'),
('640000', '', 'CHELTUIELI CU PERSONALUL', '64', '0'),
('641000', '', 'Cheltuieli cu salariile personalului', '641', '0'),
('642000', '', 'Cheltuieli cu tichetele de masa acordate salariatilor', '642', '0'),
('643000', '', 'Cheltuieli cu primele reprezentand participarea pers. la pro', '643', '0'),
('644000', '', 'Cheltuieli cu remunerarea in instrumente de capitaluri propr', '644', '0'),
('645000', '', 'Cheltuieli privind asigurarile si protectia sociala', '645', '0'),
('645100', '', 'Contributia unitatii la asigurarile sociale', '6451', '0'),
('645200', '', 'Contributia unitatii pentru ajutorul de somaj', '6452', '0'),
('645300', '', 'Contributia angajatorului pentru asigurarile sociale de sana', '6453', '0'),
('645600', '', 'Contributia unitatii la schemele de pensii facultative', '6456', '0'),
('645700', '', 'Contributia unitatii la primele de asigurare voluntara de sa', '6457', '0'),
('645800', '', 'Alte cheltuieli privind asigurarile si protectia sociala', '6458', '0'),
('650000', '', 'ALTE CHELTUIELI DE EXPLOATARE', '65', '0'),
('652000', '', 'Cheltuieli cu protectia mediului inconjur.tor', '652', '0'),
('654000', '', 'Pierderi din creante si debitori diversi', '654', '0'),
('658000', '', 'Alte cheltuieli de exploatare', '658', '0'),
('658100', '', 'Despagubiri, amenzi si penalitati', '6581', '0'),
('658200', '', 'Donatii acordate', '6582', '0'),
('658300', '', 'Cheltuieli privind activele cedate si alte operatii de capit', '6583', '0'),
('658800', '', 'Alte cheltuieli de exploatare', '6588', '0'),
('660000', '', 'CHELTUIELI FINANCIARE', '66', '0'),
('663000', '', 'Pierderi din creante legate de participatii', '663', '0'),
('664000', '', 'Cheltuieli privind investitiile financiare cedate', '664', '0'),
('664100', '', 'Cheltuieli privind imobilizarile financiare cedate', '6641', '0'),
('664200', '', 'Pierderi din investitiile pe termen scurt cedate', '6642', '0'),
('665000', '', 'Cheltuieli din diferente de curs valutar', '665', '0'),
('666000', '', 'Cheltuieli privind dobanzile', '666', '0'),
('667000', '', 'Cheltuieli privind sconturile acordate', '667', '0'),
('668000', '', 'Alte cheltuieli financiare', '668', '0'),
('670000', '', 'CHELTUIELI EXTRAORDINARE', '67', '0'),
('671000', '', 'Cheltuieli privind calamitatile si alte evenimente extraordi', '671', '0'),
('680000', '', 'CHELTUIELI CU AMORTIZARILE, PROVIZIOANELE SI AJUSTARILE PENT', '68', '0'),
('681000', '', 'Cheltuieli de exploatare privind amortizarile, provizioanele', '681', '0'),
('681100', '', 'Cheltuieli de exploatare privind amortizarea imobilizarilor', '6811', '0'),
('681200', '', 'Cheltuieli de exploatare privind provizioanele', '6812', '0'),
('681300', '', 'Cheltuieli de exploatare privind ajustarile pentru deprecier', '6813', '0'),
('681400', '', 'Cheltuieli de exploatare privind ajustarile pentru deprecier', '6814', '0'),
('686000', '', 'Cheltuieli financiare privind amortizarile si ajustarile pen', '686', '0'),
('686300', '', 'Cheltuieli financiare privind ajustarile pentru pierderea de', '6863', '0'),
('686400', '', 'Cheltuieli financiare privind ajustarile pentru pierderea de', '6864', '0'),
('686800', '', 'Cheltuieli financiare privind amortizarea primelor de rambur', '6868', '0'),
('690000', '', 'CHELTUIELI CU IMPOZITUL PE PROFIT SI ALTE IMPOZITE', '69', '0'),
('691000', '', 'Cheltuieli cu impozitul pe profit', '691', '0'),
('698000', '', 'Cheltuieli cu impozitul pe venit si cu alte impozite care nu', '698', '0'),
('700000', '', 'CIFRA DE AFACERI NETA', '70', '0'),
('701000', '', 'Venituri din vanzarea produselor finite', '701', '0'),
('702000', '', 'Venituri din vanzarea semifabricatelor', '702', '0'),
('703000', '', 'Venituri din vanzarea produselor reziduale', '703', '0'),
('704000', '', 'Venituri din servicii prestate', '704', '0'),
('705000', '', 'Venituri din studii si cercetari', '705', '0'),
('706000', '', 'Venituri din redevente, locatii de gestiune si chirii', '706', '0'),
('707000', '', 'Venituri din vanzarea marfurilor', '707', '0'),
('708000', '', 'Venituri din activitati diverse', '708', '0'),
('709000', '', 'Reduceri comerciale acordate', '709', '0'),
('710000', '', 'VENITURI AFERENTE COSTULUI PRODUCTIEI IN CURS DE EXECUTIE', '71', '0'),
('711000', '', 'Venituri aferente costurilor stocurilor de produse', '711', '0'),
('712000', '', 'Venituri aferente costurilor serviciilor in curs de executie', '712', '0'),
('720000', '', 'VENITURI DIN PRODUCTIA DE IMOBILIZARI', '72', '0'),
('721000', '', 'Venituri din productia de imobilizari necorporale', '721', '0'),
('722000', '', 'Venituri din producaia de imobilizari corporale', '722', '0'),
('740000', '', 'VENITURI DIN SUBVENTII DE EXPLOATARE', '74', '0'),
('741000', '', 'Venituri din subventii de exploatare', '741', '0'),
('741100', '', 'Venituri din subventii de exploatare aferente cifrei de afac', '7411', '0'),
('741200', '', 'Venituri din subventii de exploatare pentru materii prime si', '7412', '0'),
('741300', '', 'Venituri din subventii de exploatare pentru alte cheltuieli ', '7413', '0'),
('741400', '', 'Venituri din subventii de exploatare pentru plata personalul', '7414', '0'),
('741500', '', 'Venituri din subventii de exploatare pentru asigurari si pro', '7415', '0'),
('741600', '', 'Venituri din subventii de exploatare pentru alte cheltuieli ', '7416', '0'),
('741700', '', 'Venituri din subventii de exploatare aferente altor venituri', '7417', '0'),
('741800', '', 'Venituri din subventii de exploatare pentru dobanda datorata', '7418', '0'),
('750000', '', 'ALTE VENITURI DIN EXPLOATARE', '75', '0'),
('754000', '', 'Venituri din creante reactivate si debitori diversi', '754', '0'),
('758000', '', 'Alte venituri din exploatare', '758', '0'),
('758100', '', 'Venituri din despagubiri, amenzi si penalitati', '7581', '0'),
('758200', '', 'Venituri din donatii primite', '7582', '0'),
('758300', '', 'Venituri din vanzarea activelor si alte operatii de capital', '7583', '0'),
('758400', '', 'Venituri din subventii pentru investitii', '7584', '0'),
('758800', '', 'Alte venituri din exploatare', '7588', '0'),
('760000', '', 'VENITURI FINANCIARE', '76', '0'),
('761000', '', 'Venituri din imobilizari financiare', '761', '0'),
('761100', '', 'Venituri din actiuni detinute la entitatile afiliate', '7611', '0'),
('761300', '', 'Venituri din interese de participare', '7613', '0'),
('762000', '', 'Venituri din investitii financiare pe termen scurt', '762', '0'),
('763000', '', 'Venituri din creante imobilizate', '763', '0'),
('764000', '', 'Venituri din investitii financiare cedate', '764', '0'),
('764100', '', 'Venituri din imobilizari financiare cedate', '7641', '0'),
('764200', '', 'Castiguri din investitii pe termen scurt cedate', '7642', '0'),
('765000', '', 'Venituri din diferen.e de curs valutar', '765', '0'),
('766000', '', 'Venituri din dobanzi', '766', '0'),
('767000', '', 'Venituri din sconturi obtinute', '767', '0'),
('768000', '', 'Alte venituri financiare', '768', '0'),
('770000', '', 'VENITURI EXTRAORDINARE', '77', '0'),
('771000', '', 'Venituri din subventii pentru evenimente extraordinare si al', '771', '0'),
('780000', '', 'VENITURI DIN PROVIZIOANE SI AJUSTARI PENTRU DEPRECIERE SAU P', '78', '0'),
('781000', '', 'Venituri din provizioane si ajustari pentru depreciere privi', '781', '0'),
('781200', '', 'Venituri din provizioane', '7812', '0'),
('781300', '', 'Venituri din ajustari pentru deprecierea imobilizarilor', '7813', '0'),
('781400', '', 'Venituri din ajustari pentru deprecierea activelor circulant', '7814', '0'),
('781500', '', 'Venituri din fondul comercial negativ', '7815', '0'),
('786000', '', 'Venituri financiare din ajustari pentru pierdere de valoare', '786', '0'),
('786300', '', 'Venituri financiare din ajustari pentru pierderea de valoare', '7863', '0'),
('786400', '', 'Venituri financiare din ajustari pentru pierderea de valoare', '7864', '0'),
('800000', '', 'CONTURI IN AFARA BILANTULUI', '80', '0'),
('801000', '', 'Angajamente acordate', '801', '0'),
('801100', '', 'Giruri si garantii acordate', '8011', '0'),
('801800', '', 'Alte angajamente acordate', '8018', '0'),
('802000', '', 'Angajamente primite', '802', '0'),
('802100', '', 'Giruri si garantii primite', '8021', '0'),
('802800', '', 'Alte angajamente primite', '8028', '0'),
('803000', '', 'Alte conturi in afara bilantului', '803', '0'),
('803100', '', 'Imobilizari corporale luate cu chirie', '8031', '0'),
('803200', '', 'Valori materiale primite spre prelucrare sau reparare', '8032', '0'),
('803300', '', 'Valori materiale primite in pastrare sau custodie', '8033', '0'),
('803400', '', 'Debitori scosi din activ, urmariti in continuare', '8034', '0'),
('803500', '', 'Stocuri de natura obiectelor de inventar date in folosinta', '8035', '0'),
('803600', '', 'Redevente, locatii de gestiune, chirii si alte datorii asimi', '8036', '0'),
('803700', '', 'Efecte scontate neajunse la scadenta', '8037', '0'),
('803800', '', 'Bunuri publice primite in administrare, concesiune si cu chi', '8038', '0'),
('803900', '', 'Alte valori in afara bilantului', '8039', '0'),
('804000', '', 'Amortizarea aferenta gradului de neutilizare a mijloacelor f', '804', '0'),
('804500', '', 'Amortizarea aferenta gradului de neutilizare a mijloacelor f', '8045', '0'),
('805000', '', 'Dobanzi aferente contractelor de leasing si altor contracte ', '805', '0'),
('805100', '', 'Dobanzi de platit', '8051', '0'),
('805200', '', 'Dobanzi de incasat', '8052', '0'),
('806000', '', 'Certificate de emisii de gaze cu efect de sera', '806', '0'),
('807000', '', 'Active contingente', '807', '0'),
('808000', '', 'Datorii contingente', '808', '0'),
('890000', '', 'BILANT', '89', '0'),
('891000', '', 'Bilant de deschidere', '891', '0'),
('892000', '', 'Bilant de inchidere', '892', '0'),
('900000', '', 'DECONTARI INTERNE', '90', '0'),
('901000', '', 'Decontari interne privind cheltuielile', '901', '0'),
('902000', '', 'Decontari interne privind productia obtinuta', '902', '0'),
('903000', '', 'Decontari interne privind diferentele de pret', '903', '0'),
('920000', '', 'CONTURI DE CALCULATIE', '92', '0'),
('921000', '', 'Cheltuielile activitatii de baza', '921', '0'),
('922000', '', 'Cheltuielile activitatilor auxiliare', '922', '0'),
('923000', '', 'Cheltuieli indirecte de productie', '923', '0'),
('924000', '', 'Cheltuieli generale de administratie', '924', '0'),
('925000', '', 'Cheltuieli de desfacere', '925', '0'),
('930000', '', 'COSTUL PRODUCTIEI', '93', '0'),
('931000', '', 'Costul productiei obtinute', '931', '0'),
('933000', '', 'Costul productiei in curs de executie', '933', '0');

### Structure of table `0_chart_types` ###

DROP TABLE IF EXISTS `0_chart_types`;

CREATE TABLE `0_chart_types` (
  `id` varchar(10) NOT NULL,
  `name` varchar(60) NOT NULL DEFAULT '',
  `class_id` varchar(3) NOT NULL DEFAULT '',
  `parent` varchar(10) NOT NULL DEFAULT '-1',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `class_id` (`class_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

### Data of table `0_chart_types` ###

INSERT INTO `0_chart_types` VALUES
('1016', '1016 Patrimoniul public', '1', '101', '1'),
('1015', '1015 Patrimoniul regiei', '1', '101', '1'),
('1012', '1012 Capital subscris varsat', '1', '101', '0'),
('1011', '1011 Capital subscris nevarsat', '1', '101', '0'),
('101', '101 Capital social', '1', '10', '0'),
('10', '10 CAPITAL SI REZERVE', '1', '', '0'),
('104', '104 Prime de capital', '1', '10', '1'),
('1041', '1041 Prime de emisiune', '1', '104', '1'),
('1042', '1042 Prime de fuziune/divizare', '1', '104', '1'),
('1043', '1043 Prime de aport', '1', '104', '1'),
('1044', '1044 Prime de conversie a obligatiunilor in actiuni', '1', '104', '1'),
('105', '105 Rezerve din reevaluare', '1', '10', '1'),
('106', '106 Rezerve', '1', '10', '0'),
('1061', '1061 Rezerve legale', '1', '106', '0'),
('1063', '1063 Rezerve statutare sau contractuale', '1', '106', '1'),
('1064', '1064 Rezerve de valoare justa', '1', '106', '1'),
('1065', '1065 Rezerve reprezentand surplusul realizat din rezerve din', '1', '106', '1'),
('1067', '1067 Rezerve din dif. de curs valutar in relatie cu investit', '1', '106', '1'),
('1068', '1068 Alte rezerve', '1', '106', '1'),
('107', '107 Rezerve din conversie', '1', '10', '1'),
('108', '108 Interese care nu controleaza', '1', '10', '1'),
('1081', '1081 Interese care nu controleaza - rezultatul exercitiului ', '1', '108', '1'),
('1082', '1082 Interese care nu controleaza - alte capitaluri proprii', '1', '108', '1'),
('109', '109 Actiuni proprii', '1', '10', '1'),
('1091', '1091 Actiuni proprii detinute pe termen scurt', '1', '109', '1'),
('1092', '1092 Actiuni proprii detinute pe termen lung', '1', '109', '1'),
('11', '11 REZULTATUL REPORTAT', '1', '', '0'),
('117', '117 Rezultatul reportat', '1', '11', '0'),
('1171', '1171 Rezultatul reportat reprezentand profitul nerepartizat ', '1', '117', '0'),
('1172', '1172 Rezultatul reportat provenit din adoptarea pentru prima', '1', '117', '1'),
('1174', '1174 Rezultatul reportat provenit din corectarea erorilor co', '1', '117', '1'),
('1176', '1176 Rezultatul reportat provenit din trecerea la aplicarea ', '1', '117', '1'),
('12', '12 REZULTATUL EXERCITIULUI FINANCIAR', '1', '', '0'),
('121', '121 Profit sau pierdere', '1', '12', '0'),
('129', '129 Repartizarea profitului', '1', '12', '0'),
('14', '14 CASTIGURI SAU PIERDERI LEGATE DE EMITEREA, RASCUMPARAREA,', '1', '', '1'),
('141', '141 Castiguri legate de vanzarea sau anularea instrumentelor', '1', '14', '1'),
('149', '149 Pierderi legate de emiterea, rascumpararea, vanzarea, ce', '1', '14', '1'),
('15', '15 PROVIZIOANE', '1', '', '1'),
('151', '151 Provizioane', '1', '15', '1'),
('1511', '1511 Provizioane pentru litigii', '1', '151', '1'),
('1512', '1512 Provizioane pentru garantii acordate clientilor', '1', '151', '1'),
('1513', '1513 Provizioane pentru dezafectare imobilizari corporale si', '1', '151', '1'),
('1514', '1514 Provizioane pentru restructurare', '1', '151', '1'),
('1515', '1515 Provizioane pentru pensii si obligatii similare', '1', '151', '1'),
('1516', '1516 Provizioane pentru impozite', '1', '151', '1'),
('1518', '1518 Alte provizioane', '1', '151', '1'),
('16', '16 IMPRUMUTURI SI DATORII ASIMILATE', '1', '', '1'),
('161', '161 Imprumuturi din emisiuni de obligatiuni', '1', '16', '1'),
('1614', '1614 Imprumuturi externe din emisiuni de obligatiuni garanta', '1', '161', '1'),
('1615', '1615 Imprumuturi externe din emisiuni de obligatiuni garanta', '1', '161', '1'),
('1617', '1617 Imprumuturi interne din emisiuni de obligatiuni garanta', '1', '161', '1'),
('1618', '1618 Alte imprumuturi din emisiuni de obligatiuni', '1', '161', '1'),
('162', '162 Credite bancare pe termen lung', '1', '16', '1'),
('1621', '1621 Credite bancare pe termen lung', '1', '162', '1'),
('1622', '1622 Credite bancare pe termen lung nerambursate la scadenta', '1', '162', '1'),
('1623', '1623 Credite externe guvernamentale', '1', '162', '1'),
('1624', '1624 Credite bancare externe garantate de stat', '1', '162', '1'),
('1625', '1625 Credite bancare externe garantate de banci', '1', '162', '1'),
('1626', '1626 Credite de la trezoreria statului', '1', '162', '1'),
('1627', '1627 Credite bancare interne garantate de stat', '1', '162', '1'),
('166', '166 Datorii care privesc imobilizarile financiare', '1', '16', '1'),
('1661', '1661 Datorii fata de entititile afiliate', '1', '166', '1'),
('1663', '1663 Datorii fata de entititile de care compania este legata', '1', '166', '1'),
('167', '167 Alte imprumuturi si datorii asimilate', '1', '16', '1'),
('168', '168 Dobanzi aferente imprumuturilor si datoriilor asimilate', '1', '16', '1'),
('1681', '1681 Dobanzi aferente imprumuturilor din emisiuni de obligat', '1', '168', '1'),
('1682', '1682 Dobanzi aferente creditelor bancare pe termen lung', '1', '168', '1'),
('1685', '1685 Dobanzi aferente datoriilor fata de entitatile afiliate', '1', '168', '1'),
('1686', '1686 Dobanzi aferente datoriilor fata de entitatile de care ', '1', '168', '1'),
('1687', '1687 Dobanzi aferente altor imprumuturi si datorii asimilate', '1', '168', '1'),
('169', '169 Prime privind rambursarea obligatiunilor', '1', '16', '1'),
('20', '20 IMOBILIZARI NECORPORALE', '2', '', '0'),
('201', '201 Cheltuieli de constituire', '2', '20', '0'),
('203', '203 Cheltuieli de dezvoltare', '2', '20', '1'),
('205', '205 Concesiuni, brevete, licente, marci comerciale, drepturi', '2', '20', '1'),
('207', '207 Fond comercial', '2', '20', '1'),
('2075', '2075 Fond comercial negativ', '2', '207', '1'),
('208', '208 Alte imobilizari necorporale', '2', '20', '1'),
('21', '21 IMOBILIZARI CORPORALE', '2', '', '0'),
('211', '211 Terenuri si amenajari de terenuri', '2', '21', '1'),
('2111', '2111 Terenuri', '2', '211', '1'),
('2112', '2112 Amenajari de terenuri', '2', '211', '1'),
('212', '212 Constructii', '2', '21', '1'),
('213', '213 Instalatii tehnice, mijloace de transport, animale si pl', '2', '21', '0'),
('2131', '2131 Echipamente tehnologice (masini, utilaje si instalatii ', '2', '213', '1'),
('2132', '2132 Aparate si instalatii de masurare, control si reglare', '2', '213', '0'),
('2133', '2133 Mijloace de transport', '2', '213', '1'),
('2134', '2134 Animale si plantatii', '2', '213', '1'),
('214', '214 Mobilier, ap. birotica, echipamente de protectie a valor', '2', '21', '1'),
('22', '22 IMOBILIZARI CORPORALE IN CURS DE APROVIZIONARE', '2', '', '1'),
('223', '223 Instalatii tehnice, mijl. de transport, animale si plant', '2', '22', '1'),
('224', '224 Mobilier, ap. birotica, echipamente de protectie a valor', '2', '22', '1'),
('23', '23 IMOBILIZARI IN CURS SI AVANSURI PENTRU IMOBILIZARI', '2', '', '1'),
('231', '231 Imobilizari corporale in curs de executie', '2', '23', '1'),
('232', '232 Avansuri acordate pentru imobilizari corporale', '2', '23', '1'),
('233', '233 Imobilizari necorporale in curs de executie', '2', '23', '1'),
('234', '234 Avansuri acordate pentru imobilizari necorporale', '2', '23', '1'),
('26', '26 IMOBILIZARI FINANCIARE', '2', '', '1'),
('261', '261 Actiuni detinute la entititile afiliate', '2', '26', '1'),
('263', '263 Interese de participare', '2', '26', '1'),
('264', '264 Titluri puse in echivalenta', '2', '26', '1'),
('265', '265 Alte titluri imobilizate', '2', '26', '1'),
('267', '267 Creante imobilizate', '2', '26', '1'),
('2671', '2671 Sume datorate de entititile afiliate', '2', '267', '1'),
('2672', '2672 Dobanda aferenta sumelor datorate de entititile afiliat', '2', '267', '1'),
('2673', '2673 Creante legate de interesele de participare', '2', '267', '1'),
('2674', '2674 Dobanda aferenta creantelor legate de interesele de par', '2', '267', '1'),
('2675', '2675 Imprumuturi acordate pe termen lung', '2', '267', '1'),
('2676', '2676 Dobanda aferenta imprumuturilor acordate pe termen lung', '2', '267', '1'),
('2678', '2678 Alte creante imobilizate', '2', '267', '1'),
('2679', '2679 Dobanzi aferente altor creante imobilizate', '2', '267', '1'),
('269', '269 Varsaminte de efectuat pentru imobilizari financiare', '2', '26', '1'),
('2691', '2691 Varsaminte de efectuat privind actiunile detinute la en', '2', '269', '1'),
('2692', '2692 Varsaminte de efectuat privind interesele de participar', '2', '269', '1'),
('2693', '2693 Varsaminte de efectuat pentru alte imobilizari financia', '2', '269', '1'),
('28', '28 AMORTIZARI PRIVIND IMOBILIZARILE', '2', '', '0'),
('280', '280 Amortizari privind imobilizarile necorporale', '2', '28', '0'),
('2801', '2801 Amortizarea cheltuielilor de constituire', '2', '280', '0'),
('2803', '2803 Amortizarea cheltuielilor de dezvoltare', '2', '280', '1'),
('2805', '2805 Amortizarea concesiunilor, brevetelor, licentelor, marc', '2', '280', '1'),
('2807', '2807 Amortizarea fondului comercial', '2', '280', '1'),
('2808', '2808 Amortizarea altor imobilizari necorporale', '2', '280', '1'),
('281', '281 Amortizari privind imobilizarile corporale', '2', '28', '0'),
('2811', '2811 Amortizarea amenajarilor de terenuri', '2', '281', '1'),
('2812', '2812 Amortizarea constructiilor', '2', '281', '1'),
('2813', '2813 Amortizarea instalatiilor, mijloacelor de transport, an', '2', '281', '0'),
('2814', '2814 Amortizarea altor imobilizari corporale', '2', '281', '1'),
('29', '29 AJUSTARI PENTRU DEPRECIEREA SAU PIERDEREA DE VALOARE A IM', '2', '', '1'),
('290', '290 Ajustari pentru deprecierea imobilizarilor necorporale', '2', '29', '1'),
('2903', '2903 Ajustari pentru deprecierea cheltuielilor de dezvoltare', '2', '290', '1'),
('2905', '2905 Ajustari pentru deprecierea concesiunilor, brevetelor, ', '2', '290', '1'),
('2907', '2907 Ajustari pentru deprecierea fondului comercial', '2', '290', '1'),
('2908', '2908 Ajustari pentru deprecierea altor imobilizari necorpora', '2', '290', '1'),
('291', '291 Ajustari pentru deprecierea imobilizarilor corporale', '2', '29', '1'),
('2911', '2911 Ajustari pentru deprecierea terenurilor si amenajarilor', '2', '291', '1'),
('2912', '2912 Ajustari pentru deprecierea constructiilor', '2', '291', '1'),
('2913', '2913 Ajustari pentru deprecierea instalatiilor, mijloacelor ', '2', '291', '1'),
('2914', '2914 Ajustari pentru deprecierea altor imobilizari corporale', '2', '291', '1'),
('293', '293 Ajustari pentru deprecierea imobilizarilor in curs de ex', '2', '29', '1'),
('2931', '2931 Ajustari pentru deprecierea imobilizarilor corporale in', '2', '293', '1'),
('2933', '2933 Ajustari pentru deprecierea imobilizarilor necorporale ', '2', '293', '1'),
('296', '296 Ajustari pentru pierderea de valoare a imobilizarilor fi', '2', '29', '1'),
('2961', '2961 Ajustari pentru pierderea de valoare a actiunilor detin', '2', '296', '1'),
('2962', '2962 Ajustari pentru pierderea de valoare a intereselor de p', '2', '296', '1'),
('2963', '2963 Ajustari pentru pierderea de valoare a altor titluri im', '2', '296', '1'),
('2964', '2964 Ajustari pentru pierderea de valoare a sumelor datorate', '2', '296', '1'),
('2965', '2965 Ajustari pentru pierderea de valoare a creantelor legat', '2', '296', '1'),
('2966', '2966 Ajustari pentru pierderea de valoare a imprumuturilor a', '2', '296', '1'),
('2968', '2968 Ajustari pentru pierderea de valoare a altor creante im', '2', '296', '1'),
('30', '30 STOCURI DE MATERII PRIME SI MATERIALE', '3', '', '0'),
('301', '301 Materii prime', '3', '30', '0'),
('302', '302 Materiale consumabile', '3', '30', '1'),
('3021', '3021 Materiale auxiliare', '3', '302', '0'),
('3022', '3022 Combustibili', '3', '302', '1'),
('3023', '3023 Materiale pentru ambalat', '3', '302', '1'),
('3024', '3024 Piese de schimb', '3', '302', '1'),
('3025', '3025 Seminte si materiale de plantat', '3', '302', '1'),
('3026', '3026 Furaje', '3', '302', '1'),
('3028', '3028 Alte materiale consumabile', '3', '302', '1'),
('303', '303 Materiale de natura obiectelor de inventar', '3', '30', '0'),
('308', '308 Diferente de pret la materii prime si materiale', '3', '30', '0'),
('32', '32 STOCURI IN CURS DE APROVIZIONARE', '3', '', '1'),
('321', '321 Materii prime in curs de aprovizionare', '3', '32', '1'),
('322', '322 Materiale consumabile in curs de aprovizionare', '3', '32', '1'),
('323', '323 Materiale de natura obiectelor de inventar in curs de ap', '3', '32', '1'),
('326', '326 Animale in curs de aprovizionare', '3', '32', '1'),
('327', '327 Marfuri in curs de aprovizionare', '3', '32', '1'),
('328', '328 Ambalaje in curs de aprovizionare', '3', '32', '1'),
('33', '33 PRODUCTIE IN CURS DE EXECUTIE', '3', '', '1'),
('331', '331 Produse in curs de executie', '3', '33', '1'),
('332', '332 Servicii in curs de executie', '3', '33', '1'),
('34', '34 PRODUSE', '3', '', '1'),
('341', '341 Semifabricate', '3', '34', '1'),
('345', '345 Produse finite', '3', '34', '1'),
('346', '346 Produse reziduale', '3', '34', '1'),
('348', '348 Diferente de pret la produse', '3', '34', '1'),
('35', '35 STOCURI AFLATE LA TERTI', '3', '', '1'),
('351', '351 Materii si materiale aflate la terti', '3', '35', '1'),
('354', '354 Produse aflate la terti', '3', '35', '1'),
('356', '356 Animale aflate la terti', '3', '35', '1'),
('357', '357 Marfuri aflate la terti', '3', '35', '1'),
('358', '358 Ambalaje aflate la terti', '3', '35', '1'),
('36', '36 ANIMALE', '3', '', '1'),
('361', '361 Animale si pasari', '3', '36', '1'),
('368', '368 Diferente de pret la animale si pasari', '3', '36', '1'),
('37', '37 MARFURI', '3', '', '0'),
('371', '371 Marfuri', '3', '37', '0'),
('378', '378 Diferente de pret la marfuri', '3', '37', '0'),
('38', '38 AMBALAJE', '3', '', '1'),
('381', '381 Ambalaje', '3', '38', '1'),
('388', '388 Diferente de pret la ambalaje', '3', '38', '1'),
('39', '39 AJUSTARI PENTRU DEPRECIEREA STOCURILOR SI PRODUCTIEI IN C', '3', '', '1'),
('391', '391 Ajustari pentru deprecierea materiilor prime', '3', '39', '1'),
('392', '392 Ajustari pentru deprecierea materialelor', '3', '39', '1'),
('3921', '3921 Ajustari pentru deprecierea materialelor consumabile', '3', '392', '1'),
('3922', '3922 Ajustari pentru deprecierea materialelor de natura obie', '3', '392', '1'),
('393', '393 Ajustari pentru deprecierea productiei in curs de execut', '3', '39', '1'),
('394', '394 Ajustari pentru deprecierea produselor', '3', '39', '1'),
('3941', '3941 Ajustari pentru deprecierea semifabricatelor', '3', '394', '1'),
('3945', '3945 Ajustari pentru deprecierea produselor finite', '3', '394', '1'),
('3946', '3946 Ajustari pentru deprecierea produselor reziduale', '3', '394', '1'),
('395', '395 Ajustari pentru deprecierea stocurilor aflate la terti', '3', '39', '1'),
('3951', '3951 Ajustari pentru deprecierea materiilor si materialelor ', '3', '395', '1'),
('3952', '3952 Ajustari pentru deprecierea semifabricatelor aflate la ', '3', '395', '1'),
('3953', '3953 Ajustari pentru deprecierea produselor finite aflate la', '3', '395', '1'),
('3954', '3954 Ajustari pentru deprecierea produselor reziduale aflate', '3', '395', '1'),
('3956', '3956 Ajustari pentru deprecierea animalelor aflate la terti', '3', '395', '1'),
('3957', '3957 Ajustari pentru deprecierea marfurilor aflate la terti', '3', '395', '1'),
('3958', '3958 Ajustari pentru deprecierea ambalajelor aflate la terti', '3', '395', '1'),
('396', '396 Ajustari pentru deprecierea animalelor', '3', '39', '1'),
('397', '397 Ajustari pentru deprecierea marfurilor', '3', '39', '1'),
('398', '398 Ajustari pentru deprecierea ambalajelor', '3', '39', '1'),
('40', '40 FURNIZORI SI CONTURI ASIMILATE', '4', '', '0'),
('401', '401 Furnizori', '4', '40', '0'),
('403', '403 Efecte de platit', '4', '40', '1'),
('404', '404 Furnizori de imobilizari', '4', '40', '1'),
('405', '405 Efecte de platit pentru imobilizari', '4', '40', '1'),
('408', '408 Furnizori - facturi nesosite', '4', '40', '1'),
('409', '409 Furnizori - debitori', '4', '40', '0'),
('4091', '4091 Furnizori - debitori pentru cumparari de bunuri de natu', '4', '409', '0'),
('4092', '4092 Furnizori - debitori pentru prestari de servicii', '4', '409', '0'),
('41', '41 CLIENTI SI CONTURI ASIMILATE', '4', '', '0'),
('411', '411 Clienti', '4', '41', '0'),
('4111', '4111 Clienti', '4', '411', '0'),
('4118', '4118 Clienti incerti sau in litigiu', '4', '411', '1'),
('413', '413 Efecte de primit de la clienti', '4', '41', '1'),
('418', '418 Clienti - facturi de intocmit', '4', '41', '1'),
('419', '419 Clienti - creditori', '4', '41', '0'),
('42', '42 PERSONAL SI CONTURI ASIMILATE', '4', '', '0'),
('421', '421 Personal - salarii datorate', '4', '42', '0'),
('423', '423 Personal - ajutoare materiale datorate', '4', '42', '1'),
('424', '424 Prime reprezentand participarea personalului la profit', '4', '42', '1'),
('425', '425 Avansuri acordate personalului', '4', '42', '0'),
('426', '426 Drepturi de personal neridicate', '4', '42', '1'),
('427', '427 Retineri din salarii datorate tertilor', '4', '42', '1'),
('428', '428 Alte datorii si creante in legatura cu personalul', '4', '42', '1'),
('4281', '4281 Alte datorii in legatura cu personalul', '4', '428', '1'),
('4282', '4282 Alte creante in legatura cu personalul', '4', '428', '1'),
('43', '43 ASIGURARI SOCIALE, PROTECTIA SOCIALA SI CONTURI ASIMILATE', '4', '', '0'),
('431', '431 Asigurari sociale', '4', '43', '0'),
('4311', '4311 Contributia unitatii la asigurarile sociale', '4', '431', '0'),
('4312', '4312 Contributia personalului la asigurarile sociale', '4', '431', '0'),
('4313', '4313 Contributia angajatorului pentru asigurarile sociale de', '4', '431', '0'),
('4314', '4314 Contributia angajatilor pentru asigurarile sociale de s', '4', '431', '0'),
('437', '437 Ajutor de somaj', '4', '43', '0'),
('4371', '4371 Contributia unitatii la fondul de somaj', '4', '437', '0'),
('4372', '4372 Contributia personalului la fondul de somaj', '4', '437', '0'),
('438', '438 Alte datorii si creante sociale', '4', '43', '1'),
('4381', '4381 Alte datorii sociale', '4', '438', '1'),
('4382', '4382 Alte creante sociale', '4', '438', '1'),
('44', '44 BUGETUL STATULUI, FONDURI SPECIALE SI CONTURI ASIMILATE', '4', '', '0'),
('441', '441 Impozitul pe profit/venit', '4', '44', '0'),
('4411', '4411 Impozitul pe profit', '4', '441', '0'),
('4418', '4418 Impozitul pe venit', '4', '441', '0'),
('442', '442 Taxa pe valoarea adaugata', '4', '44', '0'),
('4423', '4423 TVA de plata', '4', '442', '0'),
('4424', '4424 TVA de recuperat', '4', '442', '0'),
('4426', '4426 TVA deductibila', '4', '442', '0'),
('4427', '4427 TVA colectata', '4', '442', '0'),
('4428', '4428 TVA neexigibila', '4', '442', '0'),
('444', '444 Impozitul pe venituri de natura salariilor', '4', '44', '0'),
('445', '445 Subventii', '4', '44', '1'),
('4451', '4451 Subventii guvernamentale', '4', '445', '1'),
('4452', '4452 Imprumuturi nerambursabile cu caracter de subventii', '4', '445', '1'),
('4458', '4458 Alte sume primite cu caracter de subventii', '4', '445', '1'),
('446', '446 Alte impozite, taxe si varsaminte asimilate', '4', '44', '1'),
('447', '447 Fonduri speciale - taxe si varsaminte asimilate', '4', '44', '1'),
('448', '448 Alte datorii si creante cu bugetul statului', '4', '44', '1'),
('4481', '4481 Alte datorii fata de bugetul statului', '4', '448', '1'),
('4482', '4482 Alte creante privind bugetul statului', '4', '448', '1'),
('45', '45 GRUP SI ACTIONARI/ASOCIATI', '4', '', '0'),
('451', '451 Decontari intre entitatile afiliate', '4', '45', '1'),
('4511', '4511 Decontari intre entitatile afiliate', '4', '451', '1'),
('4518', '4518 Dobanzi aferente decontarilor intre entitatile afiliate', '4', '451', '1'),
('453', '453 Decontari privind interesele de participare', '4', '45', '1'),
('4531', '4531 Decontari privind interesele de participare', '4', '453', '1'),
('4538', '4538 Dobanzi aferente decontarilor privind interesele de par', '4', '453', '1'),
('455', '455 Sume datorate actionarilor/asociatilor', '4', '45', '0'),
('4551', '4551 Actionari/asociati - conturi curente', '4', '455', '0'),
('4558', '4558 Actionari/asociati - dobanzi la conturi curente', '4', '455', '1'),
('456', '456 Decontari cu actionarii/asociatii privind capitalul', '4', '45', '0'),
('457', '457 Dividende de plata', '4', '45', '0'),
('458', '458 Decontari din operatii in participatie', '4', '45', '1'),
('4581', '4581 Decontari din operatii in participatie - pasiv', '4', '458', '1'),
('4582', '4582 Decontari din operatii in participatie - activ', '4', '458', '1'),
('46', '46 DEBITORI SI CREDITORI DIVERSI', '4', '', '0'),
('461', '461 Debitori diversi', '4', '46', '0'),
('462', '462 Creditori diversi', '4', '46', '0'),
('47', '47 CONTURI DE SUBVENTII, REGULARIZARE SI ASIMILATE', '4', '', '0'),
('471', '471 Cheltuieli inregistrate in avans', '4', '47', '0'),
('472', '472 Venituri inregistrate in avans', '4', '47', '0'),
('473', '473 Decontari din operatii in curs de clarificare', '4', '47', '0'),
('475', '475 SUBVENTII PENTRU INVESTITII', '4', '47', '1'),
('4751', '4751 Subventii guvernamentale pentru investitii', '4', '475', '1'),
('4752', '4752 Imprumuturi nerambursabile cu caracter de subventii pen', '4', '475', '1'),
('4753', '4753 Donatii pentru investitii', '4', '475', '1'),
('4754', '4754 Plusuri de inventar de natura imobilizarilor', '4', '475', '1'),
('4758', '4758 Alte sume primite cu caracter de subventii pentru inves', '4', '475', '1'),
('48', '48 DECONTARI IN CADRUL UNITATII', '4', '', '1'),
('481', '481 Decontari intre unitate si subunitati', '4', '48', '1'),
('482', '482 Decontari intre subunitati', '4', '48', '1'),
('49', '49 AJUSTARI PENTRU DEPRECIEREA CREANTELOR', '4', '', '1'),
('491', '491 Ajustari pentru deprecierea creantelor - clienti', '4', '49', '1'),
('495', '495 Ajustari pentru deprecierea creantelor - decontari in ca', '4', '49', '1'),
('496', '496 Ajustari pentru deprecierea creantelor - debitori divers', '4', '49', '1'),
('50', '50 INVESTITII PE TERMEN SCURT', '5', '', '1'),
('501', '501 Actiuni detinute la entitatile afiliate', '5', '50', '1'),
('505', '505 Obligatiuni emise si rascumparate', '5', '50', '1'),
('506', '506 Obligatiuni', '5', '50', '1'),
('508', '508 Alte investitii pe termen scurt si creante asimilate', '5', '50', '1'),
('5081', '5081 Alte titluri de plasament', '5', '508', '1'),
('5088', '5088 Dobanzi la obligatiuni si titluri de plasament', '5', '508', '1'),
('509', '509 Varsaminte de efectuat pentru investitiile pe termen scu', '5', '50', '1'),
('5091', '5091 Varsaminte de efectuat pentru actiunile detinute la ent', '5', '509', '1'),
('5092', '5092 Varsaminte de efectuat pentru alte investitii pe termen', '5', '509', '1'),
('51', '51 CONTURI LA BANCI', '5', '', '0'),
('511', '511 Valori de incasat', '5', '51', '1'),
('5112', '5112 Cecuri de incasat', '5', '511', '0'),
('5113', '5113 Efecte de incasat', '5', '511', '0'),
('5114', '5114 Efecte remise spre scontare', '5', '511', '0'),
('512', '512 Conturi curente la banci', '5', '51', '0'),
('5121', '5121 Conturi la banci in lei', '5', '512', '0'),
('5124', '5124 Conturi la banci in valuta', '5', '512', '0'),
('5125', '5125 Sume in curs de decontare', '5', '512', '0'),
('518', '518 Dobanzi', '5', '51', '0'),
('5186', '5186 Dobanzi de platit', '5', '518', '0'),
('5187', '5187 Dobanzi de incasat', '5', '518', '0'),
('519', '519 Credite bancare pe termen scurt', '5', '51', '1'),
('5191', '5191 Credite bancare pe termen scurt', '5', '519', '0'),
('5192', '5192 Credite bancare pe termen scurt nerambursate la scadent', '5', '519', '0'),
('5193', '5193 Credite externe guvernamentale', '5', '519', '0'),
('5194', '5194 Credite externe garantate de stat', '5', '519', '0'),
('5195', '5195 Credite externe garantate de banci', '5', '519', '0'),
('5196', '5196 Credite de la trezoreria statului', '5', '519', '0'),
('5197', '5197 Credite interne garantate de stat', '5', '519', '0'),
('5198', '5198 Dobanzi aferente creditelor bancare pe termen scurt', '5', '519', '0'),
('53', '53 CASA', '5', '', '0'),
('531', '531 Casa', '5', '53', '0'),
('5311', '5311 Casa in lei', '5', '531', '0'),
('5314', '5314 Casa in valuta', '5', '531', '1'),
('532', '532 Alte valori', '5', '53', '1'),
('5321', '5321 Timbre fiscale si postale', '5', '532', '0'),
('5322', '5322 Bilete de tratament si odihna', '5', '532', '0'),
('5323', '5323 Tichete si bilete de calatorie', '5', '532', '0'),
('5328', '5328 Alte valori', '5', '532', '0'),
('54', '54 ACREDITIVE', '5', '', '0'),
('541', '541 Acreditive', '5', '54', '1'),
('5411', '5411 Acreditive in lei', '5', '541', '0'),
('5412', '5412 Acreditive in valuta', '5', '541', '0'),
('542', '542 Avansuri de trezorerie', '5', '54', '0'),
('58', '58 VIRAMENTE INTERNE', '5', '', '0'),
('581', '581 Viramente interne', '5', '58', '0'),
('59', '59 AJUSTARI PENTRU PIERDEREA DE VALOARE A CONTURILOR DE TREZ', '5', '', '1'),
('591', '591 Ajustari pentru pierderea de valoare a actiunilor detinu', '5', '59', '0'),
('595', '595 Ajustari pentru pierderea de valoare a obligatiunilor em', '5', '59', '0'),
('596', '596 Ajustari pentru pierderea de valoare a obligatiunilor', '5', '59', '1'),
('598', '598 Ajustari pentru pierderea de valoare a altor investitii ', '5', '59', '1'),
('60', '60 CHELTUIELI PRIVIND STOCURILE', '6', '', '0'),
('601', '601 Cheltuieli cu materiile prime', '6', '60', '0'),
('602', '602 Cheltuieli cu materialele consumabile', '6', '60', '0'),
('6021', '6021 Cheltuieli cu materialele auxiliare', '6', '602', '1'),
('6022', '6022 Cheltuieli privind combustibilii', '6', '602', '0'),
('6023', '6023 Cheltuieli privind materialele pentru ambalat', '6', '602', '1'),
('6024', '6024 Cheltuieli privind piesele de schimb', '6', '602', '0'),
('6025', '6025 Cheltuieli privind semintele si materialele de plantat', '6', '602', '1'),
('6026', '6026 Cheltuieli privind furajele', '6', '602', '1'),
('6028', '6028 Cheltuieli privind alte materiale consumabile', '6', '602', '1'),
('603', '603 Cheltuieli privind materialele de natura obiectelor de i', '6', '60', '0'),
('604', '604 Cheltuieli privind materialele nestocate', '6', '60', '0'),
('605', '605 Cheltuieli privind energia si apa', '6', '60', '0'),
('606', '606 Cheltuieli privind animalele si pasarile', '6', '60', '1'),
('607', '607 Cheltuieli privind marfurile', '6', '60', '0'),
('608', '608 Cheltuieli privind ambalajele', '6', '60', '1'),
('609', '609 Reduceri comerciale primite', '6', '60', '1'),
('61', '61 CHELTUIELI CU SERVICIILE EXECUTATE DE TERTI', '6', '', '0'),
('611', '611 Cheltuieli cu intretinerea si reparatiile', '6', '61', '0'),
('612', '612 Cheltuieli cu redeventele, locatiile de gestiune si chir', '6', '61', '0'),
('613', '613 Cheltuieli cu primele de asigurare', '6', '61', '0'),
('614', '614 Cheltuieli cu studiile si cercetarile', '6', '61', '1'),
('62', '62 CHELTUIELI CU ALTE SERVICII EXECUTATE DE TERTI', '6', '', '0'),
('621', '621 Cheltuieli cu colaboratorii', '6', '62', '0'),
('622', '622 Cheltuieli privind comisioanele si onorariile', '6', '62', '1'),
('623', '623 Cheltuieli de protocol, reclama si publicitate', '6', '62', '0'),
('624', '624 Cheltuieli cu transportul de bunuri si personal', '6', '62', '0'),
('625', '625 Cheltuieli cu deplasari, detasari si transferari', '6', '62', '0'),
('626', '626 Cheltuieli postale si taxe de telecomunicatii', '6', '62', '0'),
('627', '627 Cheltuieli cu serviciile bancare si asimilate', '6', '62', '0'),
('628', '628 Alte cheltuieli cu serviciile executate de terti', '6', '62', '0'),
('63', '63 CHELTUIELI CU ALTE IMPOZITE, TAXE SI VARSAMINTE ASIMILATE', '6', '', '0'),
('635', '635 Cheltuieli cu alte impozite, taxe si varsaminte asimilat', '6', '63', '0'),
('64', '64 CHELTUIELI CU PERSONALUL', '6', '', '0'),
('641', '641 Cheltuieli cu salariile personalului', '6', '64', '0'),
('642', '642 Cheltuieli cu tichetele de masa acordate salariatilor', '6', '64', '1'),
('643', '643 Cheltuieli cu primele reprezentand participarea pers. la', '6', '64', '1'),
('644', '644 Cheltuieli cu remunerarea in instrumente de capitaluri p', '6', '64', '1'),
('645', '645 Cheltuieli privind asigurarile si protectia sociala', '6', '64', '0'),
('6451', '6451 Contributia unitatii la asigurarile sociale', '6', '645', '0'),
('6452', '6452 Contributia unitatii pentru ajutorul de somaj', '6', '645', '0'),
('6453', '6453 Contributia angajatorului pentru asigurarile sociale de', '6', '645', '0'),
('6456', '6456 Contributia unitatii la schemele de pensii facultative', '6', '645', '1'),
('6457', '6457 Contributia unitatii la primele de asigurare voluntara ', '6', '645', '1'),
('6458', '6458 Alte cheltuieli privind asigurarile si protectia social', '6', '645', '0'),
('65', '65 ALTE CHELTUIELI DE EXPLOATARE', '6', '', '0'),
('652', '652 Cheltuieli cu protectia mediului inconjur.tor', '6', '65', '1'),
('654', '654 Pierderi din creante si debitori diversi', '6', '65', '1'),
('658', '658 Alte cheltuieli de exploatare', '6', '65', '0'),
('6581', '6581 Despagubiri, amenzi si penalitati', '6', '658', '0'),
('6582', '6582 Donatii acordate', '6', '658', '1'),
('6583', '6583 Cheltuieli privind activele cedate si alte operatii de ', '6', '658', '1'),
('6588', '6588 Alte cheltuieli de exploatare', '6', '658', '1'),
('66', '66 CHELTUIELI FINANCIARE', '6', '', '1'),
('663', '663 Pierderi din creante legate de participatii', '6', '66', '1'),
('664', '664 Cheltuieli privind investitiile financiare cedate', '6', '66', '1'),
('6641', '6641 Cheltuieli privind imobilizarile financiare cedate', '6', '664', '1'),
('6642', '6642 Pierderi din investitiile pe termen scurt cedate', '6', '664', '1'),
('665', '665 Cheltuieli din diferente de curs valutar', '6', '66', '0'),
('666', '666 Cheltuieli privind dobanzile', '6', '66', '0'),
('667', '667 Cheltuieli privind sconturile acordate', '6', '66', '1'),
('668', '668 Alte cheltuieli financiare', '6', '66', '1'),
('67', '67 CHELTUIELI EXTRAORDINARE', '6', '', '1'),
('671', '671 Cheltuieli privind calamitatile si alte evenimente extra', '6', '67', '1'),
('68', '68 CHELTUIELI CU AMORTIZARILE, PROVIZIOANELE SI AJUSTARILE P', '6', '', '0'),
('681', '681 Cheltuieli de exploatare privind amortizarile, provizioa', '6', '68', '1'),
('6811', '6811 Cheltuieli de exploatare privind amortizarea imobilizar', '6', '681', '0'),
('6812', '6812 Cheltuieli de exploatare privind provizioanele', '6', '681', '1'),
('6813', '6813 Cheltuieli de exploatare privind ajustarile pentru depr', '6', '681', '1'),
('6814', '6814 Cheltuieli de exploatare privind ajustarile pentru depr', '6', '681', '1'),
('686', '686 Cheltuieli financiare privind amortizarile si ajustarile', '6', '68', '1'),
('6863', '6863 Cheltuieli financiare privind ajustarile pentru pierder', '6', '686', '1'),
('6864', '6864 Cheltuieli financiare privind ajustarile pentru pierder', '6', '686', '1'),
('6868', '6868 Cheltuieli financiare privind amortizarea primelor de r', '6', '686', '1'),
('69', '69 CHELTUIELI CU IMPOZITUL PE PROFIT SI ALTE IMPOZITE', '6', '', '0'),
('691', '691 Cheltuieli cu impozitul pe profit', '6', '69', '0'),
('698', '698 Cheltuieli cu impozitul pe venit si cu alte impozite car', '6', '69', '1'),
('70', '70 CIFRA DE AFACERI NETA', '7', '', '0'),
('701', '701 Venituri din vanzarea produselor finite', '7', '70', '1'),
('702', '702 Venituri din vanzarea semifabricatelor', '7', '70', '1'),
('703', '703 Venituri din vanzarea produselor reziduale', '7', '70', '1'),
('704', '704 Venituri din servicii prestate', '7', '70', '0'),
('705', '705 Venituri din studii si cercetari', '7', '70', '1'),
('706', '706 Venituri din redevente, locatii de gestiune si chirii', '7', '70', '1'),
('707', '707 Venituri din vanzarea marfurilor', '7', '70', '0'),
('708', '708 Venituri din activitati diverse', '7', '70', '1'),
('709', '709 Reduceri comerciale acordate', '7', '70', '1'),
('71', '71 VENITURI AFERENTE COSTULUI PRODUCTIEI IN CURS DE EXECUTIE', '7', '', '1'),
('711', '711 Venituri aferente costurilor stocurilor de produse', '7', '71', '1'),
('712', '712 Venituri aferente costurilor serviciilor în curs de exe', '7', '71', '1'),
('72', '72 VENITURI DIN PRODUCTIA DE IMOBILIZARI', '7', '', '1'),
('721', '721 Venituri din productia de imobilizari necorporale', '7', '72', '1'),
('722', '722 Venituri din producaia de imobilizari corporale', '7', '72', '1'),
('74', '74 VENITURI DIN SUBVENTII DE EXPLOATARE', '7', '', '1'),
('741', '741 Venituri din subventii de exploatare', '7', '74', '1'),
('7411', '7411 Venituri din subventii de exploatare aferente cifrei de', '7', '741', '1'),
('7412', '7412 Venituri din subventii de exploatare pentru materii pri', '7', '741', '1'),
('7413', '7413 Venituri din subventii de exploatare pentru alte cheltu', '7', '741', '1'),
('7414', '7414 Venituri din subventii de exploatare pentru plata perso', '7', '741', '1'),
('7415', '7415 Venituri din subventii de exploatare pentru asigurari s', '7', '741', '1'),
('7416', '7416 Venituri din subventii de exploatare pentru alte cheltu', '7', '741', '1'),
('7417', '7417 Venituri din subventii de exploatare aferente altor ven', '7', '741', '1'),
('7418', '7418 Venituri din subventii de exploatare pentru dobanda dat', '7', '741', '1'),
('75', '75 ALTE VENITURI DIN EXPLOATARE', '7', '', '1'),
('754', '754 Venituri din creante reactivate si debitori diversi', '7', '75', '1'),
('758', '758 Alte venituri din exploatare', '7', '75', '1'),
('7581', '7581 Venituri din despagubiri, amenzi si penalitati', '7', '758', '1'),
('7582', '7582 Venituri din donatii primite', '7', '758', '1'),
('7583', '7583 Venituri din vanzarea activelor si alte operatii de cap', '7', '758', '1'),
('7584', '7584 Venituri din subventii pentru investitii', '7', '758', '1'),
('7588', '7588 Alte venituri din exploatare', '7', '758', '0'),
('76', '76 VENITURI FINANCIARE', '7', '', '1'),
('761', '761 Venituri din imobilizari financiare', '7', '76', '1'),
('7611', '7611 Venituri din actiuni detinute la entitatile afiliate', '7', '761', '1'),
('7613', '7613 Venituri din interese de participare', '7', '761', '1'),
('762', '762 Venituri din investitii financiare pe termen scurt', '7', '76', '1'),
('763', '763 Venituri din creante imobilizate', '7', '76', '1'),
('764', '764 Venituri din investitii financiare cedate', '7', '76', '1'),
('7641', '7641 Venituri din imobilizari financiare cedate', '7', '764', '1'),
('7642', '7642 Castiguri din investitii pe termen scurt cedate', '7', '764', '1'),
('765', '765 Venituri din diferen.e de curs valutar', '7', '76', '0'),
('766', '766 Venituri din dobanzi', '7', '76', '0'),
('767', '767 Venituri din sconturi obtinute', '7', '76', '1'),
('768', '768 Alte venituri financiare', '7', '76', '1'),
('77', '77 VENITURI EXTRAORDINARE', '7', '', '1'),
('771', '771 Venituri din subventii pentru evenimente extraordinare s', '7', '77', '1'),
('78', '78 VENITURI DIN PROVIZIOANE SI AJUSTARI PENTRU DEPRECIERE SA', '7', '', '1'),
('781', '781 Venituri din provizioane si ajustari pentru depreciere p', '7', '78', '1'),
('7812', '7812 Venituri din provizioane', '7', '781', '1'),
('7813', '7813 Venituri din ajustari pentru deprecierea imobilizarilor', '7', '781', '1'),
('7814', '7814 Venituri din ajustari pentru deprecierea activelor circ', '7', '781', '1'),
('7815', '7815 Venituri din fondul comercial negativ', '7', '781', '1'),
('786', '786 Venituri financiare din ajustari pentru pierdere de valo', '7', '78', '1'),
('7863', '7863 Venituri financiare din ajustari pentru pierderea de va', '7', '786', '1'),
('7864', '7864 Venituri financiare din ajustari pentru pierderea de va', '7', '786', '1'),
('80', '80 CONTURI IN AFARA BILANTULUI', '8', '', '1'),
('801', '801 Angajamente acordate', '8', '80', '1'),
('8011', '8011 Giruri si garantii acordate', '8', '801', '1'),
('8018', '8018 Alte angajamente acordate', '8', '801', '1'),
('802', '802 Angajamente primite', '8', '80', '1'),
('8021', '8021 Giruri si garantii primite', '8', '802', '1'),
('8028', '8028 Alte angajamente primite', '8', '802', '1'),
('803', '803 Alte conturi in afara bilantului', '8', '80', '1'),
('8031', '8031 Imobilizari corporale luate cu chirie', '8', '803', '1'),
('8032', '8032 Valori materiale primite spre prelucrare sau reparare', '8', '803', '1'),
('8033', '8033 Valori materiale primite in pastrare sau custodie', '8', '803', '1'),
('8034', '8034 Debitori scosi din activ, urmariti in continuare', '8', '803', '1'),
('8035', '8035 Stocuri de natura obiectelor de inventar date in folosi', '8', '803', '1'),
('8036', '8036 Redevente, locatii de gestiune, chirii si alte datorii ', '8', '803', '1'),
('8037', '8037 Efecte scontate neajunse la scadenta', '8', '803', '1'),
('8038', '8038 Bunuri publice primite in administrare, concesiune si c', '8', '803', '1'),
('8039', '8039 Alte valori in afara bilantului', '8', '803', '1'),
('804', '804 Amortizarea aferenta gradului de neutilizare a mijloacel', '8', '80', '1'),
('8045', '8045 Amortizarea aferenta gradului de neutilizare a mijloace', '8', '804', '1'),
('805', '805 Dobanzi aferente contractelor de leasing si altor contra', '8', '80', '1'),
('8051', '8051 Dobanzi de platit', '8', '805', '1'),
('8052', '8052 Dobanzi de incasat', '8', '805', '1'),
('806', '806 Certificate de emisii de gaze cu efect de sera', '8', '80', '1'),
('807', '807 Active contingente', '8', '80', '1'),
('808', '808 Datorii contingente', '8', '80', '1'),
('89', '89 BILANT', '8', '', '1'),
('891', '891 Bilant de deschidere', '8', '89', '1'),
('892', '892 Bilant de inchidere', '8', '89', '1'),
('90', '90 DECONTARI INTERNE', '9', '', '1'),
('901', '901 Decontari interne privind cheltuielile', '9', '90', '1'),
('902', '902 Decontari interne privind productia obtinuta', '9', '90', '1'),
('903', '903 Decontari interne privind diferentele de pret', '9', '90', '1'),
('92', '92 CONTURI DE CALCULATIE', '9', '', '1'),
('921', '921 Cheltuielile activitatii de baza', '9', '92', '1'),
('922', '922 Cheltuielile activitatilor auxiliare', '9', '92', '1'),
('923', '923 Cheltuieli indirecte de productie', '9', '92', '1'),
('924', '924 Cheltuieli generale de administratie', '9', '92', '1'),
('925', '925 Cheltuieli de desfacere', '9', '92', '1'),
('93', '93 COSTUL PRODUCTIEI', '9', '', '1'),
('931', '931 Costul productiei obtinute', '9', '93', '1'),
('933', '933 Costul productiei in curs de executie', '9', '93', '1');

### Structure of table `0_comments` ###

DROP TABLE IF EXISTS `0_comments`;

CREATE TABLE `0_comments` (
  `type` int(11) NOT NULL DEFAULT '0',
  `id` int(11) NOT NULL DEFAULT '0',
  `date_` date DEFAULT '0000-00-00',
  `memo_` tinytext,
  KEY `type_and_id` (`type`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_comments` ###


### Structure of table `0_credit_status` ###

DROP TABLE IF EXISTS `0_credit_status`;

CREATE TABLE `0_credit_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reason_description` char(100) NOT NULL DEFAULT '',
  `dissallow_invoices` tinyint(1) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `reason_description` (`reason_description`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 ;

### Data of table `0_credit_status` ###

INSERT INTO `0_credit_status` VALUES
('1', 'Good', '0', '0'),
('2', 'Wait payment', '1', '0');

### Structure of table `0_crm_categories` ###

DROP TABLE IF EXISTS `0_crm_categories`;

CREATE TABLE `0_crm_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'pure technical key',
  `type` varchar(20) NOT NULL COMMENT 'contact type e.g. customer',
  `action` varchar(20) NOT NULL COMMENT 'detailed usage e.g. department',
  `name` varchar(30) NOT NULL COMMENT 'for category selector',
  `description` tinytext NOT NULL COMMENT 'usage description',
  `system` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'nonzero for core system usage',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `type` (`type`,`action`),
  UNIQUE KEY `type_2` (`type`,`name`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1 ;

### Data of table `0_crm_categories` ###

INSERT INTO `0_crm_categories` VALUES
('1', 'cust_branch', 'general', 'General', 'General contact data for customer branch (overrides company setting)', '1', '0'),
('2', 'cust_branch', 'invoice', 'Invoices', 'Invoice posting (overrides company setting)', '1', '0'),
('3', 'cust_branch', 'order', 'Orders', 'Order confirmation (overrides company setting)', '1', '0'),
('4', 'cust_branch', 'delivery', 'Deliveries', 'Delivery coordination (overrides company setting)', '1', '0'),
('5', 'customer', 'general', 'General', 'General contact data for customer', '1', '0'),
('6', 'customer', 'order', 'Orders', 'Order confirmation', '1', '0'),
('7', 'customer', 'delivery', 'Deliveries', 'Delivery coordination', '1', '0'),
('8', 'customer', 'invoice', 'Invoices', 'Invoice posting', '1', '0'),
('9', 'supplier', 'general', 'General', 'General contact data for supplier', '1', '0'),
('10', 'supplier', 'order', 'Orders', 'Order confirmation', '1', '0'),
('11', 'supplier', 'delivery', 'Deliveries', 'Delivery coordination', '1', '0'),
('12', 'supplier', 'invoice', 'Invoices', 'Invoice posting', '1', '0');

### Structure of table `0_crm_contacts` ###

DROP TABLE IF EXISTS `0_crm_contacts`;

CREATE TABLE `0_crm_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) NOT NULL DEFAULT '0' COMMENT 'foreign key to crm_contacts',
  `type` varchar(20) NOT NULL COMMENT 'foreign key to crm_categories',
  `action` varchar(20) NOT NULL COMMENT 'foreign key to crm_categories',
  `entity_id` varchar(11) DEFAULT NULL COMMENT 'entity id in related class table',
  PRIMARY KEY (`id`),
  KEY `type` (`type`,`action`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1 ;

### Data of table `0_crm_contacts` ###

INSERT INTO `0_crm_contacts` VALUES
('1', '1', 'customer', 'general', '1'),
('2', '2', 'customer', 'general', '2'),
('3', '3', 'customer', 'general', '3'),
('4', '4', 'cust_branch', 'general', '1'),
('5', '5', 'cust_branch', 'general', '2'),
('6', '6', 'cust_branch', 'general', '3'),
('7', '7', 'supplier', 'general', '1'),
('8', '8', 'supplier', 'general', '2'),
('9', '9', 'supplier', 'general', '3'),
('10', '10', 'cust_branch', 'general', '4');

### Structure of table `0_crm_persons` ###

DROP TABLE IF EXISTS `0_crm_persons`;

CREATE TABLE `0_crm_persons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ref` varchar(30) NOT NULL,
  `name` varchar(60) NOT NULL,
  `name2` varchar(60) DEFAULT NULL,
  `address` tinytext,
  `phone` varchar(30) DEFAULT NULL,
  `phone2` varchar(30) DEFAULT NULL,
  `fax` varchar(30) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `lang` char(5) DEFAULT NULL,
  `notes` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `ref` (`ref`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1 ;

### Data of table `0_crm_persons` ###


### Structure of table `0_currencies` ###

DROP TABLE IF EXISTS `0_currencies`;

CREATE TABLE `0_currencies` (
  `currency` varchar(60) NOT NULL DEFAULT '',
  `curr_abrev` char(3) NOT NULL DEFAULT '',
  `curr_symbol` varchar(10) NOT NULL DEFAULT '',
  `country` varchar(100) NOT NULL DEFAULT '',
  `hundreds_name` varchar(15) NOT NULL DEFAULT '',
  `auto_update` tinyint(1) NOT NULL DEFAULT '1',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`curr_abrev`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

### Data of table `0_currencies` ###

INSERT INTO `0_currencies` VALUES
('US Dollars', 'USD', '$', 'United States', 'Cents', '1', '0'),
('Leu', 'RON', 'LEI', 'Romania', 'bani', '1', '0'),
('Euro', 'EUR', '?', 'Europe', 'Cents', '1', '0'),
('Pounds', 'GBP', '?', 'England', 'Pence', '1', '0');

### Structure of table `0_cust_allocations` ###

DROP TABLE IF EXISTS `0_cust_allocations`;

CREATE TABLE `0_cust_allocations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `amt` double unsigned DEFAULT NULL,
  `date_alloc` date NOT NULL DEFAULT '0000-00-00',
  `trans_no_from` int(11) DEFAULT NULL,
  `trans_type_from` int(11) DEFAULT NULL,
  `trans_no_to` int(11) DEFAULT NULL,
  `trans_type_to` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `From` (`trans_type_from`,`trans_no_from`),
  KEY `To` (`trans_type_to`,`trans_no_to`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 ;

### Data of table `0_cust_allocations` ###


### Structure of table `0_cust_branch` ###

DROP TABLE IF EXISTS `0_cust_branch`;

CREATE TABLE `0_cust_branch` (
  `branch_code` int(11) NOT NULL AUTO_INCREMENT,
  `debtor_no` int(11) NOT NULL DEFAULT '0',
  `br_name` varchar(60) NOT NULL DEFAULT '',
  `branch_ref` varchar(30) NOT NULL DEFAULT '',
  `br_address` tinytext NOT NULL,
  `area` int(11) DEFAULT NULL,
  `salesman` int(11) NOT NULL DEFAULT '0',
  `contact_name` varchar(60) NOT NULL DEFAULT '',
  `default_location` varchar(5) NOT NULL DEFAULT '',
  `tax_group_id` int(11) DEFAULT NULL,
  `sales_account` varchar(15) NOT NULL DEFAULT '',
  `sales_discount_account` varchar(15) NOT NULL DEFAULT '',
  `receivables_account` varchar(15) NOT NULL DEFAULT '',
  `payment_discount_account` varchar(15) NOT NULL DEFAULT '',
  `default_ship_via` int(11) NOT NULL DEFAULT '1',
  `disable_trans` tinyint(4) NOT NULL DEFAULT '0',
  `br_post_address` tinytext NOT NULL,
  `group_no` int(11) NOT NULL DEFAULT '0',
  `notes` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`branch_code`,`debtor_no`),
  KEY `branch_code` (`branch_code`),
  KEY `branch_ref` (`branch_ref`),
  KEY `group_no` (`group_no`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 ;

### Data of table `0_cust_branch` ###


### Structure of table `0_debtor_trans` ###

DROP TABLE IF EXISTS `0_debtor_trans`;

CREATE TABLE `0_debtor_trans` (
  `trans_no` int(11) unsigned NOT NULL DEFAULT '0',
  `type` smallint(6) unsigned NOT NULL DEFAULT '0',
  `version` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `debtor_no` int(11) unsigned DEFAULT NULL,
  `branch_code` int(11) NOT NULL DEFAULT '-1',
  `tran_date` date NOT NULL DEFAULT '0000-00-00',
  `due_date` date NOT NULL DEFAULT '0000-00-00',
  `reference` varchar(60) NOT NULL DEFAULT '',
  `tpe` int(11) NOT NULL DEFAULT '0',
  `order_` int(11) NOT NULL DEFAULT '0',
  `ov_amount` double NOT NULL DEFAULT '0',
  `ov_gst` double NOT NULL DEFAULT '0',
  `ov_freight` double NOT NULL DEFAULT '0',
  `ov_freight_tax` double NOT NULL DEFAULT '0',
  `ov_discount` double NOT NULL DEFAULT '0',
  `alloc` double NOT NULL DEFAULT '0',
  `rate` double NOT NULL DEFAULT '1',
  `ship_via` int(11) DEFAULT NULL,
  `dimension_id` int(11) NOT NULL DEFAULT '0',
  `dimension2_id` int(11) NOT NULL DEFAULT '0',
  `payment_terms` int(11) DEFAULT NULL,
  PRIMARY KEY (`type`,`trans_no`),
  KEY `debtor_no` (`debtor_no`,`branch_code`),
  KEY `tran_date` (`tran_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_debtor_trans` ###


### Structure of table `0_debtor_trans_details` ###

DROP TABLE IF EXISTS `0_debtor_trans_details`;

CREATE TABLE `0_debtor_trans_details` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `debtor_trans_no` int(11) DEFAULT NULL,
  `debtor_trans_type` int(11) DEFAULT NULL,
  `stock_id` varchar(20) NOT NULL DEFAULT '',
  `description` tinytext,
  `unit_price` double NOT NULL DEFAULT '0',
  `unit_tax` double NOT NULL DEFAULT '0',
  `quantity` double NOT NULL DEFAULT '0',
  `discount_percent` double NOT NULL DEFAULT '0',
  `standard_cost` double NOT NULL DEFAULT '0',
  `qty_done` double NOT NULL DEFAULT '0',
  `src_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Transaction` (`debtor_trans_type`,`debtor_trans_no`),
  KEY `src_id` (`src_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 ;

### Data of table `0_debtor_trans_details` ###

### Structure of table `0_debtors_master` ###

DROP TABLE IF EXISTS `0_debtors_master`;

CREATE TABLE `0_debtors_master` (
  `debtor_no` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  `debtor_ref` varchar(30) NOT NULL,
  `address` tinytext,
  `tax_id` varchar(55) NOT NULL DEFAULT '',
  `curr_code` char(3) NOT NULL DEFAULT '',
  `sales_type` int(11) NOT NULL DEFAULT '1',
  `dimension_id` int(11) NOT NULL DEFAULT '0',
  `dimension2_id` int(11) NOT NULL DEFAULT '0',
  `credit_status` int(11) NOT NULL DEFAULT '0',
  `payment_terms` int(11) DEFAULT NULL,
  `discount` double NOT NULL DEFAULT '0',
  `pymt_discount` double NOT NULL DEFAULT '0',
  `credit_limit` float NOT NULL DEFAULT '1000',
  `notes` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`debtor_no`),
  UNIQUE KEY `debtor_ref` (`debtor_ref`),
  KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 ;

### Data of table `0_debtors_master` ###


### Structure of table `0_dimensions` ###

DROP TABLE IF EXISTS `0_dimensions`;

CREATE TABLE `0_dimensions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reference` varchar(60) NOT NULL DEFAULT '',
  `name` varchar(60) NOT NULL DEFAULT '',
  `type_` tinyint(1) NOT NULL DEFAULT '1',
  `closed` tinyint(1) NOT NULL DEFAULT '0',
  `date_` date NOT NULL DEFAULT '0000-00-00',
  `due_date` date NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `reference` (`reference`),
  KEY `date_` (`date_`),
  KEY `due_date` (`due_date`),
  KEY `type_` (`type_`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 ;

### Data of table `0_dimensions` ###

### Structure of table `0_exchange_rates` ###

DROP TABLE IF EXISTS `0_exchange_rates`;

CREATE TABLE `0_exchange_rates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `curr_code` char(3) NOT NULL DEFAULT '',
  `rate_buy` double NOT NULL DEFAULT '0',
  `rate_sell` double NOT NULL DEFAULT '0',
  `date_` date NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `curr_code` (`curr_code`,`date_`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 ;

### Data of table `0_exchange_rates` ###

### Structure of table `0_fiscal_year` ###

DROP TABLE IF EXISTS `0_fiscal_year`;

CREATE TABLE `0_fiscal_year` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `begin` date DEFAULT '0000-00-00',
  `end` date DEFAULT '0000-00-00',
  `closed` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `begin` (`begin`),
  UNIQUE KEY `end` (`end`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ;

### Data of table `0_fiscal_year` ###

INSERT INTO `0_fiscal_year` VALUES
('1', '2012-01-01', '2012-12-31', '0');

### Structure of table `0_gl_trans` ###

DROP TABLE IF EXISTS `0_gl_trans`;

CREATE TABLE `0_gl_trans` (
  `counter` int(11) NOT NULL AUTO_INCREMENT,
  `type` smallint(6) NOT NULL DEFAULT '0',
  `type_no` bigint(16) NOT NULL DEFAULT '1',
  `tran_date` date NOT NULL DEFAULT '0000-00-00',
  `account` varchar(15) NOT NULL DEFAULT '',
  `memo_` tinytext NOT NULL,
  `amount` double NOT NULL DEFAULT '0',
  `dimension_id` int(11) NOT NULL DEFAULT '0',
  `dimension2_id` int(11) NOT NULL DEFAULT '0',
  `person_type_id` int(11) DEFAULT NULL,
  `person_id` tinyblob,
  PRIMARY KEY (`counter`),
  KEY `Type_and_Number` (`type`,`type_no`),
  KEY `dimension_id` (`dimension_id`),
  KEY `dimension2_id` (`dimension2_id`),
  KEY `tran_date` (`tran_date`),
  KEY `account_and_tran_date` (`account`,`tran_date`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 ;

### Data of table `0_gl_trans` ###

### Structure of table `0_grn_batch` ###

DROP TABLE IF EXISTS `0_grn_batch`;

CREATE TABLE `0_grn_batch` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `supplier_id` int(11) NOT NULL DEFAULT '0',
  `purch_order_no` int(11) DEFAULT NULL,
  `reference` varchar(60) NOT NULL DEFAULT '',
  `delivery_date` date NOT NULL DEFAULT '0000-00-00',
  `loc_code` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `delivery_date` (`delivery_date`),
  KEY `purch_order_no` (`purch_order_no`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 ;

### Data of table `0_grn_batch` ###


### Structure of table `0_grn_items` ###

DROP TABLE IF EXISTS `0_grn_items`;

CREATE TABLE `0_grn_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `grn_batch_id` int(11) DEFAULT NULL,
  `po_detail_item` int(11) NOT NULL DEFAULT '0',
  `item_code` varchar(20) NOT NULL DEFAULT '',
  `description` tinytext,
  `qty_recd` double NOT NULL DEFAULT '0',
  `quantity_inv` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `grn_batch_id` (`grn_batch_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 ;

### Data of table `0_grn_items` ###

### Structure of table `0_groups` ###

DROP TABLE IF EXISTS `0_groups`;

CREATE TABLE `0_groups` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `description` (`description`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 ;

### Data of table `0_groups` ###

INSERT INTO `0_groups` VALUES
('1', 'Small', '0'),
('2', 'Medium', '0'),
('3', 'Large', '0');

### Structure of table `0_item_codes` ###

DROP TABLE IF EXISTS `0_item_codes`;

CREATE TABLE `0_item_codes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `item_code` varchar(20) NOT NULL,
  `stock_id` varchar(20) NOT NULL,
  `description` varchar(200) NOT NULL DEFAULT '',
  `category_id` smallint(6) unsigned NOT NULL,
  `quantity` double NOT NULL DEFAULT '1',
  `is_foreign` tinyint(1) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `stock_id` (`stock_id`,`item_code`),
  KEY `item_code` (`item_code`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 ;

### Data of table `0_item_codes` ###

### Structure of table `0_item_tax_type_exemptions` ###

DROP TABLE IF EXISTS `0_item_tax_type_exemptions`;

CREATE TABLE `0_item_tax_type_exemptions` (
  `item_tax_type_id` int(11) NOT NULL DEFAULT '0',
  `tax_type_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`item_tax_type_id`,`tax_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_item_tax_type_exemptions` ###


### Structure of table `0_item_tax_types` ###

DROP TABLE IF EXISTS `0_item_tax_types`;

CREATE TABLE `0_item_tax_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL DEFAULT '',
  `exempt` tinyint(1) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ;

### Data of table `0_item_tax_types` ###

INSERT INTO `0_item_tax_types` VALUES
('1', 'Regular', '0', '0');

### Structure of table `0_item_units` ###

DROP TABLE IF EXISTS `0_item_units`;

CREATE TABLE `0_item_units` (
  `abbr` varchar(20) NOT NULL,
  `name` varchar(40) NOT NULL,
  `decimals` tinyint(2) NOT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`abbr`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

### Data of table `0_item_units` ###

INSERT INTO `0_item_units` VALUES
('buc', 'Bucati', '0', '0'),
('ore', 'Ore', '0', '0');

### Structure of table `0_loc_stock` ###

DROP TABLE IF EXISTS `0_loc_stock`;

CREATE TABLE `0_loc_stock` (
  `loc_code` char(5) NOT NULL DEFAULT '',
  `stock_id` char(20) NOT NULL DEFAULT '',
  `reorder_level` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`loc_code`,`stock_id`),
  KEY `stock_id` (`stock_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_loc_stock` ###

### Structure of table `0_locations` ###

DROP TABLE IF EXISTS `0_locations`;

CREATE TABLE `0_locations` (
  `loc_code` varchar(5) NOT NULL DEFAULT '',
  `location_name` varchar(60) NOT NULL DEFAULT '',
  `delivery_address` tinytext NOT NULL,
  `phone` varchar(30) NOT NULL DEFAULT '',
  `phone2` varchar(30) NOT NULL DEFAULT '',
  `fax` varchar(30) NOT NULL DEFAULT '',
  `email` varchar(100) NOT NULL DEFAULT '',
  `contact` varchar(30) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`loc_code`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

### Data of table `0_locations` ###

INSERT INTO `0_locations` VALUES
('DEF', 'Default', 'Delivery 1\nDelivery 2\nDelivery 3', '', '', '', '', '', '0');

### Structure of table `0_movement_types` ###

DROP TABLE IF EXISTS `0_movement_types`;

CREATE TABLE `0_movement_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ;

### Data of table `0_movement_types` ###

INSERT INTO `0_movement_types` VALUES
('1', 'Adjustment', '0');

### Structure of table `0_payment_terms` ###

DROP TABLE IF EXISTS `0_payment_terms`;

CREATE TABLE `0_payment_terms` (
  `terms_indicator` int(11) NOT NULL AUTO_INCREMENT,
  `terms` char(80) NOT NULL DEFAULT '',
  `days_before_due` smallint(6) NOT NULL DEFAULT '0',
  `day_in_following_month` smallint(6) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`terms_indicator`),
  UNIQUE KEY `terms` (`terms`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 ;

### Data of table `0_payment_terms` ###

INSERT INTO `0_payment_terms` VALUES
('1', 'Plata in avans', '0', '0', '0'),
('2', 'Plata cash', '0', '0', '0');

### Structure of table `0_prices` ###

DROP TABLE IF EXISTS `0_prices`;

CREATE TABLE `0_prices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stock_id` varchar(20) NOT NULL DEFAULT '',
  `sales_type_id` int(11) NOT NULL DEFAULT '0',
  `curr_abrev` char(3) NOT NULL DEFAULT '',
  `price` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `price` (`stock_id`,`sales_type_id`,`curr_abrev`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 ;

### Data of table `0_prices` ###


### Structure of table `0_print_profiles` ###

DROP TABLE IF EXISTS `0_print_profiles`;

CREATE TABLE `0_print_profiles` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `profile` varchar(30) NOT NULL,
  `report` varchar(5) DEFAULT NULL,
  `printer` tinyint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `profile` (`profile`,`report`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=latin1 ;

### Data of table `0_print_profiles` ###

INSERT INTO `0_print_profiles` VALUES
('1', 'Out of office', NULL, '0'),
('2', 'Sales Department', NULL, '0'),
('3', 'Central', NULL, '2'),
('4', 'Sales Department', '104', '2'),
('5', 'Sales Department', '105', '2'),
('6', 'Sales Department', '107', '2'),
('7', 'Sales Department', '109', '2'),
('8', 'Sales Department', '110', '2'),
('9', 'Sales Department', '201', '2');

### Structure of table `0_printers` ###

DROP TABLE IF EXISTS `0_printers`;

CREATE TABLE `0_printers` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `description` varchar(60) NOT NULL,
  `queue` varchar(20) NOT NULL,
  `host` varchar(40) NOT NULL,
  `port` smallint(11) unsigned NOT NULL,
  `timeout` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 ;

### Data of table `0_printers` ###

INSERT INTO `0_printers` VALUES
('1', 'QL500', 'Label printer', 'QL500', 'server', '127', '20'),
('2', 'Samsung', 'Main network printer', 'scx4521F', 'server', '515', '5'),
('3', 'Local', 'Local print server at user IP', 'lp', '', '515', '10');

### Structure of table `0_purch_data` ###

DROP TABLE IF EXISTS `0_purch_data`;

CREATE TABLE `0_purch_data` (
  `supplier_id` int(11) NOT NULL DEFAULT '0',
  `stock_id` char(20) NOT NULL DEFAULT '',
  `price` double NOT NULL DEFAULT '0',
  `suppliers_uom` char(50) NOT NULL DEFAULT '',
  `conversion_factor` double NOT NULL DEFAULT '1',
  `supplier_description` char(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`supplier_id`,`stock_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

### Data of table `0_purch_data` ###


### Structure of table `0_purch_order_details` ###

DROP TABLE IF EXISTS `0_purch_order_details`;

CREATE TABLE `0_purch_order_details` (
  `po_detail_item` int(11) NOT NULL AUTO_INCREMENT,
  `order_no` int(11) NOT NULL DEFAULT '0',
  `item_code` varchar(20) NOT NULL DEFAULT '',
  `description` tinytext,
  `delivery_date` date NOT NULL DEFAULT '0000-00-00',
  `qty_invoiced` double NOT NULL DEFAULT '0',
  `unit_price` double NOT NULL DEFAULT '0',
  `act_price` double NOT NULL DEFAULT '0',
  `std_cost_unit` double NOT NULL DEFAULT '0',
  `quantity_ordered` double NOT NULL DEFAULT '0',
  `quantity_received` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`po_detail_item`),
  KEY `order` (`order_no`,`po_detail_item`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 ;

### Data of table `0_purch_order_details` ###

### Structure of table `0_purch_orders` ###

DROP TABLE IF EXISTS `0_purch_orders`;

CREATE TABLE `0_purch_orders` (
  `order_no` int(11) NOT NULL AUTO_INCREMENT,
  `supplier_id` int(11) NOT NULL DEFAULT '0',
  `comments` tinytext,
  `ord_date` date NOT NULL DEFAULT '0000-00-00',
  `reference` tinytext NOT NULL,
  `requisition_no` tinytext,
  `into_stock_location` varchar(5) NOT NULL DEFAULT '',
  `delivery_address` tinytext NOT NULL,
  `total` double NOT NULL DEFAULT '0',
  `tax_included` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`order_no`),
  KEY `ord_date` (`ord_date`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 ;

### Data of table `0_purch_orders` ###


### Structure of table `0_quick_entries` ###

DROP TABLE IF EXISTS `0_quick_entries`;

CREATE TABLE `0_quick_entries` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `type` tinyint(1) NOT NULL DEFAULT '0',
  `description` varchar(60) NOT NULL,
  `base_amount` double NOT NULL DEFAULT '0',
  `base_desc` varchar(60) DEFAULT NULL,
  `bal_type` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `description` (`description`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 ;

### Data of table `0_quick_entries` ###

### Structure of table `0_quick_entry_lines` ###

DROP TABLE IF EXISTS `0_quick_entry_lines`;

CREATE TABLE `0_quick_entry_lines` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `qid` smallint(6) unsigned NOT NULL,
  `amount` double DEFAULT '0',
  `action` varchar(2) NOT NULL,
  `dest_id` varchar(15) NOT NULL DEFAULT '',
  `dimension_id` smallint(6) unsigned DEFAULT NULL,
  `dimension2_id` smallint(6) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `qid` (`qid`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 ;

### Data of table `0_quick_entry_lines` ###

### Structure of table `0_recurrent_invoices` ###

DROP TABLE IF EXISTS `0_recurrent_invoices`;

CREATE TABLE `0_recurrent_invoices` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(60) NOT NULL DEFAULT '',
  `order_no` int(11) unsigned NOT NULL,
  `debtor_no` int(11) unsigned DEFAULT NULL,
  `group_no` smallint(6) unsigned DEFAULT NULL,
  `days` int(11) NOT NULL DEFAULT '0',
  `monthly` int(11) NOT NULL DEFAULT '0',
  `begin` date NOT NULL DEFAULT '0000-00-00',
  `end` date NOT NULL DEFAULT '0000-00-00',
  `last_sent` date NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `description` (`description`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_recurrent_invoices` ###


### Structure of table `0_refs` ###

DROP TABLE IF EXISTS `0_refs`;

CREATE TABLE `0_refs` (
  `id` int(11) NOT NULL DEFAULT '0',
  `type` int(11) NOT NULL DEFAULT '0',
  `reference` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`,`type`),
  KEY `Type_and_Reference` (`type`,`reference`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_refs` ###

INSERT INTO `0_refs` VALUES
('18', '0', '1'),
('19', '0', '2');

### Structure of table `0_sales_order_details` ###

DROP TABLE IF EXISTS `0_sales_order_details`;

CREATE TABLE `0_sales_order_details` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_no` int(11) NOT NULL DEFAULT '0',
  `trans_type` smallint(6) NOT NULL DEFAULT '30',
  `stk_code` varchar(20) NOT NULL DEFAULT '',
  `description` tinytext,
  `qty_sent` double NOT NULL DEFAULT '0',
  `unit_price` double NOT NULL DEFAULT '0',
  `quantity` double NOT NULL DEFAULT '0',
  `discount_percent` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `sorder` (`trans_type`,`order_no`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 ;

### Data of table `0_sales_order_details` ###

### Structure of table `0_sales_orders` ###

DROP TABLE IF EXISTS `0_sales_orders`;

CREATE TABLE `0_sales_orders` (
  `order_no` int(11) NOT NULL,
  `trans_type` smallint(6) NOT NULL DEFAULT '30',
  `version` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `type` tinyint(1) NOT NULL DEFAULT '0',
  `debtor_no` int(11) NOT NULL DEFAULT '0',
  `branch_code` int(11) NOT NULL DEFAULT '0',
  `reference` varchar(100) NOT NULL DEFAULT '',
  `customer_ref` tinytext NOT NULL,
  `comments` tinytext,
  `ord_date` date NOT NULL DEFAULT '0000-00-00',
  `order_type` int(11) NOT NULL DEFAULT '0',
  `ship_via` int(11) NOT NULL DEFAULT '0',
  `delivery_address` tinytext NOT NULL,
  `contact_phone` varchar(30) DEFAULT NULL,
  `contact_email` varchar(100) DEFAULT NULL,
  `deliver_to` tinytext NOT NULL,
  `freight_cost` double NOT NULL DEFAULT '0',
  `from_stk_loc` varchar(5) NOT NULL DEFAULT '',
  `delivery_date` date NOT NULL DEFAULT '0000-00-00',
  `payment_terms` int(11) DEFAULT NULL,
  `total` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`trans_type`,`order_no`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_sales_orders` ###

### Structure of table `0_sales_pos` ###

DROP TABLE IF EXISTS `0_sales_pos`;

CREATE TABLE `0_sales_pos` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `pos_name` varchar(30) NOT NULL,
  `cash_sale` tinyint(1) NOT NULL,
  `credit_sale` tinyint(1) NOT NULL,
  `pos_location` varchar(5) NOT NULL,
  `pos_account` smallint(6) unsigned NOT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `pos_name` (`pos_name`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ;

### Data of table `0_sales_pos` ###

INSERT INTO `0_sales_pos` VALUES
('1', 'Default', '1', '1', 'DEF', '2', '0');

### Structure of table `0_sales_types` ###

DROP TABLE IF EXISTS `0_sales_types`;

CREATE TABLE `0_sales_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sales_type` char(50) NOT NULL DEFAULT '',
  `tax_included` int(1) NOT NULL DEFAULT '0',
  `factor` double NOT NULL DEFAULT '1',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `sales_type` (`sales_type`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 ;

### Data of table `0_sales_types` ###

INSERT INTO `0_sales_types` VALUES
('1', 'Regular', '1', '1', '0');

### Structure of table `0_salesman` ###

DROP TABLE IF EXISTS `0_salesman`;

CREATE TABLE `0_salesman` (
  `salesman_code` int(11) NOT NULL AUTO_INCREMENT,
  `salesman_name` char(60) NOT NULL DEFAULT '',
  `salesman_phone` char(30) NOT NULL DEFAULT '',
  `salesman_fax` char(30) NOT NULL DEFAULT '',
  `salesman_email` varchar(100) NOT NULL DEFAULT '',
  `provision` double NOT NULL DEFAULT '0',
  `break_pt` double NOT NULL DEFAULT '0',
  `provision2` double NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`salesman_code`),
  UNIQUE KEY `salesman_name` (`salesman_name`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ;

### Data of table `0_salesman` ###

INSERT INTO `0_salesman` VALUES
('1', 'Office', '', '', '', '5', '1000', '4', '0');

### Structure of table `0_security_roles` ###

DROP TABLE IF EXISTS `0_security_roles`;

CREATE TABLE `0_security_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role` varchar(30) NOT NULL,
  `description` varchar(50) DEFAULT NULL,
  `sections` text,
  `areas` text,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `role` (`role`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=latin1 ;

### Data of table `0_security_roles` ###

INSERT INTO `0_security_roles` VALUES
('1', 'Inquiries', 'Inquiries', '768;2816;3072;3328;5632;5888;8192;8448;10752;11008;13312;15872;16128', '257;258;259;260;513;514;515;516;517;518;519;520;521;522;523;524;525;773;774;2822;3073;3075;3076;3077;3329;3330;3331;3332;3333;3334;3335;5377;5633;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8450;8451;10497;10753;11009;11010;11012;13313;13315;15617;15618;15619;15620;15621;15622;15623;15624;15625;15626;15873;15882;16129;16130;16131;16132', '0'),
('2', 'System Administrator', 'System Administrator', '256;512;768;2816;3072;3328;5376;5632;5888;7936;8192;8448;10496;10752;11008;13056;13312;15616;15872;16128', '257;258;259;260;513;514;515;516;517;518;519;520;521;522;523;524;525;526;769;770;771;772;773;774;2817;2818;2819;2820;2821;2822;2823;3073;3074;3082;3075;3076;3077;3078;3079;3080;3081;3329;3330;3331;3332;3333;3334;3335;5377;5633;5634;5635;5636;5637;5641;5638;5639;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8195;8196;8197;8449;8450;8451;10497;10753;10754;10755;10756;10757;11009;11010;11011;11012;13057;13313;13314;13315;15617;15618;15619;15620;15621;15622;15623;15624;15628;15625;15626;15627;15873;15874;15875;15876;15877;15878;15879;15880;15883;15881;15882;16129;16130;16131;16132', '0'),
('3', 'Salesman', 'Salesman', '768;3072;5632;8192;15872', '773;774;3073;3075;3081;5633;8194;15873', '0'),
('4', 'Stock Manager', 'Stock Manager', '2816;3072;3328;5632;5888;8192;8448;10752;11008;13312;15872;16128', '2818;2822;3073;3076;3077;3329;3330;3330;3330;3331;3331;3332;3333;3334;3335;5633;5640;5889;5890;5891;8193;8194;8450;8451;10753;11009;11010;11012;13313;13315;15882;16129;16130;16131;16132', '0'),
('5', 'Production Manager', 'Production Manager', '512;2816;3072;3328;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '521;523;524;2818;2819;2820;2821;2822;2823;3073;3074;3076;3077;3078;3079;3080;3081;3329;3330;3330;3330;3331;3331;3332;3333;3334;3335;5633;5640;5640;5889;5890;5891;8193;8194;8196;8197;8450;8451;10753;10755;11009;11010;11012;13313;13315;15617;15619;15620;15621;15624;15624;15876;15877;15880;15882;16129;16130;16131;16132', '0'),
('6', 'Purchase Officer', 'Purchase Officer', '512;2816;3072;3328;5376;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '521;523;524;2818;2819;2820;2821;2822;2823;3073;3074;3076;3077;3078;3079;3080;3081;3329;3330;3330;3330;3331;3331;3332;3333;3334;3335;5377;5633;5635;5640;5640;5889;5890;5891;8193;8194;8196;8197;8449;8450;8451;10753;10755;11009;11010;11012;13313;13315;15617;15619;15620;15621;15624;15624;15876;15877;15880;15882;16129;16130;16131;16132', '0'),
('7', 'AR Officer', 'AR Officer', '512;768;2816;3072;3328;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '521;523;524;771;773;774;2818;2819;2820;2821;2822;2823;3073;3073;3074;3075;3076;3077;3078;3079;3080;3081;3081;3329;3330;3330;3330;3331;3331;3332;3333;3334;3335;5633;5633;5634;5637;5638;5639;5640;5640;5889;5890;5891;8193;8194;8194;8196;8197;8450;8451;10753;10755;11009;11010;11012;13313;13315;15617;15619;15620;15621;15624;15624;15873;15876;15877;15878;15880;15882;16129;16130;16131;16132', '0'),
('8', 'AP Officer', 'AP Officer', '512;2816;3072;3328;5376;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '257;258;259;260;521;523;524;769;770;771;772;773;774;2818;2819;2820;2821;2822;2823;3073;3074;3082;3076;3077;3078;3079;3080;3081;3329;3330;3331;3332;3333;3334;3335;5377;5633;5635;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8196;8197;8449;8450;8451;10497;10753;10755;11009;11010;11012;13057;13313;13315;15617;15619;15620;15621;15624;15876;15877;15880;15882;16129;16130;16131;16132', '0'),
('9', 'Accountant', 'New Accountant', '512;768;2816;3072;3328;5376;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '257;258;259;260;521;523;524;771;772;773;774;2818;2819;2820;2821;2822;2823;3073;3074;3075;3076;3077;3078;3079;3080;3081;3329;3330;3331;3332;3333;3334;3335;5377;5633;5634;5635;5637;5638;5639;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8196;8197;8449;8450;8451;10497;10753;10755;11009;11010;11012;13313;13315;15617;15618;15619;15620;15621;15624;15873;15876;15877;15878;15880;15882;16129;16130;16131;16132', '0'),
('10', 'Sub Admin', 'Sub Admin', '512;768;2816;3072;3328;5376;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '257;258;259;260;521;523;524;771;772;773;774;2818;2819;2820;2821;2822;2823;3073;3074;3082;3075;3076;3077;3078;3079;3080;3081;3329;3330;3331;3332;3333;3334;3335;5377;5633;5634;5635;5637;5638;5639;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8196;8197;8449;8450;8451;10497;10753;10755;11009;11010;11012;13057;13313;13315;15617;15619;15620;15621;15624;15873;15874;15876;15877;15878;15879;15880;15882;16129;16130;16131;16132', '0');

### Structure of table `0_shippers` ###

DROP TABLE IF EXISTS `0_shippers`;

CREATE TABLE `0_shippers` (
  `shipper_id` int(11) NOT NULL AUTO_INCREMENT,
  `shipper_name` varchar(60) NOT NULL DEFAULT '',
  `phone` varchar(30) NOT NULL DEFAULT '',
  `phone2` varchar(30) NOT NULL DEFAULT '',
  `contact` tinytext NOT NULL,
  `address` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`shipper_id`),
  UNIQUE KEY `name` (`shipper_name`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ;

### Data of table `0_shippers` ###

INSERT INTO `0_shippers` VALUES
('1', 'None', '', '', '', '', '0');

### Structure of table `0_sql_trail` ###

DROP TABLE IF EXISTS `0_sql_trail`;

CREATE TABLE `0_sql_trail` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `sql` text NOT NULL,
  `result` tinyint(1) NOT NULL,
  `msg` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

### Data of table `0_sql_trail` ###


### Structure of table `0_stock_category` ###

DROP TABLE IF EXISTS `0_stock_category`;

CREATE TABLE `0_stock_category` (
  `category_id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(60) NOT NULL DEFAULT '',
  `dflt_tax_type` int(11) NOT NULL DEFAULT '1',
  `dflt_units` varchar(20) NOT NULL DEFAULT 'each',
  `dflt_mb_flag` char(1) NOT NULL DEFAULT 'B',
  `dflt_sales_act` varchar(15) NOT NULL DEFAULT '',
  `dflt_cogs_act` varchar(15) NOT NULL DEFAULT '',
  `dflt_inventory_act` varchar(15) NOT NULL DEFAULT '',
  `dflt_adjustment_act` varchar(15) NOT NULL DEFAULT '',
  `dflt_assembly_act` varchar(15) NOT NULL DEFAULT '',
  `dflt_dim1` int(11) DEFAULT NULL,
  `dflt_dim2` int(11) DEFAULT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  `dflt_no_sale` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `description` (`description`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 ;

### Data of table `0_stock_category` ###

### INSERT INTO `0_stock_category` VALUES

### Structure of table `0_stock_master` ###

DROP TABLE IF EXISTS `0_stock_master`;

CREATE TABLE `0_stock_master` (
  `stock_id` varchar(20) NOT NULL DEFAULT '',
  `category_id` int(11) NOT NULL DEFAULT '0',
  `tax_type_id` int(11) NOT NULL DEFAULT '0',
  `description` varchar(200) NOT NULL DEFAULT '',
  `long_description` tinytext NOT NULL,
  `units` varchar(20) NOT NULL DEFAULT 'each',
  `mb_flag` char(1) NOT NULL DEFAULT 'B',
  `sales_account` varchar(15) NOT NULL DEFAULT '',
  `cogs_account` varchar(15) NOT NULL DEFAULT '',
  `inventory_account` varchar(15) NOT NULL DEFAULT '',
  `adjustment_account` varchar(15) NOT NULL DEFAULT '',
  `assembly_account` varchar(15) NOT NULL DEFAULT '',
  `dimension_id` int(11) DEFAULT NULL,
  `dimension2_id` int(11) DEFAULT NULL,
  `actual_cost` double NOT NULL DEFAULT '0',
  `last_cost` double NOT NULL DEFAULT '0',
  `material_cost` double NOT NULL DEFAULT '0',
  `labour_cost` double NOT NULL DEFAULT '0',
  `overhead_cost` double NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  `no_sale` tinyint(1) NOT NULL DEFAULT '0',
  `editable` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`stock_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_stock_master` ###

### Structure of table `0_stock_moves` ###

DROP TABLE IF EXISTS `0_stock_moves`;

CREATE TABLE `0_stock_moves` (
  `trans_id` int(11) NOT NULL AUTO_INCREMENT,
  `trans_no` int(11) NOT NULL DEFAULT '0',
  `stock_id` char(20) NOT NULL DEFAULT '',
  `type` smallint(6) NOT NULL DEFAULT '0',
  `loc_code` char(5) NOT NULL DEFAULT '',
  `tran_date` date NOT NULL DEFAULT '0000-00-00',
  `person_id` int(11) DEFAULT NULL,
  `price` double NOT NULL DEFAULT '0',
  `reference` char(40) NOT NULL DEFAULT '',
  `qty` double NOT NULL DEFAULT '1',
  `discount_percent` double NOT NULL DEFAULT '0',
  `standard_cost` double NOT NULL DEFAULT '0',
  `visible` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`trans_id`),
  KEY `type` (`type`,`trans_no`),
  KEY `Move` (`stock_id`,`loc_code`,`tran_date`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 ;

### Data of table `0_stock_moves` ###

### Structure of table `0_supp_allocations` ###

DROP TABLE IF EXISTS `0_supp_allocations`;

CREATE TABLE `0_supp_allocations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `amt` double unsigned DEFAULT NULL,
  `date_alloc` date NOT NULL DEFAULT '0000-00-00',
  `trans_no_from` int(11) DEFAULT NULL,
  `trans_type_from` int(11) DEFAULT NULL,
  `trans_no_to` int(11) DEFAULT NULL,
  `trans_type_to` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `From` (`trans_type_from`,`trans_no_from`),
  KEY `To` (`trans_type_to`,`trans_no_to`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 ;

### Data of table `0_supp_allocations` ###


### Structure of table `0_supp_invoice_items` ###

DROP TABLE IF EXISTS `0_supp_invoice_items`;

CREATE TABLE `0_supp_invoice_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `supp_trans_no` int(11) DEFAULT NULL,
  `supp_trans_type` int(11) DEFAULT NULL,
  `gl_code` varchar(15) NOT NULL DEFAULT '',
  `grn_item_id` int(11) DEFAULT NULL,
  `po_detail_item_id` int(11) DEFAULT NULL,
  `stock_id` varchar(20) NOT NULL DEFAULT '',
  `description` tinytext,
  `quantity` double NOT NULL DEFAULT '0',
  `unit_price` double NOT NULL DEFAULT '0',
  `unit_tax` double NOT NULL DEFAULT '0',
  `memo_` tinytext,
  PRIMARY KEY (`id`),
  KEY `Transaction` (`supp_trans_type`,`supp_trans_no`,`stock_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 ;

### Data of table `0_supp_invoice_items` ###

### Structure of table `0_supp_trans` ###

DROP TABLE IF EXISTS `0_supp_trans`;

CREATE TABLE `0_supp_trans` (
  `trans_no` int(11) unsigned NOT NULL DEFAULT '0',
  `type` smallint(6) unsigned NOT NULL DEFAULT '0',
  `supplier_id` int(11) unsigned DEFAULT NULL,
  `reference` tinytext NOT NULL,
  `supp_reference` varchar(60) NOT NULL DEFAULT '',
  `tran_date` date NOT NULL DEFAULT '0000-00-00',
  `due_date` date NOT NULL DEFAULT '0000-00-00',
  `ov_amount` double NOT NULL DEFAULT '0',
  `ov_discount` double NOT NULL DEFAULT '0',
  `ov_gst` double NOT NULL DEFAULT '0',
  `rate` double NOT NULL DEFAULT '1',
  `alloc` double NOT NULL DEFAULT '0',
  `tax_included` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`type`,`trans_no`),
  KEY `supplier_id` (`supplier_id`),
  KEY `SupplierID_2` (`supplier_id`,`supp_reference`),
  KEY `type` (`type`),
  KEY `tran_date` (`tran_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_supp_trans` ###


### Structure of table `0_suppliers` ###

DROP TABLE IF EXISTS `0_suppliers`;

CREATE TABLE `0_suppliers` (
  `supplier_id` int(11) NOT NULL AUTO_INCREMENT,
  `supp_name` varchar(60) NOT NULL DEFAULT '',
  `supp_ref` varchar(30) NOT NULL DEFAULT '',
  `address` tinytext NOT NULL,
  `supp_address` tinytext NOT NULL,
  `gst_no` varchar(25) NOT NULL DEFAULT '',
  `contact` varchar(60) NOT NULL DEFAULT '',
  `supp_account_no` varchar(40) NOT NULL DEFAULT '',
  `website` varchar(100) NOT NULL DEFAULT '',
  `bank_account` varchar(60) NOT NULL DEFAULT '',
  `curr_code` char(3) DEFAULT NULL,
  `payment_terms` int(11) DEFAULT NULL,
  `tax_included` tinyint(1) NOT NULL DEFAULT '0',
  `dimension_id` int(11) DEFAULT '0',
  `dimension2_id` int(11) DEFAULT '0',
  `tax_group_id` int(11) DEFAULT NULL,
  `credit_limit` double NOT NULL DEFAULT '0',
  `purchase_account` varchar(15) NOT NULL DEFAULT '',
  `payable_account` varchar(15) NOT NULL DEFAULT '',
  `payment_discount_account` varchar(15) NOT NULL DEFAULT '',
  `notes` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`supplier_id`),
  KEY `supp_ref` (`supp_ref`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 ;

### Data of table `0_suppliers` ###


### Structure of table `0_sys_prefs` ###

DROP TABLE IF EXISTS `0_sys_prefs`;

CREATE TABLE `0_sys_prefs` (
  `name` varchar(35) NOT NULL DEFAULT '',
  `category` varchar(30) DEFAULT NULL,
  `type` varchar(20) NOT NULL DEFAULT '',
  `length` smallint(6) DEFAULT NULL,
  `value` tinytext,
  PRIMARY KEY (`name`),
  KEY `category` (`category`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

### Data of table `0_sys_prefs` ###

INSERT INTO `0_sys_prefs` VALUES
('coy_name', 'setup.company', 'varchar', '60', 'Training Co.'),
('gst_no', 'setup.company', 'varchar', '25', '9876543'),
('coy_no', 'setup.company', 'varchar', '25', '123456789'),
('tax_prd', 'setup.company', 'int', '11', '1'),
('tax_last', 'setup.company', 'int', '11', '1'),
('postal_address', 'setup.company', 'tinytext', '0', 'Address 1\r\nAddress 2\r\nAddress 3'),
('phone', 'setup.company', 'varchar', '30', '(222) 111.222.333'),
('fax', 'setup.company', 'varchar', '30', NULL),
('email', 'setup.company', 'varchar', '100', 'delta@delta.com'),
('coy_logo', 'setup.company', 'varchar', '100', 'logo_frontaccounting.jpg'),
('domicile', 'setup.company', 'varchar', '55', NULL),
('curr_default', 'setup.company', 'char', '3', 'RON'),
('use_dimension', 'setup.company', 'tinyint', '1', '1'),
('f_year', 'setup.company', 'int', '11', '4'),
('no_item_list', 'setup.company', 'tinyint', '1', '0'),
('no_customer_list', 'setup.company', 'tinyint', '1', '0'),
('no_supplier_list', 'setup.company', 'tinyint', '1', '0'),
('base_sales', 'setup.company', 'int', '11', '1'),
('time_zone', 'setup.company', 'tinyint', '1', '0'),
('add_pct', 'setup.company', 'int', '5', '-1'),
('round_to', 'setup.company', 'int', '5', '1'),
('login_tout', 'setup.company', 'smallint', '6', '600'),
('past_due_days', 'glsetup.general', 'int', '11', '30'),
('profit_loss_year_act', 'glsetup.general', 'varchar', '15', '9990'),
('retained_earnings_act', 'glsetup.general', 'varchar', '15', '3590'),
('bank_charge_act', 'glsetup.general', 'varchar', '15', '5690'),
('exchange_diff_act', 'glsetup.general', 'varchar', '15', '4450'),
('default_credit_limit', 'glsetup.customer', 'int', '11', '1000'),
('accumulate_shipping', 'glsetup.customer', 'tinyint', '1', '0'),
('legal_text', 'glsetup.customer', 'tinytext', '0', NULL),
('freight_act', 'glsetup.customer', 'varchar', '15', '4430'),
('debtors_act', 'glsetup.sales', 'varchar', '15', '1200'),
('default_sales_act', 'glsetup.sales', 'varchar', '15', '4010'),
('default_sales_discount_act', 'glsetup.sales', 'varchar', '15', '4510'),
('default_prompt_payment_act', 'glsetup.sales', 'varchar', '15', '4500'),
('default_delivery_required', 'glsetup.sales', 'smallint', '6', '1'),
('default_dim_required', 'glsetup.dims', 'int', '11', '20'),
('pyt_discount_act', 'glsetup.purchase', 'varchar', '15', '5060'),
('creditors_act', 'glsetup.purchase', 'varchar', '15', '2100'),
('po_over_receive', 'glsetup.purchase', 'int', '11', '10'),
('po_over_charge', 'glsetup.purchase', 'int', '11', '10'),
('allow_negative_stock', 'glsetup.inventory', 'tinyint', '1', '0'),
('default_inventory_act', 'glsetup.items', 'varchar', '15', '1510'),
('default_cogs_act', 'glsetup.items', 'varchar', '15', '5010'),
('default_adj_act', 'glsetup.items', 'varchar', '15', '5040'),
('default_inv_sales_act', 'glsetup.items', 'varchar', '15', '4010'),
('default_assembly_act', 'glsetup.items', 'varchar', '15', '1530'),
('default_workorder_required', 'glsetup.manuf', 'int', '11', '20'),
('version_id', 'system', 'varchar', '11', '2.3rc'),
('auto_curr_reval', 'setup.company', 'smallint', '6', '1'),
('grn_clearing_act', 'glsetup.purchase', 'varchar', '15', '1550');

### Structure of table `0_sys_types` ###

DROP TABLE IF EXISTS `0_sys_types`;

CREATE TABLE `0_sys_types` (
  `type_id` smallint(6) NOT NULL DEFAULT '0',
  `type_no` int(11) NOT NULL DEFAULT '1',
  `next_reference` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_sys_types` ###

INSERT INTO `0_sys_types` VALUES
('0', '19', '3'),
('1', '8', '2'),
('2', '5', '2'),
('4', '3', '1'),
('10', '19', '4'),
('11', '3', '2'),
('12', '6', '1'),
('13', '5', '2'),
('16', '2', '1'),
('17', '2', '1'),
('18', '1', '3'),
('20', '8', '3'),
('21', '1', '1'),
('22', '4', '2'),
('25', '1', '2'),
('26', '1', '8'),
('28', '1', '1'),
('29', '1', '2'),
('30', '5', '6'),
('32', '0', '1'),
('35', '1', '1'),
('40', '1', '3');

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
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` smallint(6) NOT NULL,
  `name` varchar(30) NOT NULL,
  `description` varchar(60) DEFAULT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `type` (`type`,`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

### Data of table `0_tags` ###


### Structure of table `0_tax_group_items` ###

DROP TABLE IF EXISTS `0_tax_group_items`;

CREATE TABLE `0_tax_group_items` (
  `tax_group_id` int(11) NOT NULL DEFAULT '0',
  `tax_type_id` int(11) NOT NULL DEFAULT '0',
  `rate` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`tax_group_id`,`tax_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_tax_group_items` ###

INSERT INTO `0_tax_group_items` VALUES
('1', '1', '5');

### Structure of table `0_tax_groups` ###

DROP TABLE IF EXISTS `0_tax_groups`;

CREATE TABLE `0_tax_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL DEFAULT '',
  `tax_shipping` tinyint(1) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 ;

### Data of table `0_tax_groups` ###

INSERT INTO `0_tax_groups` VALUES
('1', 'Tax', '0', '0'),
('2', 'Tax Exempt', '0', '0');

### Structure of table `0_tax_types` ###

DROP TABLE IF EXISTS `0_tax_types`;

CREATE TABLE `0_tax_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rate` double NOT NULL DEFAULT '0',
  `sales_gl_code` varchar(15) NOT NULL DEFAULT '',
  `purchasing_gl_code` varchar(15) NOT NULL DEFAULT '',
  `name` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ;

### Data of table `0_tax_types` ###

INSERT INTO `0_tax_types` VALUES
('1', '5', '2150', '2150', 'Tax', '0');

### Structure of table `0_trans_tax_details` ###

DROP TABLE IF EXISTS `0_trans_tax_details`;

CREATE TABLE `0_trans_tax_details` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `trans_type` smallint(6) DEFAULT NULL,
  `trans_no` int(11) DEFAULT NULL,
  `tran_date` date NOT NULL,
  `tax_type_id` int(11) NOT NULL DEFAULT '0',
  `rate` double NOT NULL DEFAULT '0',
  `ex_rate` double NOT NULL DEFAULT '1',
  `included_in_price` tinyint(1) NOT NULL DEFAULT '0',
  `net_amount` double NOT NULL DEFAULT '0',
  `amount` double NOT NULL DEFAULT '0',
  `memo` tinytext,
  PRIMARY KEY (`id`),
  KEY `Type_and_Number` (`trans_type`,`trans_no`),
  KEY `tran_date` (`tran_date`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1 ;

### Data of table `0_trans_tax_details` ###

INSERT INTO `0_trans_tax_details` VALUES
('1', '20', '7', '2009-06-21', '1', '5', '1', '0', '3300', '165', '5t'),
('2', '13', '3', '2009-06-21', '1', '5', '1', '0', '50', '2.5', 'auto'),
('3', '10', '17', '2009-06-21', '1', '5', '1', '0', '50', '2.5', '1'),
('4', '13', '4', '2009-06-21', '1', '5', '1.3932', '0', '35.89', '1.7945', 'auto'),
('5', '10', '18', '2009-06-21', '1', '5', '1.3932', '0', '35.89', '1.7945', '2'),
('6', '2', '5', '2009-06-21', '1', '5', '1', '0', '95.2', '4.76', NULL),
('7', '1', '8', '2009-06-21', '1', '5', '1', '0', '-47.6', '-2.38', NULL),
('8', '20', '8', '2009-06-21', '1', '5', '1', '0', '-19', '-0.95', 'cc'),
('9', '13', '5', '2009-06-21', '1', '5', '1', '1', '47.619047619048', '2.3809523809524', 'auto'),
('10', '10', '19', '2009-06-21', '1', '5', '1', '1', '47.619047619048', '2.3809523809524', '3'),
('11', '11', '3', '2009-06-21', '1', '5', '1.3932', '0', '35.89', '1.7945', '1');

### Structure of table `0_useronline` ###

DROP TABLE IF EXISTS `0_useronline`;

CREATE TABLE `0_useronline` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` int(15) NOT NULL DEFAULT '0',
  `ip` varchar(40) NOT NULL DEFAULT '',
  `file` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `timestamp` (`timestamp`),
  KEY `ip` (`ip`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

### Data of table `0_useronline` ###


### Structure of table `0_users` ###

DROP TABLE IF EXISTS `0_users`;

CREATE TABLE `0_users` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(60) NOT NULL DEFAULT '',
  `password` varchar(100) NOT NULL DEFAULT '',
  `real_name` varchar(100) NOT NULL DEFAULT '',
  `role_id` int(11) NOT NULL DEFAULT '1',
  `phone` varchar(30) NOT NULL DEFAULT '',
  `email` varchar(100) DEFAULT NULL,
  `language` varchar(20) DEFAULT NULL,
  `date_format` tinyint(1) NOT NULL DEFAULT '0',
  `date_sep` tinyint(1) NOT NULL DEFAULT '0',
  `tho_sep` tinyint(1) NOT NULL DEFAULT '0',
  `dec_sep` tinyint(1) NOT NULL DEFAULT '0',
  `theme` varchar(20) NOT NULL DEFAULT 'default',
  `page_size` varchar(20) NOT NULL DEFAULT 'A4',
  `prices_dec` smallint(6) NOT NULL DEFAULT '2',
  `qty_dec` smallint(6) NOT NULL DEFAULT '2',
  `rates_dec` smallint(6) NOT NULL DEFAULT '4',
  `percent_dec` smallint(6) NOT NULL DEFAULT '1',
  `show_gl` tinyint(1) NOT NULL DEFAULT '1',
  `show_codes` tinyint(1) NOT NULL DEFAULT '0',
  `show_hints` tinyint(1) NOT NULL DEFAULT '0',
  `last_visit_date` datetime DEFAULT NULL,
  `query_size` tinyint(1) DEFAULT '10',
  `graphic_links` tinyint(1) DEFAULT '1',
  `pos` smallint(6) DEFAULT '1',
  `print_profile` varchar(30) NOT NULL DEFAULT '1',
  `rep_popup` tinyint(1) DEFAULT '1',
  `sticky_doc_date` tinyint(1) DEFAULT '0',
  `startup_tab` varchar(20) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 ;

### Data of table `0_users` ###

INSERT INTO `0_users` VALUES
('1', 'admin', '5f4dcc3b5aa765d61d8327deb882cf99', 'Administrator', '2', '', 'adm@adm.com', 'en_US', '0', '0', '0', '0', 'default', 'Letter', '2', '2', '4', '1', '1', '0', '0', '2012-02-07 14:48:55', '10', '1', '1', '1', '1', '0', 'orders', '0'),
('2', 'demouser', '5f4dcc3b5aa765d61d8327deb882cf99', 'Demo User', '9', '999-999-999', 'demo@demo.nu', 'en_US', '0', '0', '0', '0', 'default', 'Letter', '2', '2', '3', '1', '1', '0', '0', '2008-02-06 19:02:35', '10', '1', '1', '1', '1', '0', 'orders', '0');

### Structure of table `0_voided` ###

DROP TABLE IF EXISTS `0_voided`;

CREATE TABLE `0_voided` (
  `type` int(11) NOT NULL DEFAULT '0',
  `id` int(11) NOT NULL DEFAULT '0',
  `date_` date NOT NULL DEFAULT '0000-00-00',
  `memo_` tinytext NOT NULL,
  UNIQUE KEY `id` (`type`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_voided` ###


### Structure of table `0_wo_issue_items` ###

DROP TABLE IF EXISTS `0_wo_issue_items`;

CREATE TABLE `0_wo_issue_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stock_id` varchar(40) DEFAULT NULL,
  `issue_id` int(11) DEFAULT NULL,
  `qty_issued` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_wo_issue_items` ###


### Structure of table `0_wo_issues` ###

DROP TABLE IF EXISTS `0_wo_issues`;

CREATE TABLE `0_wo_issues` (
  `issue_no` int(11) NOT NULL AUTO_INCREMENT,
  `workorder_id` int(11) NOT NULL DEFAULT '0',
  `reference` varchar(100) DEFAULT NULL,
  `issue_date` date DEFAULT NULL,
  `loc_code` varchar(5) DEFAULT NULL,
  `workcentre_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`issue_no`),
  KEY `workorder_id` (`workorder_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_wo_issues` ###


### Structure of table `0_wo_manufacture` ###

DROP TABLE IF EXISTS `0_wo_manufacture`;

CREATE TABLE `0_wo_manufacture` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reference` varchar(100) DEFAULT NULL,
  `workorder_id` int(11) NOT NULL DEFAULT '0',
  `quantity` double NOT NULL DEFAULT '0',
  `date_` date NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (`id`),
  KEY `workorder_id` (`workorder_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ;

### Data of table `0_wo_manufacture` ###

INSERT INTO `0_wo_manufacture` VALUES
('1', '1', '2', '2', '2009-06-21');

### Structure of table `0_wo_requirements` ###

DROP TABLE IF EXISTS `0_wo_requirements`;

CREATE TABLE `0_wo_requirements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `workorder_id` int(11) NOT NULL DEFAULT '0',
  `stock_id` char(20) NOT NULL DEFAULT '',
  `workcentre` int(11) NOT NULL DEFAULT '0',
  `units_req` double NOT NULL DEFAULT '1',
  `std_cost` double NOT NULL DEFAULT '0',
  `loc_code` char(5) NOT NULL DEFAULT '',
  `units_issued` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `workorder_id` (`workorder_id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1 ;

### Data of table `0_wo_requirements` ###

INSERT INTO `0_wo_requirements` VALUES
('1', '1', '102', '1', '1', '0', 'DEF', '10'),
('2', '1', '103', '1', '1', '0', 'DEF', '10'),
('3', '1', '104', '1', '1', '0', 'DEF', '10'),
('4', '2', '102', '1', '1', '0', 'DEF', '0'),
('5', '2', '103', '1', '1', '0', 'DEF', '0'),
('6', '2', '104', '1', '1', '0', 'DEF', '0'),
('7', '3', '102', '1', '1', '0', 'DEF', '2'),
('8', '3', '103', '1', '1', '0', 'DEF', '2'),
('9', '3', '104', '1', '1', '0', 'DEF', '2'),
('10', '4', '102', '1', '1', '0', 'DEF', '4'),
('11', '4', '103', '1', '1', '0', 'DEF', '4'),
('12', '4', '104', '1', '1', '0', 'DEF', '4'),
('13', '5', '102', '1', '1', '0', 'DEF', '5'),
('14', '5', '103', '1', '1', '0', 'DEF', '5'),
('15', '5', '104', '1', '1', '0', 'DEF', '5'),
('16', '6', '102', '1', '1', '0', 'DEF', '-5'),
('17', '6', '103', '1', '1', '0', 'DEF', '-5'),
('18', '6', '104', '1', '1', '0', 'DEF', '-5'),
('19', '7', '102', '1', '1', '0', 'DEF', '-2'),
('20', '7', '103', '1', '1', '0', 'DEF', '-2'),
('21', '7', '104', '1', '1', '0', 'DEF', '-2');

### Structure of table `0_workcentres` ###

DROP TABLE IF EXISTS `0_workcentres`;

CREATE TABLE `0_workcentres` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(40) NOT NULL DEFAULT '',
  `description` char(50) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ;

### Data of table `0_workcentres` ###

INSERT INTO `0_workcentres` VALUES
('1', 'Workshop', 'Workshop in Alabama', '0');

### Structure of table `0_workorders` ###

DROP TABLE IF EXISTS `0_workorders`;

CREATE TABLE `0_workorders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `wo_ref` varchar(60) NOT NULL DEFAULT '',
  `loc_code` varchar(5) NOT NULL DEFAULT '',
  `units_reqd` double NOT NULL DEFAULT '1',
  `stock_id` varchar(20) NOT NULL DEFAULT '',
  `date_` date NOT NULL DEFAULT '0000-00-00',
  `type` tinyint(4) NOT NULL DEFAULT '0',
  `required_by` date NOT NULL DEFAULT '0000-00-00',
  `released_date` date NOT NULL DEFAULT '0000-00-00',
  `units_issued` double NOT NULL DEFAULT '0',
  `closed` tinyint(1) NOT NULL DEFAULT '0',
  `released` tinyint(1) NOT NULL DEFAULT '0',
  `additional_costs` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `wo_ref` (`wo_ref`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1 ;

### Data of table `0_workorders` ###

INSERT INTO `0_workorders` VALUES
('1', '1', 'DEF', '10', '3400', '2009-06-21', '0', '2009-06-21', '2009-06-21', '10', '1', '1', '10'),
('2', '2', 'DEF', '3', '3400', '2009-06-21', '2', '2009-07-11', '2009-06-21', '2', '0', '1', '0'),
('3', '3', 'DEF', '2', '3400', '2009-06-21', '0', '2009-06-21', '2009-06-21', '2', '1', '1', '0'),
('4', '4', 'DEF', '4', '3400', '2009-06-21', '0', '2009-06-21', '2009-06-21', '4', '1', '1', '0'),
('5', '5', 'DEF', '5', '3400', '2009-06-21', '0', '2009-06-21', '2009-06-21', '5', '1', '1', '10'),
('6', '6', 'DEF', '-5', '3400', '2009-06-21', '1', '2009-06-21', '2009-06-21', '-5', '1', '1', '0'),
('7', '7', 'DEF', '-2', '3400', '2009-06-21', '1', '2009-06-21', '2009-06-21', '-2', '1', '1', '10');