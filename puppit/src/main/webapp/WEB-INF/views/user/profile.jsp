<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="../layout/header.jsp"></jsp:include>

<h1>프로필 페이지</h1>

<style>
  :root {
    --bg:#fff; --card:#fff; --text:#111; --muted:#6b7280;
    --line:#e5e7eb; --primary:#333333; --shadow:0 12px 28px rgba(0,0,0,.08);
  }
  body { background:var(--bg); }

  .profile-card{
    max-width:760px; margin:24px auto; padding:24px;
    background:var(--card); border-radius:16px; box-shadow:var(--shadow);
  }

  .profile-table{
    width:100%; border-collapse:separate; border-spacing:0;
    border:1px solid var(--line); border-radius:12px; overflow:hidden;
  }
  .profile-table th, .profile-table td{ padding:14px 16px; }
  .profile-table th{
    width:160px; background:#f9fafb; color:#374151; text-align:left; font-weight:700;
    border-bottom:1px solid #f1f5f9;
  }
  .profile-table td{ border-bottom:1px solid #f1f5f9; }
  .profile-table tr:last-child th,
  .profile-table tr:last-child td{ border-bottom:none; }

  .form-row{ display:flex; gap:8px; align-items:center; }
  .form-row input[type="text"]{
    flex:1 1 auto; height:42px; padding:0 12px;
    border:1px solid #d1d5db; border-radius:10px; font-size:14px; color:var(--text);
    outline:none; background:#fff;
  }
  .form-row input[type="text"]:focus{
    border-color:#111; box-shadow:0 0 0 3px rgba(0,0,0,.08);
  }

  .button{ height:42px; padding:0 14px; border:none; border-radius:10px;
           font-weight:700; cursor:pointer; }
  .button-check{ background:#eef2ff; color:#1f2937; border:1px solid #c7d2fe; }
  .button-check:hover{ background:#e0e7ff; }

  #btn-submit{
    width:240px; height:50px; margin:20px auto 0 auto;
    display:block;
    font-size:16px; font-weight:800; color:#fff; background:var(--primary);
    border:none; border-radius:12px; cursor:pointer;
  }
  #btn-submit:hover{ filter:brightness(1.08); }

  @media (max-width:600px){
    .profile-table th{ width:120px; }
    .form-row{ flex-direction:column; align-items:stretch; }
    .button-check{ width:100%; }
  }
</style>

<div class="profile-card">
<form action="${contextPath}/user/profile" method="post">
  <table class="profile-table">
    <tr>
      <th>아이디</th>
      <td>
        <div class="form-row">
          <input id="accountId" type="text" name="accountId" value="${sessionScope.sessionMap.accountId}" readOnly>
        </div>
      </td>
    </tr>
    <tr>
      <th>이름</th>
      <td>
        <div class="form-row">
          <input type="text" name="userName" value="${sessionScope.sessionMap.userName}">
        </div>
      </td>
    </tr>
    <tr>
      <th>닉네임</th>
      <td>
        <div class="form-row">
          <input id="nickName" type="text" name="nickName" value="${sessionScope.sessionMap.nickName}">
          <button type="button" class="button button-check" id="checkNickNameBtn">중복확인</button>
        </div>
      </td>
    </tr>
    <tr>
      <th>이메일</th>
      <td>
        <div class="form-row">
          <input id="userEmail" type="text" name="userEmail" value="${sessionScope.sessionMap.userEmail}">
          <button type="button" class="button button-check" id="checkEmailBtn">중복확인</button>
        </div>
      </td>
    </tr>
  </table>

  <button id="btn-submit" type="submit">수정</button>
</form>
</div>

  
<script type="text/javascript">

  let nicknameChecked = false;
  let emailChecked = false;


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
            nicknameChecked = true;
            return;
        } else if(response.status === 409) {
            alert('중복된 닉네임 입니다.');
            return;
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
        emailChecked = true;
        return;
      } else if(response.status === 409) {
        alert('중복된 이메일 입니다');
        return;
      }
     })
  })
  
  document.getElementById("btn-submit").addEventListener("click", e => {
	  if(!nicknameChecked || !emailChecked) {
		  if(!nicknameChecked) {
			  alert("닉네임 중복확인을 해주세요")
		  }
		  else if(!emailChecked) {
			  alert("이메일 중복확인을 해주세요")
		  }
		  e.preventDefault();
	  }
  })
</script>
</body>
</html>