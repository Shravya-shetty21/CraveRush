package com.craverush.controller;

import com.craverush.constants.AppConstants;
import com.craverush.entity.CartItem;
import com.craverush.entity.User;
import com.craverush.service.CartService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/cart")
public class CartController {

    @Autowired
    private CartService cartService;

    @GetMapping
    public String viewCart(HttpSession session, Model model) {
        User user = (User) session.getAttribute(AppConstants.SESSION_USER);
        if (user == null) {
            return "redirect:/login";
        }

        List<CartItem> cartItems = cartService.getCartItems(user);
        BigDecimal subtotal = BigDecimal.ZERO;
        for (CartItem ci : cartItems) {
            subtotal = subtotal.add(ci.getTotalPrice());
        }

        BigDecimal deliveryFee = cartItems.isEmpty() ? BigDecimal.ZERO : BigDecimal.valueOf(AppConstants.DELIVERY_FEE);
        BigDecimal platformFee = cartItems.isEmpty() ? BigDecimal.ZERO : BigDecimal.valueOf(5.00); // flat 5
        BigDecimal tax = subtotal.multiply(BigDecimal.valueOf(AppConstants.TAX_RATE))
                .setScale(2, RoundingMode.HALF_UP);
        BigDecimal grandTotal = subtotal.add(deliveryFee).add(platformFee).add(tax);

        model.addAttribute("cartItems", cartItems);
        model.addAttribute("subtotal", subtotal);
        model.addAttribute("deliveryFee", deliveryFee);
        model.addAttribute("platformFee", platformFee);
        model.addAttribute("tax", tax);
        model.addAttribute("grandTotal", grandTotal);

        return "user/cart";
    }

    @PostMapping
    @ResponseBody
    public ResponseEntity<Map<String, Object>> handleCartAction(@RequestParam(required = false) String action,
                                                               @RequestParam(required = false) Long itemId,
                                                               @RequestParam(required = false) Long restaurantId,
                                                               @RequestParam(required = false) Integer quantity,
                                                               @RequestParam(required = false) Long cartId, // maps to cartItemId
                                                               HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User user = (User) session.getAttribute(AppConstants.SESSION_USER);
        if (user == null) {
            response.put("error", "Please login first.");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }

        if (action == null) {
            response.put("error", "Invalid action.");
            return ResponseEntity.badRequest().body(response);
        }

        switch (action) {
            case "add": {
                int qty = quantity != null ? quantity : 1;
                boolean success = cartService.addToCart(user, itemId, restaurantId, qty);
                if (success) {
                    int count = cartService.getCartCount(user);
                    session.setAttribute(AppConstants.SESSION_CART_COUNT, count);
                    response.put("success", true);
                    response.put("cartCount", count);
                } else {
                    response.put("success", false);
                    response.put("conflict", true);
                    response.put("message", "You have items from another restaurant in your cart. Clear cart to add this item?");
                }
                break;
            }
            case "clearAndAdd": {
                int qty = quantity != null ? quantity : 1;
                boolean success = cartService.clearAndAdd(user, itemId, restaurantId, qty);
                int count = cartService.getCartCount(user);
                session.setAttribute(AppConstants.SESSION_CART_COUNT, count);
                response.put("success", success);
                response.put("cartCount", count);
                break;
            }
            case "update": {
                if (cartId == null || quantity == null) {
                    response.put("error", "Missing parameters.");
                    return ResponseEntity.badRequest().body(response);
                }
                cartService.updateQuantity(cartId, quantity);
                int count = cartService.getCartCount(user);
                session.setAttribute(AppConstants.SESSION_CART_COUNT, count);
                response.put("success", true);
                response.put("cartCount", count);
                break;
            }
            case "remove": {
                if (cartId == null) {
                    response.put("error", "Missing parameters.");
                    return ResponseEntity.badRequest().body(response);
                }
                cartService.removeItem(cartId);
                int count = cartService.getCartCount(user);
                session.setAttribute(AppConstants.SESSION_CART_COUNT, count);
                response.put("success", true);
                response.put("cartCount", count);
                break;
            }
            case "clear": {
                cartService.clearCart(user);
                session.setAttribute(AppConstants.SESSION_CART_COUNT, 0);
                response.put("success", true);
                response.put("cartCount", 0);
                break;
            }
            default:
                response.put("error", "Invalid action.");
                return ResponseEntity.badRequest().body(response);
        }

        return ResponseEntity.ok(response);
    }
}
