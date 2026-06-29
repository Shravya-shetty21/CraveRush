<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="Top Rated Restaurants"/></jsp:include>

<section class="section" style="padding-top: 120px; min-height: 80vh;">
    <div class="container">
        <div class="page-header" style="text-align: center; margin-bottom: 40px;">
            <h1 style="font-size: 2.5rem; color: var(--text-primary); margin-bottom: 10px;">Top Rated Legends</h1>
            <p style="color: var(--text-secondary);">The highest rated restaurants in Bengaluru, loved by thousands.</p>
        </div>

        <div class="restaurant-grid">
            <c:forEach var="restaurant" items="${restaurants}" varStatus="loop">
                <c:if test="${restaurant.rating >= 4.4}">
                    <a href="${pageContext.request.contextPath}/restaurant?id=${restaurant.restaurantId}" class="restaurant-card fade-in" style="border: 2px solid transparent; transition: all 0.3s ease;">
                        <div class="restaurant-card-img" style="height: 220px;">
                            <c:choose>
                                <c:when test="${not empty restaurant.imageUrl}">
                                    <img src="${restaurant.imageUrl}" alt="<c:out value="${restaurant.name}"/>" style="width: 100%; height: 100%; object-fit: cover;" loading="lazy" onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/images/default-restaurant.png';">
                                </c:when>
                                <c:otherwise>
                                    <div class="restaurant-card-img-placeholder">🍽️</div>
                                </c:otherwise>
                            </c:choose>
                            <c:if test="${loop.index < 3}">
                                <div style="position:absolute; top:12px; left:12px; background:linear-gradient(135deg, #F59E0B, #D97706); color:white; padding:6px 12px; border-radius:8px; font-size:0.8rem; font-weight:bold; box-shadow:0 4px 10px rgba(245,158,11,0.3); display:flex; align-items:center; gap:6px;">
                                    🏆 Rank #${loop.index + 1}
                                </div>
                            </c:if>
                            <div class="delivery-time-badge">${restaurant.deliveryTime} min</div>
                        </div>
                        <div class="restaurant-card-body">
                            <div style="display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:8px;">
                                <h3 class="restaurant-card-name" style="font-size: 1.25rem; margin:0;"><c:out value="${restaurant.name}"/></h3>
                                <div style="background:#059669; color:white; padding:4px 8px; border-radius:6px; font-weight:700; font-size:0.9rem; display:flex; align-items:center; gap:4px;">
                                    <c:out value="${restaurant.rating}"/> ⭐
                                </div>
                            </div>
                            <p class="restaurant-card-cuisine" style="font-size: 0.95rem;"><c:out value="${restaurant.cuisineType}"/></p>
                            <div style="margin-top: 12px; display:flex; justify-content:space-between; align-items:center; color: var(--text-secondary); font-size:0.85rem;">
                                <span>📍 <c:out value="${restaurant.area}"/></span>
                                <span>₹<c:out value="${restaurant.priceForTwo}"/> for two</span>
                            </div>
                        </div>
                    </a>
                </c:if>
            </c:forEach>
        </div>
    </div>
</section>

<jsp:include page="/jsp/common/footer.jsp"/>
