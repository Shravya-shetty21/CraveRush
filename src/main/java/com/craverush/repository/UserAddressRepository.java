package com.craverush.repository;

import com.craverush.entity.UserAddress;
import com.craverush.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface UserAddressRepository extends JpaRepository<UserAddress, Long> {
    List<UserAddress> findByUser(User user);
}
