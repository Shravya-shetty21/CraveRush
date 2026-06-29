package com.craverush.repository;

import com.craverush.entity.DeliveryTracking;
import com.craverush.entity.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface DeliveryTrackingRepository extends JpaRepository<DeliveryTracking, Long> {
    Optional<DeliveryTracking> findTopByOrderOrderByUpdatedAtDesc(Order order);
}
