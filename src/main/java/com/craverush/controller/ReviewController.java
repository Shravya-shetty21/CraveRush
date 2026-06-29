package com.craverush.controller;

import com.craverush.constants.AppConstants;
import com.craverush.entity.Restaurant;
import com.craverush.entity.User;
import com.craverush.service.RestaurantService;
import com.craverush.service.ReviewService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/review")
public class ReviewController {

    @Autowired
    private ReviewService reviewService;

    @Autowired
    private RestaurantService restaurantService;

    @PostMapping("/add")
    public String addReview(@RequestParam Long restaurantId,
                            @RequestParam Integer rating,
                            @RequestParam String reviewText,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute(AppConstants.SESSION_USER);
        if (user == null) {
            return "redirect:/login";
        }

        Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);
        if (restaurant != null) {
            reviewService.addReview(user, restaurant, rating, reviewText);
            redirectAttributes.addFlashAttribute("reviewSuccess", "Review added successfully!");
        }

        return "redirect:/restaurant?id=" + restaurantId;
    }
}
