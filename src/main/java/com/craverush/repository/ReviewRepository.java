package com.craverush.repository;

import com.craverush.entity.Review;
import com.craverush.entity.Restaurant;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ReviewRepository extends JpaRepository<Review, Long> {
    List<Review> findByRestaurantOrderByReviewDateDesc(Restaurant restaurant);
}
