package org.puppit.service;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.puppit.model.dto.ChatListDTO;
import org.puppit.model.dto.ChatMessageDTO;
import org.puppit.model.dto.ChatMessageProductDTO;
import org.puppit.model.dto.ChatMessageSearchDTO;
import org.puppit.model.dto.ChatMessageSelectDTO;
import org.puppit.model.dto.ChatRoomPeopleDTO;
import org.puppit.model.dto.ChatUserDTO;
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
	        dto.setBuyerId(String.valueOf(message.get("buyer_id")));
	        dto.setChatSellerAccountId(String.valueOf(message.get("chat_seller_account_id")));

	        // chat_created_at은 Timestamp로 캐스팅 필요	        
	        Object createdAt = message.get("chat_created_at");
	        if (createdAt instanceof Timestamp) {
	            dto.setChatCreatedAt((Timestamp) createdAt); // ���� ����
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

 
	@Override
	public Integer findExistingRoom(int productId, int buyerId, int sellerId) {
	    return chatDAO.selectRoomIdByParticipants(productId, buyerId, sellerId);
	}

	@Override
	public Integer createRoom(int productId, int buyerId, int sellerId) {
	    return chatDAO.insertRoom(productId, buyerId, sellerId);
	}

	@Override
	public List<ChatListDTO> getChatRooms(int userId,  Integer highlightRoomId) {
		 return chatDAO.getChatList(userId, highlightRoomId);
	}

	@Override
	public List<ChatListDTO> getChatRoomsByCreatedDesc(int userId) {
	    return chatDAO.getChatListByCreatedDesc(userId);
	}

	@Override
	public Integer getProductIdByRoomId(int roomId) {
		 return chatDAO.findProductIdByRoomId(roomId);
	}

	@Override
	public ChatMessageProductDTO getProductWithSellerAccountId(Integer productId) {
		return chatDAO.getProductWithSellerAccountId(productId);
	}

	@Override
	public ChatUserDTO getSellerByProductId(Integer productId) {
		// TODO Auto-generated method stub
		return chatDAO.getSellerByProductId(productId);
	}
	
	  // 페이징된 채팅방 목록 조회

	//public List<ChatListDTO> getChatRoomsByCreatedDescPaged(int userId, int offset, int size) {
	//    Map<String, Object> param = new HashMap<>();
	//    param.put("userId", userId);
	//    param.put("offset", offset); // int 값
	//    param.put("size", size);     // int 값
	//    return chatDAO.getChatRoomsByCreatedDescPaged(param);
	//}

}