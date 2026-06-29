package com.craverush.service;

import com.craverush.entity.Review;
import com.craverush.entity.Restaurant;
import com.craverush.entity.User;
import com.craverush.repository.ReviewRepository;
import com.craverush.repository.RestaurantRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;

@Service
@Transactional
public class ReviewService {

    @Autowired
    private ReviewRepository reviewRepository;

    @Autowired
    private RestaurantRepository restaurantRepository;

    public List<Review> getReviewsForRestaurant(Restaurant restaurant) {
        return reviewRepository.findByRestaurantOrderByReviewDateDesc(restaurant);
    }

    public Review addReview(User user, Restaurant restaurant, int rating, String text) {
        Review review = new Review();
        review.setUser(user);
        review.setRestaurant(restaurant);
        review.setRating(rating);
        review.setReviewText(text);

        review = reviewRepository.save(review);

        // Update restaurant average rating
        List<Review> reviews = reviewRepository.findByRestaurantOrderByReviewDateDesc(restaurant);
        if (!reviews.isEmpty()) {
            double sum = reviews.stream().mapToInt(Review::getRating).sum();
            double avg = sum / reviews.size();
            restaurant.setRating(BigDecimal.valueOf(avg).setScale(1, RoundingMode.HALF_UP));
            restaurantRepository.save(restaurant);
        }

        return review;
    }
}
