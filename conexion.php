<?php


// declaracion de variables para la conexion
$sever="sql.freedb.tech";
$user="freedb_ADMIN_MOSHE7";
$pass="UzQ&d?gpTQ6q@k*";
$dbname="freedb_My_server_moshe";
$db_port="3306";

// se envia la conexion a la gestora SQL para ingreso
$conx1=mysqli_connect($sever,$user,$pass,$dbname,$db_port);

//se comprueba la conexion
if(!$conx1){
    echo("Failled");
}
?>