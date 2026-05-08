package com.ecommerce.config;

import org.springframework.jdbc.core.JdbcTemplate;

public class DatabaseInitializer {

    private JdbcTemplate jdbcTemplate;

    public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public void init() {
        // Create products table
        jdbcTemplate.execute("""
            CREATE TABLE IF NOT EXISTS products (
                id INT AUTO_INCREMENT PRIMARY KEY,
                name VARCHAR(255) NOT NULL,
                description TEXT,
                price DECIMAL(10,2) NOT NULL,
                image_url VARCHAR(500),
                category VARCHAR(100),
                stock INT DEFAULT 100,
                rating DECIMAL(2,1) DEFAULT 4.0
            )
        """);

        // Create orders table
        jdbcTemplate.execute("""
            CREATE TABLE IF NOT EXISTS orders (
                id INT AUTO_INCREMENT PRIMARY KEY,
                customer_name VARCHAR(255),
                customer_email VARCHAR(255),
                customer_address TEXT,
                total_amount DECIMAL(10,2),
                order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                status VARCHAR(50) DEFAULT 'CONFIRMED'
            )
        """);

        // Create order_items table
        jdbcTemplate.execute("""
            CREATE TABLE IF NOT EXISTS order_items (
                id INT AUTO_INCREMENT PRIMARY KEY,
                order_id INT,
                product_id INT,
                product_name VARCHAR(255),
                quantity INT,
                price DECIMAL(10,2),
                FOREIGN KEY (order_id) REFERENCES orders(id)
            )
        """);

        // Seed sample products
        Integer count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM products", Integer.class);
        if (count == null || count == 0) {
            seedProducts();
        }
    }

    private void seedProducts() {
        String sql = "INSERT INTO products (name, description, price, image_url, category, stock, rating) VALUES (?, ?, ?, ?, ?, ?, ?)";

        Object[][] products = {
            // Electronics
            {"Wireless Noise-Cancelling Headphones",
             "Premium over-ear headphones with 30hr battery, active noise cancellation, and crystal-clear audio quality.",
             79.99, "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400", "Electronics", 50, 4.7},

            {"Mechanical Gaming Keyboard",
             "RGB backlit mechanical keyboard with tactile switches, anti-ghosting, and ergonomic wrist rest.",
             59.99, "https://images.unsplash.com/photo-1541140532154-b024d705b90a?w=400", "Electronics", 30, 4.5},

            {"4K Webcam",
             "Ultra HD webcam with built-in ring light, noise-canceling mic, and plug-and-play USB-C connectivity.",
             89.99, "https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=400", "Electronics", 20, 4.3},

            {"Smart Watch Pro",
             "Feature-packed smartwatch with heart rate monitor, GPS, sleep tracking, and 7-day battery life.",
             149.99, "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400", "Electronics", 40, 4.6},

            {"Portable Bluetooth Speaker",
             "Waterproof portable speaker with 360° sound, 24hr playtime and built-in powerbank.",
             49.99, "https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=400", "Electronics", 60, 4.4},

            // Books
            {"Clean Code: A Handbook",
             "A must-read for every developer. Learn how to write maintainable, readable, and professional code.",
             34.99, "https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400", "Books", 100, 4.8},

            {"Spring Boot in Action",
             "Comprehensive guide to building production-ready Spring Boot applications with real-world examples.",
             39.99, "https://images.unsplash.com/photo-1589998059171-988d887df646?w=400", "Books", 80, 4.6},

            {"JavaScript: The Good Parts",
             "Discover the elegantly simple parts of JavaScript. Essential reading for web developers.",
             24.99, "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400", "Books", 90, 4.5},

            // Clothing
            {"Premium Cotton T-Shirt",
             "Ultra-soft 100% organic cotton t-shirt. Breathable, durable, and available in 12 colors.",
             19.99, "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400", "Clothing", 200, 4.3},

            {"Slim Fit Jeans",
             "Classic slim-fit denim jeans with stretch comfort fabric. Perfect for everyday casual wear.",
             44.99, "https://images.unsplash.com/photo-1542272604-787c3835535d?w=400", "Clothing", 150, 4.2},

            // Home
            {"Ceramic Coffee Mug Set",
             "Set of 4 handcrafted ceramic mugs with minimalist design. Microwave and dishwasher safe.",
             29.99, "https://images.unsplash.com/photo-1514228742587-6b1558fcca3d?w=400", "Home", 75, 4.7},

            {"LED Desk Lamp",
             "Smart LED desk lamp with touch controls, USB charging port, 5 color modes and adjustable brightness.",
             39.99, "https://images.unsplash.com/photo-1616627451515-cbc80e5ece6d?w=400", "Home", 45, 4.5},
        };

        for (Object[] product : products) {
            jdbcTemplate.update(sql, product);
        }
    }
}
