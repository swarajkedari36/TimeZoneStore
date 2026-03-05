package com.timezone.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.timezone.model.User;
import com.timezone.util.DBConnection;

public class UserDAO {

    public boolean registerUser(User user) {

        try {
            Connection con = DBConnection.getConnection();

            String query = "INSERT INTO users(name, email, password) VALUES(?,?,?)";

            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());

            int rows = ps.executeUpdate();

            con.close();

            if (rows > 0) {
                return true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
    
    
    public boolean loginUser(String email, String password) {

        try {
            Connection con = DBConnection.getConnection();

            String query = "SELECT * FROM users WHERE email=? AND password=?";

            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                con.close();
                return true;
            }

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}