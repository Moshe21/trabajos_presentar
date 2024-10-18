<?php

function connectarDB():mysqli{

    $DB= mysqli_connect('localhost','root','091159Eliza*',
    'pqrs230831');

    if(!$db){

        echo ">Error: No se pudo conectar";
        exit;
    }else{

        return $db;

    }


}

?>