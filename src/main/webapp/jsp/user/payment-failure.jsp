<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="Payment Failed"/></jsp:include>

<section class="page-section" style="min-height: calc(100vh - 272px); display: flex; align-items: center; justify-content: center; padding: 40px 20px; background: radial-gradient(circle at 10% 90%, rgba(226, 55, 68, 0.05) 0%, rgba(255, 255, 255, 0) 90%);">
    <div style="width: 100%; max-width: 500px; background: var(--bg-white); border-radius: var(--radius-lg); box-shadow: var(--shadow-lg); border: 1px solid var(--border); padding: 40px; text-align: center;">
        
        <!-- Animated Cross Circle -->
        <div style="width: 80px; height: 80px; border-radius: 50%; background: var(--red-light); display: flex; align-items: center; justify-content: center; margin: 0 auto 24px; box-shadow: 0 4px 10px rgba(226, 55, 68, 0.2); animation: scaleUp 0.5s ease-out;">
            <span style="font-size: 2.5rem; color: var(--red); font-weight: 300;">✕</span>
        </div>

        <h2 style="font-size: 1.75rem; font-weight: 800; color: var(--secondary); margin: 0 0 8px; letter-spacing: -0.5px;">Transaction Failed</h2>
        <p style="color: var(--text-secondary); font-size: 0.95rem; margin: 0 0 24px; line-height: 1.5;">
            Unfortunately, your payment transaction could not be processed. This could be due to a mock simulation decline, incorrect details, or network connectivity issues.
        </p>

        <!-- Informational Tips -->
        <div style="background: #fafafa; border: 1px solid var(--border); border-radius: var(--radius-sm); padding: 16px 20px; text-align: left; margin-bottom: 30px;">
            <p style="font-size: 0.85rem; font-weight: 700; color: var(--text-primary); margin: 0 0 8px;">How to resolve this:</p>
            <ul style="font-size: 0.8rem; color: var(--text-secondary); list-style-type: disc; margin-left: 20px; line-height: 1.6;">
                <li>Make sure your mock card number does not start with <strong>1111</strong> (which triggers simulated failures).</li>
                <li>Ensure the "Simulate Status" selection is set to <strong>SUCCESS</strong>.</li>
                <li>You can also opt for Cash on Delivery (COD) if you want to bypass online transactions.</li>
            </ul>
        </div>

        <!-- Action Buttons -->
        <div style="display: flex; flex-direction: column; gap: 12px;">
            <a href="${pageContext.request.contextPath}/checkout" class="btn btn-primary btn-lg">
                🔄 Return to Checkout & Retry
            </a>
            <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline btn-lg">
                View Shopping Cart
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
