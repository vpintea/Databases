<?php include "lib/header.php";
include('lib/init.php'); ?>

<br>


<a href="main_menu.php">Back to Main Menu</a>


<h2>View Actual vs. Predicted Revenue for Couches & Sofars Report</h2>

<?php
    $sql = "
    with couchSofasProducts as (SELECT Product.pid, Product.price,  Product.name
    FROM Product
    JOIN ProductCategory
    ON Product.pid = ProductCategory.pid
    WHERE ProductCategory.name = 'Couches and sofas'),

    totalNumberUnitWithDiscount as (SELECT couchSofasProducts.pid, couchSofasProducts.name, SUM(Sold.quantity * HasDiscount.discount_price) as total_rev, SUM(Sold.quantity) as totalSoldDiscount
    FROM couchSofasProducts
    JOIN Sold on  couchSofasProducts.pid = Sold.pid
    JOIN HasDiscount on HasDiscount.pid = couchSofasProducts.pid
    AND Sold.Date = HasDiscount.date
    WHERE HasDiscount.date IS NOT NULL
    GROUP BY couchSofasProducts.pid, couchSofasProducts.name),

    totalNumberUnitWithoutDiscount as (
    SELECT couchSofasProducts.pid, couchSofasProducts.name, SUM(Sold.quantity * couchSofasProducts.Price) as total_rev
    FROM couchSofasProducts
    JOIN Sold on  couchSofasProducts.pid = Sold.pid
    LEFT JOIN HasDiscount on HasDiscount.pid = couchSofasProducts.pid
    AND Sold.Date = HasDiscount.date
    WHERE HasDiscount.date IS NULL
    GROUP BY couchSofasProducts.pid, couchSofasProducts.name),

    totalPredicted as (SELECT couchSofasProducts.pid, couchSofasProducts.name, SUM(Sold.quantity * couchSofasProducts.Price * 0.75) as TotalPredictedRevenue, SUM(Sold.Quantity) as totalSold
    FROM couchSofasProducts
    JOIN Sold on  couchSofasProducts.pid = Sold.pid
    GROUP BY couchSofasProducts.pid, couchSofasProducts.name)

    SELECT
    couchSofasProducts.pid,
    couchSofasProducts.name,
    couchSofasProducts.price,
    totalPredicted.totalSold,
    totalNumberUnitWithDiscount.totalSoldDiscount,
    totalPredicted.totalSold - totalNumberUnitWithDiscount.totalSoldDiscount as totalRetail,
    (COALESCE(totalNumberUnitWithDiscount.total_rev,0) + totalNumberUnitWithoutDiscount.total_rev) as total_revenue,
    totalPredicted.TotalPredictedRevenue,
    (totalNumberUnitWithDiscount.total_rev + totalNumberUnitWithoutDiscount.total_rev) - totalPredicted.TotalPredictedRevenue as difference
    FROM couchSofasProducts
    LEFT JOIN totalNumberUnitWithDiscount ON couchSofasProducts.pid = totalNumberUnitWithDiscount.PID
    LEFT JOIN totalNumberUnitWithoutDiscount ON couchSofasProducts.pid = totalNumberUnitWithoutDiscount.PID
    LEFT JOIN totalPredicted ON couchSofasProducts.pid = totalPredicted.PID
    WHERE ABS((totalNumberUnitWithDiscount.total_rev + totalNumberUnitWithoutDiscount.total_rev) - totalPredicted.TotalPredictedRevenue ) > 5000
    ORDER BY ABS((totalNumberUnitWithDiscount.total_rev + totalNumberUnitWithoutDiscount.total_rev) - totalPredicted.TotalPredictedRevenue ) DESC
    ";


    $result = mysqli_query($conn, $sql);

    if(mysqli_num_rows($result) > 0){
        // echo "Total rows: " . mysqli_num_rows($result);

        echo '<table border="1" cellspacing="2" cellpadding="2">
        <tr>
            <td> PID </td>
            <td> Product Name </td>
            <td> Product Retail Price </td>
            <td> Total Sales </td>
            <td> Total Sales Discount</td>
            <td> Total Sales Retail Price</td>
            <td> Total Revenue</td>
            <td> Total Predicted Revenue</td>
            <td>  Difference Actual VS Predicted </td>
        </tr>';

        while ($row = $result->fetch_assoc()) {
            $pid = $row["pid"];
            $name = $row["name"];
            $price = $row["price"];
            $totalSold = $row["totalSold"];
            $totalSoldDiscount = $row["totalSoldDiscount"];
            $totalRetail = $row["totalRetail"];
            $total_revenue = $row["total_revenue"];
            $TotalPredictedRevenue = $row["TotalPredictedRevenue"];
            $difference = $row["difference"];

            echo '<tr>
                      <td>'.$pid.'</td>
                      <td>'.$name.'</td>
                      <td>'.$price.'</td>
                      <td>'.$totalSold.'</td>
                      <td>'.$totalSoldDiscount.'</td>
                      <td>'.$totalRetail.'</td>
                      <td>'.$total_revenue.'</td>
                      <td>'.$TotalPredictedRevenue.'</td>
                      <td>'.$difference.'</td>
                  </tr>';
        }

        $result->free();
      }
      else {
        echo "Error";
      };

?>
