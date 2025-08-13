package org.puppit.service;

import java.util.List;

import org.puppit.model.dto.PointDTO;

public interface PointService {
    public boolean verifyAndCharge(int uid, int amount);
    public List<PointDTO> selectPointRecordById(Integer userId);
}