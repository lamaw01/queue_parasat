<?php
header('Content-Type: application/json; charset=utf-8');

//https://konek.parasat.tv:53000/branch_queue_api/teller.php

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    header('HTTP/1.1 405 Method Not Allowed');
    echo '405 Method Not Allowed';
    exit;
}

// Function to perform a SELECT query on a MySQL database using mysqli
function performSelectQuery($mysqli, $query) {
    // Prepare the SQL statement
    if ($stmt = $mysqli->prepare($query)) {
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

// Example SELECT query (replace with your actual query)
$query = 'SELECT branch_teller.id, branch_teller.name, branch_teller.type, branch_teller.branch_id, branch_queue.branch FROM branch_teller
JOIN branch_queue ON branch_teller.branch_id = branch_queue.id ORDER BY branch_teller.name ASC';  // Using a placeholder for parameterized query

$result = performSelectQuery($mysqli, $query);

// Print the result
header('HTTP/1.1 200 OK');
echo json_encode($result);

// Close the database connection
$mysqli->close();


?>