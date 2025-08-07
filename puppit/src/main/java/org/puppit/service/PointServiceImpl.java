package org.puppit.service;

import org.puppit.repository.PointDAO;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class PointServiceImpl implements PointService {

  private final PointDAO pointDAO;

  @Override
  public boolean verifyAndCharge(int uid, int amount) {
     boolean resultPointUpdate =  pointDAO.updatePoint(uid, amount) == 1;
     boolean resultRecordUpdate = pointDAO.updatePointRecord(uid, amount) == 1;
     
     return resultPointUpdate && resultRecordUpdate;

  }
}