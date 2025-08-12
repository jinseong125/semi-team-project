package org.puppit.service;

import org.apache.ibatis.annotations.Mapper;
import org.puppit.model.dto.UserDTO;
import org.puppit.model.dto.UserStatusDTO;

@Mapper
public interface UserService {
  
  boolean signup(UserDTO user); 
  boolean login(UserDTO user);
  boolean countByAccountId(String accountId);
  Integer insertLogStatus(UserStatusDTO log);
  UserDTO getUserId(String accountId);
  
}
