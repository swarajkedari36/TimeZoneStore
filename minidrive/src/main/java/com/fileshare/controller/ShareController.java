package com.fileshare.controller;

import com.fileshare.entity.ShareLink;
import com.fileshare.service.FileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/share")
@CrossOrigin(origins = "http://localhost:3000")
public class ShareController {

    @Autowired
    private FileService fileService;

    @PostMapping("/validate/{token}")
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
}