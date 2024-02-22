<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.DriverManager" %><%--
  Created by IntelliJ IDEA.
  User: acer
  Date: 22/02/2024
  Time: 14:03
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Top Proveedores</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f5f5f5;
      margin: 0;
      padding: 0;
    }

    .container {
      max-width: 600px;
      margin: 50px auto;
      background-color: #fff;
      border-radius: 10px;
      box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
      padding: 20px;
    }

    h1 {
      text-align: center;
      color: #333;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
    }

    th, td {
      padding: 8px;
      text-align: left;
      border-bottom: 1px solid #ddd;
    }

    th {
      background-color: #f58220;
      color: #fff;
    }

    tr:nth-child(even) {
      background-color: #f2f2f2;
    }

    tr:hover {
      background-color: #ddd;
    }
  </style>
</head>
<body>

<div class="container">
  <h1>TOP PROVEEDORES</h1>

  <table class="table table-hover">
    <thead>
    <tr>
      <th>Nombre</th>
      <th>Cantidad</th>
    </tr>
    </thead>
    <tbody>
    <%
      Connection c = null;
      Statement miStatement = null;
      ResultSet miResulset = null;
      try {
        Class.forName("org.postgresql.Driver");
        c = DriverManager.getConnection("jdbc:postgresql://localhost:5432/Market", "postgres", "postgres");
        miStatement = c.createStatement();
        miResulset = miStatement.executeQuery(
                "select pr.nombre, count(pr.nombre) as \"Cantidad\" from Producto as prod " +
                        "join proveedor as pr " +
                        "on prod.proveedor_id=pr.id " +
                        "group by pr.nombre " +
                        "order by \"Cantidad\" desc " +
                        "limit 5;");
        if (!miResulset.isBeforeFirst()) {
    %>
    <tr>
      <td colspan="2">No hay datos disponibles</td>
    </tr>
    <% } else {
      while (miResulset.next()) {
        String nombre = miResulset.getString("nombre");
        String cantidad = miResulset.getString("Cantidad");
    %>
    <tr>
      <td><%=nombre%></td>
      <td><%=cantidad%></td>
    </tr>
    <% }
    }
    } catch (Exception e) {
      System.out.println("Error: " + e.getMessage());
    } finally {
      try {
        if (miResulset != null) miResulset.close();
        if (miStatement != null) miStatement.close();
        if (c != null) c.close();
      } catch (Exception e) {
        System.out.println("Error al cerrar los recursos: " + e.getMessage());
      }
    }
    %>
    </tbody>
  </table>
</div>

</body>
</html>
