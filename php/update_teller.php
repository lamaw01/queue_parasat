<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
header('Content-Type: application/json; charset=utf-8');

//https://konek.parasat.tv:53000/branch_queue_api/update_teller.php

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('HTTP/1.1 405 Method Not Allowed');
    echo '405 Method Not Allowed';
    exit;
}

// Get the raw POST data (JSON)
$inputData = file_get_contents("php://input");

// Decode the JSON data into a PHP array
$decodedData = json_decode($inputData, true);

$id = $decodedData["id"];
$counter = $decodedData["counter"];
$name = $decodedData["name"];
$type = $decodedData["type"];
$window = $decodedData["window"];
$active = $decodedData["active"];

// Define required parameters
$requiredParams = ['id' => $id, 'counter' => $counter, 'name' => $name, 'type' => $type, 'active' => $active, 'window' => $window];

// Check if all required parameters are present
foreach ($requiredParams as $param => $value) {
    if (is_null($value)) {
        header('HTTP/1.1 400 Bad Request');
        // echo json_encode(['error' => "Missing parameter: $param", 'message'=>$guideJson]);
        echo "400 Missing parameter: $param";
        exit;
    }
}

// Function to update a table using mysqli
function updateType($mysqli, $data, $where) {
    // Prepare the SET part of the query
    $set = [];
    $params = [];
    foreach ($data as $column => $value) {
        $set[] = "$column = ?";
        $params[] = $value;
    }
    
    // Join the SET array to form the SET clause for the query
    $setClause = implode(', ', $set);

    // Prepare the WHERE clause (assuming $where is an associative array)
    $whereClause = [];
    foreach ($where as $column => $value) {
        $whereClause[] = "$column = ?";
        $params[] = $value;
    }
    $whereClause = implode(' AND ', $whereClause);

    // Combine the full SQL query
    $query = "UPDATE branch_teller SET $setClause WHERE $whereClause";

    // Prepare the statement
    if ($stmt = $mysqli->prepare($query)) {
        // Dynamically bind parameters to the prepared statement
        // Assuming all parameters are strings ('s'), modify this as necessary
        $types = str_repeat('s', count($params));  // Adjust for other types ('i' for integers, etc.)
        $stmt->bind_param($types, ...$params);

        // Execute the statement
        if ($stmt->execute()) {
            // Check if rows were affected
            if ($stmt->affected_rows > 0) {
                return ['status' => 'success', 'message' => 'Record updated successfully'];
            } else {
                return ['status' => 'info', 'message' => 'No rows updated (maybe no changes)'];
            }
        } else {
            return ['status' => 'error', 'message' => 'Failed to execute query: ' . $stmt->error];
        }

        // Close the statement
        $stmt->close();
    } else {
        return ['status' => 'error', 'message' => 'Failed to prepare query: ' . $mysqli->error];
    }
}

// Set up a mysqli connection (replace with your actual DB credentials)
$mysqli = new mysqli("localhost", "janrey.dumaog", "janr3yD", "dev");  // Replace with your DB details

// Check if the connection was successful
if ($mysqli->connect_error) {
    die("Connection failed: " . $mysqli->connect_error);
}

// Example data to update
$data = [
    'counter' => $counter,
    'name' => $name,
    'type' => $type,
    '`window`' => $window,
    'active' => $active,
];
$where = [
    'id' => $id  // Update where the 'id' is 1
];

// Call the update function
$response = updateType($mysqli, $data, $where);

// Output the result
header('HTTP/1.1 200 OK');
echo json_encode($response);

// Close the database connection
$mysqli->close();

?>