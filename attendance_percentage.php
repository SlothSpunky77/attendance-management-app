<?php

include("dbconnection.php");
$con = DBConnection();

if (isset($_POST['student_id']) && isset($_POST['course_id'])) {  
    $student_id = mysqli_real_escape_string($con, $_POST['student_id']);
    $course_id = mysqli_real_escape_string($con, $_POST['course_id']);
    
    // Query to calculate attendance percentage for the specified course and student
    $query = "SELECT 
                c.course_name, 
                ROUND(
                    COALESCE(
                        (SELECT COUNT(*)
                            FROM attendance_records ar2
                            WHERE ar2.student_id = '$student_id'
                            AND ar2.course_id = '$course_id'
                            AND ar2.status = 'Present') 
                        / NULLIF((SELECT COUNT(*) 
                                    FROM attendance_records ar3
                                    WHERE ar3.student_id = '$student_id'
                                    AND ar3.course_id = '$course_id'), 0) * 100, 0)
                    , 2) AS attendance_percentage
            FROM 
                course c 
            WHERE 
                c.course_id = '$course_id'";
    
    $result = mysqli_query($con, $query);
    $arr = [];

    // Fetch and store the results in an array
    while ($records = mysqli_fetch_assoc($result)) {
        $arr[] = $records;
    }

    // Return the JSON-encoded array
    print(json_encode($arr));
} else {
    print("student_id or course_id parameter is missing.");
}

?>

