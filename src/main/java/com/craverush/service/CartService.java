package com.craverush.service;

import com.craverush.entity.Cart;
import com.craverush.entity.CartItem;
import com.craverush.entity.User;
import com.craverush.entity.FoodItem;
import com.craverush.repository.CartRepository;
import com.craverush.repository.CartItemRepository;
import com.craverush.repository.FoodItemRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class CartService {

    @Autowired
    private CartRepository cartRepository;

    @Autowired
    private CartItemRepository cartItemRepository;

    @Autowired
    private FoodItemRepository foodItemRepository;

    public Cart getOrCreateCart(User user) {
        Optional<Cart> optCart = cartRepository.findByUser(user);
        if (optCart.isPresent()) {
            return optCart.get();
        } else {
            Cart cart = new Cart();
            cart.setUser(user);
            cart.setItems(new ArrayList<>());
            return cartRepository.save(cart);
        }
    }

    public List<CartItem> getCartItems(User user) {
        Cart cart = getOrCreateCart(user);
        return cart.getItems();
    }

    public boolean addToCart(User user, Long foodId, Long restaurantId, int quantity) {
        Cart cart = getOrCreateCart(user);
        List<CartItem> items = cart.getItems();

        // Single restaurant check
        if (!items.isEmpty()) {
            Long existingResId = items.get(0).getFoodItem().getRestaurant().getRestaurantId();
            if (!existingResId.equals(restaurantId)) {
                return false; // Conflict
            }
        }

        // Check if item already exists in cart
        Optional<CartItem> existingItem = items.stream()
                .filter(ci -> ci.getFoodItem().getFoodId().equals(foodId))
                .findFirst();

        if (existingItem.isPresent()) {
            CartItem ci = existingItem.get();
            ci.setQuantity(ci.getQuantity() + quantity);
            cartItemRepository.save(ci);
        } else {
            FoodItem foodItem = foodItemRepository.findById(foodId).orElse(null);
            if (foodItem == null) return false;

            CartItem ci = new CartItem(cart, foodItem, quantity, foodItem.getPrice());
            items.add(ci);
            cartRepository.save(cart);
        }
        return true;
    }

    public boolean clearAndAdd(User user, Long foodId, Long restaurantId, int quantity) {
        clearCart(user);
        return addToCart(user, foodId, restaurantId, quantity);
    }

    public void updateQuantity(Long cartItemId, int quantity) {
        Optional<CartItem> optItem = cartItemRepository.findById(cartItemId);
        if (optItem.isPresent()) {
            CartItem ci = optItem.get();
            if (quantity <= 0) {
                Cart cart = ci.getCart();
                cart.getItems().remove(ci);
                cartItemRepository.delete(ci);
                cartRepository.save(cart);
            } else {
                ci.setQuantity(quantity);
                cartItemRepository.save(ci);
            }
        }
    }

    public void removeItem(Long cartItemId) {
        updateQuantity(cartItemId, 0);
    }

    public void clearCart(User user) {
        Cart cart = getOrCreateCart(user);
        cart.getItems().clear();
        cartRepository.save(cart);
    }

    public int getCartCount(User user) {
        Cart cart = getOrCreateCart(user);
        return cart.getItems().stream().mapToInt(CartItem::getQuantity).sum();
    }

    public Long getRestaurantIdInCart(User user) {
        Cart cart = getOrCreateCart(user);
        if (!cart.getItems().isEmpty()) {
            return cart.getItems().get(0).getFoodItem().getRestaurant().getRestaurantId();
        }
        return 0L;
    }
}
