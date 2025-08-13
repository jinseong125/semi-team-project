package org.puppit.service;

import java.sql.Timestamp;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.puppit.model.dto.ChatListDTO;
import org.puppit.model.dto.ChatMessageDTO;
import org.puppit.model.dto.ChatMessageProductDTO;
import org.puppit.model.dto.ChatMessageSearchDTO;
import org.puppit.model.dto.ChatMessageSelectDTO;
import org.puppit.model.dto.ChatRoomPeopleDTO;

import org.puppit.model.dto.ChatMessageDTO;
import org.puppit.model.dto.ChatMessageProductDTO;
import org.puppit.model.dto.ChatMessageSelectDTO;

import org.puppit.repository.ChatDAO;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Transactional
@Service
public class ChatServiceImpl implements ChatService{

	private final ChatDAO chatDAO;
	
	@Override
	public List<ChatListDTO> getChatRooms(String accountId) {
		return chatDAO.getChatList(accountId);
	}

	@Override
	public List<ChatMessageDTO> getChatMessageList(ChatMessageSelectDTO chatMessageSelectDTO) {
		List<Map<String, Object>> messageList = chatDAO.getChatMessageList(chatMessageSelectDTO);
		List<ChatMessageDTO> dtoList = messageList.stream().map(message -> {
			ChatMessageDTO dto = new ChatMessageDTO();
			dto.setMessageId(String.valueOf(message.get("message_id")));
			dto.setChatRoomId(String.valueOf(message.get("chat_room_id")) );
			dto.setProductId(String.valueOf(message.get("product_id")));
		    dto.setChatSender(String.valueOf(message.get("chat_sender")));
		    dto.setChatSenderAccountId(String.valueOf(message.get("sender_account_id")));
	        dto.setChatSenderUserName(String.valueOf(message.get("sender_user_name")));
	        dto.setChatReceiver(String.valueOf(message.get("chat_receiver")));
	        dto.setChatReceiverAccountId(String.valueOf(message.get("receiver_account_id")));
	        dto.setChatReceiverUserName(String.valueOf(message.get("receiver_user_name")));
	        dto.setChatMessage(String.valueOf(message.get("chat_message")));
	        dto.setBuyerId(String.valueOf(message.get("buyer_id")));
	        // chat_created_at은 Timestamp로 캐스팅 필요
	        Object createdAt = message.get("chat_created_at");
	        if (createdAt instanceof Timestamp) {
	            dto.setChatCreatedAt((Timestamp) createdAt);
	        } else if (createdAt != null) {
	            // 만약 DB에서 Long 타입(밀리초)로 오면 변환
	            try {
	                dto.setChatCreatedAt(new Timestamp(Long.parseLong(String.valueOf(createdAt))));
	            } catch (Exception e) {
	                // 파싱 실패 시 null
	                dto.setChatCreatedAt(null);
	            }
	        }
	        dto.setSenderRole(String.valueOf(message.get("sender_role")));
	        dto.setReceiverRole(String.valueOf(message.get("receiver_role")));
			return dto;
		}).collect(Collectors.toList());
		
		return dtoList;
	}

	@Override
	public ChatMessageProductDTO getProduct(Integer productId) {
		return chatDAO.getProduct(productId);
	}

	@Override
	public Integer saveChatMessage(ChatMessageDTO chatMessageDTO) {
		return chatDAO.insertChatMessage(chatMessageDTO);
	}

	@Override
	public List<ChatMessageDTO> getChatMessageList(ChatMessageSelectDTO  chatMessageSelectDTO) {
		List<Map<String, Object>> messageList = chatDAO.getChatMessageList(chatMessageSelectDTO);
		List<ChatMessageDTO> dtoList = messageList.stream().map(message -> {
			ChatMessageDTO dto = new ChatMessageDTO();
			dto.setMessageId(String.valueOf(message.get("message_id")));
			dto.setChatRoomId(String.valueOf(message.get("chat_room_id")) );
			dto.setProductId(String.valueOf(message.get("product_id")));
			dto.setChatSender(Integer.parseInt(String.valueOf(message.get("chat_sender"))));
		    dto.setChatSenderAccountId(String.valueOf(message.get("sender_account_id")));
	        dto.setChatSenderUserName(String.valueOf(message.get("sender_user_name")));
	        dto.setChatReceiver(Integer.parseInt(String.valueOf(message.get("chat_receiver"))));
	        dto.setChatReceiverAccountId(String.valueOf(message.get("receiver_account_id")));
	        dto.setChatReceiverUserName(String.valueOf(message.get("receiver_user_name")));
	        dto.setChatMessage(String.valueOf(message.get("chat_message")));
	        //dto.setBuyerId(String.valueOf(message.get("buyer_id")));
	        // chat_created_at은 Timestamp로 캐스팅 필요
	        
	        Object createdAt = message.get("chat_created_at");
	        if (createdAt instanceof Timestamp) {
	            dto.setChatCreatedAt((Timestamp) createdAt); // 정상 동작
	        }
	        dto.setSenderRole(String.valueOf(message.get("sender_role")));
	        dto.setReceiverRole(String.valueOf(message.get("receiver_role")));
			return dto;
		}).collect(Collectors.toList());
		
		return dtoList;
	}

	@Override
	public ChatMessageProductDTO getProduct(Integer productId) {
		return chatDAO.getProduct(productId);
	}

	@Override
	public Integer saveChatMessage(ChatMessageDTO chatMessageDTO) {
		return chatDAO.insertChatMessage(chatMessageDTO);
	}

	@Override
	public List<ChatRoomPeopleDTO> getUserRoleANDAboutChatMessagePeople(ChatMessageSearchDTO chatMessageSearchDTO) {
		return chatDAO.getUserRoleANDAboutChatMessagePeople(chatMessageSearchDTO);
	}

}
