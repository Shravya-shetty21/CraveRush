<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="Sign Up"/></jsp:include>

    <section class="auth-section" id="registerSection">
        <div class="auth-container">
            <div class="auth-card">
                <div class="auth-header">
                    <h1 class="auth-title">Create Account</h1>
                    <p class="auth-subtitle">Join CraveRush and start ordering</p>
                </div>

                <c:if test="${error != null}">
                    <div class="alert alert-error" id="registerError">
                        <span class="alert-icon">⚠️</span> <c:out value="${error}"/>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/register" method="post" class="auth-form" id="registerForm">
                    <div class="form-group">
                        <label for="fullName" class="form-label">Full Name</label>
                        <input type="text" id="fullName" name="fullName" class="form-input"
                               value="${fullName}" placeholder="Enter your full name" required>
                    </div>
                    <div class="form-group">
                        <label for="email" class="form-label">Email Address</label>
                        <input type="email" id="email" name="email" class="form-input"
                               placeholder="Enter your email" required autocomplete="email">
                    </div>
                    <div class="form-group">
                        <label for="phone" class="form-label">Phone Number</label>
                        <input type="tel" id="phone" name="phone" class="form-input"
                               value="${phone}" placeholder="Enter your phone number" required pattern="[0-9]{10}">
                    </div>
                    <div class="form-group">
                        <label for="password" class="form-label">Password</label>
                        <div class="password-container">
                            <input type="password" id="password" name="password" class="form-input"
                                   placeholder="Create a password" required>
                            <button type="button" class="password-toggle" onclick="togglePasswordVisibility('password', this)" id="togglePass" aria-label="Toggle password visibility">👁️</button>
                        </div>
                        <div class="password-error" id="passwordError" style="display: none; color: var(--red); font-size: 0.82rem; margin-top: 6px; font-weight: 500;">
                            Must be 6+ chars containing a letter, number, and special character.
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword" class="form-label">Confirm Password</label>
                        <div class="password-container">
                            <input type="password" id="confirmPassword" name="confirmPassword" class="form-input"
                                   placeholder="Confirm your password" required>
                            <button type="button" class="password-toggle" onclick="togglePasswordVisibility('confirmPassword', this)" id="toggleConfirmPass" aria-label="Toggle confirm password visibility">👁️</button>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary btn-block" id="registerBtn">Create Account</button>
                </form>

                <div class="auth-footer">
                    <p>Already have an account? <a href="${pageContext.request.contextPath}/login" class="auth-link">Login</a></p>
                </div>
            </div>
        </div>
    </section>

    <script>
        function togglePasswordVisibility(inputId, btn) {
            const input = document.getElementById(inputId);
            if (input.type === 'password') {
                input.type = 'text';
                btn.textContent = '🙈';
            } else {
                input.type = 'password';
                btn.textContent = '👁️';
            }
        }

        document.addEventListener("DOMContentLoaded", function() {
            const passwordInput = document.getElementById("password");
            const confirmInput = document.getElementById("confirmPassword");
            const form = document.getElementById("registerForm");

            // Requirements elements
            const reqs = {
                length: { el: document.getElementById("req-length"), icon: document.getElementById("icon-length"), test: val => val.length >= 6 },
                letter: { el: document.getElementById("req-letter"), icon: document.getElementById("icon-letter"), test: val => /[a-zA-Z]/.test(val) },
                number: { el: document.getElementById("req-number"), icon: document.getElementById("icon-number"), test: val => /[0-9]/.test(val) },
                special: { el: document.getElementById("req-special"), icon: document.getElementById("icon-special"), test: val => /[!@#$%^&*(),.?":{}|<>_]/.test(val) }
            };

            const passwordError = document.getElementById("passwordError");

            function validatePassword() {
                const val = passwordInput.value;
                if (val.length === 0) {
                    passwordError.style.display = "none";
                    passwordInput.style.borderColor = "";
                    return false;
                }

                let allValid = true;
                for (const key in reqs) {
                    if (!reqs[key].test(val)) {
                        allValid = false;
                        break;
                    }
                }

                if (allValid) {
                    passwordError.style.display = "none";
                    passwordInput.style.borderColor = "var(--green)";
                } else {
                    passwordError.style.display = "block";
                    passwordInput.style.borderColor = "var(--red)";
                }

                return allValid;
            }

            passwordInput.addEventListener("input", validatePassword);
            passwordInput.addEventListener("blur", () => {
                if (passwordInput.value.length === 0) {
                    passwordError.style.display = "none";
                    passwordInput.style.borderColor = "";
                }
            });

            form.addEventListener("submit", function(e) {
                const isPassValid = validatePassword();
                
                // Clear existing custom alert if any
                const existingAlert = document.getElementById("jsRegisterError");
                if (existingAlert) {
                    existingAlert.remove();
                }

                if (!isPassValid) {
                    e.preventDefault();
                    showErrorAlert("Password does not meet all strength requirements.");
                    return false;
                }

                if (passwordInput.value !== confirmInput.value) {
                    e.preventDefault();
                    showErrorAlert("Passwords do not match.");
                    return false;
                }
            });

            function showErrorAlert(message) {
                const card = document.querySelector(".auth-card");
                const header = document.querySelector(".auth-header");
                
                const alertDiv = document.createElement("div");
                alertDiv.className = "alert alert-error";
                alertDiv.id = "jsRegisterError";
                alertDiv.innerHTML = '<span class="alert-icon">⚠️</span> ' + message;
                
                // Insert alert after header
                header.parentNode.insertBefore(alertDiv, header.nextSibling);
                
                // Scroll to alert
                alertDiv.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
        });
    </script>
<jsp:include page="/jsp/common/footer.jsp"/>
