package com.craverush.repository;

import com.craverush.entity.DeliveryPartner;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface DeliveryPartnerRepository extends JpaRepository<DeliveryPartner, Long> {
    List<DeliveryPartner> findByStatus(String status);
}
