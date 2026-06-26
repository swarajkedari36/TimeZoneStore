package com.fileshare.dto;

import com.fileshare.entity.DownloadLog;
import java.time.LocalDateTime;
import java.util.List;

public class ShareResponseDTO {
    private String token;
    private String shareUrl;
    private LocalDateTime expiryTime;
    private Integer downloadCount;
    private Integer maxDownloads;
    private boolean passwordProtected;
    private boolean viewOnly;
    private List<String> allowedUsers;
    private List<DownloadLog> downloadLogs;
    private String qrCodeBase64;
    private String message;
    
    // Getters and Setters
    public String getToken() {
        return token;
    }
    
    public void setToken(String token) {
        this.token = token;
    }
    
    public String getShareUrl() {
        return shareUrl;
    }
    
    public void setShareUrl(String shareUrl) {
        this.shareUrl = shareUrl;
    }
    
    public LocalDateTime getExpiryTime() {
        return expiryTime;
    }
    
    public void setExpiryTime(LocalDateTime expiryTime) {
        this.expiryTime = expiryTime;
    }
    
    public Integer getDownloadCount() {
        return downloadCount;
    }
    
    public void setDownloadCount(Integer downloadCount) {
        this.downloadCount = downloadCount;
    }
    
    public Integer getMaxDownloads() {
        return maxDownloads;
    }
    
    public void setMaxDownloads(Integer maxDownloads) {
        this.maxDownloads = maxDownloads;
    }
    
    public boolean isPasswordProtected() {
        return passwordProtected;
    }
    
    public void setPasswordProtected(boolean passwordProtected) {
        this.passwordProtected = passwordProtected;
    }
    
    public boolean isViewOnly() {
        return viewOnly;
    }
    
    public void setViewOnly(boolean viewOnly) {
        this.viewOnly = viewOnly;
    }
    
    public List<String> getAllowedUsers() {
        return allowedUsers;
    }
    
    public void setAllowedUsers(List<String> allowedUsers) {
        this.allowedUsers = allowedUsers;
    }
    
    public List<DownloadLog> getDownloadLogs() {
        return downloadLogs;
    }
    
    public void setDownloadLogs(List<DownloadLog> downloadLogs) {
        this.downloadLogs = downloadLogs;
    }
    
    public String getQrCodeBase64() {
        return qrCodeBase64;
    }
    
    public void setQrCodeBase64(String qrCodeBase64) {
        this.qrCodeBase64 = qrCodeBase64;
    }
    
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
}