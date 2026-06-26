package com.fileshare.scheduler;

import com.fileshare.entity.FileEntity;
import com.fileshare.entity.ShareLink;
import com.fileshare.repository.FileRepository;
import com.fileshare.repository.ShareLinkRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.List;

@Component
@EnableScheduling
public class CleanupScheduler {
    
    @Autowired
    private ShareLinkRepository shareLinkRepository;
    
    @Autowired
    private FileRepository fileRepository;
    
    @Scheduled(cron = "0 0 2 * * ?") // Run at 2 AM every day
    public void cleanupExpiredLinks() {
        LocalDateTime now = LocalDateTime.now();
        List<ShareLink> expiredLinks = shareLinkRepository.findByExpiryTimeBefore(now);
        
        for (ShareLink link : expiredLinks) {
            shareLinkRepository.delete(link);
        }
        
        System.out.println("Cleaned up " + expiredLinks.size() + " expired share links");
    }
    
    @Scheduled(cron = "0 0 3 * * ?") // Run at 3 AM every day
    public void cleanupOrphanedFiles() {
        List<FileEntity> allFiles = fileRepository.findAll();
        int deletedCount = 0;
        
        for (FileEntity file : allFiles) {
            Path filePath = Paths.get(file.getFilePath());
            if (!Files.exists(filePath)) {
                fileRepository.delete(file);
                deletedCount++;
            }
        }
        
        System.out.println("Cleaned up " + deletedCount + " orphaned file records");
    }
}