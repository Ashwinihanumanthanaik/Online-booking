package com.ecommerce.repository;

import com.ecommerce.model.Product;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class ProductRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private static final RowMapper<Product> PRODUCT_ROW_MAPPER = (rs, rowNum) -> {
        Product p = new Product();
        p.setId(rs.getInt("id"));
        p.setName(rs.getString("name"));
        p.setDescription(rs.getString("description"));
        p.setPrice(rs.getDouble("price"));
        p.setImageUrl(rs.getString("image_url"));
        p.setCategory(rs.getString("category"));
        p.setStock(rs.getInt("stock"));
        p.setRating(rs.getDouble("rating"));
        return p;
    };

    // Get all products
    public List<Product> findAll() {
        return jdbcTemplate.query("SELECT * FROM products ORDER BY id", PRODUCT_ROW_MAPPER);
    }

    // Get product by ID
    public Product findById(int id) {
        List<Product> results = jdbcTemplate.query(
            "SELECT * FROM products WHERE id = ?", PRODUCT_ROW_MAPPER, id);
        return results.isEmpty() ? null : results.get(0);
    }

    // Search products by name or description
    public List<Product> search(String keyword) {
        String sql = "SELECT * FROM products WHERE LOWER(name) LIKE ? OR LOWER(description) LIKE ?";
        String pattern = "%" + keyword.toLowerCase() + "%";
        return jdbcTemplate.query(sql, PRODUCT_ROW_MAPPER, pattern, pattern);
    }

    // Filter by category
    public List<Product> findByCategory(String category) {
        return jdbcTemplate.query(
            "SELECT * FROM products WHERE category = ? ORDER BY id",
            PRODUCT_ROW_MAPPER, category);
    }

    // Search + filter combined
    public List<Product> searchAndFilter(String keyword, String category, String sortBy) {
        StringBuilder sql = new StringBuilder("SELECT * FROM products WHERE 1=1");
        java.util.List<Object> params = new java.util.ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (LOWER(name) LIKE ? OR LOWER(description) LIKE ?)");
            String pattern = "%" + keyword.toLowerCase() + "%";
            params.add(pattern);
            params.add(pattern);
        }

        if (category != null && !category.trim().isEmpty() && !category.equals("All")) {
            sql.append(" AND category = ?");
            params.add(category);
        }

        switch (sortBy == null ? "" : sortBy) {
            case "price_asc"  -> sql.append(" ORDER BY price ASC");
            case "price_desc" -> sql.append(" ORDER BY price DESC");
            case "rating"     -> sql.append(" ORDER BY rating DESC");
            default           -> sql.append(" ORDER BY id");
        }

        return jdbcTemplate.query(sql.toString(), PRODUCT_ROW_MAPPER, params.toArray());
    }

    // Get distinct categories
    public List<String> findAllCategories() {
        return jdbcTemplate.queryForList("SELECT DISTINCT category FROM products ORDER BY category", String.class);
    }
}
