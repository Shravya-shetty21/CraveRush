package com.craverush.controller;

import com.craverush.entity.Restaurant;
import com.craverush.service.RestaurantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Controller
public class HomeController {

    @Autowired
    private RestaurantService restaurantService;

    @GetMapping({"/", "/home"})
    public String home(Model model) {
        List<Restaurant> restaurants = restaurantService.getAllActiveRestaurants();
        model.addAttribute("restaurants", restaurants);

        // Top rated restaurants (sorted by rating descending, top 3)
        List<Restaurant> topRated = restaurants.stream()
                .sorted(Comparator.comparing(Restaurant::getRating).reversed())
                .limit(3)
                .collect(Collectors.toList());
        model.addAttribute("topRatedRestaurants", topRated);

        return "user/home";
    }

    @GetMapping("/offers")
    public String offers() {
        return "user/offers";
    }

    @GetMapping("/contact")
    public String contact() {
        return "user/contact";
    }

    @GetMapping("/help")
    public String help() {
        return "user/help";
    }

    @GetMapping("/nearby")
    public String nearby(Model model) {
        model.addAttribute("restaurants", restaurantService.getAllActiveRestaurants());
        return "user/nearby";
    }

    @GetMapping("/deals")
    public String deals(Model model) {
        model.addAttribute("restaurants", restaurantService.getAllActiveRestaurants());
        return "user/deals";
    }

    @GetMapping("/top-rated")
    public String topRated(Model model) {
        List<Restaurant> topRated = restaurantService.getAllActiveRestaurants().stream()
                .sorted(Comparator.comparing(Restaurant::getRating).reversed())
                .collect(Collectors.toList());
        model.addAttribute("restaurants", topRated);
        return "user/top-rated";
    }

    @GetMapping("/terms")
    public String terms() {
        return "user/terms";
    }

    @GetMapping("/privacy")
    public String privacy() {
        return "user/privacy";
    }
}
