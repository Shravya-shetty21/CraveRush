<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="My Orders"/></jsp:include>

    <section class="page-section" id="ordersSection">
        <div class="container">
            <h1 class="page-title">My Orders</h1>

            <c:if test="${successMessage != null}">
                <div class="alert alert-success" id="orderSuccess">
                    <span class="alert-icon">✅</span> <c:out value="${successMessage}"/>
                </div>
            </c:if>

            <c:choose>
                <c:when test="${empty orders}">
                    <div class="empty-state" id="noOrders">
                        <span class="empty-icon">📋</span>
                        <h3>No orders yet</h3>
                        <p>When you place orders, they'll show up here.</p>
                        <a href="${pageContext.request.contextPath}/restaurants" class="btn btn-primary">Start Ordering</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="orders-list">
                        <c:forEach var="order" items="${orders}">
                            <div class="order-card" id="order-${order.orderId}" style="position: relative;">
                                <div class="order-card-header">
                                    <div>
                                        <h3 class="order-restaurant-name"><c:out value="${order.restaurantName}"/></h3>
                                        <p class="order-id">Order #${order.orderId}</p>
                                    </div>
                                    <span class="order-status order-status-${order.status.toLowerCase()}">${order.status}</span>
                                </div>
                                <div class="order-card-body" style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 12px; margin-top: 8px;">
                                    <p class="order-meta" style="margin: 0;">
                                        <span>${order.itemCount} item(s)</span>
                                        <span class="rd-dot">•</span>
                                        <span>₹<fmt:formatNumber value="${order.grandTotal}" pattern="#,##0.00"/></span>
                                        <span class="rd-dot">•</span>
                                        <span>${order.formattedOrderDate}</span>
                                    </p>
                                    <div style="display: flex; gap: 8px;">
                                        <a href="${pageContext.request.contextPath}/orders?id=${order.orderId}" class="btn btn-sm btn-outline">View Details</a>
                                        <c:if test="${order.status != 'DELIVERED' && order.status != 'CANCELLED'}">
                                            <a href="${pageContext.request.contextPath}/track-order?id=${order.orderId}" class="btn btn-sm btn-primary" style="background: var(--green);">Track Order</a>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

<jsp:include page="/jsp/common/footer.jsp"/>
