package com.craverush.controller;

import com.craverush.constants.AppConstants;
import com.craverush.entity.Admin;
import com.craverush.entity.Restaurant;
import com.craverush.entity.FoodItem;
import com.craverush.entity.Order;
import com.craverush.service.AdminService;
import com.craverush.service.RestaurantService;
import com.craverush.service.OrderService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private AdminService adminService;

    @Autowired
    private RestaurantService restaurantService;

    @Autowired
    private OrderService orderService;

    @GetMapping("/login")
    public String showLogin(HttpSession session) {
        if (session.getAttribute(AppConstants.SESSION_ADMIN) != null) {
            return "redirect:/admin/dashboard";
        }
        return "admin/admin-login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String email,
                        @RequestParam String password,
                        HttpSession session,
                        Model model) {
        Admin admin = adminService.login(email, password);
        if (admin != null) {
            session.setAttribute(AppConstants.SESSION_ADMIN, admin);
            return "redirect:/admin/dashboard";
        }
        model.addAttribute("error", "Invalid email/username or password.");
        return "admin/admin-login";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.removeAttribute(AppConstants.SESSION_ADMIN);
        return "redirect:/admin/login";
    }

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        Map<String, Long> stats = adminService.getDashboardStats();
        model.addAllAttributes(stats);
        return "admin/admin-dashboard";
    }

    @GetMapping("/restaurants")
    public String listRestaurants(@RequestParam(required = false) String action,
                                  @RequestParam(required = false) Long id,
                                  Model model) {
        if ("edit".equals(action) && id != null) {
            Restaurant restaurant = restaurantService.getRestaurantById(id);
            model.addAttribute("restaurant", restaurant);
        }

        List<Restaurant> list = restaurantService.getAllRestaurants();
        model.addAttribute("restaurants", list);
        return "admin/admin-restaurants";
    }

    @PostMapping("/restaurants")
    public String manageRestaurants(@RequestParam(required = false) String action,
                                    @RequestParam(required = false) Long restaurantId,
                                    @RequestParam(required = false) String name,
                                    @RequestParam(required = false) String ownerName,
                                    @RequestParam(required = false) String email,
                                    @RequestParam(required = false) String phone,
                                    @RequestParam(required = false) String address,
                                    @RequestParam(required = false) String city,
                                    @RequestParam(required = false) String pincode,
                                    @RequestParam(required = false) String area,
                                    @RequestParam(required = false) String cuisineType,
                                    @RequestParam(required = false) String imageUrl,
                                    @RequestParam(required = false) Double rating,
                                    @RequestParam(required = false) Integer deliveryTime,
                                    @RequestParam(required = false) Double minOrder,
                                    @RequestParam(required = false) String isVeg,
                                    @RequestParam(required = false) Boolean isActive,
                                    @RequestParam(required = false) Long id,
                                    RedirectAttributes redirectAttributes) {

        if (action == null) {
            return "redirect:/admin/restaurants";
        }

        switch (action) {
            case "add":
            case "update": {
                Restaurant r = new Restaurant();
                if (restaurantId != null) {
                    r.setRestaurantId(restaurantId);
                }
                r.setName(name);
                r.setOwnerName(ownerName != null ? ownerName : "Owner");
                r.setEmail(email);
                r.setPhone(phone);
                r.setAddress(address);
                r.setCity(city != null ? city : "Bangalore");
                r.setPincode(pincode);
                r.setArea(area != null ? area : "Koramangala");
                r.setCuisineType(cuisineType);
                r.setRating(BigDecimal.valueOf(rating != null ? rating : 0.0));
                r.setDeliveryTime(deliveryTime != null ? deliveryTime : 30);
                r.setMinOrder(BigDecimal.valueOf(minOrder != null ? minOrder : 100.00));
                r.setVeg("on".equals(isVeg) || "true".equals(isVeg));

                if ("add".equals(action)) {
                    restaurantService.addRestaurant(r, imageUrl);
                    redirectAttributes.addFlashAttribute("success", "Restaurant added successfully!");
                } else {
                    restaurantService.updateRestaurant(r, imageUrl);
                    redirectAttributes.addFlashAttribute("success", "Restaurant updated successfully!");
                }
                break;
            }
            case "delete": {
                if (id != null) {
                    restaurantService.deleteRestaurant(id);
                    redirectAttributes.addFlashAttribute("success", "Restaurant deleted successfully!");
                }
                break;
            }
            case "toggle": {
                if (id != null && isActive != null) {
                    restaurantService.toggleActive(id, isActive);
                }
                break;
            }
        }

        return "redirect:/admin/restaurants";
    }

    @GetMapping("/menu")
    public String listMenu(@RequestParam(required = false) Long restaurantId,
                           @RequestParam(required = false) String action,
                           @RequestParam(required = false) Long itemId,
                           Model model) {
        List<Restaurant> restaurants = restaurantService.getAllRestaurants();
        model.addAttribute("restaurants", restaurants);

        if (restaurantId != null) {
            List<FoodItem> menuItems = restaurantService.getAllMenuByRestaurant(restaurantId);
            Restaurant selected = restaurantService.getRestaurantById(restaurantId);
            model.addAttribute("menuItems", menuItems);
            model.addAttribute("selectedRestaurantId", restaurantId);
            model.addAttribute("selectedRestaurant", selected);
        }

        if ("edit".equals(action) && itemId != null) {
            FoodItem editItem = restaurantService.getFoodItemById(itemId);
            model.addAttribute("editItem", editItem);
        }

        return "admin/admin-menu";
    }

    @PostMapping("/menu")
    public String manageMenu(@RequestParam(required = false) String action,
                             @RequestParam Long restaurantId,
                             @RequestParam(required = false) Long itemId,
                             @RequestParam(required = false) String name,
                             @RequestParam(required = false) String description,
                             @RequestParam(required = false) Double price,
                             @RequestParam(required = false) String category,
                             @RequestParam(required = false) String imageUrl,
                             @RequestParam(required = false) String isVeg,
                             @RequestParam(required = false) String isAvailable,
                             @RequestParam(required = false) String isBestseller,
                             RedirectAttributes redirectAttributes) {

        if (action == null) {
            return "redirect:/admin/menu?restaurantId=" + restaurantId;
        }

        Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);
        if (restaurant == null) {
            return "redirect:/admin/menu";
        }

        switch (action) {
            case "add":
            case "update": {
                FoodItem item = new FoodItem();
                if (itemId != null) {
                    item.setFoodId(itemId);
                }
                item.setRestaurant(restaurant);
                item.setName(name);
                item.setDescription(description);
                item.setPrice(BigDecimal.valueOf(price != null ? price : 0.0));
                item.setImageUrl(imageUrl);
                item.setVeg("on".equals(isVeg) || "true".equals(isVeg));
                item.setAvailable(!"off".equals(isAvailable));
                item.setRating("on".equals(isBestseller) || "true".equals(isBestseller) ? BigDecimal.valueOf(4.8) : BigDecimal.valueOf(0.0));

                if ("add".equals(action)) {
                    restaurantService.addMenuItem(item, category);
                    redirectAttributes.addFlashAttribute("success", "Menu item added successfully!");
                } else {
                    restaurantService.updateMenuItem(item, category);
                    redirectAttributes.addFlashAttribute("success", "Menu item updated successfully!");
                }
                break;
            }
            case "delete": {
                if (itemId != null) {
                    restaurantService.deleteMenuItem(itemId);
                    redirectAttributes.addFlashAttribute("success", "Menu item deleted successfully!");
                }
                break;
            }
            case "toggleAvailability": {
                if (itemId != null && isAvailable != null) {
                    restaurantService.toggleAvailability(itemId, "true".equals(isAvailable));
                }
                break;
            }
        }

        return "redirect:/admin/menu?restaurantId=" + restaurantId;
    }

    @GetMapping("/orders")
    public String listOrders(Model model) {
        List<Order> orders = orderService.getAllOrders();
        model.addAttribute("orders", orders);
        return "admin/admin-orders";
    }

    @PostMapping("/orders")
    public String updateOrderStatus(@RequestParam Long orderId,
                                    @RequestParam String status,
                                    RedirectAttributes redirectAttributes) {
        boolean success = orderService.updateOrderStatus(orderId, status);
        if (success) {
            redirectAttributes.addFlashAttribute("success", "Order status updated successfully!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Failed to update order status.");
        }
        return "redirect:/admin/orders";
    }
}
