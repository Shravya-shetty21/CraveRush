package com.craverush.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "restaurants")
public class Restaurant {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "restaurant_id")
    private Long restaurantId;

    @Column(name = "restaurant_name", nullable = false, length = 100)
    private String name;

    @Column(name = "owner_name", nullable = false, length = 100)
    private String ownerName;

    @Column(name = "email", nullable = false, unique = true, length = 100)
    private String email;

    @Column(name = "phone", nullable = false, unique = true, length = 15)
    private String phone;

    @Column(name = "address", nullable = false, columnDefinition = "TEXT")
    private String address;

    @Column(name = "city", length = 50)
    private String city = "Bangalore";

    @Column(name = "state", length = 50)
    private String state = "Karnataka";

    @Column(name = "pincode", length = 10)
    private String pincode;

    @Column(name = "area", length = 100)
    private String area = "Koramangala";

    @Column(name = "latitude", precision = 10, scale = 8)
    private BigDecimal latitude;

    @Column(name = "longitude", precision = 11, scale = 8)
    private BigDecimal longitude;

    @Column(name = "opening_time")
    private LocalTime openingTime;

    @Column(name = "closing_time")
    private LocalTime closingTime;

    @Column(name = "rating", precision = 2, scale = 1)
    private BigDecimal rating = BigDecimal.valueOf(0.0);

    @Column(name = "status", length = 20)
    private String status = "ACTIVE";

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    // Added Columns
    @Column(name = "cuisine_type")
    private String cuisineType;

    @Column(name = "delivery_time")
    private Integer deliveryTime = 30;

    @Column(name = "min_order", precision = 10, scale = 2)
    private BigDecimal minOrder = BigDecimal.valueOf(100.00);

    @Column(name = "price_for_two")
    private Integer priceForTwo = 300;

    @Column(name = "is_veg")
    private boolean isVeg = false;

    @OneToMany(mappedBy = "restaurant", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    private List<RestaurantImage> images = new ArrayList<>();

    @OneToMany(mappedBy = "restaurant", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<FoodItem> foodItems = new ArrayList<>();

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        if (openingTime == null) openingTime = LocalTime.of(8, 0);
        if (closingTime == null) closingTime = LocalTime.of(23, 0);
    }

    public Restaurant() {
    }

    // --- Computed Transient properties for compatibility with Servlets ---
    @Transient
    public String getImageUrl() {
        if (images != null && !images.isEmpty()) {
            return images.get(0).getImageUrl();
        }
        if (cuisineType != null) {
            String ct = cuisineType.toLowerCase();
            if (ct.contains("pizza")) {
                return "https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=500&q=80";
            } else if (ct.contains("burger")) {
                return "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=500&q=80";
            } else if (ct.contains("chinese")) {
                return "https://images.unsplash.com/photo-1585032226651-759b368d7246?auto=format&fit=crop&w=500&q=80";
            } else if (ct.contains("south indian")) {
                return "https://images.unsplash.com/photo-1668236543090-82eba5ee5976?auto=format&fit=crop&w=500&q=80";
            } else if (ct.contains("biryani") || ct.contains("north indian")) {
                return "https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=500&q=80";
            } else if (ct.contains("dessert") || ct.contains("ice cream")) {
                return "https://images.unsplash.com/photo-1563805042-7684c019e1cb?auto=format&fit=crop&w=500&q=80";
            } else if (ct.contains("beverag") || ct.contains("coffee") || ct.contains("cafe")) {
                return "https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?auto=format&fit=crop&w=500&q=80";
            }
        }
        return "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=500&q=80"; // fallback
    }

    @Transient
    public boolean isActive() {
        return "ACTIVE".equalsIgnoreCase(this.status);
    }

    @Transient
    public boolean isOpen() {
        LocalTime now = LocalTime.now();
        if (openingTime != null && closingTime != null) {
            return now.isAfter(openingTime) && now.isBefore(closingTime);
        }
        return true;
    }

    // --- Getters & Setters ---
    public Long getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(Long restaurantId) {
        this.restaurantId = restaurantId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getOwnerName() {
        return ownerName;
    }

    public void setOwnerName(String ownerName) {
        this.ownerName = ownerName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getPincode() {
        return pincode;
    }

    public void setPincode(String pincode) {
        this.pincode = pincode;
    }

    public String getArea() {
        return area;
    }

    public void setArea(String area) {
        this.area = area;
    }

    public BigDecimal getLatitude() {
        return latitude;
    }

    public void setLatitude(BigDecimal latitude) {
        this.latitude = latitude;
    }

    public BigDecimal getLongitude() {
        return longitude;
    }

    public void setLongitude(BigDecimal longitude) {
        this.longitude = longitude;
    }

    public LocalTime getOpeningTime() {
        return openingTime;
    }

    public void setOpeningTime(LocalTime openingTime) {
        this.openingTime = openingTime;
    }

    public LocalTime getClosingTime() {
        return closingTime;
    }

    public void setClosingTime(LocalTime closingTime) {
        this.closingTime = closingTime;
    }

    public BigDecimal getRating() {
        return rating;
    }

    public void setRating(BigDecimal rating) {
        this.rating = rating;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getCuisineType() {
        return cuisineType;
    }

    public void setCuisineType(String cuisineType) {
        this.cuisineType = cuisineType;
    }

    public Integer getDeliveryTime() {
        return deliveryTime;
    }

    public void setDeliveryTime(Integer deliveryTime) {
        this.deliveryTime = deliveryTime;
    }

    public BigDecimal getMinOrder() {
        return minOrder;
    }

    public void setMinOrder(BigDecimal minOrder) {
        this.minOrder = minOrder;
    }

    public Integer getPriceForTwo() {
        return priceForTwo;
    }

    public void setPriceForTwo(Integer priceForTwo) {
        this.priceForTwo = priceForTwo;
    }

    public boolean isVeg() {
        return isVeg;
    }

    public void setVeg(boolean veg) {
        isVeg = veg;
    }

    public List<RestaurantImage> getImages() {
        return images;
    }

    public void setImages(List<RestaurantImage> images) {
        this.images = images;
    }

    public List<FoodItem> getFoodItems() {
        return foodItems;
    }

    public void setFoodItems(List<FoodItem> foodItems) {
        this.foodItems = foodItems;
    }
}
