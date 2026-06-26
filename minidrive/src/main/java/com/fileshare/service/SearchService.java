package com.fileshare.service;

import com.fileshare.entity.FileEntity;
import com.fileshare.entity.User;
import com.fileshare.repository.FileRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class SearchService {

    @Autowired
    private FileRepository fileRepository;

    // Search by file name (contains keyword)
    public List<FileEntity> searchByName(User user, String keyword) {
        List<FileEntity> allFiles = fileRepository.findByUser(user);
        return allFiles.stream()
            .filter(f -> !f.isFolder())
            .filter(f -> f.getFileName().toLowerCase().contains(keyword.toLowerCase()))
            .collect(Collectors.toList());
    }

    // Search by file type
    public List<FileEntity> searchByType(User user, String fileType) {
        List<FileEntity> allFiles = fileRepository.findByUser(user);
        return allFiles.stream()
            .filter(f -> !f.isFolder())
            .filter(f -> f.getFileType() != null && f.getFileType().toLowerCase().contains(fileType.toLowerCase()))
            .collect(Collectors.toList());
    }

    // Search by date range
    public List<FileEntity> searchByDateRange(User user, LocalDateTime startDate, LocalDateTime endDate) {
        List<FileEntity> allFiles = fileRepository.findByUser(user);
        return allFiles.stream()
            .filter(f -> !f.isFolder())
            .filter(f -> f.getUploadedAt() != null)
            .filter(f -> !f.getUploadedAt().isBefore(startDate) && !f.getUploadedAt().isAfter(endDate))
            .collect(Collectors.toList());
    }

    // Search by size range (in bytes)
    public List<FileEntity> searchBySizeRange(User user, Long minSize, Long maxSize) {
        List<FileEntity> allFiles = fileRepository.findByUser(user);
        return allFiles.stream()
            .filter(f -> !f.isFolder())
            .filter(f -> f.getFileSize() != null)
            .filter(f -> f.getFileSize() >= minSize && f.getFileSize() <= maxSize)
            .collect(Collectors.toList());
    }

    // Advanced search with multiple criteria
    public List<FileEntity> advancedSearch(User user, String keyword, String fileType, 
                                           LocalDateTime startDate, LocalDateTime endDate,
                                           Long minSize, Long maxSize, String folderName) {
        List<FileEntity> allFiles = fileRepository.findByUser(user);
        
        return allFiles.stream()
            .filter(f -> !f.isFolder())
            .filter(f -> {
                // Filter by keyword
                if (keyword != null && !keyword.isEmpty()) {
                    return f.getFileName().toLowerCase().contains(keyword.toLowerCase());
                }
                return true;
            })
            .filter(f -> {
                // Filter by file type
                if (fileType != null && !fileType.isEmpty() && !fileType.equals("All")) {
                    if (f.getFileType() == null) return false;
                    return f.getFileType().toLowerCase().contains(fileType.toLowerCase());
                }
                return true;
            })
            .filter(f -> {
                // Filter by date range
                if (startDate != null && endDate != null) {
                    if (f.getUploadedAt() == null) return false;
                    return !f.getUploadedAt().isBefore(startDate) && !f.getUploadedAt().isAfter(endDate);
                }
                return true;
            })
            .filter(f -> {
                // Filter by size range
                if (minSize != null && maxSize != null) {
                    if (f.getFileSize() == null) return false;
                    return f.getFileSize() >= minSize && f.getFileSize() <= maxSize;
                }
                return true;
            })
            .filter(f -> {
                // Filter by folder
                if (folderName != null && !folderName.isEmpty() && !folderName.equals("All Folders")) {
                    return f.getFolderName() != null && f.getFolderName().equals(folderName);
                }
                return true;
            })
            .collect(Collectors.toList());
    }
}