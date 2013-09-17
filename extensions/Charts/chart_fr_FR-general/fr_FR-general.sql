# MySQL dump of database 'faupgrade' on host 'localhost'
# Backup Date and Time: 2010-08-06 13:59
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
) ENGINE=MyISAM AUTO_INCREMENT=3  ;


### Data of table `0_areas` ###

INSERT INTO `0_areas` VALUES ('2', 'France', '0');


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

INSERT INTO `0_bank_accounts` VALUES ('531100', '3', 'Bank', '', '', NULL, 'EUR', '0', '1', '0000-00-00 00:00:00', '0', '0');
INSERT INTO `0_bank_accounts` VALUES ('512100', '1', 'Bank', '', '', NULL, 'EUR', '0', '2', '0000-00-00 00:00:00', '0', '0');


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

INSERT INTO `0_chart_class` VALUES ('1', '1 Capitaux', '3', '0');
INSERT INTO `0_chart_class` VALUES ('2', '2 Immobilisations', '1', '0');
INSERT INTO `0_chart_class` VALUES ('3', '3 Stocks et en-cours', '1', '0');
INSERT INTO `0_chart_class` VALUES ('4', '4 Tiers', '2', '0');
INSERT INTO `0_chart_class` VALUES ('5', '5 Financiers', '1', '0');
INSERT INTO `0_chart_class` VALUES ('6', '6 Charges', '6', '0');
INSERT INTO `0_chart_class` VALUES ('7', '7 Produits', '4', '0');
INSERT INTO `0_chart_class` VALUES ('8', '8 Comptes spéciaux', '4', '0');


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

INSERT INTO `0_chart_master` VALUES ('100000', '', 'Capital et réserves.', '10', '0');
INSERT INTO `0_chart_master` VALUES ('101000', '', 'Capital.', '101', '0');
INSERT INTO `0_chart_master` VALUES ('101100', '', 'Capital souscrit - non appelé.', '1011', '0');
INSERT INTO `0_chart_master` VALUES ('101200', '', 'Capital souscrit - appelé, non versé.', '1012', '0');
INSERT INTO `0_chart_master` VALUES ('101300', '', 'Capital souscrit - appelé, versé.', '1013', '0');
INSERT INTO `0_chart_master` VALUES ('101310', '', 'Capital non amorti.', '10131', '0');
INSERT INTO `0_chart_master` VALUES ('101320', '', 'Capital amorti.', '10132', '0');
INSERT INTO `0_chart_master` VALUES ('101800', '', 'Capital souscrit soumis à des réglementations part', '1018', '0');
INSERT INTO `0_chart_master` VALUES ('104000', '', 'Primes liées au capital social.', '104', '0');
INSERT INTO `0_chart_master` VALUES ('104100', '', 'Primes d&#039;émission.', '1041', '0');
INSERT INTO `0_chart_master` VALUES ('104200', '', 'Primes de fusion.', '1042', '0');
INSERT INTO `0_chart_master` VALUES ('104300', '', 'Primes d&#039;apport.', '1043', '0');
INSERT INTO `0_chart_master` VALUES ('104400', '', 'Primes de conversion d&#039;obligations en actions.', '1044', '0');
INSERT INTO `0_chart_master` VALUES ('104500', '', 'Bons de souscription d&#039;actions.', '1045', '0');
INSERT INTO `0_chart_master` VALUES ('105000', '', 'Ecarts de réévaluation.', '105', '0');
INSERT INTO `0_chart_master` VALUES ('105100', '', 'Réserve spéciale de réévaluation.', '1051', '0');
INSERT INTO `0_chart_master` VALUES ('105200', '', 'Ecart de réévaluation libre.', '1052', '0');
INSERT INTO `0_chart_master` VALUES ('105300', '', 'Réserve de réévaluation.', '1053', '0');
INSERT INTO `0_chart_master` VALUES ('105500', '', 'Ecarts de réévaluation (autres opérations légales)', '1055', '0');
INSERT INTO `0_chart_master` VALUES ('105700', '', 'Autres écarts de réévaluation en France.', '1057', '0');
INSERT INTO `0_chart_master` VALUES ('105800', '', 'Autres écarts de réévaluation à l&#039;étranger.', '1058', '0');
INSERT INTO `0_chart_master` VALUES ('106000', '', 'Réserves.', '106', '0');
INSERT INTO `0_chart_master` VALUES ('106100', '', 'Réserve légale.', '1061', '0');
INSERT INTO `0_chart_master` VALUES ('106110', '', 'Réserve légale proprement dite.', '10611', '0');
INSERT INTO `0_chart_master` VALUES ('106120', '', 'Plus-values nettes à long terme.', '10612', '0');
INSERT INTO `0_chart_master` VALUES ('106200', '', 'Réserves indisponibles.', '1062', '0');
INSERT INTO `0_chart_master` VALUES ('106300', '', 'Réserves statutaires ou contractuelles.', '1063', '0');
INSERT INTO `0_chart_master` VALUES ('106400', '', 'Réserves réglementées.', '1064', '0');
INSERT INTO `0_chart_master` VALUES ('106410', '', 'Plus-values nettes à long terme.', '10641', '0');
INSERT INTO `0_chart_master` VALUES ('106430', '', 'Réserves consécutives à l&#039;octroi de subventions d&#039;', '10643', '0');
INSERT INTO `0_chart_master` VALUES ('106480', '', 'Autres réserves réglementées.', '10648', '0');
INSERT INTO `0_chart_master` VALUES ('106800', '', 'Autres réserves.', '1068', '0');
INSERT INTO `0_chart_master` VALUES ('106810', '', 'Réserve de propre assureur.', '10681', '0');
INSERT INTO `0_chart_master` VALUES ('106880', '', 'Réserves diverses.', '10688', '0');
INSERT INTO `0_chart_master` VALUES ('107000', '', 'Ecart d&#039;équivalence.', '107', '0');
INSERT INTO `0_chart_master` VALUES ('108000', '', 'Compte de l&#039;exploitant.', '108', '0');
INSERT INTO `0_chart_master` VALUES ('109000', '', 'Actionnaires : Capital souscrit - non appelé.', '109', '0');
INSERT INTO `0_chart_master` VALUES ('110000', '', 'Report à nouveau (solde créditeur).', '110', '0');
INSERT INTO `0_chart_master` VALUES ('119000', '', 'Report à nouveau (solde débiteur).', '119', '0');
INSERT INTO `0_chart_master` VALUES ('120000', '', 'Résultat de l&#039;exercice (bénéfice).', '120', '0');
INSERT INTO `0_chart_master` VALUES ('129000', '', 'Résultat de l&#039;exercice (perte).', '129', '0');
INSERT INTO `0_chart_master` VALUES ('130000', '', 'Subventions d&#039;investissement.', '13', '0');
INSERT INTO `0_chart_master` VALUES ('131000', '', 'Subventions d&#039;équipement.', '131', '0');
INSERT INTO `0_chart_master` VALUES ('131100', '', 'Etat.', '1311', '0');
INSERT INTO `0_chart_master` VALUES ('131200', '', 'Régions.', '1312', '0');
INSERT INTO `0_chart_master` VALUES ('131300', '', 'Départements.', '1313', '0');
INSERT INTO `0_chart_master` VALUES ('131400', '', 'Communes.', '1314', '0');
INSERT INTO `0_chart_master` VALUES ('131500', '', 'Collectivités publiques.', '1315', '0');
INSERT INTO `0_chart_master` VALUES ('131600', '', 'Entreprises publiques.', '1316', '0');
INSERT INTO `0_chart_master` VALUES ('131700', '', 'Entreprises et organismes privés.', '1317', '0');
INSERT INTO `0_chart_master` VALUES ('131800', '', 'Autres.', '1318', '0');
INSERT INTO `0_chart_master` VALUES ('138000', '', 'Autres subventions d&#039;investissement.', '138', '0');
INSERT INTO `0_chart_master` VALUES ('139000', '', 'Subventions d&#039;investissement inscrites au compte d', '139', '0');
INSERT INTO `0_chart_master` VALUES ('139100', '', 'Subventions d&#039;équipement.', '1391', '0');
INSERT INTO `0_chart_master` VALUES ('139110', '', 'Etat.', '13911', '0');
INSERT INTO `0_chart_master` VALUES ('139120', '', 'Régions.', '13912', '0');
INSERT INTO `0_chart_master` VALUES ('139130', '', 'Départements.', '13913', '0');
INSERT INTO `0_chart_master` VALUES ('139140', '', 'Communes.', '13914', '0');
INSERT INTO `0_chart_master` VALUES ('139150', '', 'Collectivités publiques.', '13915', '0');
INSERT INTO `0_chart_master` VALUES ('139160', '', 'Entreprises publiques.', '13916', '0');
INSERT INTO `0_chart_master` VALUES ('139170', '', 'Entreprises et organismes privés.', '13917', '0');
INSERT INTO `0_chart_master` VALUES ('139180', '', 'Autres.', '13918', '0');
INSERT INTO `0_chart_master` VALUES ('139800', '', 'Autres subventions d&#039;investissement.', '1398', '0');
INSERT INTO `0_chart_master` VALUES ('140000', '', 'Provisions réglementées.', '14', '0');
INSERT INTO `0_chart_master` VALUES ('142000', '', 'Provisions réglementées relatives aux immobilisati', '142', '0');
INSERT INTO `0_chart_master` VALUES ('142300', '', 'Provision pour reconstitution desgisements miniers', '1423', '0');
INSERT INTO `0_chart_master` VALUES ('142400', '', 'Provision pour investissement(participation des sa', '1424', '0');
INSERT INTO `0_chart_master` VALUES ('143000', '', 'Provisions réglementées relatives aux stocks.', '143', '0');
INSERT INTO `0_chart_master` VALUES ('143100', '', 'Hausse des prix.', '1431', '0');
INSERT INTO `0_chart_master` VALUES ('143200', '', 'Fluctuation des cours.', '1432', '0');
INSERT INTO `0_chart_master` VALUES ('144000', '', 'Provisions réglementées relatives aux autres éléme', '144', '0');
INSERT INTO `0_chart_master` VALUES ('145000', '', ' Amortissements dérogatoires.', '145', '0');
INSERT INTO `0_chart_master` VALUES ('146000', '', 'Provision spéciale de réévaluation.', '146', '0');
INSERT INTO `0_chart_master` VALUES ('147000', '', 'Plus-values réinvesties.', '147', '0');
INSERT INTO `0_chart_master` VALUES ('148000', '', 'Autres provisions réglementées.', '148', '0');
INSERT INTO `0_chart_master` VALUES ('150000', '', 'Provisions.', '15', '0');
INSERT INTO `0_chart_master` VALUES ('151000', '', 'Provisions pour risques.', '151', '0');
INSERT INTO `0_chart_master` VALUES ('151100', '', 'Provisions pour litiges.', '1511', '0');
INSERT INTO `0_chart_master` VALUES ('151200', '', 'Provisions pour garanties données aux clients.', '1512', '0');
INSERT INTO `0_chart_master` VALUES ('151300', '', 'Provisions pour pertes sur marchés à terme.', '1513', '0');
INSERT INTO `0_chart_master` VALUES ('151400', '', 'Provisions pour amendes et pénalités.', '1514', '0');
INSERT INTO `0_chart_master` VALUES ('151500', '', 'Provisions pour pertes de change.', '1515', '0');
INSERT INTO `0_chart_master` VALUES ('151600', '', 'Provisions pour pertes sur contrats.', '1516', '0');
INSERT INTO `0_chart_master` VALUES ('151800', '', 'Autres provisions pour risques.', '1518', '0');
INSERT INTO `0_chart_master` VALUES ('153000', '', 'Provisions pour pensions et obligations similaires', '153', '0');
INSERT INTO `0_chart_master` VALUES ('154000', '', 'Provisions pour restructurations.', '154', '0');
INSERT INTO `0_chart_master` VALUES ('155000', '', 'Provisions pour impôts.', '155', '0');
INSERT INTO `0_chart_master` VALUES ('156000', '', 'Provisions pour renouvellement des immobilisations', '156', '0');
INSERT INTO `0_chart_master` VALUES ('157000', '', 'Provisions pour charges à répartir sur plusieurs e', '157', '0');
INSERT INTO `0_chart_master` VALUES ('158000', '', 'Provisions pour gros entretien ou grandes révision', '1572', '0');
INSERT INTO `0_chart_master` VALUES ('157200', '', 'Autres provisions pour charges.', '158', '0');
INSERT INTO `0_chart_master` VALUES ('158200', '', 'Provisions pour remise en état.', '1581', '0');
INSERT INTO `0_chart_master` VALUES ('160000', '', 'Emprunts et dettes assimilées.', '16', '0');
INSERT INTO `0_chart_master` VALUES ('161000', '', 'Emprunts obligataires convertibles.', '161', '0');
INSERT INTO `0_chart_master` VALUES ('163000', '', 'Autres emprunts obligataires.', '163', '0');
INSERT INTO `0_chart_master` VALUES ('164000', '', 'Emprunts auprès des établissements de crédit.', '164', '0');
INSERT INTO `0_chart_master` VALUES ('165000', '', 'Dépôts et cautionnements reçus.', '165', '0');
INSERT INTO `0_chart_master` VALUES ('165100', '', 'Dépôts.', '1651', '0');
INSERT INTO `0_chart_master` VALUES ('165500', '', 'Cautionnements.', '1655', '0');
INSERT INTO `0_chart_master` VALUES ('166000', '', 'Participation des salariés aux résultats.', '166', '0');
INSERT INTO `0_chart_master` VALUES ('166100', '', 'Comptes bloqués.', '1661', '0');
INSERT INTO `0_chart_master` VALUES ('166200', '', 'Fonds de participation.', '1662', '0');
INSERT INTO `0_chart_master` VALUES ('167000', '', 'Emprunts et dettes assortis de conditions particul', '167', '0');
INSERT INTO `0_chart_master` VALUES ('167100', '', 'Emissions de titres participatifs.', '1671', '0');
INSERT INTO `0_chart_master` VALUES ('167400', '', 'Avances conditionnées de l&#039;Etat.', '1674', '0');
INSERT INTO `0_chart_master` VALUES ('168000', '', 'Emprunts participatifs.', '1675', '0');
INSERT INTO `0_chart_master` VALUES ('167500', '', 'Autres emprunts et dettes assimilées.', '168', '0');
INSERT INTO `0_chart_master` VALUES ('168100', '', 'Autres emprunts.', '1681', '0');
INSERT INTO `0_chart_master` VALUES ('168500', '', 'Rentes viagères capitalisées.', '1685', '0');
INSERT INTO `0_chart_master` VALUES ('168700', '', 'Autres dettes.', '1687', '0');
INSERT INTO `0_chart_master` VALUES ('168800', '', 'Intérêts courus.', '1688', '0');
INSERT INTO `0_chart_master` VALUES ('168810', '', 'Sur emprunts obligataires convertibles.', '16881', '0');
INSERT INTO `0_chart_master` VALUES ('168840', '', 'Sur emprunts auprès des établissements de crédit.', '16884', '0');
INSERT INTO `0_chart_master` VALUES ('168850', '', 'Sur dépôts et cautionnements reçus.', '16885', '0');
INSERT INTO `0_chart_master` VALUES ('168860', '', 'Sur participation des salariés aux résultats.', '16886', '0');
INSERT INTO `0_chart_master` VALUES ('168870', '', 'Sur emprunts et dettes assortis de conditions part', '16887', '0');
INSERT INTO `0_chart_master` VALUES ('168880', '', 'Sur autres emprunts et dettes assimilées.', '16888', '0');
INSERT INTO `0_chart_master` VALUES ('169000', '', 'Primes de remboursement des obligations.', '169', '0');
INSERT INTO `0_chart_master` VALUES ('170000', '', 'Dettes rattachées à des participations.', '17', '0');
INSERT INTO `0_chart_master` VALUES ('171000', '', 'Dettes rattachées à des participations (groupe).', '171', '0');
INSERT INTO `0_chart_master` VALUES ('174000', '', 'Dettes rattachées à des participation (hors groupe', '174', '0');
INSERT INTO `0_chart_master` VALUES ('178000', '', 'Dettes rattachées à des sociétés en participation.', '178', '0');
INSERT INTO `0_chart_master` VALUES ('178100', '', 'Principal.', '1781', '0');
INSERT INTO `0_chart_master` VALUES ('178800', '', 'Intérêts courus.', '1788', '0');
INSERT INTO `0_chart_master` VALUES ('180000', '', 'Comptes de liaison des établissements et sociétés ', '18', '0');
INSERT INTO `0_chart_master` VALUES ('181000', '', 'Compte de liaison des établissements.', '181', '0');
INSERT INTO `0_chart_master` VALUES ('186000', '', 'Biens et prestations de services échangés entre ét', '186', '0');
INSERT INTO `0_chart_master` VALUES ('187000', '', 'Biens et prestations de services échangés entre ét', '187', '0');
INSERT INTO `0_chart_master` VALUES ('188000', '', 'Comptes de liaison des sociétés en participation.', '188', '0');
INSERT INTO `0_chart_master` VALUES ('200000', '', 'Immobilisations incorporelles.', '20', '0');
INSERT INTO `0_chart_master` VALUES ('201000', '', 'Frais d&#039;établissement.', '201', '0');
INSERT INTO `0_chart_master` VALUES ('201100', '', 'Frais de constitution.', '2011', '0');
INSERT INTO `0_chart_master` VALUES ('201200', '', 'Frais de premier établissement.', '2012', '0');
INSERT INTO `0_chart_master` VALUES ('201210', '', 'Frais de prospection.', '20121', '0');
INSERT INTO `0_chart_master` VALUES ('201220', '', 'Frais de publicité.', '20122', '0');
INSERT INTO `0_chart_master` VALUES ('201300', '', 'Frais d&#039;augmentation de capital et d&#039;opérations di', '2013', '0');
INSERT INTO `0_chart_master` VALUES ('203000', '', 'Frais de recherche et de développement.', '203', '0');
INSERT INTO `0_chart_master` VALUES ('205000', '', 'Concessions et droits similaires, brevets, licence', '205', '0');
INSERT INTO `0_chart_master` VALUES ('206000', '', 'Droit au bail.', '206', '0');
INSERT INTO `0_chart_master` VALUES ('207000', '', 'Fonds commercial.', '207', '0');
INSERT INTO `0_chart_master` VALUES ('208000', '', 'Autres immobilisations incorporelles.', '208', '0');
INSERT INTO `0_chart_master` VALUES ('210000', '', 'Immobilisations corporelles.', '21', '0');
INSERT INTO `0_chart_master` VALUES ('211000', '', 'Terrains.', '211', '0');
INSERT INTO `0_chart_master` VALUES ('211100', '', 'Terrains nus.', '2111', '0');
INSERT INTO `0_chart_master` VALUES ('211200', '', 'Terrains aménagés.', '2112', '0');
INSERT INTO `0_chart_master` VALUES ('211300', '', 'Sous-sols et sur-sols.', '2113', '0');
INSERT INTO `0_chart_master` VALUES ('211400', '', 'Terrains de gisements.', '2114', '0');
INSERT INTO `0_chart_master` VALUES ('211410', '', 'Carrières.', '21141', '0');
INSERT INTO `0_chart_master` VALUES ('211500', '', 'Terrains bâtis.', '2115', '0');
INSERT INTO `0_chart_master` VALUES ('211510', '', 'Ensembles immobiliers industriels (A, B...).', '21151', '0');
INSERT INTO `0_chart_master` VALUES ('211550', '', 'Ensembles immobiliers administratifs et commerciau', '21155', '0');
INSERT INTO `0_chart_master` VALUES ('211580', '', 'Autres ensembles immobiliers.', '21158', '0');
INSERT INTO `0_chart_master` VALUES ('211581', '', 'Autres ensembles immobiliers affectés aux opérations profess', '211581', '0');
INSERT INTO `0_chart_master` VALUES ('211588', '', 'Autres ensembles immobiliers affectés aux opérations non pro', '211588', '0');
INSERT INTO `0_chart_master` VALUES ('211600', '', 'Autres ensembles immobiliers affectés aux opérations profess', '213181', '0');
INSERT INTO `0_chart_master` VALUES ('212000', '', 'Autres ensembles immobiliers affectés aux opérations non pro', '213188', '0');
INSERT INTO `0_chart_master` VALUES ('213000', '', 'Compte d&#039;ordre sur immobilisations (art. 6 du décr', '2116', '0');
INSERT INTO `0_chart_master` VALUES ('213100', '', 'Agencements et aménagements de terrains.', '212', '0');
INSERT INTO `0_chart_master` VALUES ('213110', '', 'Constructions.', '213', '0');
INSERT INTO `0_chart_master` VALUES ('213150', '', 'Bâtiments.', '2131', '0');
INSERT INTO `0_chart_master` VALUES ('213180', '', 'Ensembles immobiliers industriels (A, B...).', '21311', '0');
INSERT INTO `0_chart_master` VALUES ('213181', '', 'Ensembles immobiliers administratifs et commerciau', '21315', '0');
INSERT INTO `0_chart_master` VALUES ('213188', '', 'Autres ensembles immobiliers.', '21318', '0');
INSERT INTO `0_chart_master` VALUES ('213500', '', 'Installations générales - Agencements-aménagements', '2135', '0');
INSERT INTO `0_chart_master` VALUES ('213800', '', 'Ouvrages d&#039;infrastructure.', '2138', '0');
INSERT INTO `0_chart_master` VALUES ('213810', '', 'Voies de terre.', '21381', '0');
INSERT INTO `0_chart_master` VALUES ('213820', '', 'Voies de fer.', '21382', '0');
INSERT INTO `0_chart_master` VALUES ('213830', '', 'Voies d&#039;eau.', '21383', '0');
INSERT INTO `0_chart_master` VALUES ('213840', '', 'Barrages.', '21384', '0');
INSERT INTO `0_chart_master` VALUES ('213850', '', 'Pistes d&#039;aérodrome.', '21385', '0');
INSERT INTO `0_chart_master` VALUES ('214000', '', 'Constructions sur sol d&#039;autrui.', '214', '0');
INSERT INTO `0_chart_master` VALUES ('215000', '', 'Installations techniques, matériel et outillage in', '215', '0');
INSERT INTO `0_chart_master` VALUES ('215100', '', 'Installations complexes spécialisées.', '2151', '0');
INSERT INTO `0_chart_master` VALUES ('215110', '', 'Installations complexes spécialisées sur sol propre.', '21511', '0');
INSERT INTO `0_chart_master` VALUES ('215140', '', 'Installations complexes spécialisées sur sol d&#039;autrui.', '21514', '0');
INSERT INTO `0_chart_master` VALUES ('215300', '', 'Installations à caractère spécifique.', '2153', '0');
INSERT INTO `0_chart_master` VALUES ('215310', '', 'Installations à caractère spécifique sur sol propre.', '21531', '0');
INSERT INTO `0_chart_master` VALUES ('215340', '', 'Installations à caractère spécifique sur sol d&#039;autrui.', '21534', '0');
INSERT INTO `0_chart_master` VALUES ('215400', '', 'Matériel industriel.', '2154', '0');
INSERT INTO `0_chart_master` VALUES ('215500', '', 'Outillage industriel.', '2155', '0');
INSERT INTO `0_chart_master` VALUES ('215700', '', 'Agencements et aménagements du matériel et outilla', '2157', '0');
INSERT INTO `0_chart_master` VALUES ('218000', '', 'Autres immobilisations corporelles.', '218', '0');
INSERT INTO `0_chart_master` VALUES ('218100', '', 'Installations générales, agencements, aménagements', '2181', '0');
INSERT INTO `0_chart_master` VALUES ('218200', '', 'Matériel de transport.', '2182', '0');
INSERT INTO `0_chart_master` VALUES ('218300', '', 'Matériel de bureau et matériel informatique.', '2183', '0');
INSERT INTO `0_chart_master` VALUES ('218400', '', 'Mobilier.', '2184', '0');
INSERT INTO `0_chart_master` VALUES ('218500', '', 'Cheptel.', '2185', '0');
INSERT INTO `0_chart_master` VALUES ('218600', '', 'Emballages récupérables.', '2186', '0');
INSERT INTO `0_chart_master` VALUES ('220000', '', 'Immobilisations mises en concession.', '22', '0');
INSERT INTO `0_chart_master` VALUES ('230000', '', 'Immobilisations en cours.', '23', '0');
INSERT INTO `0_chart_master` VALUES ('231000', '', ' Immobilisations corporelles en cours.', '231', '0');
INSERT INTO `0_chart_master` VALUES ('231200', '', 'Terrains.', '2312', '0');
INSERT INTO `0_chart_master` VALUES ('231300', '', 'Constructions.', '2313', '0');
INSERT INTO `0_chart_master` VALUES ('231500', '', 'Installations techniques, matériel et outillage in', '2315', '0');
INSERT INTO `0_chart_master` VALUES ('231800', '', 'Autres immobilisations corporelles.', '2318', '0');
INSERT INTO `0_chart_master` VALUES ('232000', '', 'Immobilisations incorporelles en cours.', '232', '0');
INSERT INTO `0_chart_master` VALUES ('237000', '', 'Avances et acomptes versés sur immobilisations inc', '237', '0');
INSERT INTO `0_chart_master` VALUES ('238000', '', 'Avances et acomptes versés sur commandes d&#039;immobil', '238', '0');
INSERT INTO `0_chart_master` VALUES ('238200', '', 'Terrains.', '2382', '0');
INSERT INTO `0_chart_master` VALUES ('238300', '', 'Constructions.', '2383', '0');
INSERT INTO `0_chart_master` VALUES ('238500', '', 'Installations techniques, matériel et outillage in', '2385', '0');
INSERT INTO `0_chart_master` VALUES ('238800', '', 'Autres immobilisations corporelles.', '2388', '0');
INSERT INTO `0_chart_master` VALUES ('250000', '', 'Entreprises liées - Parts et créances.', '25', '0');
INSERT INTO `0_chart_master` VALUES ('260000', '', 'Participations et créances rattachées à des partic', '26', '0');
INSERT INTO `0_chart_master` VALUES ('261000', '', 'Titres de participation.', '261', '0');
INSERT INTO `0_chart_master` VALUES ('261100', '', 'Actions.', '2611', '0');
INSERT INTO `0_chart_master` VALUES ('261800', '', 'Autres titres.', '2618', '0');
INSERT INTO `0_chart_master` VALUES ('266000', '', 'Autres formes de participation.', '266', '0');
INSERT INTO `0_chart_master` VALUES ('267000', '', 'Créances rattachées à des participations.', '267', '0');
INSERT INTO `0_chart_master` VALUES ('267100', '', 'Créances rattachées à des participations (groupe).', '2671', '0');
INSERT INTO `0_chart_master` VALUES ('267400', '', 'Créances rattachées à des participations (hors gro', '2674', '0');
INSERT INTO `0_chart_master` VALUES ('267500', '', 'Versements représentatifs d&#039;apports non capitalisé', '2675', '0');
INSERT INTO `0_chart_master` VALUES ('267600', '', 'Avances consolidables.', '2676', '0');
INSERT INTO `0_chart_master` VALUES ('267700', '', 'Autres créances rattachées à des participations.', '2677', '0');
INSERT INTO `0_chart_master` VALUES ('267800', '', 'Intérêts courus.', '2678', '0');
INSERT INTO `0_chart_master` VALUES ('268000', '', 'Créances rattachées à des sociétés en participatio', '268', '0');
INSERT INTO `0_chart_master` VALUES ('268100', '', 'Principal.', '2681', '0');
INSERT INTO `0_chart_master` VALUES ('268800', '', 'Intérêts courus.', '2688', '0');
INSERT INTO `0_chart_master` VALUES ('269000', '', 'Versements restant à effectuer sur titres de parti', '269', '0');
INSERT INTO `0_chart_master` VALUES ('270000', '', 'Autres immobilisations financières.', '27', '0');
INSERT INTO `0_chart_master` VALUES ('271000', '', 'Titres immobilisés autres que les titres immobilis', '271', '0');
INSERT INTO `0_chart_master` VALUES ('271100', '', 'Actions.', '2711', '0');
INSERT INTO `0_chart_master` VALUES ('271800', '', 'Autres titres.', '2718', '0');
INSERT INTO `0_chart_master` VALUES ('272000', '', 'Titres immobilisés (droit de créance).', '272', '0');
INSERT INTO `0_chart_master` VALUES ('272100', '', 'Obligations.', '2721', '0');
INSERT INTO `0_chart_master` VALUES ('272200', '', 'Bons.', '2722', '0');
INSERT INTO `0_chart_master` VALUES ('273000', '', 'Titres immobilisés de l&#039;activité de portefeuille.', '273', '0');
INSERT INTO `0_chart_master` VALUES ('274000', '', 'Prêts.', '274', '0');
INSERT INTO `0_chart_master` VALUES ('274100', '', 'Prêts participatifs.', '2741', '0');
INSERT INTO `0_chart_master` VALUES ('274200', '', 'Prêts aux associés.', '2742', '0');
INSERT INTO `0_chart_master` VALUES ('274300', '', 'Prêts au personnel.', '2743', '0');
INSERT INTO `0_chart_master` VALUES ('274800', '', 'Autres prêts.', '2748', '0');
INSERT INTO `0_chart_master` VALUES ('275000', '', 'Dépôts et cautionnements versés.', '275', '0');
INSERT INTO `0_chart_master` VALUES ('275100', '', 'Dépôts.', '2751', '0');
INSERT INTO `0_chart_master` VALUES ('275500', '', 'Cautionnements.', '2755', '0');
INSERT INTO `0_chart_master` VALUES ('276000', '', 'Autres créances immobilisées.', '276', '0');
INSERT INTO `0_chart_master` VALUES ('276100', '', 'Créances diverses.', '2761', '0');
INSERT INTO `0_chart_master` VALUES ('276800', '', 'Intérêts courus.', '2768', '0');
INSERT INTO `0_chart_master` VALUES ('276820', '', 'Sur titres immobilisés (droit de créance).', '27682', '0');
INSERT INTO `0_chart_master` VALUES ('276840', '', 'Sur prêts.', '27684', '0');
INSERT INTO `0_chart_master` VALUES ('276850', '', 'Sur dépôts et cautionnements.', '27685', '0');
INSERT INTO `0_chart_master` VALUES ('276880', '', 'Sur créances diverses.', '27688', '0');
INSERT INTO `0_chart_master` VALUES ('277000', '', 'Actions propres ou parts propres.', '277', '0');
INSERT INTO `0_chart_master` VALUES ('277100', '', 'Actions propres ou parts propres.', '2771', '0');
INSERT INTO `0_chart_master` VALUES ('277200', '', 'Actions propres ou parts propres en voie d&#039;annulat', '2772', '0');
INSERT INTO `0_chart_master` VALUES ('279000', '', 'Versements restant à effectuer sur titres immobili', '279', '0');
INSERT INTO `0_chart_master` VALUES ('280000', '', 'Amortissements des immobilisations incorporelles.', '280', '0');
INSERT INTO `0_chart_master` VALUES ('280100', '', 'Frais d&#039;établissement (même ventilation que celle ', '2801', '0');
INSERT INTO `0_chart_master` VALUES ('280300', '', 'Frais de recherche et de développement.', '2803', '0');
INSERT INTO `0_chart_master` VALUES ('280500', '', 'Concessions et droits similaires, brevets, licence', '2805', '0');
INSERT INTO `0_chart_master` VALUES ('280700', '', 'Fonds commercial.', '2807', '0');
INSERT INTO `0_chart_master` VALUES ('280800', '', 'Autres immobilisations incorporelles.', '2808', '0');
INSERT INTO `0_chart_master` VALUES ('281000', '', 'Amortissements des immobilisations corporelles.', '281', '0');
INSERT INTO `0_chart_master` VALUES ('281100', '', 'Terrains de gisement.', '2811', '0');
INSERT INTO `0_chart_master` VALUES ('281200', '', 'Agencements, aménagements de terrains (même ventil', '2812', '0');
INSERT INTO `0_chart_master` VALUES ('281300', '', 'Constructions (même ventilation que celle du compt', '2813', '0');
INSERT INTO `0_chart_master` VALUES ('281400', '', 'Constructions sur sol d&#039;autrui (même ventilation q', '2814', '0');
INSERT INTO `0_chart_master` VALUES ('281500', '', 'Installations techniques, matériel et outillage in', '2815', '0');
INSERT INTO `0_chart_master` VALUES ('281800', '', 'Autres immobilisations corporelles (même ventilati', '2818', '0');
INSERT INTO `0_chart_master` VALUES ('282000', '', 'Amortissements des immobilisations mises en conces', '282', '0');
INSERT INTO `0_chart_master` VALUES ('290000', '', 'Provisions pour dépréciation des immobilisations i', '290', '0');
INSERT INTO `0_chart_master` VALUES ('290500', '', 'Marques, procédés, droits et valeurs similaires.', '2905', '0');
INSERT INTO `0_chart_master` VALUES ('290600', '', 'Droit au bail.', '2906', '0');
INSERT INTO `0_chart_master` VALUES ('290700', '', 'Fonds commercial.', '2907', '0');
INSERT INTO `0_chart_master` VALUES ('290800', '', 'Autres immobilisations incorporelles.', '2908', '0');
INSERT INTO `0_chart_master` VALUES ('291000', '', 'Dépréciations des immobilisations corporelles (mêm', '291', '0');
INSERT INTO `0_chart_master` VALUES ('291100', '', 'Terrains (autres que terrains de gisement).', '2911', '0');
INSERT INTO `0_chart_master` VALUES ('292000', '', 'Dépréciations des immobilisations mises en concess', '292', '0');
INSERT INTO `0_chart_master` VALUES ('293000', '', 'Dépréciations des immobilisations en cours.', '293', '0');
INSERT INTO `0_chart_master` VALUES ('293100', '', 'Immobilisations corporelles en cours.', '2931', '0');
INSERT INTO `0_chart_master` VALUES ('293200', '', 'Immobilisations incorporelles en cours.', '2932', '0');
INSERT INTO `0_chart_master` VALUES ('296000', '', 'Dépréciations des participations et créances ratta', '296', '0');
INSERT INTO `0_chart_master` VALUES ('296100', '', 'Titres de participation.', '2961', '0');
INSERT INTO `0_chart_master` VALUES ('296600', '', 'Autres formes de participation.', '2966', '0');
INSERT INTO `0_chart_master` VALUES ('296700', '', 'Créances rattachées à des participations (même ven', '2967', '0');
INSERT INTO `0_chart_master` VALUES ('296800', '', 'Créances rattachées à des sociétés en participatio', '2968', '0');
INSERT INTO `0_chart_master` VALUES ('297000', '', 'Dépréciations des autres immobilisations financièr', '297', '0');
INSERT INTO `0_chart_master` VALUES ('297100', '', 'Titres immobilisés autres que les titres immobilis', '2971', '0');
INSERT INTO `0_chart_master` VALUES ('297200', '', 'Titres immobilisés - droit de créance (même ventil', '2972', '0');
INSERT INTO `0_chart_master` VALUES ('297300', '', 'Titres immobilisés de l&#039;activité de portefeuille.', '2973', '0');
INSERT INTO `0_chart_master` VALUES ('297400', '', 'Prêts (même ventilation que celle du compte 274).', '2974', '0');
INSERT INTO `0_chart_master` VALUES ('297500', '', 'Dépôts et cautionnements versés (même ventilation ', '2975', '0');
INSERT INTO `0_chart_master` VALUES ('297600', '', 'Autres créances immobilisées (même ventilation que', '2976', '0');
INSERT INTO `0_chart_master` VALUES ('310000', '', 'Matières premières (et fournitures).', '31', '0');
INSERT INTO `0_chart_master` VALUES ('311000', '', 'Matière (ou groupe) A.', '311', '0');
INSERT INTO `0_chart_master` VALUES ('312000', '', 'Matière (ou groupe) B.', '312', '0');
INSERT INTO `0_chart_master` VALUES ('317000', '', 'Fournitures A, B, C...', '317', '0');
INSERT INTO `0_chart_master` VALUES ('320000', '', 'Autres approvisionnements.', '32', '0');
INSERT INTO `0_chart_master` VALUES ('321000', '', 'Matières consommables.', '321', '0');
INSERT INTO `0_chart_master` VALUES ('321100', '', 'Matière (ou groupe) C.', '3211', '0');
INSERT INTO `0_chart_master` VALUES ('321200', '', 'Matière (ou groupe) D.', '3212', '0');
INSERT INTO `0_chart_master` VALUES ('322000', '', 'Fournitures consommables.', '322', '0');
INSERT INTO `0_chart_master` VALUES ('322100', '', 'Combustibles.', '3221', '0');
INSERT INTO `0_chart_master` VALUES ('322200', '', 'Produits d&#039;entretien.', '3222', '0');
INSERT INTO `0_chart_master` VALUES ('322300', '', 'Fournitures d&#039;atelier et d&#039;usine.', '3223', '0');
INSERT INTO `0_chart_master` VALUES ('322400', '', 'Fournitures de magasin.', '3224', '0');
INSERT INTO `0_chart_master` VALUES ('322500', '', 'Fournitures de bureau.', '3225', '0');
INSERT INTO `0_chart_master` VALUES ('326000', '', 'Emballages.', '326', '0');
INSERT INTO `0_chart_master` VALUES ('326100', '', 'Emballages perdus.', '3261', '0');
INSERT INTO `0_chart_master` VALUES ('326500', '', 'Emballages récupérables non identifiables.', '3265', '0');
INSERT INTO `0_chart_master` VALUES ('326700', '', 'Emballages à usage mixte.', '3267', '0');
INSERT INTO `0_chart_master` VALUES ('330000', '', 'En-cours de production de biens.', '33', '0');
INSERT INTO `0_chart_master` VALUES ('331000', '', 'Produits en cours.', '331', '0');
INSERT INTO `0_chart_master` VALUES ('331100', '', 'Produits en cours P 1.', '3311', '0');
INSERT INTO `0_chart_master` VALUES ('331200', '', 'Produits en cours P 2.', '3312', '0');
INSERT INTO `0_chart_master` VALUES ('335000', '', 'Travaux en cours.', '335', '0');
INSERT INTO `0_chart_master` VALUES ('335100', '', 'Travaux en cours T 1.', '3351', '0');
INSERT INTO `0_chart_master` VALUES ('335200', '', 'Travaux en cours T 2.', '3352', '0');
INSERT INTO `0_chart_master` VALUES ('340000', '', 'En-cours de production de services.', '34', '0');
INSERT INTO `0_chart_master` VALUES ('341000', '', 'Etudes en cours.', '341', '0');
INSERT INTO `0_chart_master` VALUES ('341100', '', 'Etude en cours E 1.', '3411', '0');
INSERT INTO `0_chart_master` VALUES ('341200', '', 'Etude en cours E 2.', '3412', '0');
INSERT INTO `0_chart_master` VALUES ('345000', '', 'Prestations de services en cours.', '345', '0');
INSERT INTO `0_chart_master` VALUES ('345100', '', 'Prestation de services S 1.', '3451', '0');
INSERT INTO `0_chart_master` VALUES ('345200', '', 'Prestation de services S 2.', '3452', '0');
INSERT INTO `0_chart_master` VALUES ('350000', '', 'Stocks de produits.', '35', '0');
INSERT INTO `0_chart_master` VALUES ('351000', '', 'Produits intermédiaires.', '351', '0');
INSERT INTO `0_chart_master` VALUES ('351100', '', 'Produit intermédiaire (ou groupe) A.', '3511', '0');
INSERT INTO `0_chart_master` VALUES ('351200', '', 'Produit intermédiaire (ou groupe) B.', '3512', '0');
INSERT INTO `0_chart_master` VALUES ('355000', '', 'Produits finis.', '355', '0');
INSERT INTO `0_chart_master` VALUES ('355100', '', 'Produit fini (ou groupe) A.', '3551', '0');
INSERT INTO `0_chart_master` VALUES ('355200', '', 'Produit fini (ou groupe) B.', '3552', '0');
INSERT INTO `0_chart_master` VALUES ('358000', '', 'Produits résiduels (ou matières de récupération).', '358', '0');
INSERT INTO `0_chart_master` VALUES ('358100', '', 'Déchets.', '3581', '0');
INSERT INTO `0_chart_master` VALUES ('358500', '', 'Rebuts.', '3585', '0');
INSERT INTO `0_chart_master` VALUES ('358600', '', 'Matières de récupération.', '3586', '0');
INSERT INTO `0_chart_master` VALUES ('360000', '', 'Stocks provenant d&#039;immobilisations.', '36', '0');
INSERT INTO `0_chart_master` VALUES ('370000', '', 'Stocks de marchandises.', '37', '0');
INSERT INTO `0_chart_master` VALUES ('371000', '', 'Marchandise (ou groupe) A.', '371', '0');
INSERT INTO `0_chart_master` VALUES ('372000', '', 'Marchandise (ou groupe) B.', '372', '0');
INSERT INTO `0_chart_master` VALUES ('380000', '', 'Stocks en voie d&#039;acheminement, mis en dépôt ou don', '38', '0');
INSERT INTO `0_chart_master` VALUES ('390000', '', 'Dépréciations des stocks et en-cours.', '39', '0');
INSERT INTO `0_chart_master` VALUES ('391000', '', 'Dépréciations des matières premières (et fournitur', '391', '0');
INSERT INTO `0_chart_master` VALUES ('391100', '', 'Matière (ou groupe) A.', '3911', '0');
INSERT INTO `0_chart_master` VALUES ('391200', '', ' Matière (ou groupe) B.', '3912', '0');
INSERT INTO `0_chart_master` VALUES ('391700', '', 'Fourniture A, B, C...', '3917', '0');
INSERT INTO `0_chart_master` VALUES ('392000', '', 'Dépréciations des autres approvisionnements.', '392', '0');
INSERT INTO `0_chart_master` VALUES ('392100', '', 'Matières consommables (même ventilation que celle ', '3921', '0');
INSERT INTO `0_chart_master` VALUES ('392200', '', 'Fournitures consommables (même ventilation que cel', '3922', '0');
INSERT INTO `0_chart_master` VALUES ('392600', '', 'Emballages (même ventilation que celle du compte 3', '3926', '0');
INSERT INTO `0_chart_master` VALUES ('393000', '', 'Dépréciations des en-cours de production de biens.', '393', '0');
INSERT INTO `0_chart_master` VALUES ('393100', '', 'Produits en cours (même ventilation que celle du c', '3931', '0');
INSERT INTO `0_chart_master` VALUES ('393500', '', 'Travaux en cours (même ventilation que celle du co', '3935', '0');
INSERT INTO `0_chart_master` VALUES ('394000', '', 'Dépréciations des en-cours de production de servic', '394', '0');
INSERT INTO `0_chart_master` VALUES ('394100', '', 'Etudes en cours (même ventilation que celle du com', '3941', '0');
INSERT INTO `0_chart_master` VALUES ('394500', '', 'Prestations de services en cours (même ventilation', '3945', '0');
INSERT INTO `0_chart_master` VALUES ('395000', '', 'Dépréciations des stocks de produits.', '395', '0');
INSERT INTO `0_chart_master` VALUES ('395100', '', 'Produits intermédiaires (même ventilation que cell', '3951', '0');
INSERT INTO `0_chart_master` VALUES ('395500', '', 'Produits finis (même ventilation que celle du comp', '3955', '0');
INSERT INTO `0_chart_master` VALUES ('397000', '', 'Dépréciations des stocks de marchandises.', '397', '0');
INSERT INTO `0_chart_master` VALUES ('397100', '', 'Marchandise (ou groupe) A.', '3971', '0');
INSERT INTO `0_chart_master` VALUES ('397200', '', 'Marchandise (ou groupe) B.', '3972', '0');
INSERT INTO `0_chart_master` VALUES ('400000', '', 'Fournisseurs et comptes rattachés.', '40', '0');
INSERT INTO `0_chart_master` VALUES ('401000', '', 'Fournisseurs.', '401', '0');
INSERT INTO `0_chart_master` VALUES ('401100', '', 'Fournisseurs - Achats de biens ou de prestations d', '4011', '0');
INSERT INTO `0_chart_master` VALUES ('401700', '', 'Fournisseurs - Retenues de garantie.', '4017', '0');
INSERT INTO `0_chart_master` VALUES ('403000', '', 'Fournisseurs - Effets à payer.', '403', '0');
INSERT INTO `0_chart_master` VALUES ('404000', '', 'Fournisseurs d&#039;immobilisations.', '404', '0');
INSERT INTO `0_chart_master` VALUES ('404100', '', 'Fournisseurs - Achats d&#039;immobilisations.', '4041', '0');
INSERT INTO `0_chart_master` VALUES ('404700', '', 'Fournisseurs d&#039;immobilisations - Retenues de garan', '4047', '0');
INSERT INTO `0_chart_master` VALUES ('405000', '', 'Fournisseurs d&#039;immobilisations - Effets à payer.', '405', '0');
INSERT INTO `0_chart_master` VALUES ('408000', '', 'Fournisseurs - Factures non parvenues.', '408', '0');
INSERT INTO `0_chart_master` VALUES ('408100', '', 'Fournisseurs.', '4081', '0');
INSERT INTO `0_chart_master` VALUES ('408400', '', 'Fournisseurs d&#039;immobilisations.', '4084', '0');
INSERT INTO `0_chart_master` VALUES ('408800', '', 'Fournisseurs - Intérêts courus.', '4088', '0');
INSERT INTO `0_chart_master` VALUES ('409000', '', 'Fournisseurs débiteurs.', '409', '0');
INSERT INTO `0_chart_master` VALUES ('409100', '', 'Fournisseurs - Avances et acomptes versés sur comm', '4091', '0');
INSERT INTO `0_chart_master` VALUES ('409600', '', 'Fournisseurs - Créances pour emballages et matérie', '4096', '0');
INSERT INTO `0_chart_master` VALUES ('409700', '', 'Fournisseurs - Autres avoirs.', '4097', '0');
INSERT INTO `0_chart_master` VALUES ('409710', '', 'Fournisseurs d&#039;exploitation.', '40971', '0');
INSERT INTO `0_chart_master` VALUES ('409740', '', 'Fournisseurs d&#039;immobilisation.', '40974', '0');
INSERT INTO `0_chart_master` VALUES ('409800', '', 'Rabais, remises, ristournes à obtenir et autres av', '4098', '0');
INSERT INTO `0_chart_master` VALUES ('410000', '', 'Clients et comptes rattachés.', '41', '0');
INSERT INTO `0_chart_master` VALUES ('411000', '', 'Clients et comptes rattachés.', '410', '0');
INSERT INTO `0_chart_master` VALUES ('411100', '', 'Clients.', '411', '0');
INSERT INTO `0_chart_master` VALUES ('411700', '', 'Clients - Ventes de biens ou de prestations de ser', '4111', '0');
INSERT INTO `0_chart_master` VALUES ('413000', '', 'Clients - Retenues de garantie.', '4117', '0');
INSERT INTO `0_chart_master` VALUES ('416000', '', 'Clients - Effets à recevoir.', '413', '0');
INSERT INTO `0_chart_master` VALUES ('417000', '', 'Clients douteux ou litigieux.', '416', '0');
INSERT INTO `0_chart_master` VALUES ('418000', '', 'Clients - Produits non encore facturés.', '418', '0');
INSERT INTO `0_chart_master` VALUES ('418100', '', 'Clients - Factures à établir.', '4181', '0');
INSERT INTO `0_chart_master` VALUES ('418800', '', 'Clients - Intérêts courus.', '4188', '0');
INSERT INTO `0_chart_master` VALUES ('419000', '', 'Clients créditeurs.', '419', '0');
INSERT INTO `0_chart_master` VALUES ('419100', '', 'Clients - Avances et acomptes reçus sur commandes.', '4191', '0');
INSERT INTO `0_chart_master` VALUES ('419600', '', 'Clients - Dettes pour emballages et matériel consi', '4196', '0');
INSERT INTO `0_chart_master` VALUES ('419700', '', 'Clients - Autres avoirs.', '4197', '0');
INSERT INTO `0_chart_master` VALUES ('419800', '', 'Rabais, remises, ristournes à accorder et autres a', '4198', '0');
INSERT INTO `0_chart_master` VALUES ('420000', '', 'Personnel et comptes rattachés.', '42', '0');
INSERT INTO `0_chart_master` VALUES ('421000', '', 'Personnel - Rémunérations dues.', '421', '0');
INSERT INTO `0_chart_master` VALUES ('422000', '', 'Comités d&#039;entreprise, d&#039;établissement...', '422', '0');
INSERT INTO `0_chart_master` VALUES ('424000', '', 'Participation des salariés aux résultats.', '424', '0');
INSERT INTO `0_chart_master` VALUES ('424600', '', 'Réserve spéciale (C. tr. art. L 442-2).', '4246', '0');
INSERT INTO `0_chart_master` VALUES ('424800', '', 'Comptes courants.', '4248', '0');
INSERT INTO `0_chart_master` VALUES ('425000', '', 'Personnel - Avances et acomptes.', '425', '0');
INSERT INTO `0_chart_master` VALUES ('426000', '', 'Personnel - Dépôts.', '426', '0');
INSERT INTO `0_chart_master` VALUES ('427000', '', 'Personnel - Opposition.', '427', '0');
INSERT INTO `0_chart_master` VALUES ('428000', '', 'Personnel - Charges à payer et produits à recevoir', '428', '0');
INSERT INTO `0_chart_master` VALUES ('428200', '', 'Dettes provisionnées pour congés à payer.', '4282', '0');
INSERT INTO `0_chart_master` VALUES ('428400', '', 'Dettes provisionnées pour participation des salari', '4284', '0');
INSERT INTO `0_chart_master` VALUES ('428600', '', 'Autres charges à payer.', '4286', '0');
INSERT INTO `0_chart_master` VALUES ('428700', '', 'Produits à recevoir.', '4287', '0');
INSERT INTO `0_chart_master` VALUES ('430000', '', 'Sécurité sociale et autres organismes sociaux.', '43', '0');
INSERT INTO `0_chart_master` VALUES ('431000', '', 'Sécurité sociale.', '431', '0');
INSERT INTO `0_chart_master` VALUES ('437000', '', 'Autres organismes sociaux.', '437', '0');
INSERT INTO `0_chart_master` VALUES ('438000', '', 'Organismes sociaux - Charges à payer et produits à', '438', '0');
INSERT INTO `0_chart_master` VALUES ('438200', '', 'Charges sociales sur congés à payer.', '4382', '0');
INSERT INTO `0_chart_master` VALUES ('438600', '', 'Autres charges à payer.', '4386', '0');
INSERT INTO `0_chart_master` VALUES ('438700', '', 'Produits à recevoir.', '4387', '0');
INSERT INTO `0_chart_master` VALUES ('440000', '', 'Etat et autres collectivités publiques.', '44', '0');
INSERT INTO `0_chart_master` VALUES ('441000', '', 'Etat - Subventions à recevoir.', '441', '0');
INSERT INTO `0_chart_master` VALUES ('441100', '', 'Subventions d&#039;investissement.', '4411', '0');
INSERT INTO `0_chart_master` VALUES ('441700', '', 'Subventions d&#039;exploitation.', '4417', '0');
INSERT INTO `0_chart_master` VALUES ('441800', '', 'Subventions d&#039;équilibre.', '4418', '0');
INSERT INTO `0_chart_master` VALUES ('441900', '', 'Avances sur subventions.', '4419', '0');
INSERT INTO `0_chart_master` VALUES ('442000', '', 'Etat - Impôts recouvrables sur des tiers.', '442', '0');
INSERT INTO `0_chart_master` VALUES ('442400', '', 'Obligataires.', '4424', '0');
INSERT INTO `0_chart_master` VALUES ('442500', '', 'Associés.', '4425', '0');
INSERT INTO `0_chart_master` VALUES ('443000', '', 'Opérations particulières avec l&#039;Etat, les collecti', '443', '0');
INSERT INTO `0_chart_master` VALUES ('443100', '', 'Créance sur l&#039;Etat résultant de la suppression de ', '4431', '0');
INSERT INTO `0_chart_master` VALUES ('443800', '', 'Intérêts courus sur créance figurant au compte 443', '4438', '0');
INSERT INTO `0_chart_master` VALUES ('444000', '', 'Etat - Impôts sur les bénéfices.', '444', '0');
INSERT INTO `0_chart_master` VALUES ('445000', '', 'Etat - Taxes sur le chiffre d&#039;affaires.', '445', '0');
INSERT INTO `0_chart_master` VALUES ('445200', '', 'TVA due intracommunautaire.', '4452', '0');
INSERT INTO `0_chart_master` VALUES ('445500', '', 'Taxes sur le chiffre d&#039;affaires à décaisser.', '4455', '0');
INSERT INTO `0_chart_master` VALUES ('445510', '', 'TVA à décaisser.', '44551', '0');
INSERT INTO `0_chart_master` VALUES ('445580', '', 'Taxes assimilées à la TVA.', '44558', '0');
INSERT INTO `0_chart_master` VALUES ('445600', '', 'Taxes sur le chiffre d&#039;affaires déductibles.', '4456', '0');
INSERT INTO `0_chart_master` VALUES ('445620', '', 'TVA sur immobilisations.', '44562', '0');
INSERT INTO `0_chart_master` VALUES ('445630', '', 'TVA transférée sur d&#039;autres entreprises.', '44563', '0');
INSERT INTO `0_chart_master` VALUES ('445660', '', 'TVA sur autres biens et services.', '44566', '0');
INSERT INTO `0_chart_master` VALUES ('445670', '', 'Crédit de TVA à reporter.', '44567', '0');
INSERT INTO `0_chart_master` VALUES ('445680', '', 'Taxes assimilées à la TVA.', '44568', '0');
INSERT INTO `0_chart_master` VALUES ('445700', '', 'Taxes sur le chiffre d&#039;affaires collectées par l&#039;e', '4457', '0');
INSERT INTO `0_chart_master` VALUES ('445710', '', 'TVA collectée.', '44571', '0');
INSERT INTO `0_chart_master` VALUES ('445780', '', 'Taxes assimilées à la TVA.', '44578', '0');
INSERT INTO `0_chart_master` VALUES ('445800', '', 'Taxes sur le chiffre d&#039;affaires à régulariser ou e', '4458', '0');
INSERT INTO `0_chart_master` VALUES ('445810', '', 'Acomptes - Régime simplifié d&#039;imposition.', '44581', '0');
INSERT INTO `0_chart_master` VALUES ('445820', '', 'Acomptes - Régime de forfait.', '44582', '0');
INSERT INTO `0_chart_master` VALUES ('445830', '', 'Remboursement de taxes sur le chiffre d&#039;affaires d', '44583', '0');
INSERT INTO `0_chart_master` VALUES ('445840', '', 'TVA récupérée d&#039;avance.', '44584', '0');
INSERT INTO `0_chart_master` VALUES ('445860', '', 'Taxes sur le chiffre d&#039;affaires sur factures non p', '44586', '0');
INSERT INTO `0_chart_master` VALUES ('445870', '', 'Taxes sur le chiffre d&#039;affaires sur factures à éta', '44587', '0');
INSERT INTO `0_chart_master` VALUES ('446000', '', 'Obligations cautionnées.', '446', '0');
INSERT INTO `0_chart_master` VALUES ('447000', '', 'Obligations cautionnées.', '4461', '0');
INSERT INTO `0_chart_master` VALUES ('448000', '', 'Autres impôts, taxes et versements assimilés.', '447', '0');
INSERT INTO `0_chart_master` VALUES ('448200', '', 'Etat - Charges à payer et produits à recevoir.', '448', '0');
INSERT INTO `0_chart_master` VALUES ('448600', '', 'Charges fiscales sur congés à payer.', '4482', '0');
INSERT INTO `0_chart_master` VALUES ('448700', '', 'Charges à payer.', '4486', '0');
INSERT INTO `0_chart_master` VALUES ('450000', '', 'Produits à recevoir.', '4487', '0');
INSERT INTO `0_chart_master` VALUES ('451000', '', 'Quotas d&#039;émission à restituer à l&#039;Etat.', '449', '0');
INSERT INTO `0_chart_master` VALUES ('455000', '', 'Groupe et associés.', '45', '0');
INSERT INTO `0_chart_master` VALUES ('455100', '', 'Groupe.', '451', '0');
INSERT INTO `0_chart_master` VALUES ('455800', '', 'Associés - Comptes courants.', '455', '0');
INSERT INTO `0_chart_master` VALUES ('456000', '', 'Principal.', '4551', '0');
INSERT INTO `0_chart_master` VALUES ('456100', '', 'Intérêts courus.', '4558', '0');
INSERT INTO `0_chart_master` VALUES ('456110', '', 'Associés - Opérations sur le capital.', '456', '0');
INSERT INTO `0_chart_master` VALUES ('456150', '', 'Apports en nature.', '45611', '0');
INSERT INTO `0_chart_master` VALUES ('456200', '', 'Apports en numéraire.', '45615', '0');
INSERT INTO `0_chart_master` VALUES ('456210', '', 'Apporteurs - Capital appelé, non versé.', '4562', '0');
INSERT INTO `0_chart_master` VALUES ('456250', '', 'Actionnaires - Capital souscrit et appelé, non ver', '45621', '0');
INSERT INTO `0_chart_master` VALUES ('456300', '', 'Associés - Capital appelé, non versé.', '45625', '0');
INSERT INTO `0_chart_master` VALUES ('456400', '', 'Associés - Versements reçus sur augmentation de ca', '4563', '0');
INSERT INTO `0_chart_master` VALUES ('456600', '', 'Associés - Versements anticipés.', '4564', '0');
INSERT INTO `0_chart_master` VALUES ('456700', '', 'Actionnaires défaillants.', '4566', '0');
INSERT INTO `0_chart_master` VALUES ('457000', '', 'Associés - Capital à rembourser.', '4567', '0');
INSERT INTO `0_chart_master` VALUES ('458000', '', 'Associés - Dividendes à payer.', '457', '0');
INSERT INTO `0_chart_master` VALUES ('458100', '', 'Associés - Opérations faites en commun et en GIE.', '458', '0');
INSERT INTO `0_chart_master` VALUES ('458800', '', 'Opérations courantes.', '4581', '0');
INSERT INTO `0_chart_master` VALUES ('460000', '', 'Intérêts courus.', '4588', '0');
INSERT INTO `0_chart_master` VALUES ('462000', '', 'Débiteurs divers et créditeurs divers.', '46', '0');
INSERT INTO `0_chart_master` VALUES ('464000', '', 'Créances sur cessions d&#039;immobilisations.', '462', '0');
INSERT INTO `0_chart_master` VALUES ('465000', '', 'Dettes sur acquisition de valeurs mobilières de pl', '464', '0');
INSERT INTO `0_chart_master` VALUES ('467000', '', 'Créances sur cessions de valeurs mobilières de pla', '465', '0');
INSERT INTO `0_chart_master` VALUES ('468000', '', 'Autres comptes débiteurs ou créditeurs.', '467', '0');
INSERT INTO `0_chart_master` VALUES ('468600', '', 'Divers - Charges à payer et produits à recevoir.', '468', '0');
INSERT INTO `0_chart_master` VALUES ('468700', '', 'Charges à payer.', '4686', '0');
INSERT INTO `0_chart_master` VALUES ('470000', '', 'Produits à recevoir.', '4687', '0');
INSERT INTO `0_chart_master` VALUES ('471000', '', 'Comptes transitoires ou d&#039;attente.', '47', '0');
INSERT INTO `0_chart_master` VALUES ('476000', '', 'Différences de conversion - Actif.', '476', '0');
INSERT INTO `0_chart_master` VALUES ('476100', '', 'Diminution des créances.', '4761', '0');
INSERT INTO `0_chart_master` VALUES ('476200', '', 'Augmentation des dettes.', '4762', '0');
INSERT INTO `0_chart_master` VALUES ('476800', '', 'Différences compensées par couverture de change.', '4768', '0');
INSERT INTO `0_chart_master` VALUES ('477000', '', 'Différences de conversion - Passif.', '477', '0');
INSERT INTO `0_chart_master` VALUES ('477100', '', 'Augmentation des créances.', '4771', '0');
INSERT INTO `0_chart_master` VALUES ('477200', '', 'Diminution des dettes.', '4772', '0');
INSERT INTO `0_chart_master` VALUES ('477800', '', 'Différences compensées par couverture de change.', '4778', '0');
INSERT INTO `0_chart_master` VALUES ('478000', '', 'Autres comptes transitoires.', '478', '0');
INSERT INTO `0_chart_master` VALUES ('480000', '', 'Comptes de régularisation.', '48', '0');
INSERT INTO `0_chart_master` VALUES ('481000', '', 'Charges à répartir sur plusieurs exercices.', '481', '0');
INSERT INTO `0_chart_master` VALUES ('481600', '', 'Frais d&#039;émission des emprunts.', '4816', '0');
INSERT INTO `0_chart_master` VALUES ('486000', '', 'Charges constatées d&#039;avance.', '486', '0');
INSERT INTO `0_chart_master` VALUES ('487000', '', 'Produits constatés d&#039;avance.', '487', '0');
INSERT INTO `0_chart_master` VALUES ('488000', '', 'Comptes de répartition périodique des charges et d', '488', '0');
INSERT INTO `0_chart_master` VALUES ('488600', '', 'Charges.', '4886', '0');
INSERT INTO `0_chart_master` VALUES ('488700', '', 'Produits.', '4887', '0');
INSERT INTO `0_chart_master` VALUES ('489000', '', 'Quotas d&#039;émission alloués par l&#039;Etat.', '489', '0');
INSERT INTO `0_chart_master` VALUES ('490000', '', 'Dépréciations des comptes de tiers.', '49', '0');
INSERT INTO `0_chart_master` VALUES ('491000', '', 'Dépréciations des comptes de clients.', '491', '0');
INSERT INTO `0_chart_master` VALUES ('495000', '', 'Dépréciations des comptes du groupe et des associé', '495', '0');
INSERT INTO `0_chart_master` VALUES ('495100', '', 'Comptes du groupe.', '4951', '0');
INSERT INTO `0_chart_master` VALUES ('495500', '', 'Comptes courants des associés.', '4955', '0');
INSERT INTO `0_chart_master` VALUES ('495800', '', 'Opérations faites en commun et en GIE.', '4958', '0');
INSERT INTO `0_chart_master` VALUES ('496000', '', 'Dépréciations des comptes de débiteurs divers.', '496', '0');
INSERT INTO `0_chart_master` VALUES ('496200', '', 'Créances sur cessions d&#039;immobilisations.', '4962', '0');
INSERT INTO `0_chart_master` VALUES ('496500', '', 'Créances sur cessions de valeurs mobilières de pla', '4965', '0');
INSERT INTO `0_chart_master` VALUES ('496700', '', 'Autres comptes débiteurs.', '4967', '0');
INSERT INTO `0_chart_master` VALUES ('500000', '', 'Valeurs mobilières de placement.', '50', '0');
INSERT INTO `0_chart_master` VALUES ('501000', '', 'Parts dans des entreprises liées.', '501', '0');
INSERT INTO `0_chart_master` VALUES ('502000', '', 'Actions propres.', '502', '0');
INSERT INTO `0_chart_master` VALUES ('503000', '', 'Actions.', '503', '0');
INSERT INTO `0_chart_master` VALUES ('503100', '', 'Titres cotés.', '5031', '0');
INSERT INTO `0_chart_master` VALUES ('503500', '', 'Titres non cotés.', '5035', '0');
INSERT INTO `0_chart_master` VALUES ('504000', '', 'Autres titres conférant un droit de propriété.', '504', '0');
INSERT INTO `0_chart_master` VALUES ('505000', '', 'Obligations et bons émis par la société et racheté', '505', '0');
INSERT INTO `0_chart_master` VALUES ('506000', '', 'Obligations.', '506', '0');
INSERT INTO `0_chart_master` VALUES ('506100', '', 'Titres cotés.', '5061', '0');
INSERT INTO `0_chart_master` VALUES ('506500', '', 'Titres non cotés.', '5065', '0');
INSERT INTO `0_chart_master` VALUES ('507000', '', 'Bons du Trésor et bons de caisse à court terme.', '507', '0');
INSERT INTO `0_chart_master` VALUES ('508000', '', 'Autres valeurs mobilières de placement et autres c', '508', '0');
INSERT INTO `0_chart_master` VALUES ('508100', '', 'Autres valeurs mobilières.', '5081', '0');
INSERT INTO `0_chart_master` VALUES ('508200', '', 'Bons de souscription.', '5082', '0');
INSERT INTO `0_chart_master` VALUES ('508800', '', 'Intérêts courus sur obligations, bons et valeurs assimilées', '5088', '0');
INSERT INTO `0_chart_master` VALUES ('509000', '', 'Versements restant à effectuer sur valeurs mobiliè', '509', '0');
INSERT INTO `0_chart_master` VALUES ('510000', '', 'Banques, établissements financiers et assimilés.', '51', '0');
INSERT INTO `0_chart_master` VALUES ('511000', '', 'Valeurs à l&#039;encaissement.', '511', '0');
INSERT INTO `0_chart_master` VALUES ('511100', '', 'Coupons échus à l&#039;encaissement.', '5111', '0');
INSERT INTO `0_chart_master` VALUES ('511200', '', 'Chèques à encaisser.', '5112', '0');
INSERT INTO `0_chart_master` VALUES ('511300', '', 'Effets à l&#039;encaissement.', '5113', '0');
INSERT INTO `0_chart_master` VALUES ('511400', '', 'Effets à l&#039;escompte.', '5114', '0');
INSERT INTO `0_chart_master` VALUES ('512000', '', 'Banques.', '512', '0');
INSERT INTO `0_chart_master` VALUES ('512100', '', 'Comptes en monnaie nationale.', '5121', '0');
INSERT INTO `0_chart_master` VALUES ('512400', '', 'Comptes en devises.', '5124', '0');
INSERT INTO `0_chart_master` VALUES ('514000', '', 'Chèques postaux.', '514', '0');
INSERT INTO `0_chart_master` VALUES ('515000', '', 'Caisses du Trésor et des établissements public', '515', '0');
INSERT INTO `0_chart_master` VALUES ('516000', '', 'Sociétés de bourse.', '516', '0');
INSERT INTO `0_chart_master` VALUES ('517000', '', 'Autres organismes financiers.', '517', '0');
INSERT INTO `0_chart_master` VALUES ('518000', '', 'Intérêts courus.', '518', '0');
INSERT INTO `0_chart_master` VALUES ('518100', '', 'Intérêts courus à payer.', '5181', '0');
INSERT INTO `0_chart_master` VALUES ('518800', '', 'Intérêts courus à recevoir.', '5188', '0');
INSERT INTO `0_chart_master` VALUES ('519000', '', 'Concours bancaires courants.', '519', '0');
INSERT INTO `0_chart_master` VALUES ('519100', '', 'Crédit de mobilisation de créances commerciales (C', '5191', '0');
INSERT INTO `0_chart_master` VALUES ('519300', '', 'Mobilisations de créances nées à l&#039;étranger.', '5193', '0');
INSERT INTO `0_chart_master` VALUES ('519800', '', 'Intérêts courus sur concours bancaires courants', '5198', '0');
INSERT INTO `0_chart_master` VALUES ('520000', '', 'Instruments de trésorerie.', '52', '0');
INSERT INTO `0_chart_master` VALUES ('530000', '', 'Caisse.', '53', '0');
INSERT INTO `0_chart_master` VALUES ('531000', '', 'Caisse siège social.', '531', '0');
INSERT INTO `0_chart_master` VALUES ('531100', '', 'Caisse en monnaie nationale.', '5311', '0');
INSERT INTO `0_chart_master` VALUES ('531400', '', 'Caisse en devises.', '5314', '0');
INSERT INTO `0_chart_master` VALUES ('532000', '', 'Caisse succursale (ou usine) A.', '532', '0');
INSERT INTO `0_chart_master` VALUES ('533000', '', 'Caisse succursale (ou usine) B.', '533', '0');
INSERT INTO `0_chart_master` VALUES ('540000', '', 'Régies d&#039;avances et accréditifs.', '54', '0');
INSERT INTO `0_chart_master` VALUES ('580000', '', 'Virements internes.', '58', '0');
INSERT INTO `0_chart_master` VALUES ('590000', '', 'Dépréciations des valeurs mobilières de placement.', '590', '0');
INSERT INTO `0_chart_master` VALUES ('590300', '', 'Actions.', '5903', '0');
INSERT INTO `0_chart_master` VALUES ('590400', '', 'Autres titres conférant un droit de propriété.', '5904', '0');
INSERT INTO `0_chart_master` VALUES ('590600', '', 'Obligations.', '5906', '0');
INSERT INTO `0_chart_master` VALUES ('590800', '', 'Autres valeurs mobilières de placement et créances', '5908', '0');
INSERT INTO `0_chart_master` VALUES ('600000', '', 'Achats (sauf 603)', '60', '0');
INSERT INTO `0_chart_master` VALUES ('601000', '', 'Achats stockés - Matières premières (et fourniture', '601', '0');
INSERT INTO `0_chart_master` VALUES ('601100', '', 'Matière (ou groupe) A.', '6011', '0');
INSERT INTO `0_chart_master` VALUES ('601200', '', 'Matière (ou groupe) B.', '6012', '0');
INSERT INTO `0_chart_master` VALUES ('601700', '', 'Fournitures A, B, C...', '6017', '0');
INSERT INTO `0_chart_master` VALUES ('602000', '', 'Achats stockés - Autres approvisionnements.', '602', '0');
INSERT INTO `0_chart_master` VALUES ('602100', '', 'Matières consommables.', '6021', '0');
INSERT INTO `0_chart_master` VALUES ('602110', '', 'Matière (ou groupe) C.', '60211', '0');
INSERT INTO `0_chart_master` VALUES ('602120', '', 'Matière (ou groupe) D.', '60212', '0');
INSERT INTO `0_chart_master` VALUES ('602200', '', 'Fournitures consommables.', '6022', '0');
INSERT INTO `0_chart_master` VALUES ('602210', '', 'Combustibles.', '60221', '0');
INSERT INTO `0_chart_master` VALUES ('602220', '', 'Produits d&#039;entretien.', '60222', '0');
INSERT INTO `0_chart_master` VALUES ('602230', '', 'Fournitures d&#039;atelier et d&#039;usine.', '60223', '0');
INSERT INTO `0_chart_master` VALUES ('602240', '', 'Fournitures de magasin.', '60224', '0');
INSERT INTO `0_chart_master` VALUES ('602250', '', 'Fournitures de bureau.', '60225', '0');
INSERT INTO `0_chart_master` VALUES ('602600', '', 'Emballages.', '6026', '0');
INSERT INTO `0_chart_master` VALUES ('602610', '', 'Emballages perdus.', '60261', '0');
INSERT INTO `0_chart_master` VALUES ('602650', '', 'Emballages récupérables non identifiables.', '60265', '0');
INSERT INTO `0_chart_master` VALUES ('602670', '', 'Emballages à usage mixte.', '60267', '0');
INSERT INTO `0_chart_master` VALUES ('603000', '', 'Variation des stocks (approvisionnements et marcha', '603', '0');
INSERT INTO `0_chart_master` VALUES ('603100', '', 'Variation des stocks de matières premières (et fou', '6031', '0');
INSERT INTO `0_chart_master` VALUES ('603200', '', 'Variation des stocks des autres approvisionnements', '6032', '0');
INSERT INTO `0_chart_master` VALUES ('603700', '', 'Variation des stocks de marchandises.', '6037', '0');
INSERT INTO `0_chart_master` VALUES ('604000', '', 'Achats d&#039;études et prestations de services.', '604', '0');
INSERT INTO `0_chart_master` VALUES ('605000', '', 'Achats de matériel, équipements et travaux.', '605', '0');
INSERT INTO `0_chart_master` VALUES ('606000', '', 'Achats non stockés de matières et fournitures.', '606', '0');
INSERT INTO `0_chart_master` VALUES ('606100', '', 'Fournitures non stockables (eau, énergie...).', '6061', '0');
INSERT INTO `0_chart_master` VALUES ('606300', '', 'Fournitures d&#039;entretien et de petit équipement.', '6063', '0');
INSERT INTO `0_chart_master` VALUES ('606400', '', 'Fournitures administratives.', '6064', '0');
INSERT INTO `0_chart_master` VALUES ('606800', '', 'Autres matières et fournitures.', '6068', '0');
INSERT INTO `0_chart_master` VALUES ('607000', '', 'Achats de marchandises.', '607', '0');
INSERT INTO `0_chart_master` VALUES ('607100', '', 'Marchandise (ou groupe) A.', '6071', '0');
INSERT INTO `0_chart_master` VALUES ('607200', '', 'Marchandise (ou groupe) B.', '6072', '0');
INSERT INTO `0_chart_master` VALUES ('608000', '', 'Frais accessoires d&#039;achat.', '608', '0');
INSERT INTO `0_chart_master` VALUES ('609000', '', 'Rabais, remises et ristournes obtenus sur achats.', '609', '0');
INSERT INTO `0_chart_master` VALUES ('609100', '', 'Rabais, remises et ristournes obtenus sur achats de matières', '6091', '0');
INSERT INTO `0_chart_master` VALUES ('609200', '', 'Rabais, remises et ristournes obtenus sur achats d&#039;autres ap', '6092', '0');
INSERT INTO `0_chart_master` VALUES ('609400', '', 'Rabais, remises et ristournes obtenus sur achats d&#039;études et', '6094', '0');
INSERT INTO `0_chart_master` VALUES ('609500', '', 'Rabais, remises et ristournes obtenus sur achats de matériel', '6095', '0');
INSERT INTO `0_chart_master` VALUES ('609600', '', 'Rabais, remises et ristournes obtenus sur achats d&#039;approvisi', '6096', '0');
INSERT INTO `0_chart_master` VALUES ('609700', '', 'Rabais, remises et ristournes obtenus sur achats de marchand', '6097', '0');
INSERT INTO `0_chart_master` VALUES ('609800', '', 'Rabais, remises et ristournes non affectés.', '6098', '0');
INSERT INTO `0_chart_master` VALUES ('610000', '', 'Services extérieurs.', '61', '0');
INSERT INTO `0_chart_master` VALUES ('611000', '', 'Sous-traitance générale.', '611', '0');
INSERT INTO `0_chart_master` VALUES ('612000', '', 'Redevances de crédit-bail.', '612', '0');
INSERT INTO `0_chart_master` VALUES ('612200', '', 'Crédit-bail mobilier.', '6122', '0');
INSERT INTO `0_chart_master` VALUES ('612500', '', 'Crédit-bail immobilier.', '6125', '0');
INSERT INTO `0_chart_master` VALUES ('613000', '', 'Locations.', '613', '0');
INSERT INTO `0_chart_master` VALUES ('613200', '', 'Locations immobilières.', '6132', '0');
INSERT INTO `0_chart_master` VALUES ('613500', '', 'Locations mobilières.', '6135', '0');
INSERT INTO `0_chart_master` VALUES ('613600', '', 'Malis sur emballages.', '6136', '0');
INSERT INTO `0_chart_master` VALUES ('614000', '', 'Charges locatives et de copropriété.', '614', '0');
INSERT INTO `0_chart_master` VALUES ('615000', '', 'Entretien et réparations.', '615', '0');
INSERT INTO `0_chart_master` VALUES ('615200', '', 'Entretien et réparations sur biens immobiliers.', '6152', '0');
INSERT INTO `0_chart_master` VALUES ('615500', '', 'Entretien et réparations sur biens mobiliers.', '6155', '0');
INSERT INTO `0_chart_master` VALUES ('615600', '', 'Maintenance.', '6156', '0');
INSERT INTO `0_chart_master` VALUES ('616000', '', 'Primes d&#039;assurance.', '616', '0');
INSERT INTO `0_chart_master` VALUES ('616100', '', 'Multirisques.', '6161', '0');
INSERT INTO `0_chart_master` VALUES ('616200', '', 'Assurance obligatoire dommage-construction.', '6162', '0');
INSERT INTO `0_chart_master` VALUES ('616300', '', 'Assurance transport.', '6163', '0');
INSERT INTO `0_chart_master` VALUES ('616360', '', 'Assurance transport sur achats.', '61636', '0');
INSERT INTO `0_chart_master` VALUES ('616370', '', 'Assurance transport sur ventes.', '61637', '0');
INSERT INTO `0_chart_master` VALUES ('616380', '', 'Assurance transport sur autres biens.', '61638', '0');
INSERT INTO `0_chart_master` VALUES ('616400', '', 'Risques d&#039;exploitation.', '6164', '0');
INSERT INTO `0_chart_master` VALUES ('616500', '', 'Insolvabilité clients.', '6165', '0');
INSERT INTO `0_chart_master` VALUES ('617000', '', 'Etudes et recherches.', '617', '0');
INSERT INTO `0_chart_master` VALUES ('618000', '', 'Divers.', '618', '0');
INSERT INTO `0_chart_master` VALUES ('618100', '', 'Documentation générale.', '6181', '0');
INSERT INTO `0_chart_master` VALUES ('618300', '', 'Documentation technique.', '6183', '0');
INSERT INTO `0_chart_master` VALUES ('618500', '', 'Frais de colloques, séminaires, conférences, formations.', '6185', '0');
INSERT INTO `0_chart_master` VALUES ('619000', '', 'Rabais, remises et ristournes obtenus sur services', '619', '0');
INSERT INTO `0_chart_master` VALUES ('620000', '', 'Autres services extérieurs.', '62', '0');
INSERT INTO `0_chart_master` VALUES ('621000', '', 'Personnel extérieur à l&#039;entreprise.', '621', '0');
INSERT INTO `0_chart_master` VALUES ('621100', '', 'Personnel intérimaire.', '6211', '0');
INSERT INTO `0_chart_master` VALUES ('621400', '', 'Personnel détaché ou prêté à l&#039;entreprise.', '6214', '0');
INSERT INTO `0_chart_master` VALUES ('622000', '', 'Rémunérations d&#039;intermédiaires et honoraires.', '622', '0');
INSERT INTO `0_chart_master` VALUES ('622100', '', 'Commissions et courtages sur achats.', '6221', '0');
INSERT INTO `0_chart_master` VALUES ('622200', '', 'Commissions et courtages sur ventes.', '6222', '0');
INSERT INTO `0_chart_master` VALUES ('622400', '', 'Rémunérations des transitaires.', '6224', '0');
INSERT INTO `0_chart_master` VALUES ('622500', '', 'Rémunérations d&#039;affacturage.', '6225', '0');
INSERT INTO `0_chart_master` VALUES ('622600', '', 'Honoraires.', '6226', '0');
INSERT INTO `0_chart_master` VALUES ('622700', '', 'Frais d&#039;actes et de contentieux.', '6227', '0');
INSERT INTO `0_chart_master` VALUES ('622800', '', 'Divers.', '6228', '0');
INSERT INTO `0_chart_master` VALUES ('623000', '', 'Publicité, publications, relations publiques.', '623', '0');
INSERT INTO `0_chart_master` VALUES ('623100', '', 'Annonces et insertions.', '6231', '0');
INSERT INTO `0_chart_master` VALUES ('623200', '', 'Echantillons.', '6232', '0');
INSERT INTO `0_chart_master` VALUES ('623300', '', 'Foires et expositions.', '6233', '0');
INSERT INTO `0_chart_master` VALUES ('623400', '', 'Cadeaux à la clientèle.', '6234', '0');
INSERT INTO `0_chart_master` VALUES ('623500', '', 'Primes.', '6235', '0');
INSERT INTO `0_chart_master` VALUES ('623600', '', 'Catalogues et imprimés.', '6236', '0');
INSERT INTO `0_chart_master` VALUES ('623700', '', 'Publications.', '6237', '0');
INSERT INTO `0_chart_master` VALUES ('623800', '', 'Divers (pourboires, dons courants...).', '6238', '0');
INSERT INTO `0_chart_master` VALUES ('624000', '', 'Transports de biens et transports collectifs du pe', '624', '0');
INSERT INTO `0_chart_master` VALUES ('624100', '', 'Transports sur achats.', '6241', '0');
INSERT INTO `0_chart_master` VALUES ('624200', '', 'Transports sur ventes.', '6242', '0');
INSERT INTO `0_chart_master` VALUES ('624300', '', 'Transports entre établissements ou chantiers.', '6243', '0');
INSERT INTO `0_chart_master` VALUES ('624400', '', 'Transports administratifs.', '6244', '0');
INSERT INTO `0_chart_master` VALUES ('624700', '', 'Transports collectifs du personnel.', '6247', '0');
INSERT INTO `0_chart_master` VALUES ('624800', '', 'Divers.', '6248', '0');
INSERT INTO `0_chart_master` VALUES ('625000', '', 'Déplacements, missions et réceptions.', '625', '0');
INSERT INTO `0_chart_master` VALUES ('625100', '', 'Voyages et déplacements.', '6251', '0');
INSERT INTO `0_chart_master` VALUES ('625500', '', 'Frais de déménagement.', '6255', '0');
INSERT INTO `0_chart_master` VALUES ('625600', '', 'Missions.', '6256', '0');
INSERT INTO `0_chart_master` VALUES ('625700', '', 'Réceptions.', '6257', '0');
INSERT INTO `0_chart_master` VALUES ('626000', '', 'Frais postaux et frais de télécommunications.', '626', '0');
INSERT INTO `0_chart_master` VALUES ('627000', '', 'Services bancaires et assimilés.', '627', '0');
INSERT INTO `0_chart_master` VALUES ('627100', '', 'Frais sur titres (achats, vente, garde).', '6271', '0');
INSERT INTO `0_chart_master` VALUES ('627200', '', 'Commissions et frais sur émission d&#039;emprunts.', '6272', '0');
INSERT INTO `0_chart_master` VALUES ('627500', '', 'Frais sur effets.', '6275', '0');
INSERT INTO `0_chart_master` VALUES ('627600', '', 'Location de coffres.', '6276', '0');
INSERT INTO `0_chart_master` VALUES ('627800', '', 'Autres frais et commissions sur prestations de ser', '6278', '0');
INSERT INTO `0_chart_master` VALUES ('628000', '', 'Divers.', '628', '0');
INSERT INTO `0_chart_master` VALUES ('628100', '', 'Concours divers (cotisations...).', '6281', '0');
INSERT INTO `0_chart_master` VALUES ('628400', '', 'Frais de recrutement de personnel.', '6284', '0');
INSERT INTO `0_chart_master` VALUES ('629000', '', 'Rabais, remises et ristournes obtenus sur autres s', '629', '0');
INSERT INTO `0_chart_master` VALUES ('630000', '', 'Impôts, taxes et versements assimilés.', '63', '0');
INSERT INTO `0_chart_master` VALUES ('631000', '', 'Impôts, taxes et versements assimilés sur rémunération admin', '631', '0');
INSERT INTO `0_chart_master` VALUES ('631100', '', 'Taxe sur les salaires.', '6311', '0');
INSERT INTO `0_chart_master` VALUES ('631200', '', 'Taxe d&#039;apprentissage.', '6312', '0');
INSERT INTO `0_chart_master` VALUES ('631300', '', 'Participation des employeurs à la formation profes', '6313', '0');
INSERT INTO `0_chart_master` VALUES ('631400', '', 'Cotisation pour défaut d&#039;investissement obligatoir', '6314', '0');
INSERT INTO `0_chart_master` VALUES ('631800', '', 'Autres.', '6318', '0');
INSERT INTO `0_chart_master` VALUES ('633000', '', 'Impôts, taxes et versements assimilés sur rémunération Autre', '633', '0');
INSERT INTO `0_chart_master` VALUES ('633100', '', 'Versement de transport.', '6331', '0');
INSERT INTO `0_chart_master` VALUES ('633200', '', 'Allocation logement.', '6332', '0');
INSERT INTO `0_chart_master` VALUES ('633300', '', 'Participation des employeurs à la formation professionnelle ', '6333', '0');
INSERT INTO `0_chart_master` VALUES ('633400', '', 'Participation des employeurs à l&#039;effort de constru', '6334', '0');
INSERT INTO `0_chart_master` VALUES ('633500', '', 'Versements libératoires ouvrant droit à l&#039;exonérat', '6335', '0');
INSERT INTO `0_chart_master` VALUES ('633800', '', 'Autres.', '6338', '0');
INSERT INTO `0_chart_master` VALUES ('635000', '', 'Autres impôts, taxes et versements assimilés (admi', '635', '0');
INSERT INTO `0_chart_master` VALUES ('635100', '', 'Impôts directs (sauf impôts sur les bénéfices).', '6351', '0');
INSERT INTO `0_chart_master` VALUES ('633110', '', 'Taxe professionnelle.', '63511', '0');
INSERT INTO `0_chart_master` VALUES ('635120', '', 'Taxes foncières.', '63512', '0');
INSERT INTO `0_chart_master` VALUES ('635130', '', 'Autres impôts locaux.', '63513', '0');
INSERT INTO `0_chart_master` VALUES ('635140', '', 'Taxe sur les véhicules des sociétés.', '63514', '0');
INSERT INTO `0_chart_master` VALUES ('635200', '', 'Taxes sur le chiffre d&#039;affaires non récupérables.', '6352', '0');
INSERT INTO `0_chart_master` VALUES ('635300', '', 'Impôts indirects.', '6353', '0');
INSERT INTO `0_chart_master` VALUES ('635400', '', 'Droits d&#039;enregistrement et de timbre.', '6354', '0');
INSERT INTO `0_chart_master` VALUES ('635410', '', 'Droits de mutation.', '63541', '0');
INSERT INTO `0_chart_master` VALUES ('635800', '', 'Autres droits.', '6358', '0');
INSERT INTO `0_chart_master` VALUES ('637000', '', 'Autres impôts, taxes et versements assimilés (autr', '637', '0');
INSERT INTO `0_chart_master` VALUES ('637100', '', 'Contribution sociale de solidarité à la charge des', '6371', '0');
INSERT INTO `0_chart_master` VALUES ('637200', '', 'Taxes perçues par les organismes publics internati', '6372', '0');
INSERT INTO `0_chart_master` VALUES ('637300', '', 'CSG/CRDS déductible IR', '6373', '0');
INSERT INTO `0_chart_master` VALUES ('637400', '', 'Impôts et taxes exigibles à l&#039;étranger.', '6374', '0');
INSERT INTO `0_chart_master` VALUES ('637800', '', 'Taxes diverses.', '6378', '0');
INSERT INTO `0_chart_master` VALUES ('640000', '', 'Charges de personnel.', '64', '0');
INSERT INTO `0_chart_master` VALUES ('641000', '', 'Rémunérations du personnel.', '641', '0');
INSERT INTO `0_chart_master` VALUES ('641100', '', 'Salaires, appointements.', '6411', '0');
INSERT INTO `0_chart_master` VALUES ('641200', '', 'Congés payés.', '6412', '0');
INSERT INTO `0_chart_master` VALUES ('641300', '', 'Primes et gratifications.', '6413', '0');
INSERT INTO `0_chart_master` VALUES ('641400', '', 'Indemnités et avantages divers.', '6414', '0');
INSERT INTO `0_chart_master` VALUES ('641500', '', 'Supplément familial.', '6415', '0');
INSERT INTO `0_chart_master` VALUES ('644000', '', 'Rémunération du travail de l&#039;exploitant.', '644', '0');
INSERT INTO `0_chart_master` VALUES ('644100', '', 'CSG non déductible IR', '6441', '0');
INSERT INTO `0_chart_master` VALUES ('645000', '', 'Charges de sécurité sociale et de prévoyance.', '645', '0');
INSERT INTO `0_chart_master` VALUES ('645100', '', 'Cotisations à l&#039;Urssaf.', '6451', '0');
INSERT INTO `0_chart_master` VALUES ('645200', '', 'Cotisations aux mutuelles.', '6452', '0');
INSERT INTO `0_chart_master` VALUES ('645300', '', 'Cotisations aux caisses de retraites.', '6453', '0');
INSERT INTO `0_chart_master` VALUES ('645400', '', 'Cotisations aux Assédic.', '6454', '0');
INSERT INTO `0_chart_master` VALUES ('645800', '', 'Cotisations aux autres organismes sociaux.', '6458', '0');
INSERT INTO `0_chart_master` VALUES ('646000', '', 'Cotisations sociales personnelles de l&#039;exploitant.', '646', '0');
INSERT INTO `0_chart_master` VALUES ('646100', '', 'Cotisations Allocations familiales TNS', '6461', '0');
INSERT INTO `0_chart_master` VALUES ('646200', '', 'Cotisations Maladie TNS', '6462', '0');
INSERT INTO `0_chart_master` VALUES ('646300', '', 'Cotisations Viellesse TNS', '6463', '0');
INSERT INTO `0_chart_master` VALUES ('647000', '', 'Autres charges sociales.', '647', '0');
INSERT INTO `0_chart_master` VALUES ('647100', '', 'Prestations directes.', '6471', '0');
INSERT INTO `0_chart_master` VALUES ('647200', '', 'Versements aux comités d&#039;entreprise et d&#039;établisse', '6472', '0');
INSERT INTO `0_chart_master` VALUES ('647300', '', 'Versements aux comités d&#039;hygiène et de sécurité.', '6473', '0');
INSERT INTO `0_chart_master` VALUES ('647400', '', 'Versements aux autres oeuvres sociales.', '6474', '0');
INSERT INTO `0_chart_master` VALUES ('647500', '', 'Médecine du travail, pharmacie.', '6475', '0');
INSERT INTO `0_chart_master` VALUES ('648000', '', 'Autres charges de personnel.', '648', '0');
INSERT INTO `0_chart_master` VALUES ('650000', '', 'Autres charges de gestion courante.', '65', '0');
INSERT INTO `0_chart_master` VALUES ('651000', '', 'Redevances pour concessions, brevets, licences, pr', '651', '0');
INSERT INTO `0_chart_master` VALUES ('651100', '', 'Redevances pour concessions, brevets, licences, ma', '6511', '0');
INSERT INTO `0_chart_master` VALUES ('651600', '', 'Droits d&#039;auteur et de reproduction.', '6516', '0');
INSERT INTO `0_chart_master` VALUES ('651800', '', 'Autres droits et valeurs similaires.', '6518', '0');
INSERT INTO `0_chart_master` VALUES ('653000', '', 'Jetons de présence.', '653', '0');
INSERT INTO `0_chart_master` VALUES ('654000', '', 'Pertes sur créances irrécouvrables.', '654', '0');
INSERT INTO `0_chart_master` VALUES ('654100', '', 'Créances de l&#039;exercice.', '6541', '0');
INSERT INTO `0_chart_master` VALUES ('654400', '', 'Créances des exercices antérieurs.', '6544', '0');
INSERT INTO `0_chart_master` VALUES ('655000', '', 'Quotes-parts de résultat sur opérations faites en ', '655', '0');
INSERT INTO `0_chart_master` VALUES ('655100', '', 'Quote-part de bénéfice transférée (comptabilité du', '6551', '0');
INSERT INTO `0_chart_master` VALUES ('655500', '', 'Quote-part de perte supportée (comptabilité des as', '6555', '0');
INSERT INTO `0_chart_master` VALUES ('658000', '', 'Charges diverses de gestion courante.', '658', '0');
INSERT INTO `0_chart_master` VALUES ('660000', '', 'Charges financières.', '66', '0');
INSERT INTO `0_chart_master` VALUES ('661000', '', 'Charges d&#039;intérêts.', '661', '0');
INSERT INTO `0_chart_master` VALUES ('661100', '', 'Intérêts des emprunts et dettes.', '6611', '0');
INSERT INTO `0_chart_master` VALUES ('661160', '', 'Intérêts des emprunts et dettes assimilées.', '66116', '0');
INSERT INTO `0_chart_master` VALUES ('661170', '', 'Intérêts des dettes rattachées à des participations.', '66117', '0');
INSERT INTO `0_chart_master` VALUES ('661500', '', 'Intérêts des comptes courants et des dépôts crédit', '6615', '0');
INSERT INTO `0_chart_master` VALUES ('661600', '', 'Intérêts bancaires et sur opérations de financemen', '6616', '0');
INSERT INTO `0_chart_master` VALUES ('661700', '', 'Intérêts des obligations cautionnées.', '6617', '0');
INSERT INTO `0_chart_master` VALUES ('661800', '', 'Intérêts des autres dettes.', '6618', '0');
INSERT INTO `0_chart_master` VALUES ('661810', '', 'Intérêts des dettes commerciales.', '66181', '0');
INSERT INTO `0_chart_master` VALUES ('661880', '', 'Intérêts des dettes diverses.', '66188', '0');
INSERT INTO `0_chart_master` VALUES ('664000', '', 'Pertes sur créances liées à des participations.', '664', '0');
INSERT INTO `0_chart_master` VALUES ('665000', '', 'Escomptes accordés.', '665', '0');
INSERT INTO `0_chart_master` VALUES ('666000', '', 'Pertes de change.', '666', '0');
INSERT INTO `0_chart_master` VALUES ('667000', '', 'Charges nettes sur cessions de valeurs mobilières ', '667', '0');
INSERT INTO `0_chart_master` VALUES ('668000', '', 'Autres charges financières.', '668', '0');
INSERT INTO `0_chart_master` VALUES ('670000', '', 'Charges exceptionnelles.', '67', '0');
INSERT INTO `0_chart_master` VALUES ('671000', '', 'Charges exceptionnelles sur opérations de gestion.', '671', '0');
INSERT INTO `0_chart_master` VALUES ('671100', '', 'Pénalités sur marchés (et dédits payés sur achats ', '6711', '0');
INSERT INTO `0_chart_master` VALUES ('671200', '', 'Pénalités, amendes fiscales et pénales.', '6712', '0');
INSERT INTO `0_chart_master` VALUES ('671300', '', 'Dons, libéralités.', '6713', '0');
INSERT INTO `0_chart_master` VALUES ('671400', '', 'Créances devenues irrécouvrables dans l&#039;exercice.', '6714', '0');
INSERT INTO `0_chart_master` VALUES ('671500', '', 'Subventions accordées.', '6715', '0');
INSERT INTO `0_chart_master` VALUES ('671700', '', 'Rappel d&#039;impôts (autres qu&#039;impôts sur les bénéfice', '6717', '0');
INSERT INTO `0_chart_master` VALUES ('671800', '', 'Autres charges exceptionnelles sur opérations de g', '6718', '0');
INSERT INTO `0_chart_master` VALUES ('672000', '', 'Charges sur exercices antérieurs (en cours d&#039;exerc', '672', '0');
INSERT INTO `0_chart_master` VALUES ('675000', '', 'Valeurs comptables des éléments d&#039;actif cédés.', '675', '0');
INSERT INTO `0_chart_master` VALUES ('675100', '', 'Immobilisations incorporelles.', '6751', '0');
INSERT INTO `0_chart_master` VALUES ('675200', '', 'Immobilisations corporelles.', '6752', '0');
INSERT INTO `0_chart_master` VALUES ('675600', '', 'Immobilisations financières.', '6756', '0');
INSERT INTO `0_chart_master` VALUES ('675800', '', 'Autres éléments d&#039;actif.', '6758', '0');
INSERT INTO `0_chart_master` VALUES ('678000', '', 'Autres charges exceptionnelles.', '678', '0');
INSERT INTO `0_chart_master` VALUES ('678100', '', 'Malis provenant de clauses d&#039;indexation.', '6781', '0');
INSERT INTO `0_chart_master` VALUES ('678200', '', 'Lots.', '6782', '0');
INSERT INTO `0_chart_master` VALUES ('678300', '', 'Malis provenant du rachat par l&#039;entreprise d&#039;actio', '6783', '0');
INSERT INTO `0_chart_master` VALUES ('678800', '', 'Charges exceptionnelles diverses.', '6788', '0');
INSERT INTO `0_chart_master` VALUES ('680000', '', 'Dotations aux amortissements, aux dépréciations et', '68', '0');
INSERT INTO `0_chart_master` VALUES ('681000', '', 'Dotations aux amortissements, aux dépréciations et', '681', '0');
INSERT INTO `0_chart_master` VALUES ('681100', '', 'Dotations aux amortissements des immobilisations i', '6811', '0');
INSERT INTO `0_chart_master` VALUES ('681110', '', 'Dotations aux amortissements des Immobilisations incorporell', '68111', '0');
INSERT INTO `0_chart_master` VALUES ('681120', '', 'Dotations aux amortissements des Immobilisations corporelles', '68112', '0');
INSERT INTO `0_chart_master` VALUES ('681200', '', 'Dotations aux amortissements des charges d&#039;exploit', '6812', '0');
INSERT INTO `0_chart_master` VALUES ('681500', '', 'Dotations aux provisions d&#039;exploitation.', '6815', '0');
INSERT INTO `0_chart_master` VALUES ('681600', '', 'Dotations aux dépréciations des immobilisations in', '6816', '0');
INSERT INTO `0_chart_master` VALUES ('681610', '', 'Dotations aux dépréciations des Immobilisations incorporelle', '68161', '0');
INSERT INTO `0_chart_master` VALUES ('681620', '', 'Dotations aux dépréciations des Immobilisations corporelles.', '68162', '0');
INSERT INTO `0_chart_master` VALUES ('681700', '', 'Dotations aux dépréciations des actifs circulants.', '6817', '0');
INSERT INTO `0_chart_master` VALUES ('681730', '', 'Dotations aux dépréciations de Stocks et en-cours.', '68173', '0');
INSERT INTO `0_chart_master` VALUES ('681740', '', 'Dotations aux dépréciations de Créances.', '68174', '0');
INSERT INTO `0_chart_master` VALUES ('686000', '', 'Dotations aux amortissements, aux dépréciations et', '686', '0');
INSERT INTO `0_chart_master` VALUES ('686100', '', 'Dotations aux amortissements des primes de rembour', '6861', '0');
INSERT INTO `0_chart_master` VALUES ('686500', '', 'Dotations aux provisions financières.', '6865', '0');
INSERT INTO `0_chart_master` VALUES ('686600', '', 'Dotations aux dépréciations des éléments financier', '6866', '0');
INSERT INTO `0_chart_master` VALUES ('686620', '', 'Immobilisations financières.', '68662', '0');
INSERT INTO `0_chart_master` VALUES ('686650', '', 'Valeurs mobilières de placement.', '68665', '0');
INSERT INTO `0_chart_master` VALUES ('686800', '', 'Autres dotations.', '6868', '0');
INSERT INTO `0_chart_master` VALUES ('687000', '', 'Dotations aux amortissements et aux provisions - C', '687', '0');
INSERT INTO `0_chart_master` VALUES ('687100', '', 'Dotations aux amortissements exceptionnels des imm', '6871', '0');
INSERT INTO `0_chart_master` VALUES ('687200', '', 'Dotations aux provisions réglementées (immobilisat', '6872', '0');
INSERT INTO `0_chart_master` VALUES ('687250', '', 'Amortissements dérogatoires.', '68725', '0');
INSERT INTO `0_chart_master` VALUES ('687300', '', 'Dotations aux provisions réglementées (stocks).', '6873', '0');
INSERT INTO `0_chart_master` VALUES ('687400', '', 'Dotations aux autres provisions réglementées.', '6874', '0');
INSERT INTO `0_chart_master` VALUES ('687500', '', 'Dotations aux provisions exceptionnelles.', '6875', '0');
INSERT INTO `0_chart_master` VALUES ('687600', '', 'Dotations aux dépréciations exceptionnelles.', '6876', '0');
INSERT INTO `0_chart_master` VALUES ('690000', '', 'Participation des salariés - Impôts sur les bénéfi', '69', '0');
INSERT INTO `0_chart_master` VALUES ('691000', '', 'Participation des salariés aux résultats.', '691', '0');
INSERT INTO `0_chart_master` VALUES ('695000', '', 'Impôts sur les bénéfices.', '695', '0');
INSERT INTO `0_chart_master` VALUES ('695100', '', 'Impôts dus en France.', '6951', '0');
INSERT INTO `0_chart_master` VALUES ('695200', '', 'Contribution additionnelle à l&#039;impôt sur les bénéf', '6952', '0');
INSERT INTO `0_chart_master` VALUES ('695400', '', 'Impôts dus à l&#039;étranger.', '6954', '0');
INSERT INTO `0_chart_master` VALUES ('696000', '', 'Suppléments d&#039;impôt sur les sociétés liés aux dist', '696', '0');
INSERT INTO `0_chart_master` VALUES ('697000', '', 'Imposition forfaitaire annuelle des sociétés.', '697', '0');
INSERT INTO `0_chart_master` VALUES ('698000', '', 'Intégration fiscale d&#039;impôt (voir n° 2855).', '698', '0');
INSERT INTO `0_chart_master` VALUES ('698100', '', 'Intégration fiscale - Charges.', '6981', '0');
INSERT INTO `0_chart_master` VALUES ('698900', '', 'Intégration fiscale - Produits.', '6989', '0');
INSERT INTO `0_chart_master` VALUES ('699000', '', 'Produits - report en arrière des déficits.', '699', '0');
INSERT INTO `0_chart_master` VALUES ('700000', '', 'Ventes de produits fabriqués, prestations de servi', '70', '0');
INSERT INTO `0_chart_master` VALUES ('701000', '', 'Ventes de produits finis.', '701', '0');
INSERT INTO `0_chart_master` VALUES ('701100', '', 'Produit fini (ou groupe) A.', '7011', '0');
INSERT INTO `0_chart_master` VALUES ('701200', '', 'Produit fini (ou groupe) B.', '7012', '0');
INSERT INTO `0_chart_master` VALUES ('702000', '', 'Ventes de produits intermédiaires.', '702', '0');
INSERT INTO `0_chart_master` VALUES ('703000', '', 'Ventes de produits résiduels.', '703', '0');
INSERT INTO `0_chart_master` VALUES ('704000', '', 'Travaux.', '704', '0');
INSERT INTO `0_chart_master` VALUES ('704100', '', 'Travaux de catégorie (ou activité) A.', '7041', '0');
INSERT INTO `0_chart_master` VALUES ('704200', '', 'Travaux de catégorie (ou activité) B.', '7042', '0');
INSERT INTO `0_chart_master` VALUES ('705000', '', 'Etudes.', '705', '0');
INSERT INTO `0_chart_master` VALUES ('706000', '', 'Prestations de services.', '706', '0');
INSERT INTO `0_chart_master` VALUES ('707000', '', 'Ventes de marchandises.', '707', '0');
INSERT INTO `0_chart_master` VALUES ('707100', '', 'Marchandise (ou groupe) A.', '7071', '0');
INSERT INTO `0_chart_master` VALUES ('707200', '', 'Marchandise (ou groupe) B.', '7072', '0');
INSERT INTO `0_chart_master` VALUES ('708000', '', 'Produits des activités annexes.', '708', '0');
INSERT INTO `0_chart_master` VALUES ('708100', '', 'Produits des services exploités dans l&#039;intérêt du personnel', '7081', '0');
INSERT INTO `0_chart_master` VALUES ('708200', '', 'Commissions et courtages.', '7082', '0');
INSERT INTO `0_chart_master` VALUES ('708300', '', 'Locations diverses.', '7083', '0');
INSERT INTO `0_chart_master` VALUES ('708400', '', 'Mise à disposition de personnel facturée.', '7084', '0');
INSERT INTO `0_chart_master` VALUES ('708500', '', 'Ports et frais accessoires facturés.', '7085', '0');
INSERT INTO `0_chart_master` VALUES ('708600', '', 'Bonis sur reprises d&#039;emballages consignés.', '7086', '0');
INSERT INTO `0_chart_master` VALUES ('708700', '', 'Bonifications obtenues des clients et primes sur v', '7087', '0');
INSERT INTO `0_chart_master` VALUES ('708800', '', 'Autres produits d&#039;activités annexes (cessions d&#039;ap', '7088', '0');
INSERT INTO `0_chart_master` VALUES ('709000', '', 'Rabais, remises et ristournes accordés par l&#039;entre', '709', '0');
INSERT INTO `0_chart_master` VALUES ('709100', '', '- sur ventes de produits finis.', '7091', '0');
INSERT INTO `0_chart_master` VALUES ('709200', '', '- sur ventes de produits intermédiaires.', '7092', '0');
INSERT INTO `0_chart_master` VALUES ('709400', '', '- sur travaux.', '7094', '0');
INSERT INTO `0_chart_master` VALUES ('709500', '', '- sur études.', '7095', '0');
INSERT INTO `0_chart_master` VALUES ('709600', '', '- sur prestations de services.', '7096', '0');
INSERT INTO `0_chart_master` VALUES ('709700', '', '- sur ventes de marchandises.', '7097', '0');
INSERT INTO `0_chart_master` VALUES ('709800', '', '- sur produits des activités annexes.', '7098', '0');
INSERT INTO `0_chart_master` VALUES ('710000', '', 'Production stockée (ou déstockage).', '71', '0');
INSERT INTO `0_chart_master` VALUES ('713000', '', 'Variation des stocks (en-cours de production, prod', '713', '0');
INSERT INTO `0_chart_master` VALUES ('713300', '', 'Variation des en-cours de production de biens.', '7133', '0');
INSERT INTO `0_chart_master` VALUES ('713310', '', 'Produits en cours.', '71331', '0');
INSERT INTO `0_chart_master` VALUES ('713350', '', 'Travaux en cours.', '71335', '0');
INSERT INTO `0_chart_master` VALUES ('713400', '', 'Variation des en-cours de production de services.', '7134', '0');
INSERT INTO `0_chart_master` VALUES ('713410', '', 'Etudes en cours.', '71341', '0');
INSERT INTO `0_chart_master` VALUES ('713450', '', 'Prestations de services en cours.', '71345', '0');
INSERT INTO `0_chart_master` VALUES ('713500', '', 'Variation des stocks de produits.', '7135', '0');
INSERT INTO `0_chart_master` VALUES ('713510', '', 'Produits intermédiaires.', '71351', '0');
INSERT INTO `0_chart_master` VALUES ('713550', '', 'Produits finis.', '71355', '0');
INSERT INTO `0_chart_master` VALUES ('713580', '', 'Produits résiduels.', '71358', '0');
INSERT INTO `0_chart_master` VALUES ('720000', '', 'Production immobilisée. ', '72', '0');
INSERT INTO `0_chart_master` VALUES ('721000', '', 'Immobilisations incorporelles.', '721', '0');
INSERT INTO `0_chart_master` VALUES ('722000', '', 'Immobilisations corporelles.', '722', '0');
INSERT INTO `0_chart_master` VALUES ('740000', '', 'Subventions d&#039;exploitation.', '74', '0');
INSERT INTO `0_chart_master` VALUES ('750000', '', 'Autres produits de gestion courante.', '75', '0');
INSERT INTO `0_chart_master` VALUES ('751000', '', 'Redevances pour concessions, brevets, licences, ma', '751', '0');
INSERT INTO `0_chart_master` VALUES ('751100', '', 'Redevances pour concessions, brevets, licences, ma', '7511', '0');
INSERT INTO `0_chart_master` VALUES ('751600', '', 'Droits d&#039;auteur et de reproduction.', '7516', '0');
INSERT INTO `0_chart_master` VALUES ('751800', '', 'Autres droits et valeurs similaires.', '7518', '0');
INSERT INTO `0_chart_master` VALUES ('752000', '', 'Revenus des immeubles non affectés aux activités p', '752', '0');
INSERT INTO `0_chart_master` VALUES ('753000', '', 'Jetons de présence et rémunérations d&#039;administrate', '753', '0');
INSERT INTO `0_chart_master` VALUES ('754000', '', 'Ristournes perçues des coopératives (provenant des', '754', '0');
INSERT INTO `0_chart_master` VALUES ('755000', '', 'Quotes-parts de résultat sur opérations faites en ', '755', '0');
INSERT INTO `0_chart_master` VALUES ('755100', '', 'Quote-part de perte transférée (comptabilité du gé', '7551', '0');
INSERT INTO `0_chart_master` VALUES ('755500', '', 'Quote-part de bénéfice attribuée (comptabilité des', '7555', '0');
INSERT INTO `0_chart_master` VALUES ('758000', '', 'Produits divers de gestion courante.', '758', '0');
INSERT INTO `0_chart_master` VALUES ('760000', '', 'Produits financiers. ', '76', '0');
INSERT INTO `0_chart_master` VALUES ('761000', '', 'Produits de participations.', '761', '0');
INSERT INTO `0_chart_master` VALUES ('761100', '', 'Revenus des titres de participation.', '7611', '0');
INSERT INTO `0_chart_master` VALUES ('761600', '', 'Revenus sur autres formes de participation.', '7616', '0');
INSERT INTO `0_chart_master` VALUES ('761700', '', 'Revenus de créances rattachées à des participation', '7617', '0');
INSERT INTO `0_chart_master` VALUES ('762000', '', 'Produits des autres immobilisations financières.', '762', '0');
INSERT INTO `0_chart_master` VALUES ('762100', '', 'Revenus des titres immobilisés.', '7621', '0');
INSERT INTO `0_chart_master` VALUES ('762600', '', 'Revenus des prêts.', '7624', '0');
INSERT INTO `0_chart_master` VALUES ('762700', '', 'Revenus des créances immobilisées.', '7627', '0');
INSERT INTO `0_chart_master` VALUES ('763000', '', 'Revenus des autres créances.', '763', '0');
INSERT INTO `0_chart_master` VALUES ('763100', '', 'Revenus des créances commerciales.', '7631', '0');
INSERT INTO `0_chart_master` VALUES ('763800', '', 'Revenus des créances diverses.', '7638', '0');
INSERT INTO `0_chart_master` VALUES ('764000', '', 'Revenus des valeurs mobilières de placement.', '764', '0');
INSERT INTO `0_chart_master` VALUES ('765000', '', 'Escomptes obtenus.', '765', '0');
INSERT INTO `0_chart_master` VALUES ('766000', '', 'Gains de change.', '766', '0');
INSERT INTO `0_chart_master` VALUES ('767000', '', 'Produits nets sur cessions de valeurs mobilières de placemen', '767', '0');
INSERT INTO `0_chart_master` VALUES ('768000', '', 'Autres produits financiers.', '768', '0');
INSERT INTO `0_chart_master` VALUES ('770000', '', 'Produits exceptionnels. ', '77', '0');
INSERT INTO `0_chart_master` VALUES ('771000', '', 'Produits exceptionnels sur opérations de gestion.', '771', '0');
INSERT INTO `0_chart_master` VALUES ('771100', '', 'Dédits et pénalités perçus sur achats et sur vente', '7711', '0');
INSERT INTO `0_chart_master` VALUES ('771300', '', 'Libéralités perçues.', '7713', '0');
INSERT INTO `0_chart_master` VALUES ('771400', '', 'Rentrées sur créances amorties.', '7714', '0');
INSERT INTO `0_chart_master` VALUES ('771500', '', 'Subventions d&#039;équilibre.', '7715', '0');
INSERT INTO `0_chart_master` VALUES ('771700', '', 'Dégrèvement d&#039;impôts autres qu&#039;impôts sur les béné', '7717', '0');
INSERT INTO `0_chart_master` VALUES ('771800', '', 'Autres produits exceptionnels sur opérations de ge', '7718', '0');
INSERT INTO `0_chart_master` VALUES ('772000', '', 'Produits sur exercices antérieurs (en cours d&#039;exer', '772', '0');
INSERT INTO `0_chart_master` VALUES ('775000', '', 'Produits des cessions d&#039;éléments d&#039;actif.', '775', '0');
INSERT INTO `0_chart_master` VALUES ('775100', '', 'Immobilisations incorporelles.', '7751', '0');
INSERT INTO `0_chart_master` VALUES ('775200', '', 'Immobilisations corporelles.', '7752', '0');
INSERT INTO `0_chart_master` VALUES ('775600', '', 'Immobilisations financières.', '7756', '0');
INSERT INTO `0_chart_master` VALUES ('775800', '', 'Autres éléments d&#039;actif.', '7758', '0');
INSERT INTO `0_chart_master` VALUES ('777000', '', 'Quote-part des subventions d&#039;investissement virée ', '777', '0');
INSERT INTO `0_chart_master` VALUES ('778000', '', 'Autres produits exceptionnels.', '778', '0');
INSERT INTO `0_chart_master` VALUES ('778100', '', 'Bonis provenant de clauses d&#039;indexation.', '7781', '0');
INSERT INTO `0_chart_master` VALUES ('778200', '', 'Lots.', '7782', '0');
INSERT INTO `0_chart_master` VALUES ('778300', '', 'Bonis provenant du rachat par l&#039;entreprise d&#039;actio', '7783', '0');
INSERT INTO `0_chart_master` VALUES ('778800', '', 'Produits exceptionnels divers.', '7788', '0');
INSERT INTO `0_chart_master` VALUES ('780000', '', 'Reprises sur amortissements, aux dépréciations et ', '78', '0');
INSERT INTO `0_chart_master` VALUES ('781000', '', 'Reprises sur amortissements et provisions (à inscr', '781', '0');
INSERT INTO `0_chart_master` VALUES ('781100', '', 'Reprises sur amortissements des immobilisations in', '7811', '0');
INSERT INTO `0_chart_master` VALUES ('781110', '', 'Immobilisations incorporelles.', '78111', '0');
INSERT INTO `0_chart_master` VALUES ('781120', '', 'Immobilisations corporelles.', '78112', '0');
INSERT INTO `0_chart_master` VALUES ('781500', '', 'Reprises sur provisions d&#039;exploitation.', '7815', '0');
INSERT INTO `0_chart_master` VALUES ('781600', '', 'Reprise sur dépréciations des immobilisations inco', '7816', '0');
INSERT INTO `0_chart_master` VALUES ('781610', '', 'Immobilisations incorporelles.', '78161', '0');
INSERT INTO `0_chart_master` VALUES ('781620', '', 'Immobilisations corporelles.', '78162', '0');
INSERT INTO `0_chart_master` VALUES ('781700', '', 'Reprises sur dépréciations des actifs circulants.', '7817', '0');
INSERT INTO `0_chart_master` VALUES ('781730', '', 'Stocks et en-cours.', '78173', '0');
INSERT INTO `0_chart_master` VALUES ('781740', '', 'Créances.', '78174', '0');
INSERT INTO `0_chart_master` VALUES ('786000', '', 'Reprises sur provisions pour risques et dépréciati', '786', '0');
INSERT INTO `0_chart_master` VALUES ('786500', '', 'Reprises sur provisions financières.', '7865', '0');
INSERT INTO `0_chart_master` VALUES ('786600', '', 'Reprises sur dépréciations des éléments financiers', '7866', '0');
INSERT INTO `0_chart_master` VALUES ('786620', '', 'Immobilisations financières.', '78662', '0');
INSERT INTO `0_chart_master` VALUES ('786650', '', 'Valeurs mobilières de placement.', '78665', '0');
INSERT INTO `0_chart_master` VALUES ('787000', '', 'Reprises sur provisions et dépréciations (à inscri', '787', '0');
INSERT INTO `0_chart_master` VALUES ('787200', '', 'Reprises sur provisions réglementées (immobilisati', '7872', '0');
INSERT INTO `0_chart_master` VALUES ('787250', '', 'Amortissements dérogatoires.', '78725', '0');
INSERT INTO `0_chart_master` VALUES ('787260', '', 'Provision spéciale de réévaluation.', '78726', '0');
INSERT INTO `0_chart_master` VALUES ('787270', '', 'Plus-values réinvesties.', '78727', '0');
INSERT INTO `0_chart_master` VALUES ('787300', '', 'Reprises sur provisions réglementées (stocks).', '7873', '0');
INSERT INTO `0_chart_master` VALUES ('787400', '', 'Reprises sur autres provisions réglementées.', '7874', '0');
INSERT INTO `0_chart_master` VALUES ('787500', '', 'Reprises sur provisions exceptionnelles.', '7875', '0');
INSERT INTO `0_chart_master` VALUES ('787600', '', 'Reprises sur dépréciations exceptionnelles.', '7876', '0');
INSERT INTO `0_chart_master` VALUES ('790000', '', 'Transferts de charges. ', '79', '0');
INSERT INTO `0_chart_master` VALUES ('791000', '', 'Transferts de charges d&#039;exploitation.', '791', '0');
INSERT INTO `0_chart_master` VALUES ('796000', '', 'Transferts de charges financières.', '796', '0');
INSERT INTO `0_chart_master` VALUES ('797000', '', 'Transferts de charges exceptionnelles.', '797', '0');
INSERT INTO `0_chart_master` VALUES ('800000', '', 'Engagements', '80', '0');
INSERT INTO `0_chart_master` VALUES ('801000', '', 'Engagements donnés par l’entité', '801', '0');
INSERT INTO `0_chart_master` VALUES ('801100', '', 'Avals, cautions, garanties.', '8011', '0');
INSERT INTO `0_chart_master` VALUES ('801400', '', 'Effets circulant sous l’endos de l’entité.', '8014', '0');
INSERT INTO `0_chart_master` VALUES ('801600', '', 'Redevances crédit-bail restant à courir.', '8016', '0');
INSERT INTO `0_chart_master` VALUES ('801610', '', 'Redevances crédit-bail mobilier restant à courir.', '80161', '0');
INSERT INTO `0_chart_master` VALUES ('801650', '', 'Redevances crédit-bail immobilier restant à courir.', '80165', '0');
INSERT INTO `0_chart_master` VALUES ('801800', '', 'Autres engagements donnés.', '8018', '0');
INSERT INTO `0_chart_master` VALUES ('802000', '', 'Engagements reçus par l’entité', '802', '0');
INSERT INTO `0_chart_master` VALUES ('802100', '', 'Avals, cautions, garanties.', '8021', '0');
INSERT INTO `0_chart_master` VALUES ('802400', '', 'Créances escomptées non échues.', '8024', '0');
INSERT INTO `0_chart_master` VALUES ('802600', '', 'Engagements reçus pour utilisation en crédit-bail.', '8026', '0');
INSERT INTO `0_chart_master` VALUES ('802610', '', 'Engagements reçus pour utilisation en crédit-bail mobilier.', '80261', '0');
INSERT INTO `0_chart_master` VALUES ('802650', '', 'Engagements reçus pour utilisation en crédit-bail immobilier', '80265', '0');
INSERT INTO `0_chart_master` VALUES ('802800', '', 'Autres engagements reçus.', '8028', '0');
INSERT INTO `0_chart_master` VALUES ('809000', '', 'Contrepartie des engagements', '809', '0');
INSERT INTO `0_chart_master` VALUES ('809100', '', 'Contrepartie 801', '8091', '0');
INSERT INTO `0_chart_master` VALUES ('809200', '', 'Contrepartie 802', '8092', '0');
INSERT INTO `0_chart_master` VALUES ('880000', '', 'Résultat en instance d&#039;affectation.', '88', '0');
INSERT INTO `0_chart_master` VALUES ('890000', '', 'Bilan d&#039;ouverture.', '890', '0');
INSERT INTO `0_chart_master` VALUES ('891000', '', 'Bilan de clôture.', '891', '0');


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
) ENGINE=MyISAM AUTO_INCREMENT=213189  ;


### Data of table `0_chart_types` ###

INSERT INTO `0_chart_types` VALUES ('10', '10 Capital et réserves.', '1', '', '0');
INSERT INTO `0_chart_types` VALUES ('101', '101 Capital.', '1', '101', '0');
INSERT INTO `0_chart_types` VALUES ('1011', '1011 Capital souscrit - non appelé.', '1', '101', '0');
INSERT INTO `0_chart_types` VALUES ('1012', '1012 Capital souscrit - appelé, non versé.', '1', '101', '0');
INSERT INTO `0_chart_types` VALUES ('1013', '1013 Capital souscrit - appelé, versé.', '1', '101', '0');
INSERT INTO `0_chart_types` VALUES ('10131', '10131 Capital non amorti.', '1', '1013', '0');
INSERT INTO `0_chart_types` VALUES ('10132', '10132 Capital amorti.', '1', '1013', '0');
INSERT INTO `0_chart_types` VALUES ('1018', '1018 Capital souscrit soumis à des réglementations part', '1', '101', '0');
INSERT INTO `0_chart_types` VALUES ('104', '104 Primes liées au capital social.', '1', '10', '0');
INSERT INTO `0_chart_types` VALUES ('1041', '1041 Primes d&#039;émission.', '1', '104', '0');
INSERT INTO `0_chart_types` VALUES ('1042', '1042 Primes de fusion.', '1', '104', '0');
INSERT INTO `0_chart_types` VALUES ('1043', '1043 Primes d&#039;apport.', '1', '104', '0');
INSERT INTO `0_chart_types` VALUES ('1044', '1044 Primes de conversion d&#039;obligations en actions.', '1', '104', '0');
INSERT INTO `0_chart_types` VALUES ('1045', '1045 Bons de souscription d&#039;actions.', '1', '104', '0');
INSERT INTO `0_chart_types` VALUES ('105', '105 Ecarts de réévaluation.', '1', '10', '0');
INSERT INTO `0_chart_types` VALUES ('1051', '1051 Réserve spéciale de réévaluation.', '1', '105', '0');
INSERT INTO `0_chart_types` VALUES ('1052', '1052 Ecart de réévaluation libre.', '1', '105', '0');
INSERT INTO `0_chart_types` VALUES ('1053', '1053 Réserve de réévaluation.', '1', '105', '0');
INSERT INTO `0_chart_types` VALUES ('1055', '1055 Ecarts de réévaluation (autres opérations légales)', '1', '105', '0');
INSERT INTO `0_chart_types` VALUES ('1057', '1057 Autres écarts de réévaluation en France.', '1', '105', '0');
INSERT INTO `0_chart_types` VALUES ('1058', '1058 Autres écarts de réévaluation à l&#039;étranger.', '1', '105', '0');
INSERT INTO `0_chart_types` VALUES ('106', '106 Réserves.', '1', '10', '0');
INSERT INTO `0_chart_types` VALUES ('1061', '1061 Réserve légale.', '1', '106', '0');
INSERT INTO `0_chart_types` VALUES ('10611', '10611 Réserve légale proprement dite.', '1', '1061', '0');
INSERT INTO `0_chart_types` VALUES ('10612', '10612 Plus-values nettes à long terme.', '1', '1061', '0');
INSERT INTO `0_chart_types` VALUES ('1062', '1062 Réserves indisponibles.', '1', '106', '0');
INSERT INTO `0_chart_types` VALUES ('1063', '1063 Réserves statutaires ou contractuelles.', '1', '106', '0');
INSERT INTO `0_chart_types` VALUES ('1064', '1064 Réserves réglementées.', '1', '106', '0');
INSERT INTO `0_chart_types` VALUES ('10641', '10641 Plus-values nettes à long terme.', '1', '1064', '0');
INSERT INTO `0_chart_types` VALUES ('10643', '10643 Réserves consécutives à l&#039;octroi de subventions d&#039;', '1', '1064', '0');
INSERT INTO `0_chart_types` VALUES ('10648', '10648 Autres réserves réglementées.', '1', '1064', '0');
INSERT INTO `0_chart_types` VALUES ('1068', '1068 Autres réserves.', '1', '106', '0');
INSERT INTO `0_chart_types` VALUES ('10681', '10681 Réserve de propre assureur.', '1', '1068', '0');
INSERT INTO `0_chart_types` VALUES ('10688', '10688 Réserves diverses.', '1', '1068', '0');
INSERT INTO `0_chart_types` VALUES ('107', '107 Ecart d&#039;équivalence.', '1', '10', '0');
INSERT INTO `0_chart_types` VALUES ('108', '108 Compte de l&#039;exploitant.', '1', '10', '0');
INSERT INTO `0_chart_types` VALUES ('109', '109 Actionnaires : Capital souscrit - non appelé.', '1', '10', '0');
INSERT INTO `0_chart_types` VALUES ('11', '11 Report à nouveau (solde créditeur ou débiteur).', '1', '', '0');
INSERT INTO `0_chart_types` VALUES ('110', '110 Report à nouveau (solde créditeur).', '1', '11', '0');
INSERT INTO `0_chart_types` VALUES ('119', '119 Report à nouveau (solde débiteur).', '1', '11', '0');
INSERT INTO `0_chart_types` VALUES ('12', '12 Résultat de l&#039;exercice (bénéfice ou perte).', '1', '', '0');
INSERT INTO `0_chart_types` VALUES ('120', '120 Résultat de l&#039;exercice (bénéfice).', '1', '12', '0');
INSERT INTO `0_chart_types` VALUES ('129', '129 Résultat de l&#039;exercice (perte).', '1', '12', '0');
INSERT INTO `0_chart_types` VALUES ('13', '13 Subventions d&#039;investissement.', '1', '', '0');
INSERT INTO `0_chart_types` VALUES ('131', '131 Subventions d&#039;équipement.', '1', '13', '0');
INSERT INTO `0_chart_types` VALUES ('1311', '1311 Etat.', '1', '131', '0');
INSERT INTO `0_chart_types` VALUES ('1312', '1312 Régions.', '1', '131', '0');
INSERT INTO `0_chart_types` VALUES ('1313', '1313 Départements.', '1', '131', '0');
INSERT INTO `0_chart_types` VALUES ('1314', '1314 Communes.', '1', '131', '0');
INSERT INTO `0_chart_types` VALUES ('1315', '1315 Collectivités publiques.', '1', '131', '0');
INSERT INTO `0_chart_types` VALUES ('1316', '1316 Entreprises publiques.', '1', '131', '0');
INSERT INTO `0_chart_types` VALUES ('1317', '1317 Entreprises et organismes privés.', '1', '131', '0');
INSERT INTO `0_chart_types` VALUES ('1318', '1318 Autres.', '1', '131', '0');
INSERT INTO `0_chart_types` VALUES ('138', '138 Autres subventions d&#039;investissement.', '1', '13', '0');
INSERT INTO `0_chart_types` VALUES ('139', '139 Subventions d&#039;investissement inscrites au compte d', '1', '13', '0');
INSERT INTO `0_chart_types` VALUES ('1391', '1391 Subventions d&#039;équipement.', '1', '139', '0');
INSERT INTO `0_chart_types` VALUES ('13911', '13911 Etat.', '1', '1391', '0');
INSERT INTO `0_chart_types` VALUES ('13912', '13912 Régions.', '1', '1391', '0');
INSERT INTO `0_chart_types` VALUES ('13913', '13913 Départements.', '1', '1391', '0');
INSERT INTO `0_chart_types` VALUES ('13914', '13914 Communes.', '1', '1391', '0');
INSERT INTO `0_chart_types` VALUES ('13915', '13915 Collectivités publiques.', '1', '1391', '0');
INSERT INTO `0_chart_types` VALUES ('13916', '13916 Entreprises publiques.', '1', '1391', '0');
INSERT INTO `0_chart_types` VALUES ('13917', '13917 Entreprises et organismes privés.', '1', '1391', '0');
INSERT INTO `0_chart_types` VALUES ('13918', '13918 Autres.', '1', '1391', '0');
INSERT INTO `0_chart_types` VALUES ('1398', '1398 Autres subventions d&#039;investissement.', '1', '139', '0');
INSERT INTO `0_chart_types` VALUES ('14', '14 Provisions réglementées.', '1', '', '0');
INSERT INTO `0_chart_types` VALUES ('142', '142 Provisions réglementées relatives aux immobilisati', '1', '14', '0');
INSERT INTO `0_chart_types` VALUES ('1423', '1423 Provision pour reconstitution desgisements miniers', '1', '142', '0');
INSERT INTO `0_chart_types` VALUES ('1424', '1424 Provision pour investissement(participation des sa', '1', '142', '0');
INSERT INTO `0_chart_types` VALUES ('143', '143 Provisions réglementées relatives aux stocks.', '1', '14', '0');
INSERT INTO `0_chart_types` VALUES ('1431', '1431 Hausse des prix.', '1', '143', '0');
INSERT INTO `0_chart_types` VALUES ('1432', '1432 Fluctuation des cours.', '1', '143', '0');
INSERT INTO `0_chart_types` VALUES ('144', '144 Provisions réglementées relatives aux autres éléme', '1', '14', '0');
INSERT INTO `0_chart_types` VALUES ('145', '145  Amortissements dérogatoires.', '1', '14', '0');
INSERT INTO `0_chart_types` VALUES ('146', '146 Provision spéciale de réévaluation.', '1', '14', '0');
INSERT INTO `0_chart_types` VALUES ('147', '147 Plus-values réinvesties.', '1', '14', '0');
INSERT INTO `0_chart_types` VALUES ('148', '148 Autres provisions réglementées.', '1', '14', '0');
INSERT INTO `0_chart_types` VALUES ('15', '15 Provisions.', '1', '', '0');
INSERT INTO `0_chart_types` VALUES ('151', '151 Provisions pour risques.', '1', '15', '0');
INSERT INTO `0_chart_types` VALUES ('1511', '1511 Provisions pour litiges.', '1', '151', '0');
INSERT INTO `0_chart_types` VALUES ('1512', '1512 Provisions pour garanties données aux clients.', '1', '151', '0');
INSERT INTO `0_chart_types` VALUES ('1513', '1513 Provisions pour pertes sur marchés à terme.', '1', '151', '0');
INSERT INTO `0_chart_types` VALUES ('1514', '1514 Provisions pour amendes et pénalités.', '1', '151', '0');
INSERT INTO `0_chart_types` VALUES ('1515', '1515 Provisions pour pertes de change.', '1', '151', '0');
INSERT INTO `0_chart_types` VALUES ('1516', '1516 Provisions pour pertes sur contrats.', '1', '151', '0');
INSERT INTO `0_chart_types` VALUES ('1518', '1518 Autres provisions pour risques.', '1', '151', '0');
INSERT INTO `0_chart_types` VALUES ('153', '153 Provisions pour pensions et obligations similaires', '1', '15', '0');
INSERT INTO `0_chart_types` VALUES ('154', '154 Provisions pour restructurations.', '1', '15', '0');
INSERT INTO `0_chart_types` VALUES ('155', '155 Provisions pour impôts.', '1', '15', '0');
INSERT INTO `0_chart_types` VALUES ('156', '156 Provisions pour renouvellement des immobilisations', '1', '15', '0');
INSERT INTO `0_chart_types` VALUES ('157', '157 Provisions pour charges à répartir sur plusieurs e', '1', '15', '0');
INSERT INTO `0_chart_types` VALUES ('1572', '1572 Provisions pour gros entretien ou grandes révision', '1', '15', '0');
INSERT INTO `0_chart_types` VALUES ('158', '158 Autres provisions pour charges.', '1', '158', '0');
INSERT INTO `0_chart_types` VALUES ('1581', '1581 Provisions pour remise en état.', '1', '158', '0');
INSERT INTO `0_chart_types` VALUES ('16', '16 Emprunts et dettes assimilées.', '1', '', '0');
INSERT INTO `0_chart_types` VALUES ('161', '161 Emprunts obligataires convertibles.', '1', '16', '0');
INSERT INTO `0_chart_types` VALUES ('163', '163 Autres emprunts obligataires.', '1', '16', '0');
INSERT INTO `0_chart_types` VALUES ('164', '164 Emprunts auprès des établissements de crédit.', '1', '16', '0');
INSERT INTO `0_chart_types` VALUES ('165', '165 Dépôts et cautionnements reçus.', '1', '16', '0');
INSERT INTO `0_chart_types` VALUES ('1651', '1651 Dépôts.', '1', '165', '0');
INSERT INTO `0_chart_types` VALUES ('1655', '1655 Cautionnements.', '1', '165', '0');
INSERT INTO `0_chart_types` VALUES ('166', '166 Participation des salariés aux résultats.', '1', '16', '0');
INSERT INTO `0_chart_types` VALUES ('1661', '1661 Comptes bloqués.', '1', '166', '0');
INSERT INTO `0_chart_types` VALUES ('1662', '1662 Fonds de participation.', '1', '166', '0');
INSERT INTO `0_chart_types` VALUES ('167', '167 Emprunts et dettes assortis de conditions particul', '1', '16', '0');
INSERT INTO `0_chart_types` VALUES ('1671', '1671 Emissions de titres participatifs.', '1', '167', '0');
INSERT INTO `0_chart_types` VALUES ('1674', '1674 Avances conditionnées de l&#039;Etat.', '1', '167', '0');
INSERT INTO `0_chart_types` VALUES ('1675', '1675 Emprunts participatifs.', '1', '16', '0');
INSERT INTO `0_chart_types` VALUES ('168', '168 Autres emprunts et dettes assimilées.', '1', '168', '0');
INSERT INTO `0_chart_types` VALUES ('1681', '1681 Autres emprunts.', '1', '168', '0');
INSERT INTO `0_chart_types` VALUES ('1685', '1685 Rentes viagères capitalisées.', '1', '168', '0');
INSERT INTO `0_chart_types` VALUES ('1687', '1687 Autres dettes.', '1', '168', '0');
INSERT INTO `0_chart_types` VALUES ('1688', '1688 Intérêts courus.', '1', '168', '0');
INSERT INTO `0_chart_types` VALUES ('16881', '16881 Sur emprunts obligataires convertibles.', '1', '1688', '0');
INSERT INTO `0_chart_types` VALUES ('16884', '16884 Sur emprunts auprès des établissements de crédit.', '1', '1688', '0');
INSERT INTO `0_chart_types` VALUES ('16885', '16885 Sur dépôts et cautionnements reçus.', '1', '1688', '0');
INSERT INTO `0_chart_types` VALUES ('16886', '16886 Sur participation des salariés aux résultats.', '1', '1688', '0');
INSERT INTO `0_chart_types` VALUES ('16887', '16887 Sur emprunts et dettes assortis de conditions part', '1', '1688', '0');
INSERT INTO `0_chart_types` VALUES ('16888', '16888 Sur autres emprunts et dettes assimilées.', '1', '1688', '0');
INSERT INTO `0_chart_types` VALUES ('169', '169 Primes de remboursement des obligations.', '1', '16', '0');
INSERT INTO `0_chart_types` VALUES ('17', '17 Dettes rattachées à des participations.', '1', '', '0');
INSERT INTO `0_chart_types` VALUES ('171', '171 Dettes rattachées à des participations (groupe).', '1', '17', '0');
INSERT INTO `0_chart_types` VALUES ('174', '174 Dettes rattachées à des participation (hors groupe', '1', '17', '0');
INSERT INTO `0_chart_types` VALUES ('178', '178 Dettes rattachées à des sociétés en participation.', '1', '17', '0');
INSERT INTO `0_chart_types` VALUES ('1781', '1781 Principal.', '1', '178', '0');
INSERT INTO `0_chart_types` VALUES ('1788', '1788 Intérêts courus.', '1', '178', '0');
INSERT INTO `0_chart_types` VALUES ('18', '18 Comptes de liaison des établissements et sociétés ', '1', '', '0');
INSERT INTO `0_chart_types` VALUES ('181', '181 Compte de liaison des établissements.', '1', '18', '0');
INSERT INTO `0_chart_types` VALUES ('186', '186 Biens et prestations de services échangés entre ét', '1', '18', '0');
INSERT INTO `0_chart_types` VALUES ('187', '187 Biens et prestations de services échangés entre ét', '1', '18', '0');
INSERT INTO `0_chart_types` VALUES ('188', '188 Comptes de liaison des sociétés en participation.', '1', '18', '0');
INSERT INTO `0_chart_types` VALUES ('20', '20 Immobilisations incorporelles.', '2', '', '0');
INSERT INTO `0_chart_types` VALUES ('201', '201 Frais d&#039;établissement.', '2', '20', '0');
INSERT INTO `0_chart_types` VALUES ('2011', '2011 Frais de constitution.', '2', '201', '0');
INSERT INTO `0_chart_types` VALUES ('2012', '2012 Frais de premier établissement.', '2', '201', '0');
INSERT INTO `0_chart_types` VALUES ('20121', '20121 Frais de prospection.', '2', '2012', '0');
INSERT INTO `0_chart_types` VALUES ('20122', '20122 Frais de publicité.', '2', '2012', '0');
INSERT INTO `0_chart_types` VALUES ('2013', '2013 Frais d&#039;augmentation de capital et d&#039;opérations di', '2', '201', '0');
INSERT INTO `0_chart_types` VALUES ('203', '203 Frais de recherche et de développement.', '2', '20', '0');
INSERT INTO `0_chart_types` VALUES ('205', '205 Concessions et droits similaires, brevets, licence', '2', '20', '0');
INSERT INTO `0_chart_types` VALUES ('206', '206 Droit au bail.', '2', '20', '0');
INSERT INTO `0_chart_types` VALUES ('207', '207 Fonds commercial.', '2', '20', '0');
INSERT INTO `0_chart_types` VALUES ('208', '208 Autres immobilisations incorporelles.', '2', '20', '0');
INSERT INTO `0_chart_types` VALUES ('21', '21 Immobilisations corporelles.', '2', '', '0');
INSERT INTO `0_chart_types` VALUES ('211', '211 Terrains.', '2', '21', '0');
INSERT INTO `0_chart_types` VALUES ('2111', '2111 Terrains nus.', '2', '211', '0');
INSERT INTO `0_chart_types` VALUES ('2112', '2112 Terrains aménagés.', '2', '211', '0');
INSERT INTO `0_chart_types` VALUES ('2113', '2113 Sous-sols et sur-sols.', '2', '211', '0');
INSERT INTO `0_chart_types` VALUES ('2114', '2114 Terrains de gisements.', '2', '211', '0');
INSERT INTO `0_chart_types` VALUES ('21141', '21141 Carrières.', '2', '2114', '0');
INSERT INTO `0_chart_types` VALUES ('2115', '2115 Terrains bâtis.', '2', '211', '0');
INSERT INTO `0_chart_types` VALUES ('21151', '21151 Ensembles immobiliers industriels (A, B...).', '2', '2115', '0');
INSERT INTO `0_chart_types` VALUES ('21155', '21155 Ensembles immobiliers administratifs et commerciau', '2', '2115', '0');
INSERT INTO `0_chart_types` VALUES ('21158', '21158 Autres ensembles immobiliers.', '2', '2115', '0');
INSERT INTO `0_chart_types` VALUES ('211581', '211581 Autres ensembles immobiliers affectés aux opérations ', '2', '21158', '0');
INSERT INTO `0_chart_types` VALUES ('211588', '211588 Autres ensembles immobiliers affectés aux opérations ', '2', '21158', '0');
INSERT INTO `0_chart_types` VALUES ('213181', '213181 Autres ensembles immobiliers affectés aux opérations ', '2', '213', '0');
INSERT INTO `0_chart_types` VALUES ('213188', '213188 Autres ensembles immobiliers affectés aux opérations ', '2', '21', '0');
INSERT INTO `0_chart_types` VALUES ('2116', '2116 Compte d&#039;ordre sur immobilisations (art. 6 du décr', '2', '21', '0');
INSERT INTO `0_chart_types` VALUES ('212', '212 Agencements et aménagements de terrains.', '2', '212', '0');
INSERT INTO `0_chart_types` VALUES ('213', '213 Constructions.', '2', '213', '0');
INSERT INTO `0_chart_types` VALUES ('2131', '2131 Bâtiments.', '2', '2131', '0');
INSERT INTO `0_chart_types` VALUES ('21311', '21311 Ensembles immobiliers industriels (A, B...).', '2', '2131', '0');
INSERT INTO `0_chart_types` VALUES ('21315', '21315 Ensembles immobiliers administratifs et commerciau', '2', '21315', '0');
INSERT INTO `0_chart_types` VALUES ('21318', '21318 Autres ensembles immobiliers.', '2', '21318', '0');
INSERT INTO `0_chart_types` VALUES ('2135', '2135 Installations générales - Agencements-aménagements', '2', '213', '0');
INSERT INTO `0_chart_types` VALUES ('2138', '2138 Ouvrages d&#039;infrastructure.', '2', '213', '0');
INSERT INTO `0_chart_types` VALUES ('21381', '21381 Voies de terre.', '2', '2138', '0');
INSERT INTO `0_chart_types` VALUES ('21382', '21382 Voies de fer.', '2', '2138', '0');
INSERT INTO `0_chart_types` VALUES ('21383', '21383 Voies d&#039;eau.', '2', '2138', '0');
INSERT INTO `0_chart_types` VALUES ('21384', '21384 Barrages.', '2', '2138', '0');
INSERT INTO `0_chart_types` VALUES ('21385', '21385 Pistes d&#039;aérodrome.', '2', '2138', '0');
INSERT INTO `0_chart_types` VALUES ('214', '214 Constructions sur sol d&#039;autrui.', '2', '21', '0');
INSERT INTO `0_chart_types` VALUES ('215', '215 Installations techniques, matériel et outillage in', '2', '21', '0');
INSERT INTO `0_chart_types` VALUES ('2151', '2151 Installations complexes spécialisées.', '2', '215', '0');
INSERT INTO `0_chart_types` VALUES ('21511', '21511 Installations complexes spécialisées sur sol propre.', '2', '2151', '0');
INSERT INTO `0_chart_types` VALUES ('21514', '21514 Installations complexes spécialisées sur sol d&#039;autrui.', '2', '2151', '0');
INSERT INTO `0_chart_types` VALUES ('2153', '2153 Installations à caractère spécifique.', '2', '215', '0');
INSERT INTO `0_chart_types` VALUES ('21531', '21531 Installations à caractère spécifique sur sol propre.', '2', '2153', '0');
INSERT INTO `0_chart_types` VALUES ('21534', '21534 Installations à caractère spécifique sur sol d&#039;autrui.', '2', '2153', '0');
INSERT INTO `0_chart_types` VALUES ('2154', '2154 Matériel industriel.', '2', '215', '0');
INSERT INTO `0_chart_types` VALUES ('2155', '2155 Outillage industriel.', '2', '215', '0');
INSERT INTO `0_chart_types` VALUES ('2157', '2157 Agencements et aménagements du matériel et outilla', '2', '215', '0');
INSERT INTO `0_chart_types` VALUES ('218', '218 Autres immobilisations corporelles.', '2', '21', '0');
INSERT INTO `0_chart_types` VALUES ('2181', '2181 Installations générales, agencements, aménagements', '2', '218', '0');
INSERT INTO `0_chart_types` VALUES ('2182', '2182 Matériel de transport.', '2', '218', '0');
INSERT INTO `0_chart_types` VALUES ('2183', '2183 Matériel de bureau et matériel informatique.', '2', '218', '0');
INSERT INTO `0_chart_types` VALUES ('2184', '2184 Mobilier.', '2', '218', '0');
INSERT INTO `0_chart_types` VALUES ('2185', '2185 Cheptel.', '2', '218', '0');
INSERT INTO `0_chart_types` VALUES ('2186', '2186 Emballages récupérables.', '2', '218', '0');
INSERT INTO `0_chart_types` VALUES ('22', '22 Immobilisations mises en concession.', '2', '', '0');
INSERT INTO `0_chart_types` VALUES ('23', '23 Immobilisations en cours.', '2', '', '0');
INSERT INTO `0_chart_types` VALUES ('231', '231  Immobilisations corporelles en cours.', '2', '23', '0');
INSERT INTO `0_chart_types` VALUES ('2312', '2312 Terrains.', '2', '231', '0');
INSERT INTO `0_chart_types` VALUES ('2313', '2313 Constructions.', '2', '231', '0');
INSERT INTO `0_chart_types` VALUES ('2315', '2315 Installations techniques, matériel et outillage in', '2', '231', '0');
INSERT INTO `0_chart_types` VALUES ('2318', '2318 Autres immobilisations corporelles.', '2', '231', '0');
INSERT INTO `0_chart_types` VALUES ('232', '232 Immobilisations incorporelles en cours.', '2', '23', '0');
INSERT INTO `0_chart_types` VALUES ('237', '237 Avances et acomptes versés sur immobilisations inc', '2', '23', '0');
INSERT INTO `0_chart_types` VALUES ('238', '238 Avances et acomptes versés sur commandes d&#039;immobil', '2', '23', '0');
INSERT INTO `0_chart_types` VALUES ('2382', '2382 Terrains.', '2', '238', '0');
INSERT INTO `0_chart_types` VALUES ('2383', '2383 Constructions.', '2', '238', '0');
INSERT INTO `0_chart_types` VALUES ('2385', '2385 Installations techniques, matériel et outillage in', '2', '238', '0');
INSERT INTO `0_chart_types` VALUES ('2388', '2388 Autres immobilisations corporelles.', '2', '238', '0');
INSERT INTO `0_chart_types` VALUES ('25', '25 Entreprises liées - Parts et créances.', '2', '', '0');
INSERT INTO `0_chart_types` VALUES ('26', '26 Participations et créances rattachées à des partic', '2', '', '0');
INSERT INTO `0_chart_types` VALUES ('261', '261 Titres de participation.', '2', '26', '0');
INSERT INTO `0_chart_types` VALUES ('2611', '2611 Actions.', '2', '261', '0');
INSERT INTO `0_chart_types` VALUES ('2618', '2618 Autres titres.', '2', '261', '0');
INSERT INTO `0_chart_types` VALUES ('266', '266 Autres formes de participation.', '2', '26', '0');
INSERT INTO `0_chart_types` VALUES ('267', '267 Créances rattachées à des participations.', '2', '26', '0');
INSERT INTO `0_chart_types` VALUES ('2671', '2671 Créances rattachées à des participations (groupe).', '2', '267', '0');
INSERT INTO `0_chart_types` VALUES ('2674', '2674 Créances rattachées à des participations (hors gro', '2', '267', '0');
INSERT INTO `0_chart_types` VALUES ('2675', '2675 Versements représentatifs d&#039;apports non capitalisé', '2', '267', '0');
INSERT INTO `0_chart_types` VALUES ('2676', '2676 Avances consolidables.', '2', '267', '0');
INSERT INTO `0_chart_types` VALUES ('2677', '2677 Autres créances rattachées à des participations.', '2', '267', '0');
INSERT INTO `0_chart_types` VALUES ('2678', '2678 Intérêts courus.', '2', '267', '0');
INSERT INTO `0_chart_types` VALUES ('268', '268 Créances rattachées à des sociétés en participatio', '2', '26', '0');
INSERT INTO `0_chart_types` VALUES ('2681', '2681 Principal.', '2', '268', '0');
INSERT INTO `0_chart_types` VALUES ('2688', '2688 Intérêts courus.', '2', '268', '0');
INSERT INTO `0_chart_types` VALUES ('269', '269 Versements restant à effectuer sur titres de parti', '2', '26', '0');
INSERT INTO `0_chart_types` VALUES ('27', '27 Autres immobilisations financières.', '2', '', '0');
INSERT INTO `0_chart_types` VALUES ('271', '271 Titres immobilisés autres que les titres immobilis', '2', '27', '0');
INSERT INTO `0_chart_types` VALUES ('2711', '2711 Actions.', '2', '271', '0');
INSERT INTO `0_chart_types` VALUES ('2718', '2718 Autres titres.', '2', '271', '0');
INSERT INTO `0_chart_types` VALUES ('272', '272 Titres immobilisés (droit de créance).', '2', '27', '0');
INSERT INTO `0_chart_types` VALUES ('2721', '2721 Obligations.', '2', '272', '0');
INSERT INTO `0_chart_types` VALUES ('2722', '2722 Bons.', '2', '272', '0');
INSERT INTO `0_chart_types` VALUES ('273', '273 Titres immobilisés de l&#039;activité de portefeuille.', '2', '27', '0');
INSERT INTO `0_chart_types` VALUES ('274', '274 Prêts.', '2', '27', '0');
INSERT INTO `0_chart_types` VALUES ('2741', '2741 Prêts participatifs.', '2', '274', '0');
INSERT INTO `0_chart_types` VALUES ('2742', '2742 Prêts aux associés.', '2', '274', '0');
INSERT INTO `0_chart_types` VALUES ('2743', '2743 Prêts au personnel.', '2', '274', '0');
INSERT INTO `0_chart_types` VALUES ('2748', '2748 Autres prêts.', '2', '274', '0');
INSERT INTO `0_chart_types` VALUES ('275', '275 Dépôts et cautionnements versés.', '2', '27', '0');
INSERT INTO `0_chart_types` VALUES ('2751', '2751 Dépôts.', '2', '275', '0');
INSERT INTO `0_chart_types` VALUES ('2755', '2755 Cautionnements.', '2', '275', '0');
INSERT INTO `0_chart_types` VALUES ('276', '276 Autres créances immobilisées.', '2', '27', '0');
INSERT INTO `0_chart_types` VALUES ('2761', '2761 Créances diverses.', '2', '276', '0');
INSERT INTO `0_chart_types` VALUES ('2768', '2768 Intérêts courus.', '2', '276', '0');
INSERT INTO `0_chart_types` VALUES ('27682', '27682 Sur titres immobilisés (droit de créance).', '2', '2768', '0');
INSERT INTO `0_chart_types` VALUES ('27684', '27684 Sur prêts.', '2', '2768', '0');
INSERT INTO `0_chart_types` VALUES ('27685', '27685 Sur dépôts et cautionnements.', '2', '2768', '0');
INSERT INTO `0_chart_types` VALUES ('27688', '27688 Sur créances diverses.', '2', '2768', '0');
INSERT INTO `0_chart_types` VALUES ('277', '277 Actions propres ou parts propres.', '2', '27', '0');
INSERT INTO `0_chart_types` VALUES ('2771', '2771 Actions propres ou parts propres.', '2', '277', '0');
INSERT INTO `0_chart_types` VALUES ('2772', '2772 Actions propres ou parts propres en voie d&#039;annulat', '2', '277', '0');
INSERT INTO `0_chart_types` VALUES ('279', '279 Versements restant à effectuer sur titres immobili', '2', '27', '0');
INSERT INTO `0_chart_types` VALUES ('28', '28 Amortissements des immobilisations.', '2', '', '0');
INSERT INTO `0_chart_types` VALUES ('280', '280 Amortissements des immobilisations incorporelles.', '2', '28', '0');
INSERT INTO `0_chart_types` VALUES ('2801', '2801 Frais d&#039;établissement (même ventilation que celle ', '2', '280', '0');
INSERT INTO `0_chart_types` VALUES ('2803', '2803 Frais de recherche et de développement.', '2', '280', '0');
INSERT INTO `0_chart_types` VALUES ('2805', '2805 Concessions et droits similaires, brevets, licence', '2', '280', '0');
INSERT INTO `0_chart_types` VALUES ('2807', '2807 Fonds commercial.', '2', '280', '0');
INSERT INTO `0_chart_types` VALUES ('2808', '2808 Autres immobilisations incorporelles.', '2', '280', '0');
INSERT INTO `0_chart_types` VALUES ('281', '281 Amortissements des immobilisations corporelles.', '2', '28', '0');
INSERT INTO `0_chart_types` VALUES ('2811', '2811 Terrains de gisement.', '2', '281', '0');
INSERT INTO `0_chart_types` VALUES ('2812', '2812 Agencements, aménagements de terrains (même ventil', '2', '281', '0');
INSERT INTO `0_chart_types` VALUES ('2813', '2813 Constructions (même ventilation que celle du compt', '2', '281', '0');
INSERT INTO `0_chart_types` VALUES ('2814', '2814 Constructions sur sol d&#039;autrui (même ventilation q', '2', '281', '0');
INSERT INTO `0_chart_types` VALUES ('2815', '2815 Installations techniques, matériel et outillage in', '2', '281', '0');
INSERT INTO `0_chart_types` VALUES ('2818', '2818 Autres immobilisations corporelles (même ventilati', '2', '281', '0');
INSERT INTO `0_chart_types` VALUES ('282', '282 Amortissements des immobilisations mises en conces', '2', '28', '0');
INSERT INTO `0_chart_types` VALUES ('29', '29 Dépréciations des immobilisations.', '2', '', '0');
INSERT INTO `0_chart_types` VALUES ('290', '290 Provisions pour dépréciation des immobilisations i', '2', '29', '0');
INSERT INTO `0_chart_types` VALUES ('2905', '2905 Marques, procédés, droits et valeurs similaires.', '2', '290', '0');
INSERT INTO `0_chart_types` VALUES ('2906', '2906 Droit au bail.', '2', '290', '0');
INSERT INTO `0_chart_types` VALUES ('2907', '2907 Fonds commercial.', '2', '290', '0');
INSERT INTO `0_chart_types` VALUES ('2908', '2908 Autres immobilisations incorporelles.', '2', '290', '0');
INSERT INTO `0_chart_types` VALUES ('291', '291 Dépréciations des immobilisations corporelles (mêm', '2', '29', '0');
INSERT INTO `0_chart_types` VALUES ('2911', '2911 Terrains (autres que terrains de gisement).', '2', '291', '0');
INSERT INTO `0_chart_types` VALUES ('292', '292 Dépréciations des immobilisations mises en concess', '2', '29', '0');
INSERT INTO `0_chart_types` VALUES ('293', '293 Dépréciations des immobilisations en cours.', '2', '29', '0');
INSERT INTO `0_chart_types` VALUES ('2931', '2931 Immobilisations corporelles en cours.', '2', '293', '0');
INSERT INTO `0_chart_types` VALUES ('2932', '2932 Immobilisations incorporelles en cours.', '2', '293', '0');
INSERT INTO `0_chart_types` VALUES ('296', '296 Dépréciations des participations et créances ratta', '2', '29', '0');
INSERT INTO `0_chart_types` VALUES ('2961', '2961 Titres de participation.', '2', '296', '0');
INSERT INTO `0_chart_types` VALUES ('2966', '2966 Autres formes de participation.', '2', '296', '0');
INSERT INTO `0_chart_types` VALUES ('2967', '2967 Créances rattachées à des participations (même ven', '2', '296', '0');
INSERT INTO `0_chart_types` VALUES ('2968', '2968 Créances rattachées à des sociétés en participatio', '2', '296', '0');
INSERT INTO `0_chart_types` VALUES ('297', '297 Dépréciations des autres immobilisations financièr', '2', '29', '0');
INSERT INTO `0_chart_types` VALUES ('2971', '2971 Titres immobilisés autres que les titres immobilis', '2', '297', '0');
INSERT INTO `0_chart_types` VALUES ('2972', '2972 Titres immobilisés - droit de créance (même ventil', '2', '297', '0');
INSERT INTO `0_chart_types` VALUES ('2973', '2973 Titres immobilisés de l&#039;activité de portefeuille.', '2', '297', '0');
INSERT INTO `0_chart_types` VALUES ('2974', '2974 Prêts (même ventilation que celle du compte 274).', '2', '297', '0');
INSERT INTO `0_chart_types` VALUES ('2975', '2975 Dépôts et cautionnements versés (même ventilation ', '2', '297', '0');
INSERT INTO `0_chart_types` VALUES ('2976', '2976 Autres créances immobilisées (même ventilation que', '2', '297', '0');
INSERT INTO `0_chart_types` VALUES ('31', '31 Matières premières (et fournitures).', '3', '', '0');
INSERT INTO `0_chart_types` VALUES ('311', '311 Matière (ou groupe) A.', '3', '31', '0');
INSERT INTO `0_chart_types` VALUES ('312', '312 Matière (ou groupe) B.', '3', '31', '0');
INSERT INTO `0_chart_types` VALUES ('317', '317 Fournitures A, B, C...', '3', '31', '0');
INSERT INTO `0_chart_types` VALUES ('32', '32 Autres approvisionnements.', '3', '', '0');
INSERT INTO `0_chart_types` VALUES ('321', '321 Matières consommables.', '3', '32', '0');
INSERT INTO `0_chart_types` VALUES ('3211', '3211 Matière (ou groupe) C.', '3', '321', '0');
INSERT INTO `0_chart_types` VALUES ('3212', '3212 Matière (ou groupe) D.', '3', '321', '0');
INSERT INTO `0_chart_types` VALUES ('322', '322 Fournitures consommables.', '3', '32', '0');
INSERT INTO `0_chart_types` VALUES ('3221', '3221 Combustibles.', '3', '322', '0');
INSERT INTO `0_chart_types` VALUES ('3222', '3222 Produits d&#039;entretien.', '3', '322', '0');
INSERT INTO `0_chart_types` VALUES ('3223', '3223 Fournitures d&#039;atelier et d&#039;usine.', '3', '322', '0');
INSERT INTO `0_chart_types` VALUES ('3224', '3224 Fournitures de magasin.', '3', '322', '0');
INSERT INTO `0_chart_types` VALUES ('3225', '3225 Fournitures de bureau.', '3', '322', '0');
INSERT INTO `0_chart_types` VALUES ('326', '326 Emballages.', '3', '32', '0');
INSERT INTO `0_chart_types` VALUES ('3261', '3261 Emballages perdus.', '3', '326', '0');
INSERT INTO `0_chart_types` VALUES ('3265', '3265 Emballages récupérables non identifiables.', '3', '326', '0');
INSERT INTO `0_chart_types` VALUES ('3267', '3267 Emballages à usage mixte.', '3', '326', '0');
INSERT INTO `0_chart_types` VALUES ('33', '33 En-cours de production de biens.', '3', '', '0');
INSERT INTO `0_chart_types` VALUES ('331', '331 Produits en cours.', '3', '33', '0');
INSERT INTO `0_chart_types` VALUES ('3311', '3311 Produits en cours P 1.', '3', '331', '0');
INSERT INTO `0_chart_types` VALUES ('3312', '3312 Produits en cours P 2.', '3', '331', '0');
INSERT INTO `0_chart_types` VALUES ('335', '335 Travaux en cours.', '3', '33', '0');
INSERT INTO `0_chart_types` VALUES ('3351', '3351 Travaux en cours T 1.', '3', '335', '0');
INSERT INTO `0_chart_types` VALUES ('3352', '3352 Travaux en cours T 2.', '3', '335', '0');
INSERT INTO `0_chart_types` VALUES ('34', '34 En-cours de production de services.', '3', '', '0');
INSERT INTO `0_chart_types` VALUES ('341', '341 Etudes en cours.', '3', '34', '0');
INSERT INTO `0_chart_types` VALUES ('3411', '3411 Etude en cours E 1.', '3', '341', '0');
INSERT INTO `0_chart_types` VALUES ('3412', '3412 Etude en cours E 2.', '3', '341', '0');
INSERT INTO `0_chart_types` VALUES ('345', '345 Prestations de services en cours.', '3', '34', '0');
INSERT INTO `0_chart_types` VALUES ('3451', '3451 Prestation de services S 1.', '3', '345', '0');
INSERT INTO `0_chart_types` VALUES ('3452', '3452 Prestation de services S 2.', '3', '345', '0');
INSERT INTO `0_chart_types` VALUES ('35', '35 Stocks de produits.', '3', '', '0');
INSERT INTO `0_chart_types` VALUES ('351', '351 Produits intermédiaires.', '3', '35', '0');
INSERT INTO `0_chart_types` VALUES ('3511', '3511 Produit intermédiaire (ou groupe) A.', '3', '351', '0');
INSERT INTO `0_chart_types` VALUES ('3512', '3512 Produit intermédiaire (ou groupe) B.', '3', '351', '0');
INSERT INTO `0_chart_types` VALUES ('355', '355 Produits finis.', '3', '35', '0');
INSERT INTO `0_chart_types` VALUES ('3551', '3551 Produit fini (ou groupe) A.', '3', '355', '0');
INSERT INTO `0_chart_types` VALUES ('3552', '3552 Produit fini (ou groupe) B.', '3', '355', '0');
INSERT INTO `0_chart_types` VALUES ('358', '358 Produits résiduels (ou matières de récupération).', '3', '35', '0');
INSERT INTO `0_chart_types` VALUES ('3581', '3581 Déchets.', '3', '358', '0');
INSERT INTO `0_chart_types` VALUES ('3585', '3585 Rebuts.', '3', '358', '0');
INSERT INTO `0_chart_types` VALUES ('3586', '3586 Matières de récupération.', '3', '358', '0');
INSERT INTO `0_chart_types` VALUES ('36', '36 Stocks provenant d&#039;immobilisations.', '3', '', '0');
INSERT INTO `0_chart_types` VALUES ('37', '37 Stocks de marchandises.', '3', '', '0');
INSERT INTO `0_chart_types` VALUES ('371', '371 Marchandise (ou groupe) A.', '3', '37', '0');
INSERT INTO `0_chart_types` VALUES ('372', '372 Marchandise (ou groupe) B.', '3', '37', '0');
INSERT INTO `0_chart_types` VALUES ('38', '38 Stocks en voie d&#039;acheminement, mis en dépôt ou don', '3', '', '0');
INSERT INTO `0_chart_types` VALUES ('39', '39 Dépréciations des stocks et en-cours.', '3', '', '0');
INSERT INTO `0_chart_types` VALUES ('391', '391 Dépréciations des matières premières (et fournitur', '3', '39', '0');
INSERT INTO `0_chart_types` VALUES ('3911', '3911 Matière (ou groupe) A.', '3', '391', '0');
INSERT INTO `0_chart_types` VALUES ('3912', '3912  Matière (ou groupe) B.', '3', '391', '0');
INSERT INTO `0_chart_types` VALUES ('3917', '3917 Fourniture A, B, C...', '3', '391', '0');
INSERT INTO `0_chart_types` VALUES ('392', '392 Dépréciations des autres approvisionnements.', '3', '39', '0');
INSERT INTO `0_chart_types` VALUES ('3921', '3921 Matières consommables (même ventilation que celle ', '3', '392', '0');
INSERT INTO `0_chart_types` VALUES ('3922', '3922 Fournitures consommables (même ventilation que cel', '3', '392', '0');
INSERT INTO `0_chart_types` VALUES ('3926', '3926 Emballages (même ventilation que celle du compte 3', '3', '392', '0');
INSERT INTO `0_chart_types` VALUES ('393', '393 Dépréciations des en-cours de production de biens.', '3', '39', '0');
INSERT INTO `0_chart_types` VALUES ('3931', '3931 Produits en cours (même ventilation que celle du c', '3', '393', '0');
INSERT INTO `0_chart_types` VALUES ('3935', '3935 Travaux en cours (même ventilation que celle du co', '3', '393', '0');
INSERT INTO `0_chart_types` VALUES ('394', '394 Dépréciations des en-cours de production de servic', '3', '39', '0');
INSERT INTO `0_chart_types` VALUES ('3941', '3941 Etudes en cours (même ventilation que celle du com', '3', '394', '0');
INSERT INTO `0_chart_types` VALUES ('3945', '3945 Prestations de services en cours (même ventilation', '3', '394', '0');
INSERT INTO `0_chart_types` VALUES ('395', '395 Dépréciations des stocks de produits.', '3', '39', '0');
INSERT INTO `0_chart_types` VALUES ('3951', '3951 Produits intermédiaires (même ventilation que cell', '3', '395', '0');
INSERT INTO `0_chart_types` VALUES ('3955', '3955 Produits finis (même ventilation que celle du comp', '3', '395', '0');
INSERT INTO `0_chart_types` VALUES ('397', '397 Dépréciations des stocks de marchandises.', '3', '39', '0');
INSERT INTO `0_chart_types` VALUES ('3971', '3971 Marchandise (ou groupe) A.', '3', '397', '0');
INSERT INTO `0_chart_types` VALUES ('3972', '3972 Marchandise (ou groupe) B.', '3', '397', '0');
INSERT INTO `0_chart_types` VALUES ('40', '40 Fournisseurs et comptes rattachés.', '4', '', '0');
INSERT INTO `0_chart_types` VALUES ('401', '401 Fournisseurs.', '4', '40', '0');
INSERT INTO `0_chart_types` VALUES ('4011', '4011 Fournisseurs - Achats de biens ou de prestations d', '4', '401', '0');
INSERT INTO `0_chart_types` VALUES ('4017', '4017 Fournisseurs - Retenues de garantie.', '4', '401', '0');
INSERT INTO `0_chart_types` VALUES ('403', '403 Fournisseurs - Effets à payer.', '4', '40', '0');
INSERT INTO `0_chart_types` VALUES ('404', '404 Fournisseurs d&#039;immobilisations.', '4', '40', '0');
INSERT INTO `0_chart_types` VALUES ('4041', '4041 Fournisseurs - Achats d&#039;immobilisations.', '4', '404', '0');
INSERT INTO `0_chart_types` VALUES ('4047', '4047 Fournisseurs d&#039;immobilisations - Retenues de garan', '4', '404', '0');
INSERT INTO `0_chart_types` VALUES ('405', '405 Fournisseurs d&#039;immobilisations - Effets à payer.', '4', '40', '0');
INSERT INTO `0_chart_types` VALUES ('408', '408 Fournisseurs - Factures non parvenues.', '4', '40', '0');
INSERT INTO `0_chart_types` VALUES ('4081', '4081 Fournisseurs.', '4', '408', '0');
INSERT INTO `0_chart_types` VALUES ('4084', '4084 Fournisseurs d&#039;immobilisations.', '4', '408', '0');
INSERT INTO `0_chart_types` VALUES ('4088', '4088 Fournisseurs - Intérêts courus.', '4', '408', '0');
INSERT INTO `0_chart_types` VALUES ('409', '409 Fournisseurs débiteurs.', '4', '40', '0');
INSERT INTO `0_chart_types` VALUES ('4091', '4091 Fournisseurs - Avances et acomptes versés sur comm', '4', '409', '0');
INSERT INTO `0_chart_types` VALUES ('4096', '4096 Fournisseurs - Créances pour emballages et matérie', '4', '409', '0');
INSERT INTO `0_chart_types` VALUES ('4097', '4097 Fournisseurs - Autres avoirs.', '4', '409', '0');
INSERT INTO `0_chart_types` VALUES ('40971', '40971 Fournisseurs d&#039;exploitation.', '4', '4097', '0');
INSERT INTO `0_chart_types` VALUES ('40974', '40974 Fournisseurs d&#039;immobilisation.', '4', '4097', '0');
INSERT INTO `0_chart_types` VALUES ('4098', '4098 Rabais, remises, ristournes à obtenir et autres av', '4', '409', '0');
INSERT INTO `0_chart_types` VALUES ('41', '41 Clients et comptes rattachés.', '4', '', '0');
INSERT INTO `0_chart_types` VALUES ('410', '410 Clients et comptes rattachés.', '4', '41', '0');
INSERT INTO `0_chart_types` VALUES ('411', '411 Clients.', '4', '411', '0');
INSERT INTO `0_chart_types` VALUES ('4111', '4111 Clients - Ventes de biens ou de prestations de ser', '4', '411', '0');
INSERT INTO `0_chart_types` VALUES ('4117', '4117 Clients - Retenues de garantie.', '4', '41', '0');
INSERT INTO `0_chart_types` VALUES ('413', '413 Clients - Effets à recevoir.', '4', '41', '0');
INSERT INTO `0_chart_types` VALUES ('416', '416 Clients douteux ou litigieux.', '4', '41', '0');
INSERT INTO `0_chart_types` VALUES ('418', '418 Clients - Produits non encore facturés.', '4', '41', '0');
INSERT INTO `0_chart_types` VALUES ('4181', '4181 Clients - Factures à établir.', '4', '418', '0');
INSERT INTO `0_chart_types` VALUES ('4188', '4188 Clients - Intérêts courus.', '4', '418', '0');
INSERT INTO `0_chart_types` VALUES ('419', '419 Clients créditeurs.', '4', '41', '0');
INSERT INTO `0_chart_types` VALUES ('4191', '4191 Clients - Avances et acomptes reçus sur commandes.', '4', '419', '0');
INSERT INTO `0_chart_types` VALUES ('4196', '4196 Clients - Dettes pour emballages et matériel consi', '4', '419', '0');
INSERT INTO `0_chart_types` VALUES ('4197', '4197 Clients - Autres avoirs.', '4', '419', '0');
INSERT INTO `0_chart_types` VALUES ('4198', '4198 Rabais, remises, ristournes à accorder et autres a', '4', '419', '0');
INSERT INTO `0_chart_types` VALUES ('42', '42 Personnel et comptes rattachés.', '4', '', '0');
INSERT INTO `0_chart_types` VALUES ('421', '421 Personnel - Rémunérations dues.', '4', '42', '0');
INSERT INTO `0_chart_types` VALUES ('422', '422 Comités d&#039;entreprise, d&#039;établissement...', '4', '42', '0');
INSERT INTO `0_chart_types` VALUES ('424', '424 Participation des salariés aux résultats.', '4', '42', '0');
INSERT INTO `0_chart_types` VALUES ('4246', '4246 Réserve spéciale (C. tr. art. L 442-2).', '4', '424', '0');
INSERT INTO `0_chart_types` VALUES ('4248', '4248 Comptes courants.', '4', '424', '0');
INSERT INTO `0_chart_types` VALUES ('425', '425 Personnel - Avances et acomptes.', '4', '42', '0');
INSERT INTO `0_chart_types` VALUES ('426', '426 Personnel - Dépôts.', '4', '42', '0');
INSERT INTO `0_chart_types` VALUES ('427', '427 Personnel - Opposition.', '4', '42', '0');
INSERT INTO `0_chart_types` VALUES ('428', '428 Personnel - Charges à payer et produits à recevoir', '4', '42', '0');
INSERT INTO `0_chart_types` VALUES ('4282', '4282 Dettes provisionnées pour congés à payer.', '4', '428', '0');
INSERT INTO `0_chart_types` VALUES ('4284', '4284 Dettes provisionnées pour participation des salari', '4', '428', '0');
INSERT INTO `0_chart_types` VALUES ('4286', '4286 Autres charges à payer.', '4', '428', '0');
INSERT INTO `0_chart_types` VALUES ('4287', '4287 Produits à recevoir.', '4', '428', '0');
INSERT INTO `0_chart_types` VALUES ('43', '43 Sécurité sociale et autres organismes sociaux.', '4', '', '0');
INSERT INTO `0_chart_types` VALUES ('431', '431 Sécurité sociale.', '4', '43', '0');
INSERT INTO `0_chart_types` VALUES ('437', '437 Autres organismes sociaux.', '4', '43', '0');
INSERT INTO `0_chart_types` VALUES ('438', '438 Organismes sociaux - Charges à payer et produits à', '4', '43', '0');
INSERT INTO `0_chart_types` VALUES ('4382', '4382 Charges sociales sur congés à payer.', '4', '438', '0');
INSERT INTO `0_chart_types` VALUES ('4386', '4386 Autres charges à payer.', '4', '438', '0');
INSERT INTO `0_chart_types` VALUES ('4387', '4387 Produits à recevoir.', '4', '438', '0');
INSERT INTO `0_chart_types` VALUES ('44', '44 Etat et autres collectivités publiques.', '4', '', '0');
INSERT INTO `0_chart_types` VALUES ('441', '441 Etat - Subventions à recevoir.', '4', '44', '0');
INSERT INTO `0_chart_types` VALUES ('4411', '4411 Subventions d&#039;investissement.', '4', '441', '0');
INSERT INTO `0_chart_types` VALUES ('4417', '4417 Subventions d&#039;exploitation.', '4', '441', '0');
INSERT INTO `0_chart_types` VALUES ('4418', '4418 Subventions d&#039;équilibre.', '4', '441', '0');
INSERT INTO `0_chart_types` VALUES ('4419', '4419 Avances sur subventions.', '4', '441', '0');
INSERT INTO `0_chart_types` VALUES ('442', '442 Etat - Impôts recouvrables sur des tiers.', '4', '44', '0');
INSERT INTO `0_chart_types` VALUES ('4424', '4424 Obligataires.', '4', '442', '0');
INSERT INTO `0_chart_types` VALUES ('4425', '4425 Associés.', '4', '442', '0');
INSERT INTO `0_chart_types` VALUES ('443', '443 Opérations particulières avec l&#039;Etat, les collecti', '4', '44', '0');
INSERT INTO `0_chart_types` VALUES ('4431', '4431 Créance sur l&#039;Etat résultant de la suppression de ', '4', '443', '0');
INSERT INTO `0_chart_types` VALUES ('4438', '4438 Intérêts courus sur créance figurant au compte 443', '4', '443', '0');
INSERT INTO `0_chart_types` VALUES ('444', '444 Etat - Impôts sur les bénéfices.', '4', '44', '0');
INSERT INTO `0_chart_types` VALUES ('445', '445 Etat - Taxes sur le chiffre d&#039;affaires.', '4', '44', '0');
INSERT INTO `0_chart_types` VALUES ('4452', '4452 TVA due intracommunautaire.', '4', '445', '0');
INSERT INTO `0_chart_types` VALUES ('4455', '4455 Taxes sur le chiffre d&#039;affaires à décaisser.', '4', '445', '0');
INSERT INTO `0_chart_types` VALUES ('44551', '44551 TVA à décaisser.', '4', '4455', '0');
INSERT INTO `0_chart_types` VALUES ('44558', '44558 Taxes assimilées à la TVA.', '4', '4455', '0');
INSERT INTO `0_chart_types` VALUES ('4456', '4456 Taxes sur le chiffre d&#039;affaires déductibles.', '4', '445', '0');
INSERT INTO `0_chart_types` VALUES ('44562', '44562 TVA sur immobilisations.', '4', '4456', '0');
INSERT INTO `0_chart_types` VALUES ('44563', '44563 TVA transférée sur d&#039;autres entreprises.', '4', '4456', '0');
INSERT INTO `0_chart_types` VALUES ('44566', '44566 TVA sur autres biens et services.', '4', '4456', '0');
INSERT INTO `0_chart_types` VALUES ('44567', '44567 Crédit de TVA à reporter.', '4', '4456', '0');
INSERT INTO `0_chart_types` VALUES ('44568', '44568 Taxes assimilées à la TVA.', '4', '4456', '0');
INSERT INTO `0_chart_types` VALUES ('4457', '4457 Taxes sur le chiffre d&#039;affaires collectées par l&#039;e', '4', '445', '0');
INSERT INTO `0_chart_types` VALUES ('44571', '44571 TVA collectée.', '4', '4457', '0');
INSERT INTO `0_chart_types` VALUES ('44578', '44578 Taxes assimilées à la TVA.', '4', '4457', '0');
INSERT INTO `0_chart_types` VALUES ('4458', '4458 Taxes sur le chiffre d&#039;affaires à régulariser ou e', '4', '445', '0');
INSERT INTO `0_chart_types` VALUES ('44581', '44581 Acomptes - Régime simplifié d&#039;imposition.', '4', '4458', '0');
INSERT INTO `0_chart_types` VALUES ('44582', '44582 Acomptes - Régime de forfait.', '4', '4458', '0');
INSERT INTO `0_chart_types` VALUES ('44583', '44583 Remboursement de taxes sur le chiffre d&#039;affaires d', '4', '4458', '0');
INSERT INTO `0_chart_types` VALUES ('44584', '44584 TVA récupérée d&#039;avance.', '4', '4458', '0');
INSERT INTO `0_chart_types` VALUES ('44586', '44586 Taxes sur le chiffre d&#039;affaires sur factures non p', '4', '4458', '0');
INSERT INTO `0_chart_types` VALUES ('44587', '44587 Taxes sur le chiffre d&#039;affaires sur factures à éta', '4', '4458', '0');
INSERT INTO `0_chart_types` VALUES ('446', '446 Obligations cautionnées.', '4', '44', '0');
INSERT INTO `0_chart_types` VALUES ('4461', '4461 Obligations cautionnées.', '4', '44', '0');
INSERT INTO `0_chart_types` VALUES ('447', '447 Autres impôts, taxes et versements assimilés.', '4', '44', '0');
INSERT INTO `0_chart_types` VALUES ('448', '448 Etat - Charges à payer et produits à recevoir.', '4', '448', '0');
INSERT INTO `0_chart_types` VALUES ('4482', '4482 Charges fiscales sur congés à payer.', '4', '448', '0');
INSERT INTO `0_chart_types` VALUES ('4486', '4486 Charges à payer.', '4', '448', '0');
INSERT INTO `0_chart_types` VALUES ('4487', '4487 Produits à recevoir.', '4', '', '0');
INSERT INTO `0_chart_types` VALUES ('449', '449 Quotas d&#039;émission à restituer à l&#039;Etat.', '4', '44', '0');
INSERT INTO `0_chart_types` VALUES ('45', '45 Groupe et associés.', '4', '45', '0');
INSERT INTO `0_chart_types` VALUES ('451', '451 Groupe.', '4', '451', '0');
INSERT INTO `0_chart_types` VALUES ('455', '455 Associés - Comptes courants.', '4', '455', '0');
INSERT INTO `0_chart_types` VALUES ('4551', '4551 Principal.', '4', '45', '0');
INSERT INTO `0_chart_types` VALUES ('4558', '4558 Intérêts courus.', '4', '455', '0');
INSERT INTO `0_chart_types` VALUES ('456', '456 Associés - Opérations sur le capital.', '4', '456', '0');
INSERT INTO `0_chart_types` VALUES ('45611', '45611 Apports en nature.', '4', '4561', '0');
INSERT INTO `0_chart_types` VALUES ('45615', '45615 Apports en numéraire.', '4', '456', '0');
INSERT INTO `0_chart_types` VALUES ('4562', '4562 Apporteurs - Capital appelé, non versé.', '4', '4562', '0');
INSERT INTO `0_chart_types` VALUES ('45621', '45621 Actionnaires - Capital souscrit et appelé, non ver', '4', '4562', '0');
INSERT INTO `0_chart_types` VALUES ('45625', '45625 Associés - Capital appelé, non versé.', '4', '456', '0');
INSERT INTO `0_chart_types` VALUES ('4563', '4563 Associés - Versements reçus sur augmentation de ca', '4', '456', '0');
INSERT INTO `0_chart_types` VALUES ('4564', '4564 Associés - Versements anticipés.', '4', '456', '0');
INSERT INTO `0_chart_types` VALUES ('4566', '4566 Actionnaires défaillants.', '4', '456', '0');
INSERT INTO `0_chart_types` VALUES ('4567', '4567 Associés - Capital à rembourser.', '4', '45', '0');
INSERT INTO `0_chart_types` VALUES ('457', '457 Associés - Dividendes à payer.', '4', '45', '0');
INSERT INTO `0_chart_types` VALUES ('458', '458 Associés - Opérations faites en commun et en GIE.', '4', '458', '0');
INSERT INTO `0_chart_types` VALUES ('4581', '4581 Opérations courantes.', '4', '458', '0');
INSERT INTO `0_chart_types` VALUES ('4588', '4588 Intérêts courus.', '4', '', '0');
INSERT INTO `0_chart_types` VALUES ('46', '46 Débiteurs divers et créditeurs divers.', '4', '46', '0');
INSERT INTO `0_chart_types` VALUES ('462', '462 Créances sur cessions d&#039;immobilisations.', '4', '46', '0');
INSERT INTO `0_chart_types` VALUES ('464', '464 Dettes sur acquisition de valeurs mobilières de pl', '4', '46', '0');
INSERT INTO `0_chart_types` VALUES ('465', '465 Créances sur cessions de valeurs mobilières de pla', '4', '46', '0');
INSERT INTO `0_chart_types` VALUES ('467', '467 Autres comptes débiteurs ou créditeurs.', '4', '46', '0');
INSERT INTO `0_chart_types` VALUES ('468', '468 Divers - Charges à payer et produits à recevoir.', '4', '468', '0');
INSERT INTO `0_chart_types` VALUES ('4686', '4686 Charges à payer.', '4', '468', '0');
INSERT INTO `0_chart_types` VALUES ('4687', '4687 Produits à recevoir.', '4', '', '0');
INSERT INTO `0_chart_types` VALUES ('47', '47 Comptes transitoires ou d&#039;attente.', '4', '47', '0');
INSERT INTO `0_chart_types` VALUES ('476', '476 Différences de conversion - Actif.', '4', '47', '0');
INSERT INTO `0_chart_types` VALUES ('4761', '4761 Diminution des créances.', '4', '476', '0');
INSERT INTO `0_chart_types` VALUES ('4762', '4762 Augmentation des dettes.', '4', '476', '0');
INSERT INTO `0_chart_types` VALUES ('4768', '4768 Différences compensées par couverture de change.', '4', '476', '0');
INSERT INTO `0_chart_types` VALUES ('477', '477 Différences de conversion - Passif.', '4', '47', '0');
INSERT INTO `0_chart_types` VALUES ('4771', '4771 Augmentation des créances.', '4', '477', '0');
INSERT INTO `0_chart_types` VALUES ('4772', '4772 Diminution des dettes.', '4', '477', '0');
INSERT INTO `0_chart_types` VALUES ('4778', '4778 Différences compensées par couverture de change.', '4', '477', '0');
INSERT INTO `0_chart_types` VALUES ('478', '478 Autres comptes transitoires.', '4', '47', '0');
INSERT INTO `0_chart_types` VALUES ('48', '48 Comptes de régularisation.', '4', '', '0');
INSERT INTO `0_chart_types` VALUES ('481', '481 Charges à répartir sur plusieurs exercices.', '4', '48', '0');
INSERT INTO `0_chart_types` VALUES ('4816', '4816 Frais d&#039;émission des emprunts.', '4', '481', '0');
INSERT INTO `0_chart_types` VALUES ('486', '486 Charges constatées d&#039;avance.', '4', '48', '0');
INSERT INTO `0_chart_types` VALUES ('487', '487 Produits constatés d&#039;avance.', '4', '48', '0');
INSERT INTO `0_chart_types` VALUES ('488', '488 Comptes de répartition périodique des charges et d', '4', '48', '0');
INSERT INTO `0_chart_types` VALUES ('4886', '4886 Charges.', '4', '488', '0');
INSERT INTO `0_chart_types` VALUES ('4887', '4887 Produits.', '4', '488', '0');
INSERT INTO `0_chart_types` VALUES ('489', '489 Quotas d&#039;émission alloués par l&#039;Etat.', '4', '489', '0');
INSERT INTO `0_chart_types` VALUES ('49', '49 Dépréciations des comptes de tiers.', '4', '', '0');
INSERT INTO `0_chart_types` VALUES ('491', '491 Dépréciations des comptes de clients.', '4', '49', '0');
INSERT INTO `0_chart_types` VALUES ('495', '495 Dépréciations des comptes du groupe et des associé', '4', '49', '0');
INSERT INTO `0_chart_types` VALUES ('4951', '4951 Comptes du groupe.', '4', '495', '0');
INSERT INTO `0_chart_types` VALUES ('4955', '4955 Comptes courants des associés.', '4', '495', '0');
INSERT INTO `0_chart_types` VALUES ('4958', '4958 Opérations faites en commun et en GIE.', '4', '495', '0');
INSERT INTO `0_chart_types` VALUES ('496', '496 Dépréciations des comptes de débiteurs divers.', '4', '49', '0');
INSERT INTO `0_chart_types` VALUES ('4962', '4962 Créances sur cessions d&#039;immobilisations.', '4', '496', '0');
INSERT INTO `0_chart_types` VALUES ('4965', '4965 Créances sur cessions de valeurs mobilières de pla', '4', '496', '0');
INSERT INTO `0_chart_types` VALUES ('4967', '4967 Autres comptes débiteurs.', '4', '496', '0');
INSERT INTO `0_chart_types` VALUES ('50', '50 Valeurs mobilières de placement.', '5', '', '0');
INSERT INTO `0_chart_types` VALUES ('501', '501 Parts dans des entreprises liées.', '5', '50', '0');
INSERT INTO `0_chart_types` VALUES ('502', '502 Actions propres.', '5', '50', '0');
INSERT INTO `0_chart_types` VALUES ('503', '503 Actions.', '5', '50', '0');
INSERT INTO `0_chart_types` VALUES ('5031', '5031 Titres cotés.', '5', '503', '0');
INSERT INTO `0_chart_types` VALUES ('5035', '5035 Titres non cotés.', '5', '503', '0');
INSERT INTO `0_chart_types` VALUES ('504', '504 Autres titres conférant un droit de propriété.', '5', '50', '0');
INSERT INTO `0_chart_types` VALUES ('505', '505 Obligations et bons émis par la société et racheté', '5', '50', '0');
INSERT INTO `0_chart_types` VALUES ('506', '506 Obligations.', '5', '50', '0');
INSERT INTO `0_chart_types` VALUES ('5061', '5061 Titres cotés.', '5', '506', '0');
INSERT INTO `0_chart_types` VALUES ('5065', '5065 Titres non cotés.', '5', '506', '0');
INSERT INTO `0_chart_types` VALUES ('507', '507 Bons du Trésor et bons de caisse à court terme.', '5', '50', '0');
INSERT INTO `0_chart_types` VALUES ('508', '508 Autres valeurs mobilières de placement et autres c', '5', '50', '0');
INSERT INTO `0_chart_types` VALUES ('5081', '5081 Autres valeurs mobilières.', '5', '508', '0');
INSERT INTO `0_chart_types` VALUES ('5082', '5082 Bons de souscription.', '5', '508', '0');
INSERT INTO `0_chart_types` VALUES ('5088', '5088 Intérêts courus sur obligations, bons et valeurs assimi', '5', '508', '0');
INSERT INTO `0_chart_types` VALUES ('509', '509 Versements restant à effectuer sur valeurs mobiliè', '5', '50', '0');
INSERT INTO `0_chart_types` VALUES ('51', '51 Banques, établissements financiers et assimilés.', '5', '', '0');
INSERT INTO `0_chart_types` VALUES ('511', '511 Valeurs à l&#039;encaissement.', '5', '51', '0');
INSERT INTO `0_chart_types` VALUES ('5111', '5111 Coupons échus à l&#039;encaissement.', '5', '511', '0');
INSERT INTO `0_chart_types` VALUES ('5112', '5112 Chèques à encaisser.', '5', '511', '0');
INSERT INTO `0_chart_types` VALUES ('5113', '5113 Effets à l&#039;encaissement.', '5', '511', '0');
INSERT INTO `0_chart_types` VALUES ('5114', '5114 Effets à l&#039;escompte.', '5', '511', '0');
INSERT INTO `0_chart_types` VALUES ('512', '512 Banques.', '5', '51', '0');
INSERT INTO `0_chart_types` VALUES ('5121', '5121 Comptes en monnaie nationale.', '5', '512', '0');
INSERT INTO `0_chart_types` VALUES ('5124', '5124 Comptes en devises.', '5', '512', '0');
INSERT INTO `0_chart_types` VALUES ('514', '514 Chèques postaux.', '5', '51', '0');
INSERT INTO `0_chart_types` VALUES ('515', '515 Caisses du Trésor et des établissements public', '5', '51', '0');
INSERT INTO `0_chart_types` VALUES ('516', '516 Sociétés de bourse.', '5', '51', '0');
INSERT INTO `0_chart_types` VALUES ('517', '517 Autres organismes financiers.', '5', '51', '0');
INSERT INTO `0_chart_types` VALUES ('518', '518 Intérêts courus.', '5', '51', '0');
INSERT INTO `0_chart_types` VALUES ('5181', '5181 Intérêts courus à payer.', '5', '518', '0');
INSERT INTO `0_chart_types` VALUES ('5188', '5188 Intérêts courus à recevoir.', '5', '518', '0');
INSERT INTO `0_chart_types` VALUES ('519', '519 Concours bancaires courants.', '5', '51', '0');
INSERT INTO `0_chart_types` VALUES ('5191', '5191 Crédit de mobilisation de créances commerciales (C', '5', '519', '0');
INSERT INTO `0_chart_types` VALUES ('5193', '5193 Mobilisations de créances nées à l&#039;étranger.', '5', '519', '0');
INSERT INTO `0_chart_types` VALUES ('5198', '5198 Intérêts courus sur concours bancaires courants', '5', '519', '0');
INSERT INTO `0_chart_types` VALUES ('52', '52 Instruments de trésorerie.', '5', '', '0');
INSERT INTO `0_chart_types` VALUES ('53', '53 Caisse.', '5', '', '0');
INSERT INTO `0_chart_types` VALUES ('531', '531 Caisse siège social.', '5', '53', '0');
INSERT INTO `0_chart_types` VALUES ('5311', '5311 Caisse en monnaie nationale.', '5', '531', '0');
INSERT INTO `0_chart_types` VALUES ('5314', '5314 Caisse en devises.', '5', '531', '0');
INSERT INTO `0_chart_types` VALUES ('532', '532 Caisse succursale (ou usine) A.', '5', '53', '0');
INSERT INTO `0_chart_types` VALUES ('533', '533 Caisse succursale (ou usine) B.', '5', '53', '0');
INSERT INTO `0_chart_types` VALUES ('54', '54 Régies d&#039;avances et accréditifs.', '5', '', '0');
INSERT INTO `0_chart_types` VALUES ('58', '58 Virements internes.', '5', '', '0');
INSERT INTO `0_chart_types` VALUES ('59', '59 Dépréciations des comptes financiers.', '5', '', '0');
INSERT INTO `0_chart_types` VALUES ('590', '590 Dépréciations des valeurs mobilières de placement.', '5', '59', '0');
INSERT INTO `0_chart_types` VALUES ('5903', '5903 Actions.', '5', '590', '0');
INSERT INTO `0_chart_types` VALUES ('5904', '5904 Autres titres conférant un droit de propriété.', '5', '590', '0');
INSERT INTO `0_chart_types` VALUES ('5906', '5906 Obligations.', '5', '590', '0');
INSERT INTO `0_chart_types` VALUES ('5908', '5908 Autres valeurs mobilières de placement et créances', '5', '590', '0');
INSERT INTO `0_chart_types` VALUES ('60', '60 Achats (sauf 603)', '6', '', '0');
INSERT INTO `0_chart_types` VALUES ('601', '601 Achats stockés - Matières premières (et fourniture', '6', '60', '0');
INSERT INTO `0_chart_types` VALUES ('6011', '6011 Matière (ou groupe) A.', '6', '601', '0');
INSERT INTO `0_chart_types` VALUES ('6012', '6012 Matière (ou groupe) B.', '6', '601', '0');
INSERT INTO `0_chart_types` VALUES ('6017', '6017 Fournitures A, B, C...', '6', '601', '0');
INSERT INTO `0_chart_types` VALUES ('602', '602 Achats stockés - Autres approvisionnements.', '6', '60', '0');
INSERT INTO `0_chart_types` VALUES ('6021', '6021 Matières consommables.', '6', '602', '0');
INSERT INTO `0_chart_types` VALUES ('60211', '60211 Matière (ou groupe) C.', '6', '6021', '0');
INSERT INTO `0_chart_types` VALUES ('60212', '60212 Matière (ou groupe) D.', '6', '6021', '0');
INSERT INTO `0_chart_types` VALUES ('6022', '6022 Fournitures consommables.', '6', '602', '0');
INSERT INTO `0_chart_types` VALUES ('60221', '60221 Combustibles.', '6', '6022', '0');
INSERT INTO `0_chart_types` VALUES ('60222', '60222 Produits d&#039;entretien.', '6', '6022', '0');
INSERT INTO `0_chart_types` VALUES ('60223', '60223 Fournitures d&#039;atelier et d&#039;usine.', '6', '6022', '0');
INSERT INTO `0_chart_types` VALUES ('60224', '60224 Fournitures de magasin.', '6', '6022', '0');
INSERT INTO `0_chart_types` VALUES ('60225', '60225 Fournitures de bureau.', '6', '6022', '0');
INSERT INTO `0_chart_types` VALUES ('6026', '6026 Emballages.', '6', '602', '0');
INSERT INTO `0_chart_types` VALUES ('60261', '60261 Emballages perdus.', '6', '6026', '0');
INSERT INTO `0_chart_types` VALUES ('60265', '60265 Emballages récupérables non identifiables.', '6', '6026', '0');
INSERT INTO `0_chart_types` VALUES ('60267', '60267 Emballages à usage mixte.', '6', '6026', '0');
INSERT INTO `0_chart_types` VALUES ('603', '603 Variation des stocks (approvisionnements et marcha', '6', '60', '0');
INSERT INTO `0_chart_types` VALUES ('6031', '6031 Variation des stocks de matières premières (et fou', '6', '603', '0');
INSERT INTO `0_chart_types` VALUES ('6032', '6032 Variation des stocks des autres approvisionnements', '6', '603', '0');
INSERT INTO `0_chart_types` VALUES ('6037', '6037 Variation des stocks de marchandises.', '6', '603', '0');
INSERT INTO `0_chart_types` VALUES ('604', '604 Achats d&#039;études et prestations de services.', '6', '60', '0');
INSERT INTO `0_chart_types` VALUES ('605', '605 Achats de matériel, équipements et travaux.', '6', '60', '0');
INSERT INTO `0_chart_types` VALUES ('606', '606 Achats non stockés de matières et fournitures.', '6', '60', '0');
INSERT INTO `0_chart_types` VALUES ('6061', '6061 Fournitures non stockables (eau, énergie...).', '6', '606', '0');
INSERT INTO `0_chart_types` VALUES ('6063', '6063 Fournitures d&#039;entretien et de petit équipement.', '6', '606', '0');
INSERT INTO `0_chart_types` VALUES ('6064', '6064 Fournitures administratives.', '6', '606', '0');
INSERT INTO `0_chart_types` VALUES ('6068', '6068 Autres matières et fournitures.', '6', '606', '0');
INSERT INTO `0_chart_types` VALUES ('607', '607 Achats de marchandises.', '6', '60', '0');
INSERT INTO `0_chart_types` VALUES ('6071', '6071 Marchandise (ou groupe) A.', '6', '607', '0');
INSERT INTO `0_chart_types` VALUES ('6072', '6072 Marchandise (ou groupe) B.', '6', '607', '0');
INSERT INTO `0_chart_types` VALUES ('608', '608 Frais accessoires d&#039;achat.', '6', '60', '0');
INSERT INTO `0_chart_types` VALUES ('609', '609 Rabais, remises et ristournes obtenus sur achats.', '6', '60', '0');
INSERT INTO `0_chart_types` VALUES ('6091', '6091 Rabais, remises et ristournes obtenus sur achats de mat', '6', '609', '0');
INSERT INTO `0_chart_types` VALUES ('6092', '6092 Rabais, remises et ristournes obtenus sur achats d&#039;autr', '6', '609', '0');
INSERT INTO `0_chart_types` VALUES ('6094', '6094 Rabais, remises et ristournes obtenus sur achats d&#039;étud', '6', '609', '0');
INSERT INTO `0_chart_types` VALUES ('6095', '6095 Rabais, remises et ristournes obtenus sur achats de mat', '6', '609', '0');
INSERT INTO `0_chart_types` VALUES ('6096', '6096 Rabais, remises et ristournes obtenus sur achats d&#039;appr', '6', '609', '0');
INSERT INTO `0_chart_types` VALUES ('6097', '6097 Rabais, remises et ristournes obtenus sur achats de mar', '6', '609', '0');
INSERT INTO `0_chart_types` VALUES ('6098', '6098 Rabais, remises et ristournes non affectés.', '6', '609', '0');
INSERT INTO `0_chart_types` VALUES ('61', '61 Services extérieurs.', '6', '', '0');
INSERT INTO `0_chart_types` VALUES ('611', '611 Sous-traitance générale.', '6', '61', '0');
INSERT INTO `0_chart_types` VALUES ('612', '612 Redevances de crédit-bail.', '6', '61', '0');
INSERT INTO `0_chart_types` VALUES ('6122', '6122 Crédit-bail mobilier.', '6', '612', '0');
INSERT INTO `0_chart_types` VALUES ('6125', '6125 Crédit-bail immobilier.', '6', '612', '0');
INSERT INTO `0_chart_types` VALUES ('613', '613 Locations.', '6', '61', '0');
INSERT INTO `0_chart_types` VALUES ('6132', '6132 Locations immobilières.', '6', '613', '0');
INSERT INTO `0_chart_types` VALUES ('6135', '6135 Locations mobilières.', '6', '613', '0');
INSERT INTO `0_chart_types` VALUES ('6136', '6136 Malis sur emballages.', '6', '613', '0');
INSERT INTO `0_chart_types` VALUES ('614', '614 Charges locatives et de copropriété.', '6', '61', '0');
INSERT INTO `0_chart_types` VALUES ('615', '615 Entretien et réparations.', '6', '61', '0');
INSERT INTO `0_chart_types` VALUES ('6152', '6152 Entretien et réparations sur biens immobiliers.', '6', '615', '0');
INSERT INTO `0_chart_types` VALUES ('6155', '6155 Entretien et réparations sur biens mobiliers.', '6', '615', '0');
INSERT INTO `0_chart_types` VALUES ('6156', '6156 Maintenance.', '6', '615', '0');
INSERT INTO `0_chart_types` VALUES ('616', '616 Primes d&#039;assurance.', '6', '61', '0');
INSERT INTO `0_chart_types` VALUES ('6161', '6161 Multirisques.', '6', '616', '0');
INSERT INTO `0_chart_types` VALUES ('6162', '6162 Assurance obligatoire dommage-construction.', '6', '616', '0');
INSERT INTO `0_chart_types` VALUES ('6163', '6163 Assurance transport.', '6', '616', '0');
INSERT INTO `0_chart_types` VALUES ('61636', '61636 Assurance transport sur achats.', '6', '6163', '0');
INSERT INTO `0_chart_types` VALUES ('61637', '61637 Assurance transport sur ventes.', '6', '6163', '0');
INSERT INTO `0_chart_types` VALUES ('61638', '61638 Assurance transport sur autres biens.', '6', '6163', '0');
INSERT INTO `0_chart_types` VALUES ('6164', '6164 Risques d&#039;exploitation.', '6', '616', '0');
INSERT INTO `0_chart_types` VALUES ('6165', '6165 Insolvabilité clients.', '6', '616', '0');
INSERT INTO `0_chart_types` VALUES ('617', '617 Etudes et recherches.', '6', '61', '0');
INSERT INTO `0_chart_types` VALUES ('618', '618 Divers.', '6', '61', '0');
INSERT INTO `0_chart_types` VALUES ('6181', '6181 Documentation générale.', '6', '618', '0');
INSERT INTO `0_chart_types` VALUES ('6183', '6183 Documentation technique.', '6', '618', '0');
INSERT INTO `0_chart_types` VALUES ('6185', '6185 Frais de colloques, séminaires, conférences, formations', '6', '618', '0');
INSERT INTO `0_chart_types` VALUES ('619', '619 Rabais, remises et ristournes obtenus sur services', '6', '61', '0');
INSERT INTO `0_chart_types` VALUES ('62', '62 Autres services extérieurs.', '6', '', '0');
INSERT INTO `0_chart_types` VALUES ('621', '621 Personnel extérieur à l&#039;entreprise.', '6', '62', '0');
INSERT INTO `0_chart_types` VALUES ('6211', '6211 Personnel intérimaire.', '6', '621', '0');
INSERT INTO `0_chart_types` VALUES ('6214', '6214 Personnel détaché ou prêté à l&#039;entreprise.', '6', '621', '0');
INSERT INTO `0_chart_types` VALUES ('622', '622 Rémunérations d&#039;intermédiaires et honoraires.', '6', '62', '0');
INSERT INTO `0_chart_types` VALUES ('6221', '6221 Commissions et courtages sur achats.', '6', '622', '0');
INSERT INTO `0_chart_types` VALUES ('6222', '6222 Commissions et courtages sur ventes.', '6', '622', '0');
INSERT INTO `0_chart_types` VALUES ('6224', '6224 Rémunérations des transitaires.', '6', '622', '0');
INSERT INTO `0_chart_types` VALUES ('6225', '6225 Rémunérations d&#039;affacturage.', '6', '622', '0');
INSERT INTO `0_chart_types` VALUES ('6226', '6226 Honoraires.', '6', '622', '0');
INSERT INTO `0_chart_types` VALUES ('6227', '6227 Frais d&#039;actes et de contentieux.', '6', '622', '0');
INSERT INTO `0_chart_types` VALUES ('6228', '6228 Divers.', '6', '622', '0');
INSERT INTO `0_chart_types` VALUES ('623', '623 Publicité, publications, relations publiques.', '6', '62', '0');
INSERT INTO `0_chart_types` VALUES ('6231', '6231 Annonces et insertions.', '6', '623', '0');
INSERT INTO `0_chart_types` VALUES ('6232', '6232 Echantillons.', '6', '623', '0');
INSERT INTO `0_chart_types` VALUES ('6233', '6233 Foires et expositions.', '6', '623', '0');
INSERT INTO `0_chart_types` VALUES ('6234', '6234 Cadeaux à la clientèle.', '6', '623', '0');
INSERT INTO `0_chart_types` VALUES ('6235', '6235 Primes.', '6', '623', '0');
INSERT INTO `0_chart_types` VALUES ('6236', '6236 Catalogues et imprimés.', '6', '623', '0');
INSERT INTO `0_chart_types` VALUES ('6237', '6237 Publications.', '6', '623', '0');
INSERT INTO `0_chart_types` VALUES ('6238', '6238 Divers (pourboires, dons courants...).', '6', '623', '0');
INSERT INTO `0_chart_types` VALUES ('624', '624 Transports de biens et transports collectifs du pe', '6', '62', '0');
INSERT INTO `0_chart_types` VALUES ('6241', '6241 Transports sur achats.', '6', '624', '0');
INSERT INTO `0_chart_types` VALUES ('6242', '6242 Transports sur ventes.', '6', '624', '0');
INSERT INTO `0_chart_types` VALUES ('6243', '6243 Transports entre établissements ou chantiers.', '6', '624', '0');
INSERT INTO `0_chart_types` VALUES ('6244', '6244 Transports administratifs.', '6', '624', '0');
INSERT INTO `0_chart_types` VALUES ('6247', '6247 Transports collectifs du personnel.', '6', '624', '0');
INSERT INTO `0_chart_types` VALUES ('6248', '6248 Divers.', '6', '624', '0');
INSERT INTO `0_chart_types` VALUES ('625', '625 Déplacements, missions et réceptions.', '6', '62', '0');
INSERT INTO `0_chart_types` VALUES ('6251', '6251 Voyages et déplacements.', '6', '625', '0');
INSERT INTO `0_chart_types` VALUES ('6255', '6255 Frais de déménagement.', '6', '625', '0');
INSERT INTO `0_chart_types` VALUES ('6256', '6256 Missions.', '6', '625', '0');
INSERT INTO `0_chart_types` VALUES ('6257', '6257 Réceptions.', '6', '625', '0');
INSERT INTO `0_chart_types` VALUES ('626', '626 Frais postaux et frais de télécommunications.', '6', '62', '0');
INSERT INTO `0_chart_types` VALUES ('627', '627 Services bancaires et assimilés.', '6', '62', '0');
INSERT INTO `0_chart_types` VALUES ('6271', '6271 Frais sur titres (achats, vente, garde).', '6', '627', '0');
INSERT INTO `0_chart_types` VALUES ('6272', '6272 Commissions et frais sur émission d&#039;emprunts.', '6', '627', '0');
INSERT INTO `0_chart_types` VALUES ('6275', '6275 Frais sur effets.', '6', '627', '0');
INSERT INTO `0_chart_types` VALUES ('6276', '6276 Location de coffres.', '6', '627', '0');
INSERT INTO `0_chart_types` VALUES ('6278', '6278 Autres frais et commissions sur prestations de ser', '6', '627', '0');
INSERT INTO `0_chart_types` VALUES ('628', '628 Divers.', '6', '62', '0');
INSERT INTO `0_chart_types` VALUES ('6281', '6281 Concours divers (cotisations...).', '6', '628', '0');
INSERT INTO `0_chart_types` VALUES ('6284', '6284 Frais de recrutement de personnel.', '6', '628', '0');
INSERT INTO `0_chart_types` VALUES ('629', '629 Rabais, remises et ristournes obtenus sur autres s', '6', '62', '0');
INSERT INTO `0_chart_types` VALUES ('63', '63 Impôts, taxes et versements assimilés.', '6', '', '0');
INSERT INTO `0_chart_types` VALUES ('631', '631 Impôts, taxes et versements assimilés sur rémunération a', '6', '63', '0');
INSERT INTO `0_chart_types` VALUES ('6311', '6311 Taxe sur les salaires.', '6', '631', '0');
INSERT INTO `0_chart_types` VALUES ('6312', '6312 Taxe d&#039;apprentissage.', '6', '631', '0');
INSERT INTO `0_chart_types` VALUES ('6313', '6313 Participation des employeurs à la formation profes', '6', '631', '0');
INSERT INTO `0_chart_types` VALUES ('6314', '6314 Cotisation pour défaut d&#039;investissement obligatoir', '6', '631', '0');
INSERT INTO `0_chart_types` VALUES ('6318', '6318 Autres.', '6', '631', '0');
INSERT INTO `0_chart_types` VALUES ('633', '633 Impôts, taxes et versements assimilés sur rémunération A', '6', '63', '0');
INSERT INTO `0_chart_types` VALUES ('6331', '6331 Versement de transport.', '6', '633', '0');
INSERT INTO `0_chart_types` VALUES ('6332', '6332 Allocation logement.', '6', '633', '0');
INSERT INTO `0_chart_types` VALUES ('6333', '6333 Participation des employeurs à la formation professionn', '6', '633', '0');
INSERT INTO `0_chart_types` VALUES ('6334', '6334 Participation des employeurs à l&#039;effort de constru', '6', '633', '0');
INSERT INTO `0_chart_types` VALUES ('6335', '6335 Versements libératoires ouvrant droit à l&#039;exonérat', '6', '633', '0');
INSERT INTO `0_chart_types` VALUES ('6338', '6338 Autres.', '6', '633', '0');
INSERT INTO `0_chart_types` VALUES ('635', '635 Autres impôts, taxes et versements assimilés (admi', '6', '63', '0');
INSERT INTO `0_chart_types` VALUES ('6351', '6351 Impôts directs (sauf impôts sur les bénéfices).', '6', '635', '0');
INSERT INTO `0_chart_types` VALUES ('63511', '63511 Taxe professionnelle.', '6', '6351', '0');
INSERT INTO `0_chart_types` VALUES ('63512', '63512 Taxes foncières.', '6', '6351', '0');
INSERT INTO `0_chart_types` VALUES ('63513', '63513 Autres impôts locaux.', '6', '6351', '0');
INSERT INTO `0_chart_types` VALUES ('63514', '63514 Taxe sur les véhicules des sociétés.', '6', '6351', '0');
INSERT INTO `0_chart_types` VALUES ('6352', '6352 Taxes sur le chiffre d&#039;affaires non récupérables.', '6', '635', '0');
INSERT INTO `0_chart_types` VALUES ('6353', '6353 Impôts indirects.', '6', '635', '0');
INSERT INTO `0_chart_types` VALUES ('6354', '6354 Droits d&#039;enregistrement et de timbre.', '6', '635', '0');
INSERT INTO `0_chart_types` VALUES ('63541', '63541 Droits de mutation.', '6', '6354', '0');
INSERT INTO `0_chart_types` VALUES ('6358', '6358 Autres droits.', '6', '635', '0');
INSERT INTO `0_chart_types` VALUES ('637', '637 Autres impôts, taxes et versements assimilés (autr', '6', '63', '0');
INSERT INTO `0_chart_types` VALUES ('6371', '6371 Contribution sociale de solidarité à la charge des', '6', '637', '0');
INSERT INTO `0_chart_types` VALUES ('6372', '6372 Taxes perçues par les organismes publics internati', '6', '637', '0');
INSERT INTO `0_chart_types` VALUES ('6373', '6373 CSG/CRDS déductible IR', '6', '637', '0');
INSERT INTO `0_chart_types` VALUES ('6374', '6374 Impôts et taxes exigibles à l&#039;étranger.', '6', '637', '0');
INSERT INTO `0_chart_types` VALUES ('6378', '6378 Taxes diverses.', '6', '637', '0');
INSERT INTO `0_chart_types` VALUES ('64', '64 Charges de personnel.', '6', '', '0');
INSERT INTO `0_chart_types` VALUES ('641', '641 Rémunérations du personnel.', '6', '64', '0');
INSERT INTO `0_chart_types` VALUES ('6411', '6411 Salaires, appointements.', '6', '641', '0');
INSERT INTO `0_chart_types` VALUES ('6412', '6412 Congés payés.', '6', '641', '0');
INSERT INTO `0_chart_types` VALUES ('6413', '6413 Primes et gratifications.', '6', '641', '0');
INSERT INTO `0_chart_types` VALUES ('6414', '6414 Indemnités et avantages divers.', '6', '641', '0');
INSERT INTO `0_chart_types` VALUES ('6415', '6415 Supplément familial.', '6', '641', '0');
INSERT INTO `0_chart_types` VALUES ('644', '644 Rémunération du travail de l&#039;exploitant.', '6', '64', '0');
INSERT INTO `0_chart_types` VALUES ('6441', '6441 CSG non déductible IR', '6', '644', '0');
INSERT INTO `0_chart_types` VALUES ('645', '645 Charges de sécurité sociale et de prévoyance.', '6', '64', '0');
INSERT INTO `0_chart_types` VALUES ('6451', '6451 Cotisations à l&#039;Urssaf.', '6', '645', '0');
INSERT INTO `0_chart_types` VALUES ('6452', '6452 Cotisations aux mutuelles.', '6', '645', '0');
INSERT INTO `0_chart_types` VALUES ('6453', '6453 Cotisations aux caisses de retraites.', '6', '645', '0');
INSERT INTO `0_chart_types` VALUES ('6454', '6454 Cotisations aux Assédic.', '6', '645', '0');
INSERT INTO `0_chart_types` VALUES ('6458', '6458 Cotisations aux autres organismes sociaux.', '6', '645', '0');
INSERT INTO `0_chart_types` VALUES ('646', '646 Cotisations sociales personnelles de l&#039;exploitant.', '6', '64', '0');
INSERT INTO `0_chart_types` VALUES ('6461', '6461 Cotisations Allocations familiales TNS', '6', '646', '0');
INSERT INTO `0_chart_types` VALUES ('6462', '6462 Cotisations Maladie TNS', '6', '646', '0');
INSERT INTO `0_chart_types` VALUES ('6463', '6463 Cotisations Viellesse TNS', '6', '646', '0');
INSERT INTO `0_chart_types` VALUES ('647', '647 Autres charges sociales.', '6', '64', '0');
INSERT INTO `0_chart_types` VALUES ('6471', '6471 Prestations directes.', '6', '647', '0');
INSERT INTO `0_chart_types` VALUES ('6472', '6472 Versements aux comités d&#039;entreprise et d&#039;établisse', '6', '647', '0');
INSERT INTO `0_chart_types` VALUES ('6473', '6473 Versements aux comités d&#039;hygiène et de sécurité.', '6', '647', '0');
INSERT INTO `0_chart_types` VALUES ('6474', '6474 Versements aux autres oeuvres sociales.', '6', '647', '0');
INSERT INTO `0_chart_types` VALUES ('6475', '6475 Médecine du travail, pharmacie.', '6', '647', '0');
INSERT INTO `0_chart_types` VALUES ('648', '648 Autres charges de personnel.', '6', '64', '0');
INSERT INTO `0_chart_types` VALUES ('65', '65 Autres charges de gestion courante.', '6', '', '0');
INSERT INTO `0_chart_types` VALUES ('651', '651 Redevances pour concessions, brevets, licences, pr', '6', '65', '0');
INSERT INTO `0_chart_types` VALUES ('6511', '6511 Redevances pour concessions, brevets, licences, ma', '6', '651', '0');
INSERT INTO `0_chart_types` VALUES ('6516', '6516 Droits d&#039;auteur et de reproduction.', '6', '651', '0');
INSERT INTO `0_chart_types` VALUES ('6518', '6518 Autres droits et valeurs similaires.', '6', '651', '0');
INSERT INTO `0_chart_types` VALUES ('653', '653 Jetons de présence.', '6', '65', '0');
INSERT INTO `0_chart_types` VALUES ('654', '654 Pertes sur créances irrécouvrables.', '6', '65', '0');
INSERT INTO `0_chart_types` VALUES ('6541', '6541 Créances de l&#039;exercice.', '6', '654', '0');
INSERT INTO `0_chart_types` VALUES ('6544', '6544 Créances des exercices antérieurs.', '6', '654', '0');
INSERT INTO `0_chart_types` VALUES ('655', '655 Quotes-parts de résultat sur opérations faites en ', '6', '65', '0');
INSERT INTO `0_chart_types` VALUES ('6551', '6551 Quote-part de bénéfice transférée (comptabilité du', '6', '655', '0');
INSERT INTO `0_chart_types` VALUES ('6555', '6555 Quote-part de perte supportée (comptabilité des as', '6', '655', '0');
INSERT INTO `0_chart_types` VALUES ('658', '658 Charges diverses de gestion courante.', '6', '65', '0');
INSERT INTO `0_chart_types` VALUES ('66', '66 Charges financières.', '6', '', '0');
INSERT INTO `0_chart_types` VALUES ('661', '661 Charges d&#039;intérêts.', '6', '66', '0');
INSERT INTO `0_chart_types` VALUES ('6611', '6611 Intérêts des emprunts et dettes.', '6', '661', '0');
INSERT INTO `0_chart_types` VALUES ('66116', '66116 Intérêts des emprunts et dettes assimilées.', '6', '6611', '0');
INSERT INTO `0_chart_types` VALUES ('66117', '66117 Intérêts des dettes rattachées à des participations.', '6', '6611', '0');
INSERT INTO `0_chart_types` VALUES ('6615', '6615 Intérêts des comptes courants et des dépôts crédit', '6', '661', '0');
INSERT INTO `0_chart_types` VALUES ('6616', '6616 Intérêts bancaires et sur opérations de financemen', '6', '661', '0');
INSERT INTO `0_chart_types` VALUES ('6617', '6617 Intérêts des obligations cautionnées.', '6', '661', '0');
INSERT INTO `0_chart_types` VALUES ('6618', '6618 Intérêts des autres dettes.', '6', '661', '0');
INSERT INTO `0_chart_types` VALUES ('66181', '66181 Intérêts des dettes commerciales.', '6', '6618', '0');
INSERT INTO `0_chart_types` VALUES ('66188', '66188 Intérêts des dettes diverses.', '6', '6618', '0');
INSERT INTO `0_chart_types` VALUES ('664', '664 Pertes sur créances liées à des participations.', '6', '66', '0');
INSERT INTO `0_chart_types` VALUES ('665', '665 Escomptes accordés.', '6', '66', '0');
INSERT INTO `0_chart_types` VALUES ('666', '666 Pertes de change.', '6', '66', '0');
INSERT INTO `0_chart_types` VALUES ('667', '667 Charges nettes sur cessions de valeurs mobilières ', '6', '66', '0');
INSERT INTO `0_chart_types` VALUES ('668', '668 Autres charges financières.', '6', '66', '0');
INSERT INTO `0_chart_types` VALUES ('67', '67 Charges exceptionnelles.', '6', '', '0');
INSERT INTO `0_chart_types` VALUES ('671', '671 Charges exceptionnelles sur opérations de gestion.', '6', '67', '0');
INSERT INTO `0_chart_types` VALUES ('6711', '6711 Pénalités sur marchés (et dédits payés sur achats ', '6', '671', '0');
INSERT INTO `0_chart_types` VALUES ('6712', '6712 Pénalités, amendes fiscales et pénales.', '6', '671', '0');
INSERT INTO `0_chart_types` VALUES ('6713', '6713 Dons, libéralités.', '6', '671', '0');
INSERT INTO `0_chart_types` VALUES ('6714', '6714 Créances devenues irrécouvrables dans l&#039;exercice.', '6', '671', '0');
INSERT INTO `0_chart_types` VALUES ('6715', '6715 Subventions accordées.', '6', '671', '0');
INSERT INTO `0_chart_types` VALUES ('6717', '6717 Rappel d&#039;impôts (autres qu&#039;impôts sur les bénéfice', '6', '671', '0');
INSERT INTO `0_chart_types` VALUES ('6718', '6718 Autres charges exceptionnelles sur opérations de g', '6', '671', '0');
INSERT INTO `0_chart_types` VALUES ('672', '672 Charges sur exercices antérieurs (en cours d&#039;exerc', '6', '67', '0');
INSERT INTO `0_chart_types` VALUES ('675', '675 Valeurs comptables des éléments d&#039;actif cédés.', '6', '67', '0');
INSERT INTO `0_chart_types` VALUES ('6751', '6751 Immobilisations incorporelles.', '6', '675', '0');
INSERT INTO `0_chart_types` VALUES ('6752', '6752 Immobilisations corporelles.', '6', '675', '0');
INSERT INTO `0_chart_types` VALUES ('6756', '6756 Immobilisations financières.', '6', '675', '0');
INSERT INTO `0_chart_types` VALUES ('6758', '6758 Autres éléments d&#039;actif.', '6', '675', '0');
INSERT INTO `0_chart_types` VALUES ('678', '678 Autres charges exceptionnelles.', '6', '67', '0');
INSERT INTO `0_chart_types` VALUES ('6781', '6781 Malis provenant de clauses d&#039;indexation.', '6', '678', '0');
INSERT INTO `0_chart_types` VALUES ('6782', '6782 Lots.', '6', '678', '0');
INSERT INTO `0_chart_types` VALUES ('6783', '6783 Malis provenant du rachat par l&#039;entreprise d&#039;actio', '6', '678', '0');
INSERT INTO `0_chart_types` VALUES ('6788', '6788 Charges exceptionnelles diverses.', '6', '678', '0');
INSERT INTO `0_chart_types` VALUES ('68', '68 Dotations aux amortissements, aux dépréciations et', '6', '', '0');
INSERT INTO `0_chart_types` VALUES ('681', '681 Dotations aux amortissements, aux dépréciations et', '6', '68', '0');
INSERT INTO `0_chart_types` VALUES ('6811', '6811 Dotations aux amortissements des immobilisations i', '6', '681', '0');
INSERT INTO `0_chart_types` VALUES ('68111', '68111 Dotations aux amortissements des Immobilisations incor', '6', '6811', '0');
INSERT INTO `0_chart_types` VALUES ('68112', '68112 Dotations aux amortissements des Immobilisations corpo', '6', '6811', '0');
INSERT INTO `0_chart_types` VALUES ('6812', '6812 Dotations aux amortissements des charges d&#039;exploit', '6', '681', '0');
INSERT INTO `0_chart_types` VALUES ('6815', '6815 Dotations aux provisions d&#039;exploitation.', '6', '681', '0');
INSERT INTO `0_chart_types` VALUES ('6816', '6816 Dotations aux dépréciations des immobilisations in', '6', '681', '0');
INSERT INTO `0_chart_types` VALUES ('68161', '68161 Dotations aux dépréciations des Immobilisations incorp', '6', '6816', '0');
INSERT INTO `0_chart_types` VALUES ('68162', '68162 Dotations aux dépréciations des Immobilisations corpor', '6', '6816', '0');
INSERT INTO `0_chart_types` VALUES ('6817', '6817 Dotations aux dépréciations des actifs circulants.', '6', '681', '0');
INSERT INTO `0_chart_types` VALUES ('68173', '68173 Dotations aux dépréciations de Stocks et en-cours.', '6', '6817', '0');
INSERT INTO `0_chart_types` VALUES ('68174', '68174 Dotations aux dépréciations de Créances.', '6', '6817', '0');
INSERT INTO `0_chart_types` VALUES ('686', '686 Dotations aux amortissements, aux dépréciations et', '6', '68', '0');
INSERT INTO `0_chart_types` VALUES ('6861', '6861 Dotations aux amortissements des primes de rembour', '6', '686', '0');
INSERT INTO `0_chart_types` VALUES ('6865', '6865 Dotations aux provisions financières.', '6', '686', '0');
INSERT INTO `0_chart_types` VALUES ('6866', '6866 Dotations aux dépréciations des éléments financier', '6', '686', '0');
INSERT INTO `0_chart_types` VALUES ('68662', '68662 Immobilisations financières.', '6', '6866', '0');
INSERT INTO `0_chart_types` VALUES ('68665', '68665 Valeurs mobilières de placement.', '6', '6866', '0');
INSERT INTO `0_chart_types` VALUES ('6868', '6868 Autres dotations.', '6', '686', '0');
INSERT INTO `0_chart_types` VALUES ('687', '687 Dotations aux amortissements et aux provisions - C', '6', '68', '0');
INSERT INTO `0_chart_types` VALUES ('6871', '6871 Dotations aux amortissements exceptionnels des imm', '6', '687', '0');
INSERT INTO `0_chart_types` VALUES ('6872', '6872 Dotations aux provisions réglementées (immobilisat', '6', '687', '0');
INSERT INTO `0_chart_types` VALUES ('68725', '68725 Amortissements dérogatoires.', '6', '6872', '0');
INSERT INTO `0_chart_types` VALUES ('6873', '6873 Dotations aux provisions réglementées (stocks).', '6', '687', '0');
INSERT INTO `0_chart_types` VALUES ('6874', '6874 Dotations aux autres provisions réglementées.', '6', '687', '0');
INSERT INTO `0_chart_types` VALUES ('6875', '6875 Dotations aux provisions exceptionnelles.', '6', '687', '0');
INSERT INTO `0_chart_types` VALUES ('6876', '6876 Dotations aux dépréciations exceptionnelles.', '6', '687', '0');
INSERT INTO `0_chart_types` VALUES ('69', '69 Participation des salariés - Impôts sur les bénéfi', '6', '', '0');
INSERT INTO `0_chart_types` VALUES ('691', '691 Participation des salariés aux résultats.', '6', '69', '0');
INSERT INTO `0_chart_types` VALUES ('695', '695 Impôts sur les bénéfices.', '6', '69', '0');
INSERT INTO `0_chart_types` VALUES ('6951', '6951 Impôts dus en France.', '6', '695', '0');
INSERT INTO `0_chart_types` VALUES ('6952', '6952 Contribution additionnelle à l&#039;impôt sur les bénéf', '6', '695', '0');
INSERT INTO `0_chart_types` VALUES ('6954', '6954 Impôts dus à l&#039;étranger.', '6', '695', '0');
INSERT INTO `0_chart_types` VALUES ('696', '696 Suppléments d&#039;impôt sur les sociétés liés aux dist', '6', '69', '0');
INSERT INTO `0_chart_types` VALUES ('697', '697 Imposition forfaitaire annuelle des sociétés.', '6', '69', '0');
INSERT INTO `0_chart_types` VALUES ('698', '698 Intégration fiscale d&#039;impôt (voir n° 2855).', '6', '69', '0');
INSERT INTO `0_chart_types` VALUES ('6981', '6981 Intégration fiscale - Charges.', '6', '698', '0');
INSERT INTO `0_chart_types` VALUES ('6989', '6989 Intégration fiscale - Produits.', '6', '698', '0');
INSERT INTO `0_chart_types` VALUES ('699', '699 Produits - report en arrière des déficits.', '6', '69', '0');
INSERT INTO `0_chart_types` VALUES ('70', '70 Ventes de produits fabriqués, prestations de servi', '7', '', '0');
INSERT INTO `0_chart_types` VALUES ('701', '701 Ventes de produits finis.', '7', '70', '0');
INSERT INTO `0_chart_types` VALUES ('7011', '7011 Produit fini (ou groupe) A.', '7', '701', '0');
INSERT INTO `0_chart_types` VALUES ('7012', '7012 Produit fini (ou groupe) B.', '7', '701', '0');
INSERT INTO `0_chart_types` VALUES ('702', '702 Ventes de produits intermédiaires.', '7', '70', '0');
INSERT INTO `0_chart_types` VALUES ('703', '703 Ventes de produits résiduels.', '7', '70', '0');
INSERT INTO `0_chart_types` VALUES ('704', '704 Travaux.', '7', '70', '0');
INSERT INTO `0_chart_types` VALUES ('7041', '7041 Travaux de catégorie (ou activité) A.', '7', '704', '0');
INSERT INTO `0_chart_types` VALUES ('7042', '7042 Travaux de catégorie (ou activité) B.', '7', '704', '0');
INSERT INTO `0_chart_types` VALUES ('705', '705 Etudes.', '7', '70', '0');
INSERT INTO `0_chart_types` VALUES ('706', '706 Prestations de services.', '7', '70', '0');
INSERT INTO `0_chart_types` VALUES ('707', '707 Ventes de marchandises.', '7', '70', '0');
INSERT INTO `0_chart_types` VALUES ('7071', '7071 Marchandise (ou groupe) A.', '7', '707', '0');
INSERT INTO `0_chart_types` VALUES ('7072', '7072 Marchandise (ou groupe) B.', '7', '707', '0');
INSERT INTO `0_chart_types` VALUES ('708', '708 Produits des activités annexes.', '7', '70', '0');
INSERT INTO `0_chart_types` VALUES ('7081', '7081 Produits des services exploités dans l&#039;intérêt du perso', '7', '708', '0');
INSERT INTO `0_chart_types` VALUES ('7082', '7082 Commissions et courtages.', '7', '708', '0');
INSERT INTO `0_chart_types` VALUES ('7083', '7083 Locations diverses.', '7', '708', '0');
INSERT INTO `0_chart_types` VALUES ('7084', '7084 Mise à disposition de personnel facturée.', '7', '708', '0');
INSERT INTO `0_chart_types` VALUES ('7085', '7085 Ports et frais accessoires facturés.', '7', '708', '0');
INSERT INTO `0_chart_types` VALUES ('7086', '7086 Bonis sur reprises d&#039;emballages consignés.', '7', '708', '0');
INSERT INTO `0_chart_types` VALUES ('7087', '7087 Bonifications obtenues des clients et primes sur v', '7', '708', '0');
INSERT INTO `0_chart_types` VALUES ('7088', '7088 Autres produits d&#039;activités annexes (cessions d&#039;ap', '7', '708', '0');
INSERT INTO `0_chart_types` VALUES ('709', '709 Rabais, remises et ristournes accordés par l&#039;entre', '7', '70', '0');
INSERT INTO `0_chart_types` VALUES ('7091', '7091 - sur ventes de produits finis.', '7', '709', '0');
INSERT INTO `0_chart_types` VALUES ('7092', '7092 - sur ventes de produits intermédiaires.', '7', '709', '0');
INSERT INTO `0_chart_types` VALUES ('7094', '7094 - sur travaux.', '7', '709', '0');
INSERT INTO `0_chart_types` VALUES ('7095', '7095 - sur études.', '7', '709', '0');
INSERT INTO `0_chart_types` VALUES ('7096', '7096 - sur prestations de services.', '7', '709', '0');
INSERT INTO `0_chart_types` VALUES ('7097', '7097 - sur ventes de marchandises.', '7', '709', '0');
INSERT INTO `0_chart_types` VALUES ('7098', '7098 - sur produits des activités annexes.', '7', '709', '0');
INSERT INTO `0_chart_types` VALUES ('71', '71 Production stockée (ou déstockage).', '7', '', '0');
INSERT INTO `0_chart_types` VALUES ('713', '713 Variation des stocks (en-cours de production, prod', '7', '71', '0');
INSERT INTO `0_chart_types` VALUES ('7133', '7133 Variation des en-cours de production de biens.', '7', '713', '0');
INSERT INTO `0_chart_types` VALUES ('71331', '71331 Produits en cours.', '7', '7133', '0');
INSERT INTO `0_chart_types` VALUES ('71335', '71335 Travaux en cours.', '7', '7133', '0');
INSERT INTO `0_chart_types` VALUES ('7134', '7134 Variation des en-cours de production de services.', '7', '713', '0');
INSERT INTO `0_chart_types` VALUES ('71341', '71341 Etudes en cours.', '7', '7134', '0');
INSERT INTO `0_chart_types` VALUES ('71345', '71345 Prestations de services en cours.', '7', '7134', '0');
INSERT INTO `0_chart_types` VALUES ('7135', '7135 Variation des stocks de produits.', '7', '713', '0');
INSERT INTO `0_chart_types` VALUES ('71351', '71351 Produits intermédiaires.', '7', '7135', '0');
INSERT INTO `0_chart_types` VALUES ('71355', '71355 Produits finis.', '7', '7135', '0');
INSERT INTO `0_chart_types` VALUES ('71358', '71358 Produits résiduels.', '7', '7135', '0');
INSERT INTO `0_chart_types` VALUES ('72', '72 Production immobilisée. ', '7', '', '0');
INSERT INTO `0_chart_types` VALUES ('721', '721 Immobilisations incorporelles.', '7', '72', '0');
INSERT INTO `0_chart_types` VALUES ('722', '722 Immobilisations corporelles.', '7', '72', '0');
INSERT INTO `0_chart_types` VALUES ('74', '74 Subventions d&#039;exploitation.', '7', '', '0');
INSERT INTO `0_chart_types` VALUES ('75', '75 Autres produits de gestion courante.', '7', '', '0');
INSERT INTO `0_chart_types` VALUES ('751', '751 Redevances pour concessions, brevets, licences, ma', '7', '75', '0');
INSERT INTO `0_chart_types` VALUES ('7511', '7511 Redevances pour concessions, brevets, licences, ma', '7', '751', '0');
INSERT INTO `0_chart_types` VALUES ('7516', '7516 Droits d&#039;auteur et de reproduction.', '7', '751', '0');
INSERT INTO `0_chart_types` VALUES ('7518', '7518 Autres droits et valeurs similaires.', '7', '751', '0');
INSERT INTO `0_chart_types` VALUES ('752', '752 Revenus des immeubles non affectés aux activités p', '7', '75', '0');
INSERT INTO `0_chart_types` VALUES ('753', '753 Jetons de présence et rémunérations d&#039;administrate', '7', '75', '0');
INSERT INTO `0_chart_types` VALUES ('754', '754 Ristournes perçues des coopératives (provenant des', '7', '75', '0');
INSERT INTO `0_chart_types` VALUES ('755', '755 Quotes-parts de résultat sur opérations faites en ', '7', '75', '0');
INSERT INTO `0_chart_types` VALUES ('7551', '7551 Quote-part de perte transférée (comptabilité du gé', '7', '755', '0');
INSERT INTO `0_chart_types` VALUES ('7555', '7555 Quote-part de bénéfice attribuée (comptabilité des', '7', '755', '0');
INSERT INTO `0_chart_types` VALUES ('758', '758 Produits divers de gestion courante.', '7', '75', '0');
INSERT INTO `0_chart_types` VALUES ('76', '76 Produits financiers. ', '7', '', '0');
INSERT INTO `0_chart_types` VALUES ('761', '761 Produits de participations.', '7', '76', '0');
INSERT INTO `0_chart_types` VALUES ('7611', '7611 Revenus des titres de participation.', '7', '761', '0');
INSERT INTO `0_chart_types` VALUES ('7616', '7616 Revenus sur autres formes de participation.', '7', '761', '0');
INSERT INTO `0_chart_types` VALUES ('7617', '7617 Revenus de créances rattachées à des participation', '7', '761', '0');
INSERT INTO `0_chart_types` VALUES ('762', '762 Produits des autres immobilisations financières.', '7', '76', '0');
INSERT INTO `0_chart_types` VALUES ('7621', '7621 Revenus des titres immobilisés.', '7', '762', '0');
INSERT INTO `0_chart_types` VALUES ('7624', '7624 Revenus des prêts.', '7', '762', '0');
INSERT INTO `0_chart_types` VALUES ('7627', '7627 Revenus des créances immobilisées.', '7', '762', '0');
INSERT INTO `0_chart_types` VALUES ('763', '763 Revenus des autres créances.', '7', '76', '0');
INSERT INTO `0_chart_types` VALUES ('7631', '7631 Revenus des créances commerciales.', '7', '763', '0');
INSERT INTO `0_chart_types` VALUES ('7638', '7638 Revenus des créances diverses.', '7', '763', '0');
INSERT INTO `0_chart_types` VALUES ('764', '764 Revenus des valeurs mobilières de placement.', '7', '76', '0');
INSERT INTO `0_chart_types` VALUES ('765', '765 Escomptes obtenus.', '7', '76', '0');
INSERT INTO `0_chart_types` VALUES ('766', '766 Gains de change.', '7', '76', '0');
INSERT INTO `0_chart_types` VALUES ('767', '767 Produits nets sur cessions de valeurs mobilières de plac', '7', '76', '0');
INSERT INTO `0_chart_types` VALUES ('768', '768 Autres produits financiers.', '7', '76', '0');
INSERT INTO `0_chart_types` VALUES ('77', '77 Produits exceptionnels. ', '7', '', '0');
INSERT INTO `0_chart_types` VALUES ('771', '771 Produits exceptionnels sur opérations de gestion.', '7', '77', '0');
INSERT INTO `0_chart_types` VALUES ('7711', '7711 Dédits et pénalités perçus sur achats et sur vente', '7', '771', '0');
INSERT INTO `0_chart_types` VALUES ('7713', '7713 Libéralités perçues.', '7', '771', '0');
INSERT INTO `0_chart_types` VALUES ('7714', '7714 Rentrées sur créances amorties.', '7', '771', '0');
INSERT INTO `0_chart_types` VALUES ('7715', '7715 Subventions d&#039;équilibre.', '7', '771', '0');
INSERT INTO `0_chart_types` VALUES ('7717', '7717 Dégrèvement d&#039;impôts autres qu&#039;impôts sur les béné', '7', '771', '0');
INSERT INTO `0_chart_types` VALUES ('7718', '7718 Autres produits exceptionnels sur opérations de ge', '7', '771', '0');
INSERT INTO `0_chart_types` VALUES ('772', '772 Produits sur exercices antérieurs (en cours d&#039;exer', '7', '77', '0');
INSERT INTO `0_chart_types` VALUES ('775', '775 Produits des cessions d&#039;éléments d&#039;actif.', '7', '77', '0');
INSERT INTO `0_chart_types` VALUES ('7751', '7751 Immobilisations incorporelles.', '7', '775', '0');
INSERT INTO `0_chart_types` VALUES ('7752', '7752 Immobilisations corporelles.', '7', '775', '0');
INSERT INTO `0_chart_types` VALUES ('7756', '7756 Immobilisations financières.', '7', '775', '0');
INSERT INTO `0_chart_types` VALUES ('7758', '7758 Autres éléments d&#039;actif.', '7', '775', '0');
INSERT INTO `0_chart_types` VALUES ('777', '777 Quote-part des subventions d&#039;investissement virée ', '7', '77', '0');
INSERT INTO `0_chart_types` VALUES ('778', '778 Autres produits exceptionnels.', '7', '77', '0');
INSERT INTO `0_chart_types` VALUES ('7781', '7781 Bonis provenant de clauses d&#039;indexation.', '7', '778', '0');
INSERT INTO `0_chart_types` VALUES ('7782', '7782 Lots.', '7', '778', '0');
INSERT INTO `0_chart_types` VALUES ('7783', '7783 Bonis provenant du rachat par l&#039;entreprise d&#039;actio', '7', '778', '0');
INSERT INTO `0_chart_types` VALUES ('7788', '7788 Produits exceptionnels divers.', '7', '778', '0');
INSERT INTO `0_chart_types` VALUES ('78', '78 Reprises sur amortissements, aux dépréciations et ', '7', '', '0');
INSERT INTO `0_chart_types` VALUES ('781', '781 Reprises sur amortissements et provisions (à inscr', '7', '78', '0');
INSERT INTO `0_chart_types` VALUES ('7811', '7811 Reprises sur amortissements des immobilisations in', '7', '781', '0');
INSERT INTO `0_chart_types` VALUES ('78111', '78111 Immobilisations incorporelles.', '7', '7811', '0');
INSERT INTO `0_chart_types` VALUES ('78112', '78112 Immobilisations corporelles.', '7', '7811', '0');
INSERT INTO `0_chart_types` VALUES ('7815', '7815 Reprises sur provisions d&#039;exploitation.', '7', '781', '0');
INSERT INTO `0_chart_types` VALUES ('7816', '7816 Reprise sur dépréciations des immobilisations inco', '7', '781', '0');
INSERT INTO `0_chart_types` VALUES ('78161', '78161 Immobilisations incorporelles.', '7', '7816', '0');
INSERT INTO `0_chart_types` VALUES ('78162', '78162 Immobilisations corporelles.', '7', '7816', '0');
INSERT INTO `0_chart_types` VALUES ('7817', '7817 Reprises sur dépréciations des actifs circulants.', '7', '781', '0');
INSERT INTO `0_chart_types` VALUES ('78173', '78173 Stocks et en-cours.', '7', '7817', '0');
INSERT INTO `0_chart_types` VALUES ('78174', '78174 Créances.', '7', '7817', '0');
INSERT INTO `0_chart_types` VALUES ('786', '786 Reprises sur provisions pour risques et dépréciati', '7', '78', '0');
INSERT INTO `0_chart_types` VALUES ('7865', '7865 Reprises sur provisions financières.', '7', '786', '0');
INSERT INTO `0_chart_types` VALUES ('7866', '7866 Reprises sur dépréciations des éléments financiers', '7', '786', '0');
INSERT INTO `0_chart_types` VALUES ('78662', '78662 Immobilisations financières.', '7', '7866', '0');
INSERT INTO `0_chart_types` VALUES ('78665', '78665 Valeurs mobilières de placement.', '7', '7866', '0');
INSERT INTO `0_chart_types` VALUES ('787', '787 Reprises sur provisions et dépréciations (à inscri', '7', '78', '0');
INSERT INTO `0_chart_types` VALUES ('7872', '7872 Reprises sur provisions réglementées (immobilisati', '7', '787', '0');
INSERT INTO `0_chart_types` VALUES ('78725', '78725 Amortissements dérogatoires.', '7', '7872', '0');
INSERT INTO `0_chart_types` VALUES ('78726', '78726 Provision spéciale de réévaluation.', '7', '7872', '0');
INSERT INTO `0_chart_types` VALUES ('78727', '78727 Plus-values réinvesties.', '7', '7872', '0');
INSERT INTO `0_chart_types` VALUES ('7873', '7873 Reprises sur provisions réglementées (stocks).', '7', '787', '0');
INSERT INTO `0_chart_types` VALUES ('7874', '7874 Reprises sur autres provisions réglementées.', '7', '787', '0');
INSERT INTO `0_chart_types` VALUES ('7875', '7875 Reprises sur provisions exceptionnelles.', '7', '787', '0');
INSERT INTO `0_chart_types` VALUES ('7876', '7876 Reprises sur dépréciations exceptionnelles.', '7', '787', '0');
INSERT INTO `0_chart_types` VALUES ('79', '79 Transferts de charges. ', '7', '', '0');
INSERT INTO `0_chart_types` VALUES ('791', '791 Transferts de charges d&#039;exploitation.', '7', '79', '0');
INSERT INTO `0_chart_types` VALUES ('796', '796 Transferts de charges financières.', '7', '79', '0');
INSERT INTO `0_chart_types` VALUES ('797', '797 Transferts de charges exceptionnelles.', '7', '79', '0');
INSERT INTO `0_chart_types` VALUES ('80', '80 Engagements', '8', '', '0');
INSERT INTO `0_chart_types` VALUES ('801', '801 Engagements donnés par l’entité', '8', '80', '0');
INSERT INTO `0_chart_types` VALUES ('8011', '8011 Avals, cautions, garanties.', '8', '801', '0');
INSERT INTO `0_chart_types` VALUES ('8014', '8014 Effets circulant sous l’endos de l’entité.', '8', '801', '0');
INSERT INTO `0_chart_types` VALUES ('8016', '8016 Redevances crédit-bail restant à courir.', '8', '801', '0');
INSERT INTO `0_chart_types` VALUES ('80161', '80161 Redevances crédit-bail mobilier restant à courir.', '8', '8016', '0');
INSERT INTO `0_chart_types` VALUES ('80165', '80165 Redevances crédit-bail immobilier restant à courir.', '8', '8016', '0');
INSERT INTO `0_chart_types` VALUES ('8018', '8018 Autres engagements donnés.', '8', '801', '0');
INSERT INTO `0_chart_types` VALUES ('802', '802 Engagements reçus par l’entité', '8', '80', '0');
INSERT INTO `0_chart_types` VALUES ('8021', '8021 Avals, cautions, garanties.', '8', '802', '0');
INSERT INTO `0_chart_types` VALUES ('8024', '8024 Créances escomptées non échues.', '8', '802', '0');
INSERT INTO `0_chart_types` VALUES ('8026', '8026 Engagements reçus pour utilisation en crédit-bail.', '8', '802', '0');
INSERT INTO `0_chart_types` VALUES ('80261', '80261 Engagements reçus pour utilisation en crédit-bail mobi', '8', '8026', '0');
INSERT INTO `0_chart_types` VALUES ('80265', '80265 Engagements reçus pour utilisation en crédit-bail immo', '8', '8026', '0');
INSERT INTO `0_chart_types` VALUES ('8028', '8028 Autres engagements reçus.', '8', '802', '0');
INSERT INTO `0_chart_types` VALUES ('809', '809 Contrepartie des engagements', '8', '80', '0');
INSERT INTO `0_chart_types` VALUES ('8091', '8091 Contrepartie 801', '8', '809', '0');
INSERT INTO `0_chart_types` VALUES ('8092', '8092 Contrepartie 802', '8', '809', '0');
INSERT INTO `0_chart_types` VALUES ('88', '88 Résultat en instance d&#039;affectation.', '8', '', '0');
INSERT INTO `0_chart_types` VALUES ('89', '89 Bilan.', '8', '', '0');
INSERT INTO `0_chart_types` VALUES ('890', '890 Bilan d&#039;ouverture.', '8', '89', '0');
INSERT INTO `0_chart_types` VALUES ('891', '891 Bilan de clôture.', '8', '89', '0');


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

INSERT INTO `0_credit_status` VALUES ('1', 'Bon historique', '0', '0');
INSERT INTO `0_credit_status` VALUES ('3', 'Pas de travail supplémentaire jusqu&#039;à paiement', '1', '0');
INSERT INTO `0_credit_status` VALUES ('4', 'En liquidation', '1', '0');


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
) ENGINE=InnoDB  ;


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
) ENGINE=InnoDB  ;


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
) ENGINE=MyISAM  ;


### Data of table `0_currencies` ###

INSERT INTO `0_currencies` VALUES ('CA Dollars', 'CAD', '', '', '', '0', '1');
INSERT INTO `0_currencies` VALUES ('US Dollars', 'USD', '$', 'Etats Unis', 'Cents', '0', '1');
INSERT INTO `0_currencies` VALUES ('Euro', 'EUR', '?', 'Europe', 'Cents', '0', '1');
INSERT INTO `0_currencies` VALUES ('Pounds', 'GBP', '?', 'Anglaterre', 'Pence', '0', '1');


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
) ENGINE=MyISAM  ;


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
) ENGINE=MyISAM  ;


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
) ENGINE=InnoDB AUTO_INCREMENT=3  ;


### Data of table `0_fiscal_year` ###

INSERT INTO `0_fiscal_year` VALUES ('1', '2008-01-01', '2008-12-31', '0');
INSERT INTO `0_fiscal_year` VALUES ('2', '2009-01-01', '2009-12-31', '0');


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
) ENGINE=MyISAM  ;


### Data of table `0_item_codes` ###



### Structure of table `0_item_tax_type_exemptions` ###

DROP TABLE IF EXISTS `0_item_tax_type_exemptions`;

CREATE TABLE `0_item_tax_type_exemptions` (
  `item_tax_type_id` int(11) NOT NULL default '0',
  `tax_type_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`item_tax_type_id`,`tax_type_id`)
) ENGINE=InnoDB  ;


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
) ENGINE=InnoDB  ;


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
) ENGINE=MyISAM  ;


### Data of table `0_item_units` ###

INSERT INTO `0_item_units` VALUES ('ea.', 'Each', '0', '0');
INSERT INTO `0_item_units` VALUES ('d', 'days', '1', '0');


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

INSERT INTO `0_locations` VALUES ('DEF', 'Défaut', 'N/A', '', '', '', '', '', '0');


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

INSERT INTO `0_movement_types` VALUES ('1', 'Correction', '0');


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

INSERT INTO `0_payment_terms` VALUES ('1', 'Le 15 du mois suivant', '0', '17', '0');
INSERT INTO `0_payment_terms` VALUES ('2', 'Fin du mois suivant', '0', '30', '0');
INSERT INTO `0_payment_terms` VALUES ('3', '10 jours', '10', '0', '0');
INSERT INTO `0_payment_terms` VALUES ('4', 'Liquide uniquement', '1', '0', '0');


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
) ENGINE=MyISAM  ;


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

INSERT INTO `0_quick_entries` VALUES ('1', '1', 'Maintenance', '0', 'Amount', '0');
INSERT INTO `0_quick_entries` VALUES ('2', '1', 'Phone', '0', 'Amount', '0');
INSERT INTO `0_quick_entries` VALUES ('3', '2', 'Cash Sales', '0', 'Amount', '0');


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

INSERT INTO `0_quick_entry_lines` VALUES ('1', '1', '0', '=', '6600', '0', '0');
INSERT INTO `0_quick_entry_lines` VALUES ('2', '2', '0', '=', '6730', '0', '0');
INSERT INTO `0_quick_entry_lines` VALUES ('3', '3', '0', '=', '3000', '0', '0');


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

INSERT INTO `0_salesman` VALUES ('1', 'Assistant commercial', '', '', '', '5', '1000', '4', '0');


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

INSERT INTO `0_shippers` VALUES ('1', 'Aucune', '', '', '', '', '0');


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

INSERT INTO `0_stock_category` VALUES ('1', 'Components', '0', '1', 'each', 'B', '701100', '601100', '311000', '603100', '658000', '0', '0', '0');
INSERT INTO `0_stock_category` VALUES ('2', 'Charges', '0', '1', 'each', 'B', '701100', '601100', '311000', '603100', '658000', '0', '0', '0');
INSERT INTO `0_stock_category` VALUES ('3', 'Systems', '0', '1', 'each', 'B', '701100', '601100', '311000', '603100', '658000', '0', '0', '0');
INSERT INTO `0_stock_category` VALUES ('4', 'Services', '0', '1', 'each', 'B', '701100', '601100', '311000', '603100', '658000', '0', '0', '0');


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
) ENGINE=MyISAM  ;


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
INSERT INTO `0_sys_prefs` VALUES ('curr_default', 'setup.company', 'char', '3', 'EUR');
INSERT INTO `0_sys_prefs` VALUES ('use_dimension', 'setup.company', 'tinyint', '1', '1');
INSERT INTO `0_sys_prefs` VALUES ('f_year', 'setup.company', 'int', '11', '1');
INSERT INTO `0_sys_prefs` VALUES ('no_item_list', 'setup.company', 'tinyint', '1', '1');
INSERT INTO `0_sys_prefs` VALUES ('no_customer_list', 'setup.company', 'tinyint', '1', '1');
INSERT INTO `0_sys_prefs` VALUES ('no_supplier_list', 'setup.company', 'tinyint', '1', '1');
INSERT INTO `0_sys_prefs` VALUES ('base_sales', 'setup.company', 'int', '11', '0');
INSERT INTO `0_sys_prefs` VALUES ('time_zone', 'setup.company', 'tinyint', '1', '0');
INSERT INTO `0_sys_prefs` VALUES ('add_pct', 'setup.company', 'int', '5', '-1');
INSERT INTO `0_sys_prefs` VALUES ('round_to', 'setup.company', 'int', '5', '1');
INSERT INTO `0_sys_prefs` VALUES ('login_tout', 'setup.company', 'smallint', '6', '600');
INSERT INTO `0_sys_prefs` VALUES ('past_due_days', 'glsetup.general', 'int', '11', '30');
INSERT INTO `0_sys_prefs` VALUES ('profit_loss_year_act', 'glsetup.general', 'varchar', '15', '9990');
INSERT INTO `0_sys_prefs` VALUES ('retained_earnings_act', 'glsetup.general', 'varchar', '15', '2050');
INSERT INTO `0_sys_prefs` VALUES ('bank_charge_act', 'glsetup.general', 'varchar', '15', '1430');
INSERT INTO `0_sys_prefs` VALUES ('exchange_diff_act', 'glsetup.general', 'varchar', '15', '666000');
INSERT INTO `0_sys_prefs` VALUES ('default_credit_limit', 'glsetup.customer', 'int', '11', '1000');
INSERT INTO `0_sys_prefs` VALUES ('accumulate_shipping', 'glsetup.customer', 'tinyint', '1', '0');
INSERT INTO `0_sys_prefs` VALUES ('legal_text', 'glsetup.customer', 'tinytext', '0', NULL);
INSERT INTO `0_sys_prefs` VALUES ('freight_act', 'glsetup.customer', 'varchar', '15', '624200');
INSERT INTO `0_sys_prefs` VALUES ('debtors_act', 'glsetup.sales', 'varchar', '15', '411100');
INSERT INTO `0_sys_prefs` VALUES ('default_sales_act', 'glsetup.sales', 'varchar', '15', NULL);
INSERT INTO `0_sys_prefs` VALUES ('default_sales_discount_act', 'glsetup.sales', 'varchar', '15', '709100');
INSERT INTO `0_sys_prefs` VALUES ('default_prompt_payment_act', 'glsetup.sales', 'varchar', '15', '709100');
INSERT INTO `0_sys_prefs` VALUES ('default_delivery_required', 'glsetup.sales', 'smallint', '6', '1');
INSERT INTO `0_sys_prefs` VALUES ('default_dim_required', 'glsetup.dims', 'int', '11', '20');
INSERT INTO `0_sys_prefs` VALUES ('pyt_discount_act', 'glsetup.purchase', 'varchar', '15', '609100');
INSERT INTO `0_sys_prefs` VALUES ('creditors_act', 'glsetup.purchase', 'varchar', '15', '401100');
INSERT INTO `0_sys_prefs` VALUES ('po_over_receive', 'glsetup.purchase', 'int', '11', '10');
INSERT INTO `0_sys_prefs` VALUES ('po_over_charge', 'glsetup.purchase', 'int', '11', '10');
INSERT INTO `0_sys_prefs` VALUES ('allow_negative_stock', 'glsetup.inventory', 'tinyint', '1', '0');
INSERT INTO `0_sys_prefs` VALUES ('default_inventory_act', 'glsetup.items', 'varchar', '15', '311000');
INSERT INTO `0_sys_prefs` VALUES ('default_cogs_act', 'glsetup.items', 'varchar', '15', '601100');
INSERT INTO `0_sys_prefs` VALUES ('default_adj_act', 'glsetup.items', 'varchar', '15', '603100');
INSERT INTO `0_sys_prefs` VALUES ('default_inv_sales_act', 'glsetup.items', 'varchar', '15', '701100');
INSERT INTO `0_sys_prefs` VALUES ('default_assembly_act', 'glsetup.items', 'varchar', '15', '658000');
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
INSERT INTO `0_sys_types` VALUES ('35', '1', '1');
INSERT INTO `0_sys_types` VALUES ('40', '1', '1');
INSERT INTO `0_sys_types` VALUES ('32', '0', '1');


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

INSERT INTO `0_tax_group_items` VALUES ('7', '8', '19.6');
INSERT INTO `0_tax_group_items` VALUES ('4', '7', '19.6');
INSERT INTO `0_tax_group_items` VALUES ('5', '9', '5.5');
INSERT INTO `0_tax_group_items` VALUES ('6', '6', '19.6');


### Structure of table `0_tax_groups` ###

DROP TABLE IF EXISTS `0_tax_groups`;

CREATE TABLE `0_tax_groups` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(60) NOT NULL default '',
  `tax_shipping` tinyint(1) NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=8  ;


### Data of table `0_tax_groups` ###

INSERT INTO `0_tax_groups` VALUES ('2', 'Pas de TVA', '0', '0');
INSERT INTO `0_tax_groups` VALUES ('4', '19.6 TVA collectée', '0', '0');
INSERT INTO `0_tax_groups` VALUES ('5', '5.5 TVA déductible biens/services', '0', '0');
INSERT INTO `0_tax_groups` VALUES ('6', '19.6 TVA déductible biens/services', '0', '0');
INSERT INTO `0_tax_groups` VALUES ('7', '19.6 TVA déductiblesur immobilisations', '0', '0');


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
) ENGINE=InnoDB AUTO_INCREMENT=11  ;


### Data of table `0_tax_types` ###

INSERT INTO `0_tax_types` VALUES ('6', '19.6', '445710', '445660', '19.6 TVA déductible biens/services', '0');
INSERT INTO `0_tax_types` VALUES ('7', '19.6', '445710', '445660', '19.6 TVA collectée', '0');
INSERT INTO `0_tax_types` VALUES ('8', '19.6', '445620', '445710', '19.6 TVA déductiblesur immobilisations', '0');
INSERT INTO `0_tax_types` VALUES ('9', '5.5', '445660', '445710', '5.5 TVA déductible biens/services', '0');
INSERT INTO `0_tax_types` VALUES ('10', '0', '445660', '445710', 'Pas de TVA', '0');


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
  `startup_tab` varchar(20) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `user_id` (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2  ;


### Data of table `0_users` ###

INSERT INTO `0_users` VALUES ('1', 'admin', '5f4dcc3b5aa765d61d8327deb882cf99', 'Administrator', '2', '', 'adm@adm.com', 'en_GB', '1', '0', '2', '1', 'cool', 'A4', '2', '2', '4', '2', '1', '1', '0', '2009-02-05 15:28:03', '10', '1', '1', '1', '1', '0', 'orders', '0');


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

