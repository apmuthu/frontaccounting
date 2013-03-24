DROP TABLE IF EXISTS `0_import_paypal`;
DROP TABLE IF EXISTS `0_import_paypal_accounts`;

CREATE TABLE `0_import_paypal` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(60) NOT NULL DEFAULT '',
  `date` date NOT NULL DEFAULT '0000-00-00',
  `ref` varchar(40) NOT NULL DEFAULT '',
  `person` varchar(100) NOT NULL DEFAULT '',
  `memo` varchar(100) NOT NULL DEFAULT '',
  `amount` double NOT NULL DEFAULT '0',
  `account` varchar(15) NOT NULL DEFAULT '',
  `confirmed` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `ref` (`ref`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

CREATE TABLE `0_import_paypal_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person` varchar(100) NOT NULL DEFAULT '',
  `memo` varchar(100) NOT NULL DEFAULT '',
  `account` varchar(15) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `person` (`person`),
  KEY `memo` (`memo`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

