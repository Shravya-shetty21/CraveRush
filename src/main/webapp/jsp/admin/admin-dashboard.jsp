<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | CraveRush</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/images/craverush-icon.svg">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="admin-body">
    <nav class="admin-nav" id="adminNav">
        <div class="admin-nav-container">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-logo">
                <img src="${pageContext.request.contextPath}/images/craverush-icon.svg" alt="CraveRush" class="admin-nav-logo-img"> <span class="logo-text">CraveRush</span> <span class="admin-badge">Admin</span>
            </a>
            <div class="admin-nav-links">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="admin-nav-link active">📊 Dashboard</a>
                <a href="${pageContext.request.contextPath}/admin/restaurants" class="admin-nav-link">🍽️ Restaurants</a>
                <a href="${pageContext.request.contextPath}/admin/menu" class="admin-nav-link">📋 Menu</a>
                <a href="${pageContext.request.contextPath}/admin/orders" class="admin-nav-link">📦 Orders</a>
                <a href="${pageContext.request.contextPath}/admin/logout" class="admin-nav-link admin-nav-logout">🚪 Logout</a>
            </div>
        </div>
    </nav>

    <main class="admin-main">
        <div class="admin-container">
            <h1 class="admin-page-title">Dashboard</h1>
            <p class="admin-welcome">Welcome back, <strong>${sessionScope.loggedInAdmin.fullName}</strong>!</p>

            <div class="admin-stats-grid">
                <div class="admin-stat-card stat-orange">
                    <span class="stat-icon">🍽️</span>
                    <div class="stat-info">
                        <p class="stat-value">${totalRestaurants}</p>
                        <p class="stat-label">Restaurants</p>
                    </div>
                </div>
                <div class="admin-stat-card stat-blue">
                    <span class="stat-icon">📦</span>
                    <div class="stat-info">
                        <p class="stat-value">${totalOrders}</p>
                        <p class="stat-label">Total Orders</p>
                    </div>
                </div>
                <div class="admin-stat-card stat-yellow">
                    <span class="stat-icon">⏳</span>
                    <div class="stat-info">
                        <p class="stat-value">${pendingOrders}</p>
                        <p class="stat-label">Pending</p>
                    </div>
                </div>
                <div class="admin-stat-card stat-green">
                    <span class="stat-icon">✅</span>
                    <div class="stat-info">
                        <p class="stat-value">${deliveredOrders}</p>
                        <p class="stat-label">Delivered</p>
                    </div>
                </div>
            </div>

            <div class="admin-quick-actions">
                <h2>Quick Actions</h2>
                <div class="quick-actions-grid">
                    <a href="${pageContext.request.contextPath}/admin/restaurants" class="quick-action-card">
                        <span class="qa-icon">➕</span>
                        <span>Manage Restaurants</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/menu" class="quick-action-card">
                        <span class="qa-icon">📋</span>
                        <span>Manage Menu</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/orders" class="quick-action-card">
                        <span class="qa-icon">📦</span>
                        <span>View Orders</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/orders?status=PLACED" class="quick-action-card">
                        <span class="qa-icon">🔔</span>
                        <span>New Orders</span>
                    </a>
                </div>
            </div>
        </div>
    </main>
</body>
</html>
