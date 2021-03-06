<?php include "lib/header.php";
include('lib/init.php'); ?>

<br>


<a href="main_menu.php">Back to Main Menu</a>


<h2>Category Report</h2>

<?php
    $sql = "
    SELECT
    Category.name as category_name,
    format(count(Product.pid),0) as total_num_products,
    COALESCE(min(Product.price),0) as min_retail_price,
    COALESCE(round(avg(Product.price),2),0) as avg_price,
    format(COALESCE(max(Product.price),0),2) as max_price
    FROM
    Category
    LEFT JOIN ProductCategory ON  Category.name = productCategory.name
    LEFT JOIN Product
    ON Product.pid = productCategory.pid
    GROUP BY Category.name
    ORDER BY Category.name ASC;
    ";

    ;

     $result = mysqli_query($conn, $sql);

    if(mysqli_num_rows($result) > 0){
        // echo "Total rows: " . mysqli_num_rows($result);

        echo '<table border="1" cellspacing="2" cellpadding="2">
        <tr>
            <td> Category Name </td>
            <td> Total Number of Products </td>
            <td> Minimum Regular Retail Price </td>
            <td> Average Regular Retail Price </td>
            <td>  Maximum Regular Retail Price </td>
        </tr>';

        while ($row = $result->fetch_assoc()) {
            $category_name = $row["category_name"];
            $total_num_products = $row["total_num_products"];
            $min_retail_price = $row["min_retail_price"];
            $avg_price = $row["avg_price"];
            $max_price = $row["max_price"];

            echo '<tr>
                      <td>'.$category_name.'</td>
                      <td>'.$total_num_products.'</td>
                      <td>'.$min_retail_price.'</td>
                      <td>'.$avg_price.'</td>
                      <td>'.$max_price.'</td>
                  </tr>';
        }

        $result->free();
      }
      else {
        echo "Error";
      };

?>
