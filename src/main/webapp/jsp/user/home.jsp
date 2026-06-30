<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="Home"/></jsp:include>

    <!-- Hero Section -->
    <section class="hero" id="heroSection">
        <div class="hero-content">
            <h1 class="hero-title">Craving something? <br><span class="text-gradient">CraveRush</span> delivers it fast.</h1>
            <p class="hero-subtitle">Order from 500+ top-rated restaurants in Bengaluru. Fresh food, delivered in minutes.</p>
            <form action="${pageContext.request.contextPath}/restaurants" method="get" class="hero-search">
                <input type="text" name="search" placeholder="Search for biryani, pizza, dosa, burgers..." class="hero-search-input" id="heroSearchInput">
                <button type="submit" class="hero-search-btn" id="heroSearchBtn">Find Food</button>
            </form>
        </div>
        <div class="hero-decoration">
            <div class="hero-circle hero-circle-1"></div>
            <div class="hero-circle hero-circle-2"></div>
            <div class="hero-circle hero-circle-3"></div>
        </div>
    </section>

    <!-- Dynamic Hero Cards -->
    <section class="hero-cards-section" id="heroCardsSection">
        <div class="hero-cards-grid">
            <!-- Card 1: Live Weather -->
            <div class="hero-dynamic-card fade-in" id="weatherCard">
                <div class="hero-card-icon weather" id="weatherIcon">🌤️</div>
                <div class="hero-card-title" id="weatherCity">Your Weather</div>
                <div class="weather-temp" id="weatherTemp">--°C</div>
                <div class="weather-desc" id="weatherDesc">Loading forecast...</div>
                <div class="weather-suggestion" id="weatherSuggestion">Fetching data...</div>
                <div class="weather-delivery-estimate" id="weatherDeliveryEstimate" style="margin-top: 10px; font-size: 0.75rem; font-weight: 600; color: var(--primary); background: var(--primary-light); padding: 6px 10px; border-radius: 6px; display: none;"></div>
            </div>

            <!-- Card 2: Nearby Restaurants -->
            <a href="${pageContext.request.contextPath}/nearby" class="hero-dynamic-card fade-in" id="nearbyCard" style="text-decoration: none; display: flex; flex-direction: column; justify-content: center; text-align: center; padding: 40px 20px; transition: transform 0.3s ease, box-shadow 0.3s ease;">
                <div class="hero-card-icon restaurants" style="margin: 0 auto 15px;">📍</div>
                <div class="hero-card-title" style="font-size: 1.25rem;">Nearby Restaurants</div>
                <div class="hero-card-subtitle" style="font-size: 0.9rem; margin-bottom: 20px;">Find the best food picks around your location instantly.</div>
                <div style="font-size: 0.85rem; font-weight: 700; color: var(--primary); background: var(--primary-light); padding: 8px 16px; border-radius: 8px; display: inline-block; margin: 0 auto;">Explore Nearby →</div>
            </a>

            <!-- Card 3: Best Deals -->
            <a href="${pageContext.request.contextPath}/deals" class="hero-dynamic-card fade-in" id="dealsCard" style="text-decoration: none; display: flex; flex-direction: column; justify-content: center; text-align: center; padding: 40px 20px; transition: transform 0.3s ease, box-shadow 0.3s ease;">
                <div class="hero-card-icon deals" style="margin: 0 auto 15px;">🏷️</div>
                <div class="hero-card-title" style="font-size: 1.25rem;">Today's Deals</div>
                <div class="hero-card-subtitle" style="font-size: 0.9rem; margin-bottom: 20px;">Save big with exclusive coupons and free delivery offers.</div>
                <div style="font-size: 0.85rem; font-weight: 700; color: var(--primary); background: var(--primary-light); padding: 8px 16px; border-radius: 8px; display: inline-block; margin: 0 auto;">View Offers →</div>
            </a>

            <!-- Card 4: Top Rated -->
            <a href="${pageContext.request.contextPath}/top-rated" class="hero-dynamic-card fade-in" id="topRatedCard" style="text-decoration: none; display: flex; flex-direction: column; justify-content: center; text-align: center; padding: 40px 20px; transition: transform 0.3s ease, box-shadow 0.3s ease;">
                <div class="hero-card-icon toprated" style="margin: 0 auto 15px;">⭐</div>
                <div class="hero-card-title" style="font-size: 1.25rem;">Top Rated</div>
                <div class="hero-card-subtitle" style="font-size: 0.9rem; margin-bottom: 20px;">Discover the highest-rated legendary restaurants in the city.</div>
                <div style="font-size: 0.85rem; font-weight: 700; color: var(--primary); background: var(--primary-light); padding: 8px 16px; border-radius: 8px; display: inline-block; margin: 0 auto;">See Top Rated →</div>
            </a>
        </div>
    </section>

    <!-- Popular Restaurants -->
    <section class="section" id="popularRestaurants">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">Popular Restaurants Near You</h2>
                <a href="${pageContext.request.contextPath}/restaurants" class="section-link">See all →</a>
            </div>
            <div class="restaurant-grid">
                <c:forEach var="restaurant" items="${restaurants}">
                    <a href="${pageContext.request.contextPath}/restaurant?id=${restaurant.restaurantId}" class="restaurant-card fade-in" id="restaurant-${restaurant.restaurantId}">
                        <div class="restaurant-card-img">
                            <c:choose>
                                <c:when test="${not empty restaurant.imageUrl}">
                                    <img src="${restaurant.imageUrl.startsWith('http') ? '' : pageContext.request.contextPath}${restaurant.imageUrl}" alt="<c:out value="${restaurant.name}"/>" style="width: 100%; height: 100%; object-fit: cover;" loading="lazy" onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/images/default-restaurant.png';">
                                </c:when>
                                <c:otherwise>
                                    <div class="restaurant-card-img-placeholder">
                                        <span class="restaurant-emoji">🍽️</span>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <c:if test="${restaurant.veg}">
                                <span class="veg-badge">Pure Veg</span>
                            </c:if>
                            <div class="delivery-time-badge">${restaurant.deliveryTime} min</div>
                        </div>
                        <div class="restaurant-card-body">
                            <h3 class="restaurant-card-name"><c:out value="${restaurant.name}"/></h3>
                            <div class="restaurant-card-rating">
                                <span class="rating-star">★</span>
                                <span class="rating-value">${restaurant.rating}</span>
                            </div>
                            <p class="restaurant-card-cuisine"><c:out value="${restaurant.cuisineType}"/></p>
                            <p class="restaurant-card-location">📍 <c:out value="${restaurant.area}"/></p>
                            <p class="restaurant-card-min-order">₹${restaurant.priceForTwo} for two</p>
                        </div>
                    </a>
                </c:forEach>
            </div>
        </div>
    </section>

    <!-- CTA Section -->
    <section class="cta-section" id="ctaSection">
        <div class="container">
            <div class="cta-content">
                <h2>Ready to satisfy your cravings?</h2>
                <p>Browse hundreds of restaurants and get your food delivered lightning fast.</p>
                <a href="${pageContext.request.contextPath}/restaurants" class="btn btn-primary btn-lg">Explore Restaurants</a>
            </div>
        </div>
    </section>

<jsp:include page="/jsp/common/footer.jsp"/>
