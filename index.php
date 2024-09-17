<html>
 <head>
    <title> registro PQR</title>
 </head>
<body>
    <form action="inserta.php" method="POST">
     
    <table>
        <tr>
          <th>nombre del abonado</th>  
            <td>
              <input type="text" name="get_nombre" placeholder="ingresa tu nombre">
            </td>
        </tr>
          <tr>
            <th>apellido del abonado</th>
          <td>
            <input type="text" name="get_apellido" placeholder="ingresa tu apellido">
          </td>    
        </tr>
       </table>
          <th>area</th>
            <select name="opcion_area">
              <option value ="soporte técnico">soporte técnico;  </option>
              <option value="cartera">cartera</option>
              <option value="atención clientes"> atención clientes </option>
          
        </tr>

                  <td>
                      <input type="submit" name="bsubmit" placeholder= "enviar">

                  </td>
              </tr> 

              <tr>
                  <td>
                      <input type="reset" name="reniciar" placeholder= "ciudad">

                  </td>
              </tr>   
    
              </table>



    </form>   


</body>


</html>