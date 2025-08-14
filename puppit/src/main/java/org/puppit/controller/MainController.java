package org.puppit.controller;

import org.puppit.model.dto.PageDTO;
import org.puppit.model.dto.ProductDTO;
import org.puppit.service.ProductService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lombok.RequiredArgsConstructor;

import java.util.List;

@RequiredArgsConstructor
@Controller
public class MainController {
  
  private final ProductService productService;
  
  @RequestMapping(value = "/")
  public String main(Model model) {
    // 첫 진입 시 8개 상품
    List<ProductDTO> initialProducts = productService.getProducts(0, 8);
    model.addAttribute("products", initialProducts);
    return "main";
  }

  // 스크롤/더보기: offset과 size를 받아서 상품 리스트 반환
  @GetMapping("/product/list")
  @ResponseBody
  public List<ProductDTO> getProducts(
      @RequestParam(defaultValue = "0") int offset,
      @RequestParam(defaultValue = "8") int size) {
    return productService.getProducts(offset, size);
  }
}