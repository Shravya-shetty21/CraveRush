<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="Payment Success"/></jsp:include>

<section class="page-section" style="min-height: calc(100vh - 272px); display: flex; align-items: center; justify-content: center; padding: 40px 20px; background: radial-gradient(circle at 90% 10%, rgba(96, 178, 70, 0.05) 0%, rgba(255, 255, 255, 0) 90%);">
    <div style="width: 100%; max-width: 500px; background: var(--bg-white); border-radius: var(--radius-lg); box-shadow: var(--shadow-lg); border: 1px solid var(--border); padding: 40px; text-align: center;">
        
        <!-- Animated Check Circle -->
        <div style="width: 80px; height: 80px; border-radius: 50%; background: var(--green-light); display: flex; align-items: center; justify-content: center; margin: 0 auto 24px; box-shadow: 0 4px 10px rgba(96, 178, 70, 0.2); animation: scaleUp 0.5s ease-out;">
            <span style="font-size: 2.5rem; color: var(--green);">✓</span>
        </div>

        <h2 style="font-size: 1.75rem; font-weight: 800; color: var(--secondary); margin: 0 0 8px; letter-spacing: -0.5px;">Order Placed Successfully!</h2>
        <p style="color: var(--text-secondary); font-size: 0.95rem; margin: 0 0 24px; line-height: 1.5;">
            Thank you for choosing CraveRush. Your payment is complete, and the kitchen has started preparing your delicious food.
        </p>

        <!-- Order Information Card -->
        <div style="background: #fafafa; border: 1px solid var(--border); border-radius: var(--radius-sm); padding: 16px 20px; text-align: left; margin-bottom: 30px;">
            <div style="display: flex; justify-content: space-between; margin-bottom: 8px;">
                <span style="font-size: 0.85rem; color: var(--text-secondary); font-weight: 600;">Order ID:</span>
                <span style="font-size: 0.85rem; color: var(--text-primary); font-weight: 700; font-family: monospace;">#CR-${orderId}</span>
            </div>
            <div style="display: flex; justify-content: space-between;">
                <span style="font-size: 0.85rem; color: var(--text-secondary); font-weight: 600;">Estimated Delivery:</span>
                <span style="font-size: 0.85rem; color: var(--green); font-weight: 700;">30 - 45 mins</span>
            </div>
        </div>

        <!-- Action Buttons -->
        <div style="display: flex; flex-direction: column; gap: 12px;">
            <a href="${pageContext.request.contextPath}/order/track/${orderId}" class="btn btn-primary btn-lg" style="display: flex; align-items: center; justify-content: center; gap: 8px;">
                <span>📍 Live Track Order</span>
            </a>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline btn-lg">
                Go to Home
            </a>
        </div>
    </div>
</section>

<style>
    @keyframes scaleUp {
        0% { transform: scale(0.7); opacity: 0; }
        100% { transform: scale(1); opacity: 1; }
    }
</style>

<jsp:include page="/jsp/common/footer.jsp"/>
