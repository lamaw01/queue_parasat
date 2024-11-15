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

// Define required parameters
$requiredParams = ['branch_id' => $branch_id];

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
function performSelectQuery($mysqli, $query, $params = []) {
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
        echo "Error: " . $mysqli->error;
        return false;
    }
}

// Set up a mysqli connection (replace with your actual DB credentials)
$mysqli = new mysqli("localhost", "janrey.dumaog", "janr3yD", "dev");  // Replace with your DB details

// Check if the connection was successful
if ($mysqli->connect_error) {
    die("Connection failed: " . $mysqli->connect_error);
}

// Example SELECT query (replace with your actual query)
$query = 'SELECT * FROM branch_teller WHERE branch_id = ?';  // Using a placeholder for parameterized query
$params = [$branch_id];  // Example parameter (status)

$result = performSelectQuery($mysqli, $query, $params);

// Print the result
// echo "SELECT Query Result: \n";
header('HTTP/1.1 200 OK');
echo json_encode($result);

// print_r($result);

// Close the database connection
$mysqli->close();


?>