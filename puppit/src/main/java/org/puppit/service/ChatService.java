package org.puppit.service;

import java.util.List;

import org.puppit.model.dto.ChatListDTO;

public interface ChatService {
	public List<ChatListDTO> getChatRooms(String userId);
}
