<?php include "lib/header.php";
include('lib/init.php'); ?>

<h2>View Outdoor Furniture on Groundhog Day Report</h2>

<form method="post">
  
  <input type="Submit" name="Submit" value="Submit">
</form>

<br>
<a href="main_menu.php">Back to Main Menu</a>

<?php if (isset($_POST['Submit'])) { ?>
  <h2>Results</h2>

  <?php $sql = "SELECT YEAR(x.date) as Year, sum(x.quantity) as TotalQuantity, sum(x.quantity)/365 as AvgDailyQuantity, 
  sum(y.quant) as GroundHogDay
FROM 
(SELECT date, quantity -- only outdoor sales
FROM Sold JOIN ProductCategory ON Sold.PID = ProductCategory.PID
WHERE ProductCategory.name = 'Outdoor Furniture') as x
LEFT JOIN
(SELECT date, quantity as quant -- only outdoor on Feb. 2
FROM Sold JOIN ProductCategory ON Sold.PID = ProductCategory.PID
WHERE ProductCategory.name = 'Outdoor Furniture' AND MONTH(Sold.date) = 2
AND DAY(Sold.date) = 2) as y
ON x.date = y.date GROUP BY YEAR ORDER BY YEAR ASC" ;
  
$result = mysqli_query($conn, $sql);

  // if (mysqli_num_rows($result) > 0) {
  //   // output data of each row
  //   while($row = mysqli_fetch_assoc($result)) {
  //     echo "CategoryName: " . $row["category_name"]. " - State: ". $row["state"]. " - TotalNumberSold: ". $row["total_number_sold"]. "<br>";
  //   }
  // } else {
  //   echo "0 results";
  // }

      if(mysqli_num_rows($result) > 0){
        echo '<table border="1" cellspacing="2" cellpadding="2"> 
        <tr> 
            <td> Year </td> 
            <td> Total Quantity </td> 
            <td> Average Daily Quantity </td> 
            <td> Ground Hog Day Quantity </td> 
        </tr>';

        while ($row = $result->fetch_assoc()) {
            $Year = $row["Year"];
            $TotalQuantity = $row["TotalQuantity"];
            $AvgDailyQuantity = $row["AvgDailyQuantity"];
            $GroundHogDay = $row["GroundHogDay"];
    
            echo '<tr> 
                      <td>'.$Year.'</td> 
                      <td>'.$TotalQuantity.'</td> 
                      <td>'.$AvgDailyQuantity.'</td> 
                      <td>'.$GroundHogDay.'</td> 
                  </tr>';
        }
    
        $result->free();
      }
      else {
        echo "Error";
      }

};
?>

 <?php include "lib/footer.php"; ?>