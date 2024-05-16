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
public class Product {
    private int prodId;
    private String prodName;
    private String prodBrand;
    private String prodMaterial;
    private String prodSize;
    private Double prodAvg;
    private int prodQnt;
    
    public static String getCreateStatement() {
        return "CREATE TABLE IF NOT EXISTS product("
                + "prodId INTEGER PRIMARY KEY AUTOINCREMENT,"
                + "prodName VARCHAR(200) NOT NULL,"
                + "prodBrand VARCHAR(50),"
                + "prodMaterial VARCHAR(200),"
                + "prodSize VARCHAR(20),"
                + "prodAvg NUMBER(8,2),"
                + "prodQnt INTEGER"
                + ")";
    }
    
    public static String getDestroyStatement() {
        return "DROP TABLE IF EXISTS product";
    }
    
    public static ArrayList<Product> getProds() throws Exception {
        ArrayList<Product> list = new ArrayList<>();
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM product");
        while(rs.next()) {
            Integer prodId = rs.getInt("prodId");
            String prodName = rs.getString("prodName");
            String prodBrand = rs.getString("prodBrand");
            String prodMaterial = rs.getString("prodMaterial");
            String prodSize = rs.getString("prodSize");
            Double prodAvg = rs.getDouble("prodAvg");
            Integer prodQnt = rs.getInt("prodQnt");
            list.add(new Product(prodId, prodName, prodBrand, prodMaterial, prodSize, prodAvg, prodQnt));
        }
        rs.close();
        stmt.close();
        con.close();
        return list;
    }
    
    public static Product getProd(Integer prodId) throws Exception {
        Product prod = null;
        Connection con = DbListener.getConnection();
        String sql = "SELECT * FROM product WHERE prodId=?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, prodId);
        ResultSet rs = stmt.executeQuery();
        if(rs.next()) {
            String prodName = rs.getString("prodName");
            String prodBrand = rs.getString("prodBrand");
            String prodMaterial = rs.getString("prodMaterial");
            String prodSize = rs.getString("prodSize");
            Double prodAvg = rs.getDouble("prodAvg");
            Integer prodQnt = rs.getInt("prodQnt");
            prod = new Product(prodId, prodName, prodBrand, prodMaterial, prodSize, prodAvg, prodQnt);
        }
        stmt.close();
        con.close();
        rs.close();
        return prod;
    }
    
    public static void insertProd(String prodName, String prodBrand,String prodMaterial, String prodSize) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "INSERT INTO product(prodName, prodBrand, prodMaterial, prodSize) "
                + "VALUES(?, ?, ?, ?)";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, prodName); 
        stmt.setString(2, prodBrand); 
        stmt.setString(3, prodMaterial);
        stmt.setString(4, prodSize);
        stmt.execute();
        stmt.close();
        Statement sstmt = con.createStatement();
        ResultSet rs = sstmt.executeQuery("SELECT LAST_INSERT_ROWID();");
        int lastId = rs.getInt("LAST_INSERT_ROWID()");
        sstmt.close();
        sql = "UPDATE product SET prodAvg = ?, prodQnt = ? WHERE prodId = ?";
        PreparedStatement tstmt = con.prepareStatement(sql);
        tstmt.setDouble(1, getAvg(lastId)); 
        tstmt.setInt(2, getQnt(lastId)); 
        tstmt.setInt(3, lastId);
        tstmt.close();
        rs.close();
        con.close();
    }
    
    public static void alterProd(Integer prodId, String prodName, String prodBrand, String prodMaterial, String prodSize) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "UPDATE product SET prodName = ?, prodBrand = ?, prodMaterial = ?, prodSize = ?, prodAvg = ?, prodQnt = ? "
                + "WHERE prodId = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, prodName); 
        stmt.setString(2, prodBrand); 
        stmt.setString(3, prodMaterial);
        stmt.setString(4, prodSize);
        stmt.setDouble(5, getAvg(prodId));
        stmt.setInt(6, getQnt(prodId));
        stmt.setInt(7, prodId);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void deleteProd(Integer prodId) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "DELETE FROM product WHERE prodId = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, prodId);
        stmt.execute();
        stmt.close();
        con.close();
    }

    public static ArrayList<Integer> getProdIds() throws Exception {
        ArrayList<Integer> idList = new ArrayList<>();
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT prodId FROM product");
        while(rs.next()) {
            int prodId = rs.getInt("prodId");
            idList.add(prodId);
        }
        rs.close();
        stmt.close();
        con.close();
        return idList;
    }
    
    public static String getProdNameById(Integer prodId) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "SELECT prodName FROM product WHERE prodId = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, prodId);
        ResultSet rs = stmt.executeQuery();
        String prodName = rs.getString("prodName"); 
        stmt.close();
        con.close();
        rs.close();
        return prodName;
    }
    
    public static int countProds() throws Exception {
        int prodQuantity = 0;
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM product");
        
        prodQuantity = rs.getInt("COUNT(*)");
        
        rs.close();
        stmt.close();
        con.close();
        return prodQuantity;
    }
    
    public static Integer getQnt(Integer movProd) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "SELECT SUM(movQnt) FROM movement WHERE movProd=?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, movProd);
        ResultSet rs = stmt.executeQuery();
        Integer actualQuantity = rs.getInt("SUM(movQnt)");
        stmt.close();
        con.close();
        rs.close();
        return actualQuantity;
    }

    public static double getAvg(Integer movProd) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "SELECT AVG(movValue) FROM movement WHERE movProd=? AND movType = 'Entrada'";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, movProd);
        ResultSet rs = stmt.executeQuery();
        double prodAvgValue = Math.round(rs.getDouble("AVG(movValue)") * 100);
        prodAvgValue = prodAvgValue / 100;
        stmt.close();
        con.close();
        rs.close();
        return prodAvgValue;
    }
    
    public static void updateProd(Integer prodId) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "UPDATE product SET prodAvg = ?, prodQnt = ? "
                + "WHERE prodId = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setDouble(1, getAvg(prodId));
        stmt.setInt(2, getQnt(prodId));
        stmt.setInt(3, prodId);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static ArrayList<Product> getPageOrderBy(int offSet, String byOrder, String bySearch) throws Exception {
        ArrayList<Product> list = new ArrayList<>();
        Connection con = DbListener.getConnection();
        String sql = "SELECT * FROM product";
        String src = "";
        String ord = "";

        if (byOrder != "" && byOrder != null) {
            ord = " ORDER BY " + byOrder;
        }
        if (bySearch != "" && bySearch != null) {
            src = " WHERE prodId LIKE ? OR prodName LIKE ?"
                    + " OR prodBrand LIKE ? OR prodMaterial LIKE ?"
                    + " OR prodSize LIKE ? OR prodAvg LIKE ?"
                    + " OR prodQnt LIKE ? ";

        }
        sql = sql + src + ord + " LIMIT 10 OFFSET ?";

        PreparedStatement stmt = con.prepareStatement(sql);

        if (bySearch != "" && bySearch != null) {

            stmt.setString(1, "%"+bySearch+"%");
            stmt.setString(2, "%"+bySearch+"%");
            stmt.setString(3, "%"+bySearch+"%");
            stmt.setString(4, "%"+bySearch+"%");
            stmt.setString(5, "%"+bySearch+"%");
            stmt.setString(6, "%"+bySearch+"%");
            stmt.setString(7, "%"+bySearch+"%");
            
            stmt.setInt(8, offSet);

        } else {
            stmt.setInt(1, offSet);
        }
        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            int prodId = rs.getInt("prodId");
            String prodName = rs.getString("prodName");
            String prodBrand = rs.getString("prodBrand");
            String prodMaterial = rs.getString("prodMaterial");
            String prodSize = rs.getString("prodSize");
            double prodAvg = rs.getDouble("prodAvg");
            int prodQnt = rs.getInt("prodQnt");
            
            list.add(new Product(prodId, prodName, prodBrand, prodMaterial, prodSize, prodAvg, prodQnt));
        }
        rs.close();
        stmt.close();
        con.close();
        return list;
    }
    
    public static int getSearchPage(String bySearch) throws Exception {
        int pgCount = 0;
        Connection con = DbListener.getConnection();
        String sql = "SELECT COUNT(*) FROM product"
                   + " WHERE prodId LIKE ? OR prodName LIKE ?"
                   + " OR prodBrand LIKE ? OR prodMaterial LIKE ?"
                   + " OR prodSize LIKE ?";

        PreparedStatement stmt = con.prepareStatement(sql);
        
        stmt.setString(1, "%"+bySearch+"%");
        stmt.setString(2, "%"+bySearch+"%");
        stmt.setString(3, "%"+bySearch+"%");
        stmt.setString(4, "%"+bySearch+"%");
        stmt.setString(5, "%"+bySearch+"%");

        ResultSet rs = stmt.executeQuery();
        pgCount = rs.getInt("COUNT(*)");
        rs.close();
        stmt.close();
        con.close();
        return pgCount;
    }

    public static int getAll() throws Exception {
        int allProd = 0;
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM product");

        allProd = rs.getInt("COUNT(*)");

        rs.close();
        stmt.close();
        con.close();
        return allProd;
    }
    
    public Product(Integer prodId, String prodName, String prodBrand, String prodMaterial, String prodSize, Double prodAvg, Integer prodQnt) {
        this.prodId = prodId;
        this.prodName = prodName;
        this.prodBrand = prodBrand;
        this.prodMaterial = prodMaterial;
        this.prodSize = prodSize;
        this.prodAvg = prodAvg;
        this.prodQnt = prodQnt;
    }

    public Integer getProdId() {
        return prodId;
    }

    public void setProdId(Integer prodId) {
        this.prodId = prodId;
    }

    public String getProdName() {
        return prodName.replaceAll("\"","&quot");
    }

    public void setProdName(String prodName) {
        this.prodName = prodName;
    }
    
    public String getProdBrand() {
        return prodBrand;
    }

    public void setProdBrand(String prodBrand) {
        this.prodBrand = prodBrand;
    }
    
    public String getProdMaterial() {
        return prodMaterial.replaceAll("\"","&quot");
    }

    public void setProdMaterial(String prodMaterial) {
        this.prodMaterial = prodMaterial;
    }
    public String getProdSize() {
        return prodSize.replaceAll("\"","&quot");
    }

    public void setProdSize(String prodSize) {
        this.prodSize = prodSize;
    }
    
    public Double getProdAvg() {
        return prodAvg;
    }

    public void setProdAvg(Double prodAvg) {
        this.prodAvg = prodAvg;
    }
    
    public Integer getProdQnt() {
        return prodQnt;
    }

    public void setProdAvg(Integer prodQnt) {
        this.prodQnt = prodQnt;
    }

}
