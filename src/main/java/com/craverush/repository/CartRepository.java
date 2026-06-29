package com.craverush.repository;

import com.craverush.entity.Cart;
import com.craverush.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface CartRepository extends JpaRepository<Cart, Long> {
    Optional<Cart> findByUser(User user);
}
