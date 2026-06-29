<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Orders | CraveRush Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/images/craverush-icon.svg">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="admin-body">
    <nav class="admin-nav"><div class="admin-nav-container">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-logo"><img src="${pageContext.request.contextPath}/images/craverush-icon.svg" alt="CraveRush" class="admin-nav-logo-img"> <span class="logo-text">CraveRush</span> <span class="admin-badge">Admin</span></a>
        <div class="admin-nav-links">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="admin-nav-link">📊 Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/restaurants" class="admin-nav-link">🍽️ Restaurants</a>
            <a href="${pageContext.request.contextPath}/admin/menu" class="admin-nav-link">📋 Menu</a>
            <a href="${pageContext.request.contextPath}/admin/orders" class="admin-nav-link active">📦 Orders</a>
            <a href="${pageContext.request.contextPath}/admin/logout" class="admin-nav-link admin-nav-logout">🚪 Logout</a>
        </div>
    </div></nav>

    <main class="admin-main"><div class="admin-container">
        <h1 class="admin-page-title">Manage Orders</h1>

        <!-- Status Filter -->
        <div class="cuisine-filters" style="margin-bottom:1.5rem;">
            <a href="${pageContext.request.contextPath}/admin/orders" class="cuisine-pill ${statusFilter == null ? 'active' : ''}">All</a>
            <a href="${pageContext.request.contextPath}/admin/orders?status=PLACED" class="cuisine-pill ${statusFilter == 'PLACED' ? 'active' : ''}">Placed</a>
            <a href="${pageContext.request.contextPath}/admin/orders?status=CONFIRMED" class="cuisine-pill ${statusFilter == 'CONFIRMED' ? 'active' : ''}">Confirmed</a>
            <a href="${pageContext.request.contextPath}/admin/orders?status=PREPARING" class="cuisine-pill ${statusFilter == 'PREPARING' ? 'active' : ''}">Preparing</a>
            <a href="${pageContext.request.contextPath}/admin/orders?status=OUT_FOR_DELIVERY" class="cuisine-pill ${statusFilter == 'OUT_FOR_DELIVERY' ? 'active' : ''}">Out for Delivery</a>
            <a href="${pageContext.request.contextPath}/admin/orders?status=DELIVERED" class="cuisine-pill ${statusFilter == 'DELIVERED' ? 'active' : ''}">Delivered</a>
            <a href="${pageContext.request.contextPath}/admin/orders?status=CANCELLED" class="cuisine-pill ${statusFilter == 'CANCELLED' ? 'active' : ''}">Cancelled</a>
        </div>

        <!-- Orders Table -->
        <div class="admin-table-card">
            <h2>Orders (${orders.size()})</h2>
            <c:choose>
                <c:when test="${empty orders}">
                    <div class="empty-state"><span class="empty-icon">📦</span><h3>No orders found</h3></div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="admin-table">
                            <thead><tr><th>ID</th><th>Customer</th><th>Restaurant</th><th>Items</th><th>Total</th><th>Date</th><th>Status</th><th>Action</th></tr></thead>
                            <tbody>
                                <c:forEach var="o" items="${orders}">
                                    <tr>
                                        <td>#${o.orderId}</td>
                                        <td><c:out value="${o.userName}"/></td>
                                        <td><c:out value="${o.restaurantName}"/></td>
                                        <td>${o.itemCount}</td>
                                        <td>₹<fmt:formatNumber value="${o.grandTotal}" pattern="#,##0.00"/></td>
                                        <td>${o.formattedOrderDateShort}</td>
                                        <td><span class="order-status order-status-${o.status.toLowerCase()}">${o.status}</span></td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/admin/orders" method="post" class="admin-inline-form">
                                                <input type="hidden" name="action" value="updateStatus">
                                                <input type="hidden" name="orderId" value="${o.orderId}">
                                                <select name="status" class="form-input form-select form-select-sm" onchange="this.form.submit()">
                                                    <option value="PLACED" ${o.status == 'PLACED' ? 'selected' : ''}>Placed</option>
                                                    <option value="CONFIRMED" ${o.status == 'CONFIRMED' ? 'selected' : ''}>Confirmed</option>
                                                    <option value="PREPARING" ${o.status == 'PREPARING' ? 'selected' : ''}>Preparing</option>
                                                    <option value="OUT_FOR_DELIVERY" ${o.status == 'OUT_FOR_DELIVERY' ? 'selected' : ''}>Out for Delivery</option>
                                                    <option value="DELIVERED" ${o.status == 'DELIVERED' ? 'selected' : ''}>Delivered</option>
                                                    <option value="CANCELLED" ${o.status == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                                                </select>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div></main>
</body>
</html>
