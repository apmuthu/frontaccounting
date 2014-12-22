ALTER TABLE `0_debtor_trans` ADD INDEX `order_` (`order_`);
ALTER TABLE `0_users` CHANGE `query_size` `query_size` TINYINT(1) UNSIGNED NOT NULL DEFAULT 10;

INSERT INTO `0_sys_prefs` VALUES ('default_quote_valid_days', 'glsetup.sales', 'smallint', 6, 30);
ALTER TABLE `0_supp_trans` DROP INDEX `supplier_id`; 
ALTER TABLE `0_supp_trans` DROP INDEX `type`; 
ALTER TABLE `0_cust_branch` DROP INDEX `branch_code`; 
ALTER TABLE `0_supp_trans` DROP INDEX `SupplierID_2`, ADD INDEX `supplier_id` (`supplier_id`, `supp_reference`);
ALTER TABLE `0_stock_moves` CHANGE `stock_id` `stock_id` VARCHAR(20) DEFAULT '' NOT NULL; 