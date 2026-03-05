package com.timezone.model;

import java.util.Date;

public class Review {
    private int id;
    private int userId;
    private int watchId;
    private int rating;
    private String reviewText;
    private Date createdAt;
    
    // Additional fields for display
    private String userName;
    private int helpfulCount;
    private boolean userHelpful; // Whether current user found this helpful
    
    public Review() {}
    
    public Review(int id, int userId, int watchId, int rating, String reviewText, Date createdAt) {
        this.id = id;
        this.userId = userId;
        this.watchId = watchId;
        this.rating = rating;
        this.reviewText = reviewText;
        this.createdAt = createdAt;
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public int getWatchId() { return watchId; }
    public void setWatchId(int watchId) { this.watchId = watchId; }
    
    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }
    
    public String getReviewText() { return reviewText; }
    public void setReviewText(String reviewText) { this.reviewText = reviewText; }
    
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    
    public int getHelpfulCount() { return helpfulCount; }
    public void setHelpfulCount(int helpfulCount) { this.helpfulCount = helpfulCount; }
    
    public boolean isUserHelpful() { return userHelpful; }
    public void setUserHelpful(boolean userHelpful) { this.userHelpful = userHelpful; }
}