package org.shark.crud.interceptor;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;

/*
 * 로그인이 안된 상태에서는 
 * 게시글 작성 화면 등으로 이동할 수 없도록 요청을 제어하는 인터셉터
 *  
 *  * */


public class LoginCheckInterceptor implements HandlerInterceptor{

  /*
   * 가로채기한 요청(request)과 응답(response)을 사용하는 preHandle() 메소드
   * 컨트롤러의 요청을 수행하기 전에 실행하기 때문에 메소드 이름이 preHandle(미리 처리)
   * 가로채기한 요청을 정상적으로 수행하려면 true 반환, 아니면 false 반환 
   * 
   * */
  
  
  
  
  @Override
  public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
    // 로그인 상태인지 확인하기 위해서 세션에서 nickname 가져오기
    HttpSession session = request.getSession();
    Object nickname = session.getAttribute("nickname");
    // 로그인 상태이면 통과 (컨트롤러 호출)
    if (nickname != null) {
      return true;
    } 
    // 로그인 상태가 아니면 로그인 페이지로 이동
    response.setHeader("Content-Type", "text/html; charset=UTF-8");
    PrintWriter out = response.getWriter();
    out.println("<script>");
    out.println("if (confirm('로그인이 필요한 기능입니다. 로그인을 할까요?')) {");
    out.println("location.href='" + request.getContextPath() + "/user/login?url="+request.getRequestURL()+"'");
    out.println("} else {");
    out.println("history.back()");
    out.println("}");
    out.println("</script>");
    out.close();
    
    
    return HandlerInterceptor.super.preHandle(request, response, handler);
  }
  
  
  
  
  
  
  
  
  
}
