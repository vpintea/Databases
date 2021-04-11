<?php include "lib/header.php";
include('lib/init.php'); ?>

<a href="main_menu.php">Back to Main Menu</a>

<h2>Advertising Campaign Analysis Report</h2>

<?php
    $sql = "WITH ALLResult (pid, name, total_sold_during_campaign, total_sold_outside_campaign, difference) AS (
        SELECT pid,
               name,
               SUM(sold_during_campaign)                              AS total_sold_during_campaign,
               SUM(sold_outside_campaign)                             AS total_sold_outside_campaign,
               SUM(sold_during_campaign) - SUM(sold_outside_campaign) AS difference
        FROM (SELECT Product.pid,
                     Product.name,
                     IF(DateAdCampaign.description IS NOT NULL, Sold.quantity, 0) AS sold_during_campaign,
                     IF(DateAdCampaign.description IS NULL AND Sold.quantity IS NOT NULL, Sold.quantity, 0)     AS sold_outside_campaign
              FROM Product
                       JOIN HasDiscount ON Product.pid = HasDiscount.pid
                       LEFT JOIN Sold ON Product.pid = Sold.pid AND HasDiscount.`date` = Sold.`date`
                       LEFT JOIN DateAdCampaign ON HasDiscount.`date` = DateAdCampaign.`date`
                       ) AS ProductsWithDiscountSalesSummary
        GROUP BY pid, name
    )
        (SELECT *
         FROM ALLResult
         ORDER BY difference DESC
         limit 10)
    UNION
    (SELECT *
     FROM (SELECT *
           FROM ALLResult
           ORDER BY difference ASC
           limit 10) AS ProductResultsOrdered
     ORDER BY difference DESC)";

     $result = mysqli_query($conn, $sql);

    if(mysqli_num_rows($result) > 0){
        // echo "Total rows: " . mysqli_num_rows($result);

        echo '<table border="1" cellspacing="2" cellpadding="2"> 
        <tr> 
            <td> Product ID </td> 
            <td> Product Name </td> 
            <td> Sold During Campaign </td>  
            <td> Sold Outside Campaign </td> 
            <td> Difference </td> 
        </tr>';

        while ($row = $result->fetch_assoc()) {
            $pid = $row["pid"];
            $name = $row["name"];
            $sold_during_campaign = $row["total_sold_during_campaign"];
            $sold_outside_campaign = $row["total_sold_outside_campaign"];
            $difference = $row["difference"];
    
            echo '<tr> 
                      <td>'.$pid.'</td> 
                      <td>'.$name.'</td> 
                      <td>'.$sold_during_campaign.'</td> 
                      <td>'.$sold_outside_campaign.'</td> 
                      <td>'.$difference.'</td> 
                  </tr>';
        }
    
        $result->free();
      }
      else {
        echo "Error";
      };
   
?>
<?php include "lib/footer.php"; ?>