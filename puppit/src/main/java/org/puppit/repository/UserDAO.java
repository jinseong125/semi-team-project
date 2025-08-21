package org.puppit.repository;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.puppit.model.dto.ChatUserDTO;
import org.puppit.model.dto.UserDTO;
import org.puppit.model.dto.UserStatusDTO;
import org.springframework.stereotype.Repository;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Repository
public class UserDAO {
  
  private final SqlSessionTemplate sqlSession;
  
  public Integer userSignUp(UserDTO user) {
    return sqlSession.insert("mybatis.mapper.userMapper.userSignUp", user);
  }
  public Integer countByAccountId(String accountId) {
    return sqlSession.selectOne("mybatis.mapper.userMapper.countByAccountId", accountId);
  }
  public Integer countByNickName(String nickName) {
    return sqlSession.selectOne("mybatis.mapper.userMapper.countByNickName", nickName);
  }
  public Integer countByEmail(String userEmail) {
    return sqlSession.selectOne("mybatis.mapper.userMapper.countByEmail", userEmail);
  }
  public UserDTO selectLogin(String accountId) {
    return sqlSession.selectOne("mybatis.mapper.userMapper.selectLogin", accountId);
  }
  public Integer insertLogStatus(UserStatusDTO log) {
    return sqlSession.insert("mybatis.mapper.userMapper.insertLogStatus", log);
  }
  // user 정보 조회 (accountId)
  public UserDTO getUserByAccountId(String accountId) {
    return sqlSession.selectOne("mybatis.mapper.userMapper.getUserByAccountId", accountId);
  }
  public String findAccountIdByNameAndEmail(UserDTO user) {
    return sqlSession.selectOne("mybatis.mapper.userMapper.findAccountIdByNameAndEmail", user);
  }
  // user 정보 조회 (user_id)
  public UserDTO getUserByUserId(Integer userId) {
    return sqlSession.selectOne("mybatis.mapper.userMapper.getUserByUserId", userId);
  }
  public Integer updateUser(Map<String, Object> map) {
    return sqlSession.update("mybatis.mapper.userMapper.updateUser", map);
  }
  public Integer updateProfileImageKey(Map<String, Object> map) {
    return sqlSession.update("mybatis.mapper.userMapper.updateProfileImageKey", map);
  }
  

}