<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login | CraveRush</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/images/craverush-icon.svg">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="admin-body">
    <section class="auth-section" id="adminLoginSection">
        <div class="auth-container">
            <div class="auth-card admin-auth-card">
                <div class="auth-header">
                    <img src="${pageContext.request.contextPath}/images/craverush-logo.svg" alt="CraveRush" class="auth-logo-img" id="adminLoginLogo">
                    <h1 class="auth-title">Admin Panel</h1>
                    <p class="auth-subtitle">CraveRush Administration</p>
                </div>

                <c:if test="${error != null}">
                    <div class="alert alert-error"><span class="alert-icon">⚠️</span> <c:out value="${error}"/></div>
                </c:if>

                <form action="${pageContext.request.contextPath}/admin/login" method="post" class="auth-form" id="adminLoginForm">
                    <div class="form-group">
                        <label for="email" class="form-label">Email</label>
                        <input type="email" id="email" name="email" class="form-input" placeholder="admin@craverush.com" required>
                    </div>
                    <div class="form-group">
                        <label for="password" class="form-label">Password</label>
                        <input type="password" id="password" name="password" class="form-input" placeholder="Enter password" required>
                    </div>
                    <button type="submit" class="btn btn-primary btn-block" id="adminLoginBtn">Login to Dashboard</button>
                </form>
                <div class="auth-footer">
                    <a href="${pageContext.request.contextPath}/home" class="auth-link">← Back to CraveRush</a>
                </div>
            </div>
        </div>
    </section>
</body>
</html>
