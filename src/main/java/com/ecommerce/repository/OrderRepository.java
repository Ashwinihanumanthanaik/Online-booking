package com.ecommerce.repository;

import com.ecommerce.model.Order;
import com.ecommerce.model.OrderItem;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.List;

@Repository
public class OrderRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public int save(Order order) {
        String sql = "INSERT INTO orders (customer_name, customer_email, customer_address, total_amount) VALUES (?, ?, ?, ?)";
        KeyHolder keyHolder = new GeneratedKeyHolder();

        jdbcTemplate.update(conn -> {
            PreparedStatement ps = conn.prepareStatement(sql, new String[] {"ID"});
            ps.setString(1, order.getCustomerName());
            ps.setString(2, order.getCustomerEmail());
            ps.setString(3, order.getCustomerAddress());
            ps.setDouble(4, order.getTotalAmount());
            return ps;
        }, keyHolder);

        return keyHolder.getKey().intValue();
    }

    public void saveItems(List<OrderItem> items) {
        String sql = "INSERT INTO order_items (order_id, product_id, product_name, quantity, price) VALUES (?, ?, ?, ?, ?)";
        for (OrderItem item : items) {
            jdbcTemplate.update(sql, item.getOrderId(), item.getProductId(),
                item.getProductName(), item.getQuantity(), item.getPrice());
        }
    }

    public Order findById(int id) {
        List<Order> orders = jdbcTemplate.query(
            "SELECT * FROM orders WHERE id = ?",
            (rs, rowNum) -> {
                Order o = new Order();
                o.setId(rs.getInt("id"));
                o.setCustomerName(rs.getString("customer_name"));
                o.setCustomerEmail(rs.getString("customer_email"));
                o.setCustomerAddress(rs.getString("customer_address"));
                o.setTotalAmount(rs.getDouble("total_amount"));
                o.setOrderDate(rs.getString("order_date"));
                o.setStatus(rs.getString("status"));
                return o;
            }, id);
        return orders.isEmpty() ? null : orders.get(0);
    }
}
