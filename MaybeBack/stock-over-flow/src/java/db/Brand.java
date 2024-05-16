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
public class Brand {

    private String brandName;
    private String brandDesc;
    
    public static String getCreateStatement() {
        return "CREATE TABLE IF NOT EXISTS brand("
                + "brandName VARCHAR(50) UNIQUE NOT NULL,"
                + "brandDesc VARCHAR(1000)"
                + ")";
    }
    
    public static String getDestroyStatement() {
        return "DROP TABLE IF EXISTS brand";
    }
    
    public static ArrayList<Brand> getBrands() throws Exception {
        ArrayList<Brand> list = new ArrayList<>();
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM brand");
        while(rs.next()) {
            String brandName = rs.getString("brandName");
            String brandDesc = rs.getString("brandDesc");
            list.add(new Brand(brandName, brandDesc));
        }
        rs.close();
        stmt.close();
        con.close();
        return list;
    }
    
    public static void insertBrand(String brandName, String brandDesc) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "INSERT INTO brand(brandName, brandDesc) "
                + "VALUES(?, ?)";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, brandName);
        stmt.setString(2, brandDesc);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void alterBrand(String oldBrandName, String brandName, String brandDesc) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "UPDATE brand SET brandName = ?, brandDesc = ? "
                + "WHERE brandName = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, brandName); 
        stmt.setString(2, brandDesc); 
        stmt.setString(3, oldBrandName);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void deleteBrand(String brandName) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "DELETE FROM brand WHERE brandName = ? ";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, brandName);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static ArrayList<String> getBrandNames() throws Exception {
        ArrayList<String> brandList = new ArrayList<>();
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT brandName FROM brand");
        while(rs.next()) {
            String brandName = rs.getString("brandName");
            brandList.add(brandName);
        }
        rs.close();
        stmt.close();
        con.close();
        return brandList;
    }
    
    public static ArrayList<Brand> getPageOrderBy(int offSet, String byOrder, String bySearch) throws Exception {
        ArrayList<Brand> list = new ArrayList<>();
        Connection con = DbListener.getConnection();
        String sql = "SELECT * FROM brand";
        String src = "";
        String ord = "";

        if (byOrder != "" && byOrder != null) {
            ord = " ORDER BY " + byOrder;
        }
        if (bySearch != "" && bySearch != null) {
            src = " WHERE brandName LIKE ? OR brandDesc LIKE ?";
        }
        sql = sql + src + ord + " LIMIT 10 OFFSET ?";

        PreparedStatement stmt = con.prepareStatement(sql);

        if (bySearch != "" && bySearch != null) {

            stmt.setString(1, "%"+bySearch+"%");
            stmt.setString(2, "%"+bySearch+"%");
            
            stmt.setInt(3, offSet);

        } else {
            stmt.setInt(1, offSet);
        }
        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            String brandName = rs.getString("brandName");
            String brandDesc = rs.getString("brandDesc");
            
            list.add(new Brand(brandName, brandDesc));
        }
        rs.close();
        stmt.close();
        con.close();
        return list;
    }
    
    public static int getSearchPage(String bySearch) throws Exception {
        int pgCount = 0;
        Connection con = DbListener.getConnection();
        String sql = "SELECT COUNT(*) FROM brand"
                   + " WHERE brandName LIKE ? OR brandDesc LIKE ?";

        PreparedStatement stmt = con.prepareStatement(sql);
        
        stmt.setString(1, "%"+bySearch+"%");
        stmt.setString(2, "%"+bySearch+"%");

        ResultSet rs = stmt.executeQuery();
        pgCount = rs.getInt("COUNT(*)");
        rs.close();
        stmt.close();
        con.close();
        return pgCount;
    }

    public static int getAll() throws Exception {
        int allBrand = 0;
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM brand");

        allBrand = rs.getInt("COUNT(*)");

        rs.close();
        stmt.close();
        con.close();
        return allBrand;
    }

    public Brand(String brandName, String brandDesc) {
        this.brandName = brandName;
        this.brandDesc = brandDesc;
    }

    public String getBrandName() {
        return brandName.replaceAll("\"","&quot");
    }
    
    public String getBrandDesc() {
        return brandDesc.replaceAll("\"","&quot");
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }
    
    public void setBrandDesc(String brandDesc) {
        this.brandDesc = brandDesc;
    }

}