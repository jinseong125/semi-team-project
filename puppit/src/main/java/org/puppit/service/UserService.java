package org.puppit.service;

import org.apache.ibatis.annotations.Mapper;
import org.puppit.model.dto.UserDTO;

@Mapper
public interface UserService {
  
  boolean signup(UserDTO user); 
  boolean countByAccountId(String accountId);
  
}
