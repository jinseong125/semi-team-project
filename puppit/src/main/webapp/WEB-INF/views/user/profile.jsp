<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<jsp:include page="../layout/header.jsp"></jsp:include>

<h1>프로필 페이지</h1>

<form action="${contextPath}/user/profile" method="post">

  <table border="1">
    <tr>
      <th>아이디</th>
      <td><input id="accountId" type="text" name="accountId" value="${sessionScope.sessionMap.accountId}"> <button type="button" id="checkIdBtn">중복확인</button></td>
    </tr>
    <tr>
      <th>이름</th>
      <td><input type="text" name="userName" value="${sessionScope.sessionMap.userName}"></td>
    </tr>
    <tr>
      <th>닉네임</th>
      <td><input id="nickName" type="text" name="nickName" value="${sessionScope.sessionMap.nickName}"> <button type="button" id="checkNickNameBtn">중복확인</button></td>
    </tr>
    <tr>
      <th>이메일</th>
      <td><input id="userEmail" type="text" name="userEmail" value="${sessionScope.sessionMap.userEmail}"> <button type="button" id="checkEmailBtn">중복확인</button></td>
    </tr>
  </table>
  <br>
  <button type="submit">적용</button>
</form>
  
<script type="text/javascript">

//아이디 중복 검사
document.getElementById("checkIdBtn").addEventListener("click", function(e) {
  // 빈 문자 입력
  const accountId = document.getElementById("accountId").value.trim();
  if(!accountId) {
    alert("아이디를 입력 해주세요");
    return;
  }
  // 아이디 형식 (정규식 검사) 소문자, 숫자 4~12자리
  const isRegex = /^[a-z0-9]{4,12}$/;
  if(!isRegex.test(accountId)) {
    alert("아이디 형식이 올바르지 않습니다 다시 입력 해주세요");
    return false;
  }
     fetch("${contextPath}/user/check?accountId=" + accountId)
     .then(response => {
        if(response.status === 200) {
         alert("사용 가능한 아이디 입니다");
         return;
      } else if(response.status === 409) {
         alert("중복 된 아이디 입니다");
         return;
      }
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
  // 닉네임 형식 (정규식 검사) 한글,영문,숫자 최소 4~8자리
  const isRegex = /^[A-Za-z0-9\uAC00-\uD7A3]{4,8}$/;
  if(!isRegex.test(nickName)) {
    alert("닉네임 형식이 올바르지 않습니다");
    return false;
  }
     fetch("${contextPath}/user/check?nickName=" + nickName)
       .then(response => {
          if(response.status === 200) {
            alert('사용 가능한 닉네임 입니다.');
        } else if(response.status === 409) {
              alert('중복된 닉네임 입니다.');
        }
     })
  })
  // 이메일 중복 검사
  document.getElementById("checkEmailBtn").addEventListener("click", function(e) {
    const userEmail = document.getElementById("userEmail").value.trim();
    if(!userEmail) {
      alert("이메일을 입력 해주세요");
      return;
    }
    // 이메일 정규식 검사
    const isRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if(!isRegex.test(userEmail)) {
      alert("이메일 형식이 올바르지 않습니다");
      return;
    }
    
    fetch("${contextPath}/user/check?userEmail=" + userEmail)
    .then(response => {
      if(response.status === 200) {
        alert('사용 가능한 이메일 입니다');
      } else if(response.status === 409) {
        alert('중복된 이메일 입니다');
      }
     })
  })
</script>
</body>
</html>