<?php
// Set headers for CORS and JSON response
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST");
header("Content-Type: application/json");

$servername = "localhost";  // Update with your server
$username = "root";         // Update with your username
$password = "";             // Update with your password
$dbname = "your_database";  // Update with your database name

// Connect to the database
$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode(["status" => "fail", "message" => "Database connection failed"]);
    exit();
}

// Get JSON payload from request
$data = json_decode(file_get_contents('php://input'), true);

// Validate received data
if (!isset($data['uid']) || !isset($data['email']) || !isset($data['phone'])) {
    http_response_code(400);
    echo json_encode(["status" => "fail", "message" => "Invalid input"]);
    exit();
}

$uid = $conn->real_escape_string($data['uid']);
$email = $conn->real_escape_string($data['email']);
$phone = $conn->real_escape_string($data['phone']);

// Insert data into the database
$query = "INSERT INTO users (uid, email, phone) VALUES ('$uid', '$email', '$phone')";

if ($conn->query($query) === TRUE) {
    http_response_code(200);
    echo json_encode(["status" => "success", "message" => "Data inserted successfully"]);
} else {
    http_response_code(500);
    echo json_encode(["status" => "fail", "message" => $conn->error]);
}

// Close database connection
$conn->close();
?>
