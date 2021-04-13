<?php
include('lib/header.php');
include('lib/init.php');
?>

<h2>City Population Update</h2>

<form method="post">
    <label for="city">City</label>
    <input type="text" name="city" id="city">
    <label for="state">State</label>
    <input type="text" name="state" id="state">
    <label for="population">Population</label>
    <input type="number" name="population" id="population">
    <input type="submit" name="submit" value="Submit">
</form>

<?php if (isset($_POST['submit'])) { ?>

    <?php $sql ="UPDATE city SET population = '$_POST[population]' WHERE city = '$_POST[city]' AND state = '$_POST[state]'";

    // TESTING

//    $result = mysqli_query($conn, $sql);
//    echo "result: " . $result;
//    echo "num of rows: " . $result->num_rows;
//    $row_cnt = $result->num_rows;
//    printf("Result set has %d rows.\n", $row_cnt);
    // result is always 1 and row_cnt is always 0

    //  https://www.w3schools.com/php/php_mysql_update.asp
    //  https://www.tutorialspoint.com/mysqli/mysqli_update_query.htm
    //  https://www.php.net/manual/en/mysqli-result.num-rows.php
    //  if ($conn->query($sql) === TRUE) {
    //  if ($result->num_rows > 0)
    //  if (mysqli_query($conn, $sql))

    // END OF TEST

    mysqli_query($conn, $sql);
    if (mysqli_affected_rows($conn)) { //https://www.php.net/manual/en/mysqli.affected-rows.php
        echo "New record updated successfully";
    } else {
        echo "Error updating record: " . $sql . "<br>" . mysqli_error($conn);
    }
}?>

<br><a href="main_menu.php">Back to Main Menu</a><br>

<?php include "lib/footer.php"; ?>
