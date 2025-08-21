package org.puppit.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.puppit.model.dto.ProductAndImageDTO;
import org.puppit.model.dto.ProductDTO;
import org.puppit.model.dto.ProductImageDTO;
import org.puppit.model.dto.WishListDTO;
import org.puppit.service.WishListService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/wish")
public class WishListController {
  
  private final WishListService wishListService;
  
  @GetMapping("/list")
  public String wishList(Integer userId, Model model) {
    List<WishListDTO> likes = wishListService.getWishListByUserId(userId);
    List<ProductDTO> products = new ArrayList<>();
    List<ProductImageDTO> productImages = new ArrayList<>();
    List<ProductAndImageDTO> productAndImages = new ArrayList<>();
    
    for(WishListDTO like : likes) {
      products.add(wishListService.getProductById(like.getProductId()));
      productImages.add(wishListService.getProductImage(like.getProductId()));
      productAndImages.add(wishListService.getProductAndImage(like.getProductId()));
      
    }
    System.out.println("상품123" + productAndImages);
    model.addAttribute("products", products);
    model.addAttribute("productImages", productImages);
    model.addAttribute("productAndImages", productAndImages);
    model.addAttribute("likes", likes);
    return "user/wishList";
  }
  
  @PostMapping("/delete")
  public String deleteWish(@RequestParam("productId") Integer productId,
                           @SessionAttribute("sessionMap") Map<String, Object> sessionMap,
                           RedirectAttributes rttr) {
    Integer userId = (Integer) sessionMap.get("userId"); 
    boolean result = wishListService.deleteWishListByUserAndProduct(userId, productId);
    rttr.addFlashAttribute("msg", result ? "삭제되었습니다." : "이미 삭제되었거나 존재하지 않습니다.");
    return "redirect:/wish/list?userId=" + userId;
  }

  @PostMapping("/delete-all")
  public String deleteAll(@SessionAttribute("sessionMap") Map<String,Object> sessionMap) {
      Integer userId = (Integer) sessionMap.get("userId");
      wishListService.deleteAllWishListByUser(userId);
      return "redirect:/wish/list?userId=" + userId;
  }
}
