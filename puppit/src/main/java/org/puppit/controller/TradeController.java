package org.puppit.controller;

import java.util.List;

import org.puppit.model.dto.TradeDTO;
import org.puppit.service.TradePaymentService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class TradeController {
  
  private final TradePaymentService trade;
  
  @GetMapping("/trade/history")
  public String getTradeHistory(Integer userId, Model model) {
    List<TradeDTO> tradeDTOs = trade.selectTradeById(userId);
    model.addAttribute("tradeDTOs", tradeDTOs);
    for(TradeDTO tradeDTO : tradeDTOs) {
      System.out.println("sellerId: " + tradeDTO.getSellerId());
      System.out.println("buyerId: " + tradeDTO.getBuyerId());
      System.out.println("productId: " + tradeDTO.getProductId());
    }
    return "trade/tradeRecord";
  }
  
 
}
