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
                        <input type="password" id="password" name="password" class="form-input"
                               placeholder="Create a password (min 6 chars)" required minlength="6">
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword" class="form-label">Confirm Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-input"
                               placeholder="Confirm your password" required minlength="6">
                    </div>
                    <button type="submit" class="btn btn-primary btn-block" id="registerBtn">Create Account</button>
                </form>

                <div class="auth-footer">
                    <p>Already have an account? <a href="${pageContext.request.contextPath}/login" class="auth-link">Login</a></p>
                </div>
            </div>
        </div>
    </section>

<jsp:include page="/jsp/common/footer.jsp"/>
