<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ page import="java.util.Map" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<%
Map<String, Object> sessionMap = (Map<String, Object>) session.getAttribute("sessionMap");
String accountId = "";
Integer userId = 0;
if (sessionMap != null) {
    Object accountIdObj = sessionMap.get("accountId");
    if (accountIdObj != null) {
        accountId = accountIdObj.toString();
    }
    Object userIdObj = sessionMap.get("userId");
    if (userIdObj != null) {
        userId = Integer.parseInt(userIdObj.toString());
    }
}
%>

<c:set var="userId" value="<%= userId %>" />

<jsp:include page="/WEB-INF/views/layout/header.jsp?dt=<%=System.currentTimeMillis()%>"/>

<div class="detail-wrap">
  <!-- 좌측: 이미지 -->
  

<div class="detail-left">
  	
  	
	    <c:choose>
	      <c:when test="${product.thumbnail ne null and not empty product.thumbnail.imageUrl}">
	        <img class="productsPicture" src="${product.thumbnail.imageUrl}" alt="${product.productName}" class="main-img"/>
	      </c:when>
	     
	      <c:otherwise>
	        <div class="thumb-placeholder">이미지 없음</div>
	      </c:otherwise>
	    </c:choose>
 
  </div>



  <!-- 우측: 상품 정보 -->
  <div class="detail-right">
    <!-- 카테고리 -->
    <div class="breadcrumb">
      <c:choose>
        <c:when test="${product.category ne null and not empty product.category.categoryName}">
          ${product.category.categoryName}
        </c:when>
        <c:otherwise>${product.categoryId}</c:otherwise>
      </c:choose>
    </div>

    <!-- 상품명 -->
    <h1 class="title">${product.productName}</h1>

    <!-- 가격 -->
    <div class="price">
      <fmt:formatNumber value="${product.productPrice}" pattern="#,###"/>원
    </div>

    <!-- 상태 / 등록일 / 판매자 정보 -->
    <ul class="meta-list">
      <li>
        <span class="label">상품상태</span>
        <span class="value">
          <c:choose>
            <c:when test="${product.status ne null and not empty product.status.statusName}">
              ${product.status.statusName}
            </c:when>
            <c:otherwise>상태 코드: ${product.statusId}</c:otherwise>
          </c:choose>
        </span>
      </li>
      <li>
        <span class="label">등록일</span>
        <span class="value">
          <fmt:formatDate value="${product.productCreatedAt}" pattern="yyyy.MM.dd HH:mm"/>
        </span>
      </li>
      <li>
        <span class="label">판매자 ID</span>
        <span>${product.sellerId}</span>
		  </li>
    </ul>



	

    <!-- 버튼 영역 -->
    <div class="buttons">
      <!-- 내 상품일 때만 수정/삭제 -->
      <c:set var="sessionMap" value="${sessionScope.sessionMap}" />
      <c:if test="${sessionMap.userId eq product.sellerId}">
        <a href="${contextPath}/product/edit/${product.productId}" class="btn outline">상품 수정</a>
        <form action="${contextPath}/product/delete" method="post" style="display:inline;">
          <input type="hidden" name="productId" value="${product.productId}"/>
          <button type="submit" class="btn outline"
                  onclick="return confirm('정말 삭제하시겠습니까?');">상품 삭제</button>
        </form>
      </c:if>
	

      <!-- 공통 버튼 -->
      <button type="button" class="btn outline" onclick="history.back()">목록</button>
      <c:if test="${sessionMap.userId ne product.sellerId}">
        <button
          id="btnWish"
          class="btn outline wish-btn ${product.wished ? 'is-on' : ''}"
          data-product-id="${product.productId}"
          aria-pressed="${product.wished ? 'true' : 'false'}"
          title="찜">
          <i class="fa-regular fa-heart icon off"></i>
          <i class="fa-solid fa-heart icon on"></i>
          <span class="text">찜</span>
        </button>
        <button type="button" class="btn solid" id="btnPay">채팅하기</button>
      </c:if>
    </div>
  </div>
</div>

<!-- 상세 설명 -->
<div class="detail-desc">
  <h2>상품정보</h2>
  <c:choose>
    <c:when test="${not empty product.productDescription}">
      <pre class="desc"><c:out value="${product.productDescription}"/></pre>
    </c:when>
    <c:otherwise>
      <div class="empty">등록된 설명이 없습니다.</div>
    </c:otherwise>
  </c:choose>
</div>

<style>

.wish-btn { border:0; background:transparent; cursor:pointer; }
.wish-btn .on { display:none; }
.wish-btn.is-on .on { display:inline; }
.wish-btn.is-on .off { display:none; }
.wish-btn {
  display:inline-flex;
  align-items:center;
  gap:8px;
  border-radius:8px;
  padding:10px 14px;
  line-height:1;
}

.wish-btn .icon { font-size:16px; }
.wish-btn .on { display:none; }        /* 기본: 빈 하트 */
.wish-btn.is-on .on { display:inline; }/* 찜 상태: 꽉 찬 하트 */
.wish-btn.is-on .off { display:none; }

/* 찜 상태일 때 살짝 강조 */
.wish-btn.is-on {
  border-color:#ff7b8a;
  background:#fff7f8;
  color:#d94164;
}

.detail-wrap {
  max-width:1100px; margin:40px auto; padding:0 20px;
  display:flex; gap:32px;
}
.detail-left {
  flex: 1;
  width: 100%;
  max-width: 500px;   /* 원하는 가로 크기 */
  height: 500px;      /* 원하는 세로 크기 */
  border: 1px solid #eee;
  border-radius: 12px;
  overflow: hidden;   /* 이미지 넘치면 잘리게 */
  display: flex;
  justify-content: center;
  align-items: center;
  background: #fafafa; /* 빈공간 배경 */
}

.detail-left img {
  width: 100%;
  height: 100%;
  object-fit: contain;   /* 박스에 꽉 채우되 잘릴 수 있음 */
  /* object-fit: contain;  잘리지 않고 다 보이지만 여백 생김 */
}


.main-img {
  width:100%; max-height: 500px;
  border-radius:12px; border:1px solid #eee;
  object-fit:contain;
}
.detail-right { flex:1; display:flex; flex-direction:column; gap:14px; }
.breadcrumb { font-size:14px; color:#6b7280; }
.title { font-size:24px; font-weight:700; margin:4px 0; }
.price { font-size:22px; font-weight:600; color:#111; }
.meta-list { list-style:none; padding:0; margin:8px 0; }
.meta-list li { font-size:14px; margin:6px 0; }
.label { color:#6b7280; margin-right:6px; }
.value { color:#111; }
.buttons { display:flex; gap:10px; margin-top:16px; flex-wrap:wrap; }
.btn {
  padding:10px 18px; border-radius:8px; font-size:15px; cursor:pointer;
}
.btn.solid { background:#0073e6; color:#fff; border:none; flex:1; text-align:center; }
.btn.outline { background:#fff; border:1px solid #d1d5db; color:#111; }
.detail-desc {
  max-width:1100px; margin:30px auto; padding:20px;
  border:1px solid #eee; border-radius:12px; background:#fafafa;
}
.detail-desc h2 { font-size:18px; font-weight:700; margin-bottom:12px; }
.desc { white-space:pre-wrap; line-height:1.6; font-size:15px; }
.empty { color:#6b7280; font-size:14px; }
.productsPicture {width:200px; height:250px;}


</style>

<script>
const appContext = "${contextPath}";

(function() {
  const btn = document.getElementById('btnWish');
  if (!btn) return;

  let busy = false;

  btn.addEventListener('click', async () => {
    if (busy) return;
    busy = true;

    const productId = btn.dataset.productId;
    const wasOn = btn.classList.contains('is-on');

    // 1) 낙관적 UI
    btn.classList.toggle('is-on', !wasOn);
    btn.setAttribute('aria-pressed', String(!wasOn));

    try {
      const res = await fetch(appContext + "/wish/toggle", {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
          "Accept": "application/json"
        },
        body: new URLSearchParams({ productId })
      });

      const data = await res.json();

      if (!data.ok) {
    	  btn.classList.toggle('is-on', wasOn);
    	  btn.setAttribute('aria-pressed', String(wasOn));
    	  if (data.reason === 'UNAUTH') {
    	    alert('로그인이 필요합니다.');
    	    location.href = appContext + '/user/login';
    	  } else {
    	    alert('처리 중 오류: ' + (data.message || ''));
    	  }
    	  return;
    	}

      // 3) 서버 판단에 맞춰 최종 확정(혹시 불일치 시 교정)
      btn.classList.toggle('is-on', !!data.added);
      btn.setAttribute('aria-pressed', String(!!data.added));

      // 필요하면 data.count로 카운트 배지 업데이트
      // document.querySelector('#wishCount')?.textContent = data.count;

    } catch (e) {
      // 네트워크 오류: 롤백
      btn.classList.toggle('is-on', wasOn);
      btn.setAttribute('aria-pressed', String(wasOn));
      alert('네트워크 오류가 발생했습니다.');
    } finally {
      busy = false;
    }
  });
})();

document.addEventListener("DOMContentLoaded", () => {
  const productId = "${product.productId}";
  getProductFetch(productId);
});

document.getElementById('btnPay')?.addEventListener('click', function() {
  const productId = "${product.productId}";
  const buyerId = "${userId}";
  const sellerId = "${product.sellerId}";
  const loginUserId = "${sessionScope.sessionMap.accountId}"; // JSP에서 세션 값을 직접 가져옴
  console.log("sellerId: ", sellerId);

  // 🚩 로그인 체크
  if (!loginUserId || buyerId === "0" || !buyerId) {
    alert("채팅을 하시려면 먼저 로그인해주세요.");
    window.location.href = appContext + "/user/login";
    return;
  }

  // 판매자와 구매자가 같을 때
  if (buyerId === sellerId) {
    alert("상품에 등록된 판매자와 구매자가 같아서 채팅할 수 없습니다");
    return;
  } else {
    window.location.href = appContext + "/chat/createRoom?productId=" + productId + "&buyerId=" + buyerId + "&sellerId=" + sellerId;
  }
});

async function getProductFetch(productId) {
  try {
    const res = await fetch(appContext + "/api/product/detail/" + productId, {
      method: "GET",
      headers: {
        "Accept": "application/json"
      }
    });
    if (!res.ok) {
      throw new Error("HTTP 오류 " + res.status);
    }

    const data = await res.json();
    console.log("[getProductFetch] 응답:", data);

    // 필요하다면 DOM 업데이트 처리 가능
  } catch (err) {
    console.error("상품 조회 실패:", err);
  }
}
</script>

