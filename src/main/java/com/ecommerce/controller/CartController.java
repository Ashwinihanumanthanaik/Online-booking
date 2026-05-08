package com.ecommerce.controller;

import com.ecommerce.model.Order;
import com.ecommerce.model.OrderItem;
import com.ecommerce.service.OrderService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Controller
public class CartController {

    @Autowired
    private OrderService orderService;

    // Cart page (cart data lives in LocalStorage on frontend)
    @GetMapping("/cart")
    public String cartPage() {
        return "cart";
    }

    // Checkout page
    @GetMapping("/checkout")
    public String checkoutPage() {
        return "checkout";
    }

    // Process checkout (POST from frontend)
    @PostMapping("/api/checkout")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> processCheckout(@RequestBody Map<String, Object> payload) {
        try {
            // Extract customer info
            Order order = new Order();
            order.setCustomerName(String.valueOf(payload.get("name")));
            order.setCustomerEmail(String.valueOf(payload.get("email")));
            order.setCustomerAddress(String.valueOf(payload.get("address")));
            order.setTotalAmount(Double.parseDouble(payload.get("total").toString()));

            // Extract cart items
            List<Map<String, Object>> cartItems = (List<Map<String, Object>>) payload.get("items");
            List<OrderItem> orderItems = new ArrayList<>();
            for (Map<String, Object> item : cartItems) {
                OrderItem oi = new OrderItem();
                // Use a more robust way to parse numbers that might be Doubles or Integers
                oi.setProductId(Double.valueOf(item.get("id").toString()).intValue());
                oi.setProductName(String.valueOf(item.get("name")));
                oi.setQuantity(Double.valueOf(item.get("quantity").toString()).intValue());
                oi.setPrice(Double.parseDouble(item.get("price").toString()));
                orderItems.add(oi);
            }

            int orderId = orderService.placeOrder(order, orderItems);

            return ResponseEntity.ok(Map.of(
                "success", true,
                "orderId", orderId,
                "message", "Order placed successfully!"
            ));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", "Failed to place order: " + e.getMessage()
            ));
        }
    }

    // Order confirmation page
    @GetMapping("/order-confirmation")
    public String orderConfirmation(@RequestParam("orderId") int orderId, Model model) {
        Order order = orderService.getOrderById(orderId);
        model.addAttribute("order", order);
        return "order-confirmation";
    }
}
