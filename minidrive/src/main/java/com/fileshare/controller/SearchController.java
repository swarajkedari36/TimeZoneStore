package com.fileshare.controller;

import com.fileshare.entity.FileEntity;
import com.fileshare.entity.User;
import com.fileshare.repository.UserRepository;
import com.fileshare.service.SearchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/search")
@CrossOrigin(origins = "http://localhost:3000")
public class SearchController {

    @Autowired
    private SearchService searchService;

    @Autowired
    private UserRepository userRepository;

    private User getCurrentUser() {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        return userRepository.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
    }

    // Search by keyword (file name)
    @GetMapping("/by-name")
    public ResponseEntity<?> searchByName(@RequestParam String keyword) {
        try {
            User user = getCurrentUser();
            List<FileEntity> results = searchService.searchByName(user, keyword);
            return ResponseEntity.ok(results);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // Search by file type
    @GetMapping("/by-type")
    public ResponseEntity<?> searchByType(@RequestParam String fileType) {
        try {
            User user = getCurrentUser();
            List<FileEntity> results = searchService.searchByType(user, fileType);
            return ResponseEntity.ok(results);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // Search by date range
    @GetMapping("/by-date")
    public ResponseEntity<?> searchByDateRange(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate) {
        try {
            User user = getCurrentUser();
            List<FileEntity> results = searchService.searchByDateRange(user, startDate, endDate);
            return ResponseEntity.ok(results);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // Search by size range
    @GetMapping("/by-size")
    public ResponseEntity<?> searchBySizeRange(
            @RequestParam Long minSize,
            @RequestParam Long maxSize) {
        try {
            User user = getCurrentUser();
            List<FileEntity> results = searchService.searchBySizeRange(user, minSize, maxSize);
            return ResponseEntity.ok(results);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // Advanced search with all criteria
    @GetMapping("/advanced")
    public ResponseEntity<?> advancedSearch(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String fileType,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate,
            @RequestParam(required = false) Long minSize,
            @RequestParam(required = false) Long maxSize,
            @RequestParam(required = false) String folderName) {
        try {
            User user = getCurrentUser();
            List<FileEntity> results = searchService.advancedSearch(
                user, keyword, fileType, startDate, endDate, minSize, maxSize, folderName
            );
            
            Map<String, Object> response = new HashMap<>();
            response.put("results", results);
            response.put("count", results.size());
            response.put("totalSize", results.stream().mapToLong(FileEntity::getFileSize).sum());
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}