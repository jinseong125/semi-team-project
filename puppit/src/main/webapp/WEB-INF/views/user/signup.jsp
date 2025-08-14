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
<body>
	<h1>Puppit 회원가입</h1>
    <hr>
    <h1>기본정보</h1>
    <form action="${contextPath}/user/signup"
          method="post"
          id="signupForm">
     
    <label>아이디: <input type="text" id="accountId" name="accountId"></label>
    <button type="button"  class="checkId" id="checkIdBtn">중복검사</button>
      <c:if test="${not empty error}">
        <div style="font-size: 12px; color: red;">${error}</div>
      </c:if>
    <br>
    <label>비밀번호: <input type="password" id="userPassword" name="userPassword"></label>
    <br>
    <label>비밀번호 확인: <input type="password" id="checkPwd" name="checkPwd"></label>
    <br>
    <label>이름 : <input type="text" id="userName" name="userName"></label>
    <br>
    <label>닉네임 : <input type="text" id="nickName" name="nickName"></label>
    <button type="button" class="checkNickName" id="checkNickNameBtn">중복검사</button>
    <br>
    <label>휴대전화 : <input type="text" id="userPhone" name="userPhone"></label>
    <br>
    <label>이메일 : <input type="text" id="userEmail" name="userEmail"></label> 
    <button type="button"  class="checkEmail" id="checkEmailBtn">중복검사</button>
    <br>
    <button type="submit" onclick="return vailablePassword()">가입하기</button>
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
  // 아이디 중복 검사
  document.getElementById("checkIdBtn").addEventListener("click", function(e) {
	  // 빈 문자 입력
	  const accountId = document.getElementById("accountId").value.trim();
	  if(!accountId) {
		  alert("아이디를 입력 해주세요");
		  return;
	  }
	  // 아이디 형식 (정규식 검사)
	  const isRegex = /^[a-z0-9]{4,12}$/;
	  if(!isRegex.test(accountId)) {
		  alert("아이디 형식이 올바르지 않습니다");
		  return false;
	  }
	     fetch("${contextPath}/user/check?accountId=" + accountId)
         .then(response => {
            if(response.status == '409') {
            	alert('중복된 아이디입니다.');
            }
            else alert('사용 가능한 아이디 입니다.');
         })
  })
	// 닉네임 중복 검사
  	document.getElementById("checkNickNameBtn").addEventListener("click", function(e) {
	  // 빈 문자 입력
	  const nickName = document.getElementById("nickName").value.trim();
	  if(!nickName) {
		  alert("닉네임을 입력 해주세요");
		  return;
	  }
	  // 닉네임 형식 (정규식 검사)
/* 	  const isRegex = /^[a-z0-9]{4,12}$/;
	  if(!isRegex.test(nickName)) {
		  alert("닉네임 형식이 올바르지 않습니다");
		  return false;
	  } */
	     fetch("${contextPath}/user/check?nickName=" + nickName)
         .then(response => {
            if(response.status == '409') {
            	alert('중복된 닉네임입니다.');
            }
            else alert('사용 가능한 닉네임 입니다.');
         })
  	})
  	// 이메일 중복 검사
  	document.getElementById("checkEmailBtn").addEventListener("click", function(e) {
  		const email = document.getElementById("userEmail").value.trim();
  		if(!email) {
  			alett("이메일을 입력 해주세요");
  			return;
  		}
  		// 이메일 정규식 검사
  		
  	  fetch("${contextPath}/user/check?userEmail=" + userEmail)
  	  .then(response => {
  		  if(response.status == '409') {
  			  alert('중복된 이메일 입니다');
  		  }
  		  else alert('사용 가능한 이메일 입니다');
  	  })
  	})
  	// 비밀번호 체크
  	function vailablePassword() {
	  
  	const password = document.getElementById("userPassword").value;
  	const checkPwd = document.getElementById("checkPwd").value;
  	if(password === "" || checkPwd === "") {
  		alert("비밀번호를 모두 입력해 주세요");
  		return false;
  	}
  	if(password != checkPwd) {
  		alert("비밀번호가 일치하지 않습니다");
  		return false;
  	}
  		return true;
    }
  	// controller에서 메시지 전송 받기
	 const msg = "${msg}";
     if (msg && msg.trim() !== "") {
         alert(msg);
     }
</script>
	
</body>
</html>