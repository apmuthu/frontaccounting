-- phpMyAdmin SQL Dump
-- version 3.4.10.1deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Czas wygenerowania: 13 Lis 2012, 15:03
-- Wersja serwera: 5.5.24
-- Wersja PHP: 5.3.10-1ubuntu3.4


DROP TABLE IF EXISTS `xx_reports`;
CREATE TABLE IF NOT EXISTS `xx_reports` (
  `id` varchar(10) NOT NULL DEFAULT '',
  `typ` varchar(10) NOT NULL DEFAULT '',
  `attrib` text NOT NULL
) ENGINE=MyISAM;

--
-- Zrzut danych tabeli `xx_reports`
--

INSERT INTO `xx_reports` (`id`, `typ`, `attrib`) VALUES
('6', 'item', 'Line|PH|1|1|1|1|1'),
('F2', 'funct', 'atime|2007-09-21|Bauer|Actual Time|function atime() {return date("h:i a");}'),
('F1', 'funct', 'RepDate|2007-09-26|Joe|Date|function RepDate() {return today()." ".now();}'),
('F4', 'funct', 'oldgroup|2007-09-26|bauer|Value of old group|function oldgroup($it){return $it->group_old;}'),
('F5', 'funct', 'Newgroup|2007-09-26|Hunt|New group value|function newgroup($it){return $it->group_new;}'),
('B1', 'block', 'block1|2007-09-27|Bauer|Block 1'),
('6', 'item', 'Line|GF|1|1|1|400|1'),
('6', 'item', 'DB|DE|Helvetica|9|6|50|0|account_code||||||||'),
('6', 'item', 'Term|GH|Helvetica|9|50|50|0|Newgroup||||||||'),
('F6', 'funct', 'rec_count|2007-09-26|bauer|total number of records|function rec_count($it) {return $it->count;}'),
('6', 'item', 'String|RF|Helvetica|9|20|50|0|Gran Total||||||||'),
('6', 'item', 'String|GF|Helvetica|9|20|50|0|Sum:||||||||'),
('6', 'item', 'DB|DE|Helvetica|9|30|300|0|name||||||||'),
('6', 'item', 'DB|DE|Helvetica|9|20|400|0|class_name||||||||'),
('6', 'item', 'DB|DE|Helvetica|9|50|100|0|account_name||||||||'),
('F7', 'funct', 'subcount|2007-09-26|bauer|total number of records of a group|function subcount($it) {return $it->subcount;}'),
('6', 'select', 'select * from 0_chart_master,0_chart_types,0_chart_class where account_type=id and class_id=cid order by account_code'),
('6', 'item', 'Line|GH|1|1|1|1|1'),
('6', 'item', 'Line|RH|1|1|1|1|1'),
('6', 'item', 'Line|RF|1|1|1|1|1'),
('6', 'item', 'Term|RH|Helvetica-Bold|16|50|50|0|RepTitle||||||||'),
('F8', 'funct', 'RepTitle|2007-09-26|Joe|Report Title|function RepTitle($it) \r\n{ return $it->long_name; }'),
('6', 'item', 'String|RH|Helvetica|8|30|50|-12|Print Out Date:||||||||'),
('6', 'item', 'Term|RH|Helvetica|8|30|120|-12|RepDate||||||||'),
('6', 'item', 'String|RH|Helvetica|8|30|50|-24|Fiscal Year:||||||||'),
('6', 'item', 'String|RH|Helvetica|8|30|50|-36|Select:||||||||'),
('6', 'item', 'Term|GF|Helvetica|9|4r|200|0|subcount||||||||'),
('6', 'item', 'Term|RF|Helvetica|9|4r|200|0|rec_count||||||||'),
('6', 'item', 'String|PH|Helvetica-Bold|9|20|50|0|Account||||||||'),
('6', 'item', 'String|PH|Helvetica-Bold|9|50|100|0|Account Name||||||||'),
('6', 'item', 'String|PH|Helvetica-Bold|9|20|300|0|Type||||||||'),
('6', 'item', 'String|PH|Helvetica-Bold|9|20l|400|0|Class||||||||'),
('6', 'item', 'Term|RH|Helvetica|9|50|400|0|Company||||||||'),
('6', 'item', 'Term|RH|Helvetica|9|50l|400|-12|Username||||||||'),
('6', 'item', 'Term|RH|Helvetica|9|50|400|-36|PageNo||||||||'),
('F9', 'funct', 'PageNo|2012-11-10|Joe|Page Number|function PageNo($it){return &quot;Page   &quot;.$it-&gt;pdf-&gt;getNumPages();}'),
('B1', 'item', 'String|PH|Helvetica|7|20|100|0|Stringitem||||||||'),
('6', 'item', 'Term|RH|Helvetica|8|50|400|-24|Host||||||||'),
('F13', 'funct', 'Host|2007-09-26|Hunt|Host name|function Host(){return $_SERVER[''SERVER_NAME''];}'),
('6', 'group', 'name|nopage'),
('6', 'item', 'Term|RH|Helvetica|8|50|120|-24|FiscalYear||||||||'),
('F12', 'funct', 'FiscalYear|2007-09-26|Hunt|Get current Fiscal Year|function FiscalYear(){$y=get_current_fiscalyear();return sql2date($y[''begin'']) . " - " . sql2date($y[''end'']);}'),
('F11', 'funct', 'Username|2007-09-26|Hunt|Get Username|function Username(){return $_SESSION["wa_current_user"]->name;}'),
('F10', 'funct', 'Company|2007-09-26|Hunt|Company Name|function Company(){ return get_company_pref(''coy_name''); }'),
('6', 'info', 'Accounts|2012-11-10|Hunt|Accounts List (example report)|portrait|a4|class');
