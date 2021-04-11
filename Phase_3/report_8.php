<?php
include "lib/header.php";
include('lib/init.php');
?>

<h2>Report 8 - View Restaurant Impact on Category Sales</h2>

<table border="1" cellspacing="2" cellpadding="2">
    <tr>
        <th>Category</th>
        <th>Store Type</th>
        <th>Quantity Sold</th>
    </tr>

<?php

$query = "SELECT ProductCategory.name as Category_name, S.restaurant as non FROM ProductCategory
JOIN Sold on ProductCategory.pid = Sold.pid
JOIN Store S on Sold.store_no = S.store_no
GROUP BY Category_name, restaurant;
SELECT SUM(store_no) as Stores_quantity FROM Store
GROUP BY restaurant;
WITH getProductCategoryInSol as (SELECT Sold.store_no, ProductCategory.name,
SUM(quantity) as Quantity_Sold
FROM Sold
LEFT JOIN ProductCategory ON Sold.pid = ProductCategory.pid GROUP BY Sold.store_no, ProductCategory.name)
SELECT
getProductCategoryInSol.name as Category, CASE
WHEN Store.restaurant = 1 Then "Restaurant"
WHEN Store.restaurant = 0 Then "Non-restaurant" END AS Store_type,
SUM(Quantity_Sold) as Quantity_Sold
FROM Store
JOIN getProductCategoryInSol
ON Store.store_no = getProductCategoryInSol.store_no GROUP BY getProductCategoryInSol.name, Store_type ORDER BY getProductCategoryInSol.name, Store_type ASC;";

$result = mysqli_query($conn, $query);
?>

<?php include "lib/footer.php"; ?>