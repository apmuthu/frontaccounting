-- Front Accounting Extension: Report Generator
-- Extension Name: repgen

-- Table Name: xx_reports
-- Host: localhost
-- Release Date: 23 Dec 2012, 03:06
-- DB Version: 5.1.66-0+squeeze1
-- PHP Version: PHP 5.3.3-7+squeeze14

-- No primary key since text/blob field cannot be in key without specifying length
-- Do not use single quote in functions and in any value of the attrib column for now


DROP TABLE IF EXISTS `xx_reports`;

CREATE TABLE IF NOT EXISTS `xx_reports` (
  `id` varchar(10) NOT NULL DEFAULT '',
  `typ` varchar(10) NOT NULL DEFAULT '',
  `attrib` text NOT NULL
) ENGINE=MyISAM;

INSERT INTO `xx_reports` (`id`, `typ`, `attrib`) VALUES
('F1', 'funct', 'RepDate|2007-09-26|Joe|Date|function RepDate() {return Today()." ".Now();}'),
('F2', 'funct', 'atime|2007-09-21|Bauer|Actual Time|function atime() {return date("h:i a");}'),
('F3', 'funct', 'Host|2007-09-26|Hunt|Host name|function Host(){return $_SERVER["SERVER_NAME"];}'),
('F4', 'funct', 'Oldgroup|2007-09-26|bauer|Value of old group|function Oldgroup($it){return $it->group_old;}'),
('F5', 'funct', 'Newgroup|2007-09-26|Hunt|New group value|function Newgroup($it){return $it->group_new;}'),
('F6', 'funct', 'rec_count|2007-09-26|bauer|total number of records|function rec_count($it) {return $it->count;}'),
('F7', 'funct', 'subcount|2007-09-26|bauer|total number of records of a group|function subcount($it) {return $it->subcount;}'),
('F8', 'funct', 'RepTitle|2007-09-26|Joe|Report Title|function RepTitle($it) \r\n{ return $it->long_name; }'),
('F9', 'funct', 'PageNo|2012-11-10|apmuthu|Page Number|function PageNo($it){return "Page   ".$it->pdf->getPage();}'),
('F10', 'funct', 'Company|2007-09-26|Hunt|Company Name|function Company(){ return get_company_pref("coy_name"); }'),
('F11', 'funct', 'Username|2007-09-26|Hunt|Get Username|function Username(){return $_SESSION["wa_current_user"]->name;}'),
('F12', 'funct', 'FiscalYear|2007-09-26|Hunt|Get current Fiscal Year|function FiscalYear(){$y=get_current_fiscalyear();return sql2date($y["begin"]) . " - " . sql2date($y["end"]);}'),
('B1', 'block', 'block1|2007-09-27|Bauer|Block 1'),
('B1', 'item', 'String|PH|Helvetica|7|20|100|0|Stringitem||||||||'),
('1', 'info', 'Accounts|2012-11-10|Hunt|Accounts List (example report)|portrait|a4|class'),
('1', 'group', 'name|nopage'),
('1', 'select', 'select * from 0_chart_master,0_chart_types,0_chart_class where account_type=id and class_id=cid order by account_code'),
('1', 'item', 'Line|PH|1|1|1|1|1'),
('1', 'item', 'Line|RH|1|1|1|1|1'),
('1', 'item', 'Line|GH|1|1|1|1|1'),
('1', 'item', 'Line|GF|1|1|1|400|1'),
('1', 'item', 'Line|RF|1|1|1|1|1'),
('1', 'item', 'String|RH|Helvetica|8|30|50|-12|Print Out Date:||||||||'),
('1', 'item', 'String|RH|Helvetica|8|30|50|-24|Fiscal Year:||||||||'),
('1', 'item', 'String|RH|Helvetica|8|30|50|-36|Select:||||||||'),
('1', 'item', 'String|PH|Helvetica-Bold|9|20|50|0|Account||||||||'),
('1', 'item', 'String|PH|Helvetica-Bold|9|50|100|0|Account Name||||||||'),
('1', 'item', 'String|PH|Helvetica-Bold|9|20|300|0|Type||||||||'),
('1', 'item', 'String|PH|Helvetica-Bold|9|20l|400|0|Class||||||||'),
('1', 'item', 'String|GF|Helvetica|9|20|50|0|No. of Accounts:||||||||'),
('1', 'item', 'String|RF|Helvetica|9|20|50|0|Grand Total||||||||'),
('1', 'item', 'DB|DE|Helvetica|9|6|50|0|account_code||||||||'),
('1', 'item', 'DB|DE|Helvetica|9|50|100|0|account_name||||||||'),
('1', 'item', 'DB|DE|Helvetica|9|30|300|0|name||||||||'),
('1', 'item', 'DB|DE|Helvetica|9|20|400|0|class_name||||||||'),
('1', 'item', 'Term|RH|Helvetica-Bold|16|50|50|0|RepTitle||||||||'),
('1', 'item', 'Term|RH|Helvetica|8|30|120|-12|RepDate||||||||'),
('1', 'item', 'Term|RH|Helvetica|9|50|400|0|Company||||||||'),
('1', 'item', 'Term|RH|Helvetica|9|50l|400|-12|Username||||||||'),
('1', 'item', 'Term|RH|Helvetica|8|50|400|-24|Host||||||||'),
('1', 'item', 'Term|RH|Helvetica|8|50|120|-24|FiscalYear||||||||'),
('1', 'item', 'Term|PH|Helvetica|9|50|400|18|PageNo||||||||'),
('1', 'item', 'Term|GH|Helvetica|9|50|50|0|Newgroup||||||||'),
('1', 'item', 'Term|GF|Helvetica|9|4r|200|0|subcount||||||||'),
('1', 'item', 'Term|RF|Helvetica|9|4r|200|0|rec_count||||||||');

INSERT INTO `xx_reports` (`id`, `typ`, `attrib`) VALUES 
('2','info','single|2007-09-26|Bauer|Single Page per Record|portrait|a4|single'),
('2','group','|nopage'),
('2','select','select * from xx_reports'),
('2','item','DB|DE|Helvetica-Bold|12||100|600|attrib||||');

INSERT INTO `xx_reports` (`id`, `typ`, `attrib`) VALUES 
('3','info','Reports|2007-10-01|Bauer|List of all stored Reports|portrait|a4|classgrid'),
('3','group','id|newpage'),
('3','select','select * from xx_reports order by id'),
('3','item','String|PF|Helvetica|8|10l|300|10|printed at||||||||'),
('3','item','String|PH|Helvetica|14|40l|200|0|Stored Report|||1|40'),
('3','item','String|GH|Helvetica-Bold|14|10l|200|0|New Group||||||||'),
('3','item','DB|DE|Helvetica|12|6l|100|0|typ||||'),
('3','item','DB|DE|Helvetica|12|40l|150|0|attrib||||||||'),
('3','item','DB|GH|Helvetica-Bold|12|6l|285|0|id||||||||'),
('3','item','DB|PH|Helvetica|14|6l|360|0|id|||1|6||||'),
('3','item','Term|PF|Helvetica|8|20l|460|10|PageNo||||||||'),
('3','item','Term|PF|Helvetica|8|20l|335|10|RepDate||||||||');
