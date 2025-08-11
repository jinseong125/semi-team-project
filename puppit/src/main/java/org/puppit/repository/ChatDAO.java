package org.puppit.repository;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.puppit.model.dto.ChatListDTO;
import org.puppit.model.dto.ChatMessageDTO;
import org.puppit.model.dto.ChatMessageProductDTO;
import org.puppit.model.dto.ChatMessageSelectDTO;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Transactional
@Repository
public class ChatDAO {
	
	private final SqlSessionTemplate sqlSession;
	
	public List<ChatListDTO> getChatList(int accountId) {
		return sqlSession.selectList("mybatis.mapper.chatMapper.getChatList", accountId);
	}
	
	public List<Map<String, Object>> getChatMessageList(ChatMessageSelectDTO chatMessageSelectDTO) {
		return sqlSession.selectList("mybatis.mapper.chatMessageMapper.getChatMessageList", chatMessageSelectDTO);
	}
	
	public ChatMessageProductDTO getProduct(Integer productId) {
		return sqlSession.selectOne("mybatis.mapper.chatMessageMapper.getProduct", productId);
	}
	
}
