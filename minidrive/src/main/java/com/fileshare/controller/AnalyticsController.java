package com.fileshare.controller;

import com.fileshare.entity.User;
import com.fileshare.repository.UserRepository;
import com.fileshare.service.AnalyticsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/analytics")
@CrossOrigin(origins = "http://localhost:3000")
public class AnalyticsController {

    @Autowired
    private AnalyticsService analyticsService;

    @Autowired
    private UserRepository userRepository;

    private User getCurrentUser() {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        return userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    @GetMapping("/dashboard")
    public ResponseEntity<?> getDashboardAnalytics() {
        try {
            User user = getCurrentUser();
            
            Map<String, Object> response = new HashMap<>();
            
            // Statistics
            response.put("storageUsed", analyticsService.getStorageUsed(user));
            response.put("totalFiles", analyticsService.getTotalFiles(user));
            response.put("totalDownloads", analyticsService.getTotalDownloads(user));
            response.put("totalShareLinks", analyticsService.getTotalShareLinks(user));
            
            // Charts & Activity
            response.put("uploadActivity", analyticsService.getUploadActivity(user));
            response.put("downloadActivity", analyticsService.getDownloadActivity(user));
            response.put("fileTypeDistribution", analyticsService.getFileTypeDistribution(user));
            
            // Most shared files
            response.put("mostSharedFiles", analyticsService.getMostSharedFiles(user, 5));
            
            // Recent activity
            response.put("recentActivity", analyticsService.getRecentActivity(user));
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}