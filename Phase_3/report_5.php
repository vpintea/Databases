<?php include "lib/header.php";
include('lib/init.php'); ?>

<h2>Select month and State</h2>

<form method="post">
  <label for="month">Month</label>
  <input type="text" name="month" id="month">
  <label for="state">State</label>
  <input type="text" name="state" id="state">
  <input type="submit" name="submit" value="Submit">
</form>

<br>
<a href="main_menu.php">Back to Main Menu</a>

<?php if (isset($_POST['submit'])) { ?>
  <h2>Results</h2>

  <?php $sql ="WITH TotalNumberSold(category_name, state, total_number_sold)
  AS (SELECT category_name, state, SUM(quantity) AS total_number_sold
      FROM (SELECT name AS category_name, state, quantity
            FROM ProductCategory
                     JOIN Sold ON ProductCategory.pid = Sold.pid
                     JOIN Store ON Store.store_no = Sold.store_no
            WHERE MONTH (Sold.`date`) = 06 AND YEAR (Sold.`date`) = 2020) AS ProductsSoldPerCategory
      GROUP BY category_name, state
)
SELECT TotalNumberSold.category_name, TotalNumberSold.state, TotalNumberSold.total_number_sold
FROM (SELECT category_name, MAX(total_number_sold) AS max_total_number_sold
FROM TotalNumberSold
GROUP BY category_name) AS TotalNumberSoldPerCategory
  JOIN TotalNumberSold ON TotalNumberSoldPerCategory.category_name = TotalNumberSold.category_name
AND TotalNumberSoldPerCategory.max_total_number_sold = TotalNumberSold.total_number_sold
ORDER BY category_name ASC";
  
$result = mysqli_query($conn, $sql);

  // if (mysqli_num_rows($result) > 0) {
  //   // output data of each row
  //   while($row = mysqli_fetch_assoc($result)) {
  //     echo "CategoryName: " . $row["category_name"]. " - State: ". $row["state"]. " - TotalNumberSold: ". $row["total_number_sold"]. "<br>";
  //   }
  // } else {
  //   echo "0 results";
  // }

      if ($row = mysqli_fetch_assoc($result)) {
        echo '<table border="1" cellspacing="2" cellpadding="2"> 
        <tr> 
            <td> Category Name </td> 
            <td> State </td> 
            <td> Total Number Sold </td> 
        </tr>';

        while ($row = $result->fetch_assoc()) {
            $category_name = $row["category_name"];
            $state = $row["state"];
            $number_sold = $row["total_number_sold"];
    
            echo '<tr> 
                      <td>'.$category_name.'</td> 
                      <td>'.$state.'</td> 
                      <td>'.$number_sold.'</td> 
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