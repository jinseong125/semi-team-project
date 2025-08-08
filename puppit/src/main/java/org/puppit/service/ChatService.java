package org.puppit.service;

import java.util.List;

import org.puppit.model.dto.ChatListDTO;
import org.puppit.model.dto.ChatMessageDTO;
import org.puppit.model.dto.ChatMessageSelectDTO;

public interface ChatService {
	public List<ChatListDTO> getChatRooms(String userId);
	public List<ChatMessageDTO> getChatMessageList(ChatMessageSelectDTO chatMessageSelectDTO);
}
