package org.puppit.controller;

import org.puppit.model.dto.UserDTO;
import org.puppit.service.ProductService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Controller
public class MainController {
  
  private final ProductService productService;
  
  @RequestMapping(value = "/")
  public String main(Model model) {
   model.addAttribute("products", productService.getProductList());
    return "main";
  }

  



  
 

}
