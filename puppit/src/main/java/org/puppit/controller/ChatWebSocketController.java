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

	    // Sender 정보 조회
	    ChatUserDTO sender = userService.getUserByUserId(chatMessageDTO.getChatSenderAccountId());
	    if (sender == null) {
	        System.out.println("Sender 정보를 찾을 수 없습니다. 메시지 처리 중단.");
	        return;
	    }

	    // ChatRoomId 확인 및 파싱
	    Integer chatRoomId = null;
	    try {
	        chatRoomId = chatMessageDTO.getChatRoomId() != null ? Integer.parseInt(chatMessageDTO.getChatRoomId()) : null;
	    } catch (NumberFormatException e) {
	        System.out.println("chatRoomId가 유효하지 않습니다: " + chatMessageDTO.getChatRoomId());
	        return;
	    }

	    // ChatRoomPeople 정보 조회
	    ChatMessageSearchDTO messageSearchDTO = new ChatMessageSearchDTO(sender.getUserId(), chatRoomId);
	    List<ChatRoomPeopleDTO> chatRoomPeoples = chatService.getUserRoleANDAboutChatMessagePeople(messageSearchDTO);

	    if (chatRoomPeoples == null || chatRoomPeoples.isEmpty()) {
	        System.out.println("chatRoomPeoples가 비어 있습니다. 메시지 처리 중단.");
	        return;
	    }

	    System.out.println("chatRoomPeoples 리스트: " + chatRoomPeoples.toString());

	    // 가장 최근 메시지 찾기 또는 기본값 설정
	    ChatRoomPeopleDTO latest = null;
	    for (int i = chatRoomPeoples.size() - 1; i >= 0; i--) {
	        ChatRoomPeopleDTO msg = chatRoomPeoples.get(i);
	        System.out.println("현재 메시지의 SenderAccountId: " + msg.getSenderAccountId());
	        System.out.println("현재 Sender의 AccountId: " + sender.getAccountId());

	        if (msg.getSenderAccountId().equals(sender.getAccountId())) {
	            latest = msg;
	            System.out.println("latest 메시지 설정: " + latest.toString());
	            break;
	        }
	    }

	    if (latest == null) {
	        System.out.println("latest가 null입니다. 초기 정보를 기반으로 설정합니다.");

	        Integer productId = null;
	        try {
	            productId = chatMessageDTO.getProductId() != null ? Integer.parseInt(chatMessageDTO.getProductId()) : null;
	        } catch (NumberFormatException e) {
	            System.out.println("productId가 유효하지 않습니다: " + chatMessageDTO.getProductId());
	        }

	        if (productId == null) {
	            System.out.println("productId가 없습니다. 채팅방 ID로 조회합니다.");
	            productId = chatService.getProductIdByRoomId(chatRoomId);
	        }

	        ChatUserDTO receiver = chatService.getSellerByProductId(productId);
	        if (receiver == null) {
	            System.out.println("Receiver 정보를 찾을 수 없습니다. 메시지 처리 중단.");
	            return;
	        }

	        latest = new ChatRoomPeopleDTO();
	        latest.setSenderRole("BUYER");
	        latest.setReceiverAccountId(receiver.getAccountId());
	        latest.setReceiverUserName(receiver.getUserName());
	        latest.setReceiverRole("SELLER");
	        latest.setProductId(productId);
	    }

	    // Receiver 정보 조회
	    String receiverAccountId = latest.getReceiverAccountId();
	    ChatUserDTO receiverInfo = userService.getUserByUserId(receiverAccountId);
	    if (receiverInfo == null) {
	        System.out.println("Receiver 정보를 찾을 수 없습니다. 메시지 처리 중단.");
	        return;
	    }

	    // chatMessageDTO에 정보 설정
	    chatMessageDTO.setChatSenderAccountId(sender.getAccountId());
	    chatMessageDTO.setChatSenderUserName(sender.getUserName());
	    chatMessageDTO.setSenderRole(latest.getSenderRole());
	    chatMessageDTO.setChatReceiverAccountId(receiverInfo.getAccountId());
	    chatMessageDTO.setChatReceiverUserName(receiverInfo.getUserName());
	    chatMessageDTO.setReceiverRole(latest.getReceiverRole());
	    chatMessageDTO.setProductId(latest.getProductId() != null ? latest.getProductId().toString() : chatMessageDTO.getProductId());
	    chatMessageDTO.setBuyerId(latest.getBuyerId() != null ? latest.getBuyerId().toString() : chatMessageDTO.getBuyerId());

	    // Sender ID 설정
	    chatMessageDTO.setChatSender(sender.getUserId());

	    // Receiver ID 설정
	    chatMessageDTO.setChatReceiver(receiverInfo.getUserId());

	    // 메시지 저장
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