package com.craverush.controller;

import com.craverush.constants.AppConstants;
import com.craverush.entity.Restaurant;
import com.craverush.entity.User;
import com.craverush.service.RestaurantService;
import com.craverush.service.FavoriteService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/favorite")
public class FavoriteController {

    @Autowired
    private FavoriteService favoriteService;

    @Autowired
    private RestaurantService restaurantService;

    @PostMapping("/toggle")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> toggleFavorite(@RequestParam Long restaurantId, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User user = (User) session.getAttribute(AppConstants.SESSION_USER);
        if (user == null) {
            response.put("error", "Please login first.");
            return ResponseEntity.status(401).body(response);
        }

        Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);
        if (restaurant == null) {
            response.put("error", "Restaurant not found.");
            return ResponseEntity.badRequest().body(response);
        }

        boolean isFavorite = favoriteService.toggleFavorite(user, restaurant);
        response.put("success", true);
        response.put("isFavorite", isFavorite);

        return ResponseEntity.ok(response);
    }
}
