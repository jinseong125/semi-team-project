package org.puppit.repository;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class PointDAO {
  
  private final SqlSessionTemplate template;
  
  // 포인트 충전 
  public int updatePoint(int uid, int amount) {
    Map<String, Object> paraMap = new HashMap<>();
    paraMap.put("uid", uid);
    paraMap.put("amount", amount);
    
    return template.update("mybatis.mapper.pointMapper.updatePoint", paraMap);
  }
  
  // 포인트 충전 내역 기록 
  public int updatePointRecord(int uid, int amount) {
    Map<String, Object> paraMap = new HashMap<>();
    paraMap.put("uid", uid);
    paraMap.put("amount", amount);
    paraMap.put("uuid", UUID.randomUUID().toString());
    
    return template.insert("mybatis.mapper.pointMapper.updatePointRecord", paraMap);
  }

}
