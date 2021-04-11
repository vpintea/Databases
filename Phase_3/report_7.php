<?php include "lib/header.php";
include('lib/init.php'); ?>

<a href="main_menu.php">Back to Main Menu</a>
<h2>Childcare Sales Volume Report</h2>

<?php
$limits = "SELECT * FROM Childcare";

$result = mysqli_query($conn, $limits);

if(mysqli_num_rows($result) > 0){

    // output data of each row
    $s = "";
    $i =0;
    $s1 ="";
    $s2 = "";
    $a=array();
    while($row = mysqli_fetch_assoc($result)) {
        $i++;
        $s .= "CASE WHEN childcare_limit = ".$row["limit"]. " THEN total_sales END AS `".$row["limit"]."`";
        $s1.= "SUM(`".$row["limit"]."`) AS `".$row["limit"]."`";
        $s2 .= "<td> ".$row["limit"]." </td> ";
        if($i < mysqli_num_rows($result)){
            $s.=", ";
            $s1.= ", ";
        }
        array_push($a,$row["limit"]);
        
    }
    
    $sql = "WITH original AS (SELECT month_of_year, childcare_limit, SUM(total_amount) AS total_sales
    FROM (SELECT MONTH(Sold.`date`)                                                  AS month_of_year,
                 IFNULL(Store.`limit`, 0)                                            AS childcare_limit,
                 Sold.quantity * IFNULL(HasDiscount.discount_price, Product.price)   AS total_amount
          FROM Sold
                   LEFT JOIN Product ON Product.pid = Sold.pid
                   LEFT JOIN HasDiscount ON HasDiscount.pid = Sold.pid AND HasDiscount.`date` = Sold.`date`
                   LEFT JOIN Store ON Store.store_no = Sold.store_no
          WHERE Sold.`date` > NOW() - INTERVAL 12 month) AS SalesPerChildcareLimit
    GROUP BY month_of_year, childcare_limit),
    extended AS (SELECT month_of_year,
                 $s FROM original)
    SELECT month_of_year, $s1
    FROM extended
    GROUP BY month_of_year";

    $result = mysqli_query($conn, $sql);

  if(!$result){
    echo "error";
    return;
  }

  if(mysqli_num_rows($result) > 0){
    echo '<table border="1" cellspacing="2" cellpadding="2"> 
          <tr> 
          <td> Month </td>'.$s2.'</tr>';

    while ($row = $result->fetch_assoc()) {
      $month = $row["month_of_year"];
      echo '<tr> 
            <td>'.$month.'</td> ';
           
      for ($x = 0; $x < sizeof($a); $x++) {
        echo '<td>'.$row[$a[$x]].'</td>';
      }
            
      echo '</tr>';
      }
            
    $result->free();
  }
  else 
  {
    echo "No results available";
  }
}

?>

<?php include "lib/footer.php"; ?>