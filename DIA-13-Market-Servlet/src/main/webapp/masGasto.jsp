<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Top 5 Clientes con más Gasto</title>
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
    <h1>CLIENTES QUE MÁS GASTARON</h1>

    <table class="table">
        <thead>
        <tr>
            <th scope="col">NOMBRE</th>
            <th scope="col">CANTIDAD</th>
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
                        "SELECT (c.nombre || ' ' || c.apellido) AS Cliente, CAST(SUM(pr.precio * fd.cantidad) AS DECIMAL(20, 1)) AS Gasto " +
                                "FROM cliente AS c " +
                                "JOIN factura AS f ON c.id = f.cliente_id " +
                                "JOIN factura_detalle AS fd ON f.id = fd.factura_id " +
                                "JOIN producto AS pr ON fd.producto_id = pr.id " +
                                "GROUP BY Cliente " +
                                "ORDER BY Gasto DESC " +
                                "LIMIT 5;");
                if (!miResulset.isBeforeFirst()) {
        %>
        <tr>
            <td colspan="2">No hay datos disponibles</td>
        </tr>
        <% } else {
            while (miResulset.next()) {
                String nombre = miResulset.getString("Cliente");
                String gasto = miResulset.getString("Gasto");
        %>
        <tr>
            <td><%=nombre%></td>
            <td><%=gasto%></td>
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
