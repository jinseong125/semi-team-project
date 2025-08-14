package org.puppit.controller;

import org.puppit.model.dto.ProductDTO;
import org.puppit.model.dto.UserDTO;
import org.puppit.service.ProductService;
import org.puppit.service.TradePaymentService;
import org.puppit.service.UserService;
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
  private final UserService userService;
  

  @GetMapping("/pay")
  public String orderForm(@RequestParam("buyerId") Integer buyerId, 
                          @RequestParam("buyerId") Integer sellerId, 
                          @RequestParam("chatSellerAccountId") String chatSellerAccountId, 
                          @RequestParam("productId") Integer productId, 
                          @RequestParam("quantity") Integer quantity, 
                          Model model) {
    
    ProductDTO productDTO = productService.getProductById(productId);
    Integer price = productDTO.getProductPrice();
    String productName = productDTO.getProductName();
    Integer amount = price * quantity;
    
    UserDTO userDTO = userService.getUserId(String.valueOf(chatSellerAccountId));
    String userNickname = userDTO.getUserName();

    model.addAttribute("buyerId", buyerId);
    model.addAttribute("sellerId", sellerId);
    model.addAttribute("productId", productId);
    model.addAttribute("quantity", quantity);
    model.addAttribute("price", price);
    model.addAttribute("amount", amount);
    model.addAttribute("productName", productName);
    model.addAttribute("sellerNickname", userNickname);
    
    return "/payment/orderForm";
  }
  
  @PostMapping("/pay")
  public String order(@RequestParam("buyerId") Integer buyerId, 
                      @RequestParam("sellerId") Integer sellerId, 
                      @RequestParam("productId") Integer productId, 
                      @RequestParam("quantity") Integer quantity,
                      @RequestParam("amount") Integer amount) {
    
    String status = "거래완료";
    tps.updateBuyerPoint(buyerId, -amount);
    tps.updateSellerPoint(sellerId, amount);
    tps.insertTrade(buyerId, sellerId, productId, status);
    
    return "redirect:/";
  }
}
