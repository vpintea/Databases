<?php

define('DB_HOST', "127.0.0.1");
define('DB_PORT', "ADD_THE_PORT_HERE"); //add the port you are using to conect with your database 
define('DB_USER', "root");
define('DB_PASS', "INSERT_YOUR_PASSWORD_HERE"); //add your password 
define('DB_SCHEMA', "cs6400_team029_lsrs");

//Create connection
$conn = mysqli_connect(DB_HOST, DB_USER, DB_PASS, DB_SCHEMA, DB_PORT);

// Check connection
// Check connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
  }
  echo "Connected successfully";

//   $sql = "INSERT INTO Product(pid, name, price)" .
//   "VALUES('12', 'indoorChair', 200.00)";

//   if ($conn->query($sql) === TRUE) {
//     echo "New record created successfully";
//   } else {
//     echo "Error: " . $sql . "<br>" . $conn->error;
//   }
?>
