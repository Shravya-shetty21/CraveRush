package com.craverush.service;

import com.craverush.entity.DeliveryAssignment;
import com.craverush.entity.DeliveryPartner;
import com.craverush.entity.Order;
import com.craverush.repository.DeliveryAssignmentRepository;
import com.craverush.repository.DeliveryPartnerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Service
@Transactional
public class DeliveryService {

    @Autowired
    private DeliveryPartnerRepository deliveryPartnerRepository;

    @Autowired
    private DeliveryAssignmentRepository deliveryAssignmentRepository;

    // Static area coordinates in Bangalore
    private static final Map<String, double[]> LOCATION_COORDS = new HashMap<>();

    static {
        LOCATION_COORDS.put("Koramangala", new double[]{12.9352, 77.6244});
        LOCATION_COORDS.put("BTM Layout", new double[]{12.9166, 77.6101});
        LOCATION_COORDS.put("HSR Layout", new double[]{12.9141, 77.6413});
        LOCATION_COORDS.put("JP Nagar", new double[]{12.9063, 77.5857});
        LOCATION_COORDS.put("Jayanagar", new double[]{12.9307, 77.5832});
        LOCATION_COORDS.put("Indiranagar", new double[]{12.9719, 77.6412});
        LOCATION_COORDS.put("Whitefield", new double[]{12.9698, 77.7499});
        LOCATION_COORDS.put("Electronic City", new double[]{12.8452, 77.6602});
        LOCATION_COORDS.put("Marathahalli", new double[]{12.9569, 77.7011});
        LOCATION_COORDS.put("Bellandur", new double[]{12.9304, 77.6784});
        LOCATION_COORDS.put("MG Road", new double[]{12.9738, 77.6119});
        LOCATION_COORDS.put("Banashankari", new double[]{12.9250, 77.5468});
        LOCATION_COORDS.put("Rajajinagar", new double[]{12.9902, 77.5539});
        LOCATION_COORDS.put("Yelahanka", new double[]{13.0994, 77.5926});
        LOCATION_COORDS.put("Hebbal", new double[]{13.0359, 77.5970});
        LOCATION_COORDS.put("Malleshwaram", new double[]{13.0031, 77.5684});
        LOCATION_COORDS.put("Basavanagudi", new double[]{12.9406, 77.5738});
        LOCATION_COORDS.put("Vijayanagar", new double[]{12.9696, 77.5360});
        LOCATION_COORDS.put("Bannerghatta Road", new double[]{12.8907, 77.5953});
        LOCATION_COORDS.put("Guruguntepalya", new double[]{13.0247, 77.5395});
    }

    public static double[] getCoordsForArea(String area) {
        if (area == null) return LOCATION_COORDS.get("Koramangala");
        for (String key : LOCATION_COORDS.keySet()) {
            if (area.toLowerCase().contains(key.toLowerCase()) || key.toLowerCase().contains(area.toLowerCase())) {
                return LOCATION_COORDS.get(key);
            }
        }
        return LOCATION_COORDS.get("Koramangala");
    }

    public DeliveryPartner getAssignedPartnerForOrder(Order order) {
        Optional<DeliveryAssignment> optAssign = deliveryAssignmentRepository.findByOrder(order);
        return optAssign.map(DeliveryAssignment::getPartner).orElse(null);
    }

    public Map<String, Object> getLiveTrackingData(Order order) {
        Map<String, Object> data = new HashMap<>();

        // 1. Restaurant coordinates
        double[] restCoords = getCoordsForArea(order.getRestaurant().getArea());
        if (order.getRestaurant().getLatitude() != null) {
            restCoords[0] = order.getRestaurant().getLatitude().doubleValue();
            restCoords[1] = order.getRestaurant().getLongitude().doubleValue();
        }
        data.put("restaurantLat", restCoords[0]);
        data.put("restaurantLng", restCoords[1]);

        // 2. Customer coordinates
        double[] custCoords = getCoordsForArea(order.getAddress() != null ? order.getAddress().getCity() : "Koramangala");
        if (order.getAddress() != null) {
            if (order.getAddress().getLatitude() != null && order.getAddress().getLatitude().doubleValue() > 0) {
                custCoords[0] = order.getAddress().getLatitude().doubleValue();
                custCoords[1] = order.getAddress().getLongitude().doubleValue();
            } else {
                // offset slightly from restaurant to make a visible route
                custCoords[0] = restCoords[0] + 0.015;
                custCoords[1] = restCoords[1] + 0.015;
            }
        } else {
            custCoords[0] = restCoords[0] + 0.015;
            custCoords[1] = restCoords[1] + 0.015;
        }
        data.put("customerLat", custCoords[0]);
        data.put("customerLng", custCoords[1]);

        // 3. Status progression simulation based on elapsed time since orderDate
        String status = order.getOrderStatus();
        
        // Dynamic status progression for demo purposes
        long elapsedSeconds = java.time.Duration.between(order.getOrderDate(), LocalDateTime.now()).getSeconds();
        if ("PLACED".equalsIgnoreCase(status)) {
            if (elapsedSeconds > 15 && elapsedSeconds <= 30) {
                status = "ACCEPTED";
            } else if (elapsedSeconds > 30 && elapsedSeconds <= 45) {
                status = "PREPARING";
            } else if (elapsedSeconds > 45 && elapsedSeconds <= 60) {
                status = "READY_FOR_PICKUP";
            } else if (elapsedSeconds > 60 && elapsedSeconds <= 75) {
                status = "PICKED_UP";
            } else if (elapsedSeconds > 75 && elapsedSeconds <= 150) {
                status = "OUT_FOR_DELIVERY";
            } else if (elapsedSeconds > 150) {
                status = "DELIVERED";
            }
            // Update order status in db silently if progressed
            if (!status.equalsIgnoreCase(order.getOrderStatus())) {
                order.setOrderStatus(status);
                if ("DELIVERED".equalsIgnoreCase(status)) {
                    order.setDeliveredAt(LocalDateTime.now());
                }
            }
        }

        data.put("orderStatus", status);

        // 4. Delivery partner coordinates simulation
        double riderLat = restCoords[0];
        double riderLng = restCoords[1];

        if ("OUT_FOR_DELIVERY".equalsIgnoreCase(status)) {
            // Smoothly move from restaurant to customer over a 60 seconds loop
            double fraction = (System.currentTimeMillis() % 60000) / 60000.0;
            riderLat = restCoords[0] + (custCoords[0] - restCoords[0]) * fraction;
            riderLng = restCoords[1] + (custCoords[1] - restCoords[1]) * fraction;
        } else if ("DELIVERED".equalsIgnoreCase(status)) {
            riderLat = custCoords[0];
            riderLng = custCoords[1];
        }

        data.put("riderLat", riderLat);
        data.put("riderLng", riderLng);

        // Estimate time: distance-based mock
        double latDiff = custCoords[0] - restCoords[0];
        double lngDiff = custCoords[1] - restCoords[1];
        double distanceKm = Math.sqrt(latDiff * latDiff + lngDiff * lngDiff) * 111.0; // rough approximation
        data.put("distance", String.format("%.2f km", distanceKm));

        int etaMin = (int) Math.round(distanceKm * 4.0 + 5.0); // 4 min per km + 5 min prep
        if ("DELIVERED".equalsIgnoreCase(status)) {
            etaMin = 0;
        } else if ("OUT_FOR_DELIVERY".equalsIgnoreCase(status)) {
            etaMin = Math.max(1, etaMin - (int)(etaMin * ((System.currentTimeMillis() % 60000) / 60000.0)));
        }
        data.put("eta", etaMin + " mins");

        // Rider details
        DeliveryPartner partner = getAssignedPartnerForOrder(order);
        if (partner != null) {
            data.put("riderName", partner.getFullName());
            data.put("riderPhone", partner.getPhone());
            data.put("riderVehicle", partner.getVehicleNumber());
            data.put("riderPhoto", partner.getProfilePhoto());
        }

        return data;
    }
}
