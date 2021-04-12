<?php include ('lib/header.php');
include('lib/init.php'); ?>

<h1>Main Menu</h1>



<!-- <form method="post">
  
<input type="Submit" name="Submit" value="View Statistics"> -->
<!--</form>-->


<h2>Summary Statistics</h2>

<?php   
    
    // query the number of stores
    $sql = "SELECT COUNT(*) as TotalStores 
    FROM Store";

    $result = mysqli_query($conn, $sql);
    if(mysqli_num_rows($result) > 0){
        $row = $result->fetch_assoc();
        echo "Total number of stores: ". $row["TotalStores"]. "<br>"."<br>";
    } else {
        echo "error";
    }
    
    // query the number of stores with restaurants or snackbars
    $sql = "SELECT COUNT(*) as TotalNumberRestaurants 
    FROM Store 
    WHERE restaurant = True OR snackbar = True";

    $result = mysqli_query($conn, $sql);
    if(mysqli_num_rows($result) > 0){
        $row = $result->fetch_assoc();
        echo "Total number of stores with restaurants or snackbar: ". $row["TotalNumberRestaurants"]. "<br>"."<br>";
    } else {
        echo "error";
    }
    
    // query the number of stores that offer childcare
    $sql = "SELECT COUNT(*) as TotalStoresOfferChildcare 
    FROM Store 
    WHERE `limit` IS NOT NULL";

    $result = mysqli_query($conn, $sql);
    if(mysqli_num_rows($result) > 0){
        $row = $result->fetch_assoc();
        echo "Total number of stores offering childcare: ". $row["TotalStoresOfferChildcare"]. "<br>"."<br>";
    } else {
        echo "error";
    }

    // query the number of products
    $sql = "SELECT COUNT(*) as TotalProducts 
    FROM Product";

    $result = mysqli_query($conn, $sql);
    if(mysqli_num_rows($result) > 0){
        $row = $result->fetch_assoc();
        echo "Total number of products: ". $row["TotalProducts"]. "<br>"."<br>";
    } else {
        echo "error";
    }

    // query the number of ad campaigns
    $sql = "SELECT COUNT(DISTINCT description) as TotalUniqueCampaigns 
    FROM AdCampaign";

    $result = mysqli_query($conn, $sql);
    if(mysqli_num_rows($result) > 0){
        $row = $result->fetch_assoc();
        echo "Total number of ad campaigns: ". $row["TotalUniqueCampaigns"]. "<br>"."<br>";
    } else {
        echo "error";
    }


?>

<h2>Reports</h2> 
<ul>
    <a href="holiday.php"><strong>Holidays</strong></a> <br>
    <br>
    <a href="population_update.php"><strong>City Population Update</strong></a>
    <br>
    <a href="report_1.php"><strong>View Category Report (Report 1</strong></a> <br>
    <br>
    <a href="report_2.php"><strong>View Actual vs. Predicted Revenue for Couches & Sofars Report (Report 2</strong></a> <br>
    <br>
    <a href="report_3.php"><strong>View Store Revenue by Year by State Report (Report 3</strong></a> <br>
    <br>
    <a href="report_4.php"><strong>View Outdoor Furniture on Groundhog Day Report (Report 4)</strong></a> <br>
    <br>
    <a href="report_5.php"><strong>State with Highest Volume for each Category Report (Report 5)</strong></a> <br>
    <br>
    <a href="report_6.php"><strong>View Revenue by Population Report (Report 6)</strong></a> <br>
    <br>
    <a href="report_7.php"><strong>Childcare Sales Volume Report (Report 7)</strong></a> <br>
    <br>
    <a href="report_8.php"><strong>Report 8 - View Restaurant Impact on Category Sales </strong></a> <br>
    <br>
    <a href="report_9.php"><strong>Advertising Campaign Analysis Report (Report 9)</strong></a> 

</ul>

<?php include ("lib/footer.php"); ?>