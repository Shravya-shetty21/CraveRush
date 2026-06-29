<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Menu | CraveRush Admin</title>
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
            <a href="${pageContext.request.contextPath}/admin/menu" class="admin-nav-link active">📋 Menu</a>
            <a href="${pageContext.request.contextPath}/admin/orders" class="admin-nav-link">📦 Orders</a>
            <a href="${pageContext.request.contextPath}/admin/logout" class="admin-nav-link admin-nav-logout">🚪 Logout</a>
        </div>
    </div></nav>

    <main class="admin-main"><div class="admin-container">
        <h1 class="admin-page-title">Manage Menu Items</h1>

        <!-- Restaurant Selector -->
        <div class="admin-form-card">
            <h2>Select Restaurant</h2>
            <form action="${pageContext.request.contextPath}/admin/menu" method="get" class="admin-inline-form">
                <select name="restaurantId" class="form-input form-select" onchange="this.form.submit()">
                    <option value="">-- Select Restaurant --</option>
                    <c:forEach var="r" items="${restaurants}">
                        <option value="${r.restaurantId}" ${selectedRestaurantId == r.restaurantId ? 'selected' : ''}><c:out value="${r.name}"/></option>
                    </c:forEach>
                </select>
            </form>
        </div>

        <c:if test="${selectedRestaurantId != null}">
            <!-- Add/Edit Form -->
            <div class="admin-form-card">
                <h2>${editItem != null ? 'Edit' : 'Add New'} Menu Item — ${selectedRestaurant.name}</h2>
                <form action="${pageContext.request.contextPath}/admin/menu" method="post">
                    <input type="hidden" name="action" value="${editItem != null ? 'update' : 'add'}">
                    <input type="hidden" name="restaurantId" value="${selectedRestaurantId}">
                    <c:if test="${editItem != null}">
                        <input type="hidden" name="itemId" value="${editItem.itemId}">
                    </c:if>
                    <div class="admin-form-grid">
                        <div class="form-group"><label class="form-label">Name</label>
                            <input type="text" name="name" class="form-input" value="${editItem.name}" required></div>
                        <div class="form-group"><label class="form-label">Price (₹)</label>
                            <input type="number" name="price" class="form-input" value="${editItem.price}" step="0.01" required></div>
                        <div class="form-group"><label class="form-label">Category</label>
                            <input type="text" name="category" class="form-input" value="${editItem.category}" placeholder="e.g. Starters, Main Course" required></div>
                        <div class="form-group"><label class="form-label">Image URL</label>
                            <input type="text" name="imageUrl" class="form-input" value="${editItem.imageUrl}"></div>
                        <div class="form-group" style="grid-column: 1 / -1;"><label class="form-label">Description</label>
                            <textarea name="description" class="form-input form-textarea" rows="2">${editItem.description}</textarea></div>
                    </div>
                    <div class="form-group form-group-inline">
                        <label><input type="checkbox" name="isVeg" ${editItem.veg ? 'checked' : ''}> Veg</label>
                        <label><input type="checkbox" name="isBestseller" ${editItem.bestseller ? 'checked' : ''}> Bestseller</label>
                    </div>
                    <button type="submit" class="btn btn-primary">${editItem != null ? 'Update' : 'Add'} Item</button>
                    <c:if test="${editItem != null}">
                        <a href="${pageContext.request.contextPath}/admin/menu?restaurantId=${selectedRestaurantId}" class="btn btn-outline">Cancel</a>
                    </c:if>
                </form>
            </div>

            <!-- Menu Items List -->
            <div class="admin-table-card">
                <h2>Menu Items (${menuItems.size()})</h2>
                <div class="table-responsive">
                    <table class="admin-table">
                        <thead><tr><th>ID</th><th>Name</th><th>Category</th><th>Price</th><th>Veg</th><th>Status</th><th>Actions</th></tr></thead>
                        <tbody>
                            <c:forEach var="item" items="${menuItems}">
                                <tr>
                                    <td>${item.itemId}</td>
                                    <td><strong><c:out value="${item.name}"/></strong>
                                        <c:if test="${item.bestseller}"><span class="bestseller-tag">★ Bestseller</span></c:if></td>
                                    <td><c:out value="${item.category}"/></td>
                                    <td>₹<fmt:formatNumber value="${item.price}" pattern="#,##0.00"/></td>
                                    <td>${item.veg ? '🟢' : '🔴'}</td>
                                    <td><span class="status-badge ${item.available ? 'status-active' : 'status-inactive'}">${item.available ? 'Available' : 'Unavailable'}</span></td>
                                    <td class="table-actions">
                                        <a href="${pageContext.request.contextPath}/admin/menu?restaurantId=${selectedRestaurantId}&action=edit&itemId=${item.itemId}" class="btn btn-sm btn-outline">Edit</a>
                                        <form action="${pageContext.request.contextPath}/admin/menu" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="delete"><input type="hidden" name="itemId" value="${item.itemId}"><input type="hidden" name="restaurantId" value="${selectedRestaurantId}">
                                            <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Delete this item?')">Delete</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>
    </div></main>
</body>
</html>
