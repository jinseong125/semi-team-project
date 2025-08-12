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
          id="signupForm">
    <label>아이디: <input type="text" id="accountId" name="accountId"></label>
    <button type="button"  class="checkId" id="checkIdBtn">중복검사</button>
    <br>
    <label>비밀번호: <input type="password" id="userPassword" name="userPassword"></label>
    <br>
    <label>비밀번호 확인: <input type="password" id="checkpwd" name="checkpwd"></label>
    <br>
    <label>이름 : <input type="text" id="userName" name="userName"></label>
    <br>
    <label>닉네임 : <input type="text" id="nickName" name="nickName"></label>
    <button type="button" class="checkNickName" name="checkNickName">중복검사</button>
    <br>
    <label>휴대전화 : <input type="text" id="userPhone" name="userPhone"></label>
    <br>
    <label>이메일 : <input type="text" id="userEmail" name="userEmail"></label>  
    <br>
    <button type="submit">가입하기</button>
    </form>

<script>
  document.getElementById("signupForm").addEventListener("submit", function (e) {
    const requiredFields = [
      { id: "accountId", name: "아이디" },
      { id: "userPassword", name: "비밀번호" },
      { id: "userName", name: "이름" },
      { id: "nickName", name: "닉네임" },
      { id: "userPhone", name: "휴대전화" },
      { id: "userEmail", name: "이메일" }
    ];

    for (let field of requiredFields) {
      const value = document.getElementById(field.id).value.trim();
      if (!value) {
        alert(`${field.name}을(를) 입력해주세요.`);
        document.getElementById(field.id).focus(); // 커서 이동
        e.preventDefault();
        return;
      }
    }
  });
  document.getElementById("checkIdBtn").addEventListener("click", function(e) {
	  const accountId = document.getElementById("accountId").value;
	  if(accountId == null || accountId == "") {
		  alert("아이디를 입력 해주세요");
		  return;
	  }
	  fetch("${contextPath}/user/checkId?accountId=" + accountId)
	  		.then(response => response.json())
	  		.then(data => {
	  			console.log("data : " + data.available);
	  			if(!data.available) {
	  				alert("중복된 아이디 입니다");
	  			} else {
	  				alert("사용 가능한 아이디 입니다");
	  			}
	  		})
	  		.catch(error => {
	  			alert("서버 오류가 발생 했습니다");
	  		})
  })


</script>
    

    
	
	
</body>
</html>