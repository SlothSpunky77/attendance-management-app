<?php

include("dbconnection.php");
$con = DBConnection();

$query = "SELECT course_name FROM course";
$result = mysqli_query($con, $query);

$courses = [];
if ($result) {
    while ($row = mysqli_fetch_assoc($result)) {
        $courses[] = $row['course_name'];
    }
    echo json_encode(['success' => true, 'courses' => $courses]);
} else {
    echo json_encode(['success' => false, 'message' => 'Failed to retrieve courses']);
}

?>
