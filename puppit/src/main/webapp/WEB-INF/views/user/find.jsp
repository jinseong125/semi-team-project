<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="../layout/header.jsp">
  <jsp:param value="Home" name="title" />
</jsp:include>

<!-- 페이지 전용 스타일: 전역 body를 건드리지 않고, 메인 영역만 가운데 정렬 -->
<style>
:root{
  --page-bg: #f6f8fb;
  --card-bg: #ffffff;
  --accent-1: #5b21b6;
  --accent-2: #7c3aed;
  --muted: #6b7280;
  --danger: #dc2626;
  --radius: 14px;
  --shadow: 0 12px 28px rgba(15,23,42,0.06);
  --maxw: 480px;
  font-family: "Noto Sans KR", "Segoe UI", Roboto, -apple-system, BlinkMacSystemFont, "Helvetica Neue", Arial;
}

/* 메인 영역만 배경 + 중앙정렬 — header 높이에 따라 자동 보정(아래 JS 참고) */
.main-content{
  background: var(--page-bg);
  padding: 32px 20px;
  box-sizing: border-box;
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: calc(100vh - 120px); /* 헤더 높이 대략값 — JS가 런타임에 보정함 */
}

/* 카드 */
.find-wrap{
  width:100%;
  max-width:var(--maxw);
  background: var(--card-bg);
  border-radius: calc(var(--radius) + 4px);
  padding: 28px;
  box-shadow: var(--shadow);
  box-sizing: border-box;
  margin-top: -250px;
}

/* 제목 */
.title {
  text-align:center;
  font-size:1.125rem;
  font-weight:700;
  margin: 0 0 18px 0;
  color: #0f172a;
}

/* 폼 */
.find-form { display:flex; flex-direction:column; gap:14px; }
.form-group input[type="text"],
.form-group input[type="email"]{
  width:100%;
  padding:12px 16px;
  font-size:0.98rem;
  border-radius:10px;
  border:1px solid #e6e9ee;
  outline:none;
  background:#fff;
  transition: box-shadow .14s ease, border-color .14s ease;
  box-sizing: border-box;
}
.form-group input::placeholder { color: #bfc7d1; }
.form-group input:focus { border-color: rgba(92, 53, 255, 0.9); box-shadow: 0 8px 22px rgba(92,53,255,0.06); }

/* 버튼 */
.btn-primary{
  width:100%;
  padding:12px 16px;
  font-weight:700;
  font-size:1rem;
  color:#fff;
  border:none;
  border-radius:10px;
  cursor:pointer;
  background: linear-gradient(90deg, var(--accent-1), var(--accent-2));
  box-shadow: 0 10px 22px rgba(124,58,237,0.18);
}
.btn-primary:active { transform: translateY(0); opacity: .98; }

/* 메시지 영역 */
.msg { margin-top:10px; text-align:center; font-size:0.9rem; color:var(--danger); }

/* 반응형 */
@media (max-width: 520px){
  .main-content { padding:20px 12px; min-height: calc(100vh - 160px); }
  .find-wrap { padding:18px; border-radius:12px; }
  .title { font-size:1rem; }
}
</style>

<main class="main-content" id="mainContent">
  <div class="find-wrap" role="region" aria-labelledby="findTitle">
    <h1 id="findTitle" class="title">아이디/비밀번호 찾기</h1>

    <form id="find" action="${contextPath}/user/find" method="post" class="find-form" novalidate>
      <div class="form-group">
        <input type="text" name="userName" id="userName" placeholder="이름" required autocomplete="name">
      </div>
      <div class="form-group">
        <input type="email" name="userEmail" id="userEmail" placeholder="이메일" required autocomplete="email">
      </div>
      <button type="submit" id="id-find" class="btn-primary">아이디 찾기</button>
    </form>

    <div class="msg" id="resultMsg">${msg}</div>
  </div>
</main>

<!-- 헤더 높이에 따라 main 높이 보정 (헤더가 .header 클래스를 가질 때 작동) -->
<script>
(function () {
  function adjustMain() {
    var header = document.querySelector('.header');
    var main = document.getElementById('mainContent');
    if (!main) return;
    var headerHeight = header ? Math.ceil(header.getBoundingClientRect().height) : 0;
    // 최소값 보정 (헤더 없을땐 full height)
    var offset = Math.max(headerHeight, 0);
    main.style.minHeight = 'calc(100vh - ' + offset + 'px)';
  }
  window.addEventListener('load', adjustMain);
  window.addEventListener('resize', adjustMain);
  // header가 동적으로 바뀌면 수동으로 호출 가능: window.dispatchEvent(new Event('resize'));
})();
</script>