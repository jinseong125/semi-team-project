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

  /* 수정 버튼 (form 밖) */
  #btn-submit{
    height:50px; padding:0 16px; border-radius:12px;
    font-size:16px; font-weight:800; color:#fff; background:var(--primary);
    border:none; cursor:pointer;
  }
  #btn-submit:hover{ filter:brightness(1.08); }

  /* 버튼 배치용 래퍼 (폼 밖) */
  .actions {
    display:flex; gap:12px; align-items:center; justify-content:flex-start;
    max-width:760px; margin:12px auto 0 auto;
  }

  /* 탈퇴 버튼 (outline-danger 톤) */
  #btn-delete{
    height:50px; padding:0 16px; border-radius:12px; font-size:16px; font-weight:800;
    background:#fff; color:#b91c1c; border:1px solid #ef4444; cursor:pointer;
  }
  #btn-delete:hover{ background:#fee2e2; }

  /* 탈퇴 확인 박스 */
  .danger-box{
    max-width:760px; margin:12px auto 0 auto; padding:16px;
    border:1px solid #fecaca; background:#fff1f2; border-radius:12px;
    display:none;
  }
  .danger-title{ margin:0 0 8px; color:#991b1b; font-weight:800; }
  .danger-desc{ margin:0 0 10px; color:#7f1d1d; font-size:.95rem; }
  .danger-row{ display:flex; gap:8px; align-items:center; }
  #agreementInput{
    flex:1 1 auto; height:44px; padding:0 12px; border:1px solid #fca5a5; border-radius:10px;
    background:#fff; outline:none; font-size:14px;
  }
  #agreementInput:focus{ border-color:#ef4444; box-shadow:0 0 0 3px rgba(239,68,68,.15); }
  #btn-confirm-delete{
    height:44px; padding:0 14px; border-radius:10px; border:none; cursor:pointer;
    background:#dc2626; color:#fff; font-weight:800;
  }
  #btn-confirm-delete:hover{ filter:brightness(1.05); }

  @media (max-width:600px){
    .profile-table th{ width:120px; }
    .form-row{ flex-direction:column; align-items:stretch; }
    .button-check{ width:100%; }
    .danger-row{ flex-direction:column; align-items:stretch; }
  }
</style>

<div class="profile-card">
  <form id="profileForm" action="${contextPath}/user/profile" method="post">
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
  </form>
</div>

<<<<<<< HEAD
<script type="text/javascript">
  // 원래 값(서버에서 내려준 값 그대로)
  const originalNick  = "${sessionScope.sessionMap.nickName}";
  const originalEmail = "${sessionScope.sessionMap.userEmail}";

  const $nick   = document.getElementById("nickName");
  const $email  = document.getElementById("userEmail");
  const $btnNick= document.getElementById("checkNickNameBtn");
  const $btnMail= document.getElementById("checkEmailBtn");
  const $submit = document.getElementById("btn-submit");

  // 현재 값이 원래 값이면 이미 통과로 간주
  let nicknameChecked = ($nick.value.trim()  === (originalNick  ?? "").trim());
  let emailChecked    = ($email.value.trim() === (originalEmail ?? "").trim());

  // 유효성 정규식
  const reNick  = /^[A-Za-z0-9\uAC00-\uD7A3]{4,8}$/;
  const reEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

  // 입력이 변경되면 “검사 필요” 상태로 전환 (단, 원래 값으로 되돌리면 다시 통과)
  $nick.addEventListener("input", () => {
    const v = $nick.value.trim();
    nicknameChecked = (v === (originalNick ?? "").trim());
  });

  $email.addEventListener("input", () => {
    const v = $email.value.trim();
    emailChecked = (v === (originalEmail ?? "").trim());
  });

  // 닉네임 중복검사
  $btnNick.addEventListener("click", async () => {
    const nick = $nick.value.trim();
    if (!nick) { alert("닉네임을 입력 해주세요"); return; }

    // 원래 값이면 검사 없이 통과
    if (nick === (originalNick ?? "").trim()) {
      nicknameChecked = true;
      alert("현재 사용 중인 닉네임입니다. 사용 가능합니다.");
      return;
    }

    if (!reNick.test(nick)) { alert("닉네임 형식이 올바르지 않습니다 (한글/영문/숫자 4~8자)"); return; }

    try {
      const res = await fetch(`${"${contextPath}"}/user/check?nickName=${encodeURIComponent(nick)}`);
      if (res.status === 200) {
        nicknameChecked = true;
        alert("사용 가능한 닉네임입니다.");
      } else if (res.status === 409) {
        nicknameChecked = false;
        alert("중복된 닉네임입니다.");
      } else {
        nicknameChecked = false;
        alert("닉네임 확인 중 오류가 발생했습니다.");
      }
    } catch(e) {
      nicknameChecked = false;
      alert("네트워크 오류가 발생했습니다.");
    }
  });

  // 이메일 중복검사
  $btnMail.addEventListener("click", async () => {
    const mail = $email.value.trim();
    if (!mail) { alert("이메일을 입력 해주세요"); return; }

    // 원래 값이면 검사 없이 통과
    if (mail === (originalEmail ?? "").trim()) {
      emailChecked = true;
      alert("현재 사용 중인 이메일입니다. 사용 가능합니다.");
      return;
    }

    if (!reEmail.test(mail)) { alert("이메일 형식이 올바르지 않습니다"); return; }

    try {
      const res = await fetch(`${"${contextPath}"}/user/check?userEmail=${encodeURIComponent(mail)}`);
      if (res.status === 200) {
        emailChecked = true;
        alert("사용 가능한 이메일입니다.");
      } else if (res.status === 409) {
        emailChecked = false;
        alert("중복된 이메일입니다.");
      } else {
        emailChecked = false;
        alert("이메일 확인 중 오류가 발생했습니다.");
      }
    } catch(e) {
      emailChecked = false;
      alert("네트워크 오류가 발생했습니다.");
    }
  });

  // 제출: “변경된 항목만” 검사 완료 요구
  $submit.addEventListener("click", (e) => {
    const nickChanged  = $nick.value.trim()  !== (originalNick  ?? "").trim();
    const emailChanged = $email.value.trim() !== (originalEmail ?? "").trim();

    if ((nickChanged && !nicknameChecked) || (emailChanged && !emailChecked)) {
      e.preventDefault();
      if (nickChanged && !nicknameChecked)  alert("닉네임 중복확인을 해주세요.");
      else if (emailChanged && !emailChecked) alert("이메일 중복확인을 해주세요.");
    }
=======
<!-- 폼 밖: 수정/탈퇴 액션 -->
<div class="actions">
  <!-- 수정: JS로 profileForm submit -->
  <button id="btn-submit" type="button" class="button">수정</button>

  <!-- 회원 탈퇴: 별도의 POST 폼 (문구 입력만) -->
  <form id="deleteForm" action="${contextPath}/user/delete" method="post" style="display:inline;">
    <input type="hidden" name="agreement" id="agreementHidden">
    <c:if test="${not empty _csrf}">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    </c:if>
    <button type="button" id="btn-delete">회원 탈퇴</button>
  </form>
</div>

<!-- 탈퇴 확인 박스 (문구 입력) -->
<div id="dangerBox" class="danger-box" aria-hidden="true">
  <h3 class="danger-title">탈퇴 전 최종 확인</h3>
  <p class="danger-desc">아래 문구를 정확히 입력해야 탈퇴가 진행됩니다.</p>
  <p class="danger-desc"><strong>회원 탈퇴 하겠습니다 이에 동의 합니다</strong></p>
  <div class="danger-row">
    <input type="text" id="agreementInput" placeholder="위 문구를 입력해주세요">
    <button type="button" id="btn-confirm-delete">탈퇴 진행</button>
  </div>
</div>

<script type="text/javascript">
  let nicknameChecked = false;
  let emailChecked = false;

  // 닉네임 중복 검사
  document.getElementById("checkNickNameBtn").addEventListener("click", function(e) {
    const nickName = document.getElementById("nickName").value.trim();
    if(!nickName) { alert("닉네임을 입력 해주세요"); return; }
    const isRegex = /^[A-Za-z0-9\uAC00-\uD7A3]{4,8}$/;
    if(!isRegex.test(nickName)) { alert("닉네임 형식이 올바르지 않습니다"); return; }

    fetch("${contextPath}/user/check?nickName=" + encodeURIComponent(nickName))
      .then(response => {
        if(response.status === 200) { alert('사용 가능한 닉네임 입니다.'); nicknameChecked = true; return; }
        else if(response.status === 409) { alert('중복된 닉네임 입니다.'); return; }
      });
  });

  // 이메일 중복 검사
  document.getElementById("checkEmailBtn").addEventListener("click", function(e) {
    const userEmail = document.getElementById("userEmail").value.trim();
    if(!userEmail) { alert("이메일을 입력 해주세요"); return; }
    const isRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if(!isRegex.test(userEmail)) { alert("이메일 형식이 올바르지 않습니다"); return; }

    fetch("${contextPath}/user/check?userEmail=" + encodeURIComponent(userEmail))
      .then(response => {
        if(response.status === 200) { alert('사용 가능한 이메일 입니다'); emailChecked = true; return; }
        else if(response.status === 409) { alert('중복된 이메일 입니다'); return; }
      });
  });

  // 수정 (form 밖 버튼 → form submit)
  document.getElementById("btn-submit").addEventListener("click", e => {
    if(!nicknameChecked || !emailChecked) {
      if(!nicknameChecked) alert("닉네임 중복확인을 해주세요");
      else if(!emailChecked) alert("이메일 중복확인을 해주세요");
      return;
    }
    document.getElementById("profileForm").submit();
  });

  // 회원 탈퇴 플로우 (문구 입력 박스 토글)
  const PHRASE = "회원 탈퇴 하겠습니다 이에 동의 합니다";
  const dangerBox = document.getElementById("dangerBox");
  const agreementInput = document.getElementById("agreementInput");
  const agreementHidden = document.getElementById("agreementHidden");

  document.getElementById("btn-delete").addEventListener("click", function() {
    const visible = dangerBox.style.display === "block";
    dangerBox.style.display = visible ? "none" : "block";
    dangerBox.setAttribute("aria-hidden", visible ? "true" : "false");
    if (!visible) {
      agreementInput.value = "";
      setTimeout(() => agreementInput.focus(), 0);
    }
  });

  // 최종 탈퇴 진행
  document.getElementById("btn-confirm-delete").addEventListener("click", function() {
    const val = agreementInput.value.trim();
    if (val !== PHRASE) {
      alert("동의 문구가 정확히 일치해야 합니다.");
      agreementInput.focus();
      return;
    }
    if (!confirm("정말 탈퇴하시겠습니까? 복구할 수 없습니다.")) return;

    agreementHidden.value = val;
    document.getElementById("deleteForm").submit();
>>>>>>> 86380a8 (회원 탈퇴 기능 구현)
  });
</script>
  

</body>
</html>