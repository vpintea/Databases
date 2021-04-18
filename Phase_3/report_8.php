<?php
include('lib/header.php');
include('lib/init.php');
?>

<h2>View Restaurant Impact on Category Sales</h2>


<?php

$sql = "with getProductCategoryInSol as (SELECT Sold.store_no,
ProductCategory.name,
SUM(quantity) as quantity_sold
FROM Sold
LEFT JOIN  ProductCategory ON Sold.pid = ProductCategory.pid
GROUP BY Sold.store_no, ProductCategory.name),

fv as (SELECT
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
ORDER BY getProductCategoryInSol.name, store_type),

c as (SELECT
    DISTINCT(getProductCategoryInSol.name),
    CASE
    WHEN Store.restaurant = 1 Then 'Restaurant'
    WHEN Store.restaurant = 0 Then 'Non-restaurant'
END AS store_type
FROM Store, getProductCategoryInSol)

SELECT c.name, c.store_type, IFNULL(fv.quantity_sold,0) AS quantity_sold
FROM c
LEFT JOIN fv ON c.name = fv.name AND c.store_type = fv.store_type
ORDER BY c.name, c.store_type desc";

$result = mysqli_query($conn, $sql);

  if(mysqli_num_rows($result) > 0) {

    echo '<table border="1" cellspacing="2" cellpadding="2">
    <tr>
        <td> Category Name </td>
        <td> Store type </td>
        <td> Quantity Sold </td>
    </tr>';
      $counter = 1;
      while ($row = $result->fetch_assoc()) {
          $name = $row["name"];
          $store_type = $row["store_type"];
          $quantity_sold = $row["quantity_sold"];

          echo '<tr>';
          if ($counter % 2 != 0) {
            echo  '<td rowspan="2">' . $name . '</td>';
          }
          echo  '<td>' . $store_type . '</td>
                <td>' . $quantity_sold . '</td>
                </tr>';
          $counter++;
      }
  }else{
      echo "Error";
  }
    
?>

<br><a href="main_menu.php">Back to Main Menu</a><br>

<?php include "lib/footer.php"; ?>
