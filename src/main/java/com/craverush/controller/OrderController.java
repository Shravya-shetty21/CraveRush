package com.craverush.controller;

import com.craverush.constants.AppConstants;
import com.craverush.entity.User;
import com.craverush.entity.Order;
import com.craverush.entity.OrderItem;
import com.craverush.service.OrderService;
import com.craverush.service.DeliveryService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class OrderController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private DeliveryService deliveryService;

    @GetMapping("/orders")
    public String viewOrders(@RequestParam(required = false) Long id, HttpSession session, Model model) {
        User user = (User) session.getAttribute(AppConstants.SESSION_USER);
        if (user == null) {
            return "redirect:/login";
        }

        if (id != null) {
            // Details page
            Order order = orderService.getOrderById(id);
            if (order == null || !order.getUser().getUserId().equals(user.getUserId())) {
                return "redirect:/orders";
            }
            model.addAttribute("order", order);
            model.addAttribute("orderItems", order.getItems());
            return "user/order-detail";
        } else {
            // List page
            List<Order> orders = orderService.getOrdersByUser(user);
            
            // To prevent JSP exceptions from accessing missing getter properties, we make sure properties exist.
            // In orders.jsp, it accesses order.itemCount. Let's add a transient method in Order or populate in a model wrapper if needed.
            // Wait, we can define a transient method in Order entity: getItemCount()!
            // Let's check: does our Order entity have getItemCount()? Let's check: we didn't add getItemCount() in Order.java!
            // Let's verify: does order.getItems().size() work? Yes, but in orders.jsp it uses: order.itemCount.
            // Let's add getItemCount() in Order.java to avoid any reflection/JSTL issues!
            
            model.addAttribute("orders", orders);
            return "user/orders";
        }
    }

    @GetMapping({"/track-order", "/order/track/{idPath}"})
    public String trackOrder(@RequestParam(required = false) Long id,
                             @PathVariable(required = false) Long idPath,
                             HttpSession session,
                             Model model) {
        User user = (User) session.getAttribute(AppConstants.SESSION_USER);
        if (user == null) {
            return "redirect:/login";
        }

        Long orderId = id != null ? id : idPath;
        if (orderId == null) {
            return "redirect:/orders";
        }

        Order order = orderService.getOrderById(orderId);
        if (order == null || !order.getUser().getUserId().equals(user.getUserId())) {
            return "redirect:/orders";
        }

        model.addAttribute("order", order);
        model.addAttribute("orderItems", order.getItems());
        return "user/track-order";
    }

    @PostMapping("/track-order")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateTrackingStatus(@RequestParam Long orderId,
                                                                   @RequestParam String status,
                                                                   HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User user = (User) session.getAttribute(AppConstants.SESSION_USER);
        if (user == null) {
            response.put("error", "Unauthorized");
            return ResponseEntity.status(401).body(response);
        }

        boolean success = orderService.updateOrderStatus(orderId, status);
        response.put("success", success);
        return ResponseEntity.ok(response);
    }

    // Live Tracking API Endpoint (returns simulated coordinates, distance, and ETA)
    @GetMapping("/api/track/{orderId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getLiveTrackingData(@PathVariable Long orderId, HttpSession session) {
        User user = (User) session.getAttribute(AppConstants.SESSION_USER);
        if (user == null) {
            return ResponseEntity.status(401).build();
        }

        Order order = orderService.getOrderById(orderId);
        if (order == null || !order.getUser().getUserId().equals(user.getUserId())) {
            return ResponseEntity.badRequest().build();
        }

        Map<String, Object> trackingData = deliveryService.getLiveTrackingData(order);
        return ResponseEntity.ok(trackingData);
    }
}
