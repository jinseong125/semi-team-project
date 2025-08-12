package org.puppit.service;

import org.puppit.repository.PointDAO;
import org.puppit.repository.TradeDAO;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class TradePaymentService {
  
  private final PointDAO pointDAO;
  private final TradeDAO tradeDAO;
  
  @Transactional
  public boolean updateBuyerPoint(int buyerId, int amount) {
    int resultPoint = pointDAO.updatePoint(buyerId, amount);
    int resultPointRecord = pointDAO.updatePointRecord(buyerId, amount);
    
    return resultPoint == 1 && resultPointRecord == 1;
  }
  @Transactional
  public boolean updateSellerPoint(int sellerId, int amount) {
    int resultPoint = pointDAO.updatePoint(sellerId, amount);
    int resultPointRecord = pointDAO.updatePointRecord(sellerId, amount);
    return resultPoint == 1 && resultPointRecord == 1;
  }
  
  public boolean insertTrade(Integer buyerId, Integer sellerId, Integer productId, String status) {
    int result = tradeDAO.insertTrade(buyerId, sellerId, productId, status);
    return result == 1;
  }
  

}
