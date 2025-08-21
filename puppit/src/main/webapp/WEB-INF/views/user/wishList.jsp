<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="../layout/header.jsp" />

<style>
  body { margin:0; background:#fff; font-family:-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Noto Sans KR', sans-serif; color:#111; }
  .wrap { max-width:1200px; margin:0 auto; padding:20px; }
  .topbar { display:flex; align-items:center; justify-content:space-between; gap:12px; flex-wrap:wrap; margin-bottom:16px; }
  .back-btn, .btn { border:1px solid #dfe3ea; background:#fff; border-radius:10px; padding:8px 12px; cursor:pointer; font-size:14px; }
  .back-btn:hover, .btn:hover { background:#f7f8fa; }
  .title { font-size:22px; font-weight:700; }
  .cards { display:grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap:16px; }
  .product-card { background:#fff; border:1px solid #dfe3ea; border-radius:16px; padding:16px; box-shadow:0 8px 24px rgba(0,0,0,.08); display:flex; flex-direction:column; gap:8px; }
  .product-link { text-decoration:none; color:inherit; }
  .product-name { font-size:18px; font-weight:700; }
  .product-price { font-size:16px; color:#4f86ff; font-weight:600; }
  .product-desc { font-size:14px; color:#555; min-height:40px; }
  .actions { display:flex; gap:8px; margin-top:8px; }
  .inline-form { display:inline; }
  .empty { padding:60px 0; text-align:center; color:#666; }
  .flash { margin: 8px 0 16px; padding:10px 12px; border:1px solid #dfe3ea; border-radius:10px; background:#f7f8fa; }
  .wishListImage {width: 200px; height: 200px;}
</style>

<div class="wrap">
  <div class="topbar">
    <button class="back-btn" onclick="history.back()">뒤로가기</button>
    <div class="title">찜 목록</div>
    <form action="${contextPath}/wish/delete-all" method="post" class="inline-form"
          onsubmit="return confirm('정말 전체 삭제할까요?');">
      <c:if test="${not empty _csrf}">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
      </c:if>
      <button type="submit" class="btn">전체 삭제</button>
    </form>
  </div>

  <c:if test="${not empty msg}">
    <div class="flash">${msg}</div>
  </c:if>

  <c:choose>
    <c:when test="${not empty products}">
      <div class="cards">
        <c:forEach var="p" items="${productAndImages}">
          <div class="product-card">
            <a href="${contextPath}/product/detail/${p.productId}" class="product-link">
              <div class="product-name">${p.productName}</div>
              <div class="product-price">
                <fmt:formatNumber value="${p.productPrice}" type="currency" currencySymbol="₩" />
              </div>
              <img class="wishListImage" src="${p.imageUrl}" alt="찜목록이미지">
            </a>

            <div class="actions">
              <!-- 단건 삭제: POST /wish/delete -->
              <form action="${contextPath}/wish/delete" method="post" class="inline-form"
                    onsubmit="return confirm('이 상품을 찜에서 삭제할까요?');">
                <input type="hidden" name="productId" value="${p.productId}" />
                <c:if test="${not empty _csrf}">
                  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                </c:if>
                <button type="submit" class="btn">삭제</button>
              </form>
            </div>
          </div>
        </c:forEach>
      </div>
    </c:when>
    <c:otherwise>
      <div class="empty">찜한 상품이 없습니다.</div>
    </c:otherwise>
  </c:choose>
</div>
