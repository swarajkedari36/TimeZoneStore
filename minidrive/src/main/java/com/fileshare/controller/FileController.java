package com.fileshare.controller;

import com.fileshare.dto.FileResponseDTO;
import com.fileshare.dto.ShareRequestDTO;
import com.fileshare.dto.ShareResponseDTO;
import com.fileshare.entity.FileEntity;
import com.fileshare.entity.ShareLink;
import com.fileshare.entity.User;
import com.fileshare.repository.FileRepository;  // ← ADD THIS IMPORT
import com.fileshare.repository.ShareLinkRepository;
import com.fileshare.repository.UserRepository;
import com.fileshare.service.FileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import javax.servlet.http.HttpServletRequest;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/files")
@CrossOrigin(origins = "http://localhost:3000")
public class FileController {
    
    @Autowired
    private FileService fileService;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private ShareLinkRepository shareLinkRepository;
    
    @Autowired
    private FileRepository fileRepository;  // ← ADD THIS
    
    private User getCurrentUser() {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        return userRepository.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
    }
    
    // ===== BASIC FILE ENDPOINTS =====
    
    @PostMapping("/upload")
    public ResponseEntity<?> uploadFile(@RequestParam("file") MultipartFile file) {
        try {
            User currentUser = getCurrentUser();
            FileEntity uploadedFile = fileService.uploadFile(file, currentUser);
            return ResponseEntity.ok(uploadedFile);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    
    @GetMapping("/download/{id}")
    public ResponseEntity<?> downloadFile(@PathVariable Long id) {
        try {
            User currentUser = getCurrentUser();
            Path filePath = fileService.downloadFile(id, currentUser);
            Resource resource = new UrlResource(filePath.toUri());
            
            return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_OCTET_STREAM)
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + resource.getFilename() + "\"")
                .body(resource);
        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteFile(@PathVariable Long id) {
        try {
            User currentUser = getCurrentUser();
            fileService.deleteFile(id, currentUser);
            return ResponseEntity.ok().body("File deleted successfully");
        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }
    }
    
    @GetMapping("/my-files")
    public ResponseEntity<?> getUserFiles() {
        User currentUser = getCurrentUser();
        List<FileResponseDTO> files = fileService.getUserFiles(currentUser);
        return ResponseEntity.ok(files);
    }
    
    // ===== BASIC SHARE ENDPOINTS =====
    
    @PostMapping("/share/{id}")
    public ResponseEntity<?> shareFile(@PathVariable Long id) {
        try {
            User currentUser = getCurrentUser();
            ShareLink shareLink = fileService.createShareLink(id, currentUser);
            return ResponseEntity.ok(shareLink);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    
    @GetMapping("/public/{token}")
    public ResponseEntity<?> downloadPublicFile(@PathVariable String token) {
        try {
            Path filePath = fileService.downloadPublicFile(token);
            Resource resource = new UrlResource(filePath.toUri());
            
            return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_OCTET_STREAM)
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + resource.getFilename() + "\"")
                .body(resource);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    
    // ===== FOLDER ENDPOINTS =====
    
    @PostMapping("/folder")
    public ResponseEntity<?> createFolder(@RequestBody Map<String, String> request) {
        try {
            User currentUser = getCurrentUser();
            String folderName = request.get("folderName");
            if (folderName == null || folderName.trim().isEmpty()) {
                return ResponseEntity.badRequest().body("Folder name is required");
            }
            FileEntity folder = fileService.createFolder(folderName.trim(), currentUser);
            return ResponseEntity.ok(folder);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    
    @GetMapping("/all-items")
    public ResponseEntity<?> getAllItems() {
        try {
            User currentUser = getCurrentUser();
            List<FileEntity> items = fileService.getAllItems(currentUser);
            
            Map<String, Object> response = new HashMap<>();
            response.put("folders", items.stream().filter(FileEntity::isFolder).collect(Collectors.toList()));
            response.put("files", items.stream().filter(f -> !f.isFolder()).collect(Collectors.toList()));
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    
    @GetMapping("/folder/{folderName}")
    public ResponseEntity<?> getItemsByFolder(@PathVariable String folderName) {
        try {
            User currentUser = getCurrentUser();
            List<FileEntity> items = fileService.getItemsByFolder(currentUser, folderName);
            return ResponseEntity.ok(items);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    
    @PutMapping("/move/{fileId}")
    public ResponseEntity<?> moveFileToFolder(
            @PathVariable Long fileId,
            @RequestBody Map<String, String> request) {
        try {
            User currentUser = getCurrentUser();
            String folderName = request.get("folderName");
            if (folderName == null || folderName.trim().isEmpty()) {
                return ResponseEntity.badRequest().body("Folder name is required");
            }
            FileEntity moved = fileService.moveFileToFolder(fileId, folderName.trim(), currentUser);
            return ResponseEntity.ok(moved);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    
    @PutMapping("/rename-folder")
    public ResponseEntity<?> renameFolder(@RequestBody Map<String, String> request) {
        try {
            User currentUser = getCurrentUser();
            String oldName = request.get("oldName");
            String newName = request.get("newName");
            if (oldName == null || newName == null) {
                return ResponseEntity.badRequest().body("Both old and new names are required");
            }
            FileEntity renamed = fileService.renameFolder(oldName.trim(), newName.trim(), currentUser);
            return ResponseEntity.ok(renamed);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    
    @DeleteMapping("/folder/{folderName}")
    public ResponseEntity<?> deleteFolder(@PathVariable String folderName) {
        try {
            User currentUser = getCurrentUser();
            fileService.deleteFolder(folderName, currentUser);
            return ResponseEntity.ok().body("Folder deleted successfully");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    
    @GetMapping("/folder-size/{folderName}")
    public ResponseEntity<?> getFolderSize(@PathVariable String folderName) {
        try {
            User currentUser = getCurrentUser();
            long size = fileService.getFolderSize(folderName, currentUser);
            return ResponseEntity.ok().body(Map.of("size", size));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    
    @PostMapping("/upload/{folderName}")
    public ResponseEntity<?> uploadFileToFolder(
            @RequestParam("file") MultipartFile file,
            @PathVariable String folderName) {
        try {
            User currentUser = getCurrentUser();
            FileEntity uploadedFile = fileService.uploadFileToFolder(file, currentUser, folderName);
            return ResponseEntity.ok(uploadedFile);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    
    // ===== ADVANCED SHARING ENDPOINTS =====
    
    @PostMapping("/share/advanced/{id}")
    public ResponseEntity<?> createAdvancedShareLink(
            @PathVariable Long id,
            @RequestBody ShareRequestDTO request,
            HttpServletRequest httpRequest) {
        try {
            User currentUser = getCurrentUser();
            
            ShareLink shareLink = fileService.createOrUpdateShareLink(id, currentUser, request);
            
            ShareResponseDTO response = new ShareResponseDTO();
            response.setToken(shareLink.getToken());
            response.setShareUrl("http://localhost:3000/share/" + shareLink.getToken());
            response.setExpiryTime(shareLink.getExpiryTime());
            response.setDownloadCount(shareLink.getDownloadCount());
            response.setMaxDownloads(shareLink.getMaxDownloads());
            response.setPasswordProtected(shareLink.getPasswordHash() != null);
            response.setViewOnly(shareLink.isViewOnly());
            response.setAllowedUsers(shareLink.getAllowedUsers());
            response.setDownloadLogs(shareLink.getDownloadLogs());
            
            String qrUrl = "http://localhost:3000/share/" + shareLink.getToken();
            response.setQrCodeBase64(generateQRCode(qrUrl));
            
            response.setMessage("Share link created/updated successfully!");
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    
    @PostMapping("/share/validate/{token}")
    public ResponseEntity<?> validateShareLink(
            @PathVariable String token,
            @RequestBody(required = false) Map<String, String> request,
            HttpServletRequest httpRequest) {
        try {
            String password = request != null ? request.get("password") : null;
            String userEmail = request != null ? request.get("email") : null;
            String ipAddress = httpRequest.getRemoteAddr();
            String userAgent = httpRequest.getHeader("User-Agent");
            
            ShareLink shareLink = fileService.validateAndGetShareLink(
                token, password, userEmail, ipAddress, userAgent
            );
            
            Map<String, Object> response = new HashMap<>();
            response.put("valid", true);
            response.put("fileName", shareLink.getFile().getFileName());
            response.put("fileSize", shareLink.getFile().getFileSize());
            response.put("viewOnly", shareLink.isViewOnly());
            response.put("downloadCount", shareLink.getDownloadCount());
            response.put("maxDownloads", shareLink.getMaxDownloads());
            response.put("expiryTime", shareLink.getExpiryTime());
            response.put("passwordProtected", shareLink.getPasswordHash() != null);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    
    @PostMapping("/share/revoke/{token}")
    public ResponseEntity<?> revokeShareLink(@PathVariable String token) {
        try {
            User currentUser = getCurrentUser();
            ShareLink shareLink = fileService.revokeShareLink(token, currentUser);
            return ResponseEntity.ok().body("Share link revoked successfully");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    
    @GetMapping("/share/my-links")
    public ResponseEntity<?> getMyShareLinks() {
        try {
            User currentUser = getCurrentUser();
            List<ShareLink> shareLinks = fileService.getUserShareLinks(currentUser);
            
            List<Map<String, Object>> response = new ArrayList<>();
            for (ShareLink link : shareLinks) {
                Map<String, Object> data = new HashMap<>();
                data.put("token", link.getToken());
                data.put("fileName", link.getFile().getFileName());
                data.put("downloadCount", link.getDownloadCount());
                data.put("maxDownloads", link.getMaxDownloads());
                data.put("expiryTime", link.getExpiryTime());
                data.put("isActive", link.isActive());
                data.put("viewOnly", link.isViewOnly());
                data.put("allowedUsers", link.getAllowedUsers());
                data.put("downloadLogs", link.getDownloadLogs());
                response.add(data);
            }
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    
    @PutMapping("/share/update/{token}")
    public ResponseEntity<?> updateShareLink(
            @PathVariable String token,
            @RequestBody ShareRequestDTO request) {
        try {
            User currentUser = getCurrentUser();
            ShareLink shareLink = fileService.updateShareLink(token, request, currentUser);
            return ResponseEntity.ok(shareLink);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    
    @GetMapping("/share/check/{fileId}")
    public ResponseEntity<?> checkExistingShareLink(@PathVariable Long fileId) {
        try {
            User currentUser = getCurrentUser();
            FileEntity file = fileRepository.findByIdAndUser(fileId, currentUser)
                .orElseThrow(() -> new RuntimeException("File not found"));
            
            boolean exists = shareLinkRepository.existsActiveByFile(file);
            
            Map<String, Object> response = new HashMap<>();
            response.put("exists", exists);
            
            if (exists) {
                ShareLink link = shareLinkRepository.findByFile(file).orElse(null);
                if (link != null) {
                    response.put("token", link.getToken());
                    response.put("expiryTime", link.getExpiryTime());
                    response.put("downloadCount", link.getDownloadCount());
                    response.put("maxDownloads", link.getMaxDownloads());
                    response.put("viewOnly", link.isViewOnly());
                    response.put("passwordProtected", link.getPasswordHash() != null);
                }
            }
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    
    // Helper: Generate QR Code
    private String generateQRCode(String url) {
        return "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==";
    }
}