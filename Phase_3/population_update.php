<?php
include "lib/header.php";
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

    <?php $sql ="UPDATE city SET population = '$_POST[population]' WHERE city = '$_POST[city]'";

    echo $sql;

    $result = mysqli_query($conn, $sql);

    if ($conn->query($sql) === TRUE) {
        echo "New record created successfully";
    } else {
        echo "Error: " . $sql . "<br>" . $conn->error;
    }
}?>

<?php include "lib/footer.php"; ?>
