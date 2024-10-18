<html>
 <head>
    <title> registro usuario</title>
   <style>
       body {
           font-family: Arial, sans-serif;
           background-color: #f4f4f4;
           display: flex;
           justify-content: center;
           align-items: center;
           min-height: 100vh;
           margin: 0;
       }
       .container {
           background-color: #fff;
           padding: 30px;
           border-radius: 5px;
           box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
           width: 400px;
       }
       h1 {
           text-align: center;
           margin-bottom: 20px;
           color: #333;
       }
       table {
           width: 100%;
       }
       th, td {
           padding: 10px;
           text-align: left;
       }
       input[type="text"], input[type="password"] {
           width: 100%;
           padding: 10px;
           margin: 5px 0 15px 0;
           border: 1px solid #ccc;
           border-radius: 3px;
       }
       input[type="submit"], input[type="reset"] {
           background-color: #4CAF50;
           color: white;
           padding: 10px 20px;
           border: none;
           border-radius: 3px;
           cursor: pointer;
       }
       input[type="submit"]:hover {
           background-color: #45a049;
       }
       input[type="reset"] {
           background-color: #f44336;
       }
       input[type="reset"]:hover {
           background-color: #d32f2f;
       }
       .error {
           color: red;
           margin-bottom: 10px;
       }
   </style>
 </head>
<body>
    <div class="container">
        <h1>Registro de Usuario</h1>
        <form action="inserta.php" method="POST">
            <?php
            // Check for an error message
            if (isset($_GET['error']) && $_GET['error'] == 'email_exists') {
              echo "<p class='error'>Error: This email address is already registered.</p>";
            }
            ?>
            <table>
                <tr>
                    <th>Nombre</th>
                    <td>
                        <input type="text" name="get_nombre" placeholder="Ingresa tu nombre">
                    </td>
                </tr>
                <tr>
                    <th>Correo</th>
                    <td>
                        <input type="text" name="get_correo" placeholder="Ingresa tu correo">
                    </td>
                </tr>
                <tr>
                    <th>Contraseña</th>
                    <td>
                        <input type="password" name="get_contraseña" placeholder="Ingresa tu contraseña">
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <input type="submit" name="bsubmit" value="Enviar">
                        <input type="reset" name="reniciar" value="Restablecer">
                    </td>
                </tr>
            </table>
        </form>
    </div>
</body>
</html>