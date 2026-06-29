package com.craverush.service;

import com.craverush.entity.Restaurant;
import com.craverush.entity.RestaurantImage;
import com.craverush.entity.FoodItem;
import com.craverush.entity.Category;
import com.craverush.repository.RestaurantRepository;
import com.craverush.repository.FoodItemRepository;
import com.craverush.repository.CategoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.stream.Collectors;

@Service
@Transactional
public class RestaurantService {

    @Autowired
    private RestaurantRepository restaurantRepository;

    @Autowired
    private FoodItemRepository foodItemRepository;

    @Autowired
    private CategoryRepository categoryRepository;

    public List<Restaurant> getAllActiveRestaurants() {
        return restaurantRepository.findByStatus("ACTIVE");
    }

    public Restaurant getRestaurantById(Long restaurantId) {
        return restaurantRepository.findById(restaurantId).orElse(null);
    }

    public List<Restaurant> getRestaurants(String area, String cuisine, String search, String sort, Boolean vegOnly) {
        List<Restaurant> list;
        if (search != null && !search.trim().isEmpty()) {
            list = restaurantRepository.searchRestaurants(search.trim());
        } else if (area != null && !area.trim().isEmpty() && !"All".equalsIgnoreCase(area)) {
            list = restaurantRepository.findByAreaAndStatus(area, "ACTIVE");
        } else {
            list = restaurantRepository.findByStatus("ACTIVE");
        }

        // Filter by Veg Only
        if (vegOnly != null && vegOnly) {
            list = list.stream().filter(Restaurant::isVeg).collect(Collectors.toList());
        }

        // Filter by Cuisine
        if (cuisine != null && !cuisine.trim().isEmpty() && !"All".equalsIgnoreCase(cuisine)) {
            list = list.stream()
                    .filter(r -> r.getCuisineType() != null && r.getCuisineType().toLowerCase().contains(cuisine.toLowerCase()))
                    .collect(Collectors.toList());
        }

        // Sort results
        if (sort != null && !sort.trim().isEmpty()) {
            switch (sort) {
                case "deliveryTime":
                    list.sort(Comparator.comparingInt(Restaurant::getDeliveryTime));
                    break;
                case "rating":
                    list.sort((r1, r2) -> r2.getRating().compareTo(r1.getRating()));
                    break;
                case "minOrder":
                    list.sort(Comparator.comparing(Restaurant::getMinOrder));
                    break;
                case "costLowToHigh":
                    list.sort(Comparator.comparingInt(Restaurant::getPriceForTwo));
                    break;
                case "costHighToLow":
                    list.sort((r1, r2) -> r2.getPriceForTwo().compareTo(r1.getPriceForTwo()));
                    break;
                default:
                    // default sorting (by rating high to low)
                    list.sort((r1, r2) -> r2.getRating().compareTo(r1.getRating()));
                    break;
            }
        } else {
            // default sorting by rating
            list.sort((r1, r2) -> r2.getRating().compareTo(r1.getRating()));
        }

        return list;
    }

    public List<FoodItem> getMenuByRestaurant(Restaurant restaurant) {
        return foodItemRepository.findByRestaurant(restaurant);
    }

    public List<Category> getAllCategories() {
        return categoryRepository.findAll();
    }

    public FoodItem getFoodItemById(Long foodId) {
        return foodItemRepository.findById(foodId).orElse(null);
    }

    // --- Admin Operations ---

    public List<Restaurant> getAllRestaurants() {
        return restaurantRepository.findAll();
    }

    public void addRestaurant(Restaurant r, String imageUrl) {
        r = restaurantRepository.save(r);
        if (imageUrl != null && !imageUrl.trim().isEmpty()) {
            RestaurantImage img = new RestaurantImage(r, imageUrl.trim());
            r.getImages().add(img);
            restaurantRepository.save(r);
        }
    }

    public void updateRestaurant(Restaurant r, String imageUrl) {
        Restaurant existing = restaurantRepository.findById(r.getRestaurantId()).orElse(null);
        if (existing != null) {
            existing.setName(r.getName());
            existing.setCuisineType(r.getCuisineType());
            existing.setAddress(r.getAddress());
            existing.setCity(r.getCity());
            existing.setPincode(r.getPincode());
            existing.setPhone(r.getPhone());
            existing.setEmail(r.getEmail());
            existing.setRating(r.getRating());
            existing.setDeliveryTime(r.getDeliveryTime());
            existing.setMinOrder(r.getMinOrder());
            existing.setPriceForTwo(r.getPriceForTwo());
            existing.setVeg(r.isVeg());
            existing.setArea(r.getArea());

            if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                existing.getImages().clear();
                RestaurantImage img = new RestaurantImage(existing, imageUrl.trim());
                existing.getImages().add(img);
            }
            restaurantRepository.save(existing);
        }
    }

    public void deleteRestaurant(Long id) {
        restaurantRepository.deleteById(id);
    }

    public void toggleActive(Long id, boolean isActive) {
        Restaurant existing = restaurantRepository.findById(id).orElse(null);
        if (existing != null) {
            existing.setStatus(isActive ? "ACTIVE" : "INACTIVE");
            restaurantRepository.save(existing);
        }
    }

    public List<FoodItem> getAllMenuByRestaurant(Long restaurantId) {
        Restaurant r = getRestaurantById(restaurantId);
        if (r != null) {
            return foodItemRepository.findByRestaurant(r);
        }
        return new ArrayList<>();
    }

    public void addMenuItem(FoodItem item, String categoryName) {
        Category category = categoryRepository.findByCategoryName(categoryName)
                .orElseGet(() -> {
                    Category cat = new Category();
                    cat.setCategoryName(categoryName);
                    return categoryRepository.save(cat);
                });
        item.setCategory(category);
        foodItemRepository.save(item);
    }

    public void updateMenuItem(FoodItem item, String categoryName) {
        FoodItem existing = foodItemRepository.findById(item.getFoodId()).orElse(null);
        if (existing != null) {
            existing.setName(item.getName());
            existing.setDescription(item.getDescription());
            existing.setPrice(item.getPrice());
            existing.setImageUrl(item.getImageUrl());
            existing.setVeg(item.isVeg());
            existing.setAvailable(item.isAvailable());
            existing.setRating(item.getRating());

            Category category = categoryRepository.findByCategoryName(categoryName)
                    .orElseGet(() -> {
                        Category cat = new Category();
                        cat.setCategoryName(categoryName);
                        return categoryRepository.save(cat);
                    });
            existing.setCategory(category);
            foodItemRepository.save(existing);
        }
    }

    public void deleteMenuItem(Long id) {
        foodItemRepository.deleteById(id);
    }

    public void toggleAvailability(Long id, boolean isAvailable) {
        FoodItem existing = foodItemRepository.findById(id).orElse(null);
        if (existing != null) {
            existing.setAvailable(isAvailable);
            foodItemRepository.save(existing);
        }
    }
}
