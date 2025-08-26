package org.puppit.controller;

import org.puppit.service.KakaoLoginService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Controller
public class KakaoLoginAPIController {
  
  private KakaoLoginService kakaoLoginService;
  
  @GetMapping("/login")
  public String kakaoLoginForm(Model model) {
    String kakaoApiKey = "79176a8cb995f6cf89985b3657377b24";
    String kakaoRedirectUri = "http://localhost:8080/puppit/auth/kakao/callback";
    model.addAttribute("kakaoApiKey", kakaoApiKey);
    model.addAttribute("redirectUri", kakaoRedirectUri);
    return "/login";
  }
  @RequestMapping("/login/oauth2/code/kakao")
  public String kakaoLogin(@RequestParam String code) {
    // 1. 인가 코드 받기
    
    // 2. 토큰 받기
    String accessToken = kakaoLoginService.AccessToken(code);
    
    // 3. 사용자 정보 받기
    
    return "redirect:/puppit";
  }
}
