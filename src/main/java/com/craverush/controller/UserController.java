package com.craverush.controller;

import com.craverush.constants.AppConstants;
import com.craverush.entity.User;
import com.craverush.entity.UserAddress;
import com.craverush.entity.Order;
import com.craverush.entity.Favorite;
import com.craverush.service.UserService;
import com.craverush.service.CartService;
import com.craverush.service.OrderService;
import com.craverush.service.FavoriteService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.util.List;

@Controller
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private CartService cartService;

    @Autowired
    private OrderService orderService;

    @Autowired
    private FavoriteService favoriteService;

    @GetMapping("/login")
    public String showLoginForm(HttpSession session) {
        if (session.getAttribute(AppConstants.SESSION_USER) != null) {
            return "redirect:/home";
        }
        return "user/login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String email,
                        @RequestParam String password,
                        HttpSession session,
                        Model model) {
        User user = userService.login(email, password);
        if (user != null) {
            session.setAttribute(AppConstants.SESSION_USER, user);
            session.setAttribute(AppConstants.SESSION_CART_COUNT, cartService.getCartCount(user));
            return "redirect:/home";
        }
        model.addAttribute("error", "Invalid email or password.");
        return "user/login";
    }

    @GetMapping("/register")
    public String showRegisterForm(HttpSession session) {
        if (session.getAttribute(AppConstants.SESSION_USER) != null) {
            return "redirect:/home";
        }
        return "user/register";
    }

    @PostMapping("/register")
    public String register(@RequestParam String fullName,
                           @RequestParam String email,
                           @RequestParam String phone,
                           @RequestParam String password,
                           Model model,
                           RedirectAttributes redirectAttributes) {
        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setPassword(password);

        if (userService.register(user)) {
            redirectAttributes.addFlashAttribute("success", "Registration successful. Please login.");
            return "redirect:/login";
        } else {
            model.addAttribute("error", "Email is already registered.");
            return "user/register";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/home";
    }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute(AppConstants.SESSION_USER);
        if (user == null) {
            return "redirect:/login";
        }

        // Refresh user details from DB
        user = userService.getUserById(user.getUserId());
        session.setAttribute(AppConstants.SESSION_USER, user);

        List<UserAddress> addresses = userService.getAddressesByUser(user);
        List<Order> orders = orderService.getOrdersByUser(user);
        List<Favorite> favorites = favoriteService.getFavoritesByUser(user);

        model.addAttribute("addresses", addresses);
        model.addAttribute("orders", orders);
        model.addAttribute("favorites", favorites);
        model.addAttribute("user", user);

        return "user/dashboard";
    }

    @PostMapping("/profile/update")
    public String updateProfile(@RequestParam String fullName,
                                @RequestParam String phone,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute(AppConstants.SESSION_USER);
        if (user == null) return "redirect:/login";

        user.setFullName(fullName);
        user.setPhone(phone);

        if (userService.updateProfile(user)) {
            redirectAttributes.addFlashAttribute("profileSuccess", "Profile updated successfully.");
        } else {
            redirectAttributes.addFlashAttribute("profileError", "Failed to update profile.");
        }
        return "redirect:/dashboard";
    }

    @PostMapping("/address/add")
    public String addAddress(@RequestParam String addressType,
                             @RequestParam String houseNo,
                             @RequestParam String street,
                             @RequestParam String city,
                             @RequestParam String state,
                             @RequestParam String pincode,
                             @RequestParam(required = false) Double latitude,
                             @RequestParam(required = false) Double longitude,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute(AppConstants.SESSION_USER);
        if (user == null) return "redirect:/login";

        UserAddress address = new UserAddress();
        address.setUser(user);
        address.setAddressType(addressType);
        address.setHouseNo(houseNo);
        address.setStreet(street);
        address.setCity(city);
        address.setState(state);
        address.setPincode(pincode);
        if (latitude != null) address.setLatitude(BigDecimal.valueOf(latitude));
        if (longitude != null) address.setLongitude(BigDecimal.valueOf(longitude));

        userService.saveAddress(address);
        redirectAttributes.addFlashAttribute("addressSuccess", "Address added successfully.");
        return "redirect:/dashboard";
    }

    @GetMapping("/address/delete")
    public String deleteAddress(@RequestParam Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute(AppConstants.SESSION_USER);
        if (user == null) return "redirect:/login";

        UserAddress addr = userService.getAddressById(id);
        if (addr != null && addr.getUser().getUserId().equals(user.getUserId())) {
            userService.deleteAddress(id);
            redirectAttributes.addFlashAttribute("addressSuccess", "Address deleted successfully.");
        }
        return "redirect:/dashboard";
    }
}
