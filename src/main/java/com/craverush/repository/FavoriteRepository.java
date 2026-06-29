package com.craverush.repository;

import com.craverush.entity.Favorite;
import com.craverush.entity.User;
import com.craverush.entity.Restaurant;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface FavoriteRepository extends JpaRepository<Favorite, Long> {
    List<Favorite> findByUser(User user);
    Optional<Favorite> findByUserAndRestaurant(User user, Restaurant restaurant);
    boolean existsByUserAndRestaurant(User user, Restaurant restaurant);
}
