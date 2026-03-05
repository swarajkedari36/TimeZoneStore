/*
 * package com.timezone.dao;
 * 
 * import java.sql.Connection; import java.sql.PreparedStatement; import
 * java.sql.ResultSet; import java.util.ArrayList; import java.util.List;
 * 
 * import com.timezone.model.Watch; import com.timezone.util.DBConnection;
 * 
 * public class WatchDAO {
 * 
 * public List<Watch> getAllWatches() {
 * 
 * List<Watch> list = new ArrayList<>();
 * 
 * try { Connection con = DBConnection.getConnection();
 * 
 * String query = "SELECT * FROM watches"; PreparedStatement ps =
 * con.prepareStatement(query);
 * 
 * ResultSet rs = ps.executeQuery();
 * 
 * while (rs.next()) { Watch watch = new Watch( rs.getInt("id"),
 * rs.getString("name"), rs.getString("brand"), rs.getDouble("price"),
 * rs.getString("image"), rs.getString("description") );
 * 
 * list.add(watch); }
 * 
 * con.close();
 * 
 * } catch (Exception e) { e.printStackTrace(); }
 * 
 * return list; } public Watch getWatchById(int id) {
 * 
 * Watch watch = null;
 * 
 * try { Connection con = DBConnection.getConnection();
 * 
 * String query = "SELECT * FROM watches WHERE id = ?"; PreparedStatement ps =
 * con.prepareStatement(query); ps.setInt(1, id);
 * 
 * ResultSet rs = ps.executeQuery();
 * 
 * if (rs.next()) { watch = new Watch(); watch.setId(rs.getInt("id"));
 * watch.setName(rs.getString("name")); watch.setBrand(rs.getString("brand"));
 * watch.setPrice(rs.getDouble("price")); watch.setImage(rs.getString("image"));
 * watch.setDescription(rs.getString("description")); }
 * 
 * } catch (Exception e) { e.printStackTrace(); }
 * 
 * return watch; } }
 */

package com.timezone.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.timezone.model.Watch;
import com.timezone.util.DBConnection;

public class WatchDAO {

    public List<Watch> getAllWatches() {

        List<Watch> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();

            // Updated query to include category
            String query = "SELECT id, name, brand, price, image, description, category FROM watches";
            PreparedStatement ps = con.prepareStatement(query);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Watch watch = new Watch(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("brand"),
                        rs.getDouble("price"),
                        rs.getString("image"),
                        rs.getString("description"),
                        rs.getString("category")  // ⭐ NEW: category from database
                );

                list.add(watch);
            }

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    public Watch getWatchById(int id) {
        Watch watch = null;
        
        try {
            Connection con = DBConnection.getConnection();
            
            String query = "SELECT id, name, brand, price, image, description, category FROM watches WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, id);
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                watch = new Watch();
                watch.setId(rs.getInt("id"));
                watch.setName(rs.getString("name"));
                watch.setBrand(rs.getString("brand"));
                watch.setPrice(rs.getDouble("price"));
                watch.setImage(rs.getString("image"));
                watch.setDescription(rs.getString("description"));
                
                // If you've added category column
                try {
                    watch.setCategory(rs.getString("category"));
                } catch (Exception e) {
                    // Category column might not exist yet
                    watch.setCategory("Luxury");
                }
            }
            
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return watch;
    }
    
    // ⭐ NEW: Method to get watches by category
    public List<Watch> getWatchesByCategory(String category) {
        
        List<Watch> list = new ArrayList<>();
        
        try {
            Connection con = DBConnection.getConnection();
            
            String query = "SELECT id, name, brand, price, image, description, category FROM watches WHERE LOWER(category) = LOWER(?)";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, category);
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Watch watch = new Watch(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("brand"),
                        rs.getDouble("price"),
                        rs.getString("image"),
                        rs.getString("description"),
                        rs.getString("category")
                );
                list.add(watch);
            }
            
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return list;
    }
    
    // ⭐ NEW: Method to get all unique categories
    public List<String> getAllCategories() {
        
        List<String> categories = new ArrayList<>();
        
        try {
            Connection con = DBConnection.getConnection();
            
            String query = "SELECT DISTINCT category FROM watches WHERE category IS NOT NULL ORDER BY category";
            PreparedStatement ps = con.prepareStatement(query);
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                categories.add(rs.getString("category"));
            }
            
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return categories;
    }
}