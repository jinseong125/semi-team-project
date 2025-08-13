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
  /* 기본 리셋(가벼운) */
  * { box-sizing: border-box; }
  body {
    font-family: "Noto Sans KR", "Apple SD Gothic Neo", Arial, sans-serif;
    margin: 0;
    padding: 24px;
    background: #fafafa;
    color: #222;
  }

  /* 페이지 중앙 정렬 컨테이너 */
  .page-wrap {
    display: flex;
    justify-content: center;
    padding: 12px;
  }

  /* 컨텐츠 박스: 내용 너비에 맞게(inline-block) */
  .card {
    display: inline-block;            /* 내용 너비에 맞춤 */
    width: 680px;                     /* 기본 너비 (원하면 줄이거나 제거) */
    max-width: 95vw;                  /* 작은 화면에 맞춤 */
    background: #fff;
    border: 1px solid #ddd;
    border-radius: 8px;
    padding: 28px 36px;
    box-shadow: 0 6px 18px rgba(20,20,20,0.05);
  }

  /* 제목 스타일 */
  .card h1 {
    margin: 0 0 8px 0;
    font-size: 28px;
    text-align: center;
    letter-spacing: -0.5px;
  }
  .card .section-title {
    margin: 18px 0 12px 0;
    font-size: 20px;
    text-align: center;
    font-weight: 700;
  }

  /* 폼 레이아웃: 2열 그리드 (label | input) */
  .form-grid {
    display: grid;
    grid-template-columns: 140px 1fr; /* 왼쪽 라벨 고정, 오른쪽은 자동 */
    gap: 10px 16px;                   /* 행 간격 / 열 간격 */
    align-items: center;
    width: 100%;
  }

  /* 라벨 정렬 (오른쪽 정렬) */
  .form-grid label {
    justify-self: end;
    font-weight: 600;
    font-size: 14px;
  }

  /* 입력 요소 공통 스타일 */
  .form-grid input[type="text"],
  .form-grid input[type="password"],
  .form-grid input[type="email"],
  .form-grid input[type="tel"] {
    width: 100%;
    padding: 8px 10px;
    border: 1px solid #cfcfcf;
    border-radius: 6px;
    font-size: 14px;
  }

  /* 검사 버튼(중복검사) 스타일 - 입력과 같은 줄에 위치하도록 */
  .check-row {
    display: flex;
    gap: 8px;
    align-items: center;
  }
  .check-btn {
    padding: 6px 10px;
    font-size: 13px;
    border: 1px solid #bbb;
    background: #f5f5f5;
    border-radius: 6px;
    cursor: pointer;
  }
  .check-btn:hover { background: #eee; }

  /* 전체 폼 하단의 가입 버튼 중앙 배치 */
  .actions {
    margin-top: 18px;
    text-align: center;
  }
  .submit-btn {
    padding: 8px 16px;
    font-size: 14px;
    border-radius: 6px;
    border: none;
    background: linear-gradient(180deg,#3b82f6,#2563eb);
    color: #fff;
    cursor: pointer;
    box-shadow: 0 6px 12px rgba(37,99,235,0.15);
  }
  .submit-btn:hover { opacity: 0.95; }

  /* 작은 화면에서 레이블을 위로 쌓이게 */
  @media (max-width: 520px) {
    .form-grid { grid-template-columns: 1fr; }
    .form-grid label { justify-self: start; }
  }
</style>
</head>
<body>
  <div class="page-wrap">
    <div class="card">
      <h1>Puppit 회원가입</h1>
      <div class="section-title">기본정보</div>

      <form id="signupForm" action="/user/signup" method="post">
        <div class="form-grid">
          <label for="accountId">아이디:</label>
          <div class="check-row">
            <input id="accountId" name="accountId" type="text" />
            <button id="checkIdBtn" type="button" class="check-btn">중복검사</button>
          </div>

          <label for="userPassword">비밀번호:</label>
          <input id="userPassword" name="userPassword" type="password" />

          <label for="userPasswordConfirm">비밀번호 확인:</label>
          <input id="userPasswordConfirm" name="userPasswordConfirm" type="password" />

          <label for="userName">이름:</label>
          <input id="userName" name="userName" type="text" />

          <label for="nickName">닉네임:</label>
          <div class="check-row">
            <input id="nickName" name="nickName" type="text" />
            <button id="checkNickNameBtn" type="button" class="check-btn">중복검사</button>
          </div>

          <label for="phone">휴대전화:</label>
          <input id="phone" name="phone" type="tel" />

          <label for="email">이메일:</label>
          <input id="email" name="email" type="email" />

        </div>

        <div class="actions">
          <button type="submit" class="submit-btn">가입하기</button>
        </div>
      </form>
    </div>
  </div>
</body>
</html>

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
</script>
	
</body>
</html>