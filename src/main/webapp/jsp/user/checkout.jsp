<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="Checkout"/></jsp:include>

    <section class="page-section" id="checkoutSection">
        <div class="container">
            <h1 class="page-title">Checkout</h1>

            <c:if test="${error != null}">
                <div class="alert alert-error"><span class="alert-icon">⚠️</span> <c:out value="${error}"/></div>
            </c:if>

            <div class="checkout-layout">
                <div class="checkout-form-area">
                    <form action="${pageContext.request.contextPath}/checkout" method="post" class="checkout-form" id="checkoutForm">
                        <div class="checkout-card">
                            <h3 class="checkout-card-title">📍 Delivery Address</h3>
                            
                            <c:if test="${not empty addresses}">
                                <div class="saved-addresses" style="display: flex; flex-direction: column; gap: 10px; margin-bottom: 16px;">
                                    <p style="font-size: 0.85rem; font-weight: 700; color: var(--text-secondary); margin: 0 0 4px;">Select a Saved Address:</p>
                                    <c:forEach var="addr" items="${addresses}">
                                        <label style="display: flex; align-items: flex-start; gap: 8px; font-size: 0.85rem; cursor: pointer; border: 1px solid var(--border); padding: 10px; border-radius: var(--radius-sm); background: #fafafa; transition: var(--transition);">
                                            <input type="radio" name="addressId" value="${addr.addressId}" style="margin-top: 3px;" onchange="selectSavedAddress('${addr.fullAddress.replace("'", "\\'")}')">
                                            <div>
                                                <span style="font-weight: 700; color: var(--text-primary); text-transform: uppercase; font-size: 0.7rem; background: #eef2f5; padding: 2px 6px; border-radius: 4px; display: inline-block; margin-bottom: 4px;">${addr.addressType}</span>
                                                <p style="margin: 0; color: var(--text-secondary); line-height: 1.4;">${addr.fullAddress}</p>
                                            </div>
                                        </label>
                                    </c:forEach>
                                </div>
                            </c:if>
                            
                            <div class="form-group">
                                <label class="form-label" for="deliveryAddress">Or Enter New Address:</label>
                                <textarea name="deliveryAddress" id="deliveryAddress" class="form-input form-textarea"
                                          placeholder="Enter your full delivery address..." required rows="3"></textarea>
                            </div>
                        </div>

                        <div class="checkout-card">
                            <h3 class="checkout-card-title">💳 Payment Method</h3>
                            <div class="payment-options">
                                <label class="payment-option">
                                    <input type="radio" name="paymentMethod" value="COD" checked>
                                    <span class="payment-option-label">
                                        <span class="payment-icon">💵</span> Cash on Delivery
                                    </span>
                                </label>
                                <label class="payment-option">
                                    <input type="radio" name="paymentMethod" value="ONLINE">
                                    <span class="payment-option-label">
                                        <span class="payment-icon">📱</span> Online Payment (UPI, Card, Wallet)
                                    </span>
                                </label>
                            </div>
                        </div>

                        <div class="checkout-card">
                            <h3 class="checkout-card-title">📝 Special Instructions</h3>
                            <div class="form-group">
                                <textarea name="notes" id="orderNotes" class="form-input form-textarea"
                                          placeholder="Any special instructions? (optional)" rows="2"></textarea>
                            </div>
                        </div>

                        <div class="checkout-card">
                            <h3 class="checkout-card-title">🏷️ Apply Coupon</h3>
                            <div class="form-group" style="display: flex; flex-direction: row; gap: 8px;">
                                <input type="text" name="couponCode" id="couponCode" class="form-input" placeholder="Enter coupon code (e.g. CRAVE50)" style="flex: 1; text-transform: uppercase;">
                                <button type="button" class="btn btn-outline" onclick="applyCoupon()" style="padding: 0 16px; font-size: 0.8rem; height: 44px; border-radius: var(--radius-sm);">Apply</button>
                            </div>
                            <div style="display: flex; flex-direction: column; gap: 8px; margin-top: 14px;">
                                <p style="font-size: 0.75rem; font-weight: 700; color: var(--text-secondary); margin: 0;">Available Coupons (Click to Apply):</p>
                                <div style="display: flex; flex-wrap: wrap; gap: 8px;">
                                    <div onclick="selectCoupon('CRAVE50')" style="background: var(--primary-light); color: var(--primary); border: 1px dashed var(--primary); padding: 6px 12px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 700; cursor: pointer; transition: var(--transition);" onmouseover="this.style.transform='scale(1.03)'" onmouseout="this.style.transform='scale(1)'">
                                        CRAVE50 (50% OFF)
                                    </div>
                                    <div onclick="selectCoupon('FREE50')" style="background: var(--green-light); color: var(--green); border: 1px dashed var(--green); padding: 6px 12px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 700; cursor: pointer; transition: var(--transition);" onmouseover="this.style.transform='scale(1.03)'" onmouseout="this.style.transform='scale(1)'">
                                        FREE50 (₹50 OFF)
                                    </div>
                                    <div onclick="selectCoupon('HDFC10')" style="background: #eef2f5; color: var(--secondary); border: 1px dashed var(--secondary); padding: 6px 12px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 700; cursor: pointer; transition: var(--transition);" onmouseover="this.style.transform='scale(1.03)'" onmouseout="this.style.transform='scale(1)'">
                                        HDFC10 (10% OFF)
                                    </div>
                                </div>
                            </div>
                            <p id="couponMessage" style="font-size: 0.8rem; margin-top: 6px; display: none; font-weight: 600;"></p>
                        </div>

                        <button type="submit" class="btn btn-primary btn-lg btn-block" id="placeOrderBtn" style="margin-top: 10px;">
                            Place Order — ₹<fmt:formatNumber value="${grandTotal}" pattern="#,##0.00"/>
                        </button>
                    </form>
                </div>
                
                <script>
                    function selectSavedAddress(addrText) {
                        document.getElementById("deliveryAddress").value = addrText;
                    }
                    
                    let currentSubtotal = ${subtotal};
                    let currentDeliveryFee = ${deliveryFee};
                    let currentTax = ${tax};
                    let currentPlatformFee = 5.00;

                    function selectCoupon(code) {
                        document.getElementById("couponCode").value = code;
                        applyCoupon();
                    }

                    function applyCoupon() {
                        const code = document.getElementById("couponCode").value.trim().toUpperCase();
                        const msg = document.getElementById("couponMessage");
                        let discount = 0;
                        
                        if (code === "CRAVE50" || code === "CRAVERUSH50") {
                            discount = currentSubtotal * 0.5;
                            if (discount > 100) discount = 100;
                            msg.style.color = "var(--green)";
                            msg.innerText = "Coupon applied! You saved ₹" + discount.toFixed(2) + " (50% off up to ₹100)";
                            msg.style.display = "block";
                        } else if (code === "FREE50") {
                            discount = 50;
                            msg.style.color = "var(--green)";
                            msg.innerText = "Coupon applied! You saved ₹50.00 (Flat ₹50 off)";
                            msg.style.display = "block";
                        } else if (code === "HDFC10") {
                            discount = currentSubtotal * 0.10;
                            if (discount > 150) discount = 150;
                            msg.style.color = "var(--green)";
                            msg.innerText = "Coupon applied! You saved ₹" + discount.toFixed(2) + " (10% off up to ₹150)";
                            msg.style.display = "block";
                        } else if (code === "") {
                            discount = 0;
                            msg.style.display = "none";
                        } else {
                            discount = 0;
                            msg.style.color = "var(--red)";
                            msg.innerText = "Invalid coupon code.";
                            msg.style.display = "block";
                        }
                        
                        let finalTotal = currentSubtotal + currentDeliveryFee + currentTax + currentPlatformFee - discount;
                        if (finalTotal < 0) finalTotal = 0;
                        
                        // Update Summary UI
                        document.getElementById("summaryDiscountRow").style.display = discount > 0 ? "flex" : "none";
                        document.getElementById("summaryDiscountVal").innerText = "-₹" + discount.toFixed(2);
                        
                        document.getElementById("summaryTotalVal").innerText = "₹" + finalTotal.toLocaleString('en-IN', {minimumFractionDigits: 2, maximumFractionDigits: 2});
                        document.getElementById("placeOrderBtn").innerText = "Place Order — ₹" + finalTotal.toLocaleString('en-IN', {minimumFractionDigits: 2, maximumFractionDigits: 2});
                    }
                </script>

                <div class="cart-summary" id="checkoutSummary">
                    <h3 class="cart-summary-title">Order Summary</h3>
                    <c:forEach var="ci" items="${cartItems}">
                        <div class="checkout-item">
                            <span class="checkout-item-name">
                                <span class="menu-item-veg-indicator ${ci.itemIsVeg ? 'veg' : 'non-veg'}" style="display:inline-block;margin-right:6px;">
                                    <span class="veg-dot"></span>
                                </span>
                                <c:out value="${ci.itemName}"/> × ${ci.quantity}
                            </span>
                            <span>₹<fmt:formatNumber value="${ci.totalPrice}" pattern="#,##0.00"/></span>
                        </div>
                    </c:forEach>
                    <hr class="cart-summary-divider">
                    <div class="cart-summary-row">
                        <span>Item Total</span>
                        <span>₹<fmt:formatNumber value="${subtotal}" pattern="#,##0.00"/></span>
                    </div>
                    <div class="cart-summary-row">
                        <span>Delivery Fee</span>
                        <span>₹<fmt:formatNumber value="${deliveryFee}" pattern="#,##0.00"/></span>
                    </div>
                    <div class="cart-summary-row">
                        <span>Platform Fee</span>
                        <span>₹<fmt:formatNumber value="${platformFee}" pattern="#,##0.00"/></span>
                    </div>
                    <div class="cart-summary-row" id="summaryDiscountRow" style="display: none; color: var(--green);">
                        <span>Coupon Discount</span>
                        <span id="summaryDiscountVal">-₹0.00</span>
                    </div>
                    <div class="cart-summary-row">
                        <span>GST (5%)</span>
                        <span>₹<fmt:formatNumber value="${tax}" pattern="#,##0.00"/></span>
                    </div>
                    <hr class="cart-summary-divider">
                    <div class="cart-summary-row cart-summary-total">
                        <span>Total</span>
                        <span id="summaryTotalVal">₹<fmt:formatNumber value="${grandTotal}" pattern="#,##0.00"/></span>
                    </div>
                </div>
            </div>
        </div>
    </section>

<jsp:include page="/jsp/common/footer.jsp"/>
