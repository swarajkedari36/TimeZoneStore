package com.timezone.model;

import java.util.Date;
import java.util.List;

public class Order {
    private int id;
    private String orderNumber;
    private Date orderDate;
    private double totalAmount;
    private String status;
    private List<Watch> items;
    private String paymentMethod;
    private String shippingAddress;
    
    // Tracking fields
    private String trackingNumber;
    private Date estimatedDelivery;
    private Date deliveredDate;
    private String shippingCarrier;
    private String trackingStatus;
    private List<TrackingHistory> trackingHistory;
    
    // Customer fields
    private String customerName;
    private String customerEmail;
    private String customerPhone;
    
    public Order() {}
    
    public Order(int id, String orderNumber, Date orderDate, double totalAmount, String status) {
        this.id = id;
        this.orderNumber = orderNumber;
        this.orderDate = orderDate;
        this.totalAmount = totalAmount;
        this.status = status;
    }
    
    // Inner class for tracking history
    public static class TrackingHistory {
        private String status;
        private String location;
        private String description;
        private Date createdAt;
        
        public TrackingHistory() {}
        
        public TrackingHistory(String status, String location, String description, Date createdAt) {
            this.status = status;
            this.location = location;
            this.description = description;
            this.createdAt = createdAt;
        }
        
        // Getters and Setters for TrackingHistory
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
        
        public String getLocation() { return location; }
        public void setLocation(String location) { this.location = location; }
        
        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }
        
        public Date getCreatedAt() { return createdAt; }
        public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getOrderNumber() { return orderNumber; }
    public void setOrderNumber(String orderNumber) { this.orderNumber = orderNumber; }
    
    public Date getOrderDate() { return orderDate; }
    public void setOrderDate(Date orderDate) { this.orderDate = orderDate; }
    
    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public List<Watch> getItems() { return items; }
    public void setItems(List<Watch> items) { this.items = items; }
    
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    
    public String getShippingAddress() { return shippingAddress; }
    public void setShippingAddress(String shippingAddress) { this.shippingAddress = shippingAddress; }
    
    // Tracking getters/setters
    public String getTrackingNumber() { return trackingNumber; }
    public void setTrackingNumber(String trackingNumber) { this.trackingNumber = trackingNumber; }
    
    public Date getEstimatedDelivery() { return estimatedDelivery; }
    public void setEstimatedDelivery(Date estimatedDelivery) { this.estimatedDelivery = estimatedDelivery; }
    
    public Date getDeliveredDate() { return deliveredDate; }
    public void setDeliveredDate(Date deliveredDate) { this.deliveredDate = deliveredDate; }
    
    public String getShippingCarrier() { return shippingCarrier; }
    public void setShippingCarrier(String shippingCarrier) { this.shippingCarrier = shippingCarrier; }
    
    public String getTrackingStatus() { return trackingStatus; }
    public void setTrackingStatus(String trackingStatus) { this.trackingStatus = trackingStatus; }
    
    public List<TrackingHistory> getTrackingHistory() { return trackingHistory; }
    public void setTrackingHistory(List<TrackingHistory> trackingHistory) { this.trackingHistory = trackingHistory; }
    
    // Customer getters/setters
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    
    public String getCustomerEmail() { return customerEmail; }
    public void setCustomerEmail(String customerEmail) { this.customerEmail = customerEmail; }
    
    public String getCustomerPhone() { return customerPhone; }
    public void setCustomerPhone(String customerPhone) { this.customerPhone = customerPhone; }
}