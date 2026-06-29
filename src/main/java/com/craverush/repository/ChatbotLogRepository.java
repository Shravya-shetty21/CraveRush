package com.craverush.repository;

import com.craverush.entity.ChatbotLog;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ChatbotLogRepository extends JpaRepository<ChatbotLog, Long> {
    List<ChatbotLog> findBySessionIdOrderByCreatedAtAsc(String sessionId);
}
