<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="Restaurants"/></jsp:include>

    <section class="page-section" id="restaurantListSection">
        <div class="container">
            <div class="page-header">
                <h1 class="page-title">
                    <c:choose>
                        <c:when test="${searchQuery != null}">Results for "<c:out value="${searchQuery}"/>"</c:when>
                        <c:when test="${cuisineFilter != null}"><c:out value="${cuisineFilter}"/> Restaurants</c:when>
                        <c:otherwise>All Restaurants</c:otherwise>
                    </c:choose>
                </h1>
                <p class="page-subtitle">${restaurants.size()} restaurant(s) found</p>
            </div>

            <!-- Cuisine Quick Filters -->
            <div class="cuisine-filters" id="cuisineFilters">
                <a href="${pageContext.request.contextPath}/restaurants" class="cuisine-pill ${cuisineFilter == null && searchQuery == null ? 'active' : ''}">All</a>
                <a href="${pageContext.request.contextPath}/restaurants?cuisine=Biryani" class="cuisine-pill ${cuisineFilter == 'Biryani' ? 'active' : ''}">🍚 Biryani</a>
                <a href="${pageContext.request.contextPath}/restaurants?cuisine=Pizza" class="cuisine-pill ${cuisineFilter == 'Pizza' ? 'active' : ''}">🍕 Pizza</a>
                <a href="${pageContext.request.contextPath}/restaurants?cuisine=Chinese" class="cuisine-pill ${cuisineFilter == 'Chinese' ? 'active' : ''}">🥡 Chinese</a>
                <a href="${pageContext.request.contextPath}/restaurants?cuisine=South Indian" class="cuisine-pill ${cuisineFilter == 'South Indian' ? 'active' : ''}">🥘 South Indian</a>
                <a href="${pageContext.request.contextPath}/restaurants?cuisine=Burgers" class="cuisine-pill ${cuisineFilter == 'Burgers' ? 'active' : ''}">🍔 Burgers</a>
                <a href="${pageContext.request.contextPath}/restaurants?cuisine=North Indian" class="cuisine-pill ${cuisineFilter == 'North Indian' ? 'active' : ''}">🫓 North Indian</a>
                <a href="${pageContext.request.contextPath}/restaurants?cuisine=Healthy" class="cuisine-pill ${cuisineFilter == 'Healthy' ? 'active' : ''}">🥗 Healthy</a>
            </div>

            <c:choose>
                <c:when test="${empty restaurants}">
                    <div class="empty-state" id="noRestaurants">
                        <span class="empty-icon">🍽️</span>
                        <h3>No restaurants found</h3>
                        <p>Try a different search or browse all restaurants.</p>
                        <a href="${pageContext.request.contextPath}/restaurants" class="btn btn-primary">Browse All</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="restaurant-grid">
                        <c:forEach var="restaurant" items="${restaurants}">
                            <a href="${pageContext.request.contextPath}/restaurant?id=${restaurant.restaurantId}" class="restaurant-card" id="restaurant-${restaurant.restaurantId}">
                                <div class="restaurant-card-img">
                                    <c:choose>
                                        <c:when test="${not empty restaurant.imageUrl}">
                                            <img src="${restaurant.imageUrl}" alt="<c:out value="${restaurant.name}"/>" style="width: 100%; height: 100%; object-fit: cover;" onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/images/default-restaurant.png';">
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
                                    <p class="restaurant-card-location">📍 <c:out value="${restaurant.address}"/>, <c:out value="${restaurant.city}"/></p>
                                    <c:if test="${restaurant.minOrder.intValue() > 0}">
                                        <p class="restaurant-card-min-order">Min. order ₹<c:out value="${restaurant.minOrder}"/></p>
                                    </c:if>
                                </div>
                            </a>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

<jsp:include page="/jsp/common/footer.jsp"/>
