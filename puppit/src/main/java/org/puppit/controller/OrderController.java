package org.puppit.controller;

import org.puppit.model.dto.ProductDTO;
import org.puppit.service.ProductService;
import org.puppit.service.TradePaymentService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import lombok.RequiredArgsConstructor;

@RequestMapping("/order")
@Controller
@RequiredArgsConstructor
public class OrderController {
  
  private final TradePaymentService tps;
  private final ProductService productService;
  

  @GetMapping("/pay")
  public String orderForm(@RequestParam("buyerId") String buyerId, 
                          @RequestParam("sellerId") String sellerId, 
                          @RequestParam("productId") String productId, 
                          @RequestParam("quantity") String quantity, 
                          Model model) {


    model.addAttribute("buyerId", Integer.parseInt(buyerId));
    model.addAttribute("sellerId", Integer.parseInt(sellerId));
    model.addAttribute("productId", Integer.parseInt(productId));
    model.addAttribute("quantity", Integer.parseInt(quantity));
    return "/payment/orderForm";
  }
  
  @PostMapping("/pay")
  public String order(@RequestParam("buyerId") int buyerId, 
                      @RequestParam("sellerId") int sellerId, 
                      @RequestParam("productId") int productId, 
                      @RequestParam("quantity") int quantity) {
    ProductDTO productDTO = productService.getProductById(productId);
    int price = productDTO.getProductPrice();
    int amount = price * quantity;
    String status = "거래완료";
    tps.updateBuyerPoint(buyerId, -amount);
    tps.updateSellerPoint(sellerId, amount);
    tps.insertTrade(buyerId, sellerId, productId, status);
    
    return "redirect:/";
  }
}
