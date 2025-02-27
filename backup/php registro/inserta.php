<?php
// Include the database connection file
require_once 'conexion.php';
// Check if the form was submitted
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
  // Get the form data
      nombrenombre = $_POST['get_nombre'];
  $correo = $_POST['get_correo'];
  $contraseña = $_POST['get_contraseña'];
  // Validate the email address
  $sql = "SELECT * FROM usuarios WHERE correo = '$correo' OR nombre = '$nombre'";
  $result = mysqli_query($conx1, $sql);
  // If the email already exists, display an error message
  if (mysqli_num_rows($result) > 0) {
    header("Location: index.php?error=email_exists");
    exit;
  } else {
    // Insert the new user data into the database
    $sql = "INSERT INTO usuarios (nombre, correo, contraseña) VALUES ('$nombre', '$correo', '$contraseña')";
    if (mysqli_query($conx1, $sql)) {
      header("Location: thanks.html");
    } else {
      echo "Error: " . mysqli_error($conx1);
    }
  }
  // Close the database connection
  mysqli_close($conx1);
}
?>