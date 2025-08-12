package org.puppit.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer{
	
	@Override
	public void configureMessageBroker(MessageBrokerRegistry config) {
		// 클라이언트가 구독하는 경로
        config.enableSimpleBroker("/topic"); // 예) /topic/chat/3
        config.setApplicationDestinationPrefixes("/app"); // 클라이언트가 보낼 때 /app/chat.send
	}

	@Override
	public void registerStompEndpoints(StompEndpointRegistry registry) {
		// ws://localhost:8080/puppit/ws-chat 엔드포인트로 접속
        registry.addEndpoint("/ws-chat")
        .setAllowedOrigins("http://localhost:8080")
        .withSockJS();
	}
	
	
}
