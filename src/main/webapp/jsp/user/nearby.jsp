<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="Nearby Restaurants"/></jsp:include>

<section class="section" style="padding-top: 120px; min-height: 80vh;">
    <div class="container">
        <div class="page-header" style="text-align: center; margin-bottom: 40px;">
            <h1 style="font-size: 2.5rem; color: var(--text-primary); margin-bottom: 10px;">Nearby Restaurants</h1>
            <p style="color: var(--text-secondary);">Discover the best food around you</p>
        </div>
        
        <div id="locationPrompt" style="text-align: center; padding: 40px; background: white; border-radius: 16px; box-shadow: var(--shadow-sm); margin-bottom: 40px;">
            <div style="font-size: 3rem; margin-bottom: 15px;">📍</div>
            <h3>We need your location</h3>
            <p style="color: var(--text-secondary); margin-bottom: 20px;">Please allow location access to find restaurants near you.</p>
            <button class="btn btn-primary" onclick="requestLocation()">Locate Me</button>
        </div>

        <div id="nearbyResults" style="display: none;">
            <div class="cuisine-filters" style="margin-bottom: 30px; display: flex; flex-wrap: wrap; gap: 10px; justify-content: center;">
                <button class="cuisine-pill active" onclick="sortNearby('distance')">Nearest First</button>
                <button class="cuisine-pill" onclick="sortNearby('rating')">Highest Rated</button>
                <button class="cuisine-pill" onclick="sortNearby('time')">Fastest Delivery</button>
            </div>
            
            <div class="restaurant-grid" id="nearbyGrid">
                <!-- Javascript will inject sorted cards here -->
            </div>
        </div>
    </div>
</section>

<script>
    // Store restaurant data passed from server
    const restaurantsData = [
        <c:forEach var="r" items="${restaurants}" varStatus="loop">
        {
            id: '${r.restaurantId}',
            name: '${r.name.replace("'", "\\'")}',
            image: '${r.imageUrl}',
            rating: ${r.rating},
            cuisine: '${r.cuisineType}',
            area: '${r.area}',
            price: ${r.priceForTwo},
            time: ${r.deliveryTime},
            veg: ${r.veg},
            lat: ${r.latitude},
            lon: ${r.longitude}
        }${!loop.last ? ',' : ''}
        </c:forEach>
    ];

    let userLocation = null;

    function requestLocation() {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
                function(pos) {
                    userLocation = { lat: pos.coords.latitude, lon: pos.coords.longitude };
                    document.getElementById('locationPrompt').style.display = 'none';
                    document.getElementById('nearbyResults').style.display = 'block';
                    calculateDistancesAndRender();
                },
                function(err) {
                    alert("Could not get your location. Please check browser permissions.");
                }
            );
        } else {
            alert("Geolocation is not supported by your browser.");
        }
    }

    // Haversine formula to calculate distance in km
    function getDistance(lat1, lon1, lat2, lon2) {
        const R = 6371; 
        const dLat = (lat2 - lat1) * Math.PI / 180;
        const dLon = (lon2 - lon1) * Math.PI / 180;
        const a = Math.sin(dLat/2) * Math.sin(dLat/2) +
                Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
                Math.sin(dLon/2) * Math.sin(dLon/2);
        const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
        return R * c;
    }

    function calculateDistancesAndRender(sortBy = 'distance') {
        if (!userLocation) return;
        
        let processed = restaurantsData.map(r => {
            let dist = getDistance(userLocation.lat, userLocation.lon, r.lat, r.lon);
            return { ...r, distance: dist };
        }).filter(r => r.distance <= 20); // Maximum 20km delivery radius

        if (sortBy === 'distance') {
            processed.sort((a, b) => a.distance - b.distance);
        } else if (sortBy === 'rating') {
            processed.sort((a, b) => b.rating - a.rating);
        } else if (sortBy === 'time') {
            processed.sort((a, b) => a.time - b.time);
        }

        const grid = document.getElementById('nearbyGrid');
        grid.innerHTML = '';
        
        if (processed.length === 0) {
            grid.innerHTML = `
                <div style="grid-column: 1 / -1; text-align: center; padding: 60px 20px; background: white; border-radius: 16px; box-shadow: var(--shadow-sm);">
                    <div style="font-size: 3rem; margin-bottom: 15px;">🛵</div>
                    <h3 style="font-size: 1.5rem; color: var(--text-primary); margin-bottom: 10px;">Out of Service Area</h3>
                    <p style="color: var(--text-secondary);">We currently don't have any partner restaurants delivering to your exact location (within 20 km).</p>
                    <p style="color: var(--text-secondary); margin-top: 5px;">We are expanding rapidly, so please check back soon!</p>
                </div>
            `;
            document.querySelectorAll('#nearbyResults .cuisine-filters').forEach(el => el.style.display = 'none');
            return;
        } else {
            document.querySelectorAll('#nearbyResults .cuisine-filters').forEach(el => el.style.display = 'flex');
        }

        let weatherDelay = parseInt(localStorage.getItem('craverush_weather_delay') || '0');

        processed.forEach(r => {
            let displayDist = r.distance.toFixed(1) + ' km';
            let deliveryTime = r.time + weatherDelay;
            let vegBadge = r.veg ? '<span class="veg-badge">Pure Veg</span>' : '';
            let imgHtml = r.image ? '<img src="' + r.image + '" style="width: 100%; height: 100%; object-fit: cover;" loading="lazy" onerror="this.onerror=null; this.src=\'${pageContext.request.contextPath}/images/default-restaurant.png\';">' : '<div class="restaurant-card-img-placeholder">🍽️</div>';
            
            let cardHtml = `
                <a href="${pageContext.request.contextPath}/restaurant?id=` + r.id + `" class="restaurant-card fade-in" style="opacity:1; transform:none;">
                    <div class="restaurant-card-img">
                        ` + imgHtml + `
                        ` + vegBadge + `
                        <div class="delivery-time-badge">` + deliveryTime + ` min</div>
                    </div>
                    <div class="restaurant-card-body">
                        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px;">
                            <h3 class="restaurant-card-name" style="margin:0;">` + r.name + `</h3>
                            <div style="font-size:0.8rem; font-weight:600; color:var(--text-secondary); background:rgba(0,0,0,0.04); padding:2px 6px; border-radius:4px;">📍 ` + displayDist + `</div>
                        </div>
                        <div class="restaurant-card-rating">
                            <span class="rating-star">★</span>
                            <span class="rating-value">` + r.rating.toFixed(1) + `</span>
                        </div>
                        <p class="restaurant-card-cuisine">` + r.cuisine + `</p>
                        <p class="restaurant-card-min-order">₹` + r.price + ` for two</p>
                    </div>
                </a>
            `;
            grid.innerHTML += cardHtml;
        });

        // Update pills
        document.querySelectorAll('#nearbyResults .cuisine-pill').forEach(p => p.classList.remove('active'));
        if (sortBy === 'distance') document.querySelectorAll('#nearbyResults .cuisine-pill')[0].classList.add('active');
        if (sortBy === 'rating') document.querySelectorAll('#nearbyResults .cuisine-pill')[1].classList.add('active');
        if (sortBy === 'time') document.querySelectorAll('#nearbyResults .cuisine-pill')[2].classList.add('active');
    }

    function sortNearby(type) {
        calculateDistancesAndRender(type);
    }
</script>

<jsp:include page="/jsp/common/footer.jsp"/>
