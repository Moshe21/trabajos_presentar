<?php



require 'config/database.php';


//1.conectar base de datos
$DB=connectarDB();

//1a. varible 
$consulta_table_depto= "selection * from departamento";
$resultado_table_depto= mysqli_query($DB,$consulta_table_depto)

//2.creacion e inicializados Variables
$clienteExiste = "1";

$emil='';
$nombre='';
$iddepto=0;
$nombreempleado='';
$mensaje='';
$fecha='';


require 'include/header.php';
?>


<h1 class="encabezado-principal">FORMULARIO DE CONTACTO</h1>
    <div class="contenedor contenido-form">
        <form class="formulario" method="POST" action="index.php">
            <fieldset>
                <legend>informacion Personal</legend>

                <label for="nombre">Nombre</label>
                <input type="text" placeholder="tu Nombre" id="nombre" 
                name="nombre" value="<?php echo $nombre; ?>">

                <label for="nombre">Correo Electrónico</label>
                <input type="email" placeholder="tu Email" id="email" name="email"  value="<?php echo $email; ?>">
            </fieldset>

            <fieldset>
                <legend>Informacion remitida</legend>

                <label for="iddepto">Departamento que recibe </label>
                <select id="iddepto" name="iddepto"  value="">


                <label for="mensaje">Mensaje</label>
                <textarea id="mensaje" name="mensaje"><?php echo $mensaje; ?></textarea>

                    <option value="0">--seleccione--</option>

                    <?php
                        while($row= mysqli_fetch_assoc($resultado_table_depto)):


                    ?>



        </fieldset>



        </form>    
    </div>         
</h1>   
