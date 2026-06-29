<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="Secure Payment"/></jsp:include>

<section class="page-section" style="min-height: calc(100vh - 272px); display: flex; align-items: center; justify-content: center; padding: 40px 20px; background: radial-gradient(circle at 10% 20%, rgba(252, 128, 25, 0.05) 0%, rgba(255, 255, 255, 0) 90%);">
    <div style="width: 100%; max-width: 600px; background: var(--bg-white); border-radius: var(--radius-lg); box-shadow: var(--shadow-lg); border: 1px solid var(--border); overflow: hidden;">
        <!-- Header -->
        <div style="background: linear-gradient(135deg, var(--secondary), var(--secondary-light)); color: var(--text-white); padding: 30px; text-align: center; position: relative;">
            <div style="font-size: 2.5rem; margin-bottom: 8px;">🔒</div>
            <h2 style="margin: 0; font-size: 1.5rem; font-weight: 700; letter-spacing: -0.5px;">Secure Payment Gateway</h2>
            <p style="margin: 5px 0 0; font-size: 0.85rem; opacity: 0.8;">CraveRush Pay · 128-bit Encryption</p>
        </div>

        <!-- Details -->
        <div style="padding: 24px 30px; background: var(--primary-light); border-bottom: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center;">
            <div>
                <span style="font-size: 0.8rem; color: var(--text-secondary); text-transform: uppercase; font-weight: 700; letter-spacing: 0.5px;">Amount to Pay</span>
                <div style="font-size: 1.75rem; font-weight: 800; color: var(--primary);">₹<fmt:formatNumber value="${grandTotal}" pattern="#,##0.00"/></div>
            </div>
            <div style="text-align: right;">
                <span style="font-size: 0.8rem; color: var(--text-secondary); text-transform: uppercase; font-weight: 700; letter-spacing: 0.5px;">Merchant</span>
                <div style="font-size: 1rem; font-weight: 700; color: var(--secondary);">CraveRush India</div>
            </div>
        </div>

        <!-- Form -->
        <form action="${pageContext.request.contextPath}/payment/process" method="post" style="padding: 30px;" id="paymentGatewayForm">
            <!-- Payment Methods Select -->
            <div style="margin-bottom: 24px;">
                <label style="display: block; font-size: 0.85rem; font-weight: 700; color: var(--text-primary); margin-bottom: 10px;">Select Payment Mode</label>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                    <label style="border: 2px solid var(--primary); border-radius: var(--radius-sm); padding: 12px; display: flex; align-items: center; gap: 8px; cursor: pointer; transition: var(--transition); background: var(--bg-white);" id="labelUPI">
                        <input type="radio" name="paymentMethod" value="UPI" checked onchange="togglePaymentInputs('UPI')" style="accent-color: var(--primary);">
                        <span style="font-size: 0.9rem; font-weight: 600;">📱 UPI (GPay, PhonePe)</span>
                    </label>
                    <label style="border: 2px solid var(--border); border-radius: var(--radius-sm); padding: 12px; display: flex; align-items: center; gap: 8px; cursor: pointer; transition: var(--transition); background: var(--bg-white);" id="labelCARD">
                        <input type="radio" name="paymentMethod" value="CARD" onchange="togglePaymentInputs('CARD')" style="accent-color: var(--primary);">
                        <span style="font-size: 0.9rem; font-weight: 600;">💳 Card (Debit/Credit)</span>
                    </label>
                </div>
            </div>

            <!-- UPI Details Form -->
            <div id="upiFormSection" style="margin-bottom: 24px;">
                <div class="form-group" style="margin-bottom: 0;">
                    <label class="form-label" for="upiId" style="font-weight: 700;">Enter UPI ID</label>
                    <input type="text" name="upiId" id="upiId" class="form-input" placeholder="e.g. username@okhdfcbank" required style="font-family: monospace; letter-spacing: 0.5px;">
                    <p style="font-size: 0.75rem; color: var(--text-secondary); margin-top: 6px;">A payment request will be sent to your UPI app.</p>
                </div>
            </div>

            <!-- Card Details Form -->
            <div id="cardFormSection" style="display: none; margin-bottom: 24px;">
                <div class="form-group" style="margin-bottom: 16px;">
                    <label class="form-label" for="cardNumber" style="font-weight: 700;">Card Number</label>
                    <input type="text" name="cardNumber" id="cardNumber" class="form-input" placeholder="1234 5678 9012 3456" maxlength="19" style="font-family: monospace; letter-spacing: 1.5px;">
                </div>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" for="cardExpiry" style="font-weight: 700;">Expiry Date</label>
                        <input type="text" id="cardExpiry" class="form-input" placeholder="MM/YY" maxlength="5" style="text-align: center; font-family: monospace;">
                    </div>
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" for="cardCVV" style="font-weight: 700;">CVV</label>
                        <input type="password" id="cardCVV" class="form-input" placeholder="•••" maxlength="3" style="text-align: center; font-family: monospace; letter-spacing: 2px;">
                    </div>
                </div>
            </div>

            <!-- Simulation Status Selector -->
            <div style="background: #fafafa; border: 1px dashed var(--border); padding: 16px; border-radius: var(--radius-sm); margin-bottom: 30px;">
                <label style="display: block; font-size: 0.8rem; font-weight: 700; color: var(--text-secondary); text-transform: uppercase; margin-bottom: 8px; letter-spacing: 0.5px;">⚙️ Payment Simulation Control</label>
                <div class="form-group" style="margin-bottom: 0;">
                    <select name="simulateStatus" class="form-input" style="background: var(--bg-white); font-weight: 600; cursor: pointer;">
                        <option value="success">Simulate Transaction SUCCESS</option>
                        <option value="fail">Simulate Transaction FAILURE</option>
                    </select>
                </div>
                <p style="font-size: 0.75rem; color: var(--text-muted); margin-top: 6px;">Choose failure to test payment error workflows and refund simulations.</p>
            </div>

            <!-- Submit Buttons -->
            <button type="submit" class="btn btn-primary btn-lg btn-block" style="display: flex; align-items: center; justify-content: center; gap: 8px;">
                <span>Pay ₹<fmt:formatNumber value="${grandTotal}" pattern="#,##0.00"/> Securely</span>
            </button>
            
            <a href="${pageContext.request.contextPath}/checkout" style="display: block; text-align: center; margin-top: 16px; font-size: 0.85rem; color: var(--text-secondary); font-weight: 600; text-decoration: underline;">
                Cancel and Go Back
            </a>
        </form>
    </div>
</section>

<script>
    function togglePaymentInputs(type) {
        const upiSec = document.getElementById("upiFormSection");
        const cardSec = document.getElementById("cardFormSection");
        const upiInput = document.getElementById("upiId");
        const cardInput = document.getElementById("cardNumber");
        
        const labelUpi = document.getElementById("labelUPI");
        const labelCard = document.getElementById("labelCARD");

        if (type === 'UPI') {
            upiSec.style.display = "block";
            cardSec.style.display = "none";
            upiInput.setAttribute("required", "required");
            cardInput.removeAttribute("required");
            
            labelUpi.style.borderColor = "var(--primary)";
            labelCard.style.borderColor = "var(--border)";
        } else {
            upiSec.style.display = "none";
            cardSec.style.display = "block";
            cardInput.setAttribute("required", "required");
            upiInput.removeAttribute("required");
            
            labelUpi.style.borderColor = "var(--border)";
            labelCard.style.borderColor = "var(--primary)";
        }
    }

    // Auto-format expiration date
    const expiry = document.getElementById('cardExpiry');
    if (expiry) {
        expiry.addEventListener('input', function(e) {
            let val = e.target.value.replace(/\D/g, '');
            if (val.length >= 2) {
                e.target.value = val.slice(0, 2) + '/' + val.slice(2, 4);
            } else {
                e.target.value = val;
            }
        });
    }

    // Auto-format card number
    const cardNum = document.getElementById('cardNumber');
    if (cardNum) {
        cardNum.addEventListener('input', function(e) {
            let val = e.target.value.replace(/\D/g, '');
            let formatted = [];
            for (let i = 0; i < val.length; i += 4) {
                formatted.push(val.slice(i, i + 4));
            }
            e.target.value = formatted.join(' ');
        });
    }
</script>

<jsp:include page="/jsp/common/footer.jsp"/>
