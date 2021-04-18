<?php include "lib/header.php";
include('lib/init.php'); ?>

<a href="main_menu.php">Back to Main Menu</a>
<h2>View Store Revenue by Year by State Report</h2>

<h> Select State:</h>

<?php
$sql =  "SELECT
DISTINCT(CITY.state) as state FROM City
ORDER BY City.State";

$result = mysqli_query($conn, $sql);

//User selects  State
if(mysqli_num_rows($result) > 0){
  echo "<form method=\"post\" >";
  echo "<select name = \"selected_state\">";
  echo "<option hidden disabled selected value> -- select an option -- </option>";
  while ($row = $result->fetch_assoc()) {
    echo "<option value='".$row[state]."' name='".$row[state]."'>".$row[state]."</option>";
  }
  echo "</select>";
  echo "<input type=\"submit\" name=\"submitState\" value=\"submit\">";
  echo "</form>";
}

if(array_key_exists('submitState',$_POST)){
  $selected_state = $_POST['selected_state'];
  displayReport($selected_state);
};

//Display the report for the corresponfing month and year selected
function displayReport($selected_state){
  include('lib/init.php');

  $sql_main_query = "with storesInState as (SELECT City.city, Store.store_no, Store.address, Store.State
  FROM City
  JOIN Store on (City.city = Store.city and City.state = Store.state)
  WHERE
  City.State = '$selected_state'),

  revenueDiscount as (
    SELECT storesInState.store_no, SUM(Sold.quantity * HasDiscount.discount_price) as revenue,  YEAR(sold.date) as year_sold
    FROM Sold
    JOIN storesInState ON storesInState.store_no = SOLD.store_no
    JOIN HasDiscount on HasDiscount.pid = SOLD.pid AND Sold.Date = HasDiscount.date
    JOIN Product on Product.pid = Sold.pid
    WHERE HasDiscount.date IS NOT NULL
    GROUP BY YEAR(sold.date), storesInState.store_no
  ),

  revenueRetail as (
    SELECT storesInState.store_no, SUM(Sold.quantity * Product.Price) as revenue,  YEAR(sold.date) as year_sold
    FROM Sold
    JOIN storesInState ON storesInState.store_no = SOLD.store_no
    LEFT JOIN HasDiscount on HasDiscount.pid = SOLD.pid AND Sold.Date = HasDiscount.date
    JOIN Product on Product.pid = Sold.pid
    WHERE HasDiscount.date IS NULL
    GROUP BY YEAR(sold.date), storesInState.store_no)

  SELECT
  storesInState.store_no,
  storesInState.address,
  storesInState.city,
  YEAR(sold.date) as sales_year,
  (COALESCE(revenueDiscount.revenue,0) + COALESCE(revenueRetail.revenue,0)) as total_revenue
  FROM storesInState
  LEFT JOIN sold ON storesInState.store_no = SOLD.store_no
  LEFT JOIN revenueDiscount ON (storesInState.store_no = revenueDiscount.store_no AND YEAR(sold.date) = revenueDiscount.year_sold)
  LEFT JOIN revenueRetail ON (storesInState.store_no = revenueRetail.store_no AND YEAR(sold.date) = revenueRetail.year_sold)
  GROUP BY storesInState.store_no, storesInState.address, storesInState.city, YEAR(sold.date), total_revenue
  ORDER BY YEAR(sold.date) ASC, total_revenue DESC";

  $result_report = mysqli_query($conn, $sql_main_query);

  if(!$result_report){
    echo "<p> No results to display </p>";
    return;
  }

  if(mysqli_num_rows($result_report) > 0){
    echo "<h3>Results showing for". $selected_state. "</h3>";
    echo '<table border="1" cellspacing="2" cellpadding="2">
    <tr>
        <td> Store Number </td>
        <td> Address </td>
        <td> City </td>
        <td> Sales Year </td>
        <td> Total Revenue </td>
    </tr>';
    while ($row = $result_report->fetch_assoc()) {
      $store_no = $row["store_no"];
      $address = $row["address"];
      $city = $row["city"];
      $sales_year = $row["sales_year"];
      $total_revenue = $row["total_revenue"];

      echo '<tr>
            <td>'.$store_no.'</td>
            <td>'.$address.'</td>
            <td>'.$city.'</td>
            <td>'.$sales_year.'</td>
            <td>'.$total_revenue.'</td>
            </tr>';
      }

    $result_report->free();
  }
  else
  {
    echo "<h3>No results available for ".$result_report. "<h3>";
  }
}
?>

<?php include "lib/footer.php"; ?>
