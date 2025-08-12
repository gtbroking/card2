/*
  # Complete Database Schema for PHP Microsite
  
  This migration creates all necessary tables for the PHP microsite with sample data.
  
  ## Tables Created:
  1. admins - Admin user accounts
  2. products - Product catalog
  3. orders - Customer orders
  4. order_items - Order line items
  5. reviews - Customer reviews
  6. videos - YouTube videos
  7. banners - Promotional banners
  8. pdfs - Downloadable PDFs
  9. site_settings - Site configuration
  10. translations - Multi-language support
  11. gallery - Photo gallery
  12. visits - Visitor tracking
  13. users - Customer accounts
  14. inquiries - Product inquiries
  15. free_website_requests - Free website requests
  16. admin_bypass_tokens - Admin bypass tokens
*/

-- Create admins table
CREATE TABLE IF NOT EXISTS `admins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL UNIQUE,
  `email` varchar(100) NOT NULL UNIQUE,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('admin','super_admin') DEFAULT 'admin',
  `status` enum('active','inactive') DEFAULT 'active',
  `last_login` timestamp NULL DEFAULT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_username` (`username`),
  INDEX `idx_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create products table
CREATE TABLE IF NOT EXISTS `products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `discount_price` decimal(10,2) DEFAULT NULL,
  `qty_stock` int(11) DEFAULT 0,
  `image_url` varchar(500) DEFAULT NULL,
  `gallery_images` json DEFAULT NULL,
  `inquiry_only` tinyint(1) DEFAULT 0,
  `status` enum('active','inactive') DEFAULT 'active',
  `sort_order` int(11) DEFAULT 0,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_status` (`status`),
  INDEX `idx_sort_order` (`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create users table
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `username` varchar(50) NOT NULL UNIQUE,
  `email` varchar(100) NOT NULL UNIQUE,
  `phone` varchar(20) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `last_login` timestamp NULL DEFAULT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_username` (`username`),
  INDEX `idx_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create orders table
CREATE TABLE IF NOT EXISTS `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `order_number` varchar(50) NOT NULL UNIQUE,
  `user_name` varchar(100) DEFAULT NULL,
  `user_phone` varchar(20) DEFAULT NULL,
  `user_email` varchar(100) DEFAULT NULL,
  `total_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `final_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `status` enum('pending','confirmed','paid','shipped','delivered','cancelled') DEFAULT 'pending',
  `payment_method` varchar(50) DEFAULT 'upi',
  `payment_status` enum('pending','paid','failed') DEFAULT 'pending',
  `notes` text DEFAULT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL,
  INDEX `idx_order_number` (`order_number`),
  INDEX `idx_status` (`status`),
  INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create order_items table
CREATE TABLE IF NOT EXISTS `order_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) DEFAULT NULL,
  `product_title` varchar(200) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `unit_price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `total_price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`order_id`) REFERENCES `orders`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON DELETE SET NULL,
  INDEX `idx_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create reviews table
CREATE TABLE IF NOT EXISTS `reviews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `rating` int(1) NOT NULL CHECK (`rating` >= 1 AND `rating` <= 5),
  `comment` text NOT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `ip_address` varchar(45) DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_status` (`status`),
  INDEX `idx_rating` (`rating`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create videos table
CREATE TABLE IF NOT EXISTS `videos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `youtube_url` varchar(500) DEFAULT NULL,
  `embed_code` varchar(500) DEFAULT NULL,
  `thumbnail_url` varchar(500) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `sort_order` int(11) DEFAULT 0,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_status` (`status`),
  INDEX `idx_sort_order` (`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create banners table
CREATE TABLE IF NOT EXISTS `banners` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) DEFAULT NULL,
  `image_url` varchar(500) NOT NULL,
  `link_url` varchar(500) DEFAULT NULL,
  `position` enum('top','bottom','both') DEFAULT 'both',
  `status` enum('active','inactive') DEFAULT 'active',
  `sort_order` int(11) DEFAULT 0,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_status` (`status`),
  INDEX `idx_position` (`position`),
  INDEX `idx_sort_order` (`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create pdfs table
CREATE TABLE IF NOT EXISTS `pdfs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `file_url` varchar(500) NOT NULL,
  `file_size` int(11) DEFAULT NULL,
  `download_count` int(11) DEFAULT 0,
  `status` enum('active','inactive') DEFAULT 'active',
  `sort_order` int(11) DEFAULT 0,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_status` (`status`),
  INDEX `idx_sort_order` (`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create site_settings table
CREATE TABLE IF NOT EXISTS `site_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(100) NOT NULL UNIQUE,
  `setting_value` text DEFAULT NULL,
  `setting_type` enum('text','number','boolean','json','url') DEFAULT 'text',
  `description` varchar(255) DEFAULT NULL,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_setting_key` (`setting_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create translations table
CREATE TABLE IF NOT EXISTS `translations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `language_code` varchar(5) NOT NULL DEFAULT 'en',
  `translation_key` varchar(100) NOT NULL,
  `translation_value` text NOT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_lang_key` (`language_code`, `translation_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create gallery table
CREATE TABLE IF NOT EXISTS `gallery` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `image_url` varchar(500) NOT NULL,
  `thumbnail_url` varchar(500) DEFAULT NULL,
  `alt_text` varchar(200) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `sort_order` int(11) DEFAULT 0,
  `upload_date` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_status` (`status`),
  INDEX `idx_sort_order` (`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create visits table
CREATE TABLE IF NOT EXISTS `visits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `page` varchar(100) DEFAULT 'home',
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `referer` varchar(500) DEFAULT NULL,
  `visit_time` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_page` (`page`),
  INDEX `idx_visit_time` (`visit_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create inquiries table
CREATE TABLE IF NOT EXISTS `inquiries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(100) DEFAULT NULL,
  `user_phone` varchar(20) DEFAULT NULL,
  `user_email` varchar(100) DEFAULT NULL,
  `products` json DEFAULT NULL,
  `message` text DEFAULT NULL,
  `status` enum('pending','contacted','completed') DEFAULT 'pending',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_status` (`status`),
  INDEX `idx_phone` (`user_phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create free_website_requests table
CREATE TABLE IF NOT EXISTS `free_website_requests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `mobile` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `business_details` text DEFAULT NULL,
  `status` enum('pending','contacted','completed') DEFAULT 'pending',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_status` (`status`),
  INDEX `idx_mobile` (`mobile`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create admin_bypass_tokens table
CREATE TABLE IF NOT EXISTS `admin_bypass_tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) NOT NULL,
  `token` varchar(64) NOT NULL UNIQUE,
  `expires_at` timestamp NOT NULL,
  `used` tinyint(1) DEFAULT 0,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`admin_id`) REFERENCES `admins`(`id`) ON DELETE CASCADE,
  INDEX `idx_token` (`token`),
  INDEX `idx_expires` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default admin user
INSERT INTO `admins` (`username`, `email`, `password_hash`, `role`, `status`) VALUES
('admin', 'admin@demo.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'super_admin', 'active');

-- Insert sample products
INSERT INTO `products` (`title`, `description`, `price`, `discount_price`, `qty_stock`, `image_url`, `inquiry_only`, `status`, `sort_order`) VALUES
('Premium Business Card', 'High-quality business cards with premium finish and professional design', 500.00, 399.00, 100, 'https://images.pexels.com/photos/6289065/pexels-photo-6289065.jpeg?auto=compress&cs=tinysrgb&w=400', 0, 'active', 1),
('Digital Visiting Card', 'Modern digital visiting card solution with QR code and online sharing', 299.00, NULL, 50, 'https://images.pexels.com/photos/6289025/pexels-photo-6289025.jpeg?auto=compress&cs=tinysrgb&w=400', 0, 'active', 2),
('Corporate Branding Package', 'Complete corporate branding solution including logo, letterhead, and business cards', 2999.00, 1999.00, 20, 'https://images.pexels.com/photos/3184339/pexels-photo-3184339.jpeg?auto=compress&cs=tinysrgb&w=400', 0, 'active', 3),
('Logo Design Service', 'Professional logo design service with multiple concepts and revisions', 1500.00, NULL, 0, 'https://images.pexels.com/photos/3184432/pexels-photo-3184432.jpeg?auto=compress&cs=tinysrgb&w=400', 1, 'active', 4),
('Website Development', 'Custom website development with responsive design and SEO optimization', 15000.00, 12000.00, 0, 'https://images.pexels.com/photos/196644/pexels-photo-196644.jpeg?auto=compress&cs=tinysrgb&w=400', 1, 'active', 5);

-- Insert sample reviews
INSERT INTO `reviews` (`name`, `email`, `phone`, `rating`, `comment`, `status`, `approved_at`) VALUES
('Rajesh Kumar', 'rajesh@example.com', '9876543210', 5, 'Excellent service and professional quality work. Highly recommended for business cards!', 'approved', NOW()),
('Priya Singh', 'priya@example.com', '9876543211', 4, 'Great experience with their team. Very responsive and helpful throughout the process.', 'approved', NOW()),
('Amit Sharma', 'amit@example.com', '9876543212', 5, 'Outstanding digital visiting card solution. Modern and professional design.', 'approved', NOW()),
('Neha Patel', 'neha@example.com', '9876543213', 4, 'Good quality products and timely delivery. Will definitely use their services again.', 'approved', NOW());

-- Insert sample videos
INSERT INTO `videos` (`title`, `description`, `youtube_url`, `embed_code`, `status`, `sort_order`) VALUES
('Company Introduction', 'Learn about our company and services', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 'https://www.youtube.com/embed/dQw4w9WgXcQ', 'active', 1),
('Product Showcase', 'Showcase of our premium business card designs', 'https://www.youtube.com/watch?v=jNQXAC9IVRw', 'https://www.youtube.com/embed/jNQXAC9IVRw', 'active', 2),
('Customer Testimonials', 'What our customers say about our services', 'https://www.youtube.com/watch?v=9bZkp7q19f0', 'https://www.youtube.com/embed/9bZkp7q19f0', 'active', 3);

-- Insert sample banners
INSERT INTO `banners` (`title`, `image_url`, `link_url`, `position`, `status`, `sort_order`) VALUES
('Special Offer Banner', 'https://images.pexels.com/photos/3184360/pexels-photo-3184360.jpeg?auto=compress&cs=tinysrgb&w=800', '#', 'both', 'active', 1),
('New Product Launch', 'https://images.pexels.com/photos/3184338/pexels-photo-3184338.jpeg?auto=compress&cs=tinysrgb&w=800', '#', 'both', 'active', 2),
('Premium Services', 'https://images.pexels.com/photos/3184465/pexels-photo-3184465.jpeg?auto=compress&cs=tinysrgb&w=800', '#', 'both', 'active', 3);

-- Insert sample PDFs
INSERT INTO `pdfs` (`title`, `description`, `file_url`, `status`, `sort_order`) VALUES
('Company Brochure', 'Download our complete company brochure', '/uploads/brochure.pdf', 'active', 1),
('Product Catalog', 'Complete catalog of all our products and services', '/uploads/catalog.pdf', 'active', 2),
('Price List', 'Current pricing for all our services', '/uploads/pricelist.pdf', 'active', 3),
('Company Profile', 'Detailed company profile and capabilities', '/uploads/profile.pdf', 'active', 4),
('Portfolio', 'Portfolio of our completed projects', '/uploads/portfolio.pdf', 'active', 5);

-- Insert sample gallery images
INSERT INTO `gallery` (`title`, `description`, `image_url`, `alt_text`, `status`, `sort_order`) VALUES
('Business Card Design 1', 'Premium business card design sample', 'https://images.pexels.com/photos/6289065/pexels-photo-6289065.jpeg?auto=compress&cs=tinysrgb&w=400', 'Business Card Design', 'active', 1),
('Business Card Design 2', 'Modern business card design sample', 'https://images.pexels.com/photos/6289025/pexels-photo-6289025.jpeg?auto=compress&cs=tinysrgb&w=400', 'Modern Business Card', 'active', 2),
('Logo Design Sample', 'Professional logo design sample', 'https://images.pexels.com/photos/3184432/pexels-photo-3184432.jpeg?auto=compress&cs=tinysrgb&w=400', 'Logo Design', 'active', 3),
('Branding Package', 'Complete branding package sample', 'https://images.pexels.com/photos/3184339/pexels-photo-3184339.jpeg?auto=compress&cs=tinysrgb&w=400', 'Branding Package', 'active', 4);

-- Insert comprehensive site settings
INSERT INTO `site_settings` (`setting_key`, `setting_value`, `setting_type`, `description`) VALUES
('site_title', 'DEMO CARD - Professional Visiting Card', 'text', 'Website title'),
('company_name', 'DEMO CARD', 'text', 'Company name'),
('director_name', 'Vishal Rathod', 'text', 'Director/Owner name'),
('director_title', 'FOUNDER', 'text', 'Director title'),
('contact_phone1', '9765834383', 'text', 'Primary contact phone'),
('contact_phone2', '9765834383', 'text', 'Secondary contact phone'),
('contact_email', 'info@galaxytribes.in', 'text', 'Contact email'),
('contact_address', 'Nashik, Maharashtra, India', 'text', 'Business address'),
('whatsapp_number', '919765834383', 'text', 'WhatsApp number with country code'),
('website_url', 'https://galaxytribes.in', 'url', 'Company website URL'),
('upi_id', 'demo@upi', 'text', 'UPI ID for payments'),
('meta_description', 'Professional digital visiting card and business services. Get premium business cards, logo design, and complete branding solutions.', 'text', 'Meta description for SEO'),
('meta_keywords', 'visiting card, business card, digital card, logo design, branding, professional services', 'text', 'Meta keywords for SEO'),
('current_theme', 'blue-dark', 'text', 'Current active theme'),
('logo_url', '', 'url', 'Company logo URL'),
('view_count', '1521', 'number', 'Website view counter'),
('discount_text', 'DISCOUNT UPTO 50% Live Use FREE code', 'text', 'Discount popup text'),
('show_discount_popup', '1', 'boolean', 'Show discount popup'),
('show_pwa_prompt', '1', 'boolean', 'Show PWA install prompt'),
('google_analytics', '', 'text', 'Google Analytics tracking ID'),
('facebook_pixel', '', 'text', 'Facebook Pixel ID'),
('social_facebook', 'https://facebook.com/democard', 'url', 'Facebook page URL'),
('social_youtube', 'https://youtube.com/democard', 'url', 'YouTube channel URL'),
('social_twitter', 'https://twitter.com/democard', 'url', 'Twitter profile URL'),
('social_instagram', 'https://instagram.com/democard', 'url', 'Instagram profile URL'),
('social_linkedin', 'https://linkedin.com/company/democard', 'url', 'LinkedIn page URL'),
('social_pinterest', 'https://pinterest.com/democard', 'url', 'Pinterest profile URL'),
('social_telegram', 'https://t.me/democard', 'url', 'Telegram channel URL'),
('social_zomato', 'https://zomato.com/democard', 'url', 'Zomato page URL');

-- Insert sample translations
INSERT INTO `translations` (`language_code`, `translation_key`, `translation_value`) VALUES
('en', 'welcome', 'Welcome'),
('hi', 'welcome', 'स्वागत'),
('en', 'products', 'Products'),
('hi', 'products', 'उत्पाद'),
('en', 'services', 'Services'),
('hi', 'services', 'सेवाएं'),
('en', 'contact', 'Contact'),
('hi', 'contact', 'संपर्क'),
('en', 'about', 'About Us'),
('hi', 'about', 'हमारे बारे में');

-- Insert sample users
INSERT INTO `users` (`name`, `username`, `email`, `phone`, `password_hash`, `status`) VALUES
('John Doe', 'johndoe', 'john@example.com', '9876543210', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'active'),
('Jane Smith', 'janesmith', 'jane@example.com', '9876543211', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'active');

-- Insert sample orders
INSERT INTO `orders` (`order_number`, `user_name`, `user_phone`, `user_email`, `total_amount`, `final_amount`, `status`, `payment_status`) VALUES
('ORD20250101001', 'Test Customer', '9876543210', 'test@example.com', 399.00, 399.00, 'pending', 'pending'),
('ORD20250101002', 'Sample User', '9876543211', 'sample@example.com', 1999.00, 1999.00, 'confirmed', 'paid');

-- Insert sample order items
INSERT INTO `order_items` (`order_id`, `product_id`, `product_title`, `quantity`, `unit_price`, `total_price`) VALUES
(1, 1, 'Premium Business Card', 1, 399.00, 399.00),
(2, 3, 'Corporate Branding Package', 1, 1999.00, 1999.00);

-- Insert sample inquiries
INSERT INTO `inquiries` (`user_name`, `user_phone`, `user_email`, `products`, `message`, `status`) VALUES
('Inquiry Customer', '9876543212', 'inquiry@example.com', '[{"id": 4, "title": "Logo Design Service"}]', 'Interested in logo design for my startup', 'pending'),
('Business Owner', '9876543213', 'business@example.com', '[{"id": 5, "title": "Website Development"}]', 'Need a professional website for my business', 'contacted');

-- Insert sample free website requests
INSERT INTO `free_website_requests` (`name`, `mobile`, `email`, `business_details`, `status`) VALUES
('Restaurant Owner', '9876543214', 'restaurant@example.com', 'I own a restaurant and need a website to showcase our menu and take online orders', 'pending'),
('Freelancer', '9876543215', 'freelancer@example.com', 'I am a freelance photographer and need a portfolio website', 'contacted');

-- Insert sample visits for analytics
INSERT INTO `visits` (`page`, `ip_address`, `user_agent`) VALUES
('home', '192.168.1.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'),
('home', '192.168.1.2', 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X)'),
('home', '192.168.1.3', 'Mozilla/5.0 (Android 10; Mobile; rv:81.0)');