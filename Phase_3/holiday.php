<?php

include "lib/header.php";
include('lib/init.php');

?>

<h1>Holidays</h1>

<table border="1" cellspacing="2" cellpadding="2">
    <tr>
        <th>Holiday Name</th>
        <th>Date</th>
    </tr>

<?php

$query = "SELECT holiday_name, `date`" .
         "FROM holiday";

$result = mysqli_query($conn, $query);
if (!empty($result) && (mysqli_num_rows($result) == 0) ) {
    array_push($error_msg,  "SELECT ERROR: Holidays <br>" . __FILE__ ." line:". __LINE__ );
}

while ($row = mysqli_fetch_array($result, MYSQLI_ASSOC)){
    print "<tr>";
    print "<td>{$row['holiday_name']}</td>";
    print "<td>{$row['date']}</td>";
    print "</tr>";
}
?>

</table>
<br>

<h2>Add Holiday</h2>

<form method="post">
    <label for="holiday_name">Holiday Name:</label><br>
    <input type="text" id="holiday_name" name="holiday_name"><br>
    <label for="date">Date:</label><br>
    <input type="date" id="date" name="date"><br><br>
    <input type="submit" name="submit" value="Submit">
</form>

<?php
if (isset($_POST['submit'])) {
    $new_holiday = array(
        "holiday_name" => $_POST['holiday_name'],
        "date"  => $_POST['date']
    );

    $sql = "INSERT INTO holiday (holiday_name, `date`) values (:holiday_name, :`date`)";

    $statement = $conn->prepare($sql);
    $statement->execute($new_holiday);
}
?>
<?php include "lib/footer.php"; ?>