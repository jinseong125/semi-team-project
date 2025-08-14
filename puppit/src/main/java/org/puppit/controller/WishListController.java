package org.puppit.controller;

import java.util.ArrayList;
import java.util.List;

import org.puppit.model.dto.ProductDTO;
import org.puppit.model.dto.WishListDTO;
import org.puppit.service.WishListService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class WishListController {
  
  private final WishListService wishListService;
  
  @GetMapping("/wish/list")
  public String wishList(Integer userId, Model model) {
    List<WishListDTO> likes = wishListService.getWishListByUserId(userId);
    List<ProductDTO> products = new ArrayList<>();
    
    for(WishListDTO like : likes) {
      products.add(wishListService.getProductById(like.getProductId()));
    }
    model.addAttribute("products", products);
    model.addAttribute("likes", likes);
    return "/user/wishList";
  }
}
