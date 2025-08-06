package org.puppit.service;

public interface PointService {
    boolean verifyAndCharge(String impUid, int amount, String userId);
}