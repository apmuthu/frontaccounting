ALTER TABLE `0_debtor_trans` ADD INDEX `order_` (`order_`);
ALTER TABLE `0_users` CHANGE `query_size` `query_size` TINYINT(1) UNSIGNED NOT NULL DEFAULT 10;

ALTER TABLE `0_crm_contacts` CHANGE `entity_id` INT(11) DEFAULT NULL COMMENT 'entity id in related class table';

INSERT IGNORE INTO `0_sys_prefs` VALUES ('default_quote_valid_days', 'glsetup.sales', 'smallint', 6, 30);

ALTER TABLE `0_cust_branch` DROP INDEX `branch_code`;
ALTER TABLE `0_supp_trans` DROP INDEX `supplier_id`;
ALTER TABLE `0_supp_trans` DROP INDEX `type`;
ALTER TABLE `0_supp_trans` DROP INDEX `SupplierID_2`, ADD INDEX `supplier_id` (`supplier_id`, `supp_reference`);

ALTER TABLE `0_bom` CHANGE `loc_code` `loc_code` VARCHAR(5) DEFAULT '' NOT NULL; 
ALTER TABLE `0_loc_stock` CHANGE `stock_id` `stock_id` VARCHAR(20) DEFAULT '' NOT NULL; 
ALTER TABLE `0_loc_stock` CHANGE `loc_code` `loc_code` VARCHAR(5) DEFAULT '' NOT NULL; 
ALTER TABLE `0_purch_data` CHANGE `stock_id` `stock_id` VARCHAR(20) DEFAULT '' NOT NULL; 
ALTER TABLE `0_stock_moves` CHANGE `stock_id` `stock_id` VARCHAR(20) DEFAULT '' NOT NULL;
ALTER TABLE `0_stock_moves` CHANGE `loc_code` `loc_code` VARCHAR(5) DEFAULT '' NOT NULL; 
ALTER TABLE `0_wo_requirements` CHANGE `stock_id` `stock_id` VARCHAR(20) DEFAULT '' NOT NULL; 
ALTER TABLE `0_wo_requirements` CHANGE `loc_code` `loc_code` VARCHAR(5) DEFAULT '' NOT NULL; 

ALTER TABLE `0_crm_contacts` ADD INDEX `entity_id` (`entity_id`);
ALTER TABLE `0_crm_contacts` ADD INDEX `person_id` (`person_id`);

ALTER TABLE `0_bank_trans` CHANGE `person_id` `person_id` INT(11) DEFAULT NULL;
ALTER TABLE `0_budget_trans` CHANGE `person_id` `person_id` INT(11) DEFAULT NULL;
ALTER TABLE `0_gl_trans` CHANGE `person_id` `person_id` INT(11) DEFAULT NULL;

ALTER TABLE `0_bom` 
	CHANGE `parent` `parent` VARCHAR(20) DEFAULT '' NOT NULL, 
	CHANGE `component` `component` VARCHAR(20) DEFAULT '' NOT NULL, 
	DROP INDEX `parent`, 
	DROP PRIMARY KEY, ADD PRIMARY KEY (`parent`, `loc_code`, `component`, `workcentre_added`); 

ALTER TABLE `0_credit_status` CHANGE `reason_description` `reason_description` VARCHAR(100) DEFAULT '' NOT NULL;
ALTER TABLE `0_payment_terms` CHANGE `terms` `terms` VARCHAR(80) DEFAULT '' NOT NULL;

ALTER TABLE `0_purch_data` 
    CHANGE `suppliers_uom` `suppliers_uom` VARCHAR(50) DEFAULT '' NOT NULL, 
    CHANGE `supplier_description` `supplier_description` VARCHAR(50) DEFAULT '' NOT NULL;

ALTER TABLE `0_sales_types` CHANGE `sales_type` `sales_type` VARCHAR(50) DEFAULT '' NOT NULL;

ALTER TABLE `0_salesman` 
    CHANGE `salesman_name` `salesman_name` VARCHAR(60) DEFAULT '' NOT NULL, 
    CHANGE `salesman_phone` `salesman_phone` VARCHAR(30) DEFAULT '' NOT NULL, 
    CHANGE `salesman_fax` `salesman_fax` VARCHAR(30) DEFAULT '' NOT NULL;

ALTER TABLE `0_stock_moves` CHANGE `reference` `reference` VARCHAR(40) DEFAULT '' NOT NULL;

ALTER TABLE `0_workcentres` 
    CHANGE `name` `name` VARCHAR(40) DEFAULT '' NOT NULL, 
    CHANGE `description` `description` VARCHAR(50) DEFAULT '' NOT NULL;

ALTER TABLE `0_audit_trail` CHANGE `fiscal_year` `fiscal_year` int(11) NOT NULL default 0;
