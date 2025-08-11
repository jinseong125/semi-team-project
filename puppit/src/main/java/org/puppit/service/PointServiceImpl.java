package org.puppit.service;

import org.puppit.repository.PointDAO;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;

@Transactional
@RequiredArgsConstructor
@Service
public class PointServiceImpl implements PointService {

  private final PointDAO pointDAO;

  @Override
  public boolean verifyAndCharge(int uid, int amount) {
    try {
      boolean resultPointUpdate = pointDAO.updatePoint(uid, amount) == 1;
      boolean resultRecordUpdate = pointDAO.updatePointRecord(uid, amount) == 1;
      
      if(!resultPointUpdate || !resultRecordUpdate) {
        throw new RuntimeException("포인트 잔액 충전 실패");
      }
      
    } catch (Exception e) {
      throw new RuntimeException("포인트 충전 중 오류가 발생했습니다.");
    }
     
     return true;

  }
}