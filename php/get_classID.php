<?php

include("dbconnection.php");
$con = DBConnection();
$query = "SELECT class_id FROM class";
$exe = mysqli_query($con, $query);
$arr = [];

while($row = mysqli_fetch_array($exe))
{
	$arr[] = $row;
}
print(json_encode($arr));

?>
