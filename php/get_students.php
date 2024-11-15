<?php

include("dbconnection.php");
$con = DBConnection();

// Check if class_id is provided in the URL parameters
if (isset($_GET['class_id'])) {
    // Get the class_id parameter and escape it to prevent SQL injection
    $class_id = mysqli_real_escape_string($con, $_GET['class_id']);
    
    $query = "SELECT * FROM student WHERE class_id = '$class_id'";
    $exe = mysqli_query($con, $query);
    $arr = [];

    while ($row = mysqli_fetch_array($exe)) {
        $arr[] = $row;
    }
 
    print(json_encode($arr));
} else {
    print(json_encode(["error" => "class_id parameter is missing"]));
}

?>


