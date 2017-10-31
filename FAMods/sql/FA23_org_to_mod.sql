/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

-- 2017-10-31
-- This script synchronises a standard FA 2.3.26 Chart to apmuthu's FAMods Chart for FA 2.3.26
-- USE `23org`;

ALTER TABLE `0_audit_trail` 
	CHANGE `fiscal_year` `fiscal_year` int(11)   NOT NULL DEFAULT 0 after `description`;

ALTER TABLE `0_bom` 
	CHANGE `parent` `parent` varchar(20) NOT NULL DEFAULT '' after `id`, 
	CHANGE `component` `component` varchar(20) NOT NULL DEFAULT '' after `parent`, 
	CHANGE `loc_code` `loc_code` varchar(5) NOT NULL DEFAULT '' after `workcentre_added`, 
	DROP KEY `parent`, 
	DROP KEY `PRIMARY`, add PRIMARY KEY(`parent`,`loc_code`,`component`,`workcentre_added`);

ALTER TABLE `0_credit_status` 
	CHANGE `reason_description` `reason_description` varchar(100) NOT NULL DEFAULT '' after `id`;

ALTER TABLE `0_crm_contacts` 
	ADD KEY `entity_id`(`entity_id`), 
	ADD KEY `person_id`(`person_id`);

ALTER TABLE `0_cust_branch` 
	DROP KEY `branch_code`;

ALTER TABLE `0_debtor_trans_details` 
	ADD KEY `stock_trans`(`stock_id`);

ALTER TABLE `0_loc_stock` 
	CHANGE `loc_code` `loc_code` varchar(5) NOT NULL DEFAULT '' first, 
	CHANGE `stock_id` `stock_id` varchar(20) NOT NULL DEFAULT '' after `loc_code`;

ALTER TABLE `0_payment_terms` 
	CHANGE `terms` `terms` varchar(80) NOT NULL DEFAULT '' after `terms_indicator`;

ALTER TABLE `0_purch_data` 
	CHANGE `stock_id` `stock_id` varchar(20) NOT NULL DEFAULT '' after `supplier_id`, 
	CHANGE `suppliers_uom` `suppliers_uom` varchar(50) NOT NULL DEFAULT '' after `price`, 
	CHANGE `supplier_description` `supplier_description` varchar(50) NOT NULL DEFAULT '' after `conversion_factor`;

ALTER TABLE `0_sales_types` 
	CHANGE `sales_type` `sales_type` varchar(50) NOT NULL DEFAULT '' after `id`;

ALTER TABLE `0_salesman` 
	CHANGE `salesman_name` `salesman_name` varchar(60) NOT NULL DEFAULT '' after `salesman_code`, 
	CHANGE `salesman_phone` `salesman_phone` varchar(30) NOT NULL DEFAULT '' after `salesman_name`, 
	CHANGE `salesman_fax` `salesman_fax` varchar(30) NOT NULL DEFAULT '' after `salesman_phone`;

ALTER TABLE `0_stock_moves` 
	CHANGE `stock_id` `stock_id` varchar(20) NOT NULL DEFAULT '' after `trans_no`, 
	CHANGE `loc_code` `loc_code` varchar(5) NOT NULL DEFAULT '' after `type`, 
	CHANGE `reference` `reference` varchar(40) NOT NULL DEFAULT '' after `price`;

ALTER TABLE `0_supp_trans` 
	DROP KEY `supplier_id`, add KEY `supplier_id`(`supplier_id`,`supp_reference`), 
	DROP KEY `SupplierID_2`, 
	DROP KEY `type`;

ALTER TABLE `0_tag_associations` 
	ADD PRIMARY KEY(`record_id`,`tag_id`), 
	DROP KEY `record_id`, ENGINE=InnoDB; 

ALTER TABLE `0_tags` ENGINE=InnoDB; 

ALTER TABLE `0_tax_types` 
	ADD UNIQUE KEY `name`(`name`,`rate`);

ALTER TABLE `0_wo_requirements` 
	CHANGE `stock_id` `stock_id` varchar(20) NOT NULL DEFAULT '' after `workorder_id`, 
	CHANGE `loc_code` `loc_code` varchar(5) NOT NULL DEFAULT '' after `std_cost`;

ALTER TABLE `0_workcentres` 
	CHANGE `name` `name` varchar(40) NOT NULL DEFAULT '' after `id`, 
	CHANGE `description` `description` varchar(50) NOT NULL DEFAULT '' after `name`;

/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
