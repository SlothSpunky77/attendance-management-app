<?php

include("dbconnection.php");
$con = DBConnection();

if (isset($_POST['student_id']) && isset($_POST['password'])) {
    $student_id = mysqli_real_escape_string($con, $_POST['student_id']);
    $password = mysqli_real_escape_string($con, $_POST['password']);

    $query = "SELECT * FROM student WHERE student_id = '$student_id' AND password = '$password'";
    $result = mysqli_query($con, $query);

    if (mysqli_num_rows($result) > 0) {
        echo json_encode(["success" => true, "message" => "Login successful"]);
    } else {
        echo json_encode(["success" => false, "message" => "Invalid student ID or password"]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Required parameters are missing"]);
}

?>
