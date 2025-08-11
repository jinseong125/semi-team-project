package org.puppit.repository;

import org.mybatis.spring.SqlSessionTemplate;
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
  public Integer countByAccountId(String userId) {
    return sqlSession.selectOne("mybatis.mapper.userMapper.countByLoginId", userId);
  }
  public String getUserById(String userId) {
    return sqlSession.selectOne("mybatis.mapper.userMapper.getUserById", userId);
  }
  public UserDTO getUserByIdAndPassword(UserDTO user) {
    return sqlSession.selectOne("mybatis.mapper.userMapper.getUserByIdAndPassword", user);
  }
  public Integer insertLogStatus(UserStatusDTO log) {
    return sqlSession.insert("mybatis.mapper.userMapper.insertLogStatus", log);
  }
  public Integer getUserId(String accountId) {
    return sqlSession.selectOne("mybatis.mapper.userMapper.getUserId", accountId);
  }
}
