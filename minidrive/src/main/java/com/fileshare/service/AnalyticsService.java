package com.fileshare.service;

import com.fileshare.entity.FileEntity;
import com.fileshare.entity.ShareLink;
import com.fileshare.entity.User;
import com.fileshare.repository.FileRepository;
import com.fileshare.repository.ShareLinkRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class AnalyticsService {

    @Autowired
    private FileRepository fileRepository;

    @Autowired
    private ShareLinkRepository shareLinkRepository;

    // Get storage usage for a user
    public long getStorageUsed(User user) {
        List<FileEntity> files = fileRepository.findByUser(user);
        return files.stream()
                .mapToLong(FileEntity::getFileSize)
                .sum();
    }

    // Get total files count
    public int getTotalFiles(User user) {
        return fileRepository.findByUser(user).size();
    }

    // Get total downloads across all files
    public int getTotalDownloads(User user) {
        List<FileEntity> files = fileRepository.findByUser(user);
        int total = 0;
        for (FileEntity file : files) {
            ShareLink shareLink = shareLinkRepository.findByFile(file).orElse(null);
            if (shareLink != null) {
                total += shareLink.getDownloadCount();
            }
        }
        return total;
    }

    // Get total share links
    public int getTotalShareLinks(User user) {
        List<FileEntity> files = fileRepository.findByUser(user);
        int count = 0;
        for (FileEntity file : files) {
            if (shareLinkRepository.findByFile(file).isPresent()) {
                count++;
            }
        }
        return count;
    }

    // Get most shared files
    public List<Map<String, Object>> getMostSharedFiles(User user, int limit) {
        List<FileEntity> files = fileRepository.findByUser(user);
        
        return files.stream()
                .filter(file -> shareLinkRepository.findByFile(file).isPresent())
                .map(file -> {
                    ShareLink shareLink = shareLinkRepository.findByFile(file).get();
                    Map<String, Object> data = new HashMap<>();
                    data.put("fileName", file.getFileName());
                    data.put("downloadCount", shareLink.getDownloadCount());
                    data.put("fileId", file.getId());
                    data.put("token", shareLink.getToken());
                    return data;
                })
                .sorted((a, b) -> Integer.compare(
                        (Integer) b.get("downloadCount"),
                        (Integer) a.get("downloadCount")
                ))
                .limit(limit)
                .collect(Collectors.toList());
    }

    // Get file upload activity (last 7 days)
    public Map<String, Integer> getUploadActivity(User user) {
        Map<String, Integer> activity = new LinkedHashMap<>();
        LocalDateTime now = LocalDateTime.now();
        
        // Initialize last 7 days
        for (int i = 6; i >= 0; i--) {
            LocalDateTime day = now.minus(i, ChronoUnit.DAYS);
            String dayKey = day.getDayOfWeek().toString().substring(0, 3);
            activity.put(dayKey, 0);
        }

        // Count uploads per day
        List<FileEntity> files = fileRepository.findByUser(user);
        for (FileEntity file : files) {
            LocalDateTime uploadedAt = file.getUploadedAt();
            if (uploadedAt != null && uploadedAt.isAfter(now.minus(7, ChronoUnit.DAYS))) {
                String dayKey = uploadedAt.getDayOfWeek().toString().substring(0, 3);
                activity.put(dayKey, activity.getOrDefault(dayKey, 0) + 1);
            }
        }
        
        return activity;
    }

    // Get recent activity (last 10 events)
    public List<Map<String, Object>> getRecentActivity(User user) {
        List<Map<String, Object>> activities = new ArrayList<>();
        List<FileEntity> files = fileRepository.findByUser(user);
        
        // Upload events
        for (FileEntity file : files) {
            if (file.getUploadedAt() != null) {
                Map<String, Object> event = new HashMap<>();
                event.put("type", "upload");
                event.put("fileName", file.getFileName());
                event.put("timestamp", file.getUploadedAt());
                event.put("message", "Uploaded: " + file.getFileName());
                activities.add(event);
            }
        }

        // Download events (from share links)
        for (FileEntity file : files) {
            ShareLink shareLink = shareLinkRepository.findByFile(file).orElse(null);
            if (shareLink != null && shareLink.getDownloadCount() > 0) {
                Map<String, Object> event = new HashMap<>();
                event.put("type", "download");
                event.put("fileName", file.getFileName());
                event.put("timestamp", shareLink.getCreatedAt());
                event.put("message", "Downloaded: " + file.getFileName());
                activities.add(event);
            }
        }

        // Sort by timestamp (most recent first)
        activities.sort((a, b) -> {
            LocalDateTime t1 = (LocalDateTime) a.get("timestamp");
            LocalDateTime t2 = (LocalDateTime) b.get("timestamp");
            return t2.compareTo(t1);
        });

        return activities.stream().limit(10).collect(Collectors.toList());
    }

    // Get file type distribution
    public Map<String, Integer> getFileTypeDistribution(User user) {
        List<FileEntity> files = fileRepository.findByUser(user);
        Map<String, Integer> distribution = new HashMap<>();
        
        for (FileEntity file : files) {
            String fileType = file.getFileType();
            if (fileType != null) {
                String category = getFileCategory(fileType);
                distribution.put(category, distribution.getOrDefault(category, 0) + 1);
            }
        }
        
        return distribution;
    }

    // Helper: categorize file type
    private String getFileCategory(String fileType) {
        if (fileType.startsWith("image/")) return "Images";
        if (fileType.startsWith("video/")) return "Videos";
        if (fileType.startsWith("audio/")) return "Audio";
        if (fileType.contains("pdf")) return "PDFs";
        if (fileType.contains("document") || fileType.contains("word")) return "Documents";
        if (fileType.contains("spreadsheet") || fileType.contains("excel")) return "Spreadsheets";
        if (fileType.contains("presentation") || fileType.contains("powerpoint")) return "Presentations";
        if (fileType.startsWith("text/")) return "Text Files";
        if (fileType.contains("zip") || fileType.contains("compressed")) return "Archives";
        return "Others";
    }

    // Get download timeline (last 7 days)
    public Map<String, Integer> getDownloadActivity(User user) {
        Map<String, Integer> activity = new LinkedHashMap<>();
        LocalDateTime now = LocalDateTime.now();
        
        for (int i = 6; i >= 0; i--) {
            LocalDateTime day = now.minus(i, ChronoUnit.DAYS);
            String dayKey = day.getDayOfWeek().toString().substring(0, 3);
            activity.put(dayKey, 0);
        }

        List<FileEntity> files = fileRepository.findByUser(user);
        for (FileEntity file : files) {
            ShareLink shareLink = shareLinkRepository.findByFile(file).orElse(null);
            if (shareLink != null && shareLink.getCreatedAt() != null) {
                LocalDateTime created = shareLink.getCreatedAt();
                if (created.isAfter(now.minus(7, ChronoUnit.DAYS))) {
                    String dayKey = created.getDayOfWeek().toString().substring(0, 3);
                    int current = activity.getOrDefault(dayKey, 0);
                    activity.put(dayKey, current + shareLink.getDownloadCount());
                }
            }
        }
        
        return activity;
    }
}