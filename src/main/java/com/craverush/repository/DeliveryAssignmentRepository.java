package com.craverush.repository;

import com.craverush.entity.DeliveryAssignment;
import com.craverush.entity.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface DeliveryAssignmentRepository extends JpaRepository<DeliveryAssignment, Long> {
    Optional<DeliveryAssignment> findByOrder(Order order);
}
