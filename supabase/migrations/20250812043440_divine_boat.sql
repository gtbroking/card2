/*
  # Additional Database Updates for Enhanced Features
  
  This migration adds new columns and features to support the enhanced admin dashboard.
  
  ## New Features Added:
  1. Director image upload support
  2. Enhanced admin profile features
  3. Additional site settings
  4. Improved UPI payment support
*/

-- Add director image URL to site settings if not exists
INSERT IGNORE INTO `site_settings` (`setting_key`, `setting_value`, `setting_type`, `description`) VALUES
('director_image_url', '', 'url', 'Director/Owner profile image URL'),
('sticky_banner_enabled', '1', 'boolean', 'Enable sticky top banner'),
('sticky_banner_text', 'DISCOUNT UPTO 50% Live Use FREE code', 'text', 'Sticky banner text'),
('upi_merchant_name', 'DEMO CARD', 'text', 'UPI merchant display name'),
('payment_timer_minutes', '5', 'number', 'Payment confirmation timer in minutes'),
('inquiry_whatsapp_message', 'Hi! I would like to inquire about your products.', 'text', 'Default inquiry WhatsApp message');

-- Add profile image URL column to admins table if not exists
ALTER TABLE `admins` ADD COLUMN IF NOT EXISTS `profile_image_url` VARCHAR(500) DEFAULT NULL;

-- Add additional columns to products table for better management
ALTER TABLE `products` ADD COLUMN IF NOT EXISTS `meta_title` VARCHAR(200) DEFAULT NULL;
ALTER TABLE `products` ADD COLUMN IF NOT EXISTS `meta_description` TEXT DEFAULT NULL;
ALTER TABLE `products` ADD COLUMN IF NOT EXISTS `tags` TEXT DEFAULT NULL;

-- Add additional columns to reviews table for better management
ALTER TABLE `reviews` ADD COLUMN IF NOT EXISTS `product_id` INT(11) DEFAULT NULL;
ALTER TABLE `reviews` ADD COLUMN IF NOT EXISTS `helpful_count` INT(11) DEFAULT 0;
ALTER TABLE `reviews` ADD COLUMN IF NOT EXISTS `verified_purchase` TINYINT(1) DEFAULT 0;

-- Add foreign key for product reviews if column exists
-- ALTER TABLE `reviews` ADD FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON DELETE SET NULL;

-- Add additional columns to orders table for better tracking
ALTER TABLE `orders` ADD COLUMN IF NOT EXISTS `tracking_number` VARCHAR(100) DEFAULT NULL;
ALTER TABLE `orders` ADD COLUMN IF NOT EXISTS `estimated_delivery` DATE DEFAULT NULL;
ALTER TABLE `orders` ADD COLUMN IF NOT EXISTS `actual_delivery` DATE DEFAULT NULL;
ALTER TABLE `orders` ADD COLUMN IF NOT EXISTS `delivery_address` TEXT DEFAULT NULL;

-- Add session management table for better security
CREATE TABLE IF NOT EXISTS `admin_sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) NOT NULL,
  `session_token` varchar(128) NOT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `expires_at` timestamp NOT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`admin_id`) REFERENCES `admins`(`id`) ON DELETE CASCADE,
  INDEX `idx_session_token` (`session_token`),
  INDEX `idx_expires_at` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Add payment tracking table
CREATE TABLE IF NOT EXISTS `payment_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `transaction_id` varchar(100) DEFAULT NULL,
  `payment_method` varchar(50) DEFAULT 'upi',
  `amount` decimal(10,2) NOT NULL,
  `status` enum('pending','success','failed','cancelled') DEFAULT 'pending',
  `gateway_response` json DEFAULT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`order_id`) REFERENCES `orders`(`id`) ON DELETE CASCADE,
  INDEX `idx_transaction_id` (`transaction_id`),
  INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Add newsletter subscription table
CREATE TABLE IF NOT EXISTS `newsletter_subscriptions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(100) NOT NULL UNIQUE,
  `name` varchar(100) DEFAULT NULL,
  `status` enum('active','unsubscribed') DEFAULT 'active',
  `subscribed_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `unsubscribed_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_email` (`email`),
  INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Add activity log table for admin actions
CREATE TABLE IF NOT EXISTS `admin_activity_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) NOT NULL,
  `action` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`admin_id`) REFERENCES `admins`(`id`) ON DELETE CASCADE,
  INDEX `idx_admin_id` (`admin_id`),
  INDEX `idx_action` (`action`),
  INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert additional sample data for testing
INSERT IGNORE INTO `site_settings` (`setting_key`, `setting_value`, `setting_type`, `description`) VALUES
('seo_title_suffix', ' - DEMO CARD', 'text', 'SEO title suffix for all pages'),
('google_analytics_id', '', 'text', 'Google Analytics tracking ID'),
('facebook_pixel_id', '', 'text', 'Facebook Pixel ID'),
('whatsapp_chat_enabled', '1', 'boolean', 'Enable WhatsApp chat widget'),
('maintenance_mode', '0', 'boolean', 'Enable maintenance mode'),
('max_cart_items', '50', 'number', 'Maximum items allowed in cart'),
('min_order_amount', '100', 'number', 'Minimum order amount'),
('free_shipping_threshold', '500', 'number', 'Free shipping threshold amount'),
('currency_symbol', '₹', 'text', 'Currency symbol'),
('currency_code', 'INR', 'text', 'Currency code'),
('timezone', 'Asia/Kolkata', 'text', 'Website timezone'),
('date_format', 'd/m/Y', 'text', 'Date display format'),
('time_format', 'H:i', 'text', 'Time display format');

-- Update existing settings with better defaults
UPDATE `site_settings` SET `setting_value` = 'Professional Digital Visiting Card and Business Services - Get premium business cards, logo design, and complete branding solutions.' WHERE `setting_key` = 'meta_description';
UPDATE `site_settings` SET `setting_value` = 'visiting card, business card, digital card, logo design, branding, professional services, business solutions, corporate identity' WHERE `setting_key` = 'meta_keywords';

-- Add some sample admin activity logs
INSERT IGNORE INTO `admin_activity_log` (`admin_id`, `action`, `description`, `ip_address`) VALUES
(1, 'login', 'Admin logged in successfully', '127.0.0.1'),
(1, 'product_add', 'Added new product: Premium Business Card', '127.0.0.1'),
(1, 'settings_update', 'Updated site settings', '127.0.0.1');