package org.puppit.service;

import java.util.List;
import java.util.Map;

import org.puppit.model.dto.ChatListDTO;
import org.puppit.model.dto.ChatMessageDTO;
import org.puppit.model.dto.ChatMessageSelectDTO;

public interface ChatService {
	public List<ChatListDTO> getChatRooms(String userId);
	public List<Map<String, Object>> getChatMessageList(ChatMessageSelectDTO chatMessageSelectDTO);
}
