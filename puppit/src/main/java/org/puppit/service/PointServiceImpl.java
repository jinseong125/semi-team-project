package org.puppit.service;

import java.util.List;

import org.puppit.model.dto.PointDTO;
import org.puppit.model.dto.TradeDTO;
import org.puppit.repository.PointDAO;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Transactional
@RequiredArgsConstructor
@Service
public class PointServiceImpl implements PointService {

  private final PointDAO pointDAO;

  @Override
  public boolean verifyAndCharge(Integer uid, String merchantUid, Integer amount) {
    try {
      boolean resultPointUpdate = pointDAO.updatePoint(uid, amount) == 1;
      boolean resultRecordUpdate = pointDAO.updatePointRecord(merchantUid, "PAID") == 1;
      
      if(!resultPointUpdate) {
        throw new RuntimeException("포인트 잔액 충전 실패");
      }
      if(!resultRecordUpdate) {
        throw new RuntimeException("포인트 충전내역 업데이트 실패");
      }
      
    } catch (Exception e) {
      log.error("verifyAndCharge FAILED", e);
      throw new RuntimeException("포인트 충전 중 오류가 발생했습니다.", e);
    }
     
     return true;

  }

  @Override
  public List<PointDTO> selectPointRecordById(Integer userId) {
    List<PointDTO> result = pointDAO.selectPointRecordById(userId);
    return result;
  }

  @Override
  public boolean insertChargeRecord(Integer uid, Integer amount, String uuid) {
    Integer result = pointDAO.insertChargeRecord(uid, amount, uuid);
    return result == 1;
  }
  
  
}