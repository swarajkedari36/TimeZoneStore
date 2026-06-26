package com.fileshare.entity;

import javax.persistence.*;
import com.fasterxml.jackson.annotation.JsonIgnore;
import java.time.LocalDateTime;

@Entity
@Table(name = "files")
public class FileEntity {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "file_name", nullable = false)
    private String fileName;
    
    @Column(name = "file_type")
    private String fileType;
    
    @Column(name = "file_path", nullable = false)
    private String filePath;
    
    @Column(name = "file_size")
    private Long fileSize;
    
    @ManyToOne
    @JoinColumn(name = "user_id")
    @JsonIgnore
    private User user;
    
    @Column(name = "uploaded_at")
    private LocalDateTime uploadedAt;
    
    // NEW: Folder support
    @Column(name = "folder_name")
    private String folderName = "root";
    
    @Column(name = "is_folder")
    private boolean isFolder = false;
    
    @OneToOne(mappedBy = "file", cascade = CascadeType.ALL)
    @JsonIgnore
    private ShareLink shareLink;
    
    @PrePersist
    protected void onCreate() {
        uploadedAt = LocalDateTime.now();
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getFileName() {
        return fileName;
    }
    
    public void setFileName(String fileName) {
        this.fileName = fileName;
    }
    
    public String getFileType() {
        return fileType;
    }
    
    public void setFileType(String fileType) {
        this.fileType = fileType;
    }
    
    public String getFilePath() {
        return filePath;
    }
    
    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }
    
    public Long getFileSize() {
        return fileSize;
    }
    
    public void setFileSize(Long fileSize) {
        this.fileSize = fileSize;
    }
    
    public User getUser() {
        return user;
    }
    
    public void setUser(User user) {
        this.user = user;
    }
    
    public LocalDateTime getUploadedAt() {
        return uploadedAt;
    }
    
    public void setUploadedAt(LocalDateTime uploadedAt) {
        this.uploadedAt = uploadedAt;
    }
    
    public String getFolderName() {
        return folderName;
    }
    
    public void setFolderName(String folderName) {
        this.folderName = folderName;
    }
    
    public boolean isFolder() {
        return isFolder;
    }
    
    public void setFolder(boolean isFolder) {
        this.isFolder = isFolder;
    }
    
    public ShareLink getShareLink() {
        return shareLink;
    }
    
    public void setShareLink(ShareLink shareLink) {
        this.shareLink = shareLink;
    }
}