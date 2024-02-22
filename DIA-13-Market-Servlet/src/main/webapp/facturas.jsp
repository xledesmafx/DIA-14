<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.DriverManager" %><%--
  Created by IntelliJ IDEA.
  User: acer
  Date: 22/02/2024
  Time: 14:08
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>FACTURAS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">

</head>
<body>

<div class="container">

    <h1>REGISTRO FACTURAS</h1>
<table class="table table-hover">
    <tr>
        <th>Fecha</th>
        <th>Nombre</th>
        <th>Apellido</th>
        <th>Producto</th>
        <th>Cantidad</th>
        <th>Tipo Factura</th>
    </tr>
<%
    Connection c = null;
    Statement miStatement = null;
    ResultSet miResulset = null;

    try {
        // Establecer la conexión
        Class.forName("org.postgresql.Driver");
        c = DriverManager.getConnection("jdbc:postgresql://localhost:5432/Market", "postgres", "postgres");

        // Crear la declaración
        miStatement = c.createStatement();

        // Ejecutar la consulta
        miResulset =  miStatement.executeQuery(
                "select fr.fecha_emision, c.nombre, c.apellido, pr.nombre as producto, fd.cantidad, ft.nombre as tipo_factura " +
                        "from producto pr " +
                        "join factura_detalle as fd " +
                        "on fd.producto_id = pr.id " +
                        "join factura as fr " +
                        "on fd.factura_id = fr.id " +
                        "join factura_tipo as ft " +
                        "on fr.factura_tipo_id = ft.id " +
                        "join cliente as c " +
                        "on fr.cliente_id = c.id;");

        // Mostrar los resultados en la página
        while (miResulset.next()) {
            String fecha_emision = miResulset.getString("fecha_emision");
            String nombre = miResulset.getString("nombre");
            String apellido = miResulset.getString("apellido");
            String producto = miResulset.getString("producto");
            String cantidad = miResulset.getString("cantidad");
            String tipo_factura = miResulset.getString("tipo_factura");
%>

    <tr>
        <td><%=fecha_emision%></td>
        <td><%=nombre%></td>
        <td><%=apellido%></td>
        <td><%=producto%></td>
        <td><%=cantidad%></td>
        <td><%=tipo_factura%></td>
    </tr>




<%
        }
    } catch (Exception e) {
        // Manejar la excepción de manera adecuada
        System.out.println("Error: " + e.getMessage());
    } finally {
        // Cerrar los recursos
        try {
            if (miResulset != null) miResulset.close();
            if (miStatement != null) miStatement.close();
            if (c != null) c.close();
        } catch (Exception e) {
            System.out.println("Error al cerrar los recursos: " + e.getMessage());
        }
    }
%>
</table>

</div>
<button onclick="window.location.href = 'index.jsp';">VOLVER AL MENÚ</button>
</body>
</html>
