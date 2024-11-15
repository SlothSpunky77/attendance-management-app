<?php

include("dbconnection.php"); 
$con = DBConnection();

if (isset($_POST['student_id']) && isset($_POST['class_id']) && isset($_POST['course_id']) && isset($_POST['attendance_date']) && isset($_POST['timeslot']) && isset($_POST['status'])) { 
    $student_id = mysqli_real_escape_string($con, $_POST['student_id']);
    $class_id = mysqli_real_escape_string($con, $_POST['class_id']);
    $course_id = mysqli_real_escape_string($con, $_POST['course_id']);
    $attendance_date = mysqli_real_escape_string($con, $_POST['attendance_date']);
    $timeslot = mysqli_real_escape_string($con, $_POST['timeslot']);
    $status = mysqli_real_escape_string($con, $_POST['status']);
    
    $query = "INSERT INTO attendance_records (student_id, class_id, course_id, attendance_date, timeslot, status)
	VALUES ('$student_id', '$class_id', '$course_id', '$attendance_date', '$timeslot', '$status')
	ON DUPLICATE KEY UPDATE
	class_id = VALUES(class_id),
	course_id = VALUES(course_id),
	status = VALUES(status)";

    if (mysqli_query($con, $query)) {
        echo json_encode(["success" => true, "message" => "Attendance record inserted successfully"]);
    } else {
        echo json_encode(["success" => false, "message" => "Error inserting record: " . mysqli_error($con)]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Required parameters are missing"]);
}

?>
