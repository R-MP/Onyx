/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package web;

import db.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/**
 * Web application lifecycle listener.
 *
 * @author spbry
 */
public class DbListener implements ServletContextListener {
    public static final String CLASS_NAME = "org.sqlite.JDBC";
    public static final String URL = "jdbc:sqlite:stock-13.db";
    
    public static Exception exception = null;
    
    public static Connection getConnection() throws Exception {
        return DriverManager.getConnection(URL);
    }

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            Class.forName(CLASS_NAME);
            Connection con = getConnection();
            Statement stmt = con.createStatement();
            
            stmt.execute(User.getCreateStatement());
            stmt.execute(Product.getCreateStatement());
            stmt.execute(Brand.getCreateStatement());
            stmt.execute(Provider.getCreateStatement());
            stmt.execute(Movement.getCreateStatement());
            
            stmt.close();
            con.close();
            
            if(User.getUsers().isEmpty()) {
            User.insertUser("admin", "Administrador", "Admin", "123", true, "99999999");
            User.insertUser("user", "Funcionario", "Usuario", "123", true, "99999999");
}
            if(Product.getProds().isEmpty()) {
               Product.insertProd("Tênis", "Nike", "Composto", "41/42");
               Product.insertProd("Blusa", "Hering", "Poliester", "G");
               Product.insertProd("Jacquard Tubular Jersey Leggings", "Gucci", "95% Poliamida; 5% Elastano", "M");
               Product.insertProd("Crocs Azul", "Crocs", "Composto", "36");
               Product.insertProd("Bloundie Mini Bag", "Gucci", "Couro", "Ajustável");
               Product.insertProd("Cropped", "Zara", "Composto", "18");
               Product.insertProd("Silk Duchesse Midi-Length", "Gucci", "Seda", "M");
               Product.insertProd("Blusinha Basic", "Zara", "Lã", "18/19/20/21");
               Product.insertProd("Calça Jeans Wide Leg", "Offtrack", "Jeans", "42");
               Product.insertProd("Crocs Roxo", "Crocs", "Composto", "36");
            }
            if(Movement.getMovements().isEmpty()) {
                Movement.insertMovement(1, "Sistema","B F1 Confecções", "Entrada", 40, 99.95, "Entrada de produtos");
                Movement.insertMovement(2, "Sistema","Mario Roupas", "Entrada", 30, 189.93, "Entrada de produtos");
                Movement.insertMovement(9, "Sistema","Offtrack", "Entrada", 30, 36.50, "Entrada de produtos");
                Movement.insertMovement(9, "Sistema","Offtrack", "Saída", -2, 109.92, "Venda");
                Movement.insertMovement(3, "Sistema","Gucci", "Entrada", 10, 1169.99, "Entrada de produtos");
                Movement.insertMovement(4, "Sistema","r7 Calçados", "Entrada", 40, 200.00, "Entrada de produtos");
                Movement.insertMovement(10, "Sistema","Crocs Market", "Entrada", 50, 200.00, "Entrada de produtos");
                Movement.insertMovement(8, "Sistema","CláraCloth", "Saída", -16, 59.99, "Venda");
                Movement.insertMovement(5, "Sistema","Gucci", "Entrada", 5, 6189.99, "Entrada de produtos");
                Movement.insertMovement(4, "Sistema","r7 Calçados", "Saída", -6, 289.99, "Venda");
                Movement.insertMovement(6, "Sistema","Roupas Brás", "Entrada", 100, 53.97, "Entrada de produtos");
                Movement.insertMovement(3, "Sistema","Gucci", "Saída", -3, 1549.99, "Venda");
                Movement.insertMovement(7, "Sistema","Roupas Brás", "Entrada", 2, 5200.00, "Entrada de produtos");
                Movement.insertMovement(8, "Sistema","CláraCloth", "Entrada", 300, 29.99, "Entrada de produtos");
                Movement.insertMovement(1, "Sistema","B F1 Confecções", "Saída", -6, 140.99, "Venda");
                Movement.insertMovement(8, "Sistema","CláraCloth", "Saída", -4, 69.99, "Venda");
                Movement.insertMovement(6, "Sistema","CláraCloth", "Saída", -16, 99.99, "Venda");
                Movement.insertMovement(10, "Sistema","Crocs Market", "Saída", -6, 349.99, "Venda");
                Movement.insertMovement(10, "Sistema","Crocs Market", "Saída", -2, 369.99, "Venda");
                Movement.insertMovement(2, "Sistema","Mario Roupas", "Saída", -3, 299.99, "Venda");
                Movement.insertMovement(5, "Sistema","Gucci", "Saída", -1, 8999.99, "Venda");
                Movement.insertMovement(4, "Sistema","r7 Calçados", "Saída", -4, 349.99, "Venda");
                Movement.insertMovement(1, "Sistema","B F1 Confecções", "Saída", -1, 196.99, "Venda");
                Movement.insertMovement(8, "Sistema","Zara", "Entrada", 3, 149.99, "Devolução");
                Movement.insertMovement(6, "Sistema","Roupas Brás", "Saída", -8, 129.99, "Venda");
                Movement.insertMovement(6, "Sistema","Roupas Brás", "Saída", -13, 149.99, "Venda");
                Movement.insertMovement(4, "Sistema","r7 Calçados", "Entrada", 2, 349.00, "Devolução");
                Movement.insertMovement(7, "Sistema","Roupas Brás", "Saída", -2, 10000.00, "Venda");
                Movement.insertMovement(2, "Sistema","Mario Roupas", "Saída", -3, 269.99, "Venda");
                Movement.insertMovement(2, "Sistema","Mario Roupas", "Saída", -20, 189.93, "Lote defeituoso");

            }
            if(Brand.getBrands().isEmpty()) {
                Brand.insertBrand("Nike", "Roupas");
                Brand.insertBrand("Hering", "Roupas");
                Brand.insertBrand("Offtrack", "Tenis");
                Brand.insertBrand("Crocs", "Calçados");
                Brand.insertBrand("Zara", "Roupas");
                Brand.insertBrand("Fendi", "Roupas");
                Brand.insertBrand("Gucci", "Roupas");
            }
            if(Provider.getProviders().isEmpty()) {
                Provider.insertProvider("Roupas Brás", "Rua São Paulo, 158", "(11) 98570-9815", "marketing@rbras.com.br");
                Provider.insertProvider("Gucci", "Av. Anchieta, 73", "(13) 4567-4222", "gucci.market@gucci.com");
                Provider.insertProvider("Offtrack", "Av. Antonio Garcia, 997", "(12) 7865-4092", "offtrack@gmail.com");
                Provider.insertProvider("Crocs Market", "Av. Rio Claro, 5981", "(78) 7865-4092", "crocs@crocs.com");
                Provider.insertProvider("B F1 Confecções", "Rua Antônio Chaves, 1", "(43) 7865-4092", "bf1@gmail.com");
                Provider.insertProvider("r7 Calçados", "Rua Madalena, 77", "(09) 7165-6254", "calcados@r7.com");
                Provider.insertProvider("Mario Roupas", "Rua Mario Laerte, 501", "(54) 4216-9472", "mario@gmail.com");
                Provider.insertProvider("CláraCloth", "Av. Bernardo Medeiros, 17095", "(109) 9473-8929", "roupas@cc.com");
            }
            
        } catch(Exception ex) {
            exception = ex;
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        try {
            Connection con = getConnection();
            Statement stmt = con.createStatement();
            stmt.execute(Brand.getDestroyStatement());
            stmt.execute(User.getDestroyStatement());
            stmt.execute(Provider.getDestroyStatement());
            stmt.execute(Product.getDestroyStatement());
            stmt.execute(Movement.getCreateStatement());
            stmt.close();
            con.close();
        } catch(Exception ex) {
            exception = ex;
        }
    }
}
