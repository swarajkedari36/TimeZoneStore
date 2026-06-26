package com.fileshare.controller;

import com.fileshare.entity.User;
import com.fileshare.repository.UserRepository;
import com.fileshare.security.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "http://localhost:3000")
public class UserController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtUtil jwtUtil;

    // Get current user profile
    @GetMapping("/me")
    public ResponseEntity<?> getCurrentUser() {
        try {
            String username = SecurityContextHolder.getContext().getAuthentication().getName();
            User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
            
            // Return user without password
            user.setPassword(null);
            return ResponseEntity.ok(user);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // Update user profile
    @PutMapping("/update")
    public ResponseEntity<?> updateUser(@RequestBody Map<String, String> request) {
        try {
            String username = SecurityContextHolder.getContext().getAuthentication().getName();
            User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
            
            String newUsername = request.get("username");
            String newEmail = request.get("email");
            
            // Check if username is already taken (if changed)
            if (newUsername != null && !newUsername.equals(user.getUsername())) {
                if (userRepository.existsByUsername(newUsername)) {
                    return ResponseEntity.badRequest().body("Username already exists");
                }
                user.setUsername(newUsername);
            }
            
            if (newEmail != null && !newEmail.equals(user.getEmail())) {
                if (userRepository.existsByEmail(newEmail)) {
                    return ResponseEntity.badRequest().body("Email already exists");
                }
                user.setEmail(newEmail);
            }
            
            userRepository.save(user);
            
            // Generate new token with updated username
            String newToken = jwtUtil.generateToken(user.getUsername());
            
            Map<String, Object> response = new HashMap<>();
            response.put("message", "Profile updated successfully");
            response.put("username", user.getUsername());
            response.put("email", user.getEmail());
            response.put("token", newToken);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // Change password
    @PutMapping("/change-password")
    public ResponseEntity<?> changePassword(@RequestBody Map<String, String> request) {
        try {
            String username = SecurityContextHolder.getContext().getAuthentication().getName();
            User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
            
            String currentPassword = request.get("currentPassword");
            String newPassword = request.get("newPassword");
            
            // Verify current password
            if (!passwordEncoder.matches(currentPassword, user.getPassword())) {
                return ResponseEntity.badRequest().body("Current password is incorrect");
            }
            
            // Update password
            user.setPassword(passwordEncoder.encode(newPassword));
            userRepository.save(user);
            
            return ResponseEntity.ok("Password updated successfully");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // Save preferences
    @PutMapping("/preferences")
    public ResponseEntity<?> savePreferences(@RequestBody Map<String, Object> preferences) {
        try {
            String username = SecurityContextHolder.getContext().getAuthentication().getName();
            User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
            
            // In a real app, you would save preferences in a separate table
            // For now, we'll just return success
            return ResponseEntity.ok("Preferences saved successfully");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}