<?php

function DBConnection() 
{
	$con = mysqli_connect("localhost","root","","dbms_project");
	return $con;
}

?>
