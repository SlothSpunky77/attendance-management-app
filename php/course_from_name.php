<?php

include("dbconnection.php");
$con = DBConnection();

if (isset($_GET['course_name'])) {
	$course_name = mysqli_real_escape_string($con, $_GET['course_name']);
	$query = "SELECT course_id FROM course WHERE course_name = '$course_name'";
	$result = mysqli_query($con, $query);

	if ($result) {
        	$row = mysqli_fetch_assoc($result);
        	echo json_encode(['success' => true, 'course_id' => $row['course_id']]);
    	} else {
                echo json_encode(['success' => false, 'message' => 'Course not found']);
    	}
} else {
        echo json_encode(['success' => false, 'message' => 'course_name parameter is missing']);
}

?>
