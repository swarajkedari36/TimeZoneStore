package com.timezone.model;

import java.util.Date;

public class TrackingHistory {
    private int id;
    private int orderId;
    private String status;
    private String location;
    private String description;
    private Date createdAt;
    
    public TrackingHistory() {}
    
    public TrackingHistory(int id, int orderId, String status, String location, String description, Date createdAt) {
        this.id = id;
        this.orderId = orderId;
        this.status = status;
        this.location = location;
        this.description = description;
        this.createdAt = createdAt;
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}