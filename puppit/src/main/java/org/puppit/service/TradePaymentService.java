package org.puppit.service;

import org.puppit.repository.PointDAO;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class TradePaymentService {
  
  private PointDAO pointDAO;
  
  public boolean updateBuyerPoint(int buyerId, int amount) {
    int resultPoint = pointDAO.updatePoint(buyerId, amount);
    int resultPointRecord = pointDAO.updatePoint(buyerId, amount);
    return resultPoint == 1 && resultPointRecord == 1;
  }
  public boolean updateSellerPoint(int sellerId, int amount) {
    int resultPoint = pointDAO.updatePoint(sellerId, amount);
    int resultPointRecord = pointDAO.updatePoint(sellerId, amount);
    return resultPoint == 1 && resultPointRecord == 1;
  }
  

}
