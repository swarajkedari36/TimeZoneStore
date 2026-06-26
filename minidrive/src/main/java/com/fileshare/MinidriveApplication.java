package com.fileshare;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class MinidriveApplication {
    public static void main(String[] args) {
        SpringApplication.run(MinidriveApplication.class, args);
        System.out.println("🚀 Mini Drive Application Started Successfully!");
        System.out.println("📁 File upload directory: uploads/");
        System.out.println("🔗 API Base URL: http://localhost:8080/api");
    }
}