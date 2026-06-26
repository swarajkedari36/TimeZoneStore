package com.fileshare.dto;

import java.time.LocalDateTime;
import java.util.List;

public class ShareRequestDTO {
    private String password;
    private String expiryOption;
    private LocalDateTime customExpiry;
    private Integer maxDownloads;
    private List<String> allowedUsers;
    private boolean viewOnly;
    private boolean folderSharing;
    
    // Getters and Setters
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getExpiryOption() {
        return expiryOption;
    }
    
    public void setExpiryOption(String expiryOption) {
        this.expiryOption = expiryOption;
    }
    
    public LocalDateTime getCustomExpiry() {
        return customExpiry;
    }
    
    public void setCustomExpiry(LocalDateTime customExpiry) {
        this.customExpiry = customExpiry;
    }
    
    public Integer getMaxDownloads() {
        return maxDownloads;
    }
    
    public void setMaxDownloads(Integer maxDownloads) {
        this.maxDownloads = maxDownloads;
    }
    
    public List<String> getAllowedUsers() {
        return allowedUsers;
    }
    
    public void setAllowedUsers(List<String> allowedUsers) {
        this.allowedUsers = allowedUsers;
    }
    
    public boolean isViewOnly() {
        return viewOnly;
    }
    
    public void setViewOnly(boolean viewOnly) {
        this.viewOnly = viewOnly;
    }
    
    public boolean isFolderSharing() {
        return folderSharing;
    }
    
    public void setFolderSharing(boolean folderSharing) {
        this.folderSharing = folderSharing;
    }
}