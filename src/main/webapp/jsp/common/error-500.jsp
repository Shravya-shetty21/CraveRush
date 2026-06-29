<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Server Error | CraveRush</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="auth-section">
        <div class="auth-container" style="text-align:center;">
            <div style="font-size:6rem;margin-bottom:16px;">🔧</div>
            <h1 style="font-size:3rem;font-weight:800;margin-bottom:8px;">500</h1>
            <p style="color:#93959F;font-size:1.1rem;margin-bottom:24px;">Something went wrong. We're working on it!</p>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">Back to Home</a>
        </div>
    </div>
</body>
</html>
