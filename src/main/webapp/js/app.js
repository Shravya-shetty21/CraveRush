/* =============================================================
   CraveRush — Premium JavaScript v2.0
   Weather · Animations · Scroll Effects · Toast System
   ============================================================= */

(function() {
    'use strict';

    // -------------------------------------------------------
    // NAVBAR — Scroll effects + glassmorphism
    // -------------------------------------------------------
    const navbar = document.getElementById('mainNavbar');
    if (navbar) {
        let lastScroll = 0;
        window.addEventListener('scroll', function() {
            const currentScroll = window.scrollY;
            if (currentScroll > 20) {
                navbar.classList.add('navbar-scrolled');
            } else {
                navbar.classList.remove('navbar-scrolled');
            }
            lastScroll = currentScroll;
        }, { passive: true });
    }

    // -------------------------------------------------------
    // MOBILE MENU TOGGLE
    // -------------------------------------------------------
    const mobileToggle = document.getElementById('mobileMenuToggle');
    const navLinks = document.getElementById('navLinks');
    if (mobileToggle && navLinks) {
        mobileToggle.addEventListener('click', function() {
            navLinks.classList.toggle('nav-links-open');
            mobileToggle.classList.toggle('active');
        });
    }

    // -------------------------------------------------------
    // USER DROPDOWN MENU
    // -------------------------------------------------------
    const userMenuBtn = document.getElementById('userMenuBtn');
    const userDropdown = document.getElementById('userDropdown');
    if (userMenuBtn && userDropdown) {
        userMenuBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            userDropdown.classList.toggle('show');
        });
        document.addEventListener('click', function(e) {
            if (!userDropdown.contains(e.target) && !userMenuBtn.contains(e.target)) {
                userDropdown.classList.remove('show');
            }
        });
    }

    // -------------------------------------------------------
    // SCROLL-TRIGGERED FADE-IN ANIMATIONS
    // -------------------------------------------------------
    const fadeElements = document.querySelectorAll('.fade-in');
    if (fadeElements.length > 0) {
        const observerOptions = {
            root: null,
            rootMargin: '0px 0px -60px 0px',
            threshold: 0.1
        };
        const fadeObserver = new IntersectionObserver(function(entries) {
            entries.forEach(function(entry, index) {
                if (entry.isIntersecting) {
                    // Stagger animation delays
                    setTimeout(function() {
                        entry.target.classList.add('fade-in-visible');
                    }, index * 80);
                    fadeObserver.unobserve(entry.target);
                }
            });
        }, observerOptions);
        fadeElements.forEach(function(el) {
            fadeObserver.observe(el);
        });
    }

    // -------------------------------------------------------
    // LIVE WEATHER WIDGET (Open-Meteo API — No API Key)
    // -------------------------------------------------------
    const weatherCard = document.getElementById('weatherCard');
    if (weatherCard) {
        // Weather code to info mapping
        var weatherCodes = {
            0:  { icon: '☀️',  desc: 'Clear Sky',          food: 'Perfect for a refreshing salad bowl!' },
            1:  { icon: '🌤️', desc: 'Mainly Clear',        food: 'Great weather for a hot dosa or biryani!' },
            2:  { icon: '⛅',  desc: 'Partly Cloudy',       food: 'How about a comforting biryani?' },
            3:  { icon: '☁️',  desc: 'Overcast',            food: 'Cozy weather — try some hot sambar!' },
            45: { icon: '🌫️', desc: 'Foggy',               food: 'A hot filter coffee would be perfect!' },
            48: { icon: '🌫️', desc: 'Icy Fog',             food: 'Warm up with a masala chai!' },
            51: { icon: '🌦️', desc: 'Light Drizzle',       food: 'Rainy vibes — order pakoras!' },
            53: { icon: '🌧️', desc: 'Moderate Drizzle',    food: 'Stay in! Order hot maggi & tea.' },
            55: { icon: '🌧️', desc: 'Dense Drizzle',       food: 'Cozy up with a hot chocolate fudge!' },
            61: { icon: '🌧️', desc: 'Light Rain',          food: 'Rainy day = biryani day! 🍛' },
            63: { icon: '🌧️', desc: 'Moderate Rain',       food: 'Stay dry — we deliver in the rain!' },
            65: { icon: '🌧️', desc: 'Heavy Rain',          food: 'Heavy rain? Let us bring dinner to you!' },
            71: { icon: '🌨️', desc: 'Light Snow',          food: 'Something warm — try our hot soups!' },
            73: { icon: '🌨️', desc: 'Moderate Snow',       food: 'Enjoy warm comfort food delivered!' },
            75: { icon: '🌨️', desc: 'Heavy Snow',          food: 'Stay safe! Order in & stay warm.' },
            80: { icon: '🌦️', desc: 'Light Showers',       food: 'Quick showers — time for quick bites!' },
            81: { icon: '🌧️', desc: 'Moderate Showers',    food: 'Don\'t step out — we\'ll step in!' },
            82: { icon: '⛈️',  desc: 'Violent Showers',     food: 'Storm mode ON — order your favorites!' },
            95: { icon: '⛈️',  desc: 'Thunderstorm',        food: 'Thunder cravings? We got you covered!' },
            96: { icon: '⛈️',  desc: 'Thunderstorm + Hail', food: 'Stay safe indoors — we\'ll deliver!' },
            99: { icon: '⛈️',  desc: 'Severe Thunderstorm', food: 'Safety first! Order & relax at home.' }
        };

        function fetchWeather(lat, lon, cityName) {
            var url = 'https://api.open-meteo.com/v1/forecast?latitude=' + lat + '&longitude=' + lon + '&current=temperature_2m,relative_humidity_2m,precipitation,weather_code,wind_speed_10m';
            fetch(url)
                .then(function(res) { return res.json(); })
                .then(function(data) {
                    if (data && data.current) {
                        var cw = data.current;
                        var info = weatherCodes[cw.weather_code] || { icon: '🌡️', desc: 'Weather', food: 'Order your favorite meal!' };

                        var cityEl = document.getElementById('weatherCity');
                        var tempEl = document.getElementById('weatherTemp');
                        var descEl = document.getElementById('weatherDesc');
                        var suggEl = document.getElementById('weatherSuggestion');
                        var iconEl = document.getElementById('weatherIcon');
                        var estimateEl = document.getElementById('weatherDeliveryEstimate');

                        if (cityEl) cityEl.textContent = cityName + ' Weather';
                        if (tempEl) tempEl.textContent = Math.round(cw.temperature_2m) + '°C';
                        if (descEl) descEl.textContent = info.icon + ' ' + info.desc + ' · Wind ' + Math.round(cw.wind_speed_10m) + ' km/h · Hum ' + cw.relative_humidity_2m + '%';
                        if (suggEl) suggEl.textContent = info.food;
                        if (iconEl) iconEl.textContent = info.icon;
                        
                        if (estimateEl) {
                            var delay = 0;
                            var msg = "☀️ Clear weather. Fast delivery is available.";
                            var code = cw.weather_code;
                            
                            if (code >= 95) { // Thunderstorm
                                delay = 25;
                                msg = "⛈️ Thunderstorm expected. Deliveries may take longer than usual.";
                                estimateEl.style.color = "#DC2626";
                                estimateEl.style.backgroundColor = "#FEE2E2";
                            } else if (code >= 65 || code == 75 || code == 82 || code == 81 || code == 71 || code == 73) { // Heavy rain/snow
                                delay = 15;
                                msg = "🌧️ Heavy rain detected. Delivery may be delayed by approx 10–15 mins.";
                                estimateEl.style.color = "#D97706";
                                estimateEl.style.backgroundColor = "#FEF3C7";
                            } else if ((code >= 51 && code <= 63) || code == 80 || code == 45 || code == 48) { // Drizzle/Light rain/Fog
                                delay = 5;
                                msg = "🌦️ Light rain/fog. Minor delivery delay expected.";
                                estimateEl.style.color = "#D97706";
                                estimateEl.style.backgroundColor = "#FEF3C7";
                            } else {
                                estimateEl.style.color = "#059669";
                                estimateEl.style.backgroundColor = "#D1FAE5";
                            }
                            
                            estimateEl.textContent = msg;
                            estimateEl.style.display = 'block';
                            localStorage.setItem('craverush_weather_delay', delay);
                            
                            // Dynamically update restaurant delivery times on the page if they exist
                            document.querySelectorAll('.delivery-time-badge').forEach(function(badge) {
                                if (!badge.dataset.originalTime) {
                                    badge.dataset.originalTime = parseInt(badge.textContent) || 30;
                                }
                                var baseTime = parseInt(badge.dataset.originalTime);
                                badge.textContent = (baseTime + delay) + ' min';
                            });
                            document.querySelectorAll('.mini-restaurant-meta').forEach(function(meta) {
                                var spans = meta.querySelectorAll('span');
                                if (spans.length >= 3) {
                                    var timeSpan = spans[2];
                                    if (timeSpan.textContent.includes('min') && !timeSpan.dataset.originalTime) {
                                        timeSpan.dataset.originalTime = parseInt(timeSpan.textContent) || 30;
                                    }
                                    if (timeSpan.dataset.originalTime) {
                                        var baseTime = parseInt(timeSpan.dataset.originalTime);
                                        timeSpan.textContent = (baseTime + delay) + ' min';
                                    }
                                }
                            });
                        }
                    }
                })
                .catch(function(err) {
                    console.warn('Weather fetch failed:', err);
                    var cityEl = document.getElementById('weatherCity');
                    var descEl = document.getElementById('weatherDesc');
                    var suggEl = document.getElementById('weatherSuggestion');
                    if (cityEl) cityEl.textContent = 'Bengaluru Weather';
                    if (descEl) descEl.textContent = 'Could not load weather data';
                    if (suggEl) suggEl.textContent = 'Order something delicious anyway! 🍕';
                });
        }

        // Try geolocation, fallback to Bengaluru
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
                function(pos) {
                    fetchWeather(pos.coords.latitude, pos.coords.longitude, 'Your Location');
                },
                function() {
                    // Fallback to Bengaluru
                    fetchWeather(12.9716, 77.5946, 'Bengaluru');
                },
                { timeout: 5000, enableHighAccuracy: false }
            );
        } else {
            fetchWeather(12.9716, 77.5946, 'Bengaluru');
        }
    }

    // -------------------------------------------------------
    // TOAST NOTIFICATION SYSTEM
    // -------------------------------------------------------
    window.showToast = function(message, type) {
        type = type || 'info';
        var container = document.getElementById('toastContainer');
        if (!container) return;
        var icons = { success: '✅', error: '❌', info: 'ℹ️' };
        var toast = document.createElement('div');
        toast.className = 'toast toast-' + type;
        toast.innerHTML = '<span class="toast-icon">' + (icons[type] || 'ℹ️') + '</span><span>' + message + '</span>';
        container.appendChild(toast);
        // Trigger animation
        requestAnimationFrame(function() {
            toast.classList.add('toast-show');
        });
        setTimeout(function() {
            toast.classList.remove('toast-show');
            toast.classList.add('toast-hide');
            setTimeout(function() { toast.remove(); }, 300);
        }, 3500);
    };

    // -------------------------------------------------------
    // FAQ ACCORDION (Help Center page)
    // -------------------------------------------------------
    document.querySelectorAll('.faq-question').forEach(function(q) {
        q.addEventListener('click', function() {
            var item = q.closest('.faq-item');
            var wasOpen = item.classList.contains('open');
            // Close all others
            document.querySelectorAll('.faq-item.open').forEach(function(openItem) {
                openItem.classList.remove('open');
            });
            // Toggle current
            if (!wasOpen) {
                item.classList.add('open');
            }
        });
    });

    // -------------------------------------------------------
    // FAQ SEARCH FILTER (Help Center page)
    // -------------------------------------------------------
    var helpSearchInput = document.getElementById('helpSearchInput');
    if (helpSearchInput) {
        helpSearchInput.addEventListener('input', function() {
            var query = this.value.toLowerCase().trim();
            document.querySelectorAll('.faq-item').forEach(function(item) {
                var text = item.textContent.toLowerCase();
                item.style.display = text.includes(query) ? '' : 'none';
            });
        });
    }

})();
