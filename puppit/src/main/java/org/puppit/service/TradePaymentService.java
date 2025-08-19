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
  

  
  @Transactional
  public void payAndRecord(int buyerId, int sellerId, int productId, int quantity, int amount) {
    int r1 = pointDAO.decreaseIfEnough(buyerId, amount);
    if (r1 == 0) throw new RuntimeException("잔액이 부족합니다");

    int r2 = pointDAO.updatePoint(sellerId, amount);
    if (r2 == 0) throw new RuntimeException("판매자 포인트 적립 실패");

    int r3 = tradeDAO.insertTrade(buyerId, sellerId, productId, "거래완료");
    if (r3 == 0) throw new RuntimeException("거래 기록 실패");
  }
  

  
  public List<TradeDTO> selectTradeById(Integer userId) {
    List<TradeDTO> result = tradeDAO.selectTradeById(userId);
    return result;
  }
  

}
