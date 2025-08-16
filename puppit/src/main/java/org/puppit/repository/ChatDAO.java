package org.puppit.repository;

import java.math.BigInteger;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.puppit.model.dto.ChatListDTO;

import org.puppit.model.dto.ChatMessageDTO;
import org.puppit.model.dto.ChatMessageProductDTO;
import org.puppit.model.dto.ChatMessageSearchDTO;
import org.puppit.model.dto.ChatMessageSelectDTO;
import org.puppit.model.dto.ChatRoomPeopleDTO;

import org.puppit.model.dto.ChatMessageDTO;
import org.puppit.model.dto.ChatMessageProductDTO;
import org.puppit.model.dto.ChatMessageSearchDTO;
import org.puppit.model.dto.ChatMessageSelectDTO;

import org.puppit.model.dto.ChatRoomPeopleDTO;



import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Transactional
@Repository
public class ChatDAO {
	
	private final SqlSessionTemplate sqlSession;
    
	public List<ChatListDTO> getChatList(int userId,  Integer highlightRoomId) {
		Map<String, Object> param = new HashMap<>();
		param.put("userId", userId);
		param.put("highlightRoomId", highlightRoomId);
	    return sqlSession.selectList("mybatis.mapper.chatMapper.getChatList", param);
	}
	
	public List<Map<String, Object>> getChatMessageList(ChatMessageSelectDTO chatMessageSelectDTO) {
		return sqlSession.selectList("mybatis.mapper.chatMessageMapper.getChatMessageList", chatMessageSelectDTO);
	}
	
	public ChatMessageProductDTO getProduct(Integer productId) {
		return sqlSession.selectOne("mybatis.mapper.chatMessageMapper.getProduct", productId);
	}
	
	 public Integer insertChatMessage(ChatMessageDTO chatMessageDTO) {
	    	return sqlSession.insert("mybatis.mapper.chatMessageMapper.insertChatMessage", chatMessageDTO);
	    }
	

	 public List<ChatRoomPeopleDTO> getUserRoleANDAboutChatMessagePeople(ChatMessageSearchDTO chatMessageSearchDTO) {
		 return sqlSession.selectList("mybatis.mapper.chatMessageMapper.getUserRoleANDAboutChatMessagePeople", chatMessageSearchDTO);
	 }
	 

     public Integer selectRoomIdByParticipants(int productId, int buyerId, int sellerId) {
        Map<String, Object> param = new HashMap<>();
        param.put("productId", productId);
        param.put("buyerId", buyerId);
        param.put("sellerId", sellerId);
        return sqlSession.selectOne("mybatis.mapper.chatMessageMapper.selectRoomIdByParticipants", param);
     }

     public Integer insertRoom(int productId, int buyerId, int sellerId) {
	    Map<String, Object> param = new HashMap<>();
	    param.put("productId", productId);
	    param.put("buyerId", buyerId);
	    param.put("sellerId", sellerId);
	    sqlSession.insert("mybatis.mapper.chatMessageMapper.insertRoom", param);
	    Object roomIdObj = param.get("room_id");
	    if (roomIdObj == null) return null;
	    if (roomIdObj instanceof Integer) {
	        return (Integer) roomIdObj;
	    } else if (roomIdObj instanceof BigInteger) {
	        return ((BigInteger) roomIdObj).intValue();
	    } else if (roomIdObj instanceof Long) {
	        return ((Long) roomIdObj).intValue();
	    } else {
	        return Integer.parseInt(roomIdObj.toString());
	    }
	}

  // 추가: 생성일 기준 내림차순 목록
   public List<ChatListDTO> getChatListByCreatedDesc(int userId) {
         Map<String, Object> param = new HashMap<>();
         param.put("userId", userId);
         return sqlSession.selectList("mybatis.mapper.chatMessageMapper.getChatRoomsByCreatedDesc", param);
   } 
   

   /**
    * roomId를 사용하여 productId를 가져오는 메서드
    * @param roomId 채팅방 ID
    * @return 해당 채팅방의 상품 ID
    */
   public Integer findProductIdByRoomId(int roomId) {
       return sqlSession.selectOne("mybatis.mapper.chatMessageMapper.findProductIdByRoomId", roomId);
   }
   
   
   
   // 페이징 처리된 채팅방 목록 조회
   // 페이징 처리된 채팅방 목록 조회
  // public List<ChatListDTO> getChatRoomsByCreatedDescPaged(Map<String, Object> param) {
  //    return sqlSession.selectList("mybatis.mapper.chatMessageMapper.getChatRoomsByCreatedDescPaged", param);
  // }
}
