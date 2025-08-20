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
      <c:when test="${product.thumbnail ne null and not empty product.thumbnail.url}">
        <img src="${product.thumbnail.url}" alt="${product.productName}" class="main-img"/>
      </c:when>
      <c:when test="${product.thumbnail ne null and not empty product.thumbnail.imageUrl}">
        <img src="${product.thumbnail.imageUrl}" alt="${product.productName}" class="main-img"/>
      </c:when>
      <c:when test="${product.thumbnail ne null and not empty product.thumbnail.path}">
        <img src="${product.thumbnail.path}" alt="${product.productName}" class="main-img"/>
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

    <!-- 상태 / 등록일 -->
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
   <%--    <li>
	       <span class="value">
			 <c:choose>
			   <c:when test="${not empty product.location}">
			     ${product.location}
			   </c:when>
			   <c:otherwise>지역 정보 없음</c:otherwise>
			 </c:choose>
		  </span>
	    </li> --%>
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
        <button type="button" class="btn outline" id="btnWish">찜</button>
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
.detail-wrap {
  max-width:1100px; margin:40px auto; padding:0 20px;
  display:flex; gap:32px;
}
.detail-left { flex:1; }
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
</style>

<script>
document.addEventListener("DOMContentLoaded", () => {
	const productId = "${product.productId}";
    getProductFetch(productId);
  });


document.getElementById('btnWish')?.addEventListener('click',()=>alert('찜 기능 연결 예정'));
document.getElementById('btnPay')?.addEventListener('click',function() {
    const productId = "${product.productId}";
    const buyerId = "${userId}";
    const sellerId = "${product.sellerId}";
    // 판매자와 구매자가 같을 때 경고창 띄우고 이동 막기
    if (buyerId === sellerId) {
        alert("상품에 등록된 판매자와 구매자가 같아서 채팅할 수 없습니다");
        return;
    }
    else {
    	window.location.href = "${contextPath}/chat/createRoom?productId=" + productId + "&buyerId=" + buyerId + "&sellerId=" + sellerId;	
    }
    
});

async function getProductFetch(productId) {
	  try {
	    const res = await fetch(contextPath + "/api/product/detail/" + productId, {
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

	    // 예시: 가격 업데이트
	    /* const priceEl = document.querySelector(".price");
	    if (priceEl && data.productPrice) {
	      priceEl.textContent = new Intl.NumberFormat().format(data.productPrice) + "원";
	    }

	    // 예시: 상품 설명 업데이트
	    const descEl = document.querySelector(".desc");
	    if (descEl && data.productDescription) {
	      descEl.textContent = data.productDescription;
	    }
 */
	  } catch (err) {
	    console.error("상품 조회 실패:", err);
	  }
}
</script>
