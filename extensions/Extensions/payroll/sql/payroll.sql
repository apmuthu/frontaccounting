DROP TABLE IF EXISTS `0_employees`;
CREATE TABLE `0_employees` (
 `emp_id` int(11) NOT NULL AUTO_INCREMENT,
 `emp_first_name` varchar(100) DEFAULT NULL,
 `emp_last_name` varchar(100) DEFAULT NULL,
 `emp_address` tinytext,
 `emp_phone` varchar(30) DEFAULT NULL,
 `emp_email` varchar(100) DEFAULT NULL,
 `emp_birthdate` date NOT NULL,
 `emp_payfrequency` varchar(30) DEFAULT NULL,
 `emp_filingstatus` varchar(100) DEFAULT NULL,
 `emp_allowances` int(2) DEFAULT NULL,
 `emp_extrawitholding` float DEFAULT NULL,
 `emp_taxid` varchar(11) DEFAULT NULL,
 `emp_hiredate` date DEFAULT NULL,
 `emp_releasedate` date DEFAULT NULL,
 `emp_type` varchar(30) DEFAULT NULL,
 `emp_notes` tinytext NOT NULL,
 `inactive` tinyint(1) NOT NULL DEFAULT '0',
 PRIMARY KEY (`emp_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `0_employee_pay_rates`;
CREATE TABLE `0_employee_pay_rates` (
  `id` tinyint(4) NOT NULL AUTO_INCREMENT,
  `emp_id` tinyint(4) NOT NULL,
  `pay_type_id` tinyint(4) NOT NULL,
  `pay_rate` float NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Index` (`emp_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `0_payroll_pay_types`;
CREATE TABLE `0_payroll_pay_types` (
 `id` tinyint(4) NOT NULL AUTO_INCREMENT,
 `type` int(11) NOT NULL,
 `name` varchar(100) NOT NULL,
 PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `0_payroll_tax_rates`;
-- CREATE TABLE `0_payroll_tax_rates` (
-- `id` int(11) NOT NULL AUTO_INCREMENT,
-- `type_id` int(11) NOT NULL,
-- `rate` double NOT NULL,
-- `threshold` double DEFAULT NULL,
-- `status` tinyint(4) DEFAULT NULL,
-- PRIMARY KEY (`id`)
-- ) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

-- SC: 18.04.2012: modified table, see comments
-- the following table set can be used as well for deductions
DROP TABLE IF EXISTS `0_payroll_tax_type`;
CREATE TABLE `0_payroll_tax_type` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(3) NOT NULL, -- user assigned code, may appear on payslip
  `name` VARCHAR(100) NOT NULL, -- relevant description
  `type` INT NOT NULL, -- tax or deduction
  `responsibility` tinytext NOT NULL, -- employer/employee
  `tax_base` INT NOT NULL, -- see includes/ui/taxes_ui.inc: base salary, realized salary or other
--  `allowance` float NOT NULL,
  `accrual_gl_code` VARCHAR(15) NOT NULL, -- accounting stuff
  `expense_gl_code` VARCHAR(15) NOT NULL, -- accounting stuff
  `tax_period` int(11) NOT NULL, --time basis for figures - annual, monthly, etc.
  `inactive` INT NOT NULL,
  
  PRIMARY KEY (`id`),
  UNIQUE KEY (`code`)
);
--

DROP TABLE IF EXISTS `0_payroll_tax_rate`;
CREATE TABLE `0_payroll_tax_rate` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `tt_id` INT(11) NOT NULL, -- foreign key payroll_tax_type
  `bracket` VARCHAR(3) NOT NULL, -- user assigned unique code
  `value_from` FLOAT, -- from this value this bracket applies
  `value_to` FLOAT, -- until this value this bracked applies
  `tax_amount` FLOAT, -- on this bracket, there is this fixed amount as tax
  `variable_from` FLOAT, -- what exceeds this amount is charged by percent
  `fixed_tax_percent` FLOAT, -- percent of charge
  `variable` FLOAT, -- variable parameter
  `variable_tax_percent` FLOAT, -- percent of charge, to be multiplied by variable
  
  PRIMARY KEY (`id`)
);


-- SC: 19/04/2012: add table for defining pay types
DROP TABLE IF EXISTS `0_payroll_other_income_type`;
DROP TABLE IF EXISTS `0_payroll_pay_type`;
CREATE TABLE `0_payroll_pay_type` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `code` VARCHAR(3) NOT NULL, -- user assigned code, may appear on payslip
    `name` VARCHAR(100) NOT NULL, -- relevant description
    `taxable` INT NOT NULL, -- yes/no
    `cmethod` INT NOT NULL, -- fixed amount/percent from base/ multipply by # of worked days
    `account_code` VARCHAR(15) NOT NULL,
    `default_rate` FLOAT, -- a default amount/rate to be proposed to user in UI
    `required` INT NOT NULL, -- whether this type is mandatory for an employee
    `automatic` INT NOT NULL, -- whether this paytype is processed automatically at payroll procedure
    `inactive` INT NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY (`code`)
);
