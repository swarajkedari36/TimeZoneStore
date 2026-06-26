/*
 * package com.fileshare.repository;
 * 
 * import com.fileshare.entity.FileEntity; import com.fileshare.entity.User;
 * import org.springframework.data.jpa.repository.JpaRepository; import
 * java.util.List; import java.util.Optional;
 * 
 * public interface FileRepository extends JpaRepository<FileEntity, Long> {
 * List<FileEntity> findByUser(User user); Optional<FileEntity>
 * findByIdAndUser(Long id, User user); }
 */
package com.fileshare.repository;

import com.fileshare.entity.FileEntity;
import com.fileshare.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface FileRepository extends JpaRepository<FileEntity, Long> {
    List<FileEntity> findByUser(User user);
    Optional<FileEntity> findByIdAndUser(Long id, User user);
    
    // NEW: Get items by folder
    List<FileEntity> findByUserAndFolderName(User user, String folderName);
    
    // NEW: Get all folders
    List<FileEntity> findByUserAndIsFolder(User user, boolean isFolder);
}