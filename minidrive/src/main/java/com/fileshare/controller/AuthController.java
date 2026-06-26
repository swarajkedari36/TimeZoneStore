package com.fileshare.controller;

import com.fileshare.dto.AuthRequestDTO;
import com.fileshare.dto.AuthResponseDTO;
import com.fileshare.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import javax.validation.Valid;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "http://localhost:3000")
public class AuthController {
    
    @Autowired
    private AuthService authService;
    
    @PostMapping("/register")
    public ResponseEntity<?> register(@Valid @RequestBody AuthRequestDTO request) {
        String token = authService.register(request.getUsername(), request.getPassword(), request.getEmail());
        return ResponseEntity.ok(new AuthResponseDTO(token, request.getUsername(), "ROLE_USER", "Registration successful"));
    }
    
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody AuthRequestDTO request) {
        // Only use username and password for login
        String token = authService.login(request.getUsername(), request.getPassword());
        return ResponseEntity.ok(new AuthResponseDTO(token, request.getUsername(), "ROLE_USER", "Login successful"));
    }
}