package com.fileshare.repository;

import com.fileshare.entity.ShareLink;
import com.fileshare.entity.FileEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface ShareLinkRepository extends JpaRepository<ShareLink, Long> {
    Optional<ShareLink> findByToken(String token);
    Optional<ShareLink> findByFile(FileEntity file);
    List<ShareLink> findByExpiryTimeBefore(LocalDateTime now);
    List<ShareLink> findByIsActiveTrue();
    
    @Query("SELECT s FROM ShareLink s WHERE s.expiryTime < :now OR s.isActive = false")
    List<ShareLink> findExpiredOrInactiveLinks(@Param("now") LocalDateTime now);
    
    @Modifying
    @Transactional
    @Query("UPDATE ShareLink s SET s.isActive = false WHERE s.file = :file")
    void deactivateLinksForFile(@Param("file") FileEntity file);
    
    // Check if file has an active share link
    @Query("SELECT CASE WHEN COUNT(s) > 0 THEN true ELSE false END FROM ShareLink s WHERE s.file = :file AND s.isActive = true")
    boolean existsActiveByFile(@Param("file") FileEntity file);
}