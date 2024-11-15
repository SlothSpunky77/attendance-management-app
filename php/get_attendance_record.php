<?php

include("dbconnection.php");
$con = DBConnection();

if (isset($_POST['student_id']) && isset($_POST['course_id'])) {
	$id = mysqli_real_escape_string($con, $_POST['student_id']);
	$course = mysqli_real_escape_string($con, $_POST['course_id']);
	$query = "SELECT * FROM attendance_records WHERE student_id = '$id' AND course_id = '$course' ORDER BY attendance_date DESC, timeslot DESC";
	$result = mysqli_query($con, $query);
	$arr = [];

	while ($records = mysqli_fetch_array($result)) {
		$arr[] = $records;
	}

	print(json_encode($arr));
} else {
	print("student_id or course_id parameter is missing.");
}

?>
