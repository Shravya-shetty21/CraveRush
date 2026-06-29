package com.craverush.repository;

import com.craverush.entity.Payment;
import com.craverush.entity.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface PaymentRepository extends JpaRepository<Payment, Long> {
    Optional<Payment> findByOrder(Order order);
}
