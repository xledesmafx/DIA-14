package Servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;

@WebServlet("/SvFactura")
public class SvFactura extends HttpServlet{

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id_factura = Integer.parseInt(request.getParameter("id"));
        Date fecha_emision = Date.valueOf(request.getParameter("fecha_emision"));
        Date fecha_vencimiento = Date.valueOf(request.getParameter("fecha_vencimiento"));
        int cliente_id = Integer.parseInt(request.getParameter("cliente_id"));
        int factura_tipo_id = Integer.parseInt(request.getParameter("factura_tipo_id"));
        int moneda_id = Integer.parseInt(request.getParameter("moneda_id"));


        System.out.println("Fecha Emision: " + fecha_emision);
        System.out.println("Fecha Vencimiento: " + fecha_vencimiento);
        System.out.println("Id Cliente: " + cliente_id);
        System.out.println("Tipo Factura: " + factura_tipo_id);
        System.out.println("Moneda: " + moneda_id);

        try {
            Connection conn = obtenerConexion();

            String sql = "INSERT INTO factura (id,fecha_emision, fecha_vencimiento, cliente_id, factura_tipo_id, moneda_id) VALUES (?,?, ?, ?, ?, ?)";

            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id_factura);
            pstmt.setDate(2, fecha_emision);
            pstmt.setDate(3, fecha_vencimiento);
            pstmt.setInt(4, cliente_id);
            pstmt.setInt(5, factura_tipo_id);
            pstmt.setInt(6, moneda_id);

            pstmt.executeUpdate();

            conn.close();

            System.out.println("Datos de factura insertados correctamente en la base de datos.");

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Error al insertar datos de factura en la base de datos.");
        }
    }

        private Connection obtenerConexion() throws SQLException {
            String url = "jdbc:postgresql://localhost:5432/Market";
            String usuario = "postgres";
            String contraseña = "postgres";

            try {
                Class.forName("org.postgresql.Driver");
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
                throw new SQLException("Error al cargar el controlador JDBC de PostgreSQL.");
            }

            return DriverManager.getConnection(url, usuario, contraseña);
        }
    }

