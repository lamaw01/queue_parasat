<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
header('Content-Type: application/json; charset=utf-8');

//https://konek.parasat.tv:53000/branch_queue_api/insert_teller.php

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

$name = $decodedData["name"];
$type = $decodedData["type"];
$branch_id = $decodedData["branch_id"];
$window = $decodedData["window"];

// Define required parameters
$requiredParams = ['name' => $name, 'type' => $type, 'branch_id' => $branch_id, 'window' => $window];

// Check if all required parameters are present
foreach ($requiredParams as $param => $value) {
    if (is_null($value)) {
        header('HTTP/1.1 400 Bad Request');
        echo "400 Missing parameter: $param";
        exit;
    }
}


// Function to insert data into the table
function insertTeller($mysqli, $data) {
    // Prepare the INSERT query
    $columns = implode(", ", array_keys($data));
    $placeholders = implode(", ", array_fill(0, count($data), "?"));
    $params = array_values($data);
    
    $query = "INSERT INTO branch_teller ($columns) VALUES ($placeholders)";

    // Prepare the statement
    if ($stmt = $mysqli->prepare($query)) {
        $types = str_repeat('s', count($data));
        $stmt->bind_param($types, ...$params);

        // Execute the statement
        if ($stmt->execute()) {
            return ['status' => 'success', 'message' => 'Record inserted successfully', 'id' => $stmt->insert_id];
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
$mysqli = new mysqli("localhost", "janrey.dumaog", "janr3yD", "dev");

// Check if the connection was successful
if ($mysqli->connect_error) {
    die("Connection failed: " . $mysqli->connect_error);
}

// Data to insert
$data = [
    'counter' => 1,
    'name' => $name,
    'type' => $type,
    'branch_id' => $branch_id,
    '`window`' => $window,
    'active' => 1,
];

// Call the insert function
$response = insertTeller($mysqli, $data);

// Output the result
header('HTTP/1.1 200 OK');
echo json_encode($response);
// echo json_encode($data);

// Close the database connection
$mysqli->close();

?>
