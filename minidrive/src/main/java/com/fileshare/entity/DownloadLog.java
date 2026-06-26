package com.fileshare.entity;

import javax.persistence.Embeddable;
import java.time.LocalDateTime;

@Embeddable
public class DownloadLog {
    
    private String userEmail;
    private String ipAddress;
    private String userAgent;
    private LocalDateTime downloadTime;
    
    public DownloadLog() {
        this.downloadTime = LocalDateTime.now();
    }
    
    public DownloadLog(String userEmail, String ipAddress, String userAgent) {
        this.userEmail = userEmail;
        this.ipAddress = ipAddress;
        this.userAgent = userAgent;
        this.downloadTime = LocalDateTime.now();
    }
    
    // Getters and Setters
    public String getUserEmail() {
        return userEmail;
    }
    
    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }
    
    public String getIpAddress() {
        return ipAddress;
    }
    
    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }
    
    public String getUserAgent() {
        return userAgent;
    }
    
    public void setUserAgent(String userAgent) {
        this.userAgent = userAgent;
    }
    
    public LocalDateTime getDownloadTime() {
        return downloadTime;
    }
    
    public void setDownloadTime(LocalDateTime downloadTime) {
        this.downloadTime = downloadTime;
    }
}