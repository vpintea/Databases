<?php
include('lib/header.php');
include('lib/init.php');
?>

<h2>View Restaurant Impact on Category Sales</h2>

<table border="1" cellspacing="2" cellpadding="2">
    <tr>
        <th>Category</th>
        <th>Store Type</th>
        <th>Quantity Sold</th>
    </tr>

<?php

$sql = "with getProductCategoryInSol as (SELECT Sold.store_no,
    ProductCategory.name,
    SUM(quantity) as quantity_sold
FROM Sold
LEFT JOIN  ProductCategory ON Sold.pid = ProductCategory.pid
GROUP BY Sold.store_no, ProductCategory.name)
SELECT
    getProductCategoryInSol.name,
CASE
    WHEN Store.restaurant = 1 Then 'Restaurant'
    WHEN Store.restaurant = 0 Then 'Non-restaurant'
END AS store_type,
SUM(quantity_sold) as quantity_sold
FROM Store
JOIN getProductCategoryInSol
ON Store.store_no = getProductCategoryInSol.store_no
GROUP BY getProductCategoryInSol.name, store_type
ORDER BY getProductCategoryInSol.name, store_type";

$result = mysqli_query($conn, $sql);

  if(mysqli_num_rows($result) > 0) {
      while ($row = $result->fetch_assoc()) {
          $name = $row["name"];
          $store_type = $row["store_type"];
          $quantity_sold = $row["quantity_sold"];

          echo '<tr> 
            <td>'.$name.'</td> 
            <td>'.$store_type.'</td> 
            <td>'.$quantity_sold.'</td> 
            </tr>';
      }
  }else{
      echo "Error";
  }
?>

<br><a href="main_menu.php">Back to Main Menu</a><br>

<?php include "lib/footer.php"; ?>