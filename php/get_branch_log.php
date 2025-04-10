<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
header('Content-Type: application/json; charset=utf-8');

//https://konek.parasat.tv:53000/branch_queue_api/get_branch_log.php

// Check if the request method is GET
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('HTTP/1.1 405 Method Not Allowed');
    echo "405 Method Not Allowed";
    exit;
}

// Get the raw POST data (JSON)
$inputData = file_get_contents("php://input");

// Decode the JSON data into a PHP array
$decodedData = json_decode($inputData, true);

$branch_id = $decodedData["branch_id"];

// Define required parameters
$requiredParams = ['branch_id' => $branch_id];

function getLogs($mysqli, $query, $params = []) {

    // Prepare the SQL statement
    if ($stmt = $mysqli->prepare($query)) {
        // Check if parameters are passed and bind them to the query
        if (!empty($params)) {
            // Dynamically bind parameters to the prepared statement
            // This assumes the params are passed as an array of values
            $types = str_repeat('s', count($params));  // assuming all params are strings ('s')
            $stmt->bind_param($types, ...$params);
        }

        // Execute the query
        $stmt->execute();

        // Get the result of the query
        $result = $stmt->get_result();

        // Fetch all results as an associative array
        $data = [];
        while ($row = $result->fetch_assoc()) {
            $data[] = $row;
        }

        // Close the statement
        $stmt->close();

         // Return the results
        return $data;
    } else {
        // If there's an error preparing the query
        return "Error: " . $mysqli->error;
    }
}


// Set up a mysqli connection (replace with your actual DB credentials)
$mysqli = new mysqli("localhost", "janrey.dumaog", "janr3yD", "dev");  // Replace with your DB details

// Check if the connection was successful
if ($mysqli->connect_error) {
    die("Connection failed: " . $mysqli->connect_error);
}

$params = [$branch_id];  // Example parameter (status)

$query = 'SELECT branch_log.counter, branch_teller.name, branch_teller.type, branch_teller.window, branch_log.time_stamp FROM branch_log
INNER JOIN branch_teller ON branch_teller.id = branch_log.teller_id WHERE branch_teller.branch_id = ? ORDER BY branch_log.counter DESC';  // Using a placeholder for parameterized query

$result = getLogs($mysqli, $query, $params);

// Print the result
header('HTTP/1.1 200 OK');
echo json_encode($result);

// Close the database connection
$mysqli->close();


?>