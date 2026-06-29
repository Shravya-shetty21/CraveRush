package com.craverush.service;

import com.craverush.entity.Favorite;
import com.craverush.entity.Restaurant;
import com.craverush.entity.User;
import com.craverush.repository.FavoriteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class FavoriteService {

    @Autowired
    private FavoriteRepository favoriteRepository;

    public boolean toggleFavorite(User user, Restaurant restaurant) {
        Optional<Favorite> optFav = favoriteRepository.findByUserAndRestaurant(user, restaurant);
        if (optFav.isPresent()) {
            favoriteRepository.delete(optFav.get());
            return false; // Favorited state is now false
        } else {
            Favorite fav = new Favorite(user, restaurant);
            favoriteRepository.save(fav);
            return true; // Favorited state is now true
        }
    }

    public boolean isFavorite(User user, Restaurant restaurant) {
        if (user == null || restaurant == null) return false;
        return favoriteRepository.existsByUserAndRestaurant(user, restaurant);
    }

    public List<Favorite> getFavoritesByUser(User user) {
        return favoriteRepository.findByUser(user);
    }
}
