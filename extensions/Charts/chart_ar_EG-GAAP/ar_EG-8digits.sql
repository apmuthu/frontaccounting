-- phpMyAdmin SQL Dump
-- version 2.11.8.1deb5
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Mar 09, 2015 at 11:37 AM
-- Server version: 5.0.51
-- PHP Version: 5.2.6-1+lenny2

--
-- Database: `fatest`
--

-- --------------------------------------------------------

--
-- Table structure for table `0_areas`
--

DROP TABLE IF EXISTS `0_areas`;
CREATE TABLE IF NOT EXISTS `0_areas` (
  `area_code` int(11) NOT NULL auto_increment,
  `description` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`area_code`),
  UNIQUE KEY `description` (`description`)
) ENGINE=MyISAM  AUTO_INCREMENT=2 ;

--
-- Dumping data for table `0_areas`
--

INSERT INTO `0_areas` VALUES(1, 'Global', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_attachments`
--

DROP TABLE IF EXISTS `0_attachments`;
CREATE TABLE IF NOT EXISTS `0_attachments` (
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
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_attachments`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_audit_trail`
--

DROP TABLE IF EXISTS `0_audit_trail`;
CREATE TABLE IF NOT EXISTS `0_audit_trail` (
  `id` int(11) NOT NULL auto_increment,
  `type` smallint(6) unsigned NOT NULL default '0',
  `trans_no` int(11) unsigned NOT NULL default '0',
  `user` smallint(6) unsigned NOT NULL default '0',
  `stamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `description` varchar(60) default NULL,
  `fiscal_year` int(11) NOT NULL,
  `gl_date` date NOT NULL default '0000-00-00',
  `gl_seq` int(11) unsigned default NULL,
  PRIMARY KEY  (`id`),
  KEY `Seq` (`fiscal_year`,`gl_date`,`gl_seq`),
  KEY `Type_and_Number` (`type`,`trans_no`)
) ENGINE=InnoDB AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_audit_trail`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_bank_accounts`
--

DROP TABLE IF EXISTS `0_bank_accounts`;
CREATE TABLE IF NOT EXISTS `0_bank_accounts` (
  `account_code` varchar(15) NOT NULL default '',
  `account_type` smallint(6) NOT NULL default '0',
  `bank_account_name` varchar(120) NOT NULL default '',
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
) ENGINE=MyISAM ;

--
-- Dumping data for table `0_bank_accounts`
--

INSERT INTO `0_bank_accounts` (`account_code`, `account_type`, `bank_account_name`, `bank_account_number`, `bank_name`, `bank_address`, `bank_curr_code`, `dflt_curr_act`, `id`, `last_reconciled_date`, `ending_reconcile_balance`, `inactive`) VALUES
('11011001', 1, 'Bank Account', 'N/A', 'N/A', '', 'USD', 0, 3, '0000-00-00 00:00:00', 0, 0),
('11012001', 3, 'Cash Account', 'N/A', 'N/A', '', 'USD', 0, 4, '0000-00-00 00:00:00', 0, 0),
('11013001', 3, 'Petty Cash Account', 'N/A', 'N/A', '', 'USD', 1, 5, '0000-00-00 00:00:00', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_bank_trans`
--

DROP TABLE IF EXISTS `0_bank_trans`;
CREATE TABLE IF NOT EXISTS `0_bank_trans` (
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
) ENGINE=InnoDB AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_bank_trans`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_bom`
--

DROP TABLE IF EXISTS `0_bom`;
CREATE TABLE IF NOT EXISTS `0_bom` (
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
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_bom`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_budget_trans`
--

DROP TABLE IF EXISTS `0_budget_trans`;
CREATE TABLE IF NOT EXISTS `0_budget_trans` (
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
) ENGINE=InnoDB AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_budget_trans`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_chart_class`
--

DROP TABLE IF EXISTS `0_chart_class`;
CREATE TABLE IF NOT EXISTS `0_chart_class` (
  `cid` varchar(3) NOT NULL,
  `class_name` varchar(120) NOT NULL default '',
  `ctype` tinyint(1) NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`cid`)
) ENGINE=MyISAM;

--
-- Dumping data for table `0_chart_class`
--

INSERT INTO `0_chart_class` (`cid`, `class_name`, `ctype`, `inactive`) VALUES
('1', '1 - الأصول', 1, 0),
('2', '2 - الخصوم', 2, 0),
('3', '3 -حقوق الملكية', 3, 0),
('41', '41 - قسم الأعمال التشغيلية - إيرادات البيع', 4, 0),
('42', '42 - قسم الأعمال الغير تشغيلية - تكلفة شراء البضاعة المباعة', 5, 0),
('51', '51 - قسم الأعمال الغير تشغيلية - الإيرادات الآخرى', 4, 0),
('52', '52 - قسم الأعمال الغير تشغيلية - المصاريف الآخرى', 6, 0),
('43', '43 - قسم الأعمال التشغيلية - مصاريف قسم المبيعات', 6, 0),
('44', '44 - قسم الأعمال التشغيلية - المصاريف الإدارية و العمومية', 6, 0),
('6', '6 - ضريبة الدخل', 6, 0),
('7', '7 - العمليات المتوقفة', 6, 0),
('8', '8 - البنود الغير عادية', 6, 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_chart_master`
--

DROP TABLE IF EXISTS `0_chart_master`;
CREATE TABLE IF NOT EXISTS `0_chart_master` (
  `account_code` varchar(15) NOT NULL default '',
  `account_code2` varchar(15) NOT NULL default '',
  `account_name` varchar(120) NOT NULL default '',
  `account_type` varchar(10) NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`account_code`),
  KEY `account_name` (`account_name`),
  KEY `accounts_by_type` (`account_type`,`account_code`)
) ENGINE=MyISAM;

--
-- Zrzut danych tabeli `0_chart_master`
--

INSERT INTO `0_chart_master` (`account_code`, `account_code2`, `account_name`, `account_type`, `inactive`) VALUES
('12013003', '', 'الأموال المخصصة للتوسع في المعدات', '12013', 0),
('12013002', '', 'الأموال المخصصة لسداد أستهلاك السندات', '12013', 0),
('12013001', '', 'القيم النقدية المتنازل عنها الخاصة ببوالص التأمين للموظفين', '12013', 0),
('12012001', '', 'الأستثمارات في الأراضي و المنافع الغير مستخدمة', '12012', 0),
('12011003', '', 'Iالأستثمارات في أسهم رأس المال ( التكلفة و رأس المال)', '12011', 0),
('11011001', '', 'البنك', '1101', 0),
('12011002', '', 'الأستثمارات في السندات المقيدة بتاريخ أستحقاق', '12011', 0),
('12011001', '', 'الأستثمارات في أسهم رأس المال القابلة للتسويق المتاحة للبيع', '12011', 0),
('11050002', '', 'التأمينات المدفوعة مقدماً', '1105', 0),
('11050001', '', 'الإيجارات المدفوعة مقدماً', '1105', 0),
('12093001', '', 'ضرائب الدخل المؤجلة - الأصول', '12093', 0),
('11040003', '', 'مخزون المواد الخام', '1104', 0),
('11040002', '', 'مخزون الأنتاج تحت التشغيل', '1104', 0),
('11040001', '', 'مخزون البضائع', '1104', 0),
('11020002', '', 'السندات المالية القابلة للتسويق - المتاحة للبيع', '1102', 0),
('11020001', '', 'أسهم رأس المال القابلة للتسويق بغرض التجارة', '1102', 0),
('11012001', '', 'النقدية', '1101', 0),
('11014001', '', 'النقدية المقيدة بغرض تواريخ الأستحقاق الحالية للسندات', '1101', 0),
('11013001', '', 'صندوق المصروفات النثرية', '1101', 0),
('12020001', '', 'الأراضي', '1202', 0),
('12020010', '', 'المباني', '1202', 0),
('12020011', '', 'مجمع أهلاك المباني', '1202', 0),
('12020020', '', 'الآلات و المعدات', '1202', 0),
('12020021', '', 'مجمع أهلاك الآلات و المعدات', '1202', 0),
('12020030', '', 'الأثاث و التركيبات', '1202', 0),
('12020031', '', 'مجمع أهلاك الأثاث و التركيبات', '1202', 0),
('12020040', '', 'الأصول المؤجرة بنظام التأجير الرأسمالي', '1202', 0),
('12020041', '', 'مجمع أهلاك الأصول المؤجرة بنظام التأجير الرأسمالي', '1202', 0),
('12020050', '', 'التحسينات في نظام التأجير الرأسمالي', '1202', 0),
('12020051', '', 'مجمع أهلاك تحسينات الأصول المؤجرة بنظام التأجير الرأسمالي', '1202', 0),
('12030001', '', 'الشهرة الخاصة بالأعمال التجارية المستحوذ عليها', '1203', 0),
('12030002', '', 'براءات الأختراع', '1203', 0),
('12030003', '', 'العلامات التجارية', '1203', 0),
('12094001', '', 'أوراق القبض للأقساط المستحقة بعد السنة القادمة', '12094', 0),
('12091001', '', 'تكاليف إصدار السندات الغير مستهلكة', '12091', 0),
('21090001', '', 'استحقاقات الآجل القصير الخاصة بالديون طويلة الآجل', '2109', 0),
('21090002', '', 'استحقاقات الآجل القصير لألتزامات التأجير الرأسمالي', '2109', 0),
('21020001', '', 'أوراق الدفع قصيرة الآجل', '2102', 0),
('21010001', '', 'الذمم الدائنة', '2101', 0),
('21100002', '', 'الإيجارات المستحقة', '2110', 0),
('21060001', '', 'توزيعات الأرباح المستحقة', '2106', 0),
('21070001', '', 'إيرادات الإيجارات المحصلة مقدماً', '2107', 0),
('21090003', '', 'استحقاقات الآجل القصير لتكاليف الضمانات المستحقة', '2109', 0),
('22010001', '', 'أوراق الدفع المستحقة بعد السنة القادمة', '2201', 0),
('22010002', '', 'العلاوة الغير مستهلكة للأوراق التجارية', '2201', 0),
('22010010', '', 'السندات طويلة الآجل', '2201', 0),
('22010011', '', 'صافي الخصومات الغير مستهلكة للعلاوة', '2201', 0),
('22030001', '', 'تكاليف المعاشات المستحقة', '2203', 0),
('22020001', '', 'الإلتزامات الخاصة بالتأجير الرأسمالي', '2202', 0),
('22040001', '', 'الألتزامات الخاصة بالإستغناء عن الأصول', '2204', 0),
('22040002', '', 'الأستحقاقات طويلة الآجل لتكاليف الضمانات المستحقة', '2204', 0),
('22060001', '', 'ضرائب الدخل المؤجلة - الخصوم', '2206', 0),
('31010001', '', 'رأسمال الشريك - محمد', '3101', 0),
('39010001', '', 'الأرباح و الخسائر للسنة الحالية', '3901', 0),
('39010002', '', 'الأرباح المحتجزة - للسنوات السابقة', '3901', 0),
('38010001', '', 'الأحتياطي القانوني', '3801', 0),
('41010001', '', 'المبيعات', '4101', 0),
('41010002', '', 'الخصم على المبيعات', '4101', 0),
('41010003', '', 'مرتجعات المبيعات', '4101', 0),
('61000001', '', 'مصاريف ضريبة الدخل', '61', 0),
('42010001', '', 'التغير في مخزون المواد الخام', '4201', 0),
('42020001', '', 'الأجور المباشرة لعمليات التصنيع', '4202', 0),
('42031001', '', 'أهلاك الآلات و المعدات', '4203', 0),
('42040001', '', 'التغير في مخزون الأنتاج تحت التشغيل', '4204', 0),
('42050001', '', 'التغير في مخزون البضائع', '4205', 0),
('43010001', '', 'رواتب قسم المبيعات', '4301', 0),
('43010002', '', 'العمولات', '4301', 0),
('43010003', '', 'مصاريف الدعاية و الآعلان', '4301', 0),
('43010004', '', 'مصاريف الشحن للعملاء', '4301', 0),
('51020001', '', 'أرباح بيع الأصول الثابتة', '5102', 0),
('44010001', '', 'رواتب الموظفين', '4401', 0),
('44010002', '', 'رواتب عمال المكتب', '4401', 0),
('44010003', '', 'مصاريف الديون المشكوك في تحصيلها', '4401', 0),
('44010004', '', 'مصاريف تجهيزات المكتب', '4401', 0),
('44010005', '', 'أستهلاك الأثاث و التركيبات', '4401', 0),
('44010006', '', 'أستهلاك المباني', '4401', 0),
('44010007', '', 'مصاريف التأمين', '4401', 0),
('44010008', '', 'مصاريف المنافع (مياه و كهرباء...)', '4401', 0),
('44010010', '', 'مصاريف فروقات ترجمة العملات', '4401', 0),
('44010009', '', 'المصاريف البنكية', '4401', 0),
('51020002', '', 'أرباح تعويضات القضايا', '5102', 0),
('52020001', '', 'خسائر بيع الأصول الثابتة', '5202', 0),
('52020002', '', 'خسائر تعويضات القضايا', '5202', 0),
('52020003', '', 'الغرامات', '5202', 0),
('52020004', '', 'خسائر السرقات', '5202', 0),
('42011001', '', 'مشتريات المواد الخام', '4201', 0),
('42011002', '', 'مرتجعات مشتريات المواد الخام', '4201', 0),
('42012001', '', 'مصاريف النقل للداخل الخاصة بالمواد الخام', '4201', 0),
('42011003', '', 'خصومات مشتريات المواد الخام', '4201', 0),
('42090001', '', 'تكلفة شراء البضاعة المباعة (نظام الجرد المستمر)', '4209', 0),
('42032001', '', 'عدد عمليات التصنيع', '4203', 0),
('42033001', '', 'الأجور الغير مباشرة لعمليات التسنيع', '4203', 0),
('42034001', '', 'المواد الغير مباشرة', '4203', 0),
('42035001', '', 'الأعباء الصناعية الآخرى', '4203', 0),
('32010001', '', 'مسحوبات الشريك - محمد', '3201', 0),
('21040002', '', 'ضريبة المشتريات المستحقة', '2104', 0),
('21040001', '', 'ضريبة المبيعات المستحقة', '2104', 0),
('11040012', '', 'فواتير المشاريع الغير منتهية', '1104', 0),
('21030001', '', 'الإيرادات الغير مكتسبة', '2103', 0),
('21110001', '', 'أستحقاقات الفواتير الخاصة بالمشاريع الغير منتهية', '2111', 0),
('21040003', '', 'ضريبة الدخل المستحقة', '2104', 0),
('21120001', '', 'قرض الشريك - محمد', '2112', 0),
('31020001', '', 'رأس المال الإضافي المستثمر للشريك - محمد', '3102', 0),
('22041001', '', 'مخصص مكافأة نهاية الخدمة', '2204', 0),
('22041002', '', 'مخصص الأجازات مدفوعة الأجر', '2204', 0),
('12092001', '', 'خطابات ضمان العاملين', '12092', 0),
('11030101', '', 'الذمم المدينة', '110301', 0),
('11030102', '', 'مخصص الديون المشكوك في تحصيلها', '110301', 0),
('11040011', '', 'المشاريع تحت التشغيل', '1104', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_chart_types`
--

DROP TABLE IF EXISTS `0_chart_types`;
CREATE TABLE IF NOT EXISTS `0_chart_types` (
  `id` varchar(10) NOT NULL,
  `name` varchar(120) NOT NULL default '',
  `class_id` varchar(3) NOT NULL default '',
  `parent` varchar(10) NOT NULL default '-1',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `name` (`name`),
  KEY `class_id` (`class_id`)
) ENGINE=MyISAM ;

--
-- Dumping data for table `0_chart_types`
--

INSERT INTO `0_chart_types` (`id`, `name`, `class_id`, `parent`, `inactive`) VALUES
('12', '12 - الِأصول الغير متداولة', '1', '0', 0),
('1101', '1101 - النقد و النقد المكافئ', '1', '11', 0),
('3305', '3305 - أسهم الخزانة للشركات المساهمة', '3', '33', 0),
('31', '31 - رأسمال الشركاء', '3', '0', 0),
('22', '22 - الخصوم الغير متداولة', '2', '0', 0),
('11', '11 - الأصول المتداولة	', '1', '0', 0),
('21', '21 - الخصوم المتداولة', '2', '0', 0),
('1102', '1102 - الأستثمارات قصيرة الآجل', '1', '11', 0),
('1103', '1103 - الذمم المدينة', '1', '11', 0),
('1104', '1104 - المخزون', '1', '11', 0),
('1105', '1105 - المصاريف المدفوعة مقدماً', '1', '11', 0),
('1201', '1201 - الأستثمارات طويلة الآجل', '1', '12', 0),
('1202', '1202 - الإنشاءات و المعدات و الآلات', '1', '12', 0),
('1203', '1203 - الأصول الغير ملموسة', '1', '12', 0),
('1209', '1209 - الأصول الآخرى', '1', '12', 0),
('2101', '2101 - الذمم الدائنة', '2', '21', 0),
('2102', '2102 - أوراق الدفع', '2', '21', 0),
('2106', '2106 - توزيعات الأرباح المستحقة', '2', '21', 0),
('2107', '2107 - المقدمات و الإيداعات', '2', '21', 0),
('2108', '2108 -الإلتزامات المتوقع إعادة تمويلها', '2', '21', 0),
('2109', '2109 - الجزء المتداول من الديون طويلة الآجل', '2', '21', 0),
('2110', '2110 - المصاريف المستحقة قصيرة الآجل', '2', '21', 0),
('2201', '2201 - القروض و أوراق الدفع طويلة الآجل', '2', '22', 0),
('2202', '2202 - إلتزامات التأجير', '2', '22', 0),
('2203', '2203 - المصاريف المستحقة طويلة الآجل', '2', '22', 0),
('2204', '2204 - المخصصات و الألتزامات المحتملة', '2', '22', 0),
('2205', '2205 - الأسهم جبرية الأستهلاك', '2', '22', 0),
('2206', '2206 - خصوم غير متداولة أخرى', '2', '22', 0),
('3101', '3101 - رأسمال الشركاء', '3', '31', 0),
('3801', '3801 - الأحتياطيات', '3', '38', 0),
('4301', '4301 - المصاريف البيعية', '43', '0', 0),
('39', '39 - الأرباح المحتجزة', '3', '0', 0),
('3901', '3901 - الأرباح المحتجزة', '3', '39', 0),
('3302', '3302 - رأسمال الأسهم للشركات المساهمة', '3', '33', 0),
('3303', '3303 - القيم الإضافية المدفوعة لرأسمال المساهمة', '3', '33', 0),
('3304', '3304 - رأسمال التبرعات في الشركات المساهمة', '1', '33', 0),
('12011', '12011 - الديون و الأوراق المالية', '1', '1201', 0),
('12012', '12012 - الأصول الملموسة الغير مستخدمة في العمليات', '1', '1201', 0),
('12013', '12013 - الأستثمارات الموقوفة على صناديق خاصة', '1', '1201', 0),
('12091', '12091 - المصاريف المدفوعة مقدماً طويلة الآجل', '1', '1209', 0),
('12092', '12092 - الأموال المحتجزة', '1', '1209', 0),
('12093', '12093 - الضرائب المؤجلة', '1', '1209', 0),
('12094', '12094 - الذمم المدينة الغير متداولة', '1', '1209', 0),
('4201', '4201 - المواد المباشرةl', '42', '0', 0),
('4202', '4202 - الأجور المباشرة', '42', '0', 0),
('4203', '4203 - الأعباء التصنيعية', '42', '0', 0),
('4204', '4204 - الأنتاج تحت التشغيل', '42', '0', 0),
('4205', '4205 - مخزون البضائع', '42', '0', 0),
('5101', '5101 - إيرادات أخرى', '51', '0', 0),
('5102', '5102 - مكاسب أخرى', '51', '0', 0),
('5201', '5201 - مصاريف أخرى', '52', '0', 0),
('5202', '5202 - خسائر أخرى', '52', '0', 0),
('2112', '2112 - قروض الشركاء', '2', '21', 0),
('4101', '4101 - إيرادت المبيعات', '41', '0', 0),
('4209', '4209 - تكلفة البضاعة المباعة - نظام الجرد المستمر', '42', '0', 0),
('38', '38 - الاحتياطيات', '3', '0', 0),
('3102', '3102 - الاستثمارات الإضافية للشركاء', '3', '31', 0),
('61', '61 - ضريبة الدخل', '6', '0', 0),
('4401', '4401 - المصاريف الإدارية و العمومية', '44', '0', 0),
('32', '32 - مسحوبات الشركاء', '3', '0', 0),
('33', '33 - رأسمال المساهمين', '3', '0', 0),
('3201', '3201 - مسحوبات الشركاء', '3', '32', 0),
('3301', '3301 - رأسمال الشركات المساهمة المصدر', '3', '33', 0),
('2103', '2103 - الإيرادات الغير مكتسبة', '2', '21', 0),
('2104', '2104 - الضرائب المستحقة', '2', '21', 0),
('2105', '2105 - الخصوم المتعلقة بالموظفين', '2', '21', 0),
('2111', '2111 - صافي فرق المشاريع تحت التشغيل و الفواتير', '2', '21', 0),
('110301', '110301 - حسابات الذمم المدينة', '1', '1103', 0),
('110302', '110302 - أوراق القبض', '1', '1103', 0),
('110304', '110304 - الذمم المدينة للموظفين', '1', '1103', 0),
('110305', '110305 - الذمم المدينة الآخرى', '1', '1103', 0),
('110303', '110303 - الذمم المدينة للشركات الشقيقة', '1', '1103', 0),
('210101', '210101 - الذمم الدائنة للشركات الشقيقة', '2', '2101', 0),
('120110', '120110 - الديون و الأوراق المالية', '1', '1201', 0),
('120120', '120120 - الأصول الملموسة الغير مستخدمة في العمليات', '1', '1201', 0),
('120130', '120130 - الأستثمارات الموقوفة على صناديق خاصة', '1', '1201', 0),
('120910', '120910 - المصاريف المدفوعة مقدماً طويلة الآجل', '1', '1209', 0),
('120920', '120920 - أموال الضمانات المحتجزة', '1', '1209', 0),
('120930', '120930 - الضرائب المؤجلة', '1', '1209', 0),
('120940', '120940 - الذمم المدينة الغير متداولة', '1', '1209', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_comments`
--

DROP TABLE IF EXISTS `0_comments`;
CREATE TABLE IF NOT EXISTS `0_comments` (
  `type` int(11) NOT NULL default '0',
  `id` int(11) NOT NULL default '0',
  `date_` date default '0000-00-00',
  `memo_` tinytext,
  KEY `type_and_id` (`type`,`id`)
) ENGINE=InnoDB;

--
-- Dumping data for table `0_comments`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_credit_status`
--

DROP TABLE IF EXISTS `0_credit_status`;
CREATE TABLE IF NOT EXISTS `0_credit_status` (
  `id` int(11) NOT NULL auto_increment,
  `reason_description` char(100) NOT NULL default '',
  `dissallow_invoices` tinyint(1) NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `reason_description` (`reason_description`)
) ENGINE=MyISAM  AUTO_INCREMENT=5 ;

--
-- Dumping data for table `0_credit_status`
--

INSERT INTO `0_credit_status` VALUES(1, 'Good History', 0, 0);
INSERT INTO `0_credit_status` VALUES(3, 'No more work until payment received', 1, 0);
INSERT INTO `0_credit_status` VALUES(4, 'In liquidation', 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_crm_categories`
--

DROP TABLE IF EXISTS `0_crm_categories`;
CREATE TABLE IF NOT EXISTS `0_crm_categories` (
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
) ENGINE=InnoDB  AUTO_INCREMENT=13 ;

--
-- Dumping data for table `0_crm_categories`
--

INSERT INTO `0_crm_categories` VALUES(1, 'cust_branch', 'general', 'General', 'General contact data for customer branch (overrides company setting)', 1, 0);
INSERT INTO `0_crm_categories` VALUES(2, 'cust_branch', 'invoice', 'Invoices', 'Invoice posting (overrides company setting)', 1, 0);
INSERT INTO `0_crm_categories` VALUES(3, 'cust_branch', 'order', 'Orders', 'Order confirmation (overrides company setting)', 1, 0);
INSERT INTO `0_crm_categories` VALUES(4, 'cust_branch', 'delivery', 'Deliveries', 'Delivery coordination (overrides company setting)', 1, 0);
INSERT INTO `0_crm_categories` VALUES(5, 'customer', 'general', 'General', 'General contact data for customer', 1, 0);
INSERT INTO `0_crm_categories` VALUES(6, 'customer', 'order', 'Orders', 'Order confirmation', 1, 0);
INSERT INTO `0_crm_categories` VALUES(7, 'customer', 'delivery', 'Deliveries', 'Delivery coordination', 1, 0);
INSERT INTO `0_crm_categories` VALUES(8, 'customer', 'invoice', 'Invoices', 'Invoice posting', 1, 0);
INSERT INTO `0_crm_categories` VALUES(9, 'supplier', 'general', 'General', 'General contact data for supplier', 1, 0);
INSERT INTO `0_crm_categories` VALUES(10, 'supplier', 'order', 'Orders', 'Order confirmation', 1, 0);
INSERT INTO `0_crm_categories` VALUES(11, 'supplier', 'delivery', 'Deliveries', 'Delivery coordination', 1, 0);
INSERT INTO `0_crm_categories` VALUES(12, 'supplier', 'invoice', 'Invoices', 'Invoice posting', 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_crm_contacts`
--

DROP TABLE IF EXISTS `0_crm_contacts`;
CREATE TABLE IF NOT EXISTS `0_crm_contacts` (
  `id` int(11) NOT NULL auto_increment,
  `person_id` int(11) NOT NULL default '0' COMMENT 'foreign key to crm_contacts',
  `type` varchar(20) NOT NULL COMMENT 'foreign key to crm_categories',
  `action` varchar(20) NOT NULL COMMENT 'foreign key to crm_categories',
  `entity_id` varchar(11) default NULL COMMENT 'entity id in related class table',
  PRIMARY KEY  (`id`),
  KEY `type` (`type`,`action`)
) ENGINE=InnoDB AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_crm_contacts`
--

-- --------------------------------------------------------

--
-- Table structure for table `0_crm_persons`
--

DROP TABLE IF EXISTS `0_crm_persons`;
CREATE TABLE IF NOT EXISTS `0_crm_persons` (
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
) ENGINE=InnoDB AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_crm_persons`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_currencies`
--

DROP TABLE IF EXISTS `0_currencies`;
CREATE TABLE IF NOT EXISTS `0_currencies` (
  `currency` varchar(60) NOT NULL default '',
  `curr_abrev` char(3) NOT NULL default '',
  `curr_symbol` varchar(10) NOT NULL default '',
  `country` varchar(100) NOT NULL default '',
  `hundreds_name` varchar(15) NOT NULL default '',
  `auto_update` tinyint(1) NOT NULL default '1',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`curr_abrev`)
) ENGINE=MyISAM;

--
-- Dumping data for table `0_currencies`
--

INSERT INTO `0_currencies` VALUES('Egyptian Pounds', 'EGP', '£', 'Egypt', 'Piastre', 1, 0);
INSERT INTO `0_currencies` VALUES('US Dollars', 'USD', '$', 'United States', 'Cents', 1, 0);
INSERT INTO `0_currencies` VALUES('CA Dollars', 'CAD', '$', 'Canada', 'Cents', 1, 0);
INSERT INTO `0_currencies` VALUES('Euro', 'EUR', '€', 'Europe', 'Cents', 1, 0);
INSERT INTO `0_currencies` VALUES('Pounds', 'GBP', '£', 'England', 'Pence', 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_cust_allocations`
--

DROP TABLE IF EXISTS `0_cust_allocations`;
CREATE TABLE IF NOT EXISTS `0_cust_allocations` (
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
) ENGINE=InnoDB AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_cust_allocations`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_cust_branch`
--

DROP TABLE IF EXISTS `0_cust_branch`;
CREATE TABLE IF NOT EXISTS `0_cust_branch` (
  `branch_code` int(11) NOT NULL auto_increment,
  `debtor_no` int(11) NOT NULL default '0',
  `br_name` varchar(60) NOT NULL default '',
  `branch_ref` varchar(30) NOT NULL default '',
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
  `notes` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`branch_code`,`debtor_no`),
  KEY `branch_code` (`branch_code`),
  KEY `branch_ref` (`branch_ref`),
  KEY `group_no` (`group_no`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_cust_branch`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_debtors_master`
--

DROP TABLE IF EXISTS `0_debtors_master`;
CREATE TABLE IF NOT EXISTS `0_debtors_master` (
  `debtor_no` int(11) NOT NULL auto_increment,
  `name` varchar(100) NOT NULL default '',
  `debtor_ref` varchar(30) NOT NULL,
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
  `notes` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`debtor_no`),
  UNIQUE KEY `debtor_ref` (`debtor_ref`),
  KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_debtors_master`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_debtor_trans`
--

DROP TABLE IF EXISTS `0_debtor_trans`;
CREATE TABLE IF NOT EXISTS `0_debtor_trans` (
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
  KEY `tran_date` (`tran_date`),
  KEY `order_` (`order_`)
) ENGINE=InnoDB;

--
-- Dumping data for table `0_debtor_trans`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_debtor_trans_details`
--

DROP TABLE IF EXISTS `0_debtor_trans_details`;
CREATE TABLE IF NOT EXISTS `0_debtor_trans_details` (
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
  `src_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `Transaction` (`debtor_trans_type`,`debtor_trans_no`),
  KEY (`src_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_debtor_trans_details`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_dimensions`
--

DROP TABLE IF EXISTS `0_dimensions`;
CREATE TABLE IF NOT EXISTS `0_dimensions` (
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
) ENGINE=InnoDB AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_dimensions`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_exchange_rates`
--

DROP TABLE IF EXISTS `0_exchange_rates`;
CREATE TABLE IF NOT EXISTS `0_exchange_rates` (
  `id` int(11) NOT NULL auto_increment,
  `curr_code` char(3) NOT NULL default '',
  `rate_buy` double NOT NULL default '0',
  `rate_sell` double NOT NULL default '0',
  `date_` date NOT NULL default '0000-00-00',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `curr_code` (`curr_code`,`date_`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_exchange_rates`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_fiscal_year`
--

DROP TABLE IF EXISTS `0_fiscal_year`;
CREATE TABLE IF NOT EXISTS `0_fiscal_year` (
  `id` int(11) NOT NULL auto_increment,
  `begin` date default '0000-00-00',
  `end` date default '0000-00-00',
  `closed` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `begin` (`begin`),
  UNIQUE KEY `end` (`end`)
) ENGINE=InnoDB  AUTO_INCREMENT=9 ;

--
-- Zrzut danych tabeli `0_fiscal_year`
--

INSERT INTO `0_fiscal_year` (`id`, `begin`, `end`, `closed`) VALUES
(1, '2008-01-01', '2008-12-31', 0),
(2, '2009-01-01', '2009-12-31', 0),
(3, '2010-01-01', '2010-12-31', 0),
(4, '2011-01-01', '2011-12-31', 0),
(5, '2012-01-01', '2012-12-31', 0),
(6, '2013-01-01', '2013-12-31', 0),
(7, '2014-01-01', '2014-12-31', 0),
(8, '2015-01-01', '2015-12-31', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_gl_trans`
--

DROP TABLE IF EXISTS `0_gl_trans`;
CREATE TABLE IF NOT EXISTS `0_gl_trans` (
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
) ENGINE=InnoDB AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_gl_trans`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_grn_batch`
--

DROP TABLE IF EXISTS `0_grn_batch`;
CREATE TABLE IF NOT EXISTS `0_grn_batch` (
  `id` int(11) NOT NULL auto_increment,
  `supplier_id` int(11) NOT NULL default '0',
  `purch_order_no` int(11) default NULL,
  `reference` varchar(60) NOT NULL default '',
  `delivery_date` date NOT NULL default '0000-00-00',
  `loc_code` varchar(5) default NULL,
  PRIMARY KEY  (`id`),
  KEY `delivery_date` (`delivery_date`),
  KEY `purch_order_no` (`purch_order_no`)
) ENGINE=InnoDB AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_grn_batch`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_grn_items`
--

DROP TABLE IF EXISTS `0_grn_items`;
CREATE TABLE IF NOT EXISTS `0_grn_items` (
  `id` int(11) NOT NULL auto_increment,
  `grn_batch_id` int(11) default NULL,
  `po_detail_item` int(11) NOT NULL default '0',
  `item_code` varchar(20) NOT NULL default '',
  `description` tinytext,
  `qty_recd` double NOT NULL default '0',
  `quantity_inv` double NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `grn_batch_id` (`grn_batch_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_grn_items`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_groups`
--

DROP TABLE IF EXISTS `0_groups`;
CREATE TABLE IF NOT EXISTS `0_groups` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `description` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `description` (`description`)
) ENGINE=MyISAM  AUTO_INCREMENT=4 ;

--
-- Dumping data for table `0_groups`
--

INSERT INTO `0_groups` VALUES(1, 'Small', 0);
INSERT INTO `0_groups` VALUES(2, 'Medium', 0);
INSERT INTO `0_groups` VALUES(3, 'Large', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_item_codes`
--

DROP TABLE IF EXISTS `0_item_codes`;
CREATE TABLE IF NOT EXISTS `0_item_codes` (
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
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_item_codes`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_item_tax_types`
--

DROP TABLE IF EXISTS `0_item_tax_types`;
CREATE TABLE IF NOT EXISTS `0_item_tax_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(60) NOT NULL default '',
  `exempt` tinyint(1) NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB  AUTO_INCREMENT=2 ;

--
-- Dumping data for table `0_item_tax_types`
--

INSERT INTO `0_item_tax_types` VALUES(1, 'Regular', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_item_tax_type_exemptions`
--

DROP TABLE IF EXISTS `0_item_tax_type_exemptions`;
CREATE TABLE IF NOT EXISTS `0_item_tax_type_exemptions` (
  `item_tax_type_id` int(11) NOT NULL default '0',
  `tax_type_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`item_tax_type_id`,`tax_type_id`)
) ENGINE=InnoDB;

--
-- Dumping data for table `0_item_tax_type_exemptions`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_item_units`
--

DROP TABLE IF EXISTS `0_item_units`;
CREATE TABLE IF NOT EXISTS `0_item_units` (
  `abbr` varchar(20) NOT NULL,
  `name` varchar(40) NOT NULL,
  `decimals` tinyint(2) NOT NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`abbr`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM;

--
-- Dumping data for table `0_item_units`
--

INSERT INTO `0_item_units` VALUES('each', 'Each', 0, 0);
INSERT INTO `0_item_units` VALUES('hr', 'Hours', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_locations`
--

DROP TABLE IF EXISTS `0_locations`;
CREATE TABLE IF NOT EXISTS `0_locations` (
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
) ENGINE=MyISAM;

--
-- Dumping data for table `0_locations`
--

INSERT INTO `0_locations` VALUES('DEF', 'Default', 'N/A', '', '', '', '', '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_loc_stock`
--

DROP TABLE IF EXISTS `0_loc_stock`;
CREATE TABLE IF NOT EXISTS `0_loc_stock` (
  `loc_code` char(5) NOT NULL default '',
  `stock_id` char(20) NOT NULL default '',
  `reorder_level` bigint(20) NOT NULL default '0',
  PRIMARY KEY  (`loc_code`,`stock_id`),
  KEY `stock_id` (`stock_id`)
) ENGINE=InnoDB;

--
-- Dumping data for table `0_loc_stock`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_movement_types`
--

DROP TABLE IF EXISTS `0_movement_types`;
CREATE TABLE IF NOT EXISTS `0_movement_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM  AUTO_INCREMENT=2 ;

--
-- Dumping data for table `0_movement_types`
--

INSERT INTO `0_movement_types` VALUES(1, 'Adjustment', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_payment_terms`
--

DROP TABLE IF EXISTS `0_payment_terms`;
CREATE TABLE IF NOT EXISTS `0_payment_terms` (
  `terms_indicator` int(11) NOT NULL auto_increment,
  `terms` char(80) NOT NULL default '',
  `days_before_due` smallint(6) NOT NULL default '0',
  `day_in_following_month` smallint(6) NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`terms_indicator`),
  UNIQUE KEY `terms` (`terms`)
) ENGINE=MyISAM  AUTO_INCREMENT=5 ;

--
-- Dumping data for table `0_payment_terms`
--

INSERT INTO `0_payment_terms` VALUES(1, 'Due 15th Of the Following Month', 0, 17, 0);
INSERT INTO `0_payment_terms` VALUES(2, 'Due By End Of The Following Month', 0, 30, 0);
INSERT INTO `0_payment_terms` VALUES(3, 'Payment due within 10 days', 10, 0, 0);
INSERT INTO `0_payment_terms` VALUES(4, 'Cash Only', 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_prices`
--

DROP TABLE IF EXISTS `0_prices`;
CREATE TABLE IF NOT EXISTS `0_prices` (
  `id` int(11) NOT NULL auto_increment,
  `stock_id` varchar(20) NOT NULL default '',
  `sales_type_id` int(11) NOT NULL default '0',
  `curr_abrev` char(3) NOT NULL default '',
  `price` double NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `price` (`stock_id`,`sales_type_id`,`curr_abrev`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_prices`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_printers`
--

DROP TABLE IF EXISTS `0_printers`;
CREATE TABLE IF NOT EXISTS `0_printers` (
  `id` tinyint(3) unsigned NOT NULL auto_increment,
  `name` varchar(20) NOT NULL,
  `description` varchar(60) NOT NULL,
  `queue` varchar(20) NOT NULL,
  `host` varchar(40) NOT NULL,
  `port` smallint(11) unsigned NOT NULL,
  `timeout` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM  AUTO_INCREMENT=4 ;

--
-- Dumping data for table `0_printers`
--

INSERT INTO `0_printers` VALUES(1, 'QL500', 'Label printer', 'QL500', 'server', 127, 20);
INSERT INTO `0_printers` VALUES(2, 'Samsung', 'Main network printer', 'scx4521F', 'server', 515, 5);
INSERT INTO `0_printers` VALUES(3, 'Local', 'Local print server at user IP', 'lp', '', 515, 10);

-- --------------------------------------------------------

--
-- Table structure for table `0_print_profiles`
--

DROP TABLE IF EXISTS `0_print_profiles`;
CREATE TABLE IF NOT EXISTS `0_print_profiles` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `profile` varchar(30) NOT NULL,
  `report` varchar(5) default NULL,
  `printer` tinyint(3) unsigned default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `profile` (`profile`,`report`)
) ENGINE=MyISAM  AUTO_INCREMENT=10 ;

--
-- Dumping data for table `0_print_profiles`
--

INSERT INTO `0_print_profiles` VALUES(1, 'Out of office', '', 0);
INSERT INTO `0_print_profiles` VALUES(2, 'Sales Department', '', 0);
INSERT INTO `0_print_profiles` VALUES(3, 'Central', '', 2);
INSERT INTO `0_print_profiles` VALUES(4, 'Sales Department', '104', 2);
INSERT INTO `0_print_profiles` VALUES(5, 'Sales Department', '105', 2);
INSERT INTO `0_print_profiles` VALUES(6, 'Sales Department', '107', 2);
INSERT INTO `0_print_profiles` VALUES(7, 'Sales Department', '109', 2);
INSERT INTO `0_print_profiles` VALUES(8, 'Sales Department', '110', 2);
INSERT INTO `0_print_profiles` VALUES(9, 'Sales Department', '201', 2);

-- --------------------------------------------------------

--
-- Table structure for table `0_purch_data`
--

DROP TABLE IF EXISTS `0_purch_data`;
CREATE TABLE IF NOT EXISTS `0_purch_data` (
  `supplier_id` int(11) NOT NULL default '0',
  `stock_id` char(20) NOT NULL default '',
  `price` double NOT NULL default '0',
  `suppliers_uom` char(50) NOT NULL default '',
  `conversion_factor` double NOT NULL default '1',
  `supplier_description` char(50) NOT NULL default '',
  PRIMARY KEY  (`supplier_id`,`stock_id`)
) ENGINE=MyISAM;

--
-- Dumping data for table `0_purch_data`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_purch_orders`
--

DROP TABLE IF EXISTS `0_purch_orders`;
CREATE TABLE IF NOT EXISTS `0_purch_orders` (
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
) ENGINE=InnoDB AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_purch_orders`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_purch_order_details`
--

DROP TABLE IF EXISTS `0_purch_order_details`;
CREATE TABLE IF NOT EXISTS `0_purch_order_details` (
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
) ENGINE=InnoDB AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_purch_order_details`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_quick_entries`
--

DROP TABLE IF EXISTS `0_quick_entries`;
CREATE TABLE IF NOT EXISTS `0_quick_entries` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `type` tinyint(1) NOT NULL default '0',
  `description` varchar(60) NOT NULL,
  `base_amount` double NOT NULL default '0',
  `base_desc` varchar(60) default NULL,
  `bal_type` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `description` (`description`)
) ENGINE=MyISAM  AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_quick_entries`
--

-- --------------------------------------------------------

--
-- Table structure for table `0_quick_entry_lines`
--

DROP TABLE IF EXISTS `0_quick_entry_lines`;
CREATE TABLE IF NOT EXISTS `0_quick_entry_lines` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `qid` smallint(6) unsigned NOT NULL,
  `amount` double default '0',
  `action` varchar(2) NOT NULL,
  `dest_id` varchar(15) NOT NULL default '',
  `dimension_id` smallint(6) unsigned default NULL,
  `dimension2_id` smallint(6) unsigned default NULL,
  PRIMARY KEY  (`id`),
  KEY `qid` (`qid`)
) ENGINE=MyISAM  AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_quick_entry_lines`
--

-- --------------------------------------------------------

--
-- Table structure for table `0_recurrent_invoices`
--

DROP TABLE IF EXISTS `0_recurrent_invoices`;
CREATE TABLE IF NOT EXISTS `0_recurrent_invoices` (
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
) ENGINE=InnoDB AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_recurrent_invoices`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_refs`
--

DROP TABLE IF EXISTS `0_refs`;
CREATE TABLE IF NOT EXISTS `0_refs` (
  `id` int(11) NOT NULL default '0',
  `type` int(11) NOT NULL default '0',
  `reference` varchar(100) NOT NULL default '',
  PRIMARY KEY  (`id`,`type`),
  KEY `Type_and_Reference` (`type`,`reference`)
) ENGINE=InnoDB;

--
-- Dumping data for table `0_refs`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_salesman`
--

DROP TABLE IF EXISTS `0_salesman`;
CREATE TABLE IF NOT EXISTS `0_salesman` (
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
) ENGINE=MyISAM  AUTO_INCREMENT=2 ;

--
-- Dumping data for table `0_salesman`
--

INSERT INTO `0_salesman` VALUES(1, 'Sales Person', '', '', '', 5, 1000, 4, 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_sales_orders`
--

DROP TABLE IF EXISTS `0_sales_orders`;
CREATE TABLE IF NOT EXISTS `0_sales_orders` (
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
) ENGINE=InnoDB;

--
-- Dumping data for table `0_sales_orders`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_sales_order_details`
--

DROP TABLE IF EXISTS `0_sales_order_details`;
CREATE TABLE IF NOT EXISTS `0_sales_order_details` (
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
) ENGINE=InnoDB AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_sales_order_details`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_sales_pos`
--

DROP TABLE IF EXISTS `0_sales_pos`;
CREATE TABLE IF NOT EXISTS `0_sales_pos` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `pos_name` varchar(30) NOT NULL,
  `cash_sale` tinyint(1) NOT NULL,
  `credit_sale` tinyint(1) NOT NULL,
  `pos_location` varchar(5) NOT NULL,
  `pos_account` smallint(6) unsigned NOT NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `pos_name` (`pos_name`)
) ENGINE=MyISAM  AUTO_INCREMENT=2 ;

--
-- Dumping data for table `0_sales_pos`
--

INSERT INTO `0_sales_pos` VALUES(1, 'Default', 1, 1, 'DEF', 2, 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_sales_types`
--

DROP TABLE IF EXISTS `0_sales_types`;
CREATE TABLE IF NOT EXISTS `0_sales_types` (
  `id` int(11) NOT NULL auto_increment,
  `sales_type` char(50) NOT NULL default '',
  `tax_included` int(1) NOT NULL default '0',
  `factor` double NOT NULL default '1',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `sales_type` (`sales_type`)
) ENGINE=MyISAM  AUTO_INCREMENT=3 ;

--
-- Dumping data for table `0_sales_types`
--

INSERT INTO `0_sales_types` VALUES(1, 'Retail', 1, 1, 0);
INSERT INTO `0_sales_types` VALUES(2, 'Wholesale', 0, 0.7, 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_security_roles`
--

DROP TABLE IF EXISTS `0_security_roles`;
CREATE TABLE IF NOT EXISTS `0_security_roles` (
  `id` int(11) NOT NULL auto_increment,
  `role` varchar(30) NOT NULL,
  `description` varchar(50) default NULL,
  `sections` text,
  `areas` text,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `role` (`role`)
) ENGINE=MyISAM  AUTO_INCREMENT=11 ;

--
-- Dumping data for table `0_security_roles`
--

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

-- --------------------------------------------------------

--
-- Table structure for table `0_shippers`
--

DROP TABLE IF EXISTS `0_shippers`;
CREATE TABLE IF NOT EXISTS `0_shippers` (
  `shipper_id` int(11) NOT NULL auto_increment,
  `shipper_name` varchar(60) NOT NULL default '',
  `phone` varchar(30) NOT NULL default '',
  `phone2` varchar(30) NOT NULL default '',
  `contact` tinytext NOT NULL,
  `address` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`shipper_id`),
  UNIQUE KEY `name` (`shipper_name`)
) ENGINE=MyISAM  AUTO_INCREMENT=2 ;

--
-- Dumping data for table `0_shippers`
--

INSERT INTO `0_shippers` VALUES(1, 'Default', '', '', '', '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_sql_trail`
--

DROP TABLE IF EXISTS `0_sql_trail`;
CREATE TABLE IF NOT EXISTS `0_sql_trail` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `sql` text NOT NULL,
  `result` tinyint(1) NOT NULL,
  `msg` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_sql_trail`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_stock_category`
--

DROP TABLE IF EXISTS `0_stock_category`;
CREATE TABLE IF NOT EXISTS `0_stock_category` (
  `category_id` int(11) NOT NULL auto_increment,
  `description` varchar(60) NOT NULL default '',
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
  `inactive` tinyint(1) NOT NULL default '0',
  `dflt_no_sale` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`category_id`),
  UNIQUE KEY `description` (`description`)
) ENGINE=MyISAM  AUTO_INCREMENT=5 ;

--
-- Dumping data for table `0_stock_category`
--

INSERT INTO `0_stock_category` (`category_id`, `description`, `dflt_tax_type`, `dflt_units`, `dflt_mb_flag`, `dflt_sales_act`, `dflt_cogs_act`, `dflt_inventory_act`, `dflt_adjustment_act`, `dflt_assembly_act`, `dflt_dim1`, `dflt_dim2`, `inactive`, `dflt_no_sale`) VALUES
(1, 'Components', 1, 'each', 'B', '41010001', '42090001', '11040001', '42050001', '11040002', 0, 0, 0, 0),
(2, 'Charges', 1, 'each', 'D', '41010001', '42090001', '11040001', '42050001', '11040002', 0, 0, 0, 0),
(3, 'Systems', 1, 'each', 'M', '41010001', '42090001', '11040001', '42050001', '11040002', 0, 0, 0, 0),
(4, 'Services', 1, 'hr', 'D', '41010001', '42090001', '11040001', '42050001', '11040002', 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_stock_master`
--

DROP TABLE IF EXISTS `0_stock_master`;
CREATE TABLE IF NOT EXISTS `0_stock_master` (
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
) ENGINE=InnoDB;

--
-- Dumping data for table `0_stock_master`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_stock_moves`
--

DROP TABLE IF EXISTS `0_stock_moves`;
CREATE TABLE IF NOT EXISTS `0_stock_moves` (
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
) ENGINE=InnoDB AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_stock_moves`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_suppliers`
--

DROP TABLE IF EXISTS `0_suppliers`;
CREATE TABLE IF NOT EXISTS `0_suppliers` (
  `supplier_id` int(11) NOT NULL auto_increment,
  `supp_name` varchar(60) NOT NULL default '',
  `supp_ref` varchar(30) NOT NULL default '',
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
  PRIMARY KEY  (`supplier_id`),
  KEY `supp_ref` (`supp_ref`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_suppliers`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_supp_allocations`
--

DROP TABLE IF EXISTS `0_supp_allocations`;
CREATE TABLE IF NOT EXISTS `0_supp_allocations` (
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
) ENGINE=InnoDB AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_supp_allocations`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_supp_invoice_items`
--

DROP TABLE IF EXISTS `0_supp_invoice_items`;
CREATE TABLE IF NOT EXISTS `0_supp_invoice_items` (
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
) ENGINE=InnoDB AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_supp_invoice_items`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_supp_trans`
--

DROP TABLE IF EXISTS `0_supp_trans`;
CREATE TABLE IF NOT EXISTS `0_supp_trans` (
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
) ENGINE=InnoDB;

--
-- Dumping data for table `0_supp_trans`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_sys_prefs`
--

DROP TABLE IF EXISTS `0_sys_prefs`;
CREATE TABLE IF NOT EXISTS `0_sys_prefs` (
  `name` varchar(35) NOT NULL default '',
  `category` varchar(30) default NULL,
  `type` varchar(20) NOT NULL default '',
  `length` smallint(6) default NULL,
  `value` tinytext,
  PRIMARY KEY  (`name`),
  KEY `category` (`category`)
) ENGINE=MyISAM;

--
-- Dumping data for table `0_sys_prefs`
--

INSERT INTO `0_sys_prefs` (`name`, `category`, `type`, `length`, `value`) VALUES
('coy_name', 'setup.company', 'varchar', 60, 'Training Co.'),
('gst_no', 'setup.company', 'varchar', 25, '9876543'),
('coy_no', 'setup.company', 'varchar', 25, '123456789'),
('tax_prd', 'setup.company', 'int', 11, '1'),
('tax_last', 'setup.company', 'int', 11, '1'),
('postal_address', 'setup.company', 'tinytext', 0, 'Address 1\r\nAddress 2\r\nAddress 3'),
('phone', 'setup.company', 'varchar', 30, '(222) 111.222.333'),
('fax', 'setup.company', 'varchar', 30, NULL),
('email', 'setup.company', 'varchar', 100, 'delta@delta.com'),
('coy_logo', 'setup.company', 'varchar', 100, 'logo_frontaccounting.jpg'),
('domicile', 'setup.company', 'varchar', 55, NULL),
('curr_default', 'setup.company', 'char', 3, 'USD'),
('use_dimension', 'setup.company', 'tinyint', 1, '1'),
('f_year', 'setup.company', 'int', 11, '1'),
('no_item_list', 'setup.company', 'tinyint', 1, '0'),
('no_customer_list', 'setup.company', 'tinyint', 1, '0'),
('no_supplier_list', 'setup.company', 'tinyint', 1, '0'),
('base_sales', 'setup.company', 'int', 11, '1'),
('time_zone', 'setup.company', 'tinyint', 1, '0'),
('add_pct', 'setup.company', 'int', 5, '-1'),
('round_to', 'setup.company', 'int', 5, '1'),
('login_tout', 'setup.company', 'smallint', 6, '6000'),
('past_due_days', 'glsetup.general', 'int', 11, '30'),
('profit_loss_year_act', 'glsetup.general', 'varchar', 15, '39010001'),
('retained_earnings_act', 'glsetup.general', 'varchar', 15, '39010002'),
('bank_charge_act', 'glsetup.general', 'varchar', 15, '44010009'),
('exchange_diff_act', 'glsetup.general', 'varchar', 15, '44010010'),
('default_credit_limit', 'glsetup.customer', 'int', 11, '1000'),
('accumulate_shipping', 'glsetup.customer', 'tinyint', 1, '0'),
('legal_text', 'glsetup.customer', 'tinytext', 0, NULL),
('freight_act', 'glsetup.customer', 'varchar', 15, '43010004'),
('debtors_act', 'glsetup.sales', 'varchar', 15, '11011001'),
('default_sales_act', 'glsetup.sales', 'varchar', 15, NULL),
('default_sales_discount_act', 'glsetup.sales', 'varchar', 15, '41010002'),
('default_prompt_payment_act', 'glsetup.sales', 'varchar', 15, '41010002'),
('default_delivery_required', 'glsetup.sales', 'smallint', 6, '1'),
('default_dim_required', 'glsetup.dims', 'int', 11, '20'),
('pyt_discount_act', 'glsetup.purchase', 'varchar', 15, '42011003'),
('creditors_act', 'glsetup.purchase', 'varchar', 15, '21010001'),
('po_over_receive', 'glsetup.purchase', 'int', 11, '10'),
('po_over_charge', 'glsetup.purchase', 'int', 11, '10'),
('allow_negative_stock', 'glsetup.inventory', 'tinyint', 1, '0'),
('default_inventory_act', 'glsetup.items', 'varchar', 15, '11040001'),
('default_cogs_act', 'glsetup.items', 'varchar', 15, '42090001'),
('default_adj_act', 'glsetup.items', 'varchar', 15, '42050001'),
('default_inv_sales_act', 'glsetup.items', 'varchar', 15, '41010001'),
('default_assembly_act', 'glsetup.items', 'varchar', 15, '42040001'),
('default_workorder_required', 'glsetup.manuf', 'int', 11, '20'),
('version_id', 'system', 'varchar', 11, '2.3rc'),
('auto_curr_reval', 'setup.company', 'smallint', 6, '1'),
('grn_clearing_act', 'glsetup.purchase', 'varchar', 15, '42011002'),
('bcc_email', 'setup.company', 'varchar', 100, '');

-- --------------------------------------------------------

--
-- Table structure for table `0_sys_types`
--

DROP TABLE IF EXISTS `0_sys_types`;
CREATE TABLE IF NOT EXISTS `0_sys_types` (
  `type_id` smallint(6) NOT NULL default '0',
  `type_no` int(11) NOT NULL default '1',
  `next_reference` varchar(100) NOT NULL default '',
  PRIMARY KEY  (`type_id`)
) ENGINE=InnoDB;

--
-- Dumping data for table `0_sys_types`
--

INSERT INTO `0_sys_types` (`type_id`, `type_no`, `next_reference`) VALUES
(0, 1, '1'),
(1, 1, '1'),
(2, 1, '1'),
(4, 1, '1'),
(10, 1, '1'),
(11, 1, '1'),
(12, 1, '1'),
(13, 1, '1'),
(16, 1, '1'),
(17, 1, '1'),
(18, 1, '1'),
(20, 1, '1'),
(21, 1, '1'),
(22, 1, '1'),
(25, 1, '1'),
(26, 1, '1'),
(28, 1, '1'),
(29, 1, '1'),
(30, 1, '1'),
(32, 1, '1'),
(35, 1, '1'),
(40, 1, '1');

-- --------------------------------------------------------

--
-- Table structure for table `0_tags`
--

DROP TABLE IF EXISTS `0_tags`;
CREATE TABLE IF NOT EXISTS `0_tags` (
  `id` int(11) NOT NULL auto_increment,
  `type` smallint(6) NOT NULL,
  `name` varchar(30) NOT NULL,
  `description` varchar(60) default NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `type` (`type`,`name`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_tags`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_tag_associations`
--

DROP TABLE IF EXISTS `0_tag_associations`;
CREATE TABLE IF NOT EXISTS `0_tag_associations` (
  `record_id` varchar(15) NOT NULL,
  `tag_id` int(11) NOT NULL,
  UNIQUE KEY `record_id` (`record_id`,`tag_id`)
) ENGINE=MyISAM;

--
-- Dumping data for table `0_tag_associations`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_tax_groups`
--

DROP TABLE IF EXISTS `0_tax_groups`;
CREATE TABLE IF NOT EXISTS `0_tax_groups` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(60) NOT NULL default '',
  `tax_shipping` tinyint(1) NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB  AUTO_INCREMENT=3 ;

--
-- Dumping data for table `0_tax_groups`
--

INSERT INTO `0_tax_groups` VALUES(1, 'Tax', 0, 0);
INSERT INTO `0_tax_groups` VALUES(2, 'Tax Exempt', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_tax_group_items`
--

DROP TABLE IF EXISTS `0_tax_group_items`;
CREATE TABLE IF NOT EXISTS `0_tax_group_items` (
  `tax_group_id` int(11) NOT NULL default '0',
  `tax_type_id` int(11) NOT NULL default '0',
  `rate` double NOT NULL default '0',
  PRIMARY KEY  (`tax_group_id`,`tax_type_id`)
) ENGINE=InnoDB;

--
-- Dumping data for table `0_tax_group_items`
--

INSERT INTO `0_tax_group_items` VALUES(1, 1, 5);

-- --------------------------------------------------------

--
-- Table structure for table `0_tax_types`
--

DROP TABLE IF EXISTS `0_tax_types`;
CREATE TABLE IF NOT EXISTS `0_tax_types` (
  `id` int(11) NOT NULL auto_increment,
  `rate` double NOT NULL default '0',
  `sales_gl_code` varchar(15) NOT NULL default '',
  `purchasing_gl_code` varchar(15) NOT NULL default '',
  `name` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  AUTO_INCREMENT=2 ;

--
-- Dumping data for table `0_tax_types`
--

INSERT INTO `0_tax_types` (`id`, `rate`, `sales_gl_code`, `purchasing_gl_code`, `name`, `inactive`) VALUES
(1, 5, '21040001', '21040002', 'Tax', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_trans_tax_details`
--

DROP TABLE IF EXISTS `0_trans_tax_details`;
CREATE TABLE IF NOT EXISTS `0_trans_tax_details` (
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
) ENGINE=InnoDB AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_trans_tax_details`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_useronline`
--

DROP TABLE IF EXISTS `0_useronline`;
CREATE TABLE IF NOT EXISTS `0_useronline` (
  `id` int(11) NOT NULL auto_increment,
  `timestamp` int(15) NOT NULL default '0',
  `ip` varchar(40) NOT NULL default '',
  `file` varchar(100) NOT NULL default '',
  PRIMARY KEY  (`id`),
  KEY `timestamp` (`timestamp`),
  KEY `ip` (`ip`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_useronline`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_users`
--

DROP TABLE IF EXISTS `0_users`;
CREATE TABLE IF NOT EXISTS `0_users` (
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
  `query_size` tinyint(1) unsigned NOT NULL default '10',
  `graphic_links` tinyint(1) default '1',
  `pos` smallint(6) default '1',
  `print_profile` varchar(30) NOT NULL default '',
  `rep_popup` tinyint(1) default '1',
  `sticky_doc_date` tinyint(1) default '0',
  `startup_tab` varchar(20) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `user_id` (`user_id`)
) ENGINE=MyISAM  AUTO_INCREMENT=2 ;

--
-- Dumping data for table `0_users`
--

INSERT INTO `0_users` (`id`, `user_id`, `password`, `real_name`, `role_id`, `phone`, `email`, `language`, `date_format`, `date_sep`, `tho_sep`, `dec_sep`, `theme`, `page_size`, `prices_dec`, `qty_dec`, `rates_dec`, `percent_dec`, `show_gl`, `show_codes`, `show_hints`, `last_visit_date`, `query_size`, `graphic_links`, `pos`, `print_profile`, `rep_popup`, `sticky_doc_date`, `startup_tab`, `inactive`) VALUES
(1, 'admin', '5f4dcc3b5aa765d61d8327deb882cf99', 'Administrator', 2, '', 'adm@adm.com', 'ar_EG', 1, 0, 0, 0, 'default', 'Letter', 2, 2, 4, 1, 1, 0, 1, '2012-09-04 16:37:28', 10, 1, 1, '1', 1, 0, 'orders', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_voided`
--

DROP TABLE IF EXISTS `0_voided`;
CREATE TABLE IF NOT EXISTS `0_voided` (
  `type` int(11) NOT NULL default '0',
  `id` int(11) NOT NULL default '0',
  `date_` date NOT NULL default '0000-00-00',
  `memo_` tinytext NOT NULL,
  UNIQUE KEY `id` (`type`,`id`)
) ENGINE=InnoDB;

--
-- Dumping data for table `0_voided`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_workcentres`
--

DROP TABLE IF EXISTS `0_workcentres`;
CREATE TABLE IF NOT EXISTS `0_workcentres` (
  `id` int(11) NOT NULL auto_increment,
  `name` char(40) NOT NULL default '',
  `description` char(50) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_workcentres`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_workorders`
--

DROP TABLE IF EXISTS `0_workorders`;
CREATE TABLE IF NOT EXISTS `0_workorders` (
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
) ENGINE=InnoDB AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_workorders`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_wo_issues`
--

DROP TABLE IF EXISTS `0_wo_issues`;
CREATE TABLE IF NOT EXISTS `0_wo_issues` (
  `issue_no` int(11) NOT NULL auto_increment,
  `workorder_id` int(11) NOT NULL default '0',
  `reference` varchar(100) default NULL,
  `issue_date` date default NULL,
  `loc_code` varchar(5) default NULL,
  `workcentre_id` int(11) default NULL,
  PRIMARY KEY  (`issue_no`),
  KEY `workorder_id` (`workorder_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_wo_issues`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_wo_issue_items`
--

DROP TABLE IF EXISTS `0_wo_issue_items`;
CREATE TABLE IF NOT EXISTS `0_wo_issue_items` (
  `id` int(11) NOT NULL auto_increment,
  `stock_id` varchar(40) default NULL,
  `issue_id` int(11) default NULL,
  `qty_issued` double default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_wo_issue_items`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_wo_manufacture`
--

DROP TABLE IF EXISTS `0_wo_manufacture`;
CREATE TABLE IF NOT EXISTS `0_wo_manufacture` (
  `id` int(11) NOT NULL auto_increment,
  `reference` varchar(100) default NULL,
  `workorder_id` int(11) NOT NULL default '0',
  `quantity` double NOT NULL default '0',
  `date_` date NOT NULL default '0000-00-00',
  PRIMARY KEY  (`id`),
  KEY `workorder_id` (`workorder_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_wo_manufacture`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_wo_requirements`
--

DROP TABLE IF EXISTS `0_wo_requirements`;
CREATE TABLE IF NOT EXISTS `0_wo_requirements` (
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
) ENGINE=InnoDB AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_wo_requirements`
--

