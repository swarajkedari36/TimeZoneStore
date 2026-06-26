package com.fileshare.entity;

import javax.persistence.*;
import com.fasterxml.jackson.annotation.JsonIgnore;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "share_links")
public class ShareLink {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(unique = true, nullable = false)
    private String token;
    
    @OneToOne
    @JoinColumn(name = "file_id", unique = true)
    @JsonIgnore
    private FileEntity file;
    
    @Column(name = "expiry_time")
    private LocalDateTime expiryTime;
    
    @Column(name = "download_count")
    private Integer downloadCount = 0;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    // Advanced Sharing Fields
    @Column(name = "password_hash")
    private String passwordHash;
    
    @Column(name = "max_downloads")
    private Integer maxDownloads;
    
    @Column(name = "is_active")
    private boolean isActive = true;
    
    @Column(name = "view_only")
    private boolean viewOnly = false;
    
    @Column(name = "folder_sharing")
    private boolean folderSharing = false;
    
    @ElementCollection
    @CollectionTable(name = "share_allowed_users", joinColumns = @JoinColumn(name = "share_link_id"))
    @Column(name = "email")
    private List<String> allowedUsers = new ArrayList<>();
    
    @ElementCollection
    @CollectionTable(name = "share_download_logs", joinColumns = @JoinColumn(name = "share_link_id"))
    private List<DownloadLog> downloadLogs = new ArrayList<>();
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getToken() {
        return token;
    }
    
    public void setToken(String token) {
        this.token = token;
    }
    
    public FileEntity getFile() {
        return file;
    }
    
    public void setFile(FileEntity file) {
        this.file = file;
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
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public String getPasswordHash() {
        return passwordHash;
    }
    
    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }
    
    public Integer getMaxDownloads() {
        return maxDownloads;
    }
    
    public void setMaxDownloads(Integer maxDownloads) {
        this.maxDownloads = maxDownloads;
    }
    
    public boolean isActive() {
        return isActive;
    }
    
    public void setActive(boolean active) {
        isActive = active;
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
}