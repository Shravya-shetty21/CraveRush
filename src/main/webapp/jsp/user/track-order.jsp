<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="Track Order"/></jsp:include>
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>

    <section class="page-section" id="trackOrderSection" style="padding-top: 40px;">
        <div class="container">
            <a href="${pageContext.request.contextPath}/orders" class="back-link">← Back to My Orders</a>
            
            <div class="order-detail-header" style="margin-bottom: 20px;">
                <div>
                    <h1 class="page-title">Tracking Order #${order.orderId}</h1>
                    <p class="page-subtitle">Placed on ${order.formattedOrderDate}</p>
                </div>
                <div>
                    <span class="order-status order-status-placed" id="liveStatusBadge">${order.status}</span>
                </div>
            </div>

            <div class="order-detail-grid">
                <!-- Left: Live Tracking Status & Map -->
                <div style="display: flex; flex-direction: column; gap: 24px;">
                    
                    <!-- Tracking Status Stepper Card -->
                    <div class="menu-section" style="padding: 30px;">
                        <h3 style="margin-bottom: 24px; font-weight: 700; color: var(--text-primary);">Delivery Status</h3>
                        
                        <div class="stepper-wrapper" style="display: flex; justify-content: space-between; position: relative; margin-bottom: 30px; padding: 0 10px;">
                            <!-- Progress line background -->
                            <div class="stepper-line" style="position: absolute; top: 18px; left: 30px; right: 30px; height: 4px; background: #e0e0e0; z-index: 1;">
                                <div class="stepper-line-progress" id="stepperLineProgress" style="height: 100%; width: 0%; background: var(--green); transition: width 0.8s ease;"></div>
                            </div>
                            
                            <!-- Step 1: PLACED -->
                            <div class="step-item active" id="step-PLACED" style="display: flex; flex-direction: column; align-items: center; z-index: 2; width: 60px; text-align: center;">
                                <div class="step-circle" id="circle-PLACED" style="width: 38px; height: 38px; border-radius: 50%; background: var(--green); color: white; display: flex; align-items: center; justify-content: center; font-weight: 700; border: 3px solid white; box-shadow: var(--shadow-sm); font-size: 0.9rem; transition: background 0.4s;">📋</div>
                                <span class="step-label" style="font-size: 0.75rem; font-weight: 600; margin-top: 8px; color: var(--text-secondary);">Placed</span>
                            </div>
                            
                            <!-- Step 2: CONFIRMED -->
                            <div class="step-item" id="step-CONFIRMED" style="display: flex; flex-direction: column; align-items: center; z-index: 2; width: 60px; text-align: center;">
                                <div class="step-circle" id="circle-CONFIRMED" style="width: 38px; height: 38px; border-radius: 50%; background: #e0e0e0; color: #757575; display: flex; align-items: center; justify-content: center; font-weight: 700; border: 3px solid white; box-shadow: var(--shadow-sm); font-size: 0.9rem; transition: background 0.4s;">👍</div>
                                <span class="step-label" style="font-size: 0.75rem; font-weight: 600; margin-top: 8px; color: var(--text-muted);">Confirmed</span>
                            </div>
                            
                            <!-- Step 3: PREPARING -->
                            <div class="step-item" id="step-PREPARING" style="display: flex; flex-direction: column; align-items: center; z-index: 2; width: 60px; text-align: center;">
                                <div class="step-circle" id="circle-PREPARING" style="width: 38px; height: 38px; border-radius: 50%; background: #e0e0e0; color: #757575; display: flex; align-items: center; justify-content: center; font-weight: 700; border: 3px solid white; box-shadow: var(--shadow-sm); font-size: 0.9rem; transition: background 0.4s;">🍳</div>
                                <span class="step-label" style="font-size: 0.75rem; font-weight: 600; margin-top: 8px; color: var(--text-muted);">Preparing</span>
                            </div>
                            
                            <!-- Step 4: OUT_FOR_DELIVERY -->
                            <div class="step-item" id="step-OUT_FOR_DELIVERY" style="display: flex; flex-direction: column; align-items: center; z-index: 2; width: 60px; text-align: center;">
                                <div class="step-circle" id="circle-OUT_FOR_DELIVERY" style="width: 38px; height: 38px; border-radius: 50%; background: #e0e0e0; color: #757575; display: flex; align-items: center; justify-content: center; font-weight: 700; border: 3px solid white; box-shadow: var(--shadow-sm); font-size: 0.9rem; transition: background 0.4s;">🏍️</div>
                                <span class="step-label" style="font-size: 0.75rem; font-weight: 600; margin-top: 8px; color: var(--text-muted);">On the Way</span>
                            </div>
                            
                            <!-- Step 5: DELIVERED -->
                            <div class="step-item" id="step-DELIVERED" style="display: flex; flex-direction: column; align-items: center; z-index: 2; width: 60px; text-align: center;">
                                <div class="step-circle" id="circle-DELIVERED" style="width: 38px; height: 38px; border-radius: 50%; background: #e0e0e0; color: #757575; display: flex; align-items: center; justify-content: center; font-weight: 700; border: 3px solid white; box-shadow: var(--shadow-sm); font-size: 0.9rem; transition: background 0.4s;">🏠</div>
                                <span class="step-label" style="font-size: 0.75rem; font-weight: 600; margin-top: 8px; color: var(--text-muted);">Delivered</span>
                            </div>
                        </div>

                        <!-- Status Description Text -->
                        <div id="liveMessageCard" style="background: var(--primary-light); padding: 16px 20px; border-radius: var(--radius-md); border-left: 4px solid var(--primary); display: flex; align-items: center; gap: 14px;">
                            <span style="font-size: 1.5rem;" id="liveStatusIcon">📋</span>
                            <div>
                                <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--primary-dark);" id="liveStatusTitle">Order Received</h4>
                                <p style="font-size: 0.85rem; color: var(--text-secondary); margin: 0;" id="liveStatusText">We have received your order and are waiting for restaurant confirmation.</p>
                            </div>
                        </div>
                    </div>

                    <!-- Live Map Simulation Card -->
                    <div class="menu-section" style="padding: 24px;">
                        <h3 style="margin-bottom: 16px; font-weight: 700;">Live Delivery Route</h3>
                        
                        <div style="background: #eef2f5; border-radius: var(--radius-lg); height: 350px; width: 100%; position: relative; overflow: hidden; border: 1px solid var(--border);">
                            <!-- Leaflet Map Container -->
                            <div id="map" style="height: 100%; width: 100%; z-index: 1;"></div>
                            
                            <!-- Delivery Partner overlay card (Dribbble Style) -->
                            <div id="deliveryPartnerCard" style="position: absolute; bottom: 16px; left: 16px; right: 16px; background: rgba(255,255,255,0.95); backdrop-filter: blur(8px); padding: 12px 18px; border-radius: var(--radius-md); border: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; transform: translateY(100px); opacity: 0; transition: transform 0.5s ease, opacity 0.5s ease; z-index: 1000;">
                                <div style="display: flex; align-items: center; gap: 12px;">
                                    <div id="riderAvatar" style="width: 44px; height: 44px; border-radius: 50%; background: linear-gradient(135deg, var(--primary), var(--primary-dark)); display: flex; align-items: center; justify-content: center; color: white; font-weight: 800; font-size: 1.2rem;">🏍️</div>
                                    <div>
                                        <h5 id="riderNameText" style="margin: 0; font-size: 0.9rem; font-weight: 700; color: var(--text-primary);">Rider</h5>
                                        <p id="riderVehicleText" style="margin: 0; font-size: 0.75rem; color: var(--text-muted);">Delivery Partner</p>
                                    </div>
                                </div>
                                <div style="display: flex; gap: 8px;">
                                    <a id="riderPhoneCall" href="#" class="btn btn-sm btn-outline" style="border-radius: var(--radius-full); padding: 8px 12px; font-size: 0.75rem;">📞 Call Rider</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right: Order Summary Details -->
                <div>
                    <div class="order-detail-summary">
                        <h3>Order Summary</h3>
                        
                        <div style="margin-bottom: 16px;">
                            <p style="margin: 0 0 4px; font-size: 0.8rem; color: var(--text-secondary); text-transform: uppercase; font-weight: 700; letter-spacing: 0.5px;">Deliver To</p>
                            <p style="margin: 0; font-size: 0.9rem; font-weight: 600; color: var(--text-primary);"><c:out value="${order.deliveryAddress}"/></p>
                        </div>
                        
                        <c:if test="${not empty order.notes}">
                            <div style="margin-bottom: 20px; background: #fafafa; padding: 10px 14px; border-radius: var(--radius-sm); border: 1px solid var(--border);">
                                <p style="margin: 0 0 2px; font-size: 0.75rem; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Delivery Notes</p>
                                <p style="margin: 0; font-size: 0.82rem; color: var(--text-secondary); font-style: italic;"><c:out value="${order.notes}"/></p>
                            </div>
                        </c:if>
                        
                        <div class="order-detail-info-section" style="border-top: 1px solid var(--border); padding-top: 16px; margin-top: 0;">
                            <h4>Items Ordered</h4>
                            <div style="display: flex; flex-direction: column; gap: 8px; margin-top: 10px;">
                                <c:forEach var="item" items="${orderItems}">
                                    <div style="display: flex; justify-content: space-between; font-size: 0.88rem;">
                                        <span>
                                            <span style="color: var(--text-secondary); font-weight: 600;">${item.quantity}x</span>
                                            <c:out value="${item.itemName}"/>
                                        </span>
                                        <span style="font-weight: 600;">₹<fmt:formatNumber value="${item.totalPrice}" pattern="#,##0.00"/></span>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                        
                        <div style="margin-top: 20px; border-top: 1px solid var(--border); padding-top: 16px; display: flex; flex-direction: column; gap: 8px;">
                            <div class="cart-summary-row" style="margin: 0;">
                                <span>Subtotal</span>
                                <span>₹<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></span>
                            </div>
                            <div class="cart-summary-row" style="margin: 0;">
                                <span>Delivery Fee</span>
                                <span>₹<fmt:formatNumber value="${order.deliveryFee}" pattern="#,##0.00"/></span>
                            </div>
                            <div class="cart-summary-row" style="margin: 0;">
                                <span>Taxes & GST (5%)</span>
                                <span>₹<fmt:formatNumber value="${order.taxAmount}" pattern="#,##0.00"/></span>
                            </div>
                            <hr class="cart-summary-divider" style="margin: 8px 0;">
                            <div class="cart-summary-row cart-summary-total" style="margin: 0; font-size: 1.1rem;">
                                <span>Grand Total</span>
                                <span style="color: var(--primary);">₹<fmt:formatNumber value="${order.grandTotal}" pattern="#,##0.00"/></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Tracking Real-time Simulator JavaScript Script -->
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            // Statuses transitions order: PLACED -> CONFIRMED -> PREPARING -> OUT_FOR_DELIVERY -> DELIVERED
            const states = [
                {
                    status: "PLACED",
                    percentage: 0,
                    badgeClass: "order-status-placed",
                    icon: "📋",
                    title: "Order Placed",
                    desc: "Your order has been received by the restaurant. Waiting for confirmation."
                },
                {
                    status: "CONFIRMED",
                    percentage: 25,
                    badgeClass: "order-status-confirmed",
                    icon: "👍",
                    title: "Order Confirmed",
                    desc: "The restaurant has accepted your order and will start cooking soon."
                },
                {
                    status: "PREPARING",
                    percentage: 50,
                    badgeClass: "order-status-preparing",
                    icon: "🍳",
                    title: "Preparing Food",
                    desc: "Chef is cooking your delicious meal with care. Fresh ingredients only!"
                },
                {
                    status: "OUT_FOR_DELIVERY",
                    percentage: 75,
                    badgeClass: "order-status-out_for_delivery",
                    icon: "🏍️",
                    title: "Out for Delivery",
                    desc: "Your rider has picked up your food and is riding to your address. Almost there!"
                },
                {
                    status: "DELIVERED",
                    percentage: 100,
                    badgeClass: "order-status-delivered",
                    icon: "🏠",
                    title: "Order Delivered!",
                    desc: "Food has been delivered. Thank you for ordering from CraveRush! Enjoy your meal."
                }
            ];

            let map, restaurantMarker, customerMarker, riderMarker, routeLine;

            function normalizeStatus(apiStatus) {
                if (!apiStatus) return "PLACED";
                apiStatus = apiStatus.toUpperCase();
                if (apiStatus === "ACCEPTED") return "CONFIRMED";
                if (apiStatus === "READY_FOR_PICKUP") return "PREPARING";
                if (apiStatus === "PICKED_UP") return "OUT_FOR_DELIVERY";
                return apiStatus;
            }

            function initMap(data) {
                const restCoords = [data.restaurantLat, data.restaurantLng];
                const custCoords = [data.customerLat, data.customerLng];
                const riderCoords = [data.riderLat, data.riderLng];
                
                // Initialize map centered between restaurant and customer
                map = L.map('map').setView([(restCoords[0] + custCoords[0]) / 2, (restCoords[1] + custCoords[1]) / 2], 13);
                
                // Add OpenStreetMap tiles
                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                    maxZoom: 19,
                    attribution: '© OpenStreetMap contributors'
                }).addTo(map);
                
                // Custom CSS-based Div Icons
                const restIcon = L.divIcon({
                    html: '<div style="font-size: 26px; line-height: 1; text-align: center; cursor: pointer; filter: drop-shadow(0 2px 5px rgba(0,0,0,0.3));">🍳</div>',
                    iconSize: [30, 30],
                    iconAnchor: [15, 15]
                });
                
                const custIcon = L.divIcon({
                    html: '<div style="font-size: 26px; line-height: 1; text-align: center; cursor: pointer; filter: drop-shadow(0 2px 5px rgba(0,0,0,0.3));">🏠</div>',
                    iconSize: [30, 30],
                    iconAnchor: [15, 15]
                });
                
                // Add static markers
                restaurantMarker = L.marker(restCoords, {icon: restIcon}).addTo(map).bindPopup('<b>${order.restaurant.name} (Kitchen)</b>');
                customerMarker = L.marker(custCoords, {icon: custIcon}).addTo(map).bindPopup('<b>Your Delivery Location</b>');
                
                // Add rider if OUT_FOR_DELIVERY
                const normStatus = normalizeStatus(data.orderStatus);
                if (normStatus === 'OUT_FOR_DELIVERY' || normStatus === 'DELIVERED') {
                    const riderIcon = L.divIcon({
                        html: '<div style="font-size: 32px; line-height: 1; text-align: center; cursor: pointer; filter: drop-shadow(0 2px 6px rgba(0,0,0,0.4));">🏍️</div>',
                        iconSize: [36, 36],
                        iconAnchor: [18, 18]
                    });
                    riderMarker = L.marker(riderCoords, {icon: riderIcon}).addTo(map).bindPopup('<b>Delivery Rider</b>');
                }
                
                // Draw route line
                routeLine = L.polyline([restCoords, custCoords], {
                    color: '#FC8019',
                    weight: 4,
                    opacity: 0.8,
                    dashArray: '10, 10'
                }).addTo(map);
                
                // Zoom map to fit route
                const bounds = L.latLngBounds([restCoords, custCoords]);
                map.fitBounds(bounds, { padding: [40, 40] });
            }

            function updateUI(data) {
                const normStatus = normalizeStatus(data.orderStatus);
                const index = states.findIndex(s => s.status === normStatus);
                if (index === -1) return;
                
                const state = states[index];
                
                // Update badge status
                const badge = document.getElementById("liveStatusBadge");
                badge.innerText = state.status;
                badge.className = "order-status " + state.badgeClass;

                // Update text description card
                document.getElementById("liveStatusIcon").innerText = state.icon;
                document.getElementById("liveStatusTitle").innerText = state.title;
                document.getElementById("liveStatusText").innerText = state.desc;

                // Reset all stepper classes
                states.forEach(s => {
                    const stepItem = document.getElementById("step-" + s.status);
                    const circle = document.getElementById("circle-" + s.status);
                    if (stepItem && circle) {
                        stepItem.classList.remove("active");
                        stepItem.querySelector('.step-label').style.color = "var(--text-muted)";
                        circle.style.background = "#e0e0e0";
                        circle.style.color = "#757575";
                    }
                });

                // Update stepper highlight classes
                for (let i = 0; i <= index; i++) {
                    const stepItem = document.getElementById("step-" + states[i].status);
                    const circle = document.getElementById("circle-" + states[i].status);
                    if (stepItem && circle) {
                        stepItem.classList.add("active");
                        stepItem.querySelector('.step-label').style.color = "var(--text-secondary)";
                        circle.style.background = "var(--green)";
                        circle.style.color = "white";
                    }
                }
                
                // Update stepper line percentage
                document.getElementById("stepperLineProgress").style.width = state.percentage + "%";

                // Rider details and map markers
                const riderCoords = [data.riderLat, data.riderLng];
                const card = document.getElementById("deliveryPartnerCard");

                if (normStatus === "OUT_FOR_DELIVERY" || normStatus === "DELIVERED") {
                    if (card) {
                        card.style.opacity = "1";
                        card.style.transform = "translateY(0)";
                    }
                    if (map) {
                        if (!riderMarker) {
                            const riderIcon = L.divIcon({
                                html: '<div style="font-size: 32px; line-height: 1; text-align: center; cursor: pointer; filter: drop-shadow(0 2px 6px rgba(0,0,0,0.4));">🏍️</div>',
                                iconSize: [36, 36],
                                iconAnchor: [18, 18]
                            });
                            riderMarker = L.marker(riderCoords, {icon: riderIcon}).addTo(map).bindPopup('<b>Delivery Rider</b>');
                        } else {
                            riderMarker.setLatLng(riderCoords);
                        }
                    }
                } else {
                    if (card) {
                        card.style.opacity = "0";
                        card.style.transform = "translateY(100px)";
                    }
                    if (map && riderMarker) {
                        map.removeLayer(riderMarker);
                        riderMarker = null;
                    }
                }
            }

            function pollTracking() {
                fetch("${pageContext.request.contextPath}/api/track/${order.orderId}")
                .then(res => res.json())
                .then(data => {
                    // Update stepper UI & rider
                    updateUI(data);

                    // Update rider text info
                    if (data.riderName) {
                        document.getElementById("riderNameText").innerText = data.riderName;
                        document.getElementById("riderVehicleText").innerText = "🚗 " + data.riderVehicle + " · Delivery Partner";
                        const callBtn = document.getElementById("riderPhoneCall");
                        if (callBtn) {
                            callBtn.href = "tel:" + data.riderPhone;
                            callBtn.innerText = "📞 Call " + data.riderName.split(" ")[0];
                        }
                    }

                    // Init map if not initialized
                    if (!map && data.restaurantLat) {
                        initMap(data);
                    }

                    // If delivered, clear polling interval
                    if (data.orderStatus === "DELIVERED") {
                        clearInterval(interval);
                    }
                })
                .catch(err => console.error("Error polling tracking details:", err));
            }

            // Poll every 3 seconds
            const interval = setInterval(pollTracking, 3000);
            pollTracking(); // Initial load call
        });
    </script>

<jsp:include page="/jsp/common/footer.jsp"/>
