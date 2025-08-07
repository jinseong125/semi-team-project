package org.puppit.controller;

import org.puppit.service.PointService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class PointController {
  
  private final PointService pointService;
  
  @GetMapping("/payment/paymentForm")
  public String paymentForm() {
    return "/user/paymentForm";
  }
  
  @PostMapping("/payment/insertPoint")
  public String insertPoint(int uid, int amount, Model model) {
    boolean result = pointService.verifyAndCharge(uid, amount);
    model.addAttribute("result", result);
    return "/user/showPoint";
  }
    
}

