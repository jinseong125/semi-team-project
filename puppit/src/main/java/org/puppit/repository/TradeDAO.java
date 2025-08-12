package org.puppit.repository;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class TradeDAO {
  
  private final SqlSessionTemplate sst;
  
  // 결제 내역 저장
  public int insertTrade(Integer buyerId, Integer sellerId, Integer productId, String status) {
    
    Map<String, Object> paraMap = new HashMap<>();
    String uuid = UUID.randomUUID().toString();
    paraMap.put("uuid", uuid);
    paraMap.put("buyerId", buyerId);
    paraMap.put("sellerId", sellerId);
    paraMap.put("productId", productId);
    paraMap.put("status", status);
    
    return sst.insert("mybatis.mapper.tradeMapper.insertTrade", paraMap);
    
  }

}
