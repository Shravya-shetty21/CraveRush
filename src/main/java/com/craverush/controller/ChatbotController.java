package com.craverush.controller;

import com.craverush.constants.AppConstants;
import com.craverush.entity.User;
import com.craverush.service.ChatbotService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/api/chatbot")
public class ChatbotController {

    @Autowired
    private ChatbotService chatbotService;

    @PostMapping
    @ResponseBody
    public ResponseEntity<Map<String, Object>> chat(@RequestBody Map<String, String> body, HttpSession session) {
        User user = (User) session.getAttribute(AppConstants.SESSION_USER);
        String message = body.get("message");
        
        Map<String, Object> response = new HashMap<>();
        if (message == null || message.trim().isEmpty()) {
            response.put("error", "Message cannot be empty.");
            return ResponseEntity.badRequest().body(response);
        }

        String sessionId = session.getId();
        String botResponse = chatbotService.processMessage(user, message, sessionId);
        
        response.put("success", true);
        response.put("response", botResponse);

        return ResponseEntity.ok(response);
    }
}
