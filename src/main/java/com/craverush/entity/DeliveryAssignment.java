package com.craverush.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "delivery_assignments")
public class DeliveryAssignment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "assignment_id")
    private Long assignmentId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "order_id", nullable = false)
    private Order order;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "partner_id", nullable = false)
    private DeliveryPartner partner;

    @Column(name = "assigned_time", updatable = false)
    private LocalDateTime assignedTime;

    @Column(name = "delivery_status", length = 30)
    private String deliveryStatus = "ASSIGNED"; // ASSIGNED, ACCEPTED, PICKED_UP, DELIVERED, CANCELLED

    @PrePersist
    protected void onCreate() {
        assignedTime = LocalDateTime.now();
    }

    public DeliveryAssignment() {
    }

    public Long getAssignmentId() {
        return assignmentId;
    }

    public void setAssignmentId(Long assignmentId) {
        this.assignmentId = assignmentId;
    }

    public Order getOrder() {
        return order;
    }

    public void setOrder(Order order) {
        this.order = order;
    }

    public DeliveryPartner getPartner() {
        return partner;
    }

    public void setPartner(DeliveryPartner partner) {
        this.partner = partner;
    }

    public LocalDateTime getAssignedTime() {
        return assignedTime;
    }

    public void setAssignedTime(LocalDateTime assignedTime) {
        this.assignedTime = assignedTime;
    }

    public String getDeliveryStatus() {
        return deliveryStatus;
    }

    public void setDeliveryStatus(String deliveryStatus) {
        this.deliveryStatus = deliveryStatus;
    }
}
