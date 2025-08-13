package org.puppit.service;

import org.apache.ibatis.annotations.Mapper;
import org.puppit.model.dto.ChatUserDTO;

import org.puppit.model.dto.UserDTO;
import org.puppit.model.dto.UserStatusDTO;

@Mapper
public interface UserService {
  
  boolean signup(UserDTO user); 
  boolean login(UserDTO user);
  Boolean isAccountIdAvailable(String accountId);
  Boolean isNickNameAvailable(String nickName);
  Boolean isUserEmailAvailable(String userEmail);
  Integer insertLogStatus(UserStatusDTO log);
  UserDTO getUserId(String accountId);

  // 채팅 보낸 사람의 사용자 정보 조회
  ChatUserDTO getUserByUserId(String senderUserId);
  
}