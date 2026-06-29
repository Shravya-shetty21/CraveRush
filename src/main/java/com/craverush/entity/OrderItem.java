package com.craverush.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "order_items")
public class OrderItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "order_item_id")
    private Long orderItemId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "order_id", nullable = false)
    private Order order;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "food_id", nullable = false)
    private FoodItem foodItem;

    @Column(name = "quantity", nullable = false)
    private Integer quantity;

    @Column(name = "price", nullable = false, precision = 10, scale = 2)
    private BigDecimal price; // Unit price

    public OrderItem() {
    }

    public OrderItem(Order order, FoodItem foodItem, Integer quantity, BigDecimal price) {
        this.order = order;
        this.foodItem = foodItem;
        this.quantity = quantity;
        this.price = price;
    }

    // --- JSP Compatibility Getters ---
    @Transient
    public String getItemName() {
        return foodItem != null ? foodItem.getName() : "";
    }

    @Transient
    public boolean isItemIsVeg() {
        return foodItem != null && foodItem.isVeg();
    }

    @Transient
    public BigDecimal getUnitPrice() {
        return price;
    }

    @Transient
    public BigDecimal getTotalPrice() {
        return price != null ? price.multiply(BigDecimal.valueOf(quantity)) : BigDecimal.ZERO;
    }

    // --- Getters & Setters ---
    public Long getOrderItemId() {
        return orderItemId;
    }

    public void setOrderItemId(Long orderItemId) {
        this.orderItemId = orderItemId;
    }

    public Order getOrder() {
        return order;
    }

    public void setOrder(Order order) {
        this.order = order;
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
