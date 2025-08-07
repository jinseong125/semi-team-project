package org.puppit.service;

import java.util.List;

import org.puppit.model.dto.ChatListDTO;
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

}
