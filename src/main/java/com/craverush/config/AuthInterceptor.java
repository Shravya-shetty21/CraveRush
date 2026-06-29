package com.craverush.config;

import com.craverush.constants.AppConstants;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class AuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());

        // Normalise path (remove double slashes)
        path = path.replaceAll("//+", "/");

        // Allow static resources
        if (path.startsWith("/css/") || path.startsWith("/js/") || path.startsWith("/images/") || path.startsWith("/uploads/")) {
            return true;
        }

        // Handle Admin routes
        if (path.startsWith("/admin")) {
            if (path.equals("/admin/login")) {
                return true;
            }
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute(AppConstants.SESSION_ADMIN) == null) {
                response.sendRedirect(contextPath + "/admin/login");
                return false;
            }
            return true;
        }

        // Protected User routes
        boolean isProtected = path.equals("/cart") || path.startsWith("/cart/") ||
                              path.equals("/checkout") || path.startsWith("/checkout/") ||
                              path.equals("/orders") || path.startsWith("/order/") ||
                              path.startsWith("/favorite") || path.startsWith("/review");

        if (isProtected) {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute(AppConstants.SESSION_USER) == null) {
                response.sendRedirect(contextPath + "/login");
                return false;
            }
        }

        return true;
    }
}
