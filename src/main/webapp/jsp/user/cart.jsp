<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="Cart"/></jsp:include>

    <section class="page-section" id="cartSection">
        <div class="container">
            <h1 class="page-title">Your Cart</h1>

            <c:choose>
                <c:when test="${empty cartItems}">
                    <div class="empty-state" id="emptyCart">
                        <span class="empty-icon">🛒</span>
                        <h3>Your cart is empty</h3>
                        <p>Add items from a restaurant to get started.</p>
                        <a href="${pageContext.request.contextPath}/restaurants" class="btn btn-primary">Browse Restaurants</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="cart-layout">
                        <div class="cart-items" id="cartItemsList">
                            <div class="cart-restaurant-header">
                                <span class="restaurant-emoji">🍽️</span>
                                <h3>${cartItems[0].restaurantName}</h3>
                            </div>

                            <c:forEach var="ci" items="${cartItems}">
                                <div class="cart-item" id="cartItem-${ci.cartId}">
                                    <div class="cart-item-info">
                                        <span class="menu-item-veg-indicator ${ci.itemIsVeg ? 'veg' : 'non-veg'}">
                                            <span class="veg-dot"></span>
                                        </span>
                                        <div>
                                            <h4 class="cart-item-name"><c:out value="${ci.itemName}"/></h4>
                                            <p class="cart-item-price">₹<fmt:formatNumber value="${ci.itemPrice}" pattern="#,##0.00"/></p>
                                        </div>
                                    </div>
                                    <div class="cart-item-controls">
                                        <div class="qty-control">
                                            <button class="qty-btn qty-minus" onclick="updateCartItem(${ci.cartId}, ${ci.quantity - 1})">−</button>
                                            <span class="qty-value" id="qty-${ci.cartId}">${ci.quantity}</span>
                                            <button class="qty-btn qty-plus" onclick="updateCartItem(${ci.cartId}, ${ci.quantity + 1})">+</button>
                                        </div>
                                        <p class="cart-item-total">₹<fmt:formatNumber value="${ci.totalPrice}" pattern="#,##0.00"/></p>
                                        <button class="cart-item-remove" onclick="updateCartItem(${ci.cartId}, 0)" title="Remove item" style="background: none; border: none; color: #ff4d4f; font-size: 1.2rem; cursor: pointer; padding: 4px; margin-left: 12px; transition: opacity 0.2s;">🗑️</button>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <div class="cart-summary" id="cartSummary">
                            <h3 class="cart-summary-title">Bill Details</h3>
                            <div class="cart-summary-row">
                                <span>Item Total</span>
                                <span>₹<fmt:formatNumber value="${subtotal}" pattern="#,##0.00"/></span>
                            </div>
                            <div class="cart-summary-row">
                                <span>Delivery Fee</span>
                                <span>₹<fmt:formatNumber value="${deliveryFee}" pattern="#,##0.00"/></span>
                            </div>
                            <div class="cart-summary-row">
                                <span>GST (5%)</span>
                                <span>₹<fmt:formatNumber value="${tax}" pattern="#,##0.00"/></span>
                            </div>
                            <hr class="cart-summary-divider">
                            <div class="cart-summary-row cart-summary-total">
                                <span>To Pay</span>
                                <span>₹<fmt:formatNumber value="${grandTotal}" pattern="#,##0.00"/></span>
                            </div>
                            <a href="${pageContext.request.contextPath}/checkout" class="btn btn-primary btn-block" id="checkoutBtn">
                                Proceed to Checkout
                            </a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

    <script>
        async function updateCartItem(cartId, quantity) {
            if (quantity < 0) {
                return;
            }
            if (quantity === 0) {
                const confirmed = await showCustomConfirm(
                    "Remove Item?", 
                    "Are you sure you want to remove this item from your cart?", 
                    "🗑️", 
                    "Remove", 
                    "var(--red)"
                );
                
                if(!confirmed) return;
                
                fetch('${pageContext.request.contextPath}/cart', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: 'action=remove&cartId=' + cartId
                })
                .then(r => r.json())
                .then(data => {
                    if (data.success) window.location.reload();
                });
                return;
            }

            fetch('${pageContext.request.contextPath}/cart', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'action=update&cartId=' + cartId + '&quantity=' + quantity
            })
            .then(response => {
                if (response.status === 401) {
                    window.location.href = '${pageContext.request.contextPath}/login';
                    throw new Error("Unauthorized");
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    window.location.reload(); 
                } else if (data.error) {
                    showCustomAlert("Error", data.error, "❌");
                }
            })
            .catch(err => console.error("Error updating cart:", err));
        }
    </script>

<jsp:include page="/jsp/common/footer.jsp"/>
