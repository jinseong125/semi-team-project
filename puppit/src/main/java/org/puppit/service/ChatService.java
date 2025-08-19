package org.puppit.service;

import java.util.List;
import java.util.Map;

import org.puppit.model.dto.ChatListDTO;
import org.puppit.model.dto.ChatMessageDTO;
import org.puppit.model.dto.ChatMessageProductDTO;

import org.puppit.model.dto.ChatMessageSearchDTO;

import org.puppit.model.dto.ChatMessageSelectDTO;
import org.puppit.model.dto.ChatRoomPeopleDTO;
import org.puppit.model.dto.ChatUserDTO;


public interface ChatService {
	public List<ChatListDTO> getChatRooms(int userId, Integer highlightRoomId); // highlightRoomId 인자 삭제!
	public List<ChatMessageDTO> getChatMessageList(ChatMessageSelectDTO chatMessageSelectDTO);
	public ChatMessageProductDTO getProduct(Integer productId);
	public Integer saveChatMessage(ChatMessageDTO chatMessageDTO);

	public List<ChatRoomPeopleDTO> getUserRoleANDAboutChatMessagePeople(ChatMessageSearchDTO chatMessageSearchDTO);	
	public Integer findExistingRoom(int productId, int buyerId, int sellerId);
	public Integer createRoom(int productId, int buyerId, int sellerId);
	public List<ChatListDTO> getChatRoomsByCreatedDesc(int userId);              // 추가
	//public List<ChatListDTO> getChatRoomsByCreatedDescPaged(int userId, int offset, int size);
	public Integer getProductIdByRoomId(int roomId);
	public ChatMessageProductDTO getProductWithSellerAccountId(Integer productId);
	public ChatUserDTO getSellerByProductId(Integer productId);
	public boolean isFirstChat(Integer chatRoomId);
	public boolean isMessageDuplicate(ChatMessageDTO chatMessageDTO);
	public Integer saveAlarmData(Map<String, Object> messageAlarm);
	public ChatUserDTO getReceiverInfoByUserId(Integer chatReceiverAccountId);
	public String getProductNameById(int parseInt);
}

