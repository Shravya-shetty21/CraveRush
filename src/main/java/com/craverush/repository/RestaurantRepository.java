package com.craverush.repository;

import com.craverush.entity.Restaurant;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;

public interface RestaurantRepository extends JpaRepository<Restaurant, Long> {
    List<Restaurant> findByAreaAndStatus(String area, String status);
    List<Restaurant> findByArea(String area);
    List<Restaurant> findByStatus(String status);
    
    @Query("SELECT r FROM Restaurant r WHERE r.name LIKE %:query% OR r.cuisineType LIKE %:query% OR r.address LIKE %:query% OR r.area LIKE %:query%")
    List<Restaurant> searchRestaurants(@Param("query") String query);
}
