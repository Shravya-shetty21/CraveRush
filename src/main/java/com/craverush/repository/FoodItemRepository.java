package com.craverush.repository;

import com.craverush.entity.FoodItem;
import com.craverush.entity.Restaurant;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface FoodItemRepository extends JpaRepository<FoodItem, Long> {
    List<FoodItem> findByRestaurant(Restaurant restaurant);
}
