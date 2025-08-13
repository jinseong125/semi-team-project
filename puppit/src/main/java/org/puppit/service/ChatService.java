package org.puppit.service;

import java.util.List;
import java.util.Map;

import org.puppit.model.dto.ChatListDTO;
import org.puppit.model.dto.ChatMessageDTO;
import org.puppit.model.dto.ChatMessageProductDTO;
<<<<<<< HEAD
import org.puppit.model.dto.ChatMessageSearchDTO;
=======

import org.puppit.model.dto.ChatMessageSearchDTO;
import org.puppit.model.dto.ChatMessageSelectDTO;
import org.puppit.model.dto.ChatRoomPeopleDTO;
>>>>>>> 7e077768101047d964f53f4feaedf9bcbe3514d3
import org.puppit.model.dto.ChatMessageSelectDTO;
import org.puppit.model.dto.ChatRoomPeopleDTO;

public interface ChatService {
	public List<ChatListDTO> getChatRooms(int userId);
	public List<ChatMessageDTO> getChatMessageList(ChatMessageSelectDTO chatMessageSelectDTO);
	public ChatMessageProductDTO getProduct(Integer productId);
	public Integer saveChatMessage(ChatMessageDTO chatMessageDTO);
<<<<<<< HEAD
	public List<ChatRoomPeopleDTO> getUserRoleANDAboutChatMessagePeople(ChatMessageSearchDTO chatMessageSearchDTO);	
=======
>>>>>>> 7e077768101047d964f53f4feaedf9bcbe3514d3
}
