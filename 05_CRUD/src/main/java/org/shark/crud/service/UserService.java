package org.shark.crud.service;

import org.shark.crud.model.dto.UserDTO;

public interface UserService {
  UserDTO findUserByEmailAndPassword(UserDTO user);
  UserDTO findUserByNickname(String nickname);
}
