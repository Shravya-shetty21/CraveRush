<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="Order #${order.orderId}"/></jsp:include>

    <section class="page-section" id="orderDetailSection">
        <div class="container">
            <a href="${pageContext.request.contextPath}/orders" class="back-link">← Back to Orders</a>

            <div class="order-detail-header" style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 12px;">
                <div>
                    <h1 class="page-title">Order #${order.orderId}</h1>
                    <p class="order-detail-restaurant"><c:out value="${order.restaurantName}"/></p>
                </div>
                <div style="display: flex; align-items: center; gap: 12px;">
                    <span class="order-status order-status-${order.status.toLowerCase()}">${order.status}</span>
                    <c:if test="${order.status != 'DELIVERED' && order.status != 'CANCELLED'}">
                        <a href="${pageContext.request.contextPath}/track-order?id=${order.orderId}" class="btn btn-sm btn-primary" style="background: var(--green);">Track Order</a>
                    </c:if>
                </div>
            </div>

            <div class="order-detail-grid">
                <div class="order-detail-items">
                    <h3>Items Ordered</h3>
                    <c:forEach var="item" items="${orderItems}">
                        <div class="order-detail-item">
                            <span class="menu-item-veg-indicator ${item.itemIsVeg ? 'veg' : 'non-veg'}">
                                <span class="veg-dot"></span>
                            </span>
                            <div class="order-detail-item-info">
                                <span class="order-detail-item-name"><c:out value="${item.itemName}"/></span>
                                <span class="order-detail-item-qty">× ${item.quantity}</span>
                            </div>
                            <span class="order-detail-item-price">₹<fmt:formatNumber value="${item.totalPrice}" pattern="#,##0.00"/></span>
                        </div>
                    </c:forEach>
                </div>

                <div class="order-detail-summary">
                    <h3>Bill Details</h3>
                    <div class="cart-summary-row">
                        <span>Item Total</span>
                        <span>₹<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></span>
                    </div>
                    <div class="cart-summary-row">
                        <span>Delivery Fee</span>
                        <span>₹<fmt:formatNumber value="${order.deliveryFee}" pattern="#,##0.00"/></span>
                    </div>
                    <div class="cart-summary-row">
                        <span>Taxes</span>
                        <span>₹<fmt:formatNumber value="${order.taxAmount}" pattern="#,##0.00"/></span>
                    </div>
                    <hr class="cart-summary-divider">
                    <div class="cart-summary-row cart-summary-total">
                        <span>Grand Total</span>
                        <span>₹<fmt:formatNumber value="${order.grandTotal}" pattern="#,##0.00"/></span>
                    </div>

                    <div class="order-detail-info-section">
                        <h4>Delivery Address</h4>
                        <p><c:out value="${order.deliveryAddress}"/></p>
                    </div>

                    <c:if test="${payment != null}">
                        <div class="order-detail-info-section">
                            <h4>Payment</h4>
                            <p>${payment.paymentMethod} — ${payment.paymentStatus}</p>
                        </div>
                    </c:if>

                    <div class="order-detail-info-section">
                        <h4>Ordered On</h4>
                        <p>${order.formattedOrderDate}</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

<jsp:include page="/jsp/common/footer.jsp"/>
