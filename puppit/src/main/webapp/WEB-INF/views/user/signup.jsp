<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Insert title here</title>
</head>
<style>
  h1 {
  text-align : center;
  }
  
  #signForm {
  border : 1px solid black;
  text-align : center;
  }
</style>
<body>
	<h1>Puppit 회원가입</h1>
    <hr>
    <h1>기본정보</h1>
    <form action="${contextPath}/user/signup"
          method="post"
          id="signForm">
    <label>아이디: <input type="text" name="accountId"></label>
    <br>
    <label>비밀번호: <input type="password" name="userPassword"></label>
    <br>
    <label>비밀번호 확인: <input type="password" name="checkpwd"></label>
    <br>
    <label>이름 : <input type="text" name="userName"></label>
    <br>
    <label>닉네임 : <input type="text" name="nickName"></label>
    <br>
    <label>휴대전화 : <input type="text" name="userPhone"></label>
    <br>
    <label>이메일 : <input type="text" name="userEmail"></label>  
    <br>
    <button type="submit">가입하기</button>
    </form>
    

    
	
	
</body>
</html>