package com.craverush.service;

import com.craverush.entity.*;
import com.craverush.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class OrderService {

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private OrderItemRepository orderItemRepository;

    @Autowired
    private CartService cartService;

    @Autowired
    private PaymentRepository paymentRepository;

    @Autowired
    private DeliveryPartnerRepository deliveryPartnerRepository;

    @Autowired
    private DeliveryAssignmentRepository deliveryAssignmentRepository;

    public Order placeOrder(User user, UserAddress address, String paymentMethod, String couponCode, String notes) {
        List<CartItem> cartItems = cartService.getCartItems(user);
        if (cartItems == null || cartItems.isEmpty()) {
            return null;
        }

        Restaurant restaurant = cartItems.get(0).getFoodItem().getRestaurant();

        // Calculate subtotal
        BigDecimal subtotal = BigDecimal.ZERO;
        for (CartItem ci : cartItems) {
            subtotal = subtotal.add(ci.getTotalPrice());
        }

        // Calculations
        BigDecimal deliveryFee = BigDecimal.valueOf(40.00); // Flat 40 delivery
        BigDecimal platformFee = BigDecimal.valueOf(5.00); // Platform fee 5
        BigDecimal taxAmount = subtotal.multiply(BigDecimal.valueOf(0.05))
                .setScale(2, RoundingMode.HALF_UP); // 5% GST

        BigDecimal discount = BigDecimal.ZERO;
        if (couponCode != null && !couponCode.trim().isEmpty()) {
            String code = couponCode.trim().toUpperCase();
            if ("CRAVERUSH50".equals(code) || "CRAVE50".equals(code)) {
                // 50% discount up to 100
                discount = subtotal.multiply(BigDecimal.valueOf(0.50)).setScale(2, RoundingMode.HALF_UP);
                if (discount.compareTo(BigDecimal.valueOf(100)) > 0) {
                    discount = BigDecimal.valueOf(100.00);
                }
            } else if ("FREE50".equals(code)) {
                // Flat 50 off
                discount = BigDecimal.valueOf(50.00);
            } else if ("HDFC10".equals(code)) {
                // 10% discount up to 150
                discount = subtotal.multiply(BigDecimal.valueOf(0.10)).setScale(2, RoundingMode.HALF_UP);
                if (discount.compareTo(BigDecimal.valueOf(150)) > 0) {
                    discount = BigDecimal.valueOf(150.00);
                }
            }
        }

        BigDecimal grandTotal = subtotal.add(deliveryFee).add(platformFee).add(taxAmount).subtract(discount);
        if (grandTotal.compareTo(BigDecimal.ZERO) < 0) {
            grandTotal = BigDecimal.ZERO;
        }

        // Create Order
        Order order = new Order();
        order.setUser(user);
        order.setRestaurant(restaurant);
        order.setAddress(address);
        order.setTotalAmount(subtotal);
        order.setDeliveryFee(deliveryFee);
        order.setTaxAmount(taxAmount);
        order.setGrandTotal(grandTotal);
        order.setOrderStatus("PLACED");
        order.setDeliveryAddress(address != null ? address.getFullAddress() : "Address not provided");
        order.setNotes(notes);

        order = orderRepository.save(order);

        // Create Order Items
        List<OrderItem> orderItems = new ArrayList<>();
        for (CartItem ci : cartItems) {
            OrderItem oi = new OrderItem(order, ci.getFoodItem(), ci.getQuantity(), ci.getPrice());
            orderItems.add(oi);
        }
        orderItemRepository.saveAll(orderItems);
        order.setItems(orderItems);

        // Create Payment
        Payment payment = new Payment();
        payment.setOrder(order);
        payment.setAmount(grandTotal);
        payment.setPaymentMethod(paymentMethod != null ? paymentMethod : "COD");
        if ("COD".equalsIgnoreCase(paymentMethod)) {
            payment.setPaymentStatus("PENDING");
        } else {
            payment.setPaymentStatus("SUCCESSFUL");
            payment.setTransactionId("TXN" + System.currentTimeMillis());
        }
        paymentRepository.save(payment);

        // Clear user's cart
        cartService.clearCart(user);

        // Assign delivery partner
        assignDeliveryPartner(order);

        return order;
    }

    private void assignDeliveryPartner(Order order) {
        List<DeliveryPartner> available = deliveryPartnerRepository.findByStatus("AVAILABLE");
        DeliveryPartner rider = null;
        if (!available.isEmpty()) {
            rider = available.get(0);
        } else {
            // Create a mock delivery partner if none is available
            List<DeliveryPartner> all = deliveryPartnerRepository.findAll();
            if (!all.isEmpty()) {
                rider = all.get(0);
            } else {
                rider = new DeliveryPartner();
                rider.setFullName("Rahul Kumar");
                rider.setPhone("9876543210");
                rider.setVehicleNumber("KA-03-HA-1234");
                rider.setVehicleType("Two-Wheeler");
                rider.setStatus("BUSY");
                rider = deliveryPartnerRepository.save(rider);
            }
        }
        
        rider.setStatus("BUSY");
        deliveryPartnerRepository.save(rider);

        DeliveryAssignment assignment = new DeliveryAssignment();
        assignment.setOrder(order);
        assignment.setPartner(rider);
        assignment.setDeliveryStatus("ASSIGNED");
        deliveryAssignmentRepository.save(assignment);
    }

    public Order getOrderById(Long orderId) {
        return orderRepository.findById(orderId).orElse(null);
    }

    public List<Order> getOrdersByUser(User user) {
        return orderRepository.findByUserOrderByOrderDateDesc(user);
    }

    public List<Order> getAllOrders() {
        return orderRepository.findAllByOrderByOrderDateDesc();
    }

    public boolean updateOrderStatus(Long orderId, String status) {
        Optional<Order> optOrder = orderRepository.findById(orderId);
        if (optOrder.isPresent()) {
            Order order = optOrder.get();
            order.setOrderStatus(status);
            if ("DELIVERED".equalsIgnoreCase(status)) {
                order.setDeliveredAt(LocalDateTime.now());
                
                // Set rider to available again
                Optional<DeliveryAssignment> optAssign = deliveryAssignmentRepository.findByOrder(order);
                if (optAssign.isPresent()) {
                    DeliveryPartner rider = optAssign.get().getPartner();
                    rider.setStatus("AVAILABLE");
                    deliveryPartnerRepository.save(rider);
                    
                    DeliveryAssignment assign = optAssign.get();
                    assign.setDeliveryStatus("DELIVERED");
                    deliveryAssignmentRepository.save(assign);
                }
            }
            orderRepository.save(order);
            return true;
        }
        return false;
    }

    public Payment getPaymentByOrderId(Long orderId) {
        Optional<Order> optOrder = orderRepository.findById(orderId);
        if (optOrder.isPresent()) {
            return paymentRepository.findByOrder(optOrder.get()).orElse(null);
        }
        return null;
    }
}
