package org.puppit.service;

import java.util.List;

import org.puppit.model.dto.TradeDTO;
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
  
  public boolean updateBuyerPoint(int buyerId, int amount) {
    int resultPoint = pointDAO.updatePoint(buyerId, amount);
    
    return resultPoint == 1;
  }
  
  public boolean updateSellerPoint(int sellerId, int amount) {
    int resultPoint = pointDAO.updatePoint(sellerId, amount);
    return resultPoint == 1;
  }
  
  public boolean insertTrade(Integer buyerId, Integer sellerId, Integer productId, String status) {
    int result = tradeDAO.insertTrade(buyerId, sellerId, productId, status);
    return result == 1;
  }
  
  public List<TradeDTO> selectTradeById(Integer userId) {
    List<TradeDTO> result = tradeDAO.selectTradeById(userId);
    return result;
  }
  

}
