<?php include "lib/header.php";
include('lib/init.php'); ?>

<a href="main_menu.php">Back to Main Menu</a><br>

<h2>Revenue by Population Report</h2>

<?php 
$sql = "-- Calculate retail revenue for each city
with retail_rev as (select YEAR(Sold.date) as Year, city, state, sum(price*quantity) as retailRev
FROM sold
LEFT JOIN Product P on Sold.pid = P.pid
LEFT JOIN HasDiscount ON P.pid = HasDiscount.pid
LEFT JOIN Store on Sold.store_no = Store.store_no
where HasDiscount.date IS null
group by city, state, year),
-- Calculate discounted revenue for each city
discount_rev as (select YEAR(Sold.date) as Year, city, state, sum(discount_price*quantity) as discountRev
FROM sold
LEFT JOIN Product P on Sold.pid = P.pid
LEFT JOIN HasDiscount ON P.pid = HasDiscount.pid
LEFT JOIN Store on Sold.store_no = Store.store_no
group by city, state, year),
citySize as (SELECT City.city, City.state, City.population as pop, -- Calculate city population categories
             CASE
                 WHEN (City.population < 3700000) THEN 'small'
                 WHEN (City.population BETWEEN 3700000 AND 6699999) THEN 'medium'
                 WHEN (city.population BETWEEN 6700000 AND 8999999) THEN 'large'
                 WHEN (City.population >= 9000000) THEN 'Xlarge'
                 ELSE null
                 END as CityPopulation
     FROM City),
totalRev as (select retail_rev.Year, retail_rev.city, retail_rev.state, (COALESCE(retail_rev.retailRev,0) + COALESCE(discount_rev.discountRev,0)) as total_rev
FROM retail_rev
JOIN discount_rev
    ON retail_rev.Year = discount_rev.Year AND
       retail_rev.city = discount_rev.city AND
       retail_rev.state = discount_rev.state),

revWithCategory as (Select citySize.CityPopulation, totalRev.Year, SUM(totalRev.total_rev) as total
    FROM citySize
    JOIN totalRev ON
        citySize.city = totalRev.city AND
        citySize.state = totalRev.state
    GROUP BY totalRev.Year, citySize.CityPopulation)
SELECT revWithCategory.Year,
    concat('$',format(SUM(CASE WHEN revWithCategory.CityPopulation = 'small' THEN  total END),2)) AS SMALL,
    concat('$',format(SUM(CASE WHEN revWithCategory.CityPopulation = 'medium' THEN  total END),2)) AS MEDIUM,
    concat('$',format(SUM(CASE WHEN revWithCategory.CityPopulation = 'large' THEN  total END),2)) AS LARGE,
    concat('$',format(SUM(CASE WHEN revWithCategory.CityPopulation = 'xlarge' THEN  total END),2)) AS Extra_Large
    FROM revWithCategory
    group by revWithCategory.Year" ;
  
$result = mysqli_query($conn, $sql);

      if(mysqli_num_rows($result) > 0){
        echo '<table border="1" cellspacing="2" cellpadding="2"> 
        <tr> 
            <td> Year </td> 
            <td> Small Population </td> 
            <td> Medium Population </td> 
            <td> Large Population </td> 
            <td> XLarge Population </td> 
        </tr>';

        while ($row = $result->fetch_assoc()) {
            $Year = $row["Year"];
            $Small = $row["SMALL"];
            $Medium = $row["MEDIUM"];
            $Large = $row["LARGE"];
            $XLarge = $row["Extra_Large"];
    
            echo '<tr> 
                      <td>'.$Year.'</td> 
                      <td>'.$Small.'</td> 
                      <td>'.$Medium.'</td> 
                      <td>'.$Large.'</td> 
                      <td>'.$XLarge.'</td> 
                  </tr>';
        }
    
        $result->free();
      }
      else {
        echo "Error";
      }
?>

 <?php include "lib/footer.php"; ?>
