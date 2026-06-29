<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="Contact Us"/></jsp:include>

<section class="page-section" style="min-height: calc(100vh - 272px); padding: 40px 24px;">
    <div class="container">
        <!-- Page Title -->
        <div style="text-align: center; margin-bottom: 48px;">
            <h1 style="font-family: var(--font-display); font-size: 2.5rem; font-weight: 900; color: var(--text-primary); margin-bottom: 8px; letter-spacing: -0.5px;">
                Get in Touch
            </h1>
            <p style="color: var(--text-muted); font-size: 1.05rem; max-width: 540px; margin: 0 auto;">
                Have a question, feedback, or need help? We'd love to hear from you.
            </p>
        </div>

        <div class="contact-grid">
            <!-- Contact Form -->
            <div class="contact-card">
                <h2 class="contact-card-title">Send us a message</h2>
                <form action="#" method="post" style="display: flex; flex-direction: column; gap: 18px;">
                    <div class="form-group">
                        <label class="form-label">Full Name</label>
                        <input type="text" class="form-input" placeholder="Enter your name" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Email Address</label>
                        <input type="email" class="form-input" placeholder="your@email.com" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Subject</label>
                        <select class="form-input form-select">
                            <option value="">Select a topic...</option>
                            <option>Order Issue</option>
                            <option>Payment & Refunds</option>
                            <option>Account Support</option>
                            <option>Restaurant Partnership</option>
                            <option>Delivery Partner Inquiry</option>
                            <option>Feedback & Suggestions</option>
                            <option>Other</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Message</label>
                        <textarea class="form-input form-textarea" rows="5" placeholder="Tell us what's on your mind..." required></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary btn-lg">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="22" y1="2" x2="11" y2="13"/><polygon points="22 2 15 22 11 13 2 9 22 2"/></svg>
                        Send Message
                    </button>
                </form>
            </div>

            <!-- Contact Info -->
            <div>
                <div class="contact-card" style="margin-bottom: 24px;">
                    <h2 class="contact-card-title">Contact Information</h2>
                    <div class="contact-info-item">
                        <div class="contact-info-icon">📞</div>
                        <div>
                            <div class="contact-info-label">Phone</div>
                            <div class="contact-info-value">1800-CRAVE-RUSH (Toll Free)</div>
                        </div>
                    </div>
                    <div class="contact-info-item">
                        <div class="contact-info-icon">📧</div>
                        <div>
                            <div class="contact-info-label">Email</div>
                            <div class="contact-info-value">support@craverush.com</div>
                        </div>
                    </div>
                    <div class="contact-info-item">
                        <div class="contact-info-icon">⏰</div>
                        <div>
                            <div class="contact-info-label">Working Hours</div>
                            <div class="contact-info-value">Mon - Sun, 8:00 AM — 11:00 PM</div>
                        </div>
                    </div>
                    <div class="contact-info-item">
                        <div class="contact-info-icon">📍</div>
                        <div>
                            <div class="contact-info-label">Office Address</div>
                            <div class="contact-info-value">CraveRush Technologies Pvt. Ltd.<br>4th Floor, Sigma Tech Park,<br>Koramangala, Bengaluru — 560034</div>
                        </div>
                    </div>
                    <div class="contact-info-item" style="border-bottom: none;">
                        <div class="contact-info-icon">💬</div>
                        <div>
                            <div class="contact-info-label">Live Chat</div>
                            <div class="contact-info-value">
                                <a href="javascript:void(0)" onclick="toggleChat()" style="color: var(--primary); font-weight: 700;">
                                    Chat with AI Assistant →
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Map -->
                <div class="map-embed">
                    <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3888.5975745774!2d77.6142!3d12.9346!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3bae15c87d7d4bb5%3A0x1234567890abcdef!2sKoramangala%2C%20Bengaluru%2C%20Karnataka!5e0!3m2!1sen!2sin!4v1700000000000!5m2!1sen!2sin" allowfullscreen loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/jsp/common/footer.jsp"/>
