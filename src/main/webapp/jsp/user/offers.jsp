<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="Offers and Coupons"/></jsp:include>

<section class="page-section" style="min-height: calc(100vh - 272px); padding: 40px 20px;">
    <div class="container">
        <!-- Title & Subtitle -->
        <div style="text-align: center; margin-bottom: 40px;">
            <h1 style="font-size: 2.25rem; font-weight: 800; color: var(--secondary); margin-bottom: 8px; letter-spacing: -0.75px;">
                🏷️ Deals & Promo Codes
            </h1>
            <p style="color: var(--text-secondary); font-size: 1rem; max-width: 600px; margin: 0 auto;">
                Get the best discounts, flat cashbacks, and bank offers on your favorite meals from top restaurants in Bangalore.
            </p>
        </div>

        <!-- Offers Grid -->
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 24px;">
            <!-- Coupon Code 1 -->
            <div style="background: var(--bg-white); border-radius: var(--radius-md); border: 1px solid var(--border); box-shadow: var(--shadow-sm); overflow: hidden; display: flex; flex-direction: column; transition: var(--transition);" class="offer-card">
                <div style="background: linear-gradient(135deg, var(--primary), var(--primary-dark)); padding: 24px; text-align: center; color: var(--text-white);">
                    <span style="font-size: 0.75rem; text-transform: uppercase; font-weight: 700; background: rgba(255,255,255,0.2); padding: 4px 8px; border-radius: 4px; display: inline-block; margin-bottom: 12px; letter-spacing: 0.5px;">Super Saver</span>
                    <h3 style="font-size: 2rem; font-weight: 800; margin: 0;">50% OFF</h3>
                    <p style="font-size: 0.85rem; margin: 4px 0 0; opacity: 0.9;">Up to ₹100 on your next order</p>
                </div>
                <div style="padding: 24px; flex-grow: 1; display: flex; flex-direction: column; justify-content: space-between; text-align: center;">
                    <p style="font-size: 0.85rem; color: var(--text-secondary); line-height: 1.5; margin: 0 0 20px;">
                        Valid on all partner restaurants. Order now to avail of this premium discount.
                    </p>
                    <div>
                        <div style="background: #fafafa; border: 1px dashed var(--primary); border-radius: var(--radius-sm); padding: 12px; margin-bottom: 12px; font-weight: 700; color: var(--primary); font-family: monospace; font-size: 1.15rem; letter-spacing: 1px; text-transform: uppercase;" id="codeCrave50">
                            CRAVE50
                        </div>
                        <button onclick="copyPromo('CRAVE50')" class="btn btn-outline" style="width: 100%; border-radius: var(--radius-sm);">Copy Code</button>
                    </div>
                </div>
            </div>

            <!-- Coupon Code 2 -->
            <div style="background: var(--bg-white); border-radius: var(--radius-md); border: 1px solid var(--border); box-shadow: var(--shadow-sm); overflow: hidden; display: flex; flex-direction: column; transition: var(--transition);" class="offer-card">
                <div style="background: linear-gradient(135deg, var(--green), #4d8f37); padding: 24px; text-align: center; color: var(--text-white);">
                    <span style="font-size: 0.75rem; text-transform: uppercase; font-weight: 700; background: rgba(255,255,255,0.2); padding: 4px 8px; border-radius: 4px; display: inline-block; margin-bottom: 12px; letter-spacing: 0.5px;">Flat Discount</span>
                    <h3 style="font-size: 2rem; font-weight: 800; margin: 0;">₹50 OFF</h3>
                    <p style="font-size: 0.85rem; margin: 4px 0 0; opacity: 0.9;">Flat discount on orders above ₹199</p>
                </div>
                <div style="padding: 24px; flex-grow: 1; display: flex; flex-direction: column; justify-content: space-between; text-align: center;">
                    <p style="font-size: 0.85rem; color: var(--text-secondary); line-height: 1.5; margin: 0 0 20px;">
                        No upper limit. Flat discount directly applied to your order total.
                    </p>
                    <div>
                        <div style="background: #fafafa; border: 1px dashed var(--green); border-radius: var(--radius-sm); padding: 12px; margin-bottom: 12px; font-weight: 700; color: var(--green); font-family: monospace; font-size: 1.15rem; letter-spacing: 1px; text-transform: uppercase;" id="codeFree50">
                            FREE50
                        </div>
                        <button onclick="copyPromo('FREE50')" class="btn btn-outline" style="width: 100%; border-radius: var(--radius-sm);">Copy Code</button>
                    </div>
                </div>
            </div>

            <!-- Coupon Code 3 -->
            <div style="background: var(--bg-white); border-radius: var(--radius-md); border: 1px solid var(--border); box-shadow: var(--shadow-sm); overflow: hidden; display: flex; flex-direction: column; transition: var(--transition);" class="offer-card">
                <div style="background: linear-gradient(135deg, var(--secondary), var(--secondary-light)); padding: 24px; text-align: center; color: var(--text-white);">
                    <span style="font-size: 0.75rem; text-transform: uppercase; font-weight: 700; background: rgba(255,255,255,0.2); padding: 4px 8px; border-radius: 4px; display: inline-block; margin-bottom: 12px; letter-spacing: 0.5px;">Bank Offer</span>
                    <h3 style="font-size: 2rem; font-weight: 800; margin: 0;">10% OFF</h3>
                    <p style="font-size: 0.85rem; margin: 4px 0 0; opacity: 0.9;">On HDFC Credit Cards up to ₹150</p>
                </div>
                <div style="padding: 24px; flex-grow: 1; display: flex; flex-direction: column; justify-content: space-between; text-align: center;">
                    <p style="font-size: 0.85rem; color: var(--text-secondary); line-height: 1.5; margin: 0 0 20px;">
                        Valid on minimum transaction values of ₹499. Apply at payment check out.
                    </p>
                    <div>
                        <div style="background: #fafafa; border: 1px dashed var(--secondary); border-radius: var(--radius-sm); padding: 12px; margin-bottom: 12px; font-weight: 700; color: var(--secondary); font-family: monospace; font-size: 1.15rem; letter-spacing: 1px; text-transform: uppercase;">
                            HDFC10
                        </div>
                        <button onclick="copyPromo('HDFC10')" class="btn btn-outline" style="width: 100%; border-radius: var(--radius-sm);">Copy Code</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Simple feedback toast -->
<div id="toast" style="position: fixed; bottom: 30px; left: 50%; transform: translateX(-50%) translateY(100px); background: var(--secondary); color: var(--text-white); padding: 12px 24px; border-radius: var(--radius-full); box-shadow: var(--shadow-md); font-size: 0.9rem; font-weight: 600; z-index: 2000; transition: transform 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275); pointer-events: none; opacity: 0;">
    Copied to Clipboard!
</div>

<script>
    function copyPromo(code) {
        navigator.clipboard.writeText(code).then(() => {
            const toast = document.getElementById("toast");
            toast.innerText = "Promo code '" + code + "' copied!";
            toast.style.transform = "translateX(-50%) translateY(0)";
            toast.style.opacity = "1";
            setTimeout(() => {
                toast.style.transform = "translateX(-50%) translateY(100px)";
                toast.style.opacity = "0";
            }, 2500);
        });
    }
</script>

<style>
    .offer-card:hover {
        transform: translateY(-8px);
        box-shadow: var(--shadow-lg);
    }
</style>

<jsp:include page="/jsp/common/footer.jsp"/>
