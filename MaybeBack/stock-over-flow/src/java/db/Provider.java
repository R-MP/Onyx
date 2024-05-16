/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import web.DbListener;

/**
 *
 * @author spbry
 */
public class Provider {
    private String provName;
    private String provLocation;
    private String provTelephone;
    private String provMail;
    
    public static String getCreateStatement() {
        return "CREATE TABLE IF NOT EXISTS provider("
                + "provName VARCHAR(50) UNIQUE NOT NULL,"
                + "provLocation VARCHAR(100),"
                + "provTelephone VARCHAR(15),"
                + "provMail VARCHAR(100)"
                + ")";
    }
    
    public static String getDestroyStatement() {
        return "DROP TABLE IF EXISTS provider";
    }
    
    public static ArrayList<Provider> getProviders() throws Exception {
        ArrayList<Provider> list = new ArrayList<>();
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM provider");
        while(rs.next()) {
            String provName = rs.getString("provName");
            String provLocation = rs.getString("provLocation");
            String provTelephone = rs.getString("provTelephone");
            String provMail = rs.getString("provMail");
            list.add(new Provider(provName, provLocation, provTelephone, provMail));
        }
        rs.close();
        stmt.close();
        con.close();
        return list;
    }
    
    public static void insertProvider(String provName, String provLocation, String provTelephone, String provMail) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "INSERT INTO provider(provName, provLocation, provTelephone, provMail) "
                + "VALUES(?, ?, ?, ?)";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, provName);
        stmt.setString(2, provLocation);
        stmt.setString(3, provTelephone);
        stmt.setString(4, provMail);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void alterProvider(String oldProvName, String provName, String provLocation, String provTelephone, String provMail) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "UPDATE provider SET provName = ?, provLocation = ?, provTelephone = ?, provMail = ? "
                + "WHERE provName = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, provName); 
        stmt.setString(2, provLocation);
        stmt.setString(3, provTelephone);
        stmt.setString(4, provMail);
        stmt.setString(5, oldProvName);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void deleteProvider(String provName) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "DELETE FROM provider WHERE provName = ? ";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, provName);
        stmt.execute();
        stmt.close();
        con.close();
    }

    public static ArrayList<String> getProvNames() throws Exception {
        ArrayList<String> provList = new ArrayList<>();
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT provName FROM provider");
        while(rs.next()) {
            String provName = rs.getString("provName");
            provList.add(provName);
        }
        rs.close();
        stmt.close();
        con.close();
        return provList;
    }
    
    public static ArrayList<Provider> getPageOrderBy(int offSet, String byOrder, String bySearch) throws Exception {
        ArrayList<Provider> list = new ArrayList<>();
        Connection con = DbListener.getConnection();
        String sql = "SELECT * FROM provider";
        String src = "";
        String ord = "";

        if (byOrder != "" && byOrder != null) {
            ord = " ORDER BY " + byOrder;
        }
        if (bySearch != "" && bySearch != null) {
            src = " WHERE provName LIKE ? OR provLocation LIKE ?"
                + " OR provTelephone LIKE ? OR provMail LIKE ?";
        }
        sql = sql + src + ord + " LIMIT 10 OFFSET ?";

        PreparedStatement stmt = con.prepareStatement(sql);

        if (bySearch != "" && bySearch != null) {

            stmt.setString(1, "%"+bySearch+"%");
            stmt.setString(2, "%"+bySearch+"%");
            stmt.setString(3, "%"+bySearch+"%");
            stmt.setString(4, "%"+bySearch+"%");
            
            stmt.setInt(5, offSet);

        } else {
            stmt.setInt(1, offSet);
        }
        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            String provName = rs.getString("provName");
            String provLocation = rs.getString("provLocation");
            String provTelephone = rs.getString("provTelephone");
            String provMail = rs.getString("provMail");
            
            list.add(new Provider(provName, provLocation, provTelephone, provMail));
        }
        rs.close();
        stmt.close();
        con.close();
        return list;
    }
    
    public static int getSearchPage(String bySearch) throws Exception {
        int pgCount = 0;
        Connection con = DbListener.getConnection();
        String sql = "SELECT COUNT(*) FROM provider"
                   + " WHERE provName LIKE ? OR provLocation LIKE ?"
                   + " OR provTelephone LIKE ? OR provMail LIKE ?";

        PreparedStatement stmt = con.prepareStatement(sql);
        
        stmt.setString(1, "%"+bySearch+"%");
        stmt.setString(2, "%"+bySearch+"%");
        stmt.setString(3, "%"+bySearch+"%");
        stmt.setString(4, "%"+bySearch+"%");

        ResultSet rs = stmt.executeQuery();
        pgCount = rs.getInt("COUNT(*)");
        rs.close();
        stmt.close();
        con.close();
        return pgCount;
    }
    
    public static int getAll() throws Exception {
        int allProv = 0;
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM provider");

        allProv = rs.getInt("COUNT(*)");

        rs.close();
        stmt.close();
        con.close();
        return allProv;
    }
    
    public static Integer getProvQnt(String provName) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "SELECT SUM(movQnt) FROM movement WHERE movProv=?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, provName);
        ResultSet rs = stmt.executeQuery();
        Integer provQnt = rs.getInt("SUM(movQnt)"); 
        stmt.close();
        con.close();
        rs.close();
        return provQnt;
    }
    
    public Provider(String provName, String provLocation, String provTelephone, String provMail) {
        this.provName = provName;
        this.provLocation = provLocation;
        this.provTelephone = provTelephone;
        this.provMail = provMail;
    }

    public String getProvName() {
        return provName.replaceAll("\"","&quot");
    }

    public String getProvLocation() {
        return provLocation.replaceAll("\"","&quot");
    }

    public String getProvTelephone() {
        return provTelephone.replaceAll("\"","&quot");
    }

    public String getProvMail() {
        return provMail.replaceAll("\"","&quot");
    }

    public void setProvName(String provName) {
        this.provName = provName;
    }

    public void setProvLocation(String provLocation) {
        this.provLocation = provLocation;
    }

    public void setProvTelephone(String provTelephone) {
        this.provTelephone = provTelephone;
    }
    
    public void setProvMail(String provMail) {
        this.provMail = provMail;
    }

}
