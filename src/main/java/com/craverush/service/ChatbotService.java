package com.craverush.service;

import com.craverush.entity.ChatbotLog;
import com.craverush.entity.Order;
import com.craverush.entity.User;
import com.craverush.entity.FoodItem;
import com.craverush.repository.ChatbotLogRepository;
import com.craverush.repository.OrderRepository;
import com.craverush.repository.FoodItemRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class ChatbotService {

    @Autowired
    private ChatbotLogRepository chatbotLogRepository;

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private FoodItemRepository foodItemRepository;

    public String processMessage(User user, String message, String sessionId) {
        String msg = message.toLowerCase().trim();
        String response;

        // --- ORDER TRACKING ---
        if (containsAny(msg, "track", "order status", "where is my order", "order update", "delivery status")) {
            response = handleOrderTracking(user);
        }
        // --- ORDER HISTORY ---
        else if (containsAny(msg, "order history", "past order", "previous order", "my orders", "all orders")) {
            response = handleOrderHistory(user);
        }
        // --- CANCEL ORDER ---
        else if (containsAny(msg, "cancel order", "cancel my order", "want to cancel", "cancellation")) {
            response = "You can cancel your order within **60 seconds** of placing it from the order details page.\n\n" +
                       "After the restaurant accepts, cancellations are **not possible**.\n\n" +
                       "For special cases, contact our support at **1800-CRAVE-RUSH** (Mon-Sun, 8 AM - 11 PM).";
        }
        // --- FOOD RECOMMENDATIONS ---
        else if (containsAny(msg, "recommend", "suggest", "what should i eat", "hungry", "food suggestion", "best food")) {
            response = handleFoodRecommendation();
        }
        // --- PAYMENT METHODS ---
        else if (containsAny(msg, "payment", "pay", "card", "upi", "wallet", "cod", "cash on delivery", "net banking", "how to pay")) {
            response = "We support a wide range of **payment methods**:\n\n" +
                       "💳 **Cards**: Visa, Mastercard, RuPay, Amex\n" +
                       "📱 **UPI**: Google Pay, PhonePe, Paytm, BHIM\n" +
                       "🏦 **Net Banking**: All major banks\n" +
                       "💵 **Cash on Delivery (COD)**\n" +
                       "🎫 **Wallets**: Paytm, Amazon Pay, Freecharge\n\n" +
                       "All transactions are secured with 256-bit encryption. 🔒";
        }
        // --- REFUNDS ---
        else if (containsAny(msg, "refund", "money back", "refund status", "refund policy", "get refund")) {
            response = "**Refund Policy:**\n\n" +
                       "• Refunds are processed within **3-5 business days** to your original payment method.\n" +
                       "• For cancelled orders, refund is initiated immediately.\n" +
                       "• For quality issues, contact support with photos of the food.\n" +
                       "• COD orders receive refund as CraveRush credits.\n\n" +
                       "Track your refund status in **My Orders → Order Details**.";
        }
        // --- COUPONS & OFFERS ---
        else if (containsAny(msg, "offer", "coupon", "discount", "promo", "deal", "code", "cashback")) {
            response = "🎉 **Active Offers:**\n\n" +
                       "• **CRAVE50** — 50% OFF up to ₹100 on all orders\n" +
                       "• **FREE50** — Flat ₹50 off on orders above ₹199\n" +
                       "• **HDFC10** — 10% off with HDFC Credit Cards (up to ₹150)\n\n" +
                       "Apply coupon codes at checkout! Visit our **Offers** page for more deals.";
        }
        // --- DELIVERY FEES ---
        else if (containsAny(msg, "fee", "charge", "delivery fee", "delivery charge", "platform fee", "gst", "tax", "extra charge")) {
            response = "**Breakdown of Charges:**\n\n" +
                       "🛵 **Delivery Fee**: ₹40 (flat rate)\n" +
                       "📱 **Platform Fee**: ₹5\n" +
                       "📋 **GST**: 5% of food subtotal\n\n" +
                       "💡 **Tip**: Use promo code **FREE50** for a flat ₹50 discount to offset these charges!";
        }
        // --- DELIVERY TIME ---
        else if (containsAny(msg, "delivery time", "how long", "when will", "estimated time", "eta", "time to deliver")) {
            response = "⏱️ **Estimated Delivery Times:**\n\n" +
                       "• Most orders: **25-35 minutes**\n" +
                       "• During peak hours: **35-45 minutes**\n" +
                       "• Far locations: **40-50 minutes**\n\n" +
                       "Real-time tracking is available on your order details page! 🗺️";
        }
        // --- ACCOUNT / PROFILE ---
        else if (containsAny(msg, "account", "profile", "edit profile", "change name", "change email", "change phone", "update profile", "delete account")) {
            response = "**Account Management:**\n\n" +
                       "👤 **Edit Profile**: Update your name, email, and phone from the user menu.\n" +
                       "🔐 **Change Password**: Go to Profile → Change Password.\n" +
                       "🗑️ **Delete Account**: Contact support at **support@craverush.com** with your registered email.\n\n" +
                       "Need help? Our team responds within 2 hours.";
        }
        // --- ADDRESS ---
        else if (containsAny(msg, "address", "add address", "change address", "delivery address", "location", "area")) {
            response = "📍 **Delivery Addresses:**\n\n" +
                       "We currently serve **20 major areas in Bengaluru** including Koramangala, Indiranagar, HSR Layout, BTM Layout, Whitefield, and more!\n\n" +
                       "Your delivery address is entered at checkout. Make sure your location pin is accurate for the fastest delivery! 🎯";
        }
        // --- RESTAURANT INFO ---
        else if (containsAny(msg, "restaurant info", "restaurant hours", "restaurant open", "menu", "restaurant menu", "what restaurants")) {
            response = "🍽️ **Restaurant Information:**\n\n" +
                       "• We partner with **40+ restaurants** across Bengaluru.\n" +
                       "• Restaurant hours: Most are open **8 AM - 11 PM**.\n" +
                       "• Browse all restaurants and their menus on our **Restaurants** page.\n" +
                       "• Filter by cuisine, rating, delivery time, and veg/non-veg options.";
        }
        // --- VEG / NON-VEG ---
        else if (containsAny(msg, "veg ", "vegetarian", "non-veg", "non veg", "pure veg", "veg food")) {
            response = "🥗 **Dietary Options:**\n\n" +
                       "• Use the **Pure Veg** filter on the restaurants page.\n" +
                       "• Green dot 🟢 = Vegetarian\n" +
                       "• Red dot 🔴 = Non-Vegetarian\n" +
                       "• Every menu item is clearly marked!\n\n" +
                       "We have dedicated pure-veg restaurants like **MTR**, **Vidyarthi Bhavan**, and **CTR**.";
        }
        // --- RATING / REVIEW ---
        else if (containsAny(msg, "rate", "review", "rating", "feedback", "complaint", "complain")) {
            response = "⭐ **Ratings & Reviews:**\n\n" +
                       "• Rate your order from the **Order Details** page after delivery.\n" +
                       "• Leave a review to help other users make better choices.\n" +
                       "• For complaints, contact us at **support@craverush.com** or call **1800-CRAVE-RUSH**.\n\n" +
                       "Your feedback helps us improve! 🙏";
        }
        // --- PARTNER / DRIVER ---
        else if (containsAny(msg, "partner", "driver", "delivery partner", "delivery boy", "rider", "ride with us", "join")) {
            response = "🤝 **Partner With CraveRush:**\n\n" +
                       "**Restaurant Owners**: Register your restaurant on our platform and reach thousands of hungry customers!\n\n" +
                       "**Delivery Partners**: Join our rider fleet and earn great income with flexible hours.\n\n" +
                       "📧 Email: **partners@craverush.com**\n📞 Call: **1800-CRAVE-RUSH**";
        }
        // --- ABOUT CRAVERUSH ---
        else if (containsAny(msg, "about", "who are you", "what is craverush", "company", "about craverush")) {
            response = "🚀 **About CraveRush:**\n\n" +
                       "CraveRush is Bengaluru's premium food delivery platform, connecting you with 500+ top-rated restaurants.\n\n" +
                       "**Our Promise:**\n" +
                       "⚡ Lightning-fast delivery (avg 30 min)\n" +
                       "🍽️ Curated restaurant selection\n" +
                       "💰 Best prices & exclusive deals\n" +
                       "🤖 AI-powered assistance\n\n" +
                       "Founded in 2024, made with ❤️ in India.";
        }
        // --- CONTACT / SUPPORT ---
        else if (containsAny(msg, "contact", "support", "help", "customer care", "customer service", "call", "phone number", "email")) {
            response = "📞 **Contact CraveRush Support:**\n\n" +
                       "📧 **Email**: support@craverush.com\n" +
                       "📞 **Phone**: 1800-CRAVE-RUSH (toll-free)\n" +
                       "⏰ **Hours**: Mon - Sun, 8 AM - 11 PM\n" +
                       "💬 **Live Chat**: You're already here! Ask me anything.\n\n" +
                       "Average response time: **< 2 hours** for emails.";
        }
        // --- APP / TECHNICAL ---
        else if (containsAny(msg, "app", "website", "bug", "error", "not working", "issue", "problem", "crash", "slow", "loading")) {
            response = "🔧 **Technical Support:**\n\n" +
                       "Try these steps:\n" +
                       "1. Clear your browser cache and cookies\n" +
                       "2. Refresh the page (Ctrl+F5)\n" +
                       "3. Try a different browser\n" +
                       "4. Check your internet connection\n\n" +
                       "Still facing issues? Email **tech@craverush.com** with a screenshot.";
        }
        // --- GREETINGS ---
        else if (containsAny(msg, "hello", "hi", "hey", "good morning", "good evening", "good afternoon", "namaste", "hola")) {
            response = "👋 Hello! Welcome to CraveRush!\n\n" +
                       "I can help you with:\n" +
                       "• 📋 **Track your order**\n" +
                       "• 🍕 **Food recommendations**\n" +
                       "• 🏷️ **Offers & coupons**\n" +
                       "• 💳 **Payment info**\n" +
                       "• 📞 **Contact support**\n\n" +
                       "What would you like to know?";
        }
        // --- THANK YOU ---
        else if (containsAny(msg, "thank", "thanks", "thx", "ty", "appreciated")) {
            response = "You're welcome! 😊 Glad I could help.\n\nIs there anything else you'd like to know? I'm always here!";
        }
        // --- BYE ---
        else if (containsAny(msg, "bye", "goodbye", "see you", "later", "exit", "quit")) {
            response = "👋 Goodbye! Have a wonderful meal! Order anytime — CraveRush is always ready.\n\nCome back whenever you need help! 😊";
        }
        // --- FALLBACK ---
        else {
            response = "I'm not sure I understood that. Here are some things I can help with:\n\n" +
                       "• 📋 **\"Track my order\"** — Check order status\n" +
                       "• 🍕 **\"Recommend food\"** — Get food suggestions\n" +
                       "• 🏷️ **\"Show offers\"** — View active coupons\n" +
                       "• 💳 **\"Payment methods\"** — How to pay\n" +
                       "• 📞 **\"Contact support\"** — Get help\n" +
                       "• ❓ **\"Help\"** — General assistance\n\n" +
                       "Try asking me one of these!";
        }

        // Save chat log
        ChatbotLog log = new ChatbotLog(user, message, response, sessionId);
        chatbotLogRepository.save(log);

        return response;
    }

    private String handleOrderTracking(User user) {
        if (user == null) {
            return "Please **log in** to check your order status. You can log in from the top-right corner of the page.";
        }
        List<Order> orders = orderRepository.findByUserOrderByOrderDateDesc(user);
        if (orders.isEmpty()) {
            return "You haven't placed any orders yet! 🍽️\n\nBrowse our **Restaurants** page to find something delicious.";
        }
        Order latest = orders.get(0);
        String status = latest.getOrderStatus();
        StringBuilder sb = new StringBuilder();
        sb.append("📦 **Order #").append(latest.getOrderId()).append("** from **").append(latest.getRestaurantName()).append("**\n\n");
        sb.append("Status: **").append(formatStatus(status)).append("**\n");

        if ("DELIVERED".equalsIgnoreCase(status)) {
            sb.append("\n✅ Your order was delivered successfully!");
            if (latest.getDeliveredAt() != null) {
                sb.append("\nDelivered at: ").append(latest.getDeliveredAt());
            }
            sb.append("\n\nHope you enjoyed your meal! Don't forget to rate it. ⭐");
        } else if ("OUT_FOR_DELIVERY".equalsIgnoreCase(status)) {
            sb.append("\n🛵 Your rider is on the way! Track live from the **Order Details** page.");
        } else if ("PREPARING".equalsIgnoreCase(status)) {
            sb.append("\n👨‍🍳 The restaurant is preparing your food. Sit tight!");
        } else if ("CONFIRMED".equalsIgnoreCase(status)) {
            sb.append("\n✅ Restaurant has confirmed your order. Preparation will begin shortly.");
        } else if ("PLACED".equalsIgnoreCase(status)) {
            sb.append("\n⏳ Waiting for restaurant confirmation...");
        } else if ("CANCELLED".equalsIgnoreCase(status)) {
            sb.append("\n❌ This order was cancelled. Any refund will be processed within 3-5 business days.");
        }

        return sb.toString();
    }

    private String handleOrderHistory(User user) {
        if (user == null) {
            return "Please **log in** to view your order history.";
        }
        List<Order> orders = orderRepository.findByUserOrderByOrderDateDesc(user);
        if (orders.isEmpty()) {
            return "You haven't placed any orders yet. Start exploring restaurants to place your first order! 🎉";
        }
        int total = orders.size();
        StringBuilder sb = new StringBuilder();
        sb.append("📋 You have **").append(total).append(" order(s)** in total.\n\n");
        sb.append("**Recent Orders:**\n");
        int limit = Math.min(3, total);
        for (int i = 0; i < limit; i++) {
            Order o = orders.get(i);
            sb.append("• #").append(o.getOrderId()).append(" — ").append(o.getRestaurantName()).append(" — **").append(formatStatus(o.getOrderStatus())).append("**\n");
        }
        if (total > 3) {
            sb.append("\n...and ").append(total - 3).append(" more. View all in **My Orders** page.");
        }
        return sb.toString();
    }

    private String handleFoodRecommendation() {
        List<FoodItem> items = foodItemRepository.findAll();
        if (items.isEmpty()) {
            return "🍕 We recommend trying **Hyderabadi Chicken Biryani**, **Masala Dosa**, or **Classic Margherita Pizza**!";
        }
        List<FoodItem> bestSellers = items.stream()
                .filter(FoodItem::isBestseller)
                .limit(4)
                .collect(Collectors.toList());
        if (bestSellers.isEmpty()) {
            bestSellers = items.stream().limit(4).collect(Collectors.toList());
        }
        StringBuilder sb = new StringBuilder("🔥 **Top Recommendations:**\n\n");
        for (FoodItem i : bestSellers) {
            sb.append("• **").append(i.getName()).append("** from ").append(i.getRestaurant().getName()).append(" — ₹").append(i.getPrice()).append("\n");
        }
        sb.append("\nBrowse all restaurants for more options! 🍽️");
        return sb.toString();
    }

    private String formatStatus(String status) {
        if (status == null) return "Unknown";
        switch (status.toUpperCase()) {
            case "PLACED": return "Order Placed";
            case "CONFIRMED": return "Confirmed";
            case "PREPARING": return "Being Prepared";
            case "OUT_FOR_DELIVERY": return "Out for Delivery";
            case "DELIVERED": return "Delivered";
            case "CANCELLED": return "Cancelled";
            default: return status;
        }
    }

    private boolean containsAny(String text, String... keywords) {
        for (String keyword : keywords) {
            if (text.contains(keyword)) return true;
        }
        return false;
    }

    public List<ChatbotLog> getHistory(String sessionId) {
        return chatbotLogRepository.findBySessionIdOrderByCreatedAtAsc(sessionId);
    }
}
