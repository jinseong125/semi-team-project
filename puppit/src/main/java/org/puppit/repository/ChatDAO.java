package org.puppit.repository;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.puppit.model.dto.ChatListDTO;
import org.puppit.model.dto.ChatMessageDTO;
import org.puppit.model.dto.ChatMessageSelectDTO;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Transactional
@Repository
public class ChatDAO {
	
	private final SqlSessionTemplate sqlSession;
	
	public List<ChatListDTO> getChatList(String accountId) {
		return sqlSession.selectList("mybatis.mapper.chatMapper.getChatList", accountId);
	}
	
	public List<ChatMessageDTO> getChatMessageList(ChatMessageSelectDTO chatMessageSelectDTO) {
		return sqlSession.selectList("mybatis.mapper.chatMessageMapper.getChatMessageList", chatMessageSelectDTO);
	}
	
}
