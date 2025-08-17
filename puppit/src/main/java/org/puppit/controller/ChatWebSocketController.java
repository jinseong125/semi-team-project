package org.puppit.controller;


import java.util.List;

import org.puppit.model.dto.ChatMessageDTO;
import org.puppit.model.dto.ChatMessageSearchDTO;
import org.puppit.model.dto.ChatRoomPeopleDTO;
import org.puppit.model.dto.ChatUserDTO;
import org.puppit.service.ChatService;
import org.puppit.service.UserService;

import org.springframework.stereotype.Controller;

import org.puppit.model.dto.ChatMessageDTO;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.SimpMessagingTemplate;

import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Controller;

import lombok.RequiredArgsConstructor;


@RequiredArgsConstructor
@Controller
public class ChatWebSocketController {
	
	private final SimpMessagingTemplate messagingTemplate;
	private final UserService userService;
	private final ChatService chatService;


	
	 // 클라이언트가 /app/chat.send로 메시지 전송

	@MessageMapping("/chat.send")
	public void sendMessage(@Payload ChatMessageDTO chatMessageDTO,
	                        SimpMessageHeaderAccessor headerAccessor) {
		System.out.println("chatMessageDTO: " + chatMessageDTO.toString());

        ChatUserDTO receiver = null;

        // Sender 정보 조회
        ChatUserDTO sender = userService.getUserByUserId(chatMessageDTO.getChatSenderAccountId());
        if (sender == null) {
            System.out.println("Sender 정보를 찾을 수 없습니다. 메시지 처리 중단.");
            return;
        }

        System.out.println("sender: " + sender.toString());

        // ChatRoomId 확인 및 파싱
        Integer chatRoomId = null;
        try {
            chatRoomId = chatMessageDTO.getChatRoomId() != null ? Integer.parseInt(chatMessageDTO.getChatRoomId()) : null;
            System.out.println("chatRoomId: " + chatRoomId);
        } catch (NumberFormatException e) {
            System.out.println("chatRoomId가 유효하지 않습니다: " + chatMessageDTO.getChatRoomId());
            return;
        }

        System.out.println("isFirstChat: " + chatService.isFirstChat(chatRoomId));

        // 메시지 중복 확인
        chatMessageDTO.setChatSender(sender.getUserId());
        if (chatService.isMessageDuplicate(chatMessageDTO)) {
            System.out.println("중복 메시지입니다. 저장하지 않습니다.");
            return;
        }

        // 첫 채팅일 경우 처리
        if (chatService.isFirstChat(chatRoomId)) {
            Integer productId = chatService.getProductIdByRoomId(chatRoomId);
            System.out.println("productId: " + productId);
            receiver = chatService.getSellerByProductId(productId);
            System.out.println("receiver: " + receiver.toString());
            if (receiver == null) {
                System.out.println("Receiver 정보를 찾을 수 없습니다. 메시지 처리 중단.");
                return;
            }

            String senderRole = sender.getUserId().equals(receiver.getUserId()) ? "SELLER" : "BUYER";
            System.out.println("senderRole: " + senderRole);
            String receiverRole = receiver.getUserId().equals(sender.getUserId()) ? "SELLER" : "BUYER";

            chatMessageDTO.setChatSenderAccountId(sender.getAccountId());
            chatMessageDTO.setChatSenderUserName(sender.getUserName());
            chatMessageDTO.setSenderRole(senderRole);

            chatMessageDTO.setChatReceiverAccountId(receiver.getAccountId());
            chatMessageDTO.setChatReceiverUserName(receiver.getUserName());
            chatMessageDTO.setReceiverRole(receiverRole);

            chatMessageDTO.setProductId(productId.toString());

            System.out.println("sender userId: " + sender.getUserId());
            chatMessageDTO.setChatSender(sender.getUserId());
            chatMessageDTO.setChatReceiver(receiver.getUserId());

        } else {
            // 기존 채팅 정보 조회 및 설정
            ChatMessageSearchDTO messageSearchDTO = new ChatMessageSearchDTO(sender.getUserId(), chatRoomId);
            List<ChatRoomPeopleDTO> chatRoomPeoples = chatService.getUserRoleANDAboutChatMessagePeople(messageSearchDTO);
            if (chatRoomPeoples == null || chatRoomPeoples.isEmpty()) {
                System.out.println("chatRoomPeoples가 비어 있습니다.");
                return;
            }
            System.out.println("messageSearchDTO: " + messageSearchDTO.toString());
            System.out.println("chatRoomPeoples: " + chatRoomPeoples.toString());

            ChatRoomPeopleDTO latest = chatRoomPeoples.get(chatRoomPeoples.size() - 1);
            chatMessageDTO.setChatSenderAccountId(sender.getAccountId());
            chatMessageDTO.setChatSenderUserName(sender.getUserName());
            chatMessageDTO.setSenderRole(latest.getSenderRole());
            chatMessageDTO.setChatReceiverAccountId(latest.getReceiverAccountId());
            chatMessageDTO.setChatReceiverUserName(latest.getReceiverUserName());
            chatMessageDTO.setReceiverRole(latest.getReceiverRole());
            chatMessageDTO.setProductId(latest.getProductId().toString());
            System.out.println("sender userId: " + sender.getUserId());
            chatMessageDTO.setChatSender(sender.getUserId());
            chatMessageDTO.setChatReceiver(Integer.parseInt(latest.getChatSender()));
            chatMessageDTO.setChatSenderAccountId(sender.getAccountId());

            System.out.println("chatMessageDTO: " + chatMessageDTO.toString());
        }

        // 메시지 저장 (트랜잭션 처리)
        try {
            Integer insertedRow = chatService.saveChatMessage(chatMessageDTO);
            System.out.println("insertedRow: " + insertedRow);
        } catch (Exception e) {
            System.out.println("채팅 메시지 저장 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
        }

        // 메시지 전송
        String destination = "/topic/chat/" + chatMessageDTO.getChatRoomId();
        messagingTemplate.convertAndSend(destination, chatMessageDTO);
	}
}
	
	
