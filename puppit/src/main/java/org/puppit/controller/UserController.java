package org.puppit.controller;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpSession;

import org.puppit.model.dto.UserDTO;
import org.puppit.model.dto.UserStatusDTO;
import org.puppit.service.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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
  public String myPage(HttpSession session, Model model) {
    String accountId = session.getAttribute("accountId").toString();
    UserDTO userDTO = userService.getUserId(accountId);
    model.addAttribute("user", userDTO);
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
  
  // 아이디 중복 검사
  @GetMapping("/check")
  public ResponseEntity<Boolean> check(UserDTO userDTO) {
    if(userDTO.getNickName() != null) {
      return ResponseEntity.ok(userService.isNickNameAvailable(userDTO.getNickName()));
    } else if(userDTO.getAccountId() != null) {
      return ResponseEntity.ok(userService.isAccountIdAvailable(userDTO.getAccountId()));
    } else if(userDTO.getUserEmail() != null) {
      return ResponseEntity.ok(userService.isUserEmailAvailable(userDTO.getUserEmail()));
    } else {
      return ResponseEntity.badRequest().build();
    }
    
  }
  
  // 로그인 폼 보여주기
  @GetMapping("/login")
  public String loginForm() {
    return "user/login";
  }
  
  @PostMapping("/login")
  public String login(UserDTO user, HttpSession session, RedirectAttributes redirectAttr) {
    try {
      boolean loginResult = userService.login(user);
      
      // timeStamp 생성
      Date now = new Date();
      SimpleDateFormat stf = new SimpleDateFormat("yyyy/MM/dd HH:mm");
      String dateTimeStr = stf.format(now);
      Date date = stf.parse(dateTimeStr);
      Timestamp timestamp = new Timestamp(date.getTime());
      
      UserDTO userDTO = userService.getUserId(user.getAccountId());
      UserStatusDTO userLog = new UserStatusDTO(user.getAccountId(), userDTO.getUserId(), timestamp);
      if(!loginResult) {
        redirectAttr.addFlashAttribute("error", "아이디나 비밀번호를 확인 해주세요");
        return "redirect:/user/login";
      }
      // 세션 저장
      session.setAttribute("userId", userDTO.getUserId());
      session.setAttribute("accountId", user.getAccountId());
      session.setAttribute("userName", userDTO.getUserName());
      session.setAttribute("userEmail", userDTO.getUserEmail());
      // 로그 기록
      userService.insertLogStatus(userLog);
      // 로그 기록 후 메시지 띄우기
      redirectAttr.addFlashAttribute("msg", "로그인 성공!");
      return "redirect:/";
    } catch (Exception e) {
       e.printStackTrace();
       return "redirect:/user/login";
    }
  }
  @GetMapping("/logout")
  public String logout(HttpSession session) {
    session.invalidate();
    return "redirect:/";
  }
}
