<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="Login"/></jsp:include>

    <section class="auth-section" id="loginSection">
        <div class="auth-container">
            <div class="auth-card">
                <div class="auth-header">
                    <h1 class="auth-title">Welcome back!</h1>
                    <p class="auth-subtitle">Login to continue ordering delicious food</p>
                </div>

                <c:if test="${error != null}">
                    <div class="alert alert-error" id="loginError">
                        <span class="alert-icon">⚠️</span> <c:out value="${error}"/>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/login" method="post" class="auth-form" id="loginForm">
                    <div class="form-group">
                        <label for="email" class="form-label">Email Address</label>
                        <input type="email" id="email" name="email" class="form-input"
                               value="${email}" placeholder="Enter your email" required autocomplete="email">
                    </div>
                    <div class="form-group">
                        <label for="password" class="form-label">Password</label>
                        <div class="password-container">
                            <input type="password" id="password" name="password" class="form-input"
                                   placeholder="Enter your password" required>
                            <button type="button" class="password-toggle" onclick="togglePasswordVisibility('password', this)" id="togglePass" aria-label="Toggle password visibility">👁️</button>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary btn-block" id="loginBtn">Login</button>
                </form>

                <div class="auth-footer">
                    <p>Don't have an account? <a href="${pageContext.request.contextPath}/register" class="auth-link">Sign up</a></p>
                    <p class="auth-admin-link"><a href="${pageContext.request.contextPath}/admin/login">Admin Login →</a></p>
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
    </script>
<jsp:include page="/jsp/common/footer.jsp"/>
