package org.puppit.service;

import org.puppit.model.dto.UserDTO;
import org.puppit.repository.UserDAO;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class UserServiceImpl implements UserService {
  
  private final UserDAO userDAO;

  public boolean signup(UserDTO user) {
    try {
      if(user.getUserName() == null || user.getUserName().trim().isEmpty()) {
        return false;
      }
      return userDAO.userSignUp(user) == 1 ? true : false;
    } catch (Exception e) {
      e.printStackTrace();
      return false;
    }
  }

}
