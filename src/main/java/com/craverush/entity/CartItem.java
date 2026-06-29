package com.craverush.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "cart_items")
public class CartItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "cart_item_id")
    private Long cartItemId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cart_id", nullable = false)
    private Cart cart;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "food_id", nullable = false)
    private FoodItem foodItem;

    @Column(name = "quantity", nullable = false)
    private Integer quantity = 1;

    @Column(name = "price", nullable = false, precision = 10, scale = 2)
    private BigDecimal price;

    public CartItem() {
    }

    public CartItem(Cart cart, FoodItem foodItem, Integer quantity, BigDecimal price) {
        this.cart = cart;
        this.foodItem = foodItem;
        this.quantity = quantity;
        this.price = price;
    }

    // --- JSP Compatibility Getters ---
    @Transient
    public int getCartId() {
        return cartItemId != null ? cartItemId.intValue() : 0;
    }

    @Transient
    public String getRestaurantName() {
        return (foodItem != null && foodItem.getRestaurant() != null) ? foodItem.getRestaurant().getName() : "";
    }

    @Transient
    public String getItemName() {
        return foodItem != null ? foodItem.getName() : "";
    }

    @Transient
    public BigDecimal getItemPrice() {
        return price;
    }

    @Transient
    public boolean isItemIsVeg() {
        return foodItem != null && foodItem.isVeg();
    }

    @Transient
    public BigDecimal getTotalPrice() {
        return price != null ? price.multiply(BigDecimal.valueOf(quantity)) : BigDecimal.ZERO;
    }

    // --- Getters & Setters ---
    public Long getCartItemId() {
        return cartItemId;
    }

    public void setCartItemId(Long cartItemId) {
        this.cartItemId = cartItemId;
    }

    public Cart getCart() {
        return cart;
    }

    public void setCart(Cart cart) {
        this.cart = cart;
    }

    public FoodItem getFoodItem() {
        return foodItem;
    }

    public void setFoodItem(FoodItem foodItem) {
        this.foodItem = foodItem;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }
}
