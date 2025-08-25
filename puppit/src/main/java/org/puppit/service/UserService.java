package org.puppit.service;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.puppit.model.dto.ChatUserDTO;

import org.puppit.model.dto.UserDTO;
import org.puppit.model.dto.UserStatusDTO;

@Mapper
public interface UserService {
  
  boolean signup(UserDTO user); 
  UserDTO login(UserDTO user);
  // 아이디 중복 체크
  Boolean isAccountIdAvailable(String accountId);
  // 닉네임 중복 체크
  Boolean isNickNameAvailable(String nickName);
  // 이메일 중복 체크
  Boolean isUserEmailAvailable(String userEmail);
  // 로그인 정보
  Integer insertLogStatus(UserStatusDTO log);
  // accountId를 이용해 유저 정보 찾기
  UserDTO getUserId(String accountId);
  // accountId 찾기
  String findAccountIdByUserNameUserEmail(UserDTO user);
  // 비밀번호 변경
//  Boolean changeUserPasswordByuserId(UserDTO user);
  // 기존 비밀번호 확인
  UserDTO passwordCheck(UserDTO user);

  boolean updateUser(Map<String, Object> map);
  UserDTO getProfileImageKey(Integer userId);
  boolean updateProfileImageKey(Integer userId, String profileImageKey);
  
}