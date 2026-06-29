<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="Today's Deals"/></jsp:include>

<section class="section" style="padding-top: 120px; min-height: 80vh;">
    <div class="container">
        <div class="page-header" style="text-align: center; margin-bottom: 40px;">
            <h1 style="font-size: 2.5rem; color: var(--text-primary); margin-bottom: 10px;">Today's Deals</h1>
            <p style="color: var(--text-secondary);">Save big on your favorite meals with exclusive offers and coupons.</p>
        </div>

        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 24px; margin-bottom: 50px;">
            <!-- Coupon 1 -->
            <div style="background: linear-gradient(135deg, #FC8019, #E65C00); color: white; border-radius: 16px; padding: 24px; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 10px 20px rgba(252,128,25,0.2);">
                <div>
                    <div style="font-size: 0.8rem; text-transform: uppercase; letter-spacing: 1px; font-weight: 700; margin-bottom: 4px; opacity: 0.9;">Welcome Offer</div>
                    <div style="font-size: 1.8rem; font-weight: 800; margin-bottom: 8px;">50% OFF</div>
                    <div style="font-size: 0.9rem; opacity: 0.9; margin-bottom: 16px;">Up to ₹100 off on your first order.</div>
                    <div style="background: rgba(0,0,0,0.2); padding: 8px 16px; border-radius: 8px; font-family: monospace; font-size: 1.1rem; font-weight: bold; letter-spacing: 2px; display: inline-block;">CRAVE50</div>
                </div>
                <div style="font-size: 4rem; opacity: 0.2;">🎉</div>
            </div>

            <!-- Coupon 2 -->
            <div style="background: linear-gradient(135deg, #4F46E5, #3730A3); color: white; border-radius: 16px; padding: 24px; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 10px 20px rgba(79,70,229,0.2);">
                <div>
                    <div style="font-size: 0.8rem; text-transform: uppercase; letter-spacing: 1px; font-weight: 700; margin-bottom: 4px; opacity: 0.9;">Monsoon Special</div>
                    <div style="font-size: 1.8rem; font-weight: 800; margin-bottom: 8px;">FREE DELIVERY</div>
                    <div style="font-size: 0.9rem; opacity: 0.9; margin-bottom: 16px;">On all orders above ₹299.</div>
                    <div style="background: rgba(0,0,0,0.2); padding: 8px 16px; border-radius: 8px; font-family: monospace; font-size: 1.1rem; font-weight: bold; letter-spacing: 2px; display: inline-block;">RAINYDAY</div>
                </div>
                <div style="font-size: 4rem; opacity: 0.2;">🌧️</div>
            </div>

            <!-- Coupon 3 -->
            <div style="background: linear-gradient(135deg, #10B981, #047857); color: white; border-radius: 16px; padding: 24px; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 10px 20px rgba(16,185,129,0.2);">
                <div>
                    <div style="font-size: 0.8rem; text-transform: uppercase; letter-spacing: 1px; font-weight: 700; margin-bottom: 4px; opacity: 0.9;">Lunch Combo</div>
                    <div style="font-size: 1.8rem; font-weight: 800; margin-bottom: 8px;">FLAT ₹75 OFF</div>
                    <div style="font-size: 0.9rem; opacity: 0.9; margin-bottom: 16px;">Valid from 12 PM to 3 PM.</div>
                    <div style="background: rgba(0,0,0,0.2); padding: 8px 16px; border-radius: 8px; font-family: monospace; font-size: 1.1rem; font-weight: bold; letter-spacing: 2px; display: inline-block;">LUNCH75</div>
                </div>
                <div style="font-size: 4rem; opacity: 0.2;">🍱</div>
            </div>
        </div>

        <h2 style="font-size: 1.5rem; margin-bottom: 24px;">Restaurants with Offers</h2>
        <div class="restaurant-grid">
            <!-- Randomly show some restaurants as having offers -->
            <c:forEach var="restaurant" items="${restaurants}" varStatus="loop">
                <c:if test="${loop.index % 3 == 0 || loop.index % 5 == 0}">
                    <a href="${pageContext.request.contextPath}/restaurant?id=${restaurant.restaurantId}" class="restaurant-card fade-in">
                        <div class="restaurant-card-img">
                            <c:choose>
                                <c:when test="${not empty restaurant.imageUrl}">
                                    <img src="${restaurant.imageUrl}" alt="<c:out value="${restaurant.name}"/>" style="width: 100%; height: 100%; object-fit: cover;" loading="lazy" onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/images/default-restaurant.png';">
                                </c:when>
                                <c:otherwise>
                                    <div class="restaurant-card-img-placeholder">🍽️</div>
                                </c:otherwise>
                            </c:choose>
                            <div style="position:absolute; top:12px; right:12px; background:var(--primary); color:white; padding:4px 8px; border-radius:4px; font-size:0.75rem; font-weight:bold;">Special Offer</div>
                        </div>
                        <div class="restaurant-card-body">
                            <h3 class="restaurant-card-name"><c:out value="${restaurant.name}"/></h3>
                            <div class="restaurant-card-rating">
                                <span class="rating-star">★</span>
                                <span class="rating-value">${restaurant.rating}</span>
                            </div>
                            <p class="restaurant-card-cuisine"><c:out value="${restaurant.cuisineType}"/></p>
                            <div style="margin-top: 10px; padding-top: 10px; border-top: 1px dashed rgba(0,0,0,0.1); font-size: 0.8rem; font-weight: 600; color: var(--primary); display: flex; align-items: center; gap: 6px;">
                                🏷️ Use code <c:out value="${loop.index % 3 == 0 ? 'CRAVE50' : 'RAINYDAY'}"/>
                            </div>
                        </div>
                    </a>
                </c:if>
            </c:forEach>
        </div>
    </div>
</section>

<jsp:include page="/jsp/common/footer.jsp"/>
