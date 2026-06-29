package com.craverush.service;

import com.craverush.entity.User;
import com.craverush.entity.UserAddress;
import com.craverush.repository.UserRepository;
import com.craverush.repository.UserAddressRepository;
import com.craverush.util.PasswordUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserAddressRepository userAddressRepository;

    public User login(String email, String password) {
        Optional<User> optUser = userRepository.findByEmail(email);
        if (optUser.isPresent()) {
            User user = optUser.get();
            if (user.isActive() && PasswordUtil.checkPassword(password, user.getPassword())) {
                return user;
            }
        }
        return null;
    }

    public boolean register(User user) {
        if (userRepository.existsByEmail(user.getEmail())) {
            return false;
        }
        user.setPassword(PasswordUtil.hashPassword(user.getPassword()));
        user.setStatus("ACTIVE");
        userRepository.save(user);
        return true;
    }

    public User getUserById(Long userId) {
        return userRepository.findById(userId).orElse(null);
    }

    public User getUserByEmail(String email) {
        return userRepository.findByEmail(email).orElse(null);
    }

    public boolean updateProfile(User user) {
        User existing = userRepository.findById(user.getUserId()).orElse(null);
        if (existing != null) {
            existing.setFullName(user.getFullName());
            existing.setPhone(user.getPhone());
            existing.setProfileImage(user.getProfileImage());
            userRepository.save(existing);
            return true;
        }
        return false;
    }

    public boolean changePassword(Long userId, String oldPassword, String newPassword) {
        User user = userRepository.findById(userId).orElse(null);
        if (user != null && PasswordUtil.checkPassword(oldPassword, user.getPassword())) {
            user.setPassword(PasswordUtil.hashPassword(newPassword));
            userRepository.save(user);
            return true;
        }
        return false;
    }

    public boolean isEmailTaken(String email) {
        return userRepository.existsByEmail(email);
    }

    public List<UserAddress> getAddressesByUser(User user) {
        return userAddressRepository.findByUser(user);
    }

    public UserAddress saveAddress(UserAddress address) {
        return userAddressRepository.save(address);
    }

    public UserAddress getAddressById(Long addressId) {
        return userAddressRepository.findById(addressId).orElse(null);
    }

    public void deleteAddress(Long addressId) {
        userAddressRepository.deleteById(addressId);
    }
}
