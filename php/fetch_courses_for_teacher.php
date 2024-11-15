<?php

include("dbconnection.php");
$con = DBConnection();

if (isset($_GET['teacher_id'])) {
    $teacher_id = mysqli_real_escape_string($con, $_GET['teacher_id']);

    $query = "SELECT c.course_name
              FROM course_teacher ct
              JOIN course c ON ct.course_id = c.course_id
              WHERE ct.teacher_id = '$teacher_id'";

    $result = mysqli_query($con, $query);

    if ($result) {
        $courses = [];
        while ($row = mysqli_fetch_assoc($result)) {
            $courses[] = $row['course_name'];
        }
        echo json_encode(["success" => true, "courses" => $courses]);
    } else {
        echo json_encode(["success" => false, "message" => "Error retrieving courses: " . mysqli_error($con)]);
    }
} else {
    echo json_encode(["success" => false, "message" => "teacher_id parameter is missing"]);
}

?>

