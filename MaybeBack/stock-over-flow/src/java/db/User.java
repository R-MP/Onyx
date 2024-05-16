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
public class User {
    private String userEmail;
    private String userName;
    private String userRole;
    private Boolean userVerified;
    private String userToken;
    
    public static String getCreateStatement() {
        return "CREATE TABLE IF NOT EXISTS user("
                + "userEmail VARCHAR(50) UNIQUE NOT NULL,"
                + "userName VARCHAR(200) NOT NULL,"
                + "userRole VARCHAR(20) NOT NULL,"
                + "userPassword LONG NOT NULL,"
                + "userVerified BIT,"
                + "userToken VARCHAR(8)"
                + ")";
    }
    
    public static String getDestroyStatement() {
        return "DROP TABLE IF EXISTS user";
    }
    
    public static ArrayList<User> getUsers() throws Exception {
        ArrayList<User> list = new ArrayList<>();
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM user");
        while(rs.next()) {
            String userEmail = rs.getString("userEmail");
            String userName = rs.getString("userName");
            String userRole = rs.getString("userRole");
            Boolean userVerified = rs.getBoolean("userVerified");
            String userToken = rs.getString("userToken");
            list.add(new User(userEmail, userName, userRole, userVerified, userToken));
        }
        rs.close();
        stmt.close();
        con.close();
        return list;
    }
    
    public static User getUser(String userEmail, String userPassword) throws Exception {
        User gotUser = null;
        Connection con = DbListener.getConnection();
        String sql = "SELECT * FROM user WHERE userEmail = ? AND userPassword = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, userEmail);
        stmt.setLong(2, userPassword.hashCode());
        ResultSet rs = stmt.executeQuery();
        if(rs.next()) {
            String userName = rs.getString("userName");
            String userRole = rs.getString("userRole");
            Boolean userVerified = rs.getBoolean("userVerified");
            String userToken = rs.getString("userToken");
            gotUser = new User(userEmail, userName, userRole, userVerified, userToken);
        }
        stmt.close();
        con.close();
        rs.close();
        return gotUser;
    }
    
    public static void insertUser(String userEmail, String userName, String userRole, String userPassword, Boolean userVerified, String userToken) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "INSERT INTO user( userEmail, userName, userRole, userPassword, userVerified, userToken) "
                + "VALUES(?, ?, ?, ?, ?, ?)";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, userEmail);
        stmt.setString(2, userName); 
        stmt.setString(3, userRole);
        stmt.setLong(4, userPassword.hashCode());
        stmt.setBoolean(5, userVerified);
        stmt.setString(6, userToken);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void alterUser(String userEmail, String userName, String userRole, String userPassword) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "UPDATE user SET userName = ?, userRole = ?, userPassword = ? "
                + "WHERE userEmail = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, userName); 
        stmt.setString(2, userRole);
        stmt.setLong(3, userPassword.hashCode());
        stmt.setString(4, userEmail);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void deleteUser(String userEmail) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "DELETE FROM user WHERE userEmail = ? AND userRole <> 'admin'";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, userEmail);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void changePassword(String userEmail, String userPassword) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "UPDATE user SET userPassword = ? WHERE userEmail = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setLong(1, userPassword.hashCode());
        stmt.setString(2, userEmail);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void changeStatus(String userEmail) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "UPDATE user SET userVerified = ? WHERE userEmail = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setBoolean(1, true);
        stmt.setString(2, userEmail);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static ArrayList<User> getPageOrderBy(int offSet, String byOrder, String bySearch) throws Exception {
        ArrayList<User> list = new ArrayList<>();
        Connection con = DbListener.getConnection();
        String sql = "SELECT * FROM user";
        String src = "";
        String ord = "";

        if (byOrder != "" && byOrder != null) {
            ord = " ORDER BY " + byOrder;
        }
        if (bySearch != "" && bySearch != null) {
            src = " WHERE userEmail LIKE ? OR userName LIKE ?"
                    + " OR userRole LIKE ? OR userVerified LIKE ?"
                    + " OR userToken LIKE ?";

        }
        sql = sql + src + ord + " LIMIT 10 OFFSET ?";

        PreparedStatement stmt = con.prepareStatement(sql);

        if (bySearch != "" && bySearch != null) {

            stmt.setString(1, "%"+bySearch+"%");
            stmt.setString(2, "%"+bySearch+"%");
            stmt.setString(3, "%"+bySearch+"%");
            stmt.setString(4, "%"+bySearch+"%");
            stmt.setString(5, "%"+bySearch+"%");
            
            stmt.setInt(6, offSet);

        } else {
            stmt.setInt(1, offSet);
        }
        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            String userEmail = rs.getString("userEmail");
            String userName = rs.getString("userName");
            String userRole = rs.getString("userRole");
            Boolean userVerified = rs.getBoolean("userVerified");
            String userToken = rs.getString("userToken");
            list.add(new User(userEmail, userName, userRole, userVerified, userToken));
        }
        rs.close();
        stmt.close();
        con.close();
        return list;
    }
    
    public static int getSearchPage(String bySearch) throws Exception {
        int pgCount = 0;
        Connection con = DbListener.getConnection();
        String sql = "SELECT COUNT(*) FROM user"
                   + " WHERE userEmail LIKE ? OR userName LIKE ?"
                   + " OR userRole LIKE ? OR userVerified LIKE ?"
                   + " OR userToken LIKE ?";

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
        int allUser = 0;
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM user");

        allUser = rs.getInt("COUNT(*)");

        rs.close();
        stmt.close();
        con.close();
        return allUser;
    }

     public User(String userEmail, String userName, String userRole, Boolean userVerified, String userToken) {
        this.userEmail = userEmail;
        this.userName = userName;
        this.userRole = userRole;
        this.userVerified = userVerified;
        this.userToken = userToken;
    }

    public String getUserRole() {
        return userRole;
    }

    public void setUserRole(String userRole) {
        this.userRole = userRole;
    }

    public String getUserEmail() {
        return userEmail.replaceAll("\"","&quot");
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public String getUserName() {
        return userName.replaceAll("\"","&quot");
    }

    public void setName(String userName) {
        this.userName = userName;
    }
    
    public Boolean getUserVerified() {
        return userVerified;
    }
     
    public void setUserVerified(Boolean userVerified) {
        this.userVerified = userVerified;
    }
     
    public String getUserToken() {
        return userToken;
    }
     
    public void setUserToken(String userToken) throws Exception {
        this.userToken = userToken;
    }
 
}
