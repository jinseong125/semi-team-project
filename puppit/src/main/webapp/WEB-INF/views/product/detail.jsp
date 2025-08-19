<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ page import="java.util.Map" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="userId" value="<%= userId %>" />


<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<div class="detail-wrap">
  <!-- 상단 카테고리 표시 (안전 처리) -->
  <div class="breadcrumb">
    <c:choose>
      <c:when test="${product.category ne null and not empty product.category.categoryName}">
        <span>${product.category.categoryName}</span>
      </c:when>
      <c:otherwise>
        <span>${product.categoryId}</span>
      </c:otherwise>
    </c:choose>
  </div>
  <!-- 내 상품일 때만 수정 버튼 보이도록 -->
  <div class="actions">
    <c:set var="sessionMap" value="${sessionScope.sessionMap}" />
    <c:if test="${sessionMap.userId eq product.sellerId}">
      <a href="${contextPath}/product/edit/${product.productId}" class="btn btn-outline">상품 수정</a>
      <form action="${contextPath}/product/delete" method="post" style="display:inline;">
        <input type="hidden" name="productId" value="${product.productId}"/>
        <button type="submit" class="btn btn-outline"
                onclick="return confirm('정말 삭제하시겠습니까?');">상품 삭제</button>
      </form>
    </c:if>

  </div>

  <div class="top">
    <!-- 좌: 대표 이미지 -->
    <div class="thumb">
      <c:choose>

        <c:when test="${product.thumbnail ne null and not empty product.thumbnail.url}">
          <img src="${product.thumbnail.url}" alt="${product.productName}"/>
        </c:when>
        <c:when test="${product.thumbnail ne null and not empty product.thumbnail.imageUrl}">
          <img src="${product.thumbnail.imageUrl}" alt="${product.productName}"/>
        </c:when>
        <c:when test="${product.thumbnail ne null and not empty product.thumbnail.path}">
          <img src="${product.thumbnail.path}" alt="${product.productName}"/>
        </c:when>

        <c:otherwise>
          <div class="thumb-placeholder">
            <div class="ph-dot"></div>
            <div class="ph-mountain"></div>
          </div>
        </c:otherwise>
      </c:choose>
    </div>

    <!-- 우: 상품 메타 -->
    <div class="meta">
      <h1 class="title">${product.productName}</h1>

      <div class="price">
        <strong><fmt:formatNumber value="${product.productPrice}" pattern="#,###원"/></strong>
      </div>

      <div class="meta-line"></div>

      <ul class="mini-list">
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
            <fmt:formatDate value="${product.productCreatedAt}" pattern="yyyy.MM.dd"/>
          </span>
        </li>
      </ul>

      <div class="actions">
        <button type="button" class="btn btn-outline" onclick="history.back()">목록</button>
        <button type="button" class="btn btn-outline" id="btnWish">찜</button>
        <button type="button" class="btn btn-solid" id="btnPay">채팅하기</button>
      </div>
    </div>
  </div>

  <!-- 구분선 -->
  <div class="divider"></div>

  <!-- 상세정보 -->
  <section class="section">
    <div class="section-head">
      <h2>상품정보</h2>
    </div>
    <div class="section-body">
      <c:choose>
        <c:when test="${not empty product.productDescription}">
          <pre class="desc"><c:out value="${product.productDescription}"/></pre>
        </c:when>
        <c:otherwise>
          <div class="empty">등록된 설명이 없습니다.</div>
        </c:otherwise>
      </c:choose>
    </div>
  </section>
</div>

<style>
:root{
  --text:#111; --muted:#6b7280; --border:#e5e7eb; --line:#ebebef;
  --black:#0a0a0a; --pink-verylight:#fff1f7;
}
.detail-wrap .detail-wrap{max-width:980px;margin:24px auto 80px;padding:0 16px;color:var(--text);}
.detail-wrap .breadcrumb{font-size:14px;color:var(--muted);margin-bottom:16px;}
.detail-wrap .detail-wrap .top{display:grid;grid-template-columns:360px 1fr;gap:28px;}
.detail-wrap .thumb{width:20%;aspect-ratio:1/1;border:1px solid var(--border);border-radius:14px;overflow:hidden;background:#fff;display:flex;align-items:center;justify-content:center;}
.detail-wrap .thumb img{width:20%;height:20%;object-fit:cover;display:block;}
.detail-wrap .thumb-placeholder{width:70%;height:70%;border:2px solid #cfcfd4;border-radius:12px;position:relative;}
.detail-wrap .ph-dot{width:14px;height:14px;border-radius:50%;background:#cfcfd4;position:absolute;left:10px;top:10px;}
.detail-wrap .ph-mountain{position:absolute;bottom:10px;left:10px;right:10px;top:40%;border-left:2px solid #cfcfd4;border-bottom:2px solid #cfcfd4;transform:skewX(-20deg);}
.detail-wrap .meta .title{font-size:28px;margin:4px 0 8px;font-weight:700;}
.detail-wrap .price strong{font-size:22px;}
.detail-wrap .meta-line{height:1px;background:var(--line);margin:16px 0;}
.detail-wrap .mini-list{list-style:none;padding:0;margin:8px 0 0;display:grid;gap:6px;}
.detail-wrap .mini-list .label{color:var(--muted);font-size:13px;margin-right:6px;}
.detail-wrap .mini-list .value{font-size:14px;}
.detail-wrap .actions{display:flex;gap:12px;margin-top:18px;}
.detail-wrap .btn{height:42px;padding:0 18px;border-radius:10px;font-size:14px;cursor:pointer;border:1px solid var(--black);background:#fff;}
.detail-wrap .btn-solid{background:var(--black);color:#fff;}
.detail-wrap .btn-outline{background:#fff;color:#111;}
.detail-wrap .divider{height:1px;background:var(--line);margin:26px 0;}
.detail-wrap .section-head h2{font-size:18px;font-weight:700;}
.detail-wrap .section-body{margin-top:12px;background:var(--pink-verylight);border:1px dashed #f2cfe0;border-radius:12px;min-height:160px;padding:18px;}
.detail-wrap .desc{white-space:pre-wrap;line-height:1.6;font-size:15px;}
.detail-wrap .empty{color:var(--muted);font-size:14px;}
@media(max-width:860px){.top{grid-template-columns:1fr;}}
</style>

<script>
var contextPath = "${contextPath}"; // <-- 반드시 선언!

document.getElementById('btnWish')?.addEventListener('click',()=>alert('찜 기능 연결 예정'));
document.getElementById('btnPay')?.addEventListener('click',function() {
	const productId = "${product.productId}";
    const buyerId = "${userId}";
    const sellerId = "${product.sellerId}";
    // chat/createRoom?productId=xxx&buyerId=xxx&sellerId=xxx 로 요청
    window.location.href = contextPath + "/chat/createRoom?productId=" + productId + "&buyerId=" + buyerId + "&sellerId=" + sellerId;




});
</script>
