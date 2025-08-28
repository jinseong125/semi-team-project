package org.puppit.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.puppit.model.dto.PointDTO;
import org.puppit.service.IamPortService;
import org.puppit.service.PointService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/payment")
public class PointController {
  
  private final PointService pointService;
  private final IamPortService iamportService;
  
  @GetMapping("/history")
  public String getPaymentHistory(Integer userId, Model model) {
    List<PointDTO> pointDTOs = pointService.selectPointRecordById(userId);
    model.addAttribute("pointDTOs", pointDTOs);
    return "trade/chargeRecord";
  }
  
  // 결제창 화면
  @GetMapping("/paymentForm")
  public String paymentForm() {
    return "/payment/paymentForm";
  }
    
  @PostMapping(value = "/verify", produces = "application/json")
  @ResponseBody
  public Map<String, Object> verifyPayment(
      @RequestBody Map<String, Object> data,
      @SessionAttribute("sessionMap") Map<String, Object> sessionMap) {
    
    try {
      
      String impUid = (String) data.get("imp_uid");
      Map<String, Object> info = iamportService.getPaymentInfoByImpUid(impUid); // 아임포트 서버에서 조회한 실제 결제 금액 
      Integer uid = (Integer)sessionMap.get("userId");
      Integer amount = Integer.parseInt(info.get("amount").toString());
      String merchantUid = info.get("merchantUid").toString();
      
      Map<String, Object> result = new HashMap<>();
      if (amount != null) {
        // 금액 정상 → 포인트 충전
        boolean success = pointService.verifyAndCharge(uid, merchantUid, amount);
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
  // 주문번호 생성 
  @PostMapping(value="/orders", produces="application/json")
  @ResponseBody
  public Map<String, Object> makeMerchantUid(@RequestBody Map<String, Object> data,
                                             @SessionAttribute("sessionMap") Map<String, Object> sessionMap) {
    Integer uid  = (Integer) sessionMap.get("userId");
    Integer amount = Integer.parseInt(data.get("amount").toString());
    String uuid = UUID.randomUUID().toString();
    
    pointService.insertChargeRecord(uid, amount, uuid);
    
    Map<String, Object> map = new HashMap<>();
    map.put("merchant_uid", uuid);
    
    return map;
  }
 
  
}

