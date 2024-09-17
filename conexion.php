<?php

// declaracion de variables
$sever="sql.freedb.tech";
$user="freedb_ADMIN_MOSHE3";
$pass="#!zPKyTGv?6GjdT";
$dbname="freedb_My_server";
$db_port="3306";


$conx1=mysqli_connect($sever,$user,$pass,$dbname,$db_port);

if(!$conx1){
    echo("Failled");
}
?>