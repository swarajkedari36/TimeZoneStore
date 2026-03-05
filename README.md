# ⌚ TimeZone Watch Store

A full-featured e-commerce web application for premium watches built with Java JSP, Servlets, and MySQL.

## 🚀 Features

### 👤 User Features
- **User Authentication** - Register, login, password reset via email
- **Product Catalog** - Browse watches with category filtering
- **Product Details** - View detailed information with images
- **Shopping Cart** - Add/remove items, update quantities
- **Wishlist** - Save favorite watches for later
- **Order Management** - Place orders, view order history
- **Order Tracking** - Real-time shipment tracking with status updates
- **Reviews & Ratings** - Rate and review purchased watches
- **User Profile** - Manage personal information and addresses

### 👑 Admin Features
- **Admin Dashboard** - Overview of sales, orders, and users
- **Product Management** - Add, edit, delete watches with image upload
- **Order Management** - View and update order status, add tracking info
- **User Management** - View and manage registered users
- **Review Moderation** - Approve, reject, or delete reviews
- **Sales Reports** - Visual charts and analytics for sales data

### 📧 Email Notifications
- Welcome emails on registration
- Order confirmation emails
- Password reset emails
- HTML email templates with branding

---

## 🛠️ Technology Stack

| Technology | Purpose |
|------------|---------|
| **Java 17** | Core programming language |
| **JSP & Servlets** | Web layer (MVC architecture) |
| **MySQL** | Database |
| **Bootstrap 5** | Frontend styling |
| **Font Awesome** | Icons |
| **Chart.js** | Sales analytics charts |
| **JavaMail API** | Email notifications |
| **Gson** | JSON processing |
| **Apache Tomcat 10** | Web server |

---

## 🏗️ Project Structure
TimeZoneStore/
├── src/
│ └── main/
│ ├── java/
│ │ └── com/
│ │ └── timezone/
│ │ ├── controller/ # Servlets
│ │ ├── dao/ # Data Access Objects
│ │ ├── model/ # POJO classes
│ │ └── util/ # Utilities (DBConnection, Email)
│ └── webapp/
│ ├── admin/ # Admin JSP files
│ ├── images/ # Product images
│ ├── WEB-INF/ # Web configuration
│ └── .jsp/.html # User-facing pages

text

---

## 🚀 Getting Started

### Prerequisites
- Java JDK 17 or higher
- Apache Tomcat 10
- MySQL 8.0
- Eclipse IDE (or any Java IDE)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/TimeZoneStore.git

