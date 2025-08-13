package org.puppit.service;

import org.puppit.model.dto.ChatUserDTO;
import org.puppit.model.dto.UserDTO;
import org.puppit.model.dto.UserStatusDTO;
import org.puppit.repository.UserDAO;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class UserServiceImpl implements UserService {
  
  private final UserDAO userDAO;
  
  private boolean emptyCheck(String... fields) {
    for(String field : fields) {
      if(field == null || field.trim().isEmpty()) {
        return true;
      }
    }
    return false; 
  }

  public boolean signup(UserDTO user) {
    try {
      if(emptyCheck(user.getAccountId(), user.getUserPassword(), user.getUserName(), user.getNickName(), user.getUserEmail(), user.getUserPhone())) {
        return false;
      }
      return userDAO.userSignUp(user) == 1 ? true : false;
    } catch (Exception e) {
      e.printStackTrace();
      return false;
    }
  }
  @Override
  public Boolean isAccountIdAvailable(String accountId) {
    return userDAO.countByAccountId(accountId.trim()) == 0; 
  }
  @Override
  public Boolean isNickNameAvailable(String nickName) {
    return userDAO.countByNickName(nickName.trim()) == 0;
  }
  @Override
  public Boolean isUserEmailAvailable(String userEmail) {
    return userDAO.countByEmail(userEmail.trim()) == 0;
  }
  @Override
  public boolean login(UserDTO user) {
    try {
      if(emptyCheck(user.getAccountId(), user.getUserPassword())) {
        return false;
      }
      UserDTO userDTO = userDAO.getUserByIdAndPassword(user);
      if(userDTO != null) {
        return true;
      }
      return false;
    } catch (Exception e) {
      e.printStackTrace();
      return false;
    }
  }
  @Override
  public Integer insertLogStatus(UserStatusDTO log) {
    return userDAO.insertLogStatus(log);
  }
  @Override
  public UserDTO getUserId(String accountId) {
    return userDAO.getUserId(accountId);
  }

  // 채팅 보낸 사람의 사용자 정보 조회
  @Override
  public ChatUserDTO getUserByUserId(String senderUserId) {
	return userDAO.getUserByUserId(senderUserId);
  }

}
