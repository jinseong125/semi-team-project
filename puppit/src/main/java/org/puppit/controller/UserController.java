package org.puppit.controller;

import org.puppit.model.dto.UserDTO;
import org.puppit.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lombok.RequiredArgsConstructor;

@RequestMapping("/user")
@RequiredArgsConstructor
@Controller
public class UserController {
  
  private final UserService userService;
  
  @GetMapping("/mypage")
  public String myPage() {
    return "user/mypage";
  }
  
  // 회원가입 폼 보여주기
  @GetMapping("/signup")
  public String showSignupForm() {
      return "user/signup";  
  }
  

  @PostMapping("/signup")
  public String signUp(UserDTO user, RedirectAttributes redirectAttr) {
    // 회원가입
    boolean signupResult = userService.signup(user);
    // 회원가입 실패
    if(!signupResult) {
      redirectAttr.addFlashAttribute("error", "아이디를 입력 해주세요");
      return "redirect:/user/signup";
    }
    // 회원가입 성공
    redirectAttr.addFlashAttribute("msg", "Puppit에 오신것을 환영 합니다");
    return "redirect:/";
  }
}
