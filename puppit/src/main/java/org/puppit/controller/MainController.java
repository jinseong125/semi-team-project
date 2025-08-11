package org.puppit.controller;

import org.puppit.model.dto.UserDTO;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class MainController {

  @RequestMapping(value = "/")
  public String main() {
    return "main";
  }
  
  @GetMapping("user/login")
  public String userlogin() {
    return "user/login";
  }


  
 
  
}
