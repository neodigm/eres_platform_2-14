```sql
-- Scott C. Krause (neodigm) | Database Schema Design | Multi-tenant SaaS | One does what one must 🦄
-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Aug 10, 2014 at 08:16 AM
-- Server version: 5.5.37-0ubuntu0.14.04.1
-- PHP Version: 5.5.9-1ubuntu4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `carsyours_v100r0`
--
CREATE DATABASE IF NOT EXISTS `carsyours_v100r0` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `carsyours_v100r0`;

-- --------------------------------------------------------

--
-- Table structure for table `app_activity`
--

CREATE TABLE IF NOT EXISTS `app_activity` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key / Auton',
  `parent_id` int(11) NOT NULL COMMENT 'Foreign Key: parent > ID',
  `created_at` datetime NOT NULL COMMENT 'audit: eloquent ORM',
  `state_stage` varchar(32) NOT NULL COMMENT 'Stage Changed to',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Truncate table before insert `app_activity`
--

TRUNCATE TABLE `app_activity`;
-- --------------------------------------------------------

--
-- Table structure for table `app_attach`
--

CREATE TABLE IF NOT EXISTS `app_attach` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key / Auton',
  `app_id` int(11) NOT NULL COMMENT 'Foreign Key: app > ID',
  `tmpl_id` int(11) NOT NULL COMMENT 'Foreign Key: app_attach_tmpl > ID',
  `sid` varchar(64) DEFAULT NULL COMMENT '4cc Checksum',
  `created_by` int(11) DEFAULT NULL COMMENT 'account  > ID',
  `created_at` datetime NOT NULL COMMENT 'audit: eloquent ORM',
  `updated_by` int(11) NOT NULL COMMENT 'account  > ID or Null',
  `updated_at` datetime NOT NULL COMMENT 'audit: eloquent ORM',
  `state_type` varchar(32) NOT NULL,
  `state_stage` varchar(32) NOT NULL,
  `attachment_nm` varchar(64) NOT NULL COMMENT 'Name of the attached file',
  `attachment_uri` varchar(176) NOT NULL COMMENT 'abs path',
  `comment` varchar(176) DEFAULT NULL COMMENT 'Admin Comment',
  `comment_usr` varchar(176) DEFAULT NULL COMMENT 'User Comment',
  `state_status` varchar(32) NOT NULL COMMENT 'ENABLED,  DISABLED or ARCHIVED',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Truncate table before insert `app_attach`
--

TRUNCATE TABLE `app_attach`;
-- --------------------------------------------------------

--
-- Table structure for table `app_attach_activity`
--

CREATE TABLE IF NOT EXISTS `app_attach_activity` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key / Auton',
  `parent_id` int(11) NOT NULL COMMENT 'Foreign Key: parent > ID',
  `created_at` datetime NOT NULL COMMENT 'audit: eloquent ORM',
  `state_stage` varchar(32) NOT NULL COMMENT 'Stage Changed to',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Truncate table before insert `app_attach_activity`
--

TRUNCATE TABLE `app_attach_activity`;
-- --------------------------------------------------------

--
-- Table structure for table `app_attach_tmpl`
--

CREATE TABLE IF NOT EXISTS `app_attach_tmpl` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key / Auton',
  `lender_id` int(11) NOT NULL COMMENT 'Foreign Key: account  > ID',
  `created_by` int(11) NOT NULL COMMENT 'Foreign Key: account  > ID',
  `created_at` datetime NOT NULL COMMENT 'audit: eloquent ORM',
  `updated_by` int(11) DEFAULT NULL COMMENT 'Foreign Key: account  > ID or Null',
  `updated_at` datetime DEFAULT NULL COMMENT 'audit: eloquent ORM',
  `state_type` varchar(32) NOT NULL,
  `tmpl_states` varchar(224) DEFAULT NULL COMMENT 'Pipe delimited 2cc State / Province codes',
  `tmpl_nm` varchar(64) NOT NULL COMMENT 'Name of the Template',
  `attachment_nm` varchar(64) NOT NULL COMMENT 'Name of the attached file',
  `attachment_uri` varchar(176) NOT NULL COMMENT 'abs path',
  `comment_adm` blob COMMENT 'Admin Comment',
  `state_status` varchar(32) NOT NULL COMMENT 'ENABLED,  DISABLED or ARCHIVED',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Truncate table before insert `app_attach_tmpl`
--

TRUNCATE TABLE `app_attach_tmpl`;
-- --------------------------------------------------------

--
-- Table structure for table `app_lkup`
--

CREATE TABLE IF NOT EXISTS `app_lkup` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key / Auton',
  `column_nm` varchar(64) NOT NULL DEFAULT 'state_stage' COMMENT 'Column Name',
  `lookup_code` varchar(32) NOT NULL COMMENT 'Code - Uppercase',
  `lookup_desc` varchar(176) DEFAULT NULL COMMENT 'Description',
  `lookup_value` int(11) DEFAULT NULL COMMENT 'Value',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Truncate table before insert `app_lkup`
--

TRUNCATE TABLE `app_lkup`;
-- --------------------------------------------------------

--
-- Table structure for table `email_out`
--

CREATE TABLE IF NOT EXISTS `email_out` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key / Auton',
  `tmpl_id` int(11) DEFAULT NULL COMMENT 'Foreign Key: email_tmpl > ID (optional)',
  `notification_id` int(11) DEFAULT NULL COMMENT 'Foreign Key: email_tmpl > ID (optional)',
  `created_at` datetime NOT NULL COMMENT 'audit: eloquent ORM',
  `broadcast_at` datetime NOT NULL COMMENT 'Time sent if applicable',
  `subject_text` varchar(96) DEFAULT NULL COMMENT 'Subject of Message',
  `from_address` varchar(32) NOT NULL COMMENT 'From Address',
  `from_nm` varchar(32) NOT NULL COMMENT 'From Name',
  `to_address` varchar(96) NOT NULL COMMENT 'To Addresses (pipe delim',
  `bcc_address` varchar(32) DEFAULT NULL COMMENT 'BCC Address',
  `body_markup` blob COMMENT 'Message Rich Text',
  `body_text` blob NOT NULL COMMENT 'Message Plain Text',
  `attachment_1` varchar(176) DEFAULT NULL COMMENT 'abs path (Token Pattern)',
  `attachment_2` varchar(176) DEFAULT NULL COMMENT 'abs path (Token Pattern)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Truncate table before insert `email_out`
--

TRUNCATE TABLE `email_out`;
-- --------------------------------------------------------

--
-- Table structure for table `email_tmpl`
--

CREATE TABLE IF NOT EXISTS `email_tmpl` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key / Auton',
  `created_at` datetime NOT NULL COMMENT 'audit: eloquent ORM',
  `email_tmpl_nm` varchar(32) NOT NULL COMMENT 'Email Template Name',
  `email_tmpl_desc` varchar(176) DEFAULT NULL COMMENT 'Email Template Description',
  `subject_text` varchar(96) DEFAULT NULL COMMENT 'Subject of Message (Token Pattern)',
  `from_address` varchar(32) NOT NULL COMMENT 'From email address',
  `from_nm` varchar(32) NOT NULL COMMENT 'From Name',
  `body_markup` blob COMMENT 'Message Rich Text (Token Pattern)',
  `body_text` blob NOT NULL COMMENT 'Message Plain Text (Token Pattern)',
  `attachment_1` varchar(176) DEFAULT NULL COMMENT 'abs path (Token Pattern)',
  `attachment_2` varchar(176) DEFAULT NULL COMMENT 'abs path (Token Pattern)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Truncate table before insert `email_tmpl`
--

TRUNCATE TABLE `email_tmpl`;
-- --------------------------------------------------------

--
-- Table structure for table `met_config`
--

CREATE TABLE IF NOT EXISTS `met_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key / Auton',
  `start_at` datetime NOT NULL COMMENT 'Time that configuration begins',
  `end_at` datetime NOT NULL COMMENT 'Time that configuration ends',
  `config_nm` varchar(48) NOT NULL COMMENT 'Unique (Add pipe delim white_label_id (lender account > id or null)) to customize',
  `config_desc` varchar(96) NOT NULL COMMENT 'Description',
  `config_value` blob COMMENT 'Value - large (conditionally required)',
  `config_value_num` int(11) DEFAULT NULL COMMENT 'Value - numeric (conditionally required)',
  `state_status` varchar(32) NOT NULL COMMENT 'ENABLED,  DISABLED or ARCHIVED',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Truncate table before insert `met_config`
--

TRUNCATE TABLE `met_config`;
-- --------------------------------------------------------

--
-- Table structure for table `met_error`
--

CREATE TABLE IF NOT EXISTS `met_error` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key / Auton',
  `created_at` datetime NOT NULL COMMENT 'audit: eloquent ORM',
  `error_num` varchar(48) NOT NULL COMMENT 'Unique - Upper Case - May reference requirement number',
  `error_msg` varchar(96) NOT NULL COMMENT 'Description',
  `error_lang` varchar(2) NOT NULL COMMENT 'Language - English',
  `state_status` varchar(32) NOT NULL COMMENT 'TRACE, DEBUG, INFO, WARN, ERROR, FATAL',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Truncate table before insert `met_error`
--

TRUNCATE TABLE `met_error`;
-- --------------------------------------------------------

--
-- Table structure for table `met_make_lkup`
--

CREATE TABLE IF NOT EXISTS `met_make_lkup` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key / Auton',
  `make_nm` varchar(32) NOT NULL COMMENT 'Make',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Truncate table before insert `met_make_lkup`
--

TRUNCATE TABLE `met_make_lkup`;
-- --------------------------------------------------------

--
-- Table structure for table `met_model_lkup`
--

CREATE TABLE IF NOT EXISTS `met_model_lkup` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key / Auton',
  `sid` varchar(64) NOT NULL COMMENT '4cc Checksum',
  `make_id` int(11) NOT NULL COMMENT 'Foreign Key: met_make_lkup > ID',
  `model_nm` varchar(64) NOT NULL COMMENT 'Model',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Truncate table before insert `met_model_lkup`
--

TRUNCATE TABLE `met_model_lkup`;
-- --------------------------------------------------------

--
-- Table structure for table `met_st_lkup`
--

CREATE TABLE IF NOT EXISTS `met_st_lkup` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key / Auton',
  `country_nm` varchar(32) NOT NULL COMMENT 'Country Name',
  `state_province` varchar(5) NOT NULL COMMENT 'State / Province',
  `state_nm` varchar(32) NOT NULL COMMENT 'State Name',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Truncate table before insert `met_st_lkup`
--

TRUNCATE TABLE `met_st_lkup`;
-- --------------------------------------------------------

--
-- Table structure for table `met_trim_lkup`
--

CREATE TABLE IF NOT EXISTS `met_trim_lkup` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key / Auton',
  `trim_nm` varchar(32) NOT NULL COMMENT 'Trim',
  `trim_tags` varchar(176) NOT NULL COMMENT 'Description',
  PRIMARY KEY (`id`),
  UNIQUE KEY `trim_nm` (`trim_nm`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=22 ;

--
-- Truncate table before insert `met_trim_lkup`
--

TRUNCATE TABLE `met_trim_lkup`;
--
-- Dumping data for table `met_trim_lkup`
--

INSERT INTO `met_trim_lkup` (`id`, `trim_nm`, `trim_tags`) VALUES
(1, '3rd Row Seats', ''),
(2, 'Backup Camera', ''),
(3, 'Cruise Control', ''),
(4, 'Keyless Entry', ''),
(5, 'Multi-zone Climate Control', ''),
(6, 'Power Locks', ''),
(7, 'Power Windows', ''),
(8, 'Steering Wheel Controls', ''),
(9, 'Bluetooth, Hands-Free', ''),
(10, 'CD Player', ''),
(11, 'DVD Player', ''),
(12, 'Navigation', ''),
(13, 'Portable Audio Connection', ''),
(14, 'Premium Audio', ''),
(15, 'Security System', ''),
(16, 'Heated Seats', ''),
(17, 'Leather Seats', ''),
(18, 'Premium Wheels', ''),
(19, 'Sunroof', ''),
(20, 'Disability Equipped', ''),
(21, 'Trailer Hitch', '');

-- --------------------------------------------------------

--
-- Table structure for table `met_zip_lkup`
--

CREATE TABLE IF NOT EXISTS `met_zip_lkup` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key / Auton',
  `zipcode` varchar(10) NOT NULL COMMENT 'Zip / Postal',
  `primary` int(11) NOT NULL COMMENT 'Primary Zip / Postal',
  `city` varchar(32) NOT NULL COMMENT 'City',
  `state_province` varchar(2) NOT NULL COMMENT 'State / Province',
  `county_num` varchar(3) NOT NULL COMMENT 'County Number',
  `county_nm` varchar(32) NOT NULL COMMENT 'County Name',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Truncate table before insert `met_zip_lkup`
--

TRUNCATE TABLE `met_zip_lkup`;
-- --------------------------------------------------------

--
-- Table structure for table `notification`
--

CREATE TABLE IF NOT EXISTS `notification` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key / Auton',
  `to_id` int(11) NOT NULL COMMENT 'Foreign Key: account  > ID',
  `from_id` int(11) DEFAULT NULL COMMENT 'Foreign Key: account  > ID or Null',
  `created_at` datetime NOT NULL COMMENT 'audit: eloquent ORM',
  `notification_msg` varchar(176) NOT NULL COMMENT 'Notification Message',
  `notification_action` varchar(176) NOT NULL COMMENT 'URI or Route',
  `passive_ind` int(11) NOT NULL COMMENT 'Display passively within UI',
  `active_ind` int(11) NOT NULL COMMENT 'Display as integrated dialog within UI',
  `email_ind` int(11) NOT NULL COMMENT 'Send as an email message',
  `sms_ind` int(11) NOT NULL COMMENT 'Send as a text message',
  `broadcast_at` datetime NOT NULL COMMENT 'Time sent if applicable',
  `state_status` varchar(32) NOT NULL COMMENT 'ENABLED,  DISABLED or ARCHIVED',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Truncate table before insert `notification`
--

TRUNCATE TABLE `notification`;
-- --------------------------------------------------------

--
-- Table structure for table `sale`
--

CREATE TABLE IF NOT EXISTS `sale` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key / Auton',
  `sid` varchar(64) NOT NULL COMMENT '4cc Checksum',
  `app_id` int(11) NOT NULL COMMENT 'Foreign Key: app > ID',
  `offer_id` int(11) NOT NULL COMMENT 'Foreign Key: offer > ID',
  `vehicle_id` int(11) DEFAULT NULL COMMENT 'Foreign Key: Vehicle > ID',
  `created_by` int(11) NOT NULL COMMENT 'account  > ID or Null',
  `created_at` datetime NOT NULL COMMENT 'audit: eloquent ORM',
  `updated_by` int(11) DEFAULT NULL COMMENT 'account  > ID or Null',
  `updated_at` datetime DEFAULT NULL COMMENT 'audit: eloquent ORM',
  `state_stage` varchar(32) NOT NULL,
  `bank_nm` varchar(96) NOT NULL COMMENT 'Name of Bank',
  `bank_account_num` varchar(32) NOT NULL COMMENT 'account  Number',
  `bank_routing_num` varchar(32) NOT NULL COMMENT 'Routing Number',
  `comment` blob COMMENT 'Admin Comment',
  `state_status` varchar(32) NOT NULL COMMENT 'ENABLED,  DISABLED or ARCHIVED',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Truncate table before insert `sale`
--

TRUNCATE TABLE `sale`;
-- --------------------------------------------------------

--
-- Table structure for table `sale_activity`
--

CREATE TABLE IF NOT EXISTS `sale_activity` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key / Auton',
  `parent_id` int(11) NOT NULL COMMENT 'Foreign Key: parent > ID',
  `created_at` datetime NOT NULL COMMENT 'audit: eloquent ORM',
  `state_stage` varchar(32) NOT NULL COMMENT 'Stage Changed to',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Truncate table before insert `sale_activity`
--

TRUNCATE TABLE `sale_activity`;
-- --------------------------------------------------------

--
-- Table structure for table `sale_attach`
--

CREATE TABLE IF NOT EXISTS `sale_attach` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key / Auton',
  `sid` varchar(64) NOT NULL COMMENT '4cc Checksum',
  `sale_id` int(11) NOT NULL COMMENT 'Foreign Key: app > ID',
  `tmpl_id` int(11) NOT NULL COMMENT 'Foreign Key: sale_attach_tmpl > ID',
  `created_by` int(11) NOT NULL COMMENT 'account  > ID',
  `created_at` datetime NOT NULL COMMENT 'audit: eloquent ORM',
  `updated_by` int(11) DEFAULT NULL COMMENT 'account  > ID or Null',
  `updated_at` datetime DEFAULT NULL COMMENT 'audit: eloquent ORM',
  `state_type` varchar(32) NOT NULL,
  `state_stage` varchar(32) NOT NULL,
  `attachment_nm` varchar(64) NOT NULL COMMENT 'Name of the attached file',
  `attachment_uri` varchar(176) NOT NULL COMMENT 'abs path',
  `comment` varchar(176) DEFAULT NULL COMMENT 'Admin Comment',
  `state_status` varchar(32) NOT NULL COMMENT 'ENABLED,  DISABLED or ARCHIVED',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Truncate table before insert `sale_attach`
--

TRUNCATE TABLE `sale_attach`;
-- --------------------------------------------------------

--
-- Table structure for table `sale_attach_activity`
--

CREATE TABLE IF NOT EXISTS `sale_attach_activity` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key / Auton',
  `parent_id` int(11) NOT NULL COMMENT 'Foreign Key: parent > ID',
  `created_at` datetime NOT NULL COMMENT 'audit: eloquent ORM',
  `state_stage` varchar(32) NOT NULL COMMENT 'Stage Changed to',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Truncate table before insert `sale_attach_activity`
--

TRUNCATE TABLE `sale_attach_activity`;
-- --------------------------------------------------------

--
-- Table structure for table `sale_attach_lkup`
--

CREATE TABLE IF NOT EXISTS `sale_attach_lkup` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key / Auton',
  `column_nm` varchar(64) NOT NULL COMMENT 'Column Name',
  `lookup_code` varchar(32) NOT NULL COMMENT 'Code - Uppercase',
  `lookup_desc` varchar(176) DEFAULT NULL COMMENT 'Description',
  `lookup_value` int(11) DEFAULT NULL COMMENT 'Value',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Truncate table before insert `sale_attach_lkup`
--

TRUNCATE TABLE `sale_attach_lkup`;
-- --------------------------------------------------------

--
-- Table structure for table `sale_attach_tmpl`
--

CREATE TABLE IF NOT EXISTS `sale_attach_tmpl` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key / Auton',
  `created_by` int(11) NOT NULL COMMENT 'Foreign Key: account  > ID',
  `created_at` datetime NOT NULL COMMENT 'audit: eloquent ORM',
  `updated_by` int(11) DEFAULT NULL COMMENT 'Foreign Key: account  > ID or Null',
  `updated_at` datetime DEFAULT NULL COMMENT 'audit: eloquent ORM',
  `state_type` varchar(32) NOT NULL DEFAULT 'INSTRUCTION',
  `tmpl_states` varchar(224) DEFAULT NULL COMMENT 'Pipe delimited 2cc State / Province codes',
  `tmpl_nm` varchar(64) NOT NULL COMMENT 'Name of the Template',
  `attachment_nm` varchar(64) NOT NULL COMMENT 'Name of the attached file',
  `attachment_uri` varchar(176) NOT NULL COMMENT 'abs path',
  `comment` blob COMMENT 'Admin Comment',
  `state_status` varchar(32) NOT NULL COMMENT 'ENABLED,  DISABLED or ARCHIVED',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Truncate table before insert `sale_attach_tmpl`
--

TRUNCATE TABLE `sale_attach_tmpl`;
-- --------------------------------------------------------

--
-- Table structure for table `sale_lkup`
--

CREATE TABLE IF NOT EXISTS `sale_lkup` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key / Auton',
  `column_nm` varchar(64) NOT NULL DEFAULT 'state_stage' COMMENT 'Column Name',
  `lookup_code` varchar(32) NOT NULL COMMENT 'Code - Uppercase',
  `lookup_desc` varchar(176) DEFAULT NULL COMMENT 'Description',
  `lookup_value` int(11) DEFAULT NULL COMMENT 'Value',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Truncate table before insert `sale_lkup`
--

TRUNCATE TABLE `sale_lkup`;
-- --------------------------------------------------------

--
-- Table structure for table `sys_log`
--

CREATE TABLE IF NOT EXISTS `sys_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key / Auton',
  `created_at` datetime NOT NULL COMMENT 'audit: eloquent ORM',
  `log_num` varchar(48) DEFAULT NULL COMMENT 'Unique - Upper Case - May reference requirement number',
  `log_msg` varchar(96) DEFAULT NULL COMMENT 'Description',
  `state_status` varchar(32) NOT NULL COMMENT 'TRACE, DEBUG, INFO, WARN, ERROR, FATAL',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Truncate table before insert `sys_log`
--

TRUNCATE TABLE `sys_log`;
-- --------------------------------------------------------

--
-- Table structure for table `vehicle`
--

CREATE TABLE IF NOT EXISTS `vehicle` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key / Auton',
  `sid` varchar(64) NOT NULL COMMENT '4cc Checksum',
  `seller_id` int(11) DEFAULT NULL COMMENT 'Foreign Key: account  > ID',
  `created_id` int(11) NOT NULL COMMENT 'account  > ID',
  `created_at` datetime NOT NULL COMMENT 'audit: eloquent ORM',
  `updated_by` int(11) DEFAULT NULL COMMENT 'account  > ID or Null',
  `updated_at` datetime NOT NULL COMMENT 'audit: eloquent ORM',
  `state_stage` varchar(32) NOT NULL,
  `make` varchar(32) NOT NULL COMMENT 'Make : Buyer Stub',
  `model` varchar(32) NOT NULL COMMENT 'Model : Buyer Stub',
  `year` varchar(4) NOT NULL COMMENT 'Year of Manufacture : Buyer Stub',
  `seller_email_temp` varchar(96) DEFAULT NULL COMMENT 'Email Address : Buyer Stub',
  `vin` varchar(17) NOT NULL COMMENT 'Vehicle Identification Number (cannot be unique because the same vehicle can be resold)',
  `mileage` int(11) NOT NULL COMMENT 'Odometer value in miles',
  `county_registered` varchar(64) NOT NULL COMMENT 'County of Registration',
  `color_exterior` varchar(16) NOT NULL COMMENT 'Primary Color (hex or rgb) : color picker',
  `color_interior` varchar(16) NOT NULL COMMENT 'Primary Color (hex or rgb) : color picker',
  `num_doors` int(11) NOT NULL COMMENT 'Number of Doors',
  `initial_price` decimal(19,4) NOT NULL COMMENT 'Initial Asking Price',
  `negotiable_ind` varchar(1) NOT NULL COMMENT 'Open to Negotiation on the Price',
  `public_ind` varchar(1) NOT NULL COMMENT 'Expose to any interested buyer (default 1 if created by Seller, 0 if stubbed by Buyer)',
  `num_views` int(11) NOT NULL COMMENT 'Number of times this vehicle was viewed',
  `state_status` varchar(32) NOT NULL COMMENT 'ENABLED,  DISABLED or ARCHIVED',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Truncate table before insert `vehicle`
--

TRUNCATE TABLE `vehicle`;
--
-- Dumping data for table `vehicle`
--

INSERT INTO `vehicle` (`id`, `sid`, `seller_id`, `created_id`, `created_at`, `updated_by`, `updated_at`, `state_stage`, `make`, `model`, `year`, `seller_email_temp`, `vin`, `mileage`, `county_registered`, `color_exterior`, `color_interior`, `num_doors`, `initial_price`, `negotiable_ind`, `public_ind`, `num_views`, `state_status`) VALUES
(1, 'da39a3ee5e6b4b0d3255bfef95601890afd80709', NULL, 1, '0000-00-00 00:00:00', NULL, '0000-00-00 00:00:00', 'NEW', 'Nissan', 'Altima', '2008', 'why is this required', '11111111111111111', 77000, 'Lake', '0000ff', '000000', 2, 20000.0000, '1', '1', 0, 'ACTIVE'),
(2, 'da39a3ee5e6b4b0d3255bfef95601890afd80709', NULL, 1, '0000-00-00 00:00:00', NULL, '0000-00-00 00:00:00', 'NEW', 'Nissan', 'Altima', '2008', 'why is this required', '11111111111111111', 77000, 'Lake', '0000ff', '000000', 2, 20000.0000, '1', '1', 0, 'ACTIVE');

-- --------------------------------------------------------

--
-- Table structure for table `vehicle_activity`
--

CREATE TABLE IF NOT EXISTS `vehicle_activity` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key / Auton',
  `parent_id` int(11) NOT NULL COMMENT 'Foreign Key: parent > ID',
  `created_at` datetime NOT NULL COMMENT 'audit: eloquent ORM',
  `state_stage` varchar(32) NOT NULL COMMENT 'Stage Changed to',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Truncate table before insert `vehicle_activity`
--

TRUNCATE TABLE `vehicle_activity`;
-- --------------------------------------------------------

--
-- Table structure for table `vehicle_attach`
--

CREATE TABLE IF NOT EXISTS `vehicle_attach` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key / Auton',
  `sid` varchar(64) NOT NULL COMMENT '4cc Checksum',
  `vehicle_id` int(11) NOT NULL COMMENT 'Foreign Key: vehicle > ID',
  `created_by` int(11) NOT NULL COMMENT 'account  > ID',
  `created_at` datetime NOT NULL COMMENT 'audit: eloquent ORM',
  `updated_by` int(11) DEFAULT NULL COMMENT 'account  > ID or Null',
  `updated_at` datetime DEFAULT NULL COMMENT 'audit: eloquent ORM',
  `state_type` varchar(32) NOT NULL,
  `attachment_nm` varchar(64) NOT NULL COMMENT 'Name of the attached file',
  `attachment_uri` varchar(176) NOT NULL COMMENT 'abs path',
  `comment` varchar(176) DEFAULT NULL COMMENT 'Admin Comment',
  `state_status` varchar(32) NOT NULL COMMENT 'ENABLED,  DISABLED or ARCHIVED',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Truncate table before insert `vehicle_attach`
--

TRUNCATE TABLE `vehicle_attach`;
-- --------------------------------------------------------

--
-- Table structure for table `vehicle_attach_activity`
--

CREATE TABLE IF NOT EXISTS `vehicle_attach_activity` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key / Auton',
  `parent_id` int(11) NOT NULL COMMENT 'Foreign Key: parent > ID',
  `created_at` datetime NOT NULL COMMENT 'audit: eloquent ORM',
  `state_stage` varchar(32) NOT NULL COMMENT 'Stage Changed to',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Truncate table before insert `vehicle_attach_activity`
--

TRUNCATE TABLE `vehicle_attach_activity`;
-- --------------------------------------------------------

--
-- Table structure for table `vehicle_attach_lkup`
--

CREATE TABLE IF NOT EXISTS `vehicle_attach_lkup` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key / Auton',
  `column_nm` varchar(64) NOT NULL DEFAULT 'state_type' COMMENT 'Column Name',
  `lookup_code` varchar(32) NOT NULL COMMENT 'Code - Uppercase',
  `lookup_desc` varchar(176) DEFAULT NULL COMMENT 'Description',
  `lookup_value` int(11) DEFAULT NULL COMMENT 'Value',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Truncate table before insert `vehicle_attach_lkup`
--

TRUNCATE TABLE `vehicle_attach_lkup`;
-- --------------------------------------------------------

--
-- Table structure for table `vehicle_lkup`
--

CREATE TABLE IF NOT EXISTS `vehicle_lkup` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key / Auton',
  `column_nm` varchar(64) NOT NULL DEFAULT 'state_stage' COMMENT 'Column Name',
  `lookup_code` varchar(32) NOT NULL COMMENT 'Code - Uppercase',
  `lookup_desc` varchar(176) DEFAULT NULL COMMENT 'Description',
  `lookup_value` int(11) DEFAULT NULL COMMENT 'Value',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Truncate table before insert `vehicle_lkup`
--

TRUNCATE TABLE `vehicle_lkup`;
-- --------------------------------------------------------

--
-- Table structure for table `vehicle_offer`
--

CREATE TABLE IF NOT EXISTS `vehicle_offer` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key / Auton',
  `vehicle_id` int(11) NOT NULL COMMENT 'Foreign Key: Vehicle> ID',
  `buyer_id` int(11) NOT NULL COMMENT 'Foreign Key: account  > ID',
  `created_by` int(11) DEFAULT NULL COMMENT 'account  > ID or Null',
  `created_at` datetime NOT NULL COMMENT 'audit: eloquent ORM',
  `updated_by` int(11) DEFAULT NULL COMMENT 'account  > ID or Null',
  `updated_at` datetime DEFAULT NULL COMMENT 'audit: eloquent ORM',
  `state_type` varchar(32) NOT NULL,
  `offer_amount` decimal(19,4) DEFAULT NULL COMMENT 'Proposed Price',
  `double_blind_offer_ind` varchar(1) NOT NULL COMMENT 'Display Offer Amount',
  `dbo_amount` decimal(19,4) NOT NULL COMMENT 'Double Blind Bid Suggested / Derived Amount',
  `offer_msg` varchar(176) NOT NULL COMMENT 'Offer Message',
  `offer_ committed_ind` varchar(1) NOT NULL COMMENT 'Price Agreed',
  `state_status` varchar(32) NOT NULL COMMENT 'ENABLED,  DISABLED or ARCHIVED',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Truncate table before insert `vehicle_offer`
--

TRUNCATE TABLE `vehicle_offer`;
-- --------------------------------------------------------

--
-- Table structure for table `vehicle_offer_lkup`
--

CREATE TABLE IF NOT EXISTS `vehicle_offer_lkup` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key / Auton',
  `column_nm` varchar(64) NOT NULL DEFAULT 'state_stage' COMMENT 'Column Name',
  `lookup_code` varchar(32) NOT NULL COMMENT 'Code - Uppercase',
  `lookup_desc` varchar(176) DEFAULT NULL COMMENT 'Description',
  `lookup_value` int(11) DEFAULT NULL COMMENT 'Value',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Truncate table before insert `vehicle_offer_lkup`
--

TRUNCATE TABLE `vehicle_offer_lkup`;
-- --------------------------------------------------------

--
-- Table structure for table `vehicle_trim_rel`
--

CREATE TABLE IF NOT EXISTS `vehicle_trim_rel` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key / Auton',
  `vehicle_id` int(11) NOT NULL COMMENT 'Foreign Key: vehicle > ID',
  `met_trim_lkup_id` int(11) NOT NULL COMMENT 'Foreign Key: met_trim_lkup > ID',
  `trim_nm` varchar(32) NOT NULL COMMENT 'Trim',
  `trim_desc` varchar(176) NOT NULL COMMENT 'Description',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Truncate table before insert `vehicle_trim_rel`
--

TRUNCATE TABLE `vehicle_trim_rel`;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

'''
