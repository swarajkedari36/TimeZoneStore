/*
 * package com.fileshare.dto;
 * 
 * import java.time.LocalDateTime;
 * 
 * public class FileResponseDTO { private Long id; private String fileName;
 * private String fileType; private Long fileSize; private LocalDateTime
 * uploadedAt;
 * 
 * public FileResponseDTO(Long id, String fileName, String fileType, Long
 * fileSize, LocalDateTime uploadedAt) { this.id = id; this.fileName = fileName;
 * this.fileType = fileType; this.fileSize = fileSize; this.uploadedAt =
 * uploadedAt; }
 * 
 * public Long getId() { return id; }
 * 
 * public void setId(Long id) { this.id = id; }
 * 
 * public String getFileName() { return fileName; }
 * 
 * public void setFileName(String fileName) { this.fileName = fileName; }
 * 
 * public String getFileType() { return fileType; }
 * 
 * public void setFileType(String fileType) { this.fileType = fileType; }
 * 
 * public Long getFileSize() { return fileSize; }
 * 
 * public void setFileSize(Long fileSize) { this.fileSize = fileSize; }
 * 
 * public LocalDateTime getUploadedAt() { return uploadedAt; }
 * 
 * public void setUploadedAt(LocalDateTime uploadedAt) { this.uploadedAt =
 * uploadedAt; } }
 */

package com.fileshare.dto;

import java.time.LocalDateTime;

public class FileResponseDTO {
    private Long id;
    private String fileName;
    private String fileType;
    private Long fileSize;
    private LocalDateTime uploadedAt;
    private String folderName;
    private boolean isFolder;
    
    public FileResponseDTO(Long id, String fileName, String fileType, Long fileSize, LocalDateTime uploadedAt) {
        this.id = id;
        this.fileName = fileName;
        this.fileType = fileType;
        this.fileSize = fileSize;
        this.uploadedAt = uploadedAt;
        this.folderName = "root";
        this.isFolder = false;
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
    
    public Long getFileSize() {
        return fileSize;
    }
    
    public void setFileSize(Long fileSize) {
        this.fileSize = fileSize;
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
}