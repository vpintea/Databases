<?php
include('lib/header.php');
include('lib/init.php');
?>

<a href="main_menu.php">Back to Main Menu</a><br>

<br>

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

    <?php
    $sql ="UPDATE city SET population = '$_POST[population]' WHERE city = '$_POST[city]' AND state = '$_POST[state]'";

    mysqli_query($conn, $sql);
    if (mysqli_affected_rows($conn)) { //https://www.php.net/manual/en/mysqli.affected-rows.php
        echo "New record updated successfully";
    } else {
        echo "Error updating record: " . $sql . "<br>" . mysqli_error($conn);
    }
}?>

<h2>City Population</h2>

<table border="1" cellspacing="2" cellpadding="2">
    <tr>
        <th>City</th>
        <th>State</th>
        <th>Population</th>
    </tr>

    <?php

    $query = "SELECT city, state, population FROM city";

    $result = mysqli_query($conn, $query);

    if (!empty($result) && (mysqli_num_rows($result) == 0) ) {
        array_push($error_msg,  "SELECT ERROR: City" . __FILE__ ." line:". __LINE__ );
        print "No population info found in the system";
    }

    while ($row = $result->fetch_assoc()){
        print "<tr>";
        print "<td>{$row['city']}</td>";
        print "<td>{$row['state']}</td>";
        print "<td>{$row['population']}</td>";
        print "</tr>";
    }
    ?>
</table>

<?php include "lib/footer.php"; ?>
