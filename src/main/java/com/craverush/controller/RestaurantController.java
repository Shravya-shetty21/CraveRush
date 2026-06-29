package com.craverush.controller;

import com.craverush.constants.AppConstants;
import com.craverush.entity.Restaurant;
import com.craverush.entity.FoodItem;
import com.craverush.entity.Review;
import com.craverush.entity.User;
import com.craverush.service.RestaurantService;
import com.craverush.service.ReviewService;
import com.craverush.service.FavoriteService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.stream.Collectors;

@Controller
public class RestaurantController {

    @Autowired
    private RestaurantService restaurantService;

    @Autowired
    private ReviewService reviewService;

    @Autowired
    private FavoriteService favoriteService;

    @GetMapping("/restaurants")
    public String listRestaurants(@RequestParam(required = false) String location,
                                  @RequestParam(required = false) String cuisine,
                                  @RequestParam(required = false) String search,
                                  @RequestParam(required = false) String sort,
                                  @RequestParam(required = false) Boolean vegOnly,
                                  HttpSession session,
                                  Model model) {
        
        // Handle Location Filter
        if (location != null && !location.trim().isEmpty()) {
            session.setAttribute("selectedLocation", location.trim());
        }
        
        String selectedLocation = (String) session.getAttribute("selectedLocation");
        if (selectedLocation == null) {
            // Default location
            selectedLocation = "Koramangala";
            session.setAttribute("selectedLocation", selectedLocation);
        }

        List<Restaurant> list = restaurantService.getRestaurants(selectedLocation, cuisine, search, sort, vegOnly);
        
        model.addAttribute("restaurants", list);
        model.addAttribute("cuisineFilter", cuisine);
        model.addAttribute("searchQuery", search);
        model.addAttribute("sortFilter", sort);
        model.addAttribute("vegOnlyFilter", vegOnly);
        
        return "user/restaurants";
    }

    @GetMapping("/restaurant")
    public String restaurantDetail(@RequestParam Long id, HttpSession session, Model model) {
        Restaurant restaurant = restaurantService.getRestaurantById(id);
        if (restaurant == null) {
            return "redirect:/restaurants";
        }

        List<FoodItem> menuItems = restaurantService.getMenuByRestaurant(restaurant);
        List<String> categories = menuItems.stream()
                .map(FoodItem::getCategoryName)
                .distinct()
                .collect(Collectors.toList());

        List<Review> reviews = reviewService.getReviewsForRestaurant(restaurant);

        // Check if this restaurant is favorited by the logged in user
        User user = (User) session.getAttribute(AppConstants.SESSION_USER);
        boolean isFavorite = favoriteService.isFavorite(user, restaurant);

        model.addAttribute("restaurant", restaurant);
        model.addAttribute("menuItems", menuItems);
        model.addAttribute("categories", categories);
        model.addAttribute("reviews", reviews);
        model.addAttribute("isFavorite", isFavorite);

        return "user/restaurant-detail";
    }
}
