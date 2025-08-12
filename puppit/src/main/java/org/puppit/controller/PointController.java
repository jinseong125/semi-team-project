package org.puppit.controller;

import org.puppit.service.PointService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import lombok.RequiredArgsConstructor;

import java.util.HashMap;
import java.util.Map;

import org.puppit.service.PointService;
import org.puppit.service.IamPortService; 
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequiredArgsConstructor
public class PointController {
  
  private final PointService pointService;
  private final IamPortService iamportService;
  
  @GetMapping("/payment/paymentForm")
  public String paymentForm() {
    return "/payment/paymentForm";
  }
    
  @PostMapping(value = "/payment/verify", produces = "application/json")
  @ResponseBody
  public Map<String, Object> verifyPayment(@RequestBody Map<String, Object> data) {
    
    try {
      String impUid = (String) data.get("imp_uid");
      int uid = Integer.parseInt(data.get("uid").toString());
      
      int amountFromIamport = iamportService.getAmountByImpUid(impUid); // 아임포트 서버에서 조회한 실제 결제 금액
      
      Map<String, Object> result = new HashMap<>();
      if (amountFromIamport > 0) {
        // 금액 정상 → 포인트 충전
        boolean success = pointService.verifyAndCharge(uid, amountFromIamport);
        result.put("success", success);
      } else {
        // 결제 실패 or 금액 검증 실패
        result.put("success", false);
      }
      
      return result;
      
    } catch (Exception e) {
      e.printStackTrace();
      Map<String, Object> result = new HashMap<>();
      result.put("success", false);
      return result;
    }
  }
  
}

