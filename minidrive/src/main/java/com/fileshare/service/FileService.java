package com.fileshare.service;

import com.fileshare.dto.FileResponseDTO;
import com.fileshare.dto.ShareRequestDTO;
import com.fileshare.entity.DownloadLog;
import com.fileshare.entity.FileEntity;
import com.fileshare.entity.ShareLink;
import com.fileshare.entity.User;
import com.fileshare.repository.FileRepository;
import com.fileshare.repository.ShareLinkRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class FileService {
    
    @Autowired
    private FileRepository fileRepository;
    
    @Autowired
    private ShareLinkRepository shareLinkRepository;
    
    @Autowired
    private PasswordEncoder passwordEncoder;
    
    @Value("${upload.dir:uploads}")
    private String uploadDir;
    
    @Value("${share.expiry.minutes:30}")
    private Integer expiryMinutes;
    
    // ===== BASIC FILE METHODS =====
    
    public FileEntity uploadFile(MultipartFile file, User user) throws IOException {
        Path uploadPath = Paths.get(uploadDir);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }
        
        String originalFilename = file.getOriginalFilename();
        String fileExtension = originalFilename.substring(originalFilename.lastIndexOf("."));
        String fileName = UUID.randomUUID().toString() + fileExtension;
        
        Path filePath = uploadPath.resolve(fileName);
        Files.copy(file.getInputStream(), filePath);
        
        FileEntity fileEntity = new FileEntity();
        fileEntity.setFileName(originalFilename);
        fileEntity.setFileType(file.getContentType());
        fileEntity.setFilePath(filePath.toString());
        fileEntity.setFileSize(file.getSize());
        fileEntity.setUser(user);
        fileEntity.setFolderName("root");
        fileEntity.setFolder(false);
        
        return fileRepository.save(fileEntity);
    }
    
    public Path downloadFile(Long fileId, User user) {
        FileEntity file = fileRepository.findByIdAndUser(fileId, user)
            .orElseThrow(() -> new RuntimeException("File not found"));
        return Paths.get(file.getFilePath());
    }
    
    public void deleteFile(Long fileId, User user) {
        FileEntity file = fileRepository.findByIdAndUser(fileId, user)
            .orElseThrow(() -> new RuntimeException("File not found"));
        try {
            Files.deleteIfExists(Paths.get(file.getFilePath()));
        } catch (IOException e) {
            throw new RuntimeException("Failed to delete file from storage");
        }
        fileRepository.delete(file);
    }
    
    public List<FileResponseDTO> getUserFiles(User user) {
        List<FileEntity> files = fileRepository.findByUser(user);
        return files.stream()
            .filter(f -> !f.isFolder())
            .map(file -> new FileResponseDTO(
                file.getId(),
                file.getFileName(),
                file.getFileType(),
                file.getFileSize(),
                file.getUploadedAt()
            ))
            .collect(Collectors.toList());
    }
    
    // ===== BASIC SHARE LINK METHODS =====
    
    public ShareLink createShareLink(Long fileId, User user) {
        FileEntity file = fileRepository.findByIdAndUser(fileId, user)
            .orElseThrow(() -> new RuntimeException("File not found"));
        
        // Check if share link already exists and still valid
        ShareLink existingLink = shareLinkRepository.findByFile(file).orElse(null);
        if (existingLink != null && existingLink.getExpiryTime().isAfter(LocalDateTime.now()) && existingLink.isActive()) {
            return existingLink;
        }
        
        // Delete expired/inactive link
        if (existingLink != null) {
            shareLinkRepository.delete(existingLink);
        }
        
        ShareLink shareLink = new ShareLink();
        shareLink.setToken(UUID.randomUUID().toString());
        shareLink.setFile(file);
        shareLink.setExpiryTime(LocalDateTime.now().plusMinutes(expiryMinutes));
        shareLink.setDownloadCount(0);
        shareLink.setActive(true);
        
        return shareLinkRepository.save(shareLink);
    }
    
    public Path downloadPublicFile(String token) {
        ShareLink shareLink = shareLinkRepository.findByToken(token)
            .orElseThrow(() -> new RuntimeException("Invalid token"));
        
        if (!shareLink.isActive()) {
            throw new RuntimeException("Share link has been revoked");
        }
        
        if (shareLink.getExpiryTime().isBefore(LocalDateTime.now())) {
            throw new RuntimeException("Link has expired");
        }
        
        // Check max downloads
        if (shareLink.getMaxDownloads() != null && shareLink.getMaxDownloads() > 0) {
            if (shareLink.getDownloadCount() >= shareLink.getMaxDownloads()) {
                throw new RuntimeException("Download limit reached");
            }
        }
        
        shareLink.setDownloadCount(shareLink.getDownloadCount() + 1);
        shareLinkRepository.save(shareLink);
        
        return Paths.get(shareLink.getFile().getFilePath());
    }
    
    // ===== FOLDER METHODS =====
    
    public FileEntity createFolder(String folderName, User user) {
        List<FileEntity> existing = fileRepository.findByUserAndFolderName(user, folderName);
        if (!existing.isEmpty()) {
            throw new RuntimeException("Folder '" + folderName + "' already exists");
        }
        
        FileEntity folder = new FileEntity();
        folder.setFileName(folderName);
        folder.setUser(user);
        folder.setFolderName(folderName);
        folder.setFolder(true);
        folder.setFilePath("");
        folder.setFileSize(0L);
        folder.setFileType("folder");
        
        return fileRepository.save(folder);
    }
    
    public List<FileEntity> getAllItems(User user) {
        return fileRepository.findByUser(user);
    }
    
    public List<FileEntity> getItemsByFolder(User user, String folderName) {
        return fileRepository.findByUserAndFolderName(user, folderName);
    }
    
    public List<FileEntity> getAllFolders(User user) {
        return fileRepository.findByUserAndIsFolder(user, true);
    }
    
    public FileEntity moveFileToFolder(Long fileId, String newFolder, User user) {
        FileEntity file = fileRepository.findByIdAndUser(fileId, user)
            .orElseThrow(() -> new RuntimeException("File not found"));
        
        if (file.isFolder()) {
            throw new RuntimeException("Cannot move a folder");
        }
        
        if (!"root".equals(newFolder)) {
            List<FileEntity> existingFolder = fileRepository.findByUserAndFolderName(user, newFolder);
            if (existingFolder.stream().noneMatch(f -> f.isFolder())) {
                createFolder(newFolder, user);
            }
        }
        
        file.setFolderName(newFolder);
        return fileRepository.save(file);
    }
    
    public FileEntity renameFolder(String oldName, String newName, User user) {
        List<FileEntity> folders = fileRepository.findByUserAndFolderName(user, oldName);
        if (folders.isEmpty()) {
            throw new RuntimeException("Folder not found");
        }
        
        List<FileEntity> existing = fileRepository.findByUserAndFolderName(user, newName);
        if (!existing.isEmpty()) {
            throw new RuntimeException("Folder '" + newName + "' already exists");
        }
        
        for (FileEntity item : folders) {
            item.setFolderName(newName);
            fileRepository.save(item);
        }
        
        return folders.get(0);
    }
    
    public void deleteFolder(String folderName, User user) {
        List<FileEntity> items = fileRepository.findByUserAndFolderName(user, folderName);
        if (items.isEmpty()) {
            throw new RuntimeException("Folder not found");
        }
        
        for (FileEntity item : items) {
            if (!item.isFolder() && item.getFilePath() != null && !item.getFilePath().isEmpty()) {
                try {
                    Files.deleteIfExists(Paths.get(item.getFilePath()));
                } catch (IOException e) {
                    System.err.println("Failed to delete file: " + item.getFilePath());
                }
            }
            fileRepository.delete(item);
        }
    }
    
    public long getFolderSize(String folderName, User user) {
        List<FileEntity> items = fileRepository.findByUserAndFolderName(user, folderName);
        return items.stream()
                .filter(f -> !f.isFolder())
                .mapToLong(FileEntity::getFileSize)
                .sum();
    }
    
    public FileEntity uploadFileToFolder(MultipartFile file, User user, String folderName) throws IOException {
        Path uploadPath = Paths.get(uploadDir);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }
        
        String originalFilename = file.getOriginalFilename();
        String fileExtension = originalFilename.substring(originalFilename.lastIndexOf("."));
        String fileName = UUID.randomUUID().toString() + fileExtension;
        
        Path filePath = uploadPath.resolve(fileName);
        Files.copy(file.getInputStream(), filePath);
        
        if (!"root".equals(folderName)) {
            List<FileEntity> existingFolder = fileRepository.findByUserAndFolderName(user, folderName);
            if (existingFolder.stream().noneMatch(f -> f.isFolder())) {
                createFolder(folderName, user);
            }
        }
        
        FileEntity fileEntity = new FileEntity();
        fileEntity.setFileName(originalFilename);
        fileEntity.setFileType(file.getContentType());
        fileEntity.setFilePath(filePath.toString());
        fileEntity.setFileSize(file.getSize());
        fileEntity.setUser(user);
        fileEntity.setFolderName(folderName != null ? folderName : "root");
        fileEntity.setFolder(false);
        
        return fileRepository.save(fileEntity);
    }
    
    // ===== ADVANCED SHARING METHODS =====
    
    // Calculate expiry based on option
    private LocalDateTime calculateExpiry(String option, LocalDateTime customExpiry) {
        LocalDateTime now = LocalDateTime.now();
        switch (option) {
            case "1h": return now.plusHours(1);
            case "24h": return now.plusDays(1);
            case "7d": return now.plusDays(7);
            case "30d": return now.plusDays(30);
            case "custom": return customExpiry != null ? customExpiry : now.plusDays(7);
            default: return now.plusDays(7);
        }
    }
    
    // CREATE OR UPDATE share link (Main method for advanced sharing)
    public ShareLink createOrUpdateShareLink(Long fileId, User user, ShareRequestDTO request) throws Exception {
        FileEntity file = fileRepository.findByIdAndUser(fileId, user)
            .orElseThrow(() -> new RuntimeException("File not found"));
        
        // Check if a share link already exists
        ShareLink existingLink = shareLinkRepository.findByFile(file).orElse(null);
        
        if (existingLink != null) {
            // UPDATE existing link instead of creating new one
            System.out.println("🔄 Updating existing share link for file: " + file.getFileName());
            
            // Update password
            if (request.getPassword() != null && !request.getPassword().isEmpty()) {
                existingLink.setPasswordHash(passwordEncoder.encode(request.getPassword()));
            } else {
                existingLink.setPasswordHash(null); // Remove password protection
            }
            
            // Update expiry
            if (request.getExpiryOption() != null) {
                existingLink.setExpiryTime(calculateExpiry(request.getExpiryOption(), request.getCustomExpiry()));
            }
            
            // Update max downloads
            if (request.getMaxDownloads() != null && request.getMaxDownloads() > 0) {
                existingLink.setMaxDownloads(request.getMaxDownloads());
            } else {
                existingLink.setMaxDownloads(null);
            }
            
            // Update allowed users
            if (request.getAllowedUsers() != null && !request.getAllowedUsers().isEmpty()) {
                existingLink.setAllowedUsers(request.getAllowedUsers());
            } else {
                existingLink.setAllowedUsers(new ArrayList<>());
            }
            
            // Update view-only permission
            existingLink.setViewOnly(request.isViewOnly());
            
            // Reactivate if it was deactivated
            existingLink.setActive(true);
            
            return shareLinkRepository.save(existingLink);
        }
        
        // No existing link - CREATE new one
        System.out.println("🆕 Creating new share link for file: " + file.getFileName());
        
        ShareLink shareLink = new ShareLink();
        shareLink.setToken(UUID.randomUUID().toString());
        shareLink.setFile(file);
        shareLink.setActive(true);
        shareLink.setViewOnly(request.isViewOnly());
        shareLink.setFolderSharing(request.isFolderSharing());
        
        LocalDateTime expiry = calculateExpiry(request.getExpiryOption(), request.getCustomExpiry());
        shareLink.setExpiryTime(expiry);
        
        if (request.getPassword() != null && !request.getPassword().isEmpty()) {
            shareLink.setPasswordHash(passwordEncoder.encode(request.getPassword()));
        }
        
        if (request.getMaxDownloads() != null && request.getMaxDownloads() > 0) {
            shareLink.setMaxDownloads(request.getMaxDownloads());
        }
        
        if (request.getAllowedUsers() != null && !request.getAllowedUsers().isEmpty()) {
            shareLink.setAllowedUsers(request.getAllowedUsers());
        }
        
        shareLink.setDownloadCount(0);
        
        return shareLinkRepository.save(shareLink);
    }
    
    // Validate share link (called when someone tries to download)
    public ShareLink validateAndGetShareLink(String token, String password, String userEmail, 
                                              String ipAddress, String userAgent) throws Exception {
        ShareLink shareLink = shareLinkRepository.findByToken(token)
            .orElseThrow(() -> new RuntimeException("Invalid share link"));
        
        // Check if active
        if (!shareLink.isActive()) {
            throw new RuntimeException("Share link has been revoked");
        }
        
        // Check expiry
        if (shareLink.getExpiryTime().isBefore(LocalDateTime.now())) {
            throw new RuntimeException("Share link has expired");
        }
        
        // Check password
        if (shareLink.getPasswordHash() != null && !shareLink.getPasswordHash().isEmpty()) {
            if (password == null || !passwordEncoder.matches(password, shareLink.getPasswordHash())) {
                throw new RuntimeException("Incorrect password");
            }
        }
        
        // Check allowed users
        if (!shareLink.getAllowedUsers().isEmpty()) {
            if (userEmail == null || !shareLink.getAllowedUsers().contains(userEmail)) {
                throw new RuntimeException("You are not authorized to access this link");
            }
        }
        
        // Check download limit
        if (shareLink.getMaxDownloads() != null && shareLink.getMaxDownloads() > 0) {
            if (shareLink.getDownloadCount() >= shareLink.getMaxDownloads()) {
                throw new RuntimeException("Download limit reached");
            }
        }
        
        // Log download
        DownloadLog log = new DownloadLog(userEmail, ipAddress, userAgent);
        shareLink.getDownloadLogs().add(log);
        shareLink.setDownloadCount(shareLink.getDownloadCount() + 1);
        shareLinkRepository.save(shareLink);
        
        return shareLink;
    }
    
    // Revoke share link
    public ShareLink revokeShareLink(String token, User user) throws Exception {
        ShareLink shareLink = shareLinkRepository.findByToken(token)
            .orElseThrow(() -> new RuntimeException("Share link not found"));
        
        // Check ownership
        if (!shareLink.getFile().getUser().getId().equals(user.getId())) {
            throw new RuntimeException("You don't have permission to revoke this link");
        }
        
        shareLink.setActive(false);
        return shareLinkRepository.save(shareLink);
    }
    
    // Get all share links for a user
    public List<ShareLink> getUserShareLinks(User user) {
        List<FileEntity> files = fileRepository.findByUser(user);
        List<ShareLink> shareLinks = new ArrayList<>();
        for (FileEntity file : files) {
            shareLinkRepository.findByFile(file).ifPresent(shareLinks::add);
        }
        return shareLinks;
    }
    
    // Update share link settings
    public ShareLink updateShareLink(String token, ShareRequestDTO request, User user) throws Exception {
        ShareLink shareLink = shareLinkRepository.findByToken(token)
            .orElseThrow(() -> new RuntimeException("Share link not found"));
        
        if (!shareLink.getFile().getUser().getId().equals(user.getId())) {
            throw new RuntimeException("You don't have permission to update this link");
        }
        
        if (request.getExpiryOption() != null) {
            shareLink.setExpiryTime(calculateExpiry(request.getExpiryOption(), request.getCustomExpiry()));
        }
        
        if (request.getMaxDownloads() != null) {
            shareLink.setMaxDownloads(request.getMaxDownloads());
        }
        
        if (request.getPassword() != null && !request.getPassword().isEmpty()) {
            shareLink.setPasswordHash(passwordEncoder.encode(request.getPassword()));
        }
        
        shareLink.setViewOnly(request.isViewOnly());
        
        return shareLinkRepository.save(shareLink);
    }
}