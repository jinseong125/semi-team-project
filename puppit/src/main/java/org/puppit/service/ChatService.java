package org.puppit.service;

import java.util.List;
import java.util.Map;

import org.puppit.model.dto.ChatListDTO;
import org.puppit.model.dto.ChatMessageDTO;
import org.puppit.model.dto.ChatMessageProductDTO;

import org.puppit.model.dto.ChatMessageSearchDTO;
import org.puppit.model.dto.ChatMessageSelectDTO;
import org.puppit.model.dto.ChatRoomPeopleDTO;
import org.puppit.model.dto.ChatMessageSelectDTO;

public interface ChatService {
	public List<ChatListDTO> getChatRooms(int userId);
	public List<ChatMessageDTO> getChatMessageList(ChatMessageSelectDTO chatMessageSelectDTO);
	public ChatMessageProductDTO getProduct(Integer productId);
	public Integer saveChatMessage(ChatMessageDTO chatMessageDTO);
}
