<?php
header('Content-Type: application/json; charset=utf-8');

//https://konek.parasat.tv:53000/branch_queue_api/teller.php

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

$branch_id = $decodedData["branch_id"];
$name = $decodedData["name"];

// Define required parameters
$requiredParams = ['branch_id' => $branch_id, 'name' => $name];

// Check if all required parameters are present
foreach ($requiredParams as $param => $value) {
    if (is_null($value)) {
        header('HTTP/1.1 400 Bad Request');
        // echo json_encode(['error' => "Missing parameter: $param", 'message'=>$guideJson]);
        echo "400 Missing parameter: $param";
        exit;
    }
}

// Function to perform a SELECT query on a MySQL database using mysqli
function getLatestCounter($mysqli, $query, $params = []) {

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
        return $data[0]['counter'];
    } else {
        // If there's an error preparing the query
        return "Error: " . $mysqli->error;
    }
}

// Function to update a table using mysqli
function updateCounter($mysqli, $data, $where) {
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
    $query = "UPDATE branch_queue SET $setClause WHERE $whereClause";

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

$params = [$branch_id];  // Example parameter (status)

// Example SELECT query (replace with your actual query)
$query = 'SELECT counter FROM branch_queue WHERE id = ?';  // Using a placeholder for parameterized query

$result = getLatestCounter($mysqli, $query, $params);

// Example data to update
$data = [
    'counter' => $result + 1,  // New value for the 'name' column
    'last_update' => $name,
];
$where = [
    'id' => $branch_id  // Update where the 'id' is 1
];

// Call the update function
$response = updateCounter($mysqli, $data, $where);

$latest_counter = getLatestCounter($mysqli, $query, $params);

// Output the result
header('HTTP/1.1 200 OK');
echo json_encode($latest_counter);

// Close the database connection
$mysqli->close();


?>