# MySQL dump of database 'faupgrade' on host 'localhost'
# Backup Date and Time: 2010-08-06 13:55
# Built by FrontAccounting 2.3RC1
# http://frontaccounting.com
# Company: my company
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

INSERT INTO `0_areas` VALUES ('1', 'Australia', '0');
INSERT INTO `0_areas` VALUES ('2', 'UK', '0');


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
) ENGINE=MyISAM AUTO_INCREMENT=8  ;


### Data of table `0_bank_accounts` ###

INSERT INTO `0_bank_accounts` VALUES ('1700', '3', 'bank acct name', 'BSB 000-000 Acct 00-000-0000', 'CBA The Owner', '100 Bourke St\nMelbourne, Vic 3000', 'AUD', '0', '5', '0000-00-00 00:00:00', '0', '0');
INSERT INTO `0_bank_accounts` VALUES ('1710', '2', 'Credit Card Visa', '', 'CBA', '100 Bourke St\nMelbourne, Vic 3000', 'AUD', '0', '4', '0000-00-00 00:00:00', '0', '0');
INSERT INTO `0_bank_accounts` VALUES ('1705', '3', 'Petty Cash', '', '', NULL, 'AUD', '0', '7', '0000-00-00 00:00:00', '0', '0');


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

INSERT INTO `0_chart_class` VALUES ('11', 'Current Assets', '1', '0');
INSERT INTO `0_chart_class` VALUES ('12', 'Non-current Assets', '1', '0');
INSERT INTO `0_chart_class` VALUES ('13', 'Current Liabilities', '2', '0');
INSERT INTO `0_chart_class` VALUES ('14', 'Non-current Liabilities', '2', '0');
INSERT INTO `0_chart_class` VALUES ('15', 'Equity', '3', '0');
INSERT INTO `0_chart_class` VALUES ('16', 'Sales Income', '4', '0');
INSERT INTO `0_chart_class` VALUES ('17', 'Other Income', '4', '0');
INSERT INTO `0_chart_class` VALUES ('18', 'Cost of Goods Sold', '5', '0');
INSERT INTO `0_chart_class` VALUES ('19', 'Other expenses', '6', '0');


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

INSERT INTO `0_chart_master` VALUES ('1510', '', 'Employee Advances', '22', '0');
INSERT INTO `0_chart_master` VALUES ('20000', '', 'Accounts Payable', '31', '0');
INSERT INTO `0_chart_master` VALUES ('2599', '', 'Tax payable', '32', '0');
INSERT INTO `0_chart_master` VALUES ('30000', '', 'Opening Bal Equity', '42', '0');
INSERT INTO `0_chart_master` VALUES ('30100', '', 'Capital Stock', '42', '0');
INSERT INTO `0_chart_master` VALUES ('30200', '', 'Dividends Paid', '42', '0');
INSERT INTO `0_chart_master` VALUES ('32000', '', 'Retained Earnings', '42', '0');
INSERT INTO `0_chart_master` VALUES ('4010', 'SALES_DOM', 'Fees', '51', '0');
INSERT INTO `0_chart_master` VALUES ('4050', 'SALES_DOM', 'Sales', '51', '0');
INSERT INTO `0_chart_master` VALUES ('6040', '', 'Amortisation Expense', '69', '0');
INSERT INTO `0_chart_master` VALUES ('6110', '', 'Motor Expense', '62', '0');
INSERT INTO `0_chart_master` VALUES ('6120', '', 'Bank Service Charges', '62', '0');
INSERT INTO `0_chart_master` VALUES ('6125', '', 'Books and Publications', '62', '0');
INSERT INTO `0_chart_master` VALUES ('6130', '', 'Cash Discounts', '61', '0');
INSERT INTO `0_chart_master` VALUES ('6140', '', 'Gifts and Donations', '62', '0');
INSERT INTO `0_chart_master` VALUES ('6150', '', 'Depreciation Expense', '69', '0');
INSERT INTO `0_chart_master` VALUES ('6160', '', 'Dues and Subscriptions', '62', '0');
INSERT INTO `0_chart_master` VALUES ('6170', '', 'Computer equipment expensed', '64', '0');
INSERT INTO `0_chart_master` VALUES ('6175', '', 'Office equipment expensed', '64', '0');
INSERT INTO `0_chart_master` VALUES ('6640', '', 'Other employee expenses', '72', '0');
INSERT INTO `0_chart_master` VALUES ('6185', '', 'Professional Indemnity', '67', '0');
INSERT INTO `0_chart_master` VALUES ('6190', '', 'Sickness and accident', '67', '0');
INSERT INTO `0_chart_master` VALUES ('6420', '', 'Workcover', '67', '0');
INSERT INTO `0_chart_master` VALUES ('6610', '', 'Wages', '72', '0');
INSERT INTO `0_chart_master` VALUES ('6210', '', 'Finance Charge', '71', '0');
INSERT INTO `0_chart_master` VALUES ('6220', '', 'Loan Interest', '71', '0');
INSERT INTO `0_chart_master` VALUES ('6375', '', 'Mortgage interest', '71', '0');
INSERT INTO `0_chart_master` VALUES ('6230', '', 'Licenses and Permits', '62', '0');
INSERT INTO `0_chart_master` VALUES ('6240', '', 'Miscellaneous', '62', '0');
INSERT INTO `0_chart_master` VALUES ('6250', '', 'Postage and Delivery', '61', '0');
INSERT INTO `0_chart_master` VALUES ('6260', '', 'Printing and Reproduction', '64', '0');
INSERT INTO `0_chart_master` VALUES ('6620', '', 'Superannuation contribution', '72', '0');
INSERT INTO `0_chart_master` VALUES ('6280', '', 'Legal Fees', '62', '0');
INSERT INTO `0_chart_master` VALUES ('6290', '', 'Rent', '63', '0');
INSERT INTO `0_chart_master` VALUES ('6310', '', 'Building Repairs', '66', '0');
INSERT INTO `0_chart_master` VALUES ('6320', '', 'Computer Repairs', '66', '0');
INSERT INTO `0_chart_master` VALUES ('6330', '', 'Equipment Repairs', '66', '0');
INSERT INTO `0_chart_master` VALUES ('6750', '', 'Janitorial Exp', '66', '0');
INSERT INTO `0_chart_master` VALUES ('6334', '', 'Subscriptions', '62', '0');
INSERT INTO `0_chart_master` VALUES ('6335', '', 'Software Expense', '64', '0');
INSERT INTO `0_chart_master` VALUES ('6340', '', 'Telephone', '65', '0');
INSERT INTO `0_chart_master` VALUES ('6341', '', 'Telephone:Mobile', '65', '0');
INSERT INTO `0_chart_master` VALUES ('6345', '', 'Telephone:Fax', '65', '0');
INSERT INTO `0_chart_master` VALUES ('6390', '', 'Utilities:Council Rates', '63', '0');
INSERT INTO `0_chart_master` VALUES ('6400', '', 'Utilities:Gas', '63', '0');
INSERT INTO `0_chart_master` VALUES ('6410', '', 'Utilities:Water', '63', '0');
INSERT INTO `0_chart_master` VALUES ('6550', '', 'Office Supplies', '64', '0');
INSERT INTO `0_chart_master` VALUES ('6630', '', 'Training', '72', '0');
INSERT INTO `0_chart_master` VALUES ('6680', '', 'Recruiting', '62', '0');
INSERT INTO `0_chart_master` VALUES ('7010', '', 'Interest Income', '52', '0');
INSERT INTO `0_chart_master` VALUES ('7030', '', 'Other Income', '52', '0');
INSERT INTO `0_chart_master` VALUES ('8010', '', 'Other Expenses', '62', '0');
INSERT INTO `0_chart_master` VALUES ('6050', '', 'Exchange variance', '62', '0');
INSERT INTO `0_chart_master` VALUES ('4110', 'SALES_EXP', 'Fees - Export', '51', '0');
INSERT INTO `0_chart_master` VALUES ('4150', 'SALES_EXP', 'Sales - Export', '51', '0');
INSERT INTO `0_chart_master` VALUES ('4111', 'SALES_FRE', 'Fees - Other GST-free', '51', '0');
INSERT INTO `0_chart_master` VALUES ('4151', 'SALES_FRE', 'Sales - Other GST-free', '51', '0');
INSERT INTO `0_chart_master` VALUES ('4112', 'SALES_INP', 'Fees - Input taxed', '51', '0');
INSERT INTO `0_chart_master` VALUES ('4152', 'SALES_INP', 'Sales - Input taxed', '51', '0');
INSERT INTO `0_chart_master` VALUES ('2300', '', 'PAYG Instalments', '32', '0');
INSERT INTO `0_chart_master` VALUES ('2500', '', 'GST Clearing', '32', '0');
INSERT INTO `0_chart_master` VALUES ('2510', 'TAX_NONCAP_', 'GST paid on non-capital purchases', '32', '0');
INSERT INTO `0_chart_master` VALUES ('2520', 'TAX_NONCAP_', 'GST collected on non-capital sales', '32', '0');
INSERT INTO `0_chart_master` VALUES ('2511', 'TAX_IMP_P', 'Tax paid on import purchases (0%)', '32', '0');
INSERT INTO `0_chart_master` VALUES ('2521', 'TAX_IMP_S', 'Tax collected on export sales (0%)', '32', '0');
INSERT INTO `0_chart_master` VALUES ('2512', 'TAX_FRE_P', 'Tax paid on tax-free purchases (0%)', '32', '0');
INSERT INTO `0_chart_master` VALUES ('2522', 'TAX_FRE_S', 'Tax collected on tax-free sales (0%)', '32', '0');
INSERT INTO `0_chart_master` VALUES ('2513', 'TAX_INP_P', 'GST paid on input item purchases', '32', '0');
INSERT INTO `0_chart_master` VALUES ('2523', 'TAX_INP_S', 'GST collected on input item sales', '32', '0');
INSERT INTO `0_chart_master` VALUES ('2514', 'TAX_CAP_P', 'GST paid on capital purchases', '32', '0');
INSERT INTO `0_chart_master` VALUES ('2524', 'TAX_CAP_S', 'GST collected on capital sales', '32', '0');
INSERT INTO `0_chart_master` VALUES ('6405', '', 'Utilities:Electricity', '63', '0');
INSERT INTO `0_chart_master` VALUES ('1200', '', 'Inventory', '23', '0');
INSERT INTO `0_chart_master` VALUES ('1700', '', 'Bank Account', '21', '0');
INSERT INTO `0_chart_master` VALUES ('1705', '', 'Petty Cash', '21', '0');
INSERT INTO `0_chart_master` VALUES ('1710', '', 'Credit Card', '21', '0');
INSERT INTO `0_chart_master` VALUES ('6800', '', 'Shipping', '61', '0');
INSERT INTO `0_chart_master` VALUES ('1800', '', 'Accounts receivable', '22', '0');
INSERT INTO `0_chart_master` VALUES ('6090', '', 'Sales Discounts', '61', '0');
INSERT INTO `0_chart_master` VALUES ('6910', '', 'Assembly Costs', '61', '0');
INSERT INTO `0_chart_master` VALUES ('6920', '', 'Cost of goods sold', '61', '0');
INSERT INTO `0_chart_master` VALUES ('7040', '', 'Early payment discounts on purchases', '52', '0');
INSERT INTO `0_chart_master` VALUES ('6095', '', 'Early payment discounts (sales)', '61', '0');
INSERT INTO `0_chart_master` VALUES ('1205', '', 'Inventory adjustment', '23', '0');
INSERT INTO `0_chart_master` VALUES ('6350', '', 'Internet hosting services', '65', '0');
INSERT INTO `0_chart_master` VALUES ('6355', '', 'Internet ISP Charges', '65', '0');
INSERT INTO `0_chart_master` VALUES ('6165', '', 'Travel Expenses', '62', '0');
INSERT INTO `0_chart_master` VALUES ('6167', '', 'Medical expenses - travel related', '62', '0');
INSERT INTO `0_chart_master` VALUES ('1010', '', 'Office Equipment', '25', '0');
INSERT INTO `0_chart_master` VALUES ('1020', '', 'Computer Equipment', '25', '0');
INSERT INTO `0_chart_master` VALUES ('2525', 'TAX_NON_S', 'Tax collected on non-taxed sales (0%)', '32', '0');
INSERT INTO `0_chart_master` VALUES ('2515', 'TAX_NON_P', 'Tax paid on non-taxed purchases', '32', '0');


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
) ENGINE=MyISAM AUTO_INCREMENT=73  ;


### Data of table `0_chart_types` ###

INSERT INTO `0_chart_types` VALUES ('62', 'Other expense', '19', '', '0');
INSERT INTO `0_chart_types` VALUES ('51', 'Sales Income', '16', '', '0');
INSERT INTO `0_chart_types` VALUES ('61', 'Cost of Goods Sold', '18', '', '0');
INSERT INTO `0_chart_types` VALUES ('63', 'Rent &amp; Utilities', '19', '', '0');
INSERT INTO `0_chart_types` VALUES ('36', 'Loans', '14', '', '0');
INSERT INTO `0_chart_types` VALUES ('52', 'Other income', '17', '', '0');
INSERT INTO `0_chart_types` VALUES ('22', 'Receivables', '11', '', '0');
INSERT INTO `0_chart_types` VALUES ('21', 'Cash', '11', '', '0');
INSERT INTO `0_chart_types` VALUES ('25', 'Property, plant, equip.', '12', '', '0');
INSERT INTO `0_chart_types` VALUES ('31', 'Accounts payable', '13', '', '0');
INSERT INTO `0_chart_types` VALUES ('32', 'Tax liabilities', '13', '', '0');
INSERT INTO `0_chart_types` VALUES ('35', 'Non-current payables', '14', '', '0');
INSERT INTO `0_chart_types` VALUES ('41', 'Retained earnings', '15', '', '0');
INSERT INTO `0_chart_types` VALUES ('33', 'Other current liabilities', '13', '', '0');
INSERT INTO `0_chart_types` VALUES ('42', 'Equity', '15', '', '0');
INSERT INTO `0_chart_types` VALUES ('23', 'Inventory', '11', '', '0');
INSERT INTO `0_chart_types` VALUES ('64', 'Office supplies', '19', '', '0');
INSERT INTO `0_chart_types` VALUES ('65', 'Telephone/Internet', '19', '', '0');
INSERT INTO `0_chart_types` VALUES ('69', 'Depreciation &amp; Amortisation', '19', '', '0');
INSERT INTO `0_chart_types` VALUES ('72', 'Employee Expenses', '19', '', '0');
INSERT INTO `0_chart_types` VALUES ('66', 'Repairs', '19', '', '0');
INSERT INTO `0_chart_types` VALUES ('67', 'Insurance', '19', '', '0');
INSERT INTO `0_chart_types` VALUES ('71', 'Interest', '19', '', '0');


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
) ENGINE=InnoDB AUTO_INCREMENT=10  ;


### Data of table `0_crm_contacts` ###

INSERT INTO `0_crm_contacts` VALUES ('1', '1', 'supplier', 'general', '1');
INSERT INTO `0_crm_contacts` VALUES ('2', '2', 'supplier', 'general', '2');
INSERT INTO `0_crm_contacts` VALUES ('3', '3', 'supplier', 'general', '3');
INSERT INTO `0_crm_contacts` VALUES ('4', '4', 'supplier', 'general', '4');
INSERT INTO `0_crm_contacts` VALUES ('5', '5', 'supplier', 'general', '5');
INSERT INTO `0_crm_contacts` VALUES ('6', '6', 'supplier', 'general', '6');
INSERT INTO `0_crm_contacts` VALUES ('7', '7', 'supplier', 'general', '7');
INSERT INTO `0_crm_contacts` VALUES ('8', '8', 'supplier', 'general', '8');
INSERT INTO `0_crm_contacts` VALUES ('9', '9', 'supplier', 'general', '9');


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
) ENGINE=InnoDB AUTO_INCREMENT=10  ;


### Data of table `0_crm_persons` ###

INSERT INTO `0_crm_persons` VALUES ('1', 'Telstra Bigpond', '', NULL, NULL, '13 7663', NULL, NULL, NULL, NULL, '', '0');
INSERT INTO `0_crm_persons` VALUES ('2', 'City West Water', '', NULL, NULL, '131 691', NULL, NULL, NULL, NULL, '', '0');
INSERT INTO `0_crm_persons` VALUES ('3', 'Dymock&#039;s Books', '', NULL, NULL, '03 9663 0900', NULL, '03 9663 6901', NULL, NULL, '', '0');
INSERT INTO `0_crm_persons` VALUES ('4', 'Officeworks Superstores Pty Lt', '', NULL, NULL, '03 9412 6700', NULL, NULL, NULL, NULL, '', '0');
INSERT INTO `0_crm_persons` VALUES ('5', 'Webcity Australia Pty Ltd', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '0');
INSERT INTO `0_crm_persons` VALUES ('6', 'Origin Electricity', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '0');
INSERT INTO `0_crm_persons` VALUES ('7', 'Origin Gas', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '0');
INSERT INTO `0_crm_persons` VALUES ('8', 'Dick Smith Electronics', '', NULL, NULL, '03 9600 3914', NULL, '03 9600 4683', NULL, NULL, '', '0');
INSERT INTO `0_crm_persons` VALUES ('9', 'Ikea', '', NULL, NULL, '03 8416 5000', NULL, NULL, NULL, NULL, '', '0');


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

INSERT INTO `0_currencies` VALUES ('AU Dollars', 'AUD', '$', 'Australia', 'Cents', '0', '1');
INSERT INTO `0_currencies` VALUES ('British Pounds', 'GBP', '£', 'United Kingdom', 'Pence', '0', '1');


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
) ENGINE=MyISAM AUTO_INCREMENT=3  ;


### Data of table `0_exchange_rates` ###

INSERT INTO `0_exchange_rates` VALUES ('1', 'GBP', '2.0229', '2.0229', '2007-06-30');
INSERT INTO `0_exchange_rates` VALUES ('2', 'GBP', '2.0229', '2.0229', '2009-06-12');


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
) ENGINE=InnoDB AUTO_INCREMENT=5  ;


### Data of table `0_fiscal_year` ###

INSERT INTO `0_fiscal_year` VALUES ('2', '2009-07-01', '2010-06-30', '0');
INSERT INTO `0_fiscal_year` VALUES ('3', '2008-07-01', '2009-06-30', '0');
INSERT INTO `0_fiscal_year` VALUES ('4', '2007-07-01', '2008-06-30', '1');


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
) ENGINE=MyISAM AUTO_INCREMENT=18  ;


### Data of table `0_item_codes` ###

INSERT INTO `0_item_codes` VALUES ('1', '1', '1', 'Image processing', '4', '1', '0', '0');
INSERT INTO `0_item_codes` VALUES ('3', '3', '3', 'Web hosting/domain setup', '3', '1', '0', '0');
INSERT INTO `0_item_codes` VALUES ('4', '4', '4', 'Content Mgt System design/install', '3', '1', '0', '0');
INSERT INTO `0_item_codes` VALUES ('5', '5', '5', 'Online store setup/install', '3', '1', '0', '0');
INSERT INTO `0_item_codes` VALUES ('6', '6', '6', 'Wordpress design/install', '3', '1', '0', '0');
INSERT INTO `0_item_codes` VALUES ('8', '8', '8', 'Custom reporting devt/test', '4', '1', '0', '0');
INSERT INTO `0_item_codes` VALUES ('9', '9', '9', 'Data extract/processing', '4', '1', '0', '0');
INSERT INTO `0_item_codes` VALUES ('17', '85-C-HR', '85-C-HR', 'Consulting', '5', '1', '0', '0');


### Structure of table `0_item_tax_type_exemptions` ###

DROP TABLE IF EXISTS `0_item_tax_type_exemptions`;

CREATE TABLE `0_item_tax_type_exemptions` (
  `item_tax_type_id` int(11) NOT NULL default '0',
  `tax_type_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`item_tax_type_id`,`tax_type_id`)
) ENGINE=InnoDB  ;


### Data of table `0_item_tax_type_exemptions` ###

INSERT INTO `0_item_tax_type_exemptions` VALUES ('1', '3');
INSERT INTO `0_item_tax_type_exemptions` VALUES ('1', '4');
INSERT INTO `0_item_tax_type_exemptions` VALUES ('1', '8');
INSERT INTO `0_item_tax_type_exemptions` VALUES ('1', '10');
INSERT INTO `0_item_tax_type_exemptions` VALUES ('2', '3');
INSERT INTO `0_item_tax_type_exemptions` VALUES ('2', '4');
INSERT INTO `0_item_tax_type_exemptions` VALUES ('2', '6');
INSERT INTO `0_item_tax_type_exemptions` VALUES ('2', '8');
INSERT INTO `0_item_tax_type_exemptions` VALUES ('3', '3');
INSERT INTO `0_item_tax_type_exemptions` VALUES ('3', '4');
INSERT INTO `0_item_tax_type_exemptions` VALUES ('3', '6');
INSERT INTO `0_item_tax_type_exemptions` VALUES ('3', '8');
INSERT INTO `0_item_tax_type_exemptions` VALUES ('3', '10');
INSERT INTO `0_item_tax_type_exemptions` VALUES ('4', '3');
INSERT INTO `0_item_tax_type_exemptions` VALUES ('4', '6');
INSERT INTO `0_item_tax_type_exemptions` VALUES ('4', '8');
INSERT INTO `0_item_tax_type_exemptions` VALUES ('4', '10');
INSERT INTO `0_item_tax_type_exemptions` VALUES ('5', '4');
INSERT INTO `0_item_tax_type_exemptions` VALUES ('5', '6');
INSERT INTO `0_item_tax_type_exemptions` VALUES ('5', '8');
INSERT INTO `0_item_tax_type_exemptions` VALUES ('5', '10');


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

INSERT INTO `0_item_tax_types` VALUES ('1', 'Taxed GST', '0', '0');
INSERT INTO `0_item_tax_types` VALUES ('2', 'Tax free N-T', '0', '0');
INSERT INTO `0_item_tax_types` VALUES ('3', 'Taxed CAP', '0', '0');
INSERT INTO `0_item_tax_types` VALUES ('4', 'Tax FRE', '0', '0');
INSERT INTO `0_item_tax_types` VALUES ('5', 'Tax free EXP', '0', '0');


### Structure of table `0_item_units` ###

DROP TABLE IF EXISTS `0_item_units`;

CREATE TABLE `0_item_units` (
  `abbr` varchar(20) NOT NULL default '',
  `name` varchar(40) NOT NULL default '',
  `decimals` tinyint(2) NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`abbr`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM  ;


### Data of table `0_item_units` ###

INSERT INTO `0_item_units` VALUES ('', 'Items', '0', '0');
INSERT INTO `0_item_units` VALUES ('hrs', 'Hours', '1', '0');
INSERT INTO `0_item_units` VALUES ('days', 'Days', '1', '0');


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

INSERT INTO `0_locations` VALUES ('MEL', 'Melbourne', '1 Smith St\nSmithtown\nVic 3000', '+61 3 9555 5555', '', '', 'info@mycompany.com.au', 'Pete', '0');


### Structure of table `0_movement_types` ###

DROP TABLE IF EXISTS `0_movement_types`;

CREATE TABLE `0_movement_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=3  ;


### Data of table `0_movement_types` ###

INSERT INTO `0_movement_types` VALUES ('1', 'Adjustment', '0');
INSERT INTO `0_movement_types` VALUES ('2', 'Initial', '0');


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
) ENGINE=MyISAM AUTO_INCREMENT=7  ;


### Data of table `0_payment_terms` ###

INSERT INTO `0_payment_terms` VALUES ('1', 'Due 15th Of the Following Month', '0', '17', '0');
INSERT INTO `0_payment_terms` VALUES ('2', 'Due By End Of The Following Month', '0', '30', '0');
INSERT INTO `0_payment_terms` VALUES ('4', 'Cash Only', '1', '0', '0');
INSERT INTO `0_payment_terms` VALUES ('5', '50% deposit, 50% 14 days job end', '0', '30', '0');
INSERT INTO `0_payment_terms` VALUES ('6', '14 days', '14', '0', '0');


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
) ENGINE=MyISAM AUTO_INCREMENT=18  ;


### Data of table `0_prices` ###

INSERT INTO `0_prices` VALUES ('1', '1', '1', 'AUD', '1');
INSERT INTO `0_prices` VALUES ('4', '8', '1', 'AUD', '1');
INSERT INTO `0_prices` VALUES ('5', '9', '1', 'AUD', '1');
INSERT INTO `0_prices` VALUES ('6', '3', '1', 'AUD', '1');
INSERT INTO `0_prices` VALUES ('7', '4', '1', 'AUD', '1');
INSERT INTO `0_prices` VALUES ('8', '5', '1', 'AUD', '1');
INSERT INTO `0_prices` VALUES ('9', '6', '1', 'AUD', '1');


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
) ENGINE=MyISAM AUTO_INCREMENT=16  ;


### Data of table `0_quick_entries` ###

INSERT INTO `0_quick_entries` VALUES ('4', '1', 'Internet ADSL monthly', '59.95', 'Monthly Charge', '0');
INSERT INTO `0_quick_entries` VALUES ('9', '1', 'Mobile bill', '29.19', 'Base Amount', '0');
INSERT INTO `0_quick_entries` VALUES ('8', '1', 'Office supplies purchase', '0', 'Amount', '0');
INSERT INTO `0_quick_entries` VALUES ('10', '1', 'Gas', '0', 'Base Amount', '0');
INSERT INTO `0_quick_entries` VALUES ('11', '1', 'Electricity', '0', 'Base Amount', '0');
INSERT INTO `0_quick_entries` VALUES ('12', '1', 'Water', '0', 'Base Amount', '0');
INSERT INTO `0_quick_entries` VALUES ('14', '1', 'Office equip (capex)', '0', 'Base Amount', '0');
INSERT INTO `0_quick_entries` VALUES ('15', '1', 'Computer book/magazines', '0', 'Base Amount', '0');


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
) ENGINE=MyISAM AUTO_INCREMENT=28  ;


### Data of table `0_quick_entry_lines` ###

INSERT INTO `0_quick_entry_lines` VALUES ('7', '4', '0', 't-', '6', '0', '0');
INSERT INTO `0_quick_entry_lines` VALUES ('8', '4', '0', '=', '6355', '0', '0');
INSERT INTO `0_quick_entry_lines` VALUES ('13', '8', '0', '=', '6550', '0', '0');
INSERT INTO `0_quick_entry_lines` VALUES ('12', '8', '0', 't-', '6', '0', '0');
INSERT INTO `0_quick_entry_lines` VALUES ('15', '9', '0', 't-', '1', '0', '0');
INSERT INTO `0_quick_entry_lines` VALUES ('16', '9', '0', '=', '6341', '0', '0');
INSERT INTO `0_quick_entry_lines` VALUES ('18', '10', '0', 't-', '6', '0', '0');
INSERT INTO `0_quick_entry_lines` VALUES ('19', '10', '0', '=', '6400', '0', '0');
INSERT INTO `0_quick_entry_lines` VALUES ('20', '11', '0', 't-', '6', '0', '0');
INSERT INTO `0_quick_entry_lines` VALUES ('21', '11', '0', '=', '6405', '0', '0');
INSERT INTO `0_quick_entry_lines` VALUES ('22', '12', '0', 't-', '4', '0', '0');
INSERT INTO `0_quick_entry_lines` VALUES ('23', '12', '0', '=', '6410', '0', '0');
INSERT INTO `0_quick_entry_lines` VALUES ('24', '14', '0', 't-', '10', '0', '0');
INSERT INTO `0_quick_entry_lines` VALUES ('25', '14', '0', '=', '1010', '0', '0');
INSERT INTO `0_quick_entry_lines` VALUES ('26', '15', '0', 't-', '6', '0', '0');
INSERT INTO `0_quick_entry_lines` VALUES ('27', '15', '0', '=', '6125', '0', '0');


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

INSERT INTO `0_sales_pos` VALUES ('1', 'DEF', '1', '1', 'MEL', '5', '0');


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

INSERT INTO `0_sales_types` VALUES ('1', 'Retail', '1', '1', '0');
INSERT INTO `0_sales_types` VALUES ('2', 'Wholesale', '1', '1', '0');


### Structure of table `0_salesman` ###

DROP TABLE IF EXISTS `0_salesman`;

CREATE TABLE `0_salesman` (
  `salesman_code` int(11) NOT NULL auto_increment,
  `salesman_name` varchar(60) NOT NULL default '',
  `salesman_phone` varchar(30) NOT NULL default '',
  `salesman_fax` varchar(30) NOT NULL default '',
  `salesman_email` varchar(100) NOT NULL default '',
  `provision` double NOT NULL default '0',
  `break_pt` double NOT NULL default '0',
  `provision2` double NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`salesman_code`),
  UNIQUE KEY `salesman_name` (`salesman_name`)
) ENGINE=MyISAM AUTO_INCREMENT=2  ;


### Data of table `0_salesman` ###

INSERT INTO `0_salesman` VALUES ('1', 'Pete', '0411 555 555', '', 'pete@mycompany.com.au', '0', '0', '0', '0');


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
) ENGINE=MyISAM AUTO_INCREMENT=11  ;


### Data of table `0_security_roles` ###

INSERT INTO `0_security_roles` VALUES ('1', 'Inquiries', 'Inquiries', '768;2816;3072;3328;5632;5888;8192;8448;10752;11008;13312;15872;16128', '257;258;259;260;513;514;515;516;517;518;519;520;521;522;523;524;525;773;774;2822;3073;3075;3076;3077;3329;3330;3331;3332;3333;3334;3335;5377;5633;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8450;8451;10497;10753;11009;11010;11012;13313;13315;15617;15618;15619;15620;15621;15622;15623;15624;15625;15626;15873;15882;16129;16130;16131;16132', '0');
INSERT INTO `0_security_roles` VALUES ('2', 'System Administrator', 'System Administrator', '256;512;768;2816;3072;3328;5376;5632;5888;7936;8192;8448;10496;10752;11008;13056;13312;15616;15872;16128', '257;258;259;260;513;514;515;516;517;518;519;520;521;522;523;524;525;769;770;771;772;773;774;2817;2818;2819;2820;2821;2822;2823;3073;3074;3082;3075;3076;3077;3078;3079;3080;3081;3329;3330;3331;3332;3333;3334;3335;5377;5633;5634;5635;5636;5637;5641;5638;5639;5640;5889;5891;7937;7938;7939;7940;8193;8194;8195;8196;8197;8449;8450;8451;10497;10753;10754;10755;10756;10757;11009;11010;11012;13057;13313;13314;13315;15617;15618;15619;15620;15621;15622;15623;15624;15625;15626;15627;15873;15874;15875;15876;15877;15878;15879;15880;15883;15881;15882;16129;16130;16131;16132', '0');
INSERT INTO `0_security_roles` VALUES ('3', 'Salesman', 'Salesman', '768;3072;5632;8192;15872', '773;774;3073;3075;3081;5633;8194;15873', '0');
INSERT INTO `0_security_roles` VALUES ('4', 'Stock Manager', 'Stock Manager', '2816;3072;3328;5632;5888;8192;8448;10752;11008;13312;15872;16128', '2818;2822;3073;3076;3077;3329;3330;3330;3330;3331;3331;3332;3333;3334;3335;5633;5640;5889;5890;5891;8193;8194;8450;8451;10753;11009;11010;11012;13313;13315;15882;16129;16130;16131;16132', '0');
INSERT INTO `0_security_roles` VALUES ('5', 'Production Manager', 'Production Manager', '512;2816;3072;3328;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '521;523;524;2818;2819;2820;2821;2822;2823;3073;3074;3076;3077;3078;3079;3080;3081;3329;3330;3330;3330;3331;3331;3332;3333;3334;3335;5633;5640;5640;5889;5890;5891;8193;8194;8196;8197;8450;8451;10753;10755;11009;11010;11012;13313;13315;15617;15619;15620;15621;15624;15624;15876;15877;15880;15882;16129;16130;16131;16132', '0');
INSERT INTO `0_security_roles` VALUES ('6', 'Purchase Officer', 'Purchase Officer', '512;2816;3072;3328;5376;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '521;523;524;2818;2819;2820;2821;2822;2823;3073;3074;3076;3077;3078;3079;3080;3081;3329;3330;3330;3330;3331;3331;3332;3333;3334;3335;5377;5633;5635;5640;5640;5889;5890;5891;8193;8194;8196;8197;8449;8450;8451;10753;10755;11009;11010;11012;13313;13315;15617;15619;15620;15621;15624;15624;15876;15877;15880;15882;16129;16130;16131;16132', '0');
INSERT INTO `0_security_roles` VALUES ('7', 'AR Officer', 'AR Officer', '512;768;2816;3072;3328;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '521;523;524;771;773;774;2818;2819;2820;2821;2822;2823;3073;3073;3074;3075;3076;3077;3078;3079;3080;3081;3081;3329;3330;3330;3330;3331;3331;3332;3333;3334;3335;5633;5633;5634;5637;5638;5639;5640;5640;5889;5890;5891;8193;8194;8194;8196;8197;8450;8451;10753;10755;11009;11010;11012;13313;13315;15617;15619;15620;15621;15624;15624;15873;15876;15877;15878;15880;15882;16129;16130;16131;16132', '0');
INSERT INTO `0_security_roles` VALUES ('8', 'AP Officer', 'AP Officer', '512;2816;3072;3328;5376;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '257;258;259;260;521;523;524;769;770;771;772;773;774;2818;2819;2820;2821;2822;2823;3073;3074;3082;3076;3077;3078;3079;3080;3081;3329;3330;3331;3332;3333;3334;3335;5377;5633;5635;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8196;8197;8449;8450;8451;10497;10753;10755;11009;11010;11012;13057;13313;13315;15617;15619;15620;15621;15624;15876;15877;15880;15882;16129;16130;16131;16132', '0');
INSERT INTO `0_security_roles` VALUES ('9', 'Accountant', 'New Accountant', '512;768;2816;3072;3328;5376;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '257;258;259;260;521;523;524;771;772;773;774;2818;2819;2820;2821;2822;2823;3073;3074;3075;3076;3077;3078;3079;3080;3081;3329;3330;3331;3332;3333;3334;3335;5377;5633;5634;5635;5637;5638;5639;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8196;8197;8449;8450;8451;10497;10753;10755;11009;11010;11012;13313;13315;15617;15618;15619;15620;15621;15624;15873;15876;15877;15878;15880;15882;16129;16130;16131;16132', '0');
INSERT INTO `0_security_roles` VALUES ('10', 'Sub Admin', 'Sub Admin', '512;768;2816;3072;3328;5376;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '257;258;259;260;521;523;524;771;772;773;774;2818;2819;2820;2821;2822;2823;3073;3074;3082;3075;3076;3077;3078;3079;3080;3081;3329;3330;3331;3332;3333;3334;3335;5377;5633;5634;5635;5637;5638;5639;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8196;8197;8449;8450;8451;10497;10753;10755;11009;11010;11012;13057;13313;13315;15617;15619;15620;15621;15624;15873;15874;15876;15877;15878;15879;15880;15882;16129;16130;16131;16132', '0');


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
) ENGINE=MyISAM AUTO_INCREMENT=6  ;


### Data of table `0_stock_category` ###

INSERT INTO `0_stock_category` VALUES ('1', 'Components', '0', '1', 'each', 'B', '4050', '6920', '1200', '1205', '6910', '0', '0', '0');
INSERT INTO `0_stock_category` VALUES ('2', 'Charges', '0', '1', 'each', 'B', '4050', '6920', '1200', '1205', '6910', '0', '0', '0');
INSERT INTO `0_stock_category` VALUES ('3', 'Systems', '0', '1', 'each', 'B', '4050', '6920', '1200', '1205', '6910', '0', '0', '0');
INSERT INTO `0_stock_category` VALUES ('4', 'Services', '0', '1', 'each', 'B', '4050', '6920', '1200', '1205', '6910', '0', '0', '0');
INSERT INTO `0_stock_category` VALUES ('5', 'Consulting', '0', '1', 'each', 'B', '4050', '6920', '1200', '1205', '6910', '0', '0', '0');


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

INSERT INTO `0_stock_master` VALUES ('1', '4', '1', 'Image processing', 'Image processing for web sites. Includes Photoshop/GIMP work, gif or flash.', '', 'D', '4050', '4010', '1200', '1510', '20000', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `0_stock_master` VALUES ('3', '3', '1', 'Web hosting/domain setup/test', 'Web hosting services - includes domain acquisition', '', 'D', '4050', '4010', '1200', '1205', '6910', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `0_stock_master` VALUES ('4', '3', '1', 'Content Mgt System setup/install', 'CMS (Joomla) setup installation test on existing site', '', 'M', '4050', '6920', '1200', '1205', '6910', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `0_stock_master` VALUES ('5', '3', '1', 'Online store setup/install', 'Standard extras included', '', 'M', '4050', '6920', '1200', '1205', '6910', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `0_stock_master` VALUES ('6', '3', '1', 'Wordpress design/install', 'CMS - wordpress driven.', '', 'M', '4050', '6920', '1200', '1205', '6910', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `0_stock_master` VALUES ('8', '4', '1', 'Custom reporting devt/test', 'Custom reporting for oscommerce. PHP-based', 'hrs', 'D', '4050', '4010', '1200', '1205', '6910', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `0_stock_master` VALUES ('85-C-HR', '5', '1', 'Consulting', '', 'days', 'D', '4050', '6920', '1200', '1205', '6910', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `0_stock_master` VALUES ('9', '4', '1', 'Data extraction/processing', 'Includes one-off Perl/PHP based script processing.', 'hrs', 'D', '4050', '4010', '1200', '1205', '6910', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');


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
) ENGINE=MyISAM AUTO_INCREMENT=10  ;


### Data of table `0_suppliers` ###

INSERT INTO `0_suppliers` VALUES ('1', 'Telstra Bigpond', 'BigPond\nPO Box 299\nBallarat VIC 3350', '', '33 051 775 556', '', '', '', 'BPAY 929919 022144935', 'AUD', '2', '0', '0', '0', '1', '0', '6355', '20000', '7040', '', '0', 'Telstra Bigpond');
INSERT INTO `0_suppliers` VALUES ('2', 'City West Water', 'City West Water\nGPO Box 2839\nMelbourne, Vic 3001', '', '70 066 902 467', '', '', '', 'BPAY: 8789, 111 1111', 'AUD', '2', '0', '0', '0', '2', '0', '6410', '20000', '7040', '', '0', 'City West Water');
INSERT INTO `0_suppliers` VALUES ('3', 'Dymock&#039;s Books', 'Lwr Ground Floor\n234 Collins St\nMelbourne, Vic 3000', '', '73 063 594 883', '', '', '', '', 'AUD', '4', '0', '0', '0', '1', '0', '6920', '20000', '7040', '', '0', 'Dymock&#039;s Books');
INSERT INTO `0_suppliers` VALUES ('4', 'Officeworks Superstores Pty Ltd', '230 Alexandra Pde\nFitzroy', '', '36 004 763 526', '', '', '', '', 'AUD', '4', '0', '0', '0', '1', '0', '6550', '20000', '7040', '', '0', 'Officeworks Superstores Pty Lt');
INSERT INTO `0_suppliers` VALUES ('5', 'Webcity Australia Pty Ltd', 'Webcity Australia\nPO Box 245\nParramatta NSW 2124', '', '72 924 334 435', '', '', '', '', 'AUD', '4', '0', '0', '0', '1', '0', '6350', '20000', '7040', '', '0', 'Webcity Australia Pty Ltd');
INSERT INTO `0_suppliers` VALUES ('6', 'Origin Electricity', '', '', '', '', '', '', '', 'AUD', '2', '0', '0', '0', '1', '0', '6405', '20000', '7040', '', '0', 'Origin Electricity');
INSERT INTO `0_suppliers` VALUES ('7', 'Origin Gas', '', '', '', '', '', '', '', 'AUD', '2', '0', '0', '0', '1', '0', '6400', '20000', '7040', '', '0', 'Origin Gas');
INSERT INTO `0_suppliers` VALUES ('8', 'Dick Smith Electronics', 'Galleria Shopping Plaza Shop\n359 Bourke St\nMelbourne Vic 3000', '', '34 000 908 716', '', '', '', '', 'AUD', '4', '0', '0', '0', '1', '0', '6175', '20000', '7040', '', '0', 'Dick Smith Electronics');
INSERT INTO `0_suppliers` VALUES ('9', 'Ikea', 'Victoria Gardens\nRichmond, Vic 3121', '', '84 006 270 757', '', '', '', '', 'AUD', '4', '0', '0', '0', '1', '0', '6175', '20000', '7040', '', '0', 'Ikea');


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

INSERT INTO `0_sys_prefs` VALUES ('coy_name', 'setup.company', 'varchar', '60', 'my company');
INSERT INTO `0_sys_prefs` VALUES ('gst_no', 'setup.company', 'varchar', '25', '95 000 000 000');
INSERT INTO `0_sys_prefs` VALUES ('coy_no', 'setup.company', 'varchar', '25', '95 000 000 000');
INSERT INTO `0_sys_prefs` VALUES ('tax_prd', 'setup.company', 'int', '11', '1');
INSERT INTO `0_sys_prefs` VALUES ('tax_last', 'setup.company', 'int', '11', '1');
INSERT INTO `0_sys_prefs` VALUES ('postal_address', 'setup.company', 'tinytext', '0', '1 Smith St\r\nSmithtown\r\nVic 3000');
INSERT INTO `0_sys_prefs` VALUES ('phone', 'setup.company', 'varchar', '30', '03 9555 5555');
INSERT INTO `0_sys_prefs` VALUES ('fax', 'setup.company', 'varchar', '30', NULL);
INSERT INTO `0_sys_prefs` VALUES ('email', 'setup.company', 'varchar', '100', 'info@mycompany.au');
INSERT INTO `0_sys_prefs` VALUES ('coy_logo', 'setup.company', 'varchar', '100', 'store_logo.jpg');
INSERT INTO `0_sys_prefs` VALUES ('domicile', 'setup.company', 'varchar', '55', 'Victoria, Australia');
INSERT INTO `0_sys_prefs` VALUES ('curr_default', 'setup.company', 'char', '3', 'AUD');
INSERT INTO `0_sys_prefs` VALUES ('use_dimension', 'setup.company', 'tinyint', '1', '0');
INSERT INTO `0_sys_prefs` VALUES ('f_year', 'setup.company', 'int', '11', '3');
INSERT INTO `0_sys_prefs` VALUES ('no_item_list', 'setup.company', 'tinyint', '1', '0');
INSERT INTO `0_sys_prefs` VALUES ('no_customer_list', 'setup.company', 'tinyint', '1', '0');
INSERT INTO `0_sys_prefs` VALUES ('no_supplier_list', 'setup.company', 'tinyint', '1', '0');
INSERT INTO `0_sys_prefs` VALUES ('base_sales', 'setup.company', 'int', '11', '1');
INSERT INTO `0_sys_prefs` VALUES ('time_zone', 'setup.company', 'tinyint', '1', '0');
INSERT INTO `0_sys_prefs` VALUES ('add_pct', 'setup.company', 'int', '5', '-1');
INSERT INTO `0_sys_prefs` VALUES ('round_to', 'setup.company', 'int', '5', '1');
INSERT INTO `0_sys_prefs` VALUES ('login_tout', 'setup.company', 'smallint', '6', '600');
INSERT INTO `0_sys_prefs` VALUES ('past_due_days', 'glsetup.general', 'int', '11', '30');
INSERT INTO `0_sys_prefs` VALUES ('profit_loss_year_act', 'glsetup.general', 'varchar', '15', '9990');
INSERT INTO `0_sys_prefs` VALUES ('retained_earnings_act', 'glsetup.general', 'varchar', '15', '2050');
INSERT INTO `0_sys_prefs` VALUES ('bank_charge_act', 'glsetup.general', 'varchar', '15', '1430');
INSERT INTO `0_sys_prefs` VALUES ('exchange_diff_act', 'glsetup.general', 'varchar', '15', '6050');
INSERT INTO `0_sys_prefs` VALUES ('default_credit_limit', 'glsetup.customer', 'int', '11', '10000');
INSERT INTO `0_sys_prefs` VALUES ('accumulate_shipping', 'glsetup.customer', 'tinyint', '1', '0');
INSERT INTO `0_sys_prefs` VALUES ('legal_text', 'glsetup.customer', 'tinytext', '0', NULL);
INSERT INTO `0_sys_prefs` VALUES ('freight_act', 'glsetup.customer', 'varchar', '15', '6800');
INSERT INTO `0_sys_prefs` VALUES ('debtors_act', 'glsetup.sales', 'varchar', '15', '1800');
INSERT INTO `0_sys_prefs` VALUES ('default_sales_act', 'glsetup.sales', 'varchar', '15', NULL);
INSERT INTO `0_sys_prefs` VALUES ('default_sales_discount_act', 'glsetup.sales', 'varchar', '15', '6090');
INSERT INTO `0_sys_prefs` VALUES ('default_prompt_payment_act', 'glsetup.sales', 'varchar', '15', '6095');
INSERT INTO `0_sys_prefs` VALUES ('default_delivery_required', 'glsetup.sales', 'smallint', '6', '1');
INSERT INTO `0_sys_prefs` VALUES ('default_dim_required', 'glsetup.dims', 'int', '11', '20');
INSERT INTO `0_sys_prefs` VALUES ('pyt_discount_act', 'glsetup.purchase', 'varchar', '15', '7040');
INSERT INTO `0_sys_prefs` VALUES ('creditors_act', 'glsetup.purchase', 'varchar', '15', '20000');
INSERT INTO `0_sys_prefs` VALUES ('po_over_receive', 'glsetup.purchase', 'int', '11', '10');
INSERT INTO `0_sys_prefs` VALUES ('po_over_charge', 'glsetup.purchase', 'int', '11', '10');
INSERT INTO `0_sys_prefs` VALUES ('allow_negative_stock', 'glsetup.inventory', 'tinyint', '1', '1');
INSERT INTO `0_sys_prefs` VALUES ('default_inventory_act', 'glsetup.items', 'varchar', '15', '1200');
INSERT INTO `0_sys_prefs` VALUES ('default_cogs_act', 'glsetup.items', 'varchar', '15', '6920');
INSERT INTO `0_sys_prefs` VALUES ('default_adj_act', 'glsetup.items', 'varchar', '15', '1205');
INSERT INTO `0_sys_prefs` VALUES ('default_inv_sales_act', 'glsetup.items', 'varchar', '15', '4050');
INSERT INTO `0_sys_prefs` VALUES ('default_assembly_act', 'glsetup.items', 'varchar', '15', '6910');
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

INSERT INTO `0_sys_types` VALUES ('0', '18', '34');
INSERT INTO `0_sys_types` VALUES ('1', '10', '10');
INSERT INTO `0_sys_types` VALUES ('2', '6', '16');
INSERT INTO `0_sys_types` VALUES ('4', '3', '6');
INSERT INTO `0_sys_types` VALUES ('10', '39', '39');
INSERT INTO `0_sys_types` VALUES ('11', '4', '4');
INSERT INTO `0_sys_types` VALUES ('12', '29', '29');
INSERT INTO `0_sys_types` VALUES ('13', '41', '12');
INSERT INTO `0_sys_types` VALUES ('16', '2', '2');
INSERT INTO `0_sys_types` VALUES ('17', '2', '2');
INSERT INTO `0_sys_types` VALUES ('18', '1', '16');
INSERT INTO `0_sys_types` VALUES ('20', '13', '34');
INSERT INTO `0_sys_types` VALUES ('21', '1', '2');
INSERT INTO `0_sys_types` VALUES ('22', '4', '4');
INSERT INTO `0_sys_types` VALUES ('25', '1', '14');
INSERT INTO `0_sys_types` VALUES ('26', '1', '8');
INSERT INTO `0_sys_types` VALUES ('28', '1', '2');
INSERT INTO `0_sys_types` VALUES ('29', '1', '201');
INSERT INTO `0_sys_types` VALUES ('30', '0', '1');
INSERT INTO `0_sys_types` VALUES ('32', '0', '1');
INSERT INTO `0_sys_types` VALUES ('35', '6', '1');
INSERT INTO `0_sys_types` VALUES ('40', '1', '3');


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

INSERT INTO `0_tax_group_items` VALUES ('1', '6', '10');
INSERT INTO `0_tax_group_items` VALUES ('2', '4', '0');
INSERT INTO `0_tax_group_items` VALUES ('4', '3', '0');
INSERT INTO `0_tax_group_items` VALUES ('5', '10', '0');
INSERT INTO `0_tax_group_items` VALUES ('6', '11', '0');
INSERT INTO `0_tax_group_items` VALUES ('7', '8', '10');


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

INSERT INTO `0_tax_groups` VALUES ('1', 'Taxed GST', '0', '0');
INSERT INTO `0_tax_groups` VALUES ('2', 'Tax free FRE', '0', '0');
INSERT INTO `0_tax_groups` VALUES ('4', 'Tax free EXP', '0', '0');
INSERT INTO `0_tax_groups` VALUES ('5', 'Taxed CAP', '0', '0');
INSERT INTO `0_tax_groups` VALUES ('6', 'Tax free N-T', '0', '0');
INSERT INTO `0_tax_groups` VALUES ('7', 'Taxed INP', '0', '0');


### Structure of table `0_tax_types` ###

DROP TABLE IF EXISTS `0_tax_types`;

CREATE TABLE `0_tax_types` (
  `id` int(11) NOT NULL auto_increment,
  `rate` double NOT NULL default '0',
  `sales_gl_code` varchar(15) NOT NULL default '',
  `purchasing_gl_code` varchar(15) NOT NULL default '',
  `name` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12  ;


### Data of table `0_tax_types` ###

INSERT INTO `0_tax_types` VALUES ('3', '0', '2521', '2511', 'EXP', '0');
INSERT INTO `0_tax_types` VALUES ('4', '0', '2522', '2512', 'FRE', '0');
INSERT INTO `0_tax_types` VALUES ('6', '10', '2520', '2510', 'GST', '0');
INSERT INTO `0_tax_types` VALUES ('8', '10', '2523', '2513', 'INP', '0');
INSERT INTO `0_tax_types` VALUES ('10', '10', '2524', '2514', 'CAP', '0');
INSERT INTO `0_tax_types` VALUES ('11', '0', '2525', '2515', 'N-T', '0');


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
) ENGINE=MyISAM AUTO_INCREMENT=3  ;


### Data of table `0_users` ###

INSERT INTO `0_users` VALUES ('1', 'demouser', '5f4dcc3b5aa765d61d8327deb882cf99', 'Demo User', '3', '999-999-999', 'demo@demo.nu', 'en_US', '0', '0', '0', '0', 'default', 'Letter', '2', '2', '3', '1', '1', '0', '0', '2008-02-06 19:02:35', '10', '1', '1', '1', '1', '0', 'orders', '0');
INSERT INTO `0_users` VALUES ('2', 'admin', '5f4dcc3b5aa765d61d8327deb882cf99', 'Administrator', '2', '', 'me@mycompany.au', 'en_US', '1', '0', '0', '0', 'cool', 'A4', '2', '2', '4', '1', '1', '1', '1', '2009-09-02 17:29:20', '10', '1', '1', '', '1', '0', 'orders', '0');


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
) ENGINE=MyISAM AUTO_INCREMENT=3  ;


### Data of table `0_workcentres` ###

INSERT INTO `0_workcentres` VALUES ('1', 'MEL', 'Melbourne', '0');
INSERT INTO `0_workcentres` VALUES ('2', 'LGW', 'London - Gatwick', '0');


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

