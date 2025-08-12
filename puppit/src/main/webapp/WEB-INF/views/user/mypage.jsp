<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="../layout/header.jsp">
  <jsp:param value="Home" name="title"/>
</jsp:include>

<style>
  :root{
    --bg:#f7f8fa; --card:#fff; --text:#111; --muted:#8a8f98; --primary:#4f86ff;
    --line:#dfe3ea; --shadow:0 8px 24px rgba(0,0,0,.08);
  }
  *{box-sizing:border-box;}
  body{margin:0;background:var(--bg);font-family:system-ui, -apple-system, "Segoe UI", Roboto, "Noto Sans KR", sans-serif;color:var(--text);}
  .wrap{max-width:720px;margin:0 auto;padding:20px;}
  .topbar{display:flex;align-items:center;gap:8px;margin-bottom:16px;}
  .back-btn {
    border: none;
    background-color: #f7f8fa;
    font-size: 20px;   
    color: #333;       
    cursor: pointer;   
  }
    .title{font-weight:700;font-size:20px;}

  /* 프로필 카드 */
  .profile{
    display:flex;align-items:center;gap:16px;background:var(--card);border:1px solid var(--line);
    border-radius:16px;padding:16px;box-shadow:var(--shadow);
  }
  .avatar{
    width:64px;height:64px;border-radius:50%;overflow:hidden;flex:0 0 64px;border:2px solid #eee;background:#fafafa;
  }
  .avatar img{width:100%;height:100%;object-fit:cover;}
  .who{flex:1;}
  .nick{font-weight:700;font-size:18px;}
  .edit{
    margin-left:auto;background:#8e8e8e;color:#fff;border:none;border-radius:10px;padding:10px 14px;
    cursor:pointer;opacity:.95;transition:.15s;white-space:nowrap;
  }
  .edit:hover{opacity:1}

  /* 포인트 카드 — 살짝 컴팩트 */
  .point-card{
    margin-top:18px;background:var(--card);border:1px solid var(--line);border-radius:20px;
    padding:18px;box-shadow:var(--shadow);
  }
  .point-head{display:flex;justify-content:space-between;align-items:center;margin-bottom:12px;}
  .point-title{font-weight:800;font-size:18px;}

  .point-row{display:flex;align-items:center;gap:12px;margin:8px 0 16px;}
  .p-icon {
      width: 28px;           
      height: 28px;
      border-radius: 50%;    
      overflow: hidden;      
      display: flex;
      align-items: center;   
      justify-content: center; 
      background: transparent; 
    }
    
    .p-icon img {
      width: 100%;          
      height: 100%;
      object-fit: cover;    
    }
  .p-amount{font-size:28px;font-weight:800;letter-spacing:.5px;}

  .charge{
    margin-top:6px;width:100%;height:56px;border:none;border-radius:14px;background:var(--primary);
    color:#fff;font-weight:800;font-size:18px;cursor:pointer;box-shadow:0 6px 16px rgba(79,134,255,.35);
    transition:transform .05s ease;
  }
  .charge:active{transform:translateY(1px)}

  /* 아래 확장 공간 */
  .future-area{
    margin-top:18px; min-height:280px; 
    border:1px dashed #cfd6e3;border-radius:14px;background:#ffffff80;display:grid;place-items:center;color:#99a2b3;
  }

  /* 반응형 */
  @media (min-width:768px){
    .avatar{width:72px;height:72px;}
    .p-amount{font-size:32px;}
  }
</style>
<div class="wrap">
    <div class="topbar">
      <button class="back-btn" onclick="history.back()" aria-label="뒤로가기">
        <i class="fa-solid fa-arrow-left"></i>
      </button>
      <div class="title">마이페이지</div>
    </div>

    <!-- 프로필 -->
    <div class="profile">
      <div class="avatar">
        <img src="${contextPath}/resources/image/profile-default.png" alt="프로필 이미지" />
      </div>
      <div class="who">
        <div class="nick">${user.nickName != null ? user.nickName : 'happy'}</div>
      </div>
      <button class="edit" type="button" onclick="location.href='${contextPath}/user/profile'">프로필 수정</button>
    </div>

    <!-- 포인트 카드 (컴팩트) -->
    <div class="point-card">
      <div class="point-head">
        <div class="point-title">포인트</div>
      </div>
      <div class="point-row">
        <div class="p-icon">
          <img src="${contextPath}/resources/image/point-icon.png" alt="포인트" />
        </div>
        <div class="p-amount">
          <c:choose>
            <c:when test="${not empty user.point}">
              <fmt:formatNumber value="${user.point}" type="number"/>
            </c:when>
            <c:otherwise>0</c:otherwise>
          </c:choose>
        </div>
      </div>
      <button class="charge" type="button" onclick="location.href='${contextPath}/payment/paymentForm'">충전하기</button>
    </div>

    <!-- 향후 기능 영역 -->
    <div class="future-area">
      여기에 나중에 기능(쿠폰, 구매내역, 적립내역 등)을 추가할 공간입니다.
      <div>user.nickName: ${user.nickName}</div>
      <div>user.point: ${user.point}</div>
    </div>
</div>

</body>
</html>