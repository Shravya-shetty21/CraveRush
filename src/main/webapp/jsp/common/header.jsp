<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="CraveRush - Premium food delivery in Bengaluru. Order from 500+ top-rated restaurants with lightning-fast delivery.">
    <meta name="keywords" content="food delivery, Bengaluru, restaurants, order food online, CraveRush">
    <meta name="author" content="CraveRush">
    <meta name="theme-color" content="#FC8019">
    <title>${param.pageTitle != null ? param.pageTitle : 'CraveRush'} | Premium Food Delivery</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/images/craverush-icon.svg">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script>
        window.contextPath = '${pageContext.request.contextPath}';
    </script>
</head>
<body>
    <nav class="navbar" id="mainNavbar">
        <div class="nav-container">
            <div style="display: flex; align-items: center;">
                <a href="${pageContext.request.contextPath}/home" class="nav-logo" id="navLogo">
                    <img src="${pageContext.request.contextPath}/images/craverush-logo.svg" alt="CraveRush" class="nav-logo-img" id="navLogoImg">
                </a>
                <div class="nav-location" style="margin-left: 16px; display: flex; align-items: center; gap: 6px; font-size: 0.88rem; font-weight: 600; color: var(--text-primary);">
                    <span>📍</span>
                    <select onchange="location.href='${pageContext.request.contextPath}/restaurants?location=' + encodeURIComponent(this.value)" style="border: none; background: transparent; font-weight: 700; font-family: var(--font); color: var(--primary); outline: none; cursor: pointer; font-size: 0.88rem;">
                        <option value="All" ${sessionScope.selectedLocation == 'All' ? 'selected' : ''}>All Locations</option>
                        <option value="BTM Layout" ${sessionScope.selectedLocation == 'BTM Layout' ? 'selected' : ''}>BTM Layout</option>
                        <option value="Koramangala" ${sessionScope.selectedLocation == 'Koramangala' || sessionScope.selectedLocation == null ? 'selected' : ''}>Koramangala</option>
                        <option value="HSR Layout" ${sessionScope.selectedLocation == 'HSR Layout' ? 'selected' : ''}>HSR Layout</option>
                        <option value="JP Nagar" ${sessionScope.selectedLocation == 'JP Nagar' ? 'selected' : ''}>JP Nagar</option>
                        <option value="Jayanagar" ${sessionScope.selectedLocation == 'Jayanagar' ? 'selected' : ''}>Jayanagar</option>
                        <option value="Indiranagar" ${sessionScope.selectedLocation == 'Indiranagar' ? 'selected' : ''}>Indiranagar</option>
                        <option value="Whitefield" ${sessionScope.selectedLocation == 'Whitefield' ? 'selected' : ''}>Whitefield</option>
                        <option value="Electronic City" ${sessionScope.selectedLocation == 'Electronic City' ? 'selected' : ''}>Electronic City</option>
                        <option value="Marathahalli" ${sessionScope.selectedLocation == 'Marathahalli' ? 'selected' : ''}>Marathahalli</option>
                        <option value="Bellandur" ${sessionScope.selectedLocation == 'Bellandur' ? 'selected' : ''}>Bellandur</option>
                        <option value="MG Road" ${sessionScope.selectedLocation == 'MG Road' ? 'selected' : ''}>MG Road</option>
                        <option value="Banashankari" ${sessionScope.selectedLocation == 'Banashankari' ? 'selected' : ''}>Banashankari</option>
                        <option value="Rajajinagar" ${sessionScope.selectedLocation == 'Rajajinagar' ? 'selected' : ''}>Rajajinagar</option>
                        <option value="Yelahanka" ${sessionScope.selectedLocation == 'Yelahanka' ? 'selected' : ''}>Yelahanka</option>
                        <option value="Hebbal" ${sessionScope.selectedLocation == 'Hebbal' ? 'selected' : ''}>Hebbal</option>
                        <option value="Malleshwaram" ${sessionScope.selectedLocation == 'Malleshwaram' ? 'selected' : ''}>Malleshwaram</option>
                        <option value="Basavanagudi" ${sessionScope.selectedLocation == 'Basavanagudi' ? 'selected' : ''}>Basavanagudi</option>
                        <option value="Vijayanagar" ${sessionScope.selectedLocation == 'Vijayanagar' ? 'selected' : ''}>Vijayanagar</option>
                        <option value="Bannerghatta Road" ${sessionScope.selectedLocation == 'Bannerghatta Road' ? 'selected' : ''}>Bannerghatta Road</option>
                    </select>
                </div>
            </div>

            <div class="nav-search" id="navSearch">
                <form action="${pageContext.request.contextPath}/restaurants" method="get" class="search-form">
                    <span class="search-icon">🔍</span>
                    <input type="text" name="search" placeholder="Search for restaurants, cuisines..."
                           value="${searchQuery}" class="search-input" id="searchInput" autocomplete="off">
                </form>
            </div>

            <div class="nav-links" id="navLinks">

                <a href="${pageContext.request.contextPath}/offers" class="nav-link" id="navOffers">
                    <span class="nav-link-icon">🏷️</span> Offers
                </a>
                <c:choose>
                    <c:when test="${sessionScope.loggedInUser != null}">
                        <a href="${pageContext.request.contextPath}/orders" class="nav-link" id="navOrders">
                            <span class="nav-link-icon">📋</span> Orders
                        </a>
                        <a href="${pageContext.request.contextPath}/cart" class="nav-link nav-cart" id="navCart">
                            <span class="nav-link-icon">🛒</span> Cart
                            <c:if test="${sessionScope.cartCount != null && sessionScope.cartCount > 0}">
                                <span class="cart-badge" id="cartBadge">${sessionScope.cartCount}</span>
                            </c:if>
                        </a>
                        <div class="nav-user-menu" id="navUserMenu">
                            <button class="nav-user-btn" id="userMenuBtn">
                                <span class="user-avatar">${sessionScope.loggedInUser.fullName.substring(0,1)}</span>
                                <span class="user-name">${sessionScope.loggedInUser.fullName}</span>
                            </button>
                            <div class="user-dropdown" id="userDropdown">
                                <a href="${pageContext.request.contextPath}/logout" class="dropdown-item dropdown-logout">Logout</a>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="nav-link" id="navLogin">Login</a>
                        <a href="${pageContext.request.contextPath}/register" class="nav-link nav-link-cta" id="navRegister">Sign Up</a>
                    </c:otherwise>
                </c:choose>
            </div>

            <button class="nav-mobile-toggle" id="mobileMenuToggle" aria-label="Toggle menu">
                <span></span><span></span><span></span>
            </button>
        </div>
    </nav>

    <!-- Custom Modal -->
    <div id="customModal" class="custom-modal-overlay">
        <div class="custom-modal">
            <div class="custom-modal-icon" id="modalIcon">🗑️</div>
            <h3 class="custom-modal-title" id="modalTitle">Remove Item?</h3>
            <p class="custom-modal-text" id="modalText">Are you sure you want to remove this item from your cart?</p>
            <div class="custom-modal-actions">
                <button class="btn btn-outline" id="modalCancelBtn">Cancel</button>
                <button class="btn btn-primary" id="modalConfirmBtn" style="background: var(--red); border-color: var(--red); color: white;">Remove</button>
            </div>
        </div>
    </div>

    <style>
        .custom-modal-overlay {
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(0,0,0,0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 9999;
            opacity: 0;
            pointer-events: none;
            transition: opacity 0.3s ease;
            backdrop-filter: blur(4px);
        }
        .custom-modal-overlay.active {
            opacity: 1;
            pointer-events: all;
        }
        .custom-modal {
            background: white;
            padding: 30px;
            border-radius: 16px;
            width: 90%;
            max-width: 400px;
            text-align: center;
            transform: translateY(20px) scale(0.95);
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            box-shadow: 0 20px 40px rgba(0,0,0,0.2);
        }
        .custom-modal-overlay.active .custom-modal {
            transform: translateY(0) scale(1);
        }
        .custom-modal-icon {
            font-size: 48px;
            margin-bottom: 15px;
            background: #fff1f0;
            width: 80px;
            height: 80px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            color: var(--red);
            margin-left: auto;
            margin-right: auto;
        }
        .custom-modal-title {
            font-size: 1.5rem;
            color: var(--text-primary);
            margin-bottom: 10px;
        }
        .custom-modal-text {
            color: var(--text-secondary);
            margin-bottom: 25px;
            line-height: 1.5;
        }
        .custom-modal-actions {
            display: flex;
            gap: 15px;
            justify-content: center;
        }
        .custom-modal-actions .btn {
            min-width: 120px;
        }
    </style>

    <script>
        let modalResolve = null;

        function showCustomConfirm(title, text, icon, confirmText, confirmColor) {
            return new Promise((resolve) => {
                const modal = document.getElementById('customModal');
                document.getElementById('modalTitle').textContent = title;
                document.getElementById('modalText').textContent = text;
                document.getElementById('modalIcon').textContent = icon;
                
                const confirmBtn = document.getElementById('modalConfirmBtn');
                confirmBtn.textContent = confirmText;
                confirmBtn.style.background = confirmColor;
                confirmBtn.style.borderColor = confirmColor;
                confirmBtn.style.color = "white";

                if(icon === '⚠️') {
                    document.getElementById('modalIcon').style.background = '#fffbe6';
                } else if(icon === '❌' || icon === '🗑️') {
                    document.getElementById('modalIcon').style.background = '#fff1f0';
                } else {
                    document.getElementById('modalIcon').style.background = '#fff1f0';
                }

                modal.classList.add('active');
                modalResolve = resolve;
            });
        }

        function showCustomAlert(title, text, icon = '⚠️') {
            return new Promise((resolve) => {
                const modal = document.getElementById('customModal');
                document.getElementById('modalTitle').textContent = title;
                document.getElementById('modalText').textContent = text;
                document.getElementById('modalIcon').textContent = icon;
                
                document.getElementById('modalCancelBtn').style.display = 'none';
                
                const confirmBtn = document.getElementById('modalConfirmBtn');
                confirmBtn.textContent = 'OK';
                confirmBtn.style.background = 'var(--primary)';
                confirmBtn.style.borderColor = 'var(--primary)';
                confirmBtn.style.color = "white";

                modal.classList.add('active');
                modalResolve = resolve;
            });
        }

        function hideModal() {
            document.getElementById('customModal').classList.remove('active');
            setTimeout(() => {
                document.getElementById('modalCancelBtn').style.display = 'block';
            }, 300);
        }

        document.addEventListener('DOMContentLoaded', () => {
            const cancelBtn = document.getElementById('modalCancelBtn');
            const confirmBtn = document.getElementById('modalConfirmBtn');
            
            if (cancelBtn) {
                cancelBtn.addEventListener('click', () => {
                    hideModal();
                    if (modalResolve) modalResolve(false);
                });
            }
            if (confirmBtn) {
                confirmBtn.addEventListener('click', () => {
                    hideModal();
                    if (modalResolve) modalResolve(true);
                });
            }
        });
    </script>
    <main class="main-content">
