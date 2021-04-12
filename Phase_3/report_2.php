<?php include "lib/header.php";
include('lib/init.php'); ?>

<a href="main_menu.php">Back to Main Menu</a>
<h2>State with Highest Volume for each Category Report</h2>

<h> Select Year:</h>

<?php
$sql = "SELECT YEAR(`date`) AS year
FROM Date
GROUP BY YEAR(`date`)
ORDER BY YEAR(`date`) DESC";
$result = mysqli_query($conn, $sql);
//User selects year first
if(mysqli_num_rows($result) > 0){
  echo "<form method=\"post\">";
  echo "<select name = \"selected_year\">";
  while ($row = $result->fetch_assoc()) {
    echo "<option value='".$row[year]."' name='".$row[year]."'>".$row[year]."</option>";
  }
  echo "</select>";
  echo "<input type=\"submit\" name=\"submitYear\" value=\"submit\">";
  echo "</form>";
}
if(array_key_exists('submitYear',$_POST)){
  displayMonthOptions($_POST['selected_year']);
}else if(array_key_exists('submitMonth',$_POST)){
  $selected_month = $_POST['selected_month'];
  $selected_year = $_POST['selected_year'];
   displayReport($selected_year, $selected_month);
};
//User selects month after selecting a year
function displayMonthOptions($selected_year){
  include('lib/init.php');
    $sql_2 = "SELECT MONTH(`date`) AS month
    FROM Date
    WHERE YEAR(`date`) = $selected_year
    GROUP BY MONTH(`date`)
    ORDER BY MONTH(`date`) DESC";
    $result_months = mysqli_query($conn, $sql_2);
    if(mysqli_num_rows($result_months) > 0){
      echo "<br>Select Month:";
      echo "<form method=\"post\">";
      echo "<select name = \"selected_month\">";

      while ($row = $result_months->fetch_assoc()) {
        echo "<option value='".$row[month]."' name='".$row[month]."'>".$row[month]."</option>";
      }
      echo "</select>";
      echo "<input type=\"hidden\" name =\"selected_year\" value=\"$selected_year\">";
      echo "<input type=\"submit\" name =\"submitMonth\" id=\"submitMonth\" value=\"submit\">";
      echo "</form>";
    }
}
//Display the report for the corresponfing month and year selected
function displayReport($selected_year, $selected_month){
  include('lib/init.php');
  $sql_main_query ="WITH TotalNumberSold(category_name, state, total_number_sold)
              AS (SELECT category_name, state, SUM(quantity) AS total_number_sold
              FROM (SELECT name AS category_name, state, quantity
              FROM ProductCategory
                     JOIN Sold ON ProductCategory.pid = Sold.pid
                     JOIN Store ON Store.store_no = Sold.store_no
              WHERE MONTH (Sold.`date`) = $selected_month AND YEAR (Sold.`date`) = $selected_year) AS ProductsSoldPerCategory
              GROUP BY category_name, state
              )
              SELECT TotalNumberSold.category_name, TotalNumberSold.state, TotalNumberSold.total_number_sold
              FROM (SELECT category_name, MAX(total_number_sold) AS max_total_number_sold
              FROM TotalNumberSold
              GROUP BY category_name) AS TotalNumberSoldPerCategory
                JOIN TotalNumberSold ON TotalNumberSoldPerCategory.category_name = TotalNumberSold.category_name
              AND TotalNumberSoldPerCategory.max_total_number_sold = TotalNumberSold.total_number_sold
              ORDER BY category_name ASC";

  $result_report = mysqli_query($conn, $sql_main_query);
  if(!$result_report){
    echo "error";
    return;
  }
  if(mysqli_num_rows($result_report) > 0){
    echo "<h3>Showing results for ".$selected_month. "/" .$selected_year. "</h3>";
    echo '<table border="1" cellspacing="2" cellpadding="2">
          <tr>
          <td> Category Name </td>
          <td> State </td>
          <td> Total Number Sold </td>
          </tr>';
    while ($row = $result_report->fetch_assoc()) {
      $category_name = $row["category_name"];
      $state = $row["state"];
      $number_sold = $row["total_number_sold"];

      echo '<tr>
            <td>'.$category_name.'</td>
            <td>'.$state.'</td>
            <td>'.$number_sold.'</td>
            </tr>';
      }

    $result_report->free();
  }
  else
  {
    echo "<h3>No results available for ".$selected_month. "/" .$selected_year."<h3>";
  }
}
?>

<?php include "lib/footer.php"; ?>
