<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="Help Center"/></jsp:include>

<section class="page-section" style="min-height: calc(100vh - 272px); padding: 40px 24px;">
    <div class="container">
        <!-- Hero -->
        <div class="help-hero">
            <h1>👋 How can we help you?</h1>
            <p style="color: var(--text-secondary); margin-bottom: 24px;">Search our FAQs or browse by category</p>
            <div class="help-search-bar">
                <span class="help-search-icon">🔍</span>
                <input type="text" id="helpSearchInput" placeholder="Search for answers..." autocomplete="off">
            </div>
        </div>

        <!-- Category Cards -->
        <div class="help-categories-grid">
            <div class="help-category-card" onclick="document.getElementById('ordersSection').scrollIntoView({behavior:'smooth'})">
                <span class="help-category-icon">📦</span>
                <span class="help-category-label">Orders</span>
            </div>
            <div class="help-category-card" onclick="document.getElementById('paymentsSection').scrollIntoView({behavior:'smooth'})">
                <span class="help-category-icon">💳</span>
                <span class="help-category-label">Payments</span>
            </div>
            <div class="help-category-card" onclick="document.getElementById('accountSection').scrollIntoView({behavior:'smooth'})">
                <span class="help-category-icon">👤</span>
                <span class="help-category-label">Account</span>
            </div>
            <div class="help-category-card" onclick="document.getElementById('deliverySection').scrollIntoView({behavior:'smooth'})">
                <span class="help-category-icon">🛵</span>
                <span class="help-category-label">Delivery</span>
            </div>
            <div class="help-category-card" onclick="document.getElementById('restaurantSection').scrollIntoView({behavior:'smooth'})">
                <span class="help-category-icon">🍽️</span>
                <span class="help-category-label">Restaurants</span>
            </div>
            <div class="help-category-card" onclick="document.getElementById('technicalSection').scrollIntoView({behavior:'smooth'})">
                <span class="help-category-icon">🔧</span>
                <span class="help-category-label">Technical</span>
            </div>
        </div>

        <!-- FAQ Sections -->

        <!-- Orders -->
        <div class="faq-section" id="ordersSection" style="margin-bottom: 24px;">
            <h2>📦 Orders</h2>
            <div class="faq-item">
                <div class="faq-question">
                    <span>How do I track my order?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    After placing your order, go to <strong>My Orders</strong> and click on the order you want to track. You'll see real-time status updates including when the restaurant accepts your order, when it's being prepared, and when the rider is on the way. You can also use our AI chatbot to quickly check your latest order status.
                </div>
            </div>
            <div class="faq-item">
                <div class="faq-question">
                    <span>Can I cancel my order?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    You can cancel your order within <strong>60 seconds</strong> of placing it from the Order Details page. Once the restaurant accepts and starts preparing your food, cancellation is no longer possible. For special circumstances, contact our support team at <strong>1800-CRAVE-RUSH</strong>.
                </div>
            </div>
            <div class="faq-item">
                <div class="faq-question">
                    <span>My order is delayed. What should I do?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    During peak hours (12-2 PM and 7-10 PM) or bad weather, deliveries may take slightly longer. You can track real-time updates on your order page. If your order is significantly delayed (more than 15 minutes past ETA), please contact support and we'll investigate immediately.
                </div>
            </div>
            <div class="faq-item">
                <div class="faq-question">
                    <span>I received the wrong order. What do I do?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    We're sorry about that! Please contact our support team within 2 hours of delivery with photos of the items received. We'll either arrange a re-delivery of the correct items or issue a full refund. Email <strong>support@craverush.com</strong> or use the AI chatbot for immediate assistance.
                </div>
            </div>
        </div>

        <!-- Payments -->
        <div class="faq-section" id="paymentsSection" style="margin-bottom: 24px;">
            <h2>💳 Payments & Refunds</h2>
            <div class="faq-item">
                <div class="faq-question">
                    <span>What payment methods do you accept?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    We accept a wide range of payment methods: <strong>UPI</strong> (Google Pay, PhonePe, Paytm, BHIM), <strong>Credit/Debit Cards</strong> (Visa, Mastercard, RuPay, Amex), <strong>Net Banking</strong> (all major banks), <strong>Wallets</strong> (Paytm, Amazon Pay), and <strong>Cash on Delivery (COD)</strong>. All digital payments are secured with 256-bit encryption.
                </div>
            </div>
            <div class="faq-item">
                <div class="faq-question">
                    <span>When will I get my refund?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    Refunds are processed within <strong>3-5 business days</strong> to your original payment method. UPI refunds are usually faster (within 24-48 hours). For COD orders, refunds are credited as CraveRush wallet credits. You can track your refund status from the Order Details page.
                </div>
            </div>
            <div class="faq-item">
                <div class="faq-question">
                    <span>My payment failed but money was deducted. Help!</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    Don't worry! If your payment was deducted but the order wasn't placed, the amount will be automatically refunded within <strong>5-7 business days</strong>. If you don't see the refund after 7 days, contact your bank with the transaction ID or email us at <strong>support@craverush.com</strong>.
                </div>
            </div>
            <div class="faq-item">
                <div class="faq-question">
                    <span>How do I apply a coupon code?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    At checkout, you'll see an "Apply Coupon" field. Enter your promo code and click Apply. The discount will be reflected in your order summary. Check our <a href="${pageContext.request.contextPath}/offers" style="color: var(--primary); font-weight: 600;">Offers page</a> for active coupon codes.
                </div>
            </div>
        </div>

        <!-- Account -->
        <div class="faq-section" id="accountSection" style="margin-bottom: 24px;">
            <h2>👤 Account</h2>
            <div class="faq-item">
                <div class="faq-question">
                    <span>How do I create an account?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    Click the <strong>"Sign Up"</strong> button in the top navigation bar. Fill in your name, email, phone number, and create a password. You'll be able to start ordering immediately after registration!
                </div>
            </div>
            <div class="faq-item">
                <div class="faq-question">
                    <span>I forgot my password. How do I reset it?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    On the login page, click "Forgot Password?" and enter your registered email. You'll receive a password reset link. If you don't see the email, check your spam folder or contact <strong>support@craverush.com</strong>.
                </div>
            </div>
            <div class="faq-item">
                <div class="faq-question">
                    <span>How do I delete my account?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    To delete your account, please send an email to <strong>support@craverush.com</strong> from your registered email address with the subject "Account Deletion Request". We'll process your request within 48 hours. Please note that all order history and saved data will be permanently removed.
                </div>
            </div>
        </div>

        <!-- Delivery -->
        <div class="faq-section" id="deliverySection" style="margin-bottom: 24px;">
            <h2>🛵 Delivery</h2>
            <div class="faq-item">
                <div class="faq-question">
                    <span>What areas do you deliver to?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    We currently deliver across <strong>20+ major areas in Bengaluru</strong> including Koramangala, Indiranagar, HSR Layout, BTM Layout, JP Nagar, Jayanagar, Whitefield, Electronic City, Marathahalli, Bellandur, MG Road, Banashankari, Rajajinagar, Yelahanka, Hebbal, Malleshwaram, Basavanagudi, and more!
                </div>
            </div>
            <div class="faq-item">
                <div class="faq-question">
                    <span>What are the delivery charges?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    <strong>Delivery Fee</strong>: ₹40 (flat rate)<br>
                    <strong>Platform Fee</strong>: ₹5<br>
                    <strong>GST</strong>: 5% of food subtotal<br><br>
                    Use promo codes to offset these charges! Check our <a href="${pageContext.request.contextPath}/offers" style="color: var(--primary); font-weight: 600;">Offers page</a>.
                </div>
            </div>
            <div class="faq-item">
                <div class="faq-question">
                    <span>Do you offer contactless delivery?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    Yes! You can request contactless delivery by adding a note during checkout. Our delivery partner will leave the food at your door and notify you. This is available for all prepaid orders.
                </div>
            </div>
        </div>

        <!-- Restaurants -->
        <div class="faq-section" id="restaurantSection" style="margin-bottom: 24px;">
            <h2>🍽️ Restaurants</h2>
            <div class="faq-item">
                <div class="faq-question">
                    <span>How do I find a specific restaurant?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    Use the search bar in the navigation or on the home page. You can search by restaurant name, cuisine type, or specific dish. You can also filter results by rating, delivery time, price, and dietary preference (veg/non-veg).
                </div>
            </div>
            <div class="faq-item">
                <div class="faq-question">
                    <span>I want to register my restaurant on CraveRush.</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    We'd love to have you! Email us at <strong>partners@craverush.com</strong> with your restaurant name, location, cuisine type, and contact details. Our partnerships team will get back to you within 2-3 business days to onboard your restaurant.
                </div>
            </div>
        </div>

        <!-- Technical -->
        <div class="faq-section" id="technicalSection" style="margin-bottom: 24px;">
            <h2>🔧 Technical Issues</h2>
            <div class="faq-item">
                <div class="faq-question">
                    <span>The website is loading slowly. What should I do?</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    Try these steps: (1) Clear your browser cache and cookies, (2) Hard refresh with Ctrl+F5, (3) Try a different browser (Chrome, Firefox, Edge), (4) Check your internet connection. If the issue persists, email <strong>tech@craverush.com</strong> with your browser and OS details.
                </div>
            </div>
            <div class="faq-item">
                <div class="faq-question">
                    <span>I can't add items to my cart.</span>
                    <span class="faq-arrow">▼</span>
                </div>
                <div class="faq-answer">
                    Make sure you're logged in before adding items. Also note that you can only order from <strong>one restaurant at a time</strong>. If you have items from a different restaurant in your cart, you'll need to clear the cart first. If the issue persists, try refreshing the page.
                </div>
            </div>
        </div>

        <!-- Still Need Help -->
        <div style="text-align: center; padding: 48px 24px; background: linear-gradient(135deg, var(--primary-light), #FFE0B2); border-radius: var(--radius-xl);">
            <h2 style="font-family: var(--font-display); font-size: 1.5rem; font-weight: 800; margin-bottom: 12px;">Still need help?</h2>
            <p style="color: var(--text-secondary); margin-bottom: 24px; font-size: 0.95rem;">Our support team is ready to assist you.</p>
            <div style="display: flex; justify-content: center; gap: 16px; flex-wrap: wrap;">
                <a href="${pageContext.request.contextPath}/contact" class="btn btn-primary btn-lg">
                    📞 Contact Support
                </a>
                <button onclick="toggleChat()" class="btn btn-outline btn-lg" style="background: white;">
                    💬 Chat with AI
                </button>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/jsp/common/footer.jsp"/>
