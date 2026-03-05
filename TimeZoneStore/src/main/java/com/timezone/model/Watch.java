/*
 * package com.timezone.model;
 * 
 * public class Watch {
 * 
 * private int id; private String name; private String brand; private double
 * price; private String image; private String description;
 * 
 * private int quantity = 1; // ⭐ ADD THIS
 * 
 * public Watch() {}
 * 
 * public Watch(int id, String name, String brand, double price, String image,
 * String description) { this.id = id; this.name = name; this.brand = brand;
 * this.price = price; this.image = image; this.description = description;
 * this.quantity = 1; // ⭐ DEFAULT 1 }
 * 
 * public int getId() { return id; } public void setId(int id) { this.id = id; }
 * 
 * public String getName() { return name; } public void setName(String name) {
 * this.name = name; }
 * 
 * public String getBrand() { return brand; } public void setBrand(String brand)
 * { this.brand = brand; }
 * 
 * public double getPrice() { return price; } public void setPrice(double price)
 * { this.price = price; }
 * 
 * public String getImage() { return image; } public void setImage(String image)
 * { this.image = image; }
 * 
 * public String getDescription() { return description; } public void
 * setDescription(String description) { this.description = description; }
 * 
 * // ⭐ NEW METHODS public int getQuantity() { return quantity; } public void
 * setQuantity(int quantity) { this.quantity = quantity; } }
 */


package com.timezone.model;

public class Watch {

    private int id;
    private String name;
    private String brand;
    private double price;
    private String image;
    private String description;
    private String category;  // ⭐ NEW FIELD
    private int quantity = 1;

    public Watch() {}

    // Updated constructor with category
    public Watch(int id, String name, String brand, double price, String image, String description, String category) {
        this.id = id;
        this.name = name;
        this.brand = brand;
        this.price = price;
        this.image = image;
        this.description = description;
        this.category = category;
        this.quantity = 1;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    // ⭐ NEW Getter/Setter for category
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}