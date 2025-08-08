package org.puppit.service;

import org.puppit.model.dto.UserDTO;
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
  public boolean countByAccountId(String accountId) {
    return false;
  }

}
