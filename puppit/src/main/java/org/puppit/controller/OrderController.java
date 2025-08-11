package org.puppit.controller;

import org.puppit.model.dto.ProductDTO;
import org.puppit.service.ProductService;
import org.puppit.service.TradePaymentService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class OrderController {
  
  private final TradePaymentService tps;
  private final ProductService productService;
  
  @GetMapping("/order/pay")
  public String orderForm(@RequestParam("buyerId") int buyerId, 
                          @RequestParam("sellerId") int sellerId, 
                          @RequestParam("prodId") int prodId, 
                          @RequestParam("quantity") int quantity, 
                          Model model) {
    model.addAttribute("buyerId", buyerId);
    model.addAttribute("sellerId", sellerId);
    model.addAttribute("prodId", prodId);
    model.addAttribute("quantity", quantity);
    
    return "/payment/orderForm";
  }
  
  @PostMapping("/order/pay")
  public String order(@RequestParam("buyerId") int buyerId, 
                      @RequestParam("sellerId") int sellerId, 
                      @RequestParam("prodId") int prodId, 
                      @RequestParam("quantity") int quantity, 
                      Model model) {
    ProductDTO productDTO = productService.getProductById(prodId);
    int price = productDTO.getProductPrice();
    int amount = price * quantity;
    tps.updateBuyerPoint(buyerId, amount);
    tps.updateSellerPoint(sellerId, amount);
    
    return "redirect:/user/mypage";
  }
}
