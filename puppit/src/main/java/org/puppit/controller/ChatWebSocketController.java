package org.puppit.controller;

import org.puppit.model.dto.ChatMessageDTO;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Controller
public class ChatWebSocketController {
	
	private final SimpMessagingTemplate messagingTemplate;
	
	 // 클라이언트가 /app/chat.send로 메시지 전송
    @MessageMapping("/chat.send")
    public void sendMessage(@Payload ChatMessageDTO chatMessageDTO,
                            SimpMessageHeaderAccessor headerAccessor) {
        // 예: roomId가 5이면 /topic/chat/3 구독자 모두에게 전송
        String destination = "/topic/chat/" + chatMessageDTO.getChatRoomId();
        messagingTemplate.convertAndSend(destination, chatMessageDTO);
    }
	
	
}
