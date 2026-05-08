package com.ecommerce.service;

import com.ecommerce.model.Order;
import com.ecommerce.model.OrderItem;
import com.ecommerce.repository.OrderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class OrderService {

    @Autowired
    private OrderRepository orderRepository;

    public int placeOrder(Order order, List<OrderItem> items) {
        int orderId = orderRepository.save(order);
        for (OrderItem item : items) {
            item.setOrderId(orderId);
        }
        orderRepository.saveItems(items);
        return orderId;
    }

    public Order getOrderById(int id) {
        return orderRepository.findById(id);
    }
}
