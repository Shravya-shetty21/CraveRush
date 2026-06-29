package com.craverush.controller;

import com.craverush.constants.AppConstants;
import com.craverush.entity.CartItem;
import com.craverush.entity.User;
import com.craverush.entity.UserAddress;
import com.craverush.entity.Order;
import com.craverush.service.CartService;
import com.craverush.service.OrderService;
import com.craverush.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;

@Controller
public class PaymentController {

    @Autowired
    private CartService cartService;

    @Autowired
    private UserService userService;

    @Autowired
    private OrderService orderService;

    @GetMapping("/payment")
    public String showPaymentPortal(HttpSession session, Model model) {
        User user = (User) session.getAttribute(AppConstants.SESSION_USER);
        if (user == null) {
            return "redirect:/login";
        }

        Long addressId = (Long) session.getAttribute("pendingCheckoutAddressId");
        if (addressId == null) {
            return "redirect:/checkout";
        }

        List<CartItem> cartItems = cartService.getCartItems(user);
        if (cartItems.isEmpty()) {
            return "redirect:/cart";
        }

        BigDecimal subtotal = BigDecimal.ZERO;
        for (CartItem ci : cartItems) {
            subtotal = subtotal.add(ci.getTotalPrice());
        }

        BigDecimal deliveryFee = BigDecimal.valueOf(AppConstants.DELIVERY_FEE);
        BigDecimal platformFee = BigDecimal.valueOf(5.00);
        BigDecimal tax = subtotal.multiply(BigDecimal.valueOf(AppConstants.TAX_RATE))
                .setScale(2, RoundingMode.HALF_UP);
        
        String coupon = (String) session.getAttribute("pendingCheckoutCoupon");
        BigDecimal discount = BigDecimal.ZERO;
        if (coupon != null && !coupon.trim().isEmpty()) {
            String code = coupon.trim().toUpperCase();
            if ("CRAVERUSH50".equals(code) || "CRAVE50".equals(code)) {
                discount = subtotal.multiply(BigDecimal.valueOf(0.50)).setScale(2, RoundingMode.HALF_UP);
                if (discount.compareTo(BigDecimal.valueOf(100)) > 0) {
                    discount = BigDecimal.valueOf(100.00);
                }
            } else if ("FREE50".equals(code)) {
                discount = BigDecimal.valueOf(50.00);
            } else if ("HDFC10".equals(code)) {
                discount = subtotal.multiply(BigDecimal.valueOf(0.10)).setScale(2, RoundingMode.HALF_UP);
                if (discount.compareTo(BigDecimal.valueOf(150)) > 0) {
                    discount = BigDecimal.valueOf(150.00);
                }
            }
        }

        BigDecimal grandTotal = subtotal.add(deliveryFee).add(platformFee).add(tax).subtract(discount);
        if (grandTotal.compareTo(BigDecimal.ZERO) < 0) {
            grandTotal = BigDecimal.ZERO;
        }

        model.addAttribute("grandTotal", grandTotal);
        return "user/payment";
    }

    @PostMapping("/payment/process")
    public String processPayment(@RequestParam String paymentMethod,
                                 @RequestParam(required = false) String cardNumber,
                                 @RequestParam(required = false) String upiId,
                                 @RequestParam(required = false) String simulateStatus,
                                 HttpSession session,
                                 Model model) {
        User user = (User) session.getAttribute(AppConstants.SESSION_USER);
        if (user == null) {
            return "redirect:/login";
        }

        Long addressId = (Long) session.getAttribute("pendingCheckoutAddressId");
        if (addressId == null) {
            return "redirect:/checkout";
        }

        UserAddress address = userService.getAddressById(addressId);
        String notes = (String) session.getAttribute("pendingCheckoutNotes");
        String coupon = (String) session.getAttribute("pendingCheckoutCoupon");

        // Simulate transaction result
        if ("fail".equalsIgnoreCase(simulateStatus) || (cardNumber != null && cardNumber.startsWith("1111"))) {
            return "redirect:/payment/failure";
        }

        // Create Order on successful payment
        Order order = orderService.placeOrder(user, address, paymentMethod, coupon, notes);
        if (order != null) {
            session.setAttribute(AppConstants.SESSION_CART_COUNT, 0);
            // Clear checkout variables
            session.removeAttribute("pendingCheckoutAddressId");
            session.removeAttribute("pendingCheckoutNotes");
            session.removeAttribute("pendingCheckoutCoupon");

            return "redirect:/payment/success?orderId=" + order.getOrderId();
        } else {
            return "redirect:/payment/failure";
        }
    }

    @GetMapping("/payment/success")
    public String paymentSuccess(@RequestParam Long orderId, Model model) {
        model.addAttribute("orderId", orderId);
        return "user/payment-success";
    }

    @GetMapping("/payment/failure")
    public String paymentFailure() {
        return "user/payment-failure";
    }
}
