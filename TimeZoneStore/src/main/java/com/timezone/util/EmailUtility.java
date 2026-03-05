package com.timezone.util;

import java.util.Properties;
import java.io.InputStream;
import javax.mail.*;
import javax.mail.internet.*;

public class EmailUtility {
    
    private static String HOST;
    private static String PORT;
    private static String USERNAME;
    private static String PASSWORD;
    private static String FROM;
    private static String FROM_NAME;
    
    static {
        try {
            Properties props = new Properties();
            InputStream input = EmailUtility.class.getClassLoader().getResourceAsStream("email.properties");
            
            if (input == null) {
                System.err.println("email.properties not found, using defaults");
                // Fallback defaults - REPLACE WITH YOUR ACTUAL CREDENTIALS
                HOST = "smtp.gmail.com";
                PORT = "587";
                USERNAME = "contact.timezonewatches@gmail.com";
                PASSWORD = "zya ehvr nwpw vlim"; // Replace with actual app password
                FROM = "contact.timezonewatches@gmail.com";
                FROM_NAME = "TimeZone Watches";
            } else {
                props.load(input);
                HOST = props.getProperty("mail.smtp.host");
                PORT = props.getProperty("mail.smtp.port");
                USERNAME = props.getProperty("mail.username");
                PASSWORD = props.getProperty("mail.password");
                FROM = props.getProperty("mail.from");
                FROM_NAME = props.getProperty("mail.from.name");
                input.close();
                System.out.println("Email configuration loaded successfully");
            }
        } catch (Exception e) {
            System.err.println("Error loading email config: " + e.getMessage());
            e.printStackTrace();
        }
    }
//    
//    public static boolean sendEmail(String toEmail, String subject, String htmlContent) {
//        System.out.println("Attempting to send email to: " + toEmail);
//        System.out.println("Using account: " + USERNAME);
//        
//        Properties props = new Properties();
//        props.put("mail.smtp.host", HOST);
//        props.put("mail.smtp.port", PORT);
//        props.put("mail.smtp.auth", "true");
//        props.put("mail.smtp.starttls.enable", "true");
//        props.put("mail.debug", "true"); // Enable debug to see what's happening
//        
//        Session session = Session.getInstance(props, new Authenticator() {
//            protected PasswordAuthentication getPasswordAuthentication() {
//                return new PasswordAuthentication(USERNAME, PASSWORD);
//            }
//        });
//        session.setDebug(true); // Print debug info to console
//        
//        try {
//            Message message = new MimeMessage(session);
//            message.setFrom(new InternetAddress(FROM, FROM_NAME));
//            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
//            message.setSubject(subject);
//            
//            // Set HTML content
//            MimeBodyPart mimeBodyPart = new MimeBodyPart();
//            mimeBodyPart.setContent(htmlContent, "text/html; charset=utf-8");
//            
//            Multipart multipart = new MimeMultipart();
//            multipart.addBodyPart(mimeBodyPart);
//            
//            message.setContent(multipart);
//            
//            Transport.send(message);
//            System.out.println("✅ Email sent successfully to: " + toEmail);
//            return true;
//            
//        } catch (Exception e) {
//            System.out.println("❌ Error sending email: " + e.getMessage());
//            e.printStackTrace();
//            return false;
//        }
//    }
    public static boolean sendEmail(String toEmail, String subject, String htmlContent) {
        System.out.println("Attempting to send email to: " + toEmail);
        System.out.println("Using account: " + USERNAME);
        
        Properties props = new Properties();
        props.put("mail.smtp.host", HOST);
        props.put("mail.smtp.port", PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        
        // Create session with authenticator
        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(USERNAME, PASSWORD);
            }
        });
        
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM, FROM_NAME));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            
            // Set HTML content
            MimeBodyPart mimeBodyPart = new MimeBodyPart();
            mimeBodyPart.setContent(htmlContent, "text/html; charset=utf-8");
            
            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(mimeBodyPart);
            
            message.setContent(multipart);
            
            Transport.send(message);
            System.out.println("✅ Email sent successfully to: " + toEmail);
            return true;
            
        } catch (Exception e) {
            System.out.println("❌ Error sending email: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // ============= EMAIL TEMPLATES =============
    
    /**
     * Welcome email template for new registrations
     */
    public static String getWelcomeEmailTemplate(String userName) {
        return "<!DOCTYPE html>" +
            "<html>" +
            "<head>" +
            "<style>" +
            "body { font-family: 'Inter', sans-serif; background: #f5f5f5; margin: 0; padding: 20px; }" +
            ".container { max-width: 600px; margin: 0 auto; background: white; border-radius: 15px; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.1); }" +
            ".header { background: #c9a959; padding: 30px; text-align: center; }" +
            ".header h1 { color: #000; margin: 0; font-size: 32px; }" +
            ".content { padding: 40px 30px; }" +
            ".button { display: inline-block; background: #c9a959; color: #000; padding: 12px 30px; text-decoration: none; border-radius: 50px; font-weight: 600; margin-top: 20px; }" +
            ".footer { background: #f0f0f0; padding: 20px; text-align: center; color: #666; font-size: 14px; }" +
            "</style>" +
            "</head>" +
            "<body>" +
            "<div class='container'>" +
            "<div class='header'>" +
            "<h1>⌚ TimeZone</h1>" +
            "</div>" +
            "<div class='content'>" +
            "<h2>Welcome to TimeZone, " + userName + "!</h2>" +
            "<p>Thank you for joining the TimeZone community. We're thrilled to have you with us.</p>" +
            "<p>Now you can:</p>" +
            "<ul>" +
            "<li>Browse our exclusive collection of premium watches</li>" +
            "<li>Save your favorite timepieces to wishlist</li>" +
            "<li>Track your orders in real-time</li>" +
            "<li>Get personalized recommendations</li>" +
            "</ul>" +
            "<p>Ready to find your perfect timepiece?</p>" +
            "<a href='http://localhost:8080/TimeZoneStore/products' class='button'>Start Shopping</a>" +
            "</div>" +
            "<div class='footer'>" +
            "<p>&copy; 2026 TimeZone Watches. All rights reserved.</p>" +
            "</div>" +
            "</div>" +
            "</body>" +
            "</html>";
    }
    
    /**
     * Order confirmation email template
     */
    public static String getOrderConfirmationEmailTemplate(String userName, String orderNumber, double total, String estimatedDelivery) {
        return "<!DOCTYPE html>" +
            "<html>" +
            "<head>" +
            "<style>" +
            "body { font-family: 'Inter', sans-serif; background: #f5f5f5; margin: 0; padding: 20px; }" +
            ".container { max-width: 600px; margin: 0 auto; background: white; border-radius: 15px; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.1); }" +
            ".header { background: #c9a959; padding: 30px; text-align: center; }" +
            ".header h1 { color: #000; margin: 0; font-size: 32px; }" +
            ".content { padding: 40px 30px; }" +
            ".order-details { background: #f9f9f9; padding: 20px; border-radius: 10px; margin: 20px 0; }" +
            ".order-number { font-size: 24px; color: #c9a959; font-weight: 600; }" +
            ".button { display: inline-block; background: #c9a959; color: #000; padding: 12px 30px; text-decoration: none; border-radius: 50px; font-weight: 600; margin-top: 20px; }" +
            ".footer { background: #f0f0f0; padding: 20px; text-align: center; color: #666; font-size: 14px; }" +
            "</style>" +
            "</head>" +
            "<body>" +
            "<div class='container'>" +
            "<div class='header'>" +
            "<h1>⌚ TimeZone</h1>" +
            "</div>" +
            "<div class='content'>" +
            "<h2>Thank You for Your Order, " + userName + "!</h2>" +
            "<p>Your order has been placed successfully and is being processed.</p>" +
            "<div class='order-details'>" +
            "<p><strong>Order Number:</strong> <span class='order-number'>" + orderNumber + "</span></p>" +
            "<p><strong>Total Amount:</strong> ₹" + String.format("%,d", (int)total) + "</p>" +
            "<p><strong>Estimated Delivery:</strong> " + estimatedDelivery + "</p>" +
            "</div>" +
            "<p>You can track your order status in real-time:</p>" +
            "<a href='http://localhost:8080/TimeZoneStore/track-order?orderNumber=" + orderNumber + "' class='button'>Track Order</a>" +
            "</div>" +
            "<div class='footer'>" +
            "<p>&copy; 2026 TimeZone Watches. All rights reserved.</p>" +
            "</div>" +
            "</div>" +
            "</body>" +
            "</html>";
    }
    
    /**
     * Password reset email template
     */
    public static String getPasswordResetEmailTemplate(String userName, String resetLink) {
        return "<!DOCTYPE html>" +
            "<html>" +
            "<head>" +
            "<style>" +
            "body { font-family: 'Inter', sans-serif; background: #f5f5f5; margin: 0; padding: 20px; }" +
            ".container { max-width: 600px; margin: 0 auto; background: white; border-radius: 15px; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.1); }" +
            ".header { background: #c9a959; padding: 30px; text-align: center; }" +
            ".header h1 { color: #000; margin: 0; font-size: 32px; }" +
            ".content { padding: 40px 30px; }" +
            ".button { display: inline-block; background: #c9a959; color: #000; padding: 12px 30px; text-decoration: none; border-radius: 50px; font-weight: 600; margin: 20px 0; }" +
            ".footer { background: #f0f0f0; padding: 20px; text-align: center; color: #666; font-size: 14px; }" +
            ".warning { color: #666; font-size: 14px; }" +
            "</style>" +
            "</head>" +
            "<body>" +
            "<div class='container'>" +
            "<div class='header'>" +
            "<h1>⌚ TimeZone</h1>" +
            "</div>" +
            "<div class='content'>" +
            "<h2>Password Reset Request</h2>" +
            "<p>Hello " + userName + ",</p>" +
            "<p>We received a request to reset your password. Click the button below to create a new password:</p>" +
            "<a href='" + resetLink + "' class='button'>Reset Password</a>" +
            "<p class='warning'>This link will expire in 1 hour.</p>" +
            "<p>If you didn't request this, please ignore this email or contact support.</p>" +
            "</div>" +
            "<div class='footer'>" +
            "<p>&copy; 2026 TimeZone Watches. All rights reserved.</p>" +
            "</div>" +
            "</div>" +
            "</body>" +
            "</html>";
    }
    
    /**
     * Shipping update email template
     */
    public static String getShippingUpdateEmailTemplate(String userName, String orderNumber, String status, String trackingNumber) {
        return "<!DOCTYPE html>" +
            "<html>" +
            "<head>" +
            "<style>" +
            "body { font-family: 'Inter', sans-serif; background: #f5f5f5; margin: 0; padding: 20px; }" +
            ".container { max-width: 600px; margin: 0 auto; background: white; border-radius: 15px; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.1); }" +
            ".header { background: #c9a959; padding: 30px; text-align: center; }" +
            ".header h1 { color: #000; margin: 0; font-size: 32px; }" +
            ".content { padding: 40px 30px; }" +
            ".status-badge { background: #c9a959; color: #000; padding: 8px 20px; border-radius: 50px; display: inline-block; font-weight: 600; }" +
            ".tracking-number { background: #f0f0f0; padding: 15px; border-radius: 10px; font-size: 18px; margin: 20px 0; }" +
            ".button { display: inline-block; background: #c9a959; color: #000; padding: 12px 30px; text-decoration: none; border-radius: 50px; font-weight: 600; }" +
            ".footer { background: #f0f0f0; padding: 20px; text-align: center; color: #666; font-size: 14px; }" +
            "</style>" +
            "</head>" +
            "<body>" +
            "<div class='container'>" +
            "<div class='header'>" +
            "<h1>⌚ TimeZone</h1>" +
            "</div>" +
            "<div class='content'>" +
            "<h2>Your Order Has Been " + status + "!</h2>" +
            "<p>Hello " + userName + ",</p>" +
            "<p>Great news! Your order <strong>" + orderNumber + "</strong> has been " + status.toLowerCase() + ".</p>" +
            "<div class='status-badge'>" + status + "</div>" +
            (trackingNumber != null ? 
            "<div class='tracking-number'>📦 Tracking Number: " + trackingNumber + "</div>" : "") +
            "<p>Track your order in real-time:</p>" +
            "<a href='http://localhost:8080/TimeZoneStore/track-order?orderNumber=" + orderNumber + "' class='button'>Track Order</a>" +
            "</div>" +
            "<div class='footer'>" +
            "<p>&copy; 2026 TimeZone Watches. All rights reserved.</p>" +
            "</div>" +
            "</div>" +
            "</body>" +
            "</html>";
    }
}