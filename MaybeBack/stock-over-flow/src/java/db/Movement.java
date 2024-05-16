/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package db;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPRow;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import javax.servlet.http.HttpServletResponse;
import web.DbListener;

/**
 *
 * @author spbry
 */
public class Movement {

    private int movId;
    private String movDate;
    private int movProd;
    private String movName;
    private String movOp;
    private String movProv;
    private String movType;
    private int movQnt;
    private double movValue;
    private String movDesc;

    public static String getCreateStatement() {
        return "CREATE TABLE IF NOT EXISTS movement("
                + "movId INTEGER PRIMARY KEY AUTOINCREMENT,"
                + "movDate VARCHAR(21) NOT NULL,"
                + "movProd INTEGER,"
                + "movName VARCHAR(200),"
                + "movOp VARCHAR(200),"
                + "movProv VARCHAR(50),"
                + "movType VARCHAR(7),"
                + "movQnt INTEGER NOT NULL,"
                + "movValue REAL,"
                + "movDesc VARCHAR(500)"
                + ")";
    }

    public static String getDestroyStatement() {
        return "DROP TABLE IF EXISTS movement";
    }

    public static ArrayList<Movement> getMovements() throws Exception {
        ArrayList<Movement> list = new ArrayList<>();
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM movement");
        while (rs.next()) {
            int movId = rs.getInt("movId");
            int movProd = rs.getInt("movProd");
            String movName = rs.getString("movName");
            String movOp = rs.getString("movOp");
            String movProv = rs.getString("movProv");
            String movDate = rs.getString("movDate");
            String movType = rs.getString("movType");
            int movQnt = rs.getInt("movQnt");
            Double movValue = rs.getDouble("movValue");
            String movDesc = rs.getString("movDesc");
            Product.updateProd(movId);
            list.add(new Movement(movId, movDate, movProd, movName, movOp, movProv, movType, movQnt, movValue, movDesc));
        }
        rs.close();
        stmt.close();
        con.close();
        return list;
    }

    public static void insertMovement(int movProd, String movOp, String movProv, String movType, int movQnt, Double movValue, String movDesc) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "INSERT INTO movement(movDate, movProd, movName, movOp, movProv, movType, movQnt, movValue, movDesc) "
                + "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement stmt = con.prepareStatement(sql);
        String currentDate = new SimpleDateFormat("HH:mm:ss | dd/MM/yyyy").format(Calendar.getInstance().getTime());
        String prodTarget = Product.getProdNameById(movProd);
        stmt.setString(1, currentDate);
        stmt.setInt(2, movProd);
        stmt.setString(3, prodTarget);
        stmt.setString(4, movOp);
        stmt.setString(5, movProv);
        stmt.setString(6, movType);
        stmt.setDouble(7, movQnt);
        stmt.setDouble(8, movValue);
        stmt.setString(9, movDesc);
        stmt.execute();
        stmt.close();
        con.close();
        Product.updateProd(movProd);
    }

    public static void alterMovement(int movId, int movProd, String movProv, String movType, int movQnt, Double movValue, String movDesc) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "UPDATE movement SET movProd = ?, movProv = ?, movType = ?,  movQnt = ?, movValue = ?, movDesc = ? "
                + "WHERE movId = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, movProd);
        stmt.setString(2, movProv);
        stmt.setString(3, movType);
        stmt.setInt(4, movQnt);
        stmt.setDouble(5, movValue);
        stmt.setString(6, movDesc);
        stmt.setInt(7, movId);
        stmt.execute();
        stmt.close();
        con.close();
        Product.updateProd(movProd);
    }

    public static void deleteMovement(int movId) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "DELETE FROM movement WHERE movId = ? ";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, movId);
        stmt.execute();
        stmt.close();
        con.close();
        Product.updateProd(movId);
    }

    public static void generateReport(ArrayList<Movement> movements, HttpServletResponse response) throws Exception {
        Document document = new Document();
        response.setContentType("apllication/pdf");
        response.addHeader("Content-Disposition", "inline; filename=" + "movimentacoes.pdf");
        PdfWriter.getInstance(document, response.getOutputStream());
        document.open();

        PdfPTable profitTable = new PdfPTable(3);
        profitTable.setWidthPercentage(100);
        //float[] widths = new float[] {20f, 120f, 50f, 70f, 70f, 30f, 50f, 100f};
        //profitTable.setWidths(widths);
        PdfPCell colProfit1 = new PdfPCell(new Paragraph("Total de Custo"));
        colProfit1.setBackgroundColor(BaseColor.LIGHT_GRAY);
        PdfPCell colProfit2 = new PdfPCell(new Paragraph("Total de Vendas"));
        colProfit2.setBackgroundColor(BaseColor.LIGHT_GRAY);
        PdfPCell colProfit3 = new PdfPCell(new Paragraph("Lucro / Prejuízo"));
        colProfit3.setBackgroundColor(BaseColor.LIGHT_GRAY);
        profitTable.addCell(colProfit1);
        profitTable.addCell(colProfit2);
        profitTable.addCell(colProfit3);

        double valueAllEntries = 0, valueAllOutputs = 0;
        for (Movement movement : movements) {
            if (movement.getMovType().equals("Entrada")) {
                valueAllEntries += movement.getMovValue();
            } else if (movement.getMovType().equals("Saída")) {
                valueAllOutputs += movement.getMovValue();
            }
        }
        BigDecimal entries = new BigDecimal(valueAllEntries).setScale(2, RoundingMode.HALF_EVEN);
        BigDecimal outputs = new BigDecimal(valueAllOutputs).setScale(2, RoundingMode.HALF_EVEN);
        BigDecimal profit = new BigDecimal(valueAllOutputs - valueAllEntries).setScale(2, RoundingMode.HALF_EVEN);
        profitTable.addCell("R$ " + String.valueOf(entries.doubleValue()));
        profitTable.addCell("R$ " + String.valueOf(outputs.doubleValue()));
        profitTable.addCell("R$ " + String.valueOf(profit.doubleValue()));
        document.add(profitTable);

        document.add(new Paragraph("Movimentações:"));
        document.add(new Paragraph(" "));
        PdfPTable table = new PdfPTable(8);
        table.setWidthPercentage(100);
        float[] widths = new float[]{20f, 120f, 50f, 70f, 70f, 30f, 50f, 100f};
        table.setWidths(widths);
        PdfPCell col1 = new PdfPCell(new Paragraph("ID"));
        PdfPCell col2 = new PdfPCell(new Paragraph("Horário | Data"));
        PdfPCell col3 = new PdfPCell(new Paragraph("Mov."));
        PdfPCell col4 = new PdfPCell(new Paragraph("Produto"));
        PdfPCell col5 = new PdfPCell(new Paragraph("Fornecedor"));
        PdfPCell col6 = new PdfPCell(new Paragraph("Qtd."));
        PdfPCell col7 = new PdfPCell(new Paragraph("Valor"));
        PdfPCell col8 = new PdfPCell(new Paragraph("Descrição"));
        table.addCell(col1);
        table.addCell(col2);
        table.addCell(col3);
        table.addCell(col4);
        table.addCell(col5);
        table.addCell(col6);
        table.addCell(col7);
        table.addCell(col8);
        for (int i = 0; i < movements.size(); i++) {
            table.addCell(Integer.toString(movements.get(i).getMovId()));
            table.addCell(movements.get(i).getMovDate());
            table.addCell(movements.get(i).getMovType());
            table.addCell(Product.getProdNameById(movements.get(i).getMovProd()));
            table.addCell(movements.get(i).getMovProv());
            table.addCell(Integer.toString(movements.get(i).getMovQnt()));
            table.addCell(Double.toString(movements.get(i).getMovValue()));
            table.addCell(movements.get(i).getMovDesc());
        }
        int i = 0;
        for (PdfPRow r : table.getRows()) {
            for (PdfPCell c : r.getCells()) {
                if (i == 0) {
                    c.setBackgroundColor(BaseColor.LIGHT_GRAY);
                } else {
                    c.setBackgroundColor(i % 2 == 0 ? BaseColor.ORANGE : BaseColor.WHITE);
                }
            }
            i++;
        }
        document.add(table);
        document.close();
    }

    public static Integer getQntById(Integer movProd) throws Exception {
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

    public static double getAvgById(Integer movProd) throws Exception {
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

    public static ArrayList<String> getMovNames() throws Exception {
        ArrayList<String> nameList = new ArrayList<>();
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT movName FROM movement");
        while (rs.next()) {
            String movName = rs.getString("movName");
            nameList.add(movName);
        }
        rs.close();
        stmt.close();
        con.close();
        return nameList;
    }

    public static ArrayList<Integer> getSells() throws Exception {
        ArrayList<Integer> sellList = new ArrayList<>();
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT movQnt, movDate FROM movement WHERE movType = 'Saída' ORDER BY movDate");
        while (rs.next()) {
            Integer movQnt = Math.abs(rs.getInt("movQnt"));
            sellList.add(movQnt);
        }
        rs.close();
        stmt.close();
        con.close();
        return sellList;
    }

    public static ArrayList<String> getSalesDates() throws Exception {
        ArrayList<String> dataList = new ArrayList<>();
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT movDate FROM movement WHERE movType = 'Saída'");
        while (rs.next()) {
            String movDate = rs.getString("movDate").substring(12,13);
            dataList.add(movDate);
        }
        rs.close();
        stmt.close();
        con.close();
        return dataList;
    }

    public static String getFrequentUser() throws Exception {
        String mostlyFrequent = "N/A";
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT movOp, COUNT(movOp) "
                + "AS mostOp FROM movement "
                + "GROUP BY movOp "
                + "ORDER BY mostOp "
                + "DESC LIMIT 1");
        mostlyFrequent = rs.getString("movOp");

        rs.close();
        stmt.close();
        con.close();
        return mostlyFrequent;
    }

    public static String getFrequentProv() throws Exception {
        String mostlyFrequent = "N/A";
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT movProv, COUNT(movProv) "
                + "AS mostProv FROM movement "
                + "WHERE movType = 'Saída' "
                + "GROUP BY movProv "
                + "ORDER BY mostProv "
                + "DESC LIMIT 1");
        mostlyFrequent = rs.getString("movProv");

        rs.close();
        stmt.close();
        con.close();
        return mostlyFrequent;
    }

    public static String getFrequentProd() throws Exception {
        String mostlyFrequent = "N/A";
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT movName, COUNT(movName) "
                + "AS mostProd FROM movement "
                + "WHERE movType = 'Saída'"
                + "GROUP BY movName "
                + "ORDER BY mostProd "
                + "DESC LIMIT 1");
        mostlyFrequent = rs.getString("movName");

        rs.close();
        stmt.close();
        con.close();
        return mostlyFrequent;
    }
    
    public static double getOutsValue() throws Exception {
        double allSell = 0;
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT movValue, movQnt FROM movement WHERE movType = 'Saída'");
        while (rs.next()) {
            allSell += rs.getInt("movValue")*Math.abs(rs.getInt("movQnt"));
            
        }
        rs.close();
        stmt.close();
        con.close();
        return allSell;
    }

    public static int getOuts() throws Exception {
        int allOut = 0;
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM movement WHERE movType='Saída'");

        allOut = rs.getInt("COUNT(*)");

        rs.close();
        stmt.close();
        con.close();
        return allOut;
    }

    public static double getInsValue() throws Exception {
        double allSell = 0;
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT movValue, movQnt FROM movement WHERE movType = 'Entrada'");
        while (rs.next()) {
            allSell += Math.abs(rs.getInt("movValue"))*rs.getInt("movQnt");
            
        }
        rs.close();
        stmt.close();
        con.close();
        return allSell;
    }
    
    public static int getIns() throws Exception {
        int allIn = 0;
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM movement WHERE movType='Entrada'");

        allIn = rs.getInt("COUNT(*)");

        rs.close();
        stmt.close();
        con.close();
        return allIn;
    }

    public static ArrayList<Movement> getPageOrderBy(int offSet, String byOrder, String bySearch) throws Exception {
        ArrayList<Movement> list = new ArrayList<>();
        Connection con = DbListener.getConnection();
        String sql = "SELECT * FROM movement";
        String src = "";
        String ord = "";

        if (byOrder != "" && byOrder != null) {
            ord = " ORDER BY " + byOrder;
        }
        if (bySearch != "" && bySearch != null) {
            src = " WHERE movId LIKE ? OR movDate LIKE ?"
                    + " OR movProd LIKE ? OR movName LIKE ?"
                    + " OR movOp LIKE ? OR movProv LIKE ?"
                    + " OR movType LIKE ? OR movQnt LIKE ?"
                    + " OR movValue LIKE ? OR movDesc LIKE ?";

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
            stmt.setString(8, "%"+bySearch+"%");
            stmt.setString(9, "%"+bySearch+"%");
            stmt.setString(10, "%"+bySearch+"%");
            stmt.setInt(11, offSet);

        } else {
            stmt.setInt(1, offSet);
        }
        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            int movId = rs.getInt("movId");
            int movProd = rs.getInt("movProd");
            String movName = rs.getString("movName");
            String movOp = rs.getString("movOp");
            String movProv = rs.getString("movProv");
            String movDate = rs.getString("movDate");
            String movType = rs.getString("movType");
            int movQnt = rs.getInt("movQnt");
            Double movValue = rs.getDouble("movValue");
            String movDesc = rs.getString("movDesc");
            list.add(new Movement(movId, movDate, movProd, movName, movOp, movProv, movType, movQnt, movValue, movDesc));
        }
        rs.close();
        stmt.close();
        con.close();
        return list;
    }
    
    public static int getSearchPage(String bySearch) throws Exception {
        int pgCount = 0;
        Connection con = DbListener.getConnection();
        String sql = "SELECT COUNT(*) FROM movement"
                   + " WHERE movId LIKE ? OR movDate LIKE ?"
                   + " OR movProd LIKE ? OR movName LIKE ?"
                   + " OR movOp LIKE ? OR movProv LIKE ?"
                   + " OR movType LIKE ? OR movQnt LIKE ?"
                   + " OR movValue LIKE ? OR movDesc LIKE ?";

        PreparedStatement stmt = con.prepareStatement(sql);
        
        stmt.setString(1, "%"+bySearch+"%");
        stmt.setString(2, "%"+bySearch+"%");
        stmt.setString(3, "%"+bySearch+"%");
        stmt.setString(4, "%"+bySearch+"%");
        stmt.setString(5, "%"+bySearch+"%");
        stmt.setString(6, "%"+bySearch+"%");
        stmt.setString(7, "%"+bySearch+"%");
        stmt.setString(8, "%"+bySearch+"%");
        stmt.setString(9, "%"+bySearch+"%");
        stmt.setString(10, "%"+bySearch+"%");

        ResultSet rs = stmt.executeQuery();
        pgCount = rs.getInt("COUNT(*)");
        rs.close();
        stmt.close();
        con.close();
        return pgCount;
    }
    
    public static double getProfit() throws Exception {
        double sellValue = 0;
        double buyValue = 0;
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rsell = stmt.executeQuery("SELECT movValue, movQnt FROM movement WHERE movType='Saída'");
        while (rsell.next()) {
           sellValue += rsell.getDouble("movValue")*rsell.getInt("movQnt");
        }
        rsell.close();
        
        ResultSet rbuy = stmt.executeQuery("SELECT movValue, movQnt FROM movement WHERE movType='Entrada'");
        while (rbuy.next()) {
           buyValue += rbuy.getDouble("movValue")*rsell.getInt("movQnt");
        }
        rbuy.close();
        stmt.close();
        con.close();
        
        
        double showValue = (Math.round((Math.abs(sellValue) - buyValue)*100))/100;
        return showValue;
    }

    public static int getAll() throws Exception {
        int allMov = 0;
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM movement");

        allMov = rs.getInt("COUNT(*)");

        rs.close();
        stmt.close();
        con.close();
        return allMov;
    }

    public Movement(int movId, String movDate, int movProd, String movName, String movOp, String movProv, String movType, int movQnt, double movValue, String movDesc) {
        this.movId = movId;
        this.movDate = movDate;
        this.movProd = movProd;
        this.movName = movName;
        this.movOp = movOp;
        this.movProv = movProv;
        this.movType = movType;
        this.movQnt = movQnt;
        this.movValue = movValue;
        this.movDesc = movDesc;
    }

    public int getMovId() {
        return movId;
    }

    public String getMovDate() {
        return movDate;
    }

    public int getMovProd() {
        return movProd;
    }

    public String getMovName() {
        return movName.replaceAll("\"", "&quot");
    }

    public String getMovOp() {
        return movOp;
    }

    public String getMovProv() {
        return movProv;
    }

    public String getMovType() {
        return movType;
    }

    public int getMovQnt() {
        return movQnt;
    }

    public double getMovValue() {
        return movValue;
    }

    public String getMovDesc() {
        return movDesc.replaceAll("\"", "&quot");
    }

    public void setMovId(int movId) {
        this.movId = movId;
    }

    public void setMovDate(String movDate) {
        this.movDate = movDate;
    }

    public void setMovProd(int movProd) {
        this.movProd = movProd;
    }

    public void setMovName(String movName) {
        this.movName = movName;
    }

    public void setMovOp(String movOp) {
        this.movOp = movOp;
    }

    public void setMovProv(String movProv) {
        this.movProv = movProv;
    }

    public void setMovType(String movType) {
        this.movType = movType;
    }

    public void setMovQnt(int movQnt) {
        this.movQnt = movQnt;
    }

    public void setMovValue(double movValue) {
        this.movValue = movValue;
    }

    public void setMovDesc(String movDesc) {
        this.movDesc = movDesc;
    }
}
