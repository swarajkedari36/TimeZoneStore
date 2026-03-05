package com.timezone.util;

import java.sql.Connection;

public class TestConnection {
    public static void main(String[] args) throws Exception {
        Connection con = DBConnection.getConnection();
        if(con != null) {
            System.out.println("Database Connected Successfully!");
        }
    }
}