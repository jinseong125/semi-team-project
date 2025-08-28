package org.puppit.service;

import java.util.List;

import org.puppit.model.dto.PointDTO;

public interface PointService {
    public boolean verifyAndCharge(Integer uid, String merchantUid, Integer amount);
    public List<PointDTO> selectPointRecordById(Integer userId);
    public boolean insertChargeRecord(Integer uid, Integer amount, String uuid);
}