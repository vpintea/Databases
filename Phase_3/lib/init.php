<?php

define('DB_HOST', "127.0.0.1");
define('DB_PORT', "3307"); //add the port you are using to connect with your database
define('DB_USER', "root");
define('DB_PASS', "gatech123"); //add your password
define('DB_SCHEMA', "cs6400_team029_lsrs");

//Create connection
$conn = mysqli_connect(DB_HOST, DB_USER, DB_PASS, DB_SCHEMA, DB_PORT);

// Check connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
  }

  // echo "Connected successfully";

//   $sql = "INSERT INTO Product(pid, name, price)" .
//   "VALUES('12', 'indoorChair', 200.00)";

//   if ($conn->query($sql) === TRUE) {
//     echo "New record created successfully";
//   } else {
//     echo "Error: " . $sql . "<br>" . $conn->error;
//   }
?>

