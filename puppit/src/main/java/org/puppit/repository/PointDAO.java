package org.puppit.repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.mybatis.spring.SqlSessionTemplate;
import org.puppit.model.dto.PointDTO;
import org.puppit.model.dto.TradeDTO;
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
  public int insertPointRecord(int uid, int amount) {
    Map<String, Object> paraMap = new HashMap<>();
    paraMap.put("uid", uid);
    paraMap.put("amount", amount);
    paraMap.put("uuid", UUID.randomUUID().toString());
    
    return template.insert("mybatis.mapper.pointMapper.insertPointRecord", paraMap);
  }
  
  //dto 불러오기
  public List<PointDTO> selectPointRecordById(Integer userId) {
    Map<String, Object> paraMap = new HashMap<>();
    paraMap.put("userId", userId);
    
    return template.selectList("mybatis.mapper.pointMapper.selectPointRecordById", paraMap);
  }

}
