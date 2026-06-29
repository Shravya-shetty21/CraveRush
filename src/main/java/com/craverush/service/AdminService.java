package com.craverush.service;

import com.craverush.entity.Admin;
import com.craverush.repository.*;
import com.craverush.util.PasswordUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Service
@Transactional
public class AdminService {

    @Autowired
    private AdminRepository adminRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RestaurantRepository restaurantRepository;

    @Autowired
    private OrderRepository orderRepository;

    public Admin login(String emailOrUsername, String password) {
        Optional<Admin> optAdmin = adminRepository.findByEmail(emailOrUsername);
        if (!optAdmin.isPresent()) {
            optAdmin = adminRepository.findByUsername(emailOrUsername);
        }

        if (optAdmin.isPresent()) {
            Admin admin = optAdmin.get();
            if (PasswordUtil.checkPassword(password, admin.getPassword())) {
                return admin;
            }
        }
        return null;
    }

    public Map<String, Long> getDashboardStats() {
        Map<String, Long> stats = new HashMap<>();
        stats.put("totalUsers", userRepository.count());
        stats.put("totalRestaurants", restaurantRepository.count());
        stats.put("totalOrders", orderRepository.count());
        
        // Count active orders (PLACED, ACCEPTED, PREPARING, OUT_FOR_DELIVERY)
        long activeOrders = orderRepository.findAll().stream()
                .filter(o -> !"DELIVERED".equalsIgnoreCase(o.getOrderStatus()) && !"CANCELLED".equalsIgnoreCase(o.getOrderStatus()))
                .count();
        stats.put("activeOrders", activeOrders);

        return stats;
    }
}
