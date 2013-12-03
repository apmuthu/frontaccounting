-- MySQL dump of database 'frontaccount' on host 'localhost'
-- Backup Date and Time: 2010-01-15 08:09
-- Built by Anugerah Cipta Sarana 2.2.3
-- Creator: Rendy Satrya from Indonesia 
-- http://frontaccounting.net
-- Company: Company name
-- User: Administrator
-- COA: in_ID-general.sql
-- Updated to 2.3.19: 2013-12-02 12:57:12 (M Fatah A)


DROP TABLE IF EXISTS `0_areas`;
CREATE TABLE `0_areas` (
  `area_code` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`area_code`),
  UNIQUE KEY `description` (`description`)
) ENGINE=MyISAM ;

INSERT INTO `0_areas` (`area_code`, `description`, `inactive`) VALUES
(1,	'Global',	0);

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
) ENGINE=MyISAM ;


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
) ENGINE=InnoDB ;


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
) ENGINE=MyISAM ;

INSERT INTO `0_bank_accounts` (`account_code`, `account_type`, `bank_account_name`, `bank_account_number`, `bank_name`, `bank_address`, `bank_curr_code`, `dflt_curr_act`, `id`, `last_reconciled_date`, `ending_reconcile_balance`, `inactive`) VALUES
('1060',	0,	'Current account',	'N/A',	'N/A',	'',	'USD',	1,	1,	'0000-00-00 00:00:00',	0,	0),
('1065',	3,	'Petty Cash account',	'N/A',	'N/A',	'',	'USD',	0,	2,	'0000-00-00 00:00:00',	0,	0),
('11111110',	3,	'Kas Kantor',	'',	'',	'',	'IDR',	1,	3,	'0000-00-00 00:00:00',	0,	0),
('11111120',	3,	'Kas Gudang',	'',	'',	'',	'IDR',	0,	4,	'0000-00-00 00:00:00',	0,	0),
('11111121',	3,	'Kas Bon',	'',	'',	'',	'IDR',	0,	5,	'0000-00-00 00:00:00',	0,	0),
('11111210',	3,	'Kas USD',	'',	'',	'',	'USD',	0,	6,	'0000-00-00 00:00:00',	0,	0),
('11111220',	3,	'Kas EUR',	'',	'',	'',	'EUR',	0,	7,	'0000-00-00 00:00:00',	0,	0),
('11113110',	0,	'Deposito IDR - Satu Bulan',	'',	'',	'',	'IDR',	0,	8,	'0000-00-00 00:00:00',	0,	0),
('11113120',	0,	'Deposito IDR - s/d 3 Bulan',	'',	'',	'',	'IDR',	0,	9,	'0000-00-00 00:00:00',	0,	0),
('11113210',	0,	'Deposito USD - Satu Bulan',	'',	'',	'',	'USD',	0,	10,	'0000-00-00 00:00:00',	0,	0),
('11113220',	0,	'Deposito USD - s/d Tiga Bulan',	'',	'',	'',	'USD',	0,	11,	'0000-00-00 00:00:00',	0,	0),
('11121100',	0,	'Deposito diatas 3 bulan s/d satu tahun',	'',	'',	'',	'IDR',	0,	12,	'0000-00-00 00:00:00',	0,	0);

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
) ENGINE=InnoDB ;


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
) ENGINE=MyISAM ;


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
) ENGINE=InnoDB ;


DROP TABLE IF EXISTS `0_chart_class`;
CREATE TABLE `0_chart_class` (
  `cid` varchar(3) NOT NULL,
  `class_name` varchar(60) NOT NULL DEFAULT '',
  `ctype` tinyint(1) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`cid`)
) ENGINE=MyISAM ;

INSERT INTO `0_chart_class` (`cid`, `class_name`, `ctype`, `inactive`) VALUES
('1',	'AKTIVA',	1,	0),
('2',	'HUTANG',	2,	0),
('3',	'MODAL &amp; LABA DITAHAN',	3,	0),
('4',	'PENDAPATAN',	4,	0),
('5',	'HARGA POKOK PENJUALAN',	5,	0),
('6',	'BIAYA',	6,	0),
('7',	'PENDAPATAN DAN BIAYA LAINNYA',	6,	0);

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
) ENGINE=MyISAM ;

INSERT INTO `0_chart_master` (`account_code`, `account_code2`, `account_name`, `account_type`, `inactive`) VALUES
('11111120',	'',	'Kas Gudang',	'11111100',	0),
('11111121',	'',	'Kas BON',	'11111100',	0),
('11111110',	'',	'Kas Kantor',	'11111100',	0),
('11111210',	'',	'Kas USD',	'11111200',	0),
('11111220',	'',	'Kas EUR',	'11111200',	0),
('11111990',	'',	'Pos Silang Kas',	'11110000',	0),
('11112111',	'',	'Bank IDR - 1 - Asset',	'11112110',	0),
('11112112',	'',	'Bank IDR - 1 - Dalam Transit',	'11112110',	0),
('11112211',	'',	'Bank Valas - 1 - Asset',	'11112210',	0),
('11112212',	'',	'Bank Valas - 1 - Dalam Transit',	'11112210',	0),
('11113110',	'',	'Deposito (IDR) - Satu Bulan',	'11113100',	0),
('11113120',	'',	'Deposito (IDR) - s/d Tiga Bulan',	'11113100',	0),
('11113210',	'',	'Deposito (USD) - Satu Bulan',	'11113200',	0),
('11113220',	'',	'Deposito (USD) - s/d Tiga Bulan',	'11113200',	0),
('11119010',	'',	'Penerimaan Belum Dialokasi BANK IDR - 1',	'11119000',	0),
('11119020',	'',	'Penerimaan Belum Dialokasi BANK Valas - 1',	'11119000',	0),
('11119030',	'',	'Penerimaan Tidak Dikenal',	'11119000',	0),
('11121100',	'',	'Deposito diatas 3 bulan  s/d satu tahun.',	'11121000',	0),
('11122100',	'',	'Surat berharga s/d satu tahun',	'11122000',	0),
('11131110',	'',	'Piutang Penjualan Barang',	'11131100',	0),
('11131120',	'',	'Piutang Penjualan Jasa',	'11131100',	0),
('11131130',	'',	'Piutang Belum Difaktur',	'11131100',	0),
('11139110',	'',	'Cadangan Piutang Tak Tertagih - Penjualan Barang',	'11139100',	0),
('11139120',	'',	'Cadangan Piutang Tak Tertagih - Penjualan Jasa',	'11139100',	0),
('11149100',	'',	'Piutang Intercompany',	'11149000',	0),
('11149200',	'',	'Piutang Affiliasi',	'11149000',	0),
('11149300',	'',	'Piutang Direksi',	'11149000',	0),
('11149400',	'',	'Piutang Karyawan Lainnya',	'11149000',	0),
('11149900',	'',	'Piutang Lain-Lain',	'11149000',	0),
('11151100',	'',	'Persediaan Barang Dagangan',	'11151000',	0),
('11151200',	'',	'Persediaan Gudang',	'11151000',	0),
('11151300',	'',	'Persediaan Dalam Transit',	'11151000',	0),
('11152100',	'',	'Asset Proyek',	'11152000',	0),
('11152200',	'',	'Asset Proyek WIP',	'11152000',	0),
('11161010',	'',	'Uang Muka Pembelian',	'11161000',	0),
('11163010',	'',	'Uang Muka Jaminan Penjualan',	'11163000',	0),
('11163900',	'',	'Uang Muka Jaminan Lain-Lain',	'11163000',	0),
('11169010',	'',	'Uang Muka Karyawan',	'11169000',	0),
('11171010',	'',	'Asuransi Dibayar Di Muka',	'11171000',	0),
('11171020',	'',	'Sewa Dibayar Di Muka',	'11171000',	0),
('11171030',	'',	'Bunga Dibayar Di Muka',	'11171000',	0),
('11171900',	'',	'Biaya Dibayar Di Muka Lainnya',	'11171000',	0),
('11172010',	'',	'PPN Masukan Dibayar Dimuka',	'11172000',	0),
('11172020',	'',	'PPN Masukan Yang Ditangguhkan',	'11172000',	0),
('11172030',	'',	'PPh - psl 22 Dibayar Dimuka',	'11172000',	0),
('11172040',	'',	'PPh - psl 23 Dibayar Dimuka',	'11172000',	0),
('11172050',	'',	'PPh - psl 25 Dibayar Dimuka',	'11172000',	0),
('11172060',	'',	'PPh - psl 29 Dibayar Dimuka',	'11172000',	0),
('11172090',	'',	'Fiskal Luar Negeri',	'11172000',	0),
('11180010',	'',	'Biaya Notul Yang Ditangguhkan',	'11180000',	0),
('11180030',	'',	'Biaya Yang Ditangguhkan Lainnya',	'11180000',	0),
('11190010',	'',	'Sewa Yang Masih Harus Diterima',	'11190000',	0),
('11190900',	'',	'Pendapatan Yang Masih Harus Diterima Lainnya',	'11190000',	0),
('12101100',	'',	'Aktiva Pajak Tangguhan',	'12100000',	0),
('12201110',	'',	'Deposito (IDR) - Satu Tahun',	'12201100',	0),
('12201120',	'',	'Deposito (IDR) - Dua Tahun',	'12201100',	0),
('12201210',	'',	'Deposito (USD) - Satu Tahun',	'12201200',	0),
('12201220',	'',	'Deposito (USD) - Dua Tahun',	'12201200',	0),
('12202110',	'',	'Penyertaan Saham',	'12202000',	0),
('12311101',	'',	'Tanah - Perl Langsung',	'12311100',	0),
('12311102',	'',	'Bangunan - Perl Langsung',	'12311100',	0),
('12311103',	'',	'Mesin dan Peralatan - Perl Langsung',	'12311100',	0),
('12311104',	'',	'Kendaraan - Perl Langsung',	'12311100',	0),
('12311105',	'',	'Inventaris Kantor - Perl Langsung',	'12311100',	0),
('12311106',	'',	'Instalasi &amp; Renovasi',	'12311100',	0),
('12311201',	'',	'Akm. Penys Bangunan - Perl Langsung',	'12311200',	0),
('12311202',	'',	'Akm. Penys Mesin - Perl Langsung',	'12311200',	0),
('12311203',	'',	'Akm. Penys Kendaraan - Perl Langsung',	'12311200',	0),
('12311204',	'',	'Akm. Penys Inventaris - Perl Langsung',	'12311200',	0),
('12311205',	'',	'Akm. Penys Instalasi &amp; Renovasi',	'12311200',	0),
('12312101',	'',	'Bangunan - Aktiva Leasing',	'12312100',	0),
('12312102',	'',	'Mesin dan Peralatan - Aktiva Leasing',	'12312100',	0),
('12312103',	'',	'Kendaraan - Aktiva Leasing',	'12312100',	0),
('12312104',	'',	'Inventaris Kantor - Aktiva Leasing',	'12312100',	0),
('12312201',	'',	'Akm Penys Bangunan - Aktiva Leasing',	'12312200',	0),
('12312202',	'',	'Akm Penys Mesin dan Peralatan - Aktiva Leasing',	'12312200',	0),
('12312203',	'',	'Akm Penys Kendaraan - Aktiva Leasing',	'12312200',	0),
('12312204',	'',	'Akm Penys Inventaris Kantor - Aktiva Leasing',	'12312200',	0),
('12313101',	'',	'Renovasi Sewa Bangunan Kantor Electric',	'12313000',	0),
('12313102',	'',	'Bangunan Gudang Dalam Penyelesaian',	'12313000',	0),
('12313103',	'',	'Sarana &amp; Prasarana Kantor - Dalam Penyelesaian',	'12313000',	0),
('12314101',	'',	'Tanah - Properti Invenstasi',	'12314100',	0),
('12314102',	'',	'Bangunan - Properti Invenstasi',	'12314100',	0),
('12314103',	'',	'Mesin dan Peralatan - Properti Invenstasi',	'12314100',	0),
('12314104',	'',	'Kendaraan - Properti Invenstasi',	'12314100',	0),
('12314105',	'',	'Inventaris Kantor - Properti Invenstasi',	'12314100',	0),
('12314201',	'',	'Akm. Penys Bangunan - Properti Invenstasi',	'12314200',	0),
('12314202',	'',	'Akm. Penys Mesin dan Peralatan - Properti Invenstasi',	'12314200',	0),
('12314203',	'',	'Akm. Penys Kendaraan - Properti Invenstasi',	'12314200',	0),
('12314204',	'',	'Akm. Penys Inventaris - Properti Invenstasi',	'12314200',	0),
('12321100',	'',	'HAKI',	'12321000',	0),
('12321200',	'',	'Goodwill',	'12321000',	0),
('12901000',	'',	'Akta Pendirian &amp; Perizinan',	'12900000',	0),
('12902000',	'',	'Hak Atas Tanah',	'12900000',	0),
('21101010',	'',	'Hutang Bank Jangka Pendek',	'21101000',	0),
('21102110',	'',	'Hutang Dagang',	'21102100',	0),
('21102120',	'',	'Hutang Jasa',	'21102100',	0),
('21102130',	'',	'Terima Barang Belum Difaktur',	'21102100',	0),
('21102140',	'',	'Seleksi Pembayaran',	'21102100',	0),
('21103010',	'',	'Gaji Yang Masih Harus Dibayar',	'21103000',	0),
('21103020',	'',	'Komisi Penjualan Yang Masih Harus Dibayar',	'21103000',	0),
('21103030',	'',	'Bunga Bank Yang Masih Harus Dibayar',	'21103000',	0),
('21103040',	'',	'Telepon Yang Masih Harus Dibayar',	'21103000',	0),
('21103050',	'',	'Listrik &amp; Air Yang Masih Harus Dibayar',	'21103000',	0),
('21103060',	'',	'Asuransi Yang Masih Harus Dibayar',	'21103000',	0),
('21103070',	'',	'Biaya Impor Yang Masih Harus Dibayar',	'21103000',	0),
('21103900',	'',	'Biaya Yang Masih harus Dibayar Lainnya',	'21103000',	0),
('21104110',	'',	'PPN Keluaran',	'21104100',	0),
('21104120',	'',	'PPN Keluaran Yang Ditangguhkan',	'21104100',	0),
('21104190',	'',	'WithHolding (Tax)',	'21104100',	0),
('21104210',	'',	'Hutang PPh psl 21',	'21104200',	0),
('21104220',	'',	'Hutang PPh psl 23',	'21104200',	0),
('21104230',	'',	'Hutang PPh psl 25',	'21104200',	0),
('21104240',	'',	'Hutang PPh psl 26',	'21104200',	0),
('21104250',	'',	'Hutang PPh psl 29',	'21104200',	0),
('21104260',	'',	'Hutang PPh Final psl 4 ayat 2',	'21104200',	0),
('21105010',	'',	'Uang Muka Penjualan',	'21105000',	0),
('21105020',	'',	'Sewa Diterima Di Muka',	'21105000',	0),
('21105030',	'',	'Pendapatan Diterima Di Muka Lainnya',	'21105000',	0),
('21106100',	'',	'Hutang Intercompany',	'21106000',	0),
('21106200',	'',	'Hutang Affiliasi',	'21106000',	0),
('21106300',	'',	'Hutang Direksi',	'21106000',	0),
('21106900',	'',	'Hutang Jangka Pendek Lain-Lain',	'21106000',	0),
('21107010',	'',	'Hutang Bank Jangka Panjang-Current',	'21107000',	0),
('21107020',	'',	'Hutang Leasing',	'21107000',	0),
('21107030',	'',	'Hutang Jgk Pnj yg akan Jt Tempo 1 th Lainnya',	'21107000',	0),
('22001000',	'',	'Kewajiban Pajak Tangguhan',	'22000000',	0),
('22002000',	'',	'Kewajiban diestimasi atas Imbalan Kerja',	'22000000',	0),
('22003000',	'',	'Hutang Bank Jangka Panjang',	'22000000',	0),
('22004000',	'',	'Hutang Leasing',	'22000000',	0),
('22005000',	'',	'Hutang Jangka Panjang Lain-Lain',	'22000000',	0),
('31011010',	'',	'Modal Disetor - Direksi 1',	'31011000',	0),
('31011020',	'',	'Modal Disetor - Direksi 2',	'31011000',	0),
('32021010',	'',	'Agio / Disagio - Direksi 1',	'32021000',	0),
('32021020',	'',	'Agio / Disagio - Direksi 2',	'32021000',	0),
('33031010',	'',	'Tanah - Penilaian Kembali',	'33031000',	0),
('33031020',	'',	'Bangunan - Penilaian Kembali',	'33031000',	0),
('33031030',	'',	'Mesin dan Peralatan - Penilaian Kembali',	'33031000',	0),
('33031040',	'',	'Kendaraan - Penilaian Kembali',	'33031000',	0),
('33031050',	'',	'Inventaris Kantor - Penilaian Kembali',	'33031000',	0),
('34041010',	'',	'Deviden - Direksi 1',	'34041000',	0),
('34041020',	'',	'Deviden - Direksi 2',	'34041000',	0),
('35051010',	'',	'Laba / (Rugi) Ditahan',	'35051000',	0),
('35051020',	'',	'Laba / (Rugi) Berjalan',	'35051000',	0),
('41001000',	'',	'Penjualan Barang Usaha',	'41000000',	0),
('41002000',	'',	'Penjualan Jasa Service',	'41000000',	0),
('41003000',	'',	'Pendapatan Belum Difaktur',	'41000000',	0),
('41004000',	'',	'Komisi Penjualan',	'41000000',	0),
('42001000',	'',	'Diskon Penjualan',	'42000000',	0),
('44001000',	'',	'Retur Penjualan',	'44000000',	0),
('51010000',	'',	'HPP Produk',	'50000000',	0),
('51020000',	'',	'Pembelian Jasa',	'50000000',	0),
('51030000',	'',	'Penyesuaian HPP',	'50000000',	0),
('51040000',	'',	'Diskon Pembelian',	'50000000',	0),
('51050000',	'',	'Selisih Persediaan',	'50000000',	0),
('51060000',	'',	'Penyesuaian Persediaan',	'50000000',	0),
('51070000',	'',	'Revaluasi Persediaan',	'50000000',	0),
('59010000',	'',	'Varian Harga Faktur',	'59000000',	0),
('59020000',	'',	'Varian Harga Beli',	'59000000',	0),
('59030000',	'',	'Varian Harga Beli Offset',	'59000000',	0),
('61101110',	'',	'Biaya Gaji Bulanan',	'61100000',	0),
('61101120',	'',	'Biaya Upah Harian',	'61100000',	0),
('61101130',	'',	'Biaya Transport Karyawan',	'61100000',	0),
('61101140',	'',	'Biaya Uang Makan Karyawan',	'61100000',	0),
('61101150',	'',	'Biaya Pengobatan',	'61100000',	0),
('61101160',	'',	'Biaya Lembur',	'61100000',	0),
('61101170',	'',	'Biaya Asuransi / JAMSOSTEK',	'61100000',	0),
('61101180',	'',	'Biaya THR Karyawan',	'61100000',	0),
('61101190',	'',	'Biaya Bonus Karyawan',	'61100000',	0),
('61101200',	'',	'Biaya Tunjangan PPH 21',	'61100000',	0),
('61101210',	'',	'Biaya Recruitment &amp; Training',	'61100000',	0),
('61101900',	'',	'Biaya Karyawan Lainnya',	'61100000',	0),
('61201110',	'',	'Biaya Iklan &amp; Promosi',	'61200000',	0),
('61201120',	'',	'Biaya Komisi Penjualan Sales',	'61200000',	0),
('61201130',	'',	'Biaya Komisi Penjualan Customer',	'61200000',	0),
('61201140',	'',	'Biaya Isentif Penjualan Sales',	'61200000',	0),
('61201150',	'',	'Biaya Bonus Penjualan Sales',	'61200000',	0),
('61201160',	'',	'Biaya Entertainment',	'61200000',	0),
('61201170',	'',	'Biaya Disain',	'61200000',	0),
('61201180',	'',	'Biaya Sample',	'61200000',	0),
('61201190',	'',	'Biaya Trucking/Ekspedisi',	'61200000',	0),
('61201900',	'',	'Biaya Marketing Lain-lain',	'61200000',	0),
('61301110',	'',	'Biaya Perbaikan &amp; Perawatan Gedung',	'61300000',	0),
('61301120',	'',	'Biaya Perbaikan &amp; Perawatan Kendaraan',	'61300000',	0),
('61301130',	'',	'Biaya Perbaikan &amp; Perawatan Mesin',	'61300000',	0),
('61301140',	'',	'Biaya Perbaikan &amp; Perawatan Inventaris',	'61300000',	0),
('61301900',	'',	'Biaya Perbaikan &amp; Perawatan Lainnya',	'61300000',	0),
('61401110',	'',	'Biaya Telepon - Kantor',	'61400000',	0),
('61401120',	'',	'Biaya Telepon - Gudang',	'61400000',	0),
('61401130',	'',	'Biaya FAX - Kantor',	'61400000',	0),
('61401140',	'',	'Biaya Handphone',	'61400000',	0),
('61401150',	'',	'Biaya Internet',	'61400000',	0),
('61401160',	'',	'Biaya Information Technology',	'61400000',	0),
('61401900',	'',	'Biaya Telekomunikasi Lainnya',	'61400000',	0),
('61501110',	'',	'Biaya Listrik',	'61500000',	0),
('61501120',	'',	'Biaya Air',	'61500000',	0),
('61601110',	'',	'Biaya Sewa Kantor',	'61600000',	0),
('61601120',	'',	'Biaya Sewa Gudang',	'61600000',	0),
('61601130',	'',	'Biaya Sewa Kendaraan',	'61600000',	0),
('61601140',	'',	'Biaya Sewa Alat Berat',	'61600000',	0),
('61601900',	'',	'Biaya Sewa Lainnya',	'61600000',	0),
('61701110',	'',	'Biaya Perlengkapan',	'61700000',	0),
('61701120',	'',	'Biaya Konsultan &amp; Audit',	'61700000',	0),
('61701130',	'',	'Biaya Iuran &amp; Sumbangan',	'61700000',	0),
('61701140',	'',	'Biaya Alat Tulis',	'61700000',	0),
('61701150',	'',	'Biaya Pembelian Rumah Tangga',	'61700000',	0),
('61701160',	'',	'Biaya Pos &amp; Meterai',	'61700000',	0),
('61701170',	'',	'Biaya Perizinan',	'61700000',	0),
('61701180',	'',	'Biaya Surat-surat Kendaraan',	'61700000',	0),
('61701190',	'',	'Biaya Foto Copy, Penjilidan &amp; Cetakan',	'61700000',	0),
('61701200',	'',	'Biaya Direksi',	'61700000',	0),
('61701210',	'',	'Biaya Pajak Bumi &amp; Bangunan',	'61700000',	0),
('61701900',	'',	'Biaya Kantor Lainnya',	'61700000',	0),
('61801110',	'',	'Biaya Research &amp; Development',	'61800000',	0),
('61801120',	'',	'Biaya Laboratorium',	'61800000',	0),
('61801900',	'',	'Biaya R&amp;D Lainnya',	'61800000',	0),
('61901110',	'',	'Biaya Bahan Bakar Minyak',	'61900000',	0),
('61901120',	'',	'Biaya Kuli &amp; Bongkar Kontainer',	'61900000',	0),
('61901130',	'',	'Biaya Tol &amp; Parkir',	'61900000',	0),
('61901140',	'',	'Biaya Keamanan',	'61900000',	0),
('61901150',	'',	'Biaya Angkut &amp; Packing',	'61900000',	0),
('61901160',	'',	'Biaya Meeting',	'61900000',	0),
('61901170',	'',	'Biaya Rokok',	'61900000',	0),
('61901180',	'',	'Biaya Langganan Majalah &amp; Koran',	'61900000',	0),
('61901190',	'',	'Biaya Rekreasi Karyawan',	'61900000',	0),
('61901200',	'',	'Biaya Perjalanan Dinas DN',	'61900000',	0),
('61901210',	'',	'Biaya Perjalanan Dinas LN',	'61900000',	0),
('61901211',	'',	'Biaya Bunga Leasing',	'61900000',	0),
('61901900',	'',	'Biaya Umum Lain-lain',	'61900000',	0),
('62101110',	'',	'Biaya Penyusutan Bangunan',	'62100000',	0),
('62101120',	'',	'Biaya Penyusutan Kendaraan',	'62100000',	0),
('62101130',	'',	'Biaya Penyusutan Inventaris',	'62100000',	0),
('62101140',	'',	'Biaya Penyusutan Mesin dan Peralatan',	'62100000',	0),
('62201110',	'',	'Biaya Amortisasi HAKI',	'62200000',	0),
('62201120',	'',	'Biaya Amortisasi Goodwill',	'62200000',	0),
('70011110',	'',	'Pendapatan Buku Kas',	'70011000',	0),
('70011120',	'',	'Pendapatan Bunga Bank',	'70011000',	0),
('70011130',	'',	'Pendapatan Selisih Kurs',	'70011000',	0),
('70011140',	'',	'Taksiran Pendapatan Selisih Kurs',	'70011000',	0),
('70011150',	'',	'Laba Revaluasi Bank',	'70011000',	0),
('70011160',	'',	'Penyesuaian Laba Bank',	'70011000',	0),
('70011180',	'',	'Pendapatan Diskon Pembayaran',	'70011000',	0),
('70011900',	'',	'Pendapatan Lain-lain',	'70011000',	0),
('70021110',	'',	'Biaya Buku Kas',	'70021000',	0),
('70021120',	'',	'Biaya Bunga Bank',	'70021000',	0),
('70021130',	'',	'Kerugian Selisih Kurs',	'70021000',	0),
('70021140',	'',	'Taksiran Kerugian Selisih Kurs',	'70021000',	0),
('70021150',	'',	'Rugi Revaluasi Bank',	'70021000',	0),
('70021160',	'',	'Penyesuaian Rugi Bank',	'70021000',	0),
('70021170',	'',	'Biaya Administrasi Bank',	'70021000',	0),
('70021180',	'',	'Biaya Pembulatan Pembayaran',	'70021000',	0),
('70021190',	'',	'Selisih Pembulatan Kurs',	'70021000',	0),
('70021200',	'',	'Cash Discount Penjualan',	'70021000',	0),
('70021210',	'',	'Biaya Selisih Kas Kecil',	'70021000',	0),
('70021220',	'',	'Biaya Piutang Tak Tertagih',	'70021000',	0),
('70021910',	'',	'Pos Default',	'70021000',	0),
('70021920',	'',	'Suspense Balancing',	'70021000',	0),
('70021930',	'',	'Suspense Error',	'70021000',	0),
('70021990',	'',	'Biaya Lainnya',	'70021000',	0),
('80001100',	'',	'Pajak Penghasilan Badan',	'80000000',	0),
('80001200',	'',	'Pajak Tangguhan',	'80000000',	0),
('90001110',	'',	'Ikhtisar Laba / (Rugi) Ditahan',	'90000000',	0),
('90001120',	'',	'Selisih Koreksi L/R Berjalan',	'90000000',	0),
('90001130',	'',	'Komitmen PO',	'90000000',	0),
('90001140',	'',	'Komitmen SO',	'90000000',	0),
('90009000',	'',	'Offset Saldo Awal',	'90000000',	0);

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
) ENGINE=MyISAM ;

INSERT INTO `0_chart_types` (`id`, `name`, `class_id`, `parent`, `inactive`) VALUES
('11000000',	'AKTIVA LANCAR',	'1',	'',	0),
('11110000',	'KAS DAN SETARA KAS',	'1',	'11000000',	0),
('11111000',	'KAS',	'1',	'11110000',	0),
('11111100',	'Kas IDR',	'1',	'11111000',	0),
('11111200',	'KAS VALAS',	'1',	'11111000',	0),
('11112000',	'BANK',	'1',	'11110000',	0),
('11112100',	'BANK IDR',	'1',	'11112000',	0),
('11112110',	'BANK IDR - 1',	'1',	'11112100',	0),
('11112200',	'BANK VALAS',	'1',	'11112000',	0),
('11112210',	'BANK VALAS - 1',	'1',	'11112200',	0),
('11113000',	'DEPOSITO JANGKA PENDEK',	'1',	'11110000',	0),
('11113100',	'Deposito IDR',	'1',	'11113000',	0),
('11113200',	'Deposito VALAS',	'1',	'11113000',	0),
('11119000',	'PENERIMAAN BELUM TERALOKASI',	'1',	'11110000',	0),
('11120000',	'INVESTASI JANGKA PENDEK',	'1',	'11000000',	0),
('11121000',	'DEPOSITO',	'1',	'11120000',	0),
('11122000',	'SURAT-SURAT BERHARGA',	'1',	'11120000',	0),
('11130000',	'PIUTANG USAHA',	'1',	'11000000',	0),
('11131100',	'PIUTANG USAHA',	'1',	'11130000',	0),
('11139100',	'CADANGAN PIUTANG TAK TERTAGIH',	'1',	'11130000',	0),
('11149000',	'PIUTANG LAIN-LAIN',	'1',	'11000000',	0),
('11150000',	'PERSEDIAAN',	'1',	'11000000',	0),
('11151000',	'PERSEDIAAN UNTUK USAHA',	'1',	'11150000',	0),
('11152000',	'PERSEDIAAN PROYEK',	'1',	'11150000',	0),
('11160000',	'UANG MUKA YANG DIBAYAR',	'1',	'11000000',	0),
('11161000',	'UANG MUKA PEMBELIAN',	'1',	'11160000',	0),
('11163000',	'UANG MUKA JAMINAN',	'1',	'11160000',	0),
('11169000',	'UANG MUKA LAINNYA',	'1',	'11160000',	0),
('11170000',	'BIAYA DAN PAJAK DIBAYAR DIMUKA',	'1',	'11000000',	0),
('11171000',	'BIAYA DIBAYAR DIMUKA',	'1',	'11170000',	0),
('11172000',	'PAJAK DIBAYAR DIMUKA',	'1',	'11170000',	0),
('11180000',	'BIAYA YANG DITANGGUHKAN',	'1',	'11000000',	0),
('11190000',	'PENDAPATAN YANG MASIH HARUS DITERIMA',	'1',	'11000000',	0),
('12000000',	'AKTIVA TIDAK LANCAR',	'1',	'',	0),
('12100000',	'AKTIVA PAJAK TANGGUHAN',	'1',	'12000000',	0),
('12200000',	'INVESTASI JANGKA PANJANG',	'1',	'12000000',	0),
('12201000',	'DEPOSITO JANGKA PANJANG',	'1',	'12200000',	0),
('12201100',	'DEPOSITO (IDR)',	'1',	'12201000',	0),
('12201200',	'DEPOSITO (VALAS)',	'1',	'12201000',	0),
('12202000',	'PENYERTAAN',	'1',	'12200000',	0),
('12300000',	'AKTIVA TETAP',	'1',	'12000000',	0),
('12310000',	'AKTIVA TETAP BERWUJUD',	'1',	'12300000',	0),
('12311000',	'AKTIVA PEROLEHAN LANGSUNG',	'1',	'12310000',	0),
('12311100',	'AKTIVA HARGA PEROLEHAN',	'1',	'12311000',	0),
('12311200',	'AKUMULASI PENYUSUTAN AKTIVA TETAP',	'1',	'12311000',	0),
('12312000',	'AKTIVA LEASING',	'1',	'12310000',	0),
('12312100',	'AKTIVA HARGA PEROLEHAN',	'1',	'12312000',	0),
('12312200',	'AKUMULASI PENYUSUTAN AKTIVA LEASING',	'1',	'12312000',	0),
('12313000',	'AKTIVA DALAM PENYELESAIAN',	'1',	'12310000',	0),
('12314000',	'PROPERTI INVESTASI',	'1',	'12310000',	0),
('12314100',	'AKTIVA HARGA PEROLEHAN',	'1',	'12314000',	0),
('12314200',	'AKUMULASI PENYUSUTAN AKTIVA LEASING',	'1',	'12314000',	0),
('12320000',	'AKTIVA TETAP TIDAK BERWUJUD',	'1',	'12314200',	0),
('12321000',	'AKTIVA TIDAK BERWUJUD - HARGA PEROLEHAN',	'1',	'12320000',	0),
('12900000',	'AKTIVA TETAP LAINNYA',	'1',	'12000000',	0),
('21000000',	'HUTANG JANGKA PENDEK',	'2',	'',	0),
('21101000',	'HUTANG BANK',	'2',	'21000000',	0),
('21102000',	'HUTANG USAHA',	'2',	'21000000',	0),
('21102100',	'HUTANG USAHA',	'2',	'21102000',	0),
('21103000',	'HUTANG BIAYA',	'2',	'21000000',	0),
('21104000',	'HUTANG PAJAK',	'2',	'21000000',	0),
('21104100',	'HUTANG PPN',	'2',	'21104000',	0),
('21104200',	'HUTANG PPh',	'2',	'21104000',	0),
('21105000',	'PENDAPATAN DITERIMA DI MUKA',	'2',	'21000000',	0),
('21106000',	'HUTANG JANGKA PENDEK LAINNYA',	'2',	'21000000',	0),
('21107000',	'HUTANG JANGKA PANJANG YANG AKAN JT TEMPO 1 TH',	'2',	'21000000',	0),
('22000000',	'HUTANG JANGKA PANJANG',	'2',	'',	0),
('31011000',	'MODAL DISETOR',	'3',	'',	0),
('32021000',	'AGIO / DISAGIO',	'3',	'',	0),
('33031000',	'PENILAIAN KEMBALI ATAS AKTIVA',	'3',	'',	0),
('34041000',	'DIVIDEN',	'3',	'',	0),
('35051000',	'LABA / (RUGI)',	'3',	'',	0),
('41000000',	'PENJUALAN',	'4',	'',	0),
('42000000',	'DISKON PENJUALAN',	'4',	'',	0),
('44000000',	'RETUR PENJUALAN',	'4',	'',	0),
('50000000',	'HARGA POKOK PENJUALAN',	'5',	'',	0),
('59000000',	'SELISIH HPP',	'5',	'',	0),
('61000000',	'BIAYA OPERASIONAL',	'6',	'',	0),
('61100000',	'BIAYA KARYAWAN',	'6',	'61000000',	0),
('61200000',	'BIAYA MARKETING',	'6',	'61000000',	0),
('61300000',	'BIAYA PERBAIKAN &amp; PERAWATAN',	'6',	'61000000',	0),
('61400000',	'BIAYA FAX &amp; TELEKOMUNIKASI',	'6',	'61000000',	0),
('61500000',	'BIAYA LISTRIK &amp; AIR',	'6',	'61000000',	0),
('61600000',	'BIAYA SEWA',	'6',	'61000000',	0),
('61700000',	'BIAYA KANTOR',	'6',	'61000000',	0),
('61800000',	'BIAYA R&amp;D',	'6',	'61000000',	0),
('61900000',	'BIAYA UMUM',	'6',	'61000000',	0),
('62000000',	'BIAYA PENYUSUTAN &amp; AMORTISASI',	'6',	'',	0),
('62100000',	'BIAYA PENYUSUTAN',	'6',	'62000000',	0),
('62200000',	'BIAYA AMORTISASI',	'6',	'62000000',	0),
('70011000',	'PENDAPATAN LAIN-LAIN',	'7',	'',	0),
('70021000',	'BIAYA LAIN-LAIN',	'7',	'',	0),
('80000000',	'PAJAK PENGHASILAN',	'6',	'',	0),
('90000000',	'MEMO',	'6',	'',	0);

DROP TABLE IF EXISTS `0_comments`;
CREATE TABLE `0_comments` (
  `type` int(11) NOT NULL DEFAULT '0',
  `id` int(11) NOT NULL DEFAULT '0',
  `date_` date DEFAULT '0000-00-00',
  `memo_` tinytext,
  KEY `type_and_id` (`type`,`id`)
) ENGINE=InnoDB ;


DROP TABLE IF EXISTS `0_credit_status`;
CREATE TABLE `0_credit_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reason_description` char(100) NOT NULL DEFAULT '',
  `dissallow_invoices` tinyint(1) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `reason_description` (`reason_description`)
) ENGINE=MyISAM ;

INSERT INTO `0_credit_status` (`id`, `reason_description`, `dissallow_invoices`, `inactive`) VALUES
(1,	'Good History',	0,	0),
(3,	'No more work until payment received',	1,	0),
(4,	'In liquidation',	1,	0);

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
) ENGINE=InnoDB ;

INSERT INTO `0_crm_categories` (`id`, `type`, `action`, `name`, `description`, `system`, `inactive`) VALUES
(1,	'cust_branch',	'general',	'General',	'General contact data for customer branch (overrides company setting)',	1,	0),
(2,	'cust_branch',	'invoice',	'Invoices',	'Invoice posting (overrides company setting)',	1,	0),
(3,	'cust_branch',	'order',	'Orders',	'Order confirmation (overrides company setting)',	1,	0),
(4,	'cust_branch',	'delivery',	'Deliveries',	'Delivery coordination (overrides company setting)',	1,	0),
(5,	'customer',	'general',	'General',	'General contact data for customer',	1,	0),
(6,	'customer',	'order',	'Orders',	'Order confirmation',	1,	0),
(7,	'customer',	'delivery',	'Deliveries',	'Delivery coordination',	1,	0),
(8,	'customer',	'invoice',	'Invoices',	'Invoice posting',	1,	0),
(9,	'supplier',	'general',	'General',	'General contact data for supplier',	1,	0),
(10,	'supplier',	'order',	'Orders',	'Order confirmation',	1,	0),
(11,	'supplier',	'delivery',	'Deliveries',	'Delivery coordination',	1,	0),
(12,	'supplier',	'invoice',	'Invoices',	'Invoice posting',	1,	0);

DROP TABLE IF EXISTS `0_crm_contacts`;
CREATE TABLE `0_crm_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) NOT NULL DEFAULT '0' COMMENT 'foreign key to crm_contacts',
  `type` varchar(20) NOT NULL COMMENT 'foreign key to crm_categories',
  `action` varchar(20) NOT NULL COMMENT 'foreign key to crm_categories',
  `entity_id` varchar(11) DEFAULT NULL COMMENT 'entity id in related class table',
  PRIMARY KEY (`id`),
  KEY `type` (`type`,`action`)
) ENGINE=InnoDB ;


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
) ENGINE=InnoDB ;


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
) ENGINE=MyISAM ;

INSERT INTO `0_currencies` (`currency`, `curr_abrev`, `curr_symbol`, `country`, `hundreds_name`, `auto_update`, `inactive`) VALUES
('US Dollars',	'USD',	'$',	'United States',	'Cents',	1,	0),
('Euro',	'EUR',	'?',	'Europe',	'Cents',	1,	0),
('Rupiah',	'IDR',	'Rp',	'Indonesia',	'Sen',	1,	0);

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
) ENGINE=InnoDB ;


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
) ENGINE=MyISAM ;


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
) ENGINE=MyISAM ;


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
) ENGINE=InnoDB ;


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
) ENGINE=InnoDB ;


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
) ENGINE=InnoDB ;


DROP TABLE IF EXISTS `0_exchange_rates`;
CREATE TABLE `0_exchange_rates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `curr_code` char(3) NOT NULL DEFAULT '',
  `rate_buy` double NOT NULL DEFAULT '0',
  `rate_sell` double NOT NULL DEFAULT '0',
  `date_` date NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `curr_code` (`curr_code`,`date_`)
) ENGINE=MyISAM ;


DROP TABLE IF EXISTS `0_fiscal_year`;
CREATE TABLE `0_fiscal_year` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `begin` date DEFAULT '0000-00-00',
  `end` date DEFAULT '0000-00-00',
  `closed` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `begin` (`begin`),
  UNIQUE KEY `end` (`end`)
) ENGINE=InnoDB ;

INSERT INTO `0_fiscal_year` (`id`, `begin`, `end`, `closed`) VALUES
(1,	concat(year(now()),'-01-01'),	concat(year(now()),'-12-31'),	0);

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
) ENGINE=InnoDB ;


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
) ENGINE=InnoDB ;


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
) ENGINE=InnoDB ;


DROP TABLE IF EXISTS `0_groups`;
CREATE TABLE `0_groups` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `description` (`description`)
) ENGINE=MyISAM ;

INSERT INTO `0_groups` (`id`, `description`, `inactive`) VALUES
(1,	'Small',	0),
(2,	'Medium',	0),
(3,	'Large',	0);

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
) ENGINE=MyISAM ;


DROP TABLE IF EXISTS `0_item_tax_types`;
CREATE TABLE `0_item_tax_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL DEFAULT '',
  `exempt` tinyint(1) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB ;

INSERT INTO `0_item_tax_types` (`id`, `name`, `exempt`, `inactive`) VALUES
(1,	'Penjualan Regular',	0,	0);

DROP TABLE IF EXISTS `0_item_tax_type_exemptions`;
CREATE TABLE `0_item_tax_type_exemptions` (
  `item_tax_type_id` int(11) NOT NULL DEFAULT '0',
  `tax_type_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`item_tax_type_id`,`tax_type_id`)
) ENGINE=InnoDB ;


DROP TABLE IF EXISTS `0_item_units`;
CREATE TABLE `0_item_units` (
  `abbr` varchar(20) NOT NULL,
  `name` varchar(40) NOT NULL,
  `decimals` tinyint(2) NOT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`abbr`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM ;

INSERT INTO `0_item_units` (`abbr`, `name`, `decimals`, `inactive`) VALUES
('ea.',	'Each',	0,	0);

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
) ENGINE=MyISAM ;

INSERT INTO `0_locations` (`loc_code`, `location_name`, `delivery_address`, `phone`, `phone2`, `fax`, `email`, `contact`, `inactive`) VALUES
('DEF',	'Default',	'N/A',	'',	'',	'',	'',	'',	0);

DROP TABLE IF EXISTS `0_loc_stock`;
CREATE TABLE `0_loc_stock` (
  `loc_code` char(5) NOT NULL DEFAULT '',
  `stock_id` char(20) NOT NULL DEFAULT '',
  `reorder_level` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`loc_code`,`stock_id`),
  KEY `stock_id` (`stock_id`)
) ENGINE=InnoDB ;


DROP TABLE IF EXISTS `0_movement_types`;
CREATE TABLE `0_movement_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM ;

INSERT INTO `0_movement_types` (`id`, `name`, `inactive`) VALUES
(1,	'Adjustment',	0);

DROP TABLE IF EXISTS `0_payment_terms`;
CREATE TABLE `0_payment_terms` (
  `terms_indicator` int(11) NOT NULL AUTO_INCREMENT,
  `terms` char(80) NOT NULL DEFAULT '',
  `days_before_due` smallint(6) NOT NULL DEFAULT '0',
  `day_in_following_month` smallint(6) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`terms_indicator`),
  UNIQUE KEY `terms` (`terms`)
) ENGINE=MyISAM ;

INSERT INTO `0_payment_terms` (`terms_indicator`, `terms`, `days_before_due`, `day_in_following_month`, `inactive`) VALUES
(1,	'Tanggal 15 bulan berikutnya',	0,	17,	0),
(2,	'Akhir bulan berikutnya',	0,	30,	0),
(3,	'Pembayaran dalam 10 hari',	10,	0,	0),
(4,	'Cash Only',	0,	0,	0);

DROP TABLE IF EXISTS `0_prices`;
CREATE TABLE `0_prices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stock_id` varchar(20) NOT NULL DEFAULT '',
  `sales_type_id` int(11) NOT NULL DEFAULT '0',
  `curr_abrev` char(3) NOT NULL DEFAULT '',
  `price` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `price` (`stock_id`,`sales_type_id`,`curr_abrev`)
) ENGINE=MyISAM ;


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
) ENGINE=MyISAM ;

INSERT INTO `0_printers` (`id`, `name`, `description`, `queue`, `host`, `port`, `timeout`) VALUES
(1,	'QL500',	'Label printer',	'QL500',	'server',	127,	20),
(2,	'Samsung',	'Main network printer',	'scx4521F',	'server',	515,	5),
(3,	'Local',	'Local print server at user IP',	'lp',	'',	515,	10);

DROP TABLE IF EXISTS `0_print_profiles`;
CREATE TABLE `0_print_profiles` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `profile` varchar(30) NOT NULL,
  `report` varchar(5) DEFAULT NULL,
  `printer` tinyint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `profile` (`profile`,`report`)
) ENGINE=MyISAM ;

INSERT INTO `0_print_profiles` (`id`, `profile`, `report`, `printer`) VALUES
(1,	'Out of office',	'',	0),
(2,	'Sales Department',	'',	0),
(3,	'Central',	'',	2),
(4,	'Sales Department',	'104',	2),
(5,	'Sales Department',	'105',	2),
(6,	'Sales Department',	'107',	2),
(7,	'Sales Department',	'109',	2),
(8,	'Sales Department',	'110',	2),
(9,	'Sales Department',	'201',	2);

DROP TABLE IF EXISTS `0_purch_data`;
CREATE TABLE `0_purch_data` (
  `supplier_id` int(11) NOT NULL DEFAULT '0',
  `stock_id` char(20) NOT NULL DEFAULT '',
  `price` double NOT NULL DEFAULT '0',
  `suppliers_uom` char(50) NOT NULL DEFAULT '',
  `conversion_factor` double NOT NULL DEFAULT '1',
  `supplier_description` char(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`supplier_id`,`stock_id`)
) ENGINE=MyISAM ;


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
) ENGINE=InnoDB ;


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
) ENGINE=InnoDB ;


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
) ENGINE=MyISAM ;

INSERT INTO `0_quick_entries` (`id`, `type`, `description`, `base_amount`, `base_desc`, `bal_type`) VALUES
(1,	1,	'Maintenance',	0,	'Amount',	0),
(2,	4,	'Phone',	0,	'Amount',	0),
(3,	2,	'Cash Sales',	0,	'Amount',	0);

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
) ENGINE=MyISAM ;

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
) ENGINE=InnoDB ;


DROP TABLE IF EXISTS `0_refs`;
CREATE TABLE `0_refs` (
  `id` int(11) NOT NULL DEFAULT '0',
  `type` int(11) NOT NULL DEFAULT '0',
  `reference` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`,`type`),
  KEY `Type_and_Reference` (`type`,`reference`)
) ENGINE=InnoDB ;


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
) ENGINE=MyISAM ;

INSERT INTO `0_salesman` (`salesman_code`, `salesman_name`, `salesman_phone`, `salesman_fax`, `salesman_email`, `provision`, `break_pt`, `provision2`, `inactive`) VALUES
(1,	'Sales Person',	'',	'',	'',	5,	1000,	4,	0);

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
) ENGINE=InnoDB ;


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
) ENGINE=InnoDB ;


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
) ENGINE=MyISAM ;

INSERT INTO `0_sales_pos` (`id`, `pos_name`, `cash_sale`, `credit_sale`, `pos_location`, `pos_account`, `inactive`) VALUES
(1,	'Default',	1,	1,	'DEF',	2,	0);

DROP TABLE IF EXISTS `0_sales_types`;
CREATE TABLE `0_sales_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sales_type` char(50) NOT NULL DEFAULT '',
  `tax_included` int(1) NOT NULL DEFAULT '0',
  `factor` double NOT NULL DEFAULT '1',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `sales_type` (`sales_type`)
) ENGINE=MyISAM ;

INSERT INTO `0_sales_types` (`id`, `sales_type`, `tax_included`, `factor`, `inactive`) VALUES
(1,	'Retail',	1,	1,	0),
(2,	'Wholesale',	0,	0.7,	0);

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
) ENGINE=MyISAM ;

INSERT INTO `0_security_roles` (`id`, `role`, `description`, `sections`, `areas`, `inactive`) VALUES
(1,	'Inquiries',	'Inquiries',	'768;2816;3072;3328;5632;5888;8192;8448;10752;11008;13312;15872;16128',	'257;258;259;260;513;514;515;516;517;518;519;520;521;522;523;524;525;773;774;2822;3073;3075;3076;3077;3329;3330;3331;3332;3333;3334;3335;5377;5633;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8450;8451;10497;10753;11009;11010;11012;13313;13315;15617;15618;15619;15620;15621;15622;15623;15624;15625;15626;15873;15882;16129;16130;16131;16132',	0),
(2,	'System Administrator',	'System Administrator',	'256;512;768;2816;3072;3328;5376;5632;5888;7936;8192;8448;10496;10752;11008;13056;13312;15616;15872;16128',	'257;258;259;260;513;514;515;516;517;518;519;520;521;522;523;524;525;526;769;770;771;772;773;774;2817;2818;2819;2820;2821;2822;2823;3073;3074;3082;3075;3076;3077;3078;3079;3080;3081;3329;3330;3331;3332;3333;3334;3335;5377;5633;5634;5635;5636;5637;5641;5638;5639;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8195;8196;8197;8449;8450;8451;10497;10753;10754;10755;10756;10757;11009;11010;11011;11012;13057;13313;13314;13315;15617;15618;15619;15620;15621;15622;15623;15624;15628;15625;15626;15627;15873;15874;15875;15876;15877;15878;15879;15880;15883;15881;15882;16129;16130;16131;16132',	0),
(3,	'Salesman',	'Salesman',	'768;3072;5632;8192;15872',	'773;774;3073;3075;3081;5633;8194;15873',	0),
(4,	'Stock Manager',	'Stock Manager',	'2816;3072;3328;5632;5888;8192;8448;10752;11008;13312;15872;16128',	'2818;2822;3073;3076;3077;3329;3330;3330;3330;3331;3331;3332;3333;3334;3335;5633;5640;5889;5890;5891;8193;8194;8450;8451;10753;11009;11010;11012;13313;13315;15882;16129;16130;16131;16132',	0),
(5,	'Production Manager',	'Production Manager',	'512;2816;3072;3328;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128',	'521;523;524;2818;2819;2820;2821;2822;2823;3073;3074;3076;3077;3078;3079;3080;3081;3329;3330;3330;3330;3331;3331;3332;3333;3334;3335;5633;5640;5640;5889;5890;5891;8193;8194;8196;8197;8450;8451;10753;10755;11009;11010;11012;13313;13315;15617;15619;15620;15621;15624;15624;15876;15877;15880;15882;16129;16130;16131;16132',	0),
(6,	'Purchase Officer',	'Purchase Officer',	'512;2816;3072;3328;5376;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128',	'521;523;524;2818;2819;2820;2821;2822;2823;3073;3074;3076;3077;3078;3079;3080;3081;3329;3330;3330;3330;3331;3331;3332;3333;3334;3335;5377;5633;5635;5640;5640;5889;5890;5891;8193;8194;8196;8197;8449;8450;8451;10753;10755;11009;11010;11012;13313;13315;15617;15619;15620;15621;15624;15624;15876;15877;15880;15882;16129;16130;16131;16132',	0),
(7,	'AR Officer',	'AR Officer',	'512;768;2816;3072;3328;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128',	'521;523;524;771;773;774;2818;2819;2820;2821;2822;2823;3073;3073;3074;3075;3076;3077;3078;3079;3080;3081;3081;3329;3330;3330;3330;3331;3331;3332;3333;3334;3335;5633;5633;5634;5637;5638;5639;5640;5640;5889;5890;5891;8193;8194;8194;8196;8197;8450;8451;10753;10755;11009;11010;11012;13313;13315;15617;15619;15620;15621;15624;15624;15873;15876;15877;15878;15880;15882;16129;16130;16131;16132',	0),
(8,	'AP Officer',	'AP Officer',	'512;2816;3072;3328;5376;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128',	'257;258;259;260;521;523;524;769;770;771;772;773;774;2818;2819;2820;2821;2822;2823;3073;3074;3082;3076;3077;3078;3079;3080;3081;3329;3330;3331;3332;3333;3334;3335;5377;5633;5635;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8196;8197;8449;8450;8451;10497;10753;10755;11009;11010;11012;13057;13313;13315;15617;15619;15620;15621;15624;15876;15877;15880;15882;16129;16130;16131;16132',	0),
(9,	'Accountant',	'New Accountant',	'512;768;2816;3072;3328;5376;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128',	'257;258;259;260;521;523;524;771;772;773;774;2818;2819;2820;2821;2822;2823;3073;3074;3075;3076;3077;3078;3079;3080;3081;3329;3330;3331;3332;3333;3334;3335;5377;5633;5634;5635;5637;5638;5639;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8196;8197;8449;8450;8451;10497;10753;10755;11009;11010;11012;13313;13315;15617;15618;15619;15620;15621;15624;15873;15876;15877;15878;15880;15882;16129;16130;16131;16132',	0),
(10,	'Sub Admin',	'Sub Admin',	'512;768;2816;3072;3328;5376;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128',	'257;258;259;260;521;523;524;771;772;773;774;2818;2819;2820;2821;2822;2823;3073;3074;3082;3075;3076;3077;3078;3079;3080;3081;3329;3330;3331;3332;3333;3334;3335;5377;5633;5634;5635;5637;5638;5639;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8196;8197;8449;8450;8451;10497;10753;10755;11009;11010;11012;13057;13313;13315;15617;15619;15620;15621;15624;15873;15874;15876;15877;15878;15879;15880;15882;16129;16130;16131;16132',	0);

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
) ENGINE=MyISAM ;

INSERT INTO `0_shippers` (`shipper_id`, `shipper_name`, `phone`, `phone2`, `contact`, `address`, `inactive`) VALUES
(1,	'Default',	'',	'',	'',	'',	0);

DROP TABLE IF EXISTS `0_sql_trail`;
CREATE TABLE `0_sql_trail` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `sql` text NOT NULL,
  `result` tinyint(1) NOT NULL,
  `msg` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM ;


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
) ENGINE=MyISAM ;

INSERT INTO `0_stock_category` (`category_id`, `description`, `dflt_tax_type`, `dflt_units`, `dflt_mb_flag`, `dflt_sales_act`, `dflt_cogs_act`, `dflt_inventory_act`, `dflt_adjustment_act`, `dflt_assembly_act`, `dflt_dim1`, `dflt_dim2`, `inactive`, `dflt_no_sale`) VALUES
(1,	'Komponen',	1,	'ea.',	'B',	'41001000',	'51010000',	'11151100',	'51060000',	'51030000',	0,	0,	0,	1),
(2,	'Jasa',	1,	'ea.',	'D',	'41002000',	'51020000',	'11151100',	'51060000',	'51030000',	0,	0,	0,	0),
(3,	'Barang Dagang',	1,	'ea.',	'B',	'41001000',	'51010000',	'11151100',	'51060000',	'51030000',	0,	0,	0,	0),
(4,	'Barang Jadi',	1,	'ea.',	'M',	'41001000',	'51010000',	'11151100',	'51060000',	'51030000',	0,	0,	0,	0);

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
) ENGINE=InnoDB ;


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
) ENGINE=InnoDB ;


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
) ENGINE=MyISAM ;


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
) ENGINE=InnoDB ;


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
) ENGINE=InnoDB ;


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
) ENGINE=InnoDB ;


DROP TABLE IF EXISTS `0_sys_prefs`;
CREATE TABLE `0_sys_prefs` (
  `name` varchar(35) NOT NULL DEFAULT '',
  `category` varchar(30) DEFAULT NULL,
  `type` varchar(20) NOT NULL DEFAULT '',
  `length` smallint(6) DEFAULT NULL,
  `value` tinytext,
  PRIMARY KEY (`name`),
  KEY `category` (`category`)
) ENGINE=MyISAM ;

INSERT INTO `0_sys_prefs` (`name`, `category`, `type`, `length`, `value`) VALUES
('coy_name',	'setup.company',	'varchar',	60,	'Company name'),
('gst_no',	'setup.company',	'varchar',	25,	''),
('coy_no',	'setup.company',	'varchar',	25,	''),
('tax_prd',	'setup.company',	'int',	11,	'1'),
('tax_last',	'setup.company',	'int',	11,	'1'),
('postal_address',	'setup.company',	'tinytext',	0,	'N/A'),
('phone',	'setup.company',	'varchar',	30,	''),
('fax',	'setup.company',	'varchar',	30,	''),
('email',	'setup.company',	'varchar',	100,	''),
('coy_logo',	'setup.company',	'varchar',	100,	''),
('domicile',	'setup.company',	'varchar',	55,	''),
('curr_default',	'setup.company',	'char',	3,	'IDR'),
('use_dimension',	'setup.company',	'tinyint',	1,	'1'),
('f_year',	'setup.company',	'int',	11,	'1'),
('no_item_list',	'setup.company',	'tinyint',	1,	'0'),
('no_customer_list',	'setup.company',	'tinyint',	1,	'0'),
('no_supplier_list',	'setup.company',	'tinyint',	1,	'0'),
('base_sales',	'setup.company',	'int',	11,	'1'),
('time_zone',	'setup.company',	'tinyint',	1,	'0'),
('add_pct',	'setup.company',	'int',	5,	'-1'),
('round_to',	'setup.company',	'int',	5,	'1'),
('login_tout',	'setup.company',	'smallint',	6,	'1800'),
('past_due_days',	'glsetup.general',	'int',	11,	'30'),
('profit_loss_year_act',	'glsetup.general',	'varchar',	15,	'90001110'),
('retained_earnings_act',	'glsetup.general',	'varchar',	15,	'35051010'),
('bank_charge_act',	'glsetup.general',	'varchar',	15,	'70021170'),
('exchange_diff_act',	'glsetup.general',	'varchar',	15,	'70011130'),
('default_credit_limit',	'glsetup.customer',	'int',	11,	'1000000'),
('accumulate_shipping',	'glsetup.customer',	'tinyint',	1,	'0'),
('legal_text',	'glsetup.customer',	'tinytext',	0,	''),
('freight_act',	'glsetup.customer',	'varchar',	15,	'61201190'),
('debtors_act',	'glsetup.sales',	'varchar',	15,	'11131110'),
('default_sales_act',	'glsetup.sales',	'varchar',	15,	'41001000'),
('default_sales_discount_act',	'glsetup.sales',	'varchar',	15,	'42001000'),
('default_prompt_payment_act',	'glsetup.sales',	'varchar',	15,	'44001000'),
('default_delivery_required',	'glsetup.sales',	'smallint',	6,	'1'),
('default_dim_required',	'glsetup.dims',	'int',	11,	'20'),
('pyt_discount_act',	'glsetup.purchase',	'varchar',	15,	'51040000'),
('creditors_act',	'glsetup.purchase',	'varchar',	15,	'21102110'),
('po_over_receive',	'glsetup.purchase',	'int',	11,	'10'),
('po_over_charge',	'glsetup.purchase',	'int',	11,	'10'),
('allow_negative_stock',	'glsetup.inventory',	'tinyint',	1,	'0'),
('default_inventory_act',	'glsetup.items',	'varchar',	15,	'11151100'),
('default_cogs_act',	'glsetup.items',	'varchar',	15,	'51010000'),
('default_adj_act',	'glsetup.items',	'varchar',	15,	'51060000'),
('default_inv_sales_act',	'glsetup.items',	'varchar',	15,	'41001000'),
('default_assembly_act',	'glsetup.items',	'varchar',	15,	'51030000'),
('default_workorder_required',	'glsetup.manuf',	'int',	11,	'20'),
('version_id',	'system',	'varchar',	11,	'2.3rc'),
('auto_curr_reval',	'setup.company',	'smallint',	6,	'1'),
('grn_clearing_act',	'glsetup.purchase',	'varchar',	15,	'11151300'),
('bcc_email',	'setup.company',	'varchar',	100,	'');

DROP TABLE IF EXISTS `0_sys_types`;
CREATE TABLE `0_sys_types` (
  `type_id` smallint(6) NOT NULL DEFAULT '0',
  `type_no` int(11) NOT NULL DEFAULT '1',
  `next_reference` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`type_id`)
) ENGINE=InnoDB ;

INSERT INTO `0_sys_types` (`type_id`, `type_no`, `next_reference`) VALUES
(0,	17,	'1'),
(1,	7,	'1'),
(2,	4,	'1'),
(4,	3,	'1'),
(10,	16,	'1'),
(11,	2,	'1'),
(12,	6,	'1'),
(13,	1,	'1'),
(16,	2,	'1'),
(17,	2,	'1'),
(18,	1,	'1'),
(20,	6,	'1'),
(21,	1,	'1'),
(22,	3,	'1'),
(25,	1,	'1'),
(26,	1,	'1'),
(28,	1,	'1'),
(29,	1,	'1'),
(30,	0,	'1'),
(32,	0,	'1'),
(35,	1,	'1'),
(40,	1,	'1');

DROP TABLE IF EXISTS `0_tags`;
CREATE TABLE `0_tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` smallint(6) NOT NULL,
  `name` varchar(30) NOT NULL,
  `description` varchar(60) DEFAULT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `type` (`type`,`name`)
) ENGINE=MyISAM ;


DROP TABLE IF EXISTS `0_tag_associations`;
CREATE TABLE `0_tag_associations` (
  `record_id` varchar(15) NOT NULL,
  `tag_id` int(11) NOT NULL,
  UNIQUE KEY `record_id` (`record_id`,`tag_id`)
) ENGINE=MyISAM ;


DROP TABLE IF EXISTS `0_tax_groups`;
CREATE TABLE `0_tax_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL DEFAULT '',
  `tax_shipping` tinyint(1) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB ;

INSERT INTO `0_tax_groups` (`id`, `name`, `tax_shipping`, `inactive`) VALUES
(1,	'Tax',	0,	0),
(2,	'Tax Exempt',	0,	0);

DROP TABLE IF EXISTS `0_tax_group_items`;
CREATE TABLE `0_tax_group_items` (
  `tax_group_id` int(11) NOT NULL DEFAULT '0',
  `tax_type_id` int(11) NOT NULL DEFAULT '0',
  `rate` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`tax_group_id`,`tax_type_id`)
) ENGINE=InnoDB ;

INSERT INTO `0_tax_group_items` (`tax_group_id`, `tax_type_id`, `rate`) VALUES
(1,	1,	5);

DROP TABLE IF EXISTS `0_tax_types`;
CREATE TABLE `0_tax_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rate` double NOT NULL DEFAULT '0',
  `sales_gl_code` varchar(15) NOT NULL DEFAULT '',
  `purchasing_gl_code` varchar(15) NOT NULL DEFAULT '',
  `name` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB ;

INSERT INTO `0_tax_types` (`id`, `rate`, `sales_gl_code`, `purchasing_gl_code`, `name`, `inactive`) VALUES
(1,	10,	'21104110',	'21104110',	'PPN 10%',	0);

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
) ENGINE=InnoDB ;


DROP TABLE IF EXISTS `0_useronline`;
CREATE TABLE `0_useronline` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` int(15) NOT NULL DEFAULT '0',
  `ip` varchar(40) NOT NULL DEFAULT '',
  `file` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `timestamp` (`timestamp`),
  KEY `ip` (`ip`)
) ENGINE=MyISAM ;


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
) ENGINE=MyISAM ;

INSERT INTO `0_users` (`id`, `user_id`, `password`, `real_name`, `role_id`, `phone`, `email`, `language`, `date_format`, `date_sep`, `tho_sep`, `dec_sep`, `theme`, `page_size`, `prices_dec`, `qty_dec`, `rates_dec`, `percent_dec`, `show_gl`, `show_codes`, `show_hints`, `last_visit_date`, `query_size`, `graphic_links`, `pos`, `print_profile`, `rep_popup`, `sticky_doc_date`, `startup_tab`, `inactive`) VALUES
(1,	'admin',	'5f4dcc3b5aa765d61d8327deb882cf99',	'Administrator',	2,	'',	'adm@adm.com',	'en_US',	0,	0,	0,	0,	'default',	'Letter',	2,	2,	4,	1,	1,	0,	0,	'2013-12-02 06:51:15',	10,	1,	1,	'1',	1,	0,	'system',	0);

DROP TABLE IF EXISTS `0_voided`;
CREATE TABLE `0_voided` (
  `type` int(11) NOT NULL DEFAULT '0',
  `id` int(11) NOT NULL DEFAULT '0',
  `date_` date NOT NULL DEFAULT '0000-00-00',
  `memo_` tinytext NOT NULL,
  UNIQUE KEY `id` (`type`,`id`)
) ENGINE=InnoDB ;


DROP TABLE IF EXISTS `0_workcentres`;
CREATE TABLE `0_workcentres` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(40) NOT NULL DEFAULT '',
  `description` char(50) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM ;


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
) ENGINE=InnoDB ;


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
) ENGINE=InnoDB ;


DROP TABLE IF EXISTS `0_wo_issue_items`;
CREATE TABLE `0_wo_issue_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stock_id` varchar(40) DEFAULT NULL,
  `issue_id` int(11) DEFAULT NULL,
  `qty_issued` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB ;


DROP TABLE IF EXISTS `0_wo_manufacture`;
CREATE TABLE `0_wo_manufacture` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reference` varchar(100) DEFAULT NULL,
  `workorder_id` int(11) NOT NULL DEFAULT '0',
  `quantity` double NOT NULL DEFAULT '0',
  `date_` date NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (`id`),
  KEY `workorder_id` (`workorder_id`)
) ENGINE=InnoDB ;


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
) ENGINE=InnoDB ;


