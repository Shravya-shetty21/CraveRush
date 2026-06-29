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
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;

@Controller
@RequestMapping("/checkout")
public class CheckoutController {

    @Autowired
    private CartService cartService;

    @Autowired
    private UserService userService;

    @Autowired
    private OrderService orderService;

    @GetMapping
    public String showCheckout(HttpSession session, Model model) {
        User user = (User) session.getAttribute(AppConstants.SESSION_USER);
        if (user == null) {
            return "redirect:/login";
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
        BigDecimal grandTotal = subtotal.add(deliveryFee).add(platformFee).add(tax);

        List<UserAddress> addresses = userService.getAddressesByUser(user);

        model.addAttribute("cartItems", cartItems);
        model.addAttribute("subtotal", subtotal);
        model.addAttribute("deliveryFee", deliveryFee);
        model.addAttribute("platformFee", platformFee);
        model.addAttribute("tax", tax);
        model.addAttribute("grandTotal", grandTotal);
        model.addAttribute("addresses", addresses);

        return "user/checkout";
    }

    @PostMapping
    public String placeOrder(@RequestParam String deliveryAddress,
                             @RequestParam String paymentMethod,
                             @RequestParam(required = false) String couponCode,
                             @RequestParam(required = false) String notes,
                             @RequestParam(required = false) Long addressId,
                             HttpSession session,
                             RedirectAttributes redirectAttributes,
                             Model model) {
        User user = (User) session.getAttribute(AppConstants.SESSION_USER);
        if (user == null) {
            return "redirect:/login";
        }

        if (deliveryAddress == null || deliveryAddress.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Delivery address is required.");
            return "redirect:/checkout";
        }

        UserAddress address = null;
        if (addressId != null) {
            address = userService.getAddressById(addressId);
        }

        if (address == null) {
            // Create a temp address object to pass user details
            address = new UserAddress();
            address.setUser(user);
            address.setHouseNo("");
            address.setStreet(deliveryAddress.trim());
            address.setCity("Bangalore");
            address.setState("Karnataka");
            address.setPincode("560001");
            address = userService.saveAddress(address);
        }

        // If payment method is ONLINE, redirect to simulated payment portal instead of placing order immediately
        if ("ONLINE".equalsIgnoreCase(paymentMethod)) {
            session.setAttribute("pendingCheckoutAddressId", address.getAddressId());
            session.setAttribute("pendingCheckoutNotes", notes);
            session.setAttribute("pendingCheckoutCoupon", couponCode);
            return "redirect:/payment";
        }

        // Otherwise place order directly (for COD)
        Order order = orderService.placeOrder(user, address, "COD", couponCode, notes);
        if (order != null) {
            session.setAttribute(AppConstants.SESSION_CART_COUNT, 0);
            return "redirect:/order/track/" + order.getOrderId();
        } else {
            redirectAttributes.addFlashAttribute("error", "Failed to place order. Please try again.");
            return "redirect:/checkout";
        }
    }
}
