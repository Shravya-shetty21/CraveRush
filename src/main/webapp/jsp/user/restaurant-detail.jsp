<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="${restaurant.name}"/></jsp:include>

    <section class="restaurant-detail-section" id="restaurantDetailSection">
        <div class="container">
            <!-- Restaurant Header -->
            <div class="rd-header" id="restaurantHeader">
                <div class="rd-header-info">
                    <h1 class="rd-name"><c:out value="${restaurant.name}"/></h1>
                    <p class="rd-cuisine"><c:out value="${restaurant.cuisineType}"/></p>
                    <p class="rd-address">📍 <c:out value="${restaurant.address}"/>, <c:out value="${restaurant.city}"/></p>
                    <div class="rd-meta">
                        <span class="rd-rating"><span class="rating-star">★</span> ${restaurant.rating}</span>
                        <span class="rd-dot">•</span>
                        <span class="rd-delivery-time">🕐 ${restaurant.deliveryTime} min</span>
                        <span class="rd-dot">•</span>
                        <span class="rd-min-order">Min. ₹${restaurant.minOrder}</span>
                        <c:if test="${restaurant.veg}">
                            <span class="rd-dot">•</span>
                            <span class="rd-veg-tag">🟢 Pure Veg</span>
                        </c:if>
                    </div>
                    <div style="margin-top: 14px; display: flex; align-items: center; gap: 10px;">
                        <button onclick="toggleFavorite(${restaurant.restaurantId})" id="favoriteBtn" 
                                style="background: rgba(255, 255, 255, 0.95); border: 1px solid var(--border); border-radius: var(--radius-full); padding: 8px 18px; cursor: pointer; display: flex; align-items: center; gap: 6px; font-weight: 700; font-size: 0.85rem; color: ${isFavorite ? 'var(--red)' : 'var(--text-secondary)'}; transition: var(--transition); box-shadow: var(--shadow-sm); outline: none;">
                            <span id="favoriteHeart" style="font-size: 1rem; transition: var(--transition);">${isFavorite ? '❤️' : '🤍'}</span> 
                            <span id="favoriteText">${isFavorite ? 'Favorited' : 'Favorite'}</span>
                        </button>
                    </div>
                </div>
            </div>

            <!-- Category Nav -->
            <c:if test="${not empty categories}">
                <div class="menu-category-nav" id="categoryNav">
                    <c:forEach var="cat" items="${categories}">
                        <a href="#cat-${cat.replaceAll(' ', '-')}" class="category-chip"><c:out value="${cat}"/></a>
                    </c:forEach>
                </div>
            </c:if>

            <!-- Menu Items -->
            <div class="menu-section" id="menuSection">
                <h2 class="section-title">Menu</h2>

                <c:set var="currentCategory" value=""/>
                <c:forEach var="item" items="${menuItems}">
                    <c:if test="${item.categoryName != currentCategory}">
                        <c:if test="${not empty currentCategory}">
                            </div>
                        </c:if>
                        <div class="menu-category" id="cat-${item.categoryName.replaceAll(' ', '-')}">
                            <h3 class="menu-category-title"><c:out value="${item.categoryName}"/></h3>
                        <c:set var="currentCategory" value="${item.categoryName}"/>
                    </c:if>

                    <div class="menu-item-card" id="menuItem-${item.foodId}">
                        <div class="menu-item-info">
                            <div class="menu-item-veg-indicator ${item.veg ? 'veg' : 'non-veg'}">
                                <span class="veg-dot"></span>
                            </div>
                            <h4 class="menu-item-name">
                                <c:out value="${item.name}"/>
                                <c:if test="${item.bestseller}">
                                    <span class="bestseller-tag">★ Bestseller</span>
                                </c:if>
                            </h4>
                            <p class="menu-item-price">₹<fmt:formatNumber value="${item.price}" pattern="#,##0.00"/></p>
                            <p class="menu-item-desc"><c:out value="${item.description}"/></p>
                        </div>
                        <div class="menu-item-action" style="display: flex; flex-direction: column; align-items: center; gap: 8px;">
                            <c:if test="${not empty item.imageUrl}">
                                <div class="menu-item-img-container" style="width: 118px; height: 96px; border-radius: var(--radius-md); overflow: hidden; box-shadow: var(--shadow-sm); margin-bottom: 4px;">
                                    <img src="${item.imageUrl}" alt="<c:out value="${item.name}"/>" style="width: 100%; height: 100%; object-fit: cover;" onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/images/default-restaurant.png';">
                                </div>
                            </c:if>
                            <button class="btn-add-to-cart" id="addBtn-${item.foodId}"
                                    onclick="addToCart(${item.foodId}, ${restaurant.restaurantId})"
                                    data-item-id="${item.foodId}"
                                    data-restaurant-id="${restaurant.restaurantId}">
                                ADD
                            </button>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${not empty currentCategory}">
                    </div>
                </c:if>

                <c:if test="${empty menuItems}">
                    <div class="empty-state">
                        <span class="empty-icon">📋</span>
                        <h3>Menu not available</h3>
                        <p>This restaurant hasn't added any items yet.</p>
                    </div>
                </c:if>
            </div>

            <!-- Customer Reviews Section -->
            <div class="reviews-section" style="margin-top: 48px; border-top: 1px solid var(--border); padding-top: 40px; display: grid; grid-template-columns: 1fr; gap: 32px;" id="reviewsSection">
                <div style="display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 16px; border-bottom: 2px solid var(--border); padding-bottom: 12px;">
                    <h2 class="section-title" style="margin: 0; border: none; padding: 0;">Customer Reviews</h2>
                    <div style="display: flex; align-items: center; gap: 8px; background: var(--primary-light); padding: 8px 16px; border-radius: var(--radius-sm);">
                        <span style="font-size: 1.15rem; font-weight: 800; color: var(--primary);">★ ${restaurant.rating}</span>
                        <span style="font-size: 0.85rem; color: var(--text-secondary); font-weight: 600;">Overall Rating</span>
                    </div>
                </div>

                <c:if test="${not empty reviewSuccess}">
                    <div class="alert alert-success" style="margin: 0;"><span class="alert-icon">✓</span> <c:out value="${reviewSuccess}"/></div>
                </c:if>

                <div style="display: grid; grid-template-columns: 1fr; gap: 32px;">
                    <!-- Review Submission Form -->
                    <c:choose>
                        <c:when test="${sessionScope.loggedInUser != null}">
                            <div style="background: var(--bg-white); border: 1px solid var(--border); border-radius: var(--radius-md); padding: 24px; box-shadow: var(--shadow-sm);">
                                <h3 style="font-size: 1.1rem; font-weight: 700; color: var(--secondary); margin-bottom: 16px; display: flex; align-items: center; gap: 6px;">✍️ Write a Review</h3>
                                <form action="${pageContext.request.contextPath}/review/add" method="post">
                                    <input type="hidden" name="restaurantId" value="${restaurant.restaurantId}">
                                    
                                    <div class="form-group" style="margin-bottom: 16px;">
                                        <label class="form-label" style="font-weight: 700; margin-bottom: 8px; display: block;">Your Rating</label>
                                        <div style="display: flex; gap: 8px; font-size: 1.75rem; cursor: pointer; color: var(--yellow);" id="starRatingSelect">
                                            <span onclick="setRating(1)" class="star-select" id="star-1" style="transition: var(--transition);">★</span>
                                            <span onclick="setRating(2)" class="star-select" id="star-2" style="transition: var(--transition);">★</span>
                                            <span onclick="setRating(3)" class="star-select" id="star-3" style="transition: var(--transition);">★</span>
                                            <span onclick="setRating(4)" class="star-select" id="star-4" style="transition: var(--transition);">★</span>
                                            <span onclick="setRating(5)" class="star-select" id="star-5" style="transition: var(--transition);">★</span>
                                        </div>
                                        <input type="hidden" name="rating" id="ratingInput" value="5">
                                    </div>

                                    <div class="form-group" style="margin-bottom: 20px;">
                                        <label class="form-label" for="reviewText" style="font-weight: 700;">Your Review</label>
                                        <textarea name="reviewText" id="reviewText" class="form-input form-textarea" rows="3" placeholder="Share your experience (food quality, packaging, delivery)..." required style="border-radius: var(--radius-sm);"></textarea>
                                    </div>

                                    <button type="submit" class="btn btn-primary" style="padding: 10px 24px; font-size: 0.85rem; border-radius: var(--radius-sm); font-weight: 700;">Submit Review</button>
                                </form>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div style="background: #fafafa; border: 1px dashed var(--border); border-radius: var(--radius-md); padding: 24px; text-align: center;">
                                <span style="font-size: 1.75rem;">✍️</span>
                                <h3 style="font-size: 1rem; font-weight: 700; color: var(--text-primary); margin: 8px 0 4px;">Want to write a review?</h3>
                                <p style="font-size: 0.85rem; color: var(--text-secondary); margin-bottom: 12px;">Please log in to share your rating and review for this restaurant.</p>
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-outline" style="font-size: 0.8rem; padding: 8px 20px; border-radius: var(--radius-sm); font-weight: 700;">Login to Review</a>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <!-- Reviews List -->
                    <div>
                        <h3 style="font-size: 1.1rem; font-weight: 700; color: var(--secondary); margin-bottom: 20px; border-bottom: 1px solid var(--border); padding-bottom: 8px;">Reviews (${reviews.size()})</h3>
                        <c:if test="${empty reviews}">
                            <div style="text-align: center; padding: 30px; background: #fafafa; border-radius: var(--radius-md); border: 1px solid var(--border);">
                                <p style="font-size: 0.9rem; color: var(--text-muted); font-style: italic; margin: 0;">No reviews yet for this restaurant. Be the first to share your experience!</p>
                            </div>
                        </c:if>
                        <div style="display: flex; flex-direction: column; gap: 16px;">
                            <c:forEach var="rev" items="${reviews}">
                                <div style="background: var(--bg-white); border: 1px solid var(--border); border-radius: var(--radius-md); padding: 20px; box-shadow: var(--shadow-sm); display: flex; flex-direction: column; gap: 10px; transition: var(--transition);" class="review-item-card">
                                    <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 8px;">
                                        <div style="display: flex; align-items: center; gap: 10px;">
                                            <span style="width: 36px; height: 36px; border-radius: 50%; background: var(--primary-light); color: var(--primary); display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 0.9rem; box-shadow: var(--shadow-sm);">
                                                ${rev.reviewerAvatar}
                                            </span>
                                            <div>
                                                <div style="font-size: 0.9rem; font-weight: 700; color: var(--text-primary);">${rev.reviewerName}</div>
                                                <div style="font-size: 0.75rem; color: var(--text-muted); font-weight: 500;">${rev.formattedDate}</div>
                                            </div>
                                        </div>
                                        <div style="background: var(--green-light); color: var(--green); border-radius: 4px; padding: 4px 10px; font-weight: 800; font-size: 0.85rem; display: flex; align-items: center; gap: 2px;">
                                            ★ ${rev.rating}
                                        </div>
                                    </div>
                                    <p style="font-size: 0.9rem; color: var(--text-secondary); margin: 0; line-height: 1.6;">
                                        <c:out value="${rev.reviewText}"/>
                                    </p>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <script>
        function toggleFavorite(restaurantId) {
            fetch('${pageContext.request.contextPath}/favorite/toggle', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'restaurantId=' + restaurantId
            })
            .then(response => {
                if (response.status === 401) {
                    alert("Please log in to add this restaurant to your favorites.");
                    window.location.href = '${pageContext.request.contextPath}/login';
                    throw new Error("Unauthorized");
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    const heart = document.getElementById("favoriteHeart");
                    const text = document.getElementById("favoriteText");
                    const btn = document.getElementById("favoriteBtn");
                    if (data.isFavorite) {
                        heart.innerText = "❤️";
                        text.innerText = "Favorited";
                        btn.style.color = "var(--red)";
                        heart.style.transform = "scale(1.3)";
                        setTimeout(() => heart.style.transform = "scale(1)", 200);
                    } else {
                        heart.innerText = "🤍";
                        text.innerText = "Favorite";
                        btn.style.color = "var(--text-secondary)";
                    }
                } else if (data.error) {
                    alert(data.error);
                }
            })
            .catch(err => console.error("Error toggling favorite:", err));
        }

        function setRating(rating) {
            document.getElementById("ratingInput").value = rating;
            for (let i = 1; i <= 5; i++) {
                const star = document.getElementById("star-" + i);
                if (i <= rating) {
                    star.style.color = "var(--yellow)";
                    star.style.transform = "scale(1.2)";
                } else {
                    star.style.color = "var(--text-muted)";
                    star.style.transform = "scale(1)";
                }
            }
        }
    </script>

    <style>
        .star-select:hover {
            transform: scale(1.3) !important;
        }
        .review-item-card:hover {
            border-color: var(--primary-light);
            box-shadow: var(--shadow-md);
        }
    </style>

    <script>
        function addToCart(itemId, restaurantId) {
            fetch('${pageContext.request.contextPath}/cart', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'action=add&itemId=' + itemId + '&restaurantId=' + restaurantId + '&quantity=1'
            })
            .then(response => {
                if (response.status === 401) {
                    showCustomAlert("Login Required", "Please log in to add items to your cart.", "🔒");
                    return;
                }
                return response.json();
            })
            .then(async data => {
                if (data.success) {
                    const btn = document.getElementById('addBtn-' + itemId);
                    if (btn) {
                        btn.innerHTML = 'Added! <span style="font-size: 0.8rem;">✓</span>';
                        btn.style.background = 'var(--green)';
                        btn.style.color = 'white';
                        btn.style.border = 'none';
                        setTimeout(() => {
                            btn.innerHTML = 'ADD';
                            btn.style = '';
                        }, 2000);
                    }

                    if (data.cartCount !== undefined) {
                        const cartLink = document.getElementById('navCart');
                        if (cartLink) {
                            cartLink.innerHTML = '<span class="nav-link-icon">🛒</span> Cart <span class="cart-badge" id="cartBadge">' + data.cartCount + '</span>';
                        }
                    }
                } else if (data.conflict) {
                    const confirmed = await showCustomConfirm(
                        "Clear Cart?", 
                        data.message, 
                        "⚠️", 
                        "Clear & Add", 
                        "var(--primary-color)"
                    );
                    if (confirmed) {
                        clearAndAddToCart(itemId, restaurantId);
                    }
                } else if (data.error) {
                    showCustomAlert("Error", data.error, "❌");
                }
            })
            .catch(err => console.error("Error adding to cart:", err));
        }

        function clearAndAddToCart(itemId, restaurantId) {
            fetch('${pageContext.request.contextPath}/cart', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'action=clearAndAdd&itemId=' + itemId + '&restaurantId=' + restaurantId + '&quantity=1'
            })
            .then(r => r.json())
            .then(data => {
                if(data.success) {
                    const badge = document.getElementById('cartBadge');
                    if(badge) badge.innerText = data.cartCount;
                    alert("Cart cleared and item added!");
                }
            });
        }
    </script>

<jsp:include page="/jsp/common/footer.jsp"/>
