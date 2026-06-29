<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Restaurants | CraveRush Admin</title>
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
            <a href="${pageContext.request.contextPath}/admin/restaurants" class="admin-nav-link active">🍽️ Restaurants</a>
            <a href="${pageContext.request.contextPath}/admin/menu" class="admin-nav-link">📋 Menu</a>
            <a href="${pageContext.request.contextPath}/admin/orders" class="admin-nav-link">📦 Orders</a>
            <a href="${pageContext.request.contextPath}/admin/logout" class="admin-nav-link admin-nav-logout">🚪 Logout</a>
        </div>
    </div></nav>

    <main class="admin-main"><div class="admin-container">
        <h1 class="admin-page-title">Manage Restaurants</h1>

        <!-- Add/Edit Form -->
        <div class="admin-form-card" id="restaurantForm">
            <h2>${restaurant != null ? 'Edit' : 'Add New'} Restaurant</h2>
            <form action="${pageContext.request.contextPath}/admin/restaurants" method="post">
                <input type="hidden" name="action" value="${restaurant != null ? 'update' : 'add'}">
                <c:if test="${restaurant != null}">
                    <input type="hidden" name="restaurantId" value="${restaurant.restaurantId}">
                </c:if>
                <div class="admin-form-grid">
                    <div class="form-group"><label class="form-label">Name</label>
                        <input type="text" name="name" class="form-input" value="${restaurant.name}" required></div>
                    <div class="form-group"><label class="form-label">Cuisine Type</label>
                        <input type="text" name="cuisineType" class="form-input" value="${restaurant.cuisineType}" placeholder="e.g. Italian, Chinese" required></div>
                    <div class="form-group"><label class="form-label">Address</label>
                        <input type="text" name="address" class="form-input" value="${restaurant.address}" required></div>
                    <div class="form-group"><label class="form-label">City</label>
                        <input type="text" name="city" class="form-input" value="${restaurant.city}" required></div>
                    <div class="form-group"><label class="form-label">Pincode</label>
                        <input type="text" name="pincode" class="form-input" value="${restaurant.pincode}" required></div>
                    <div class="form-group"><label class="form-label">Phone</label>
                        <input type="text" name="phone" class="form-input" value="${restaurant.phone}"></div>
                    <div class="form-group"><label class="form-label">Email</label>
                        <input type="email" name="email" class="form-input" value="${restaurant.email}"></div>
                    <div class="form-group"><label class="form-label">Image URL</label>
                        <input type="text" name="imageUrl" class="form-input" value="${restaurant.imageUrl}"></div>
                    <div class="form-group"><label class="form-label">Rating</label>
                        <input type="number" name="rating" class="form-input" value="${restaurant.rating}" step="0.1" min="0" max="5"></div>
                    <div class="form-group"><label class="form-label">Delivery Time (min)</label>
                        <input type="number" name="deliveryTime" class="form-input" value="${restaurant != null ? restaurant.deliveryTime : 30}"></div>
                    <div class="form-group"><label class="form-label">Min Order (₹)</label>
                        <input type="number" name="minOrder" class="form-input" value="${restaurant.minOrder}" step="0.01"></div>
                    <div class="form-group"><label class="form-label">Description</label>
                        <textarea name="description" class="form-input form-textarea" rows="2">${restaurant.description}</textarea></div>
                </div>
                <div class="form-group form-group-inline">
                    <label><input type="checkbox" name="isVeg" ${restaurant.veg ? 'checked' : ''}> Pure Veg</label>
                </div>
                <button type="submit" class="btn btn-primary">${restaurant != null ? 'Update' : 'Add'} Restaurant</button>
                <c:if test="${restaurant != null}">
                    <a href="${pageContext.request.contextPath}/admin/restaurants" class="btn btn-outline">Cancel</a>
                </c:if>
            </form>
        </div>

        <!-- Restaurants List -->
        <div class="admin-table-card">
            <h2>All Restaurants (${restaurants.size()})</h2>
            <div class="table-responsive">
                <table class="admin-table">
                    <thead><tr>
                        <th>ID</th><th>Name</th><th>Cuisine</th><th>City</th><th>Rating</th><th>Status</th><th>Actions</th>
                    </tr></thead>
                    <tbody>
                        <c:forEach var="r" items="${restaurants}">
                            <tr>
                                <td>${r.restaurantId}</td>
                                <td><strong><c:out value="${r.name}"/></strong></td>
                                <td><c:out value="${r.cuisineType}"/></td>
                                <td><c:out value="${r.city}"/></td>
                                <td><span class="rating-star">★</span> ${r.rating}</td>
                                <td><span class="status-badge ${r.active ? 'status-active' : 'status-inactive'}">${r.active ? 'Active' : 'Inactive'}</span></td>
                                <td class="table-actions">
                                    <a href="${pageContext.request.contextPath}/admin/restaurants?action=edit&id=${r.restaurantId}" class="btn btn-sm btn-outline">Edit</a>
                                    <form action="${pageContext.request.contextPath}/admin/restaurants" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="${r.restaurantId}">
                                        <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Delete this restaurant?')">Delete</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div></main>
</body>
</html>
