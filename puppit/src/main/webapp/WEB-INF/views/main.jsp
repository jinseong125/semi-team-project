<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="./layout/header.jsp" />

<script>
  const msg = "${msg}";
  if (msg && msg.trim() !== "") alert(msg);
</script>

<style>
  html, body {
    height: 100%; margin: 0; padding: 0; background: #fff; font-family: 'Pretendard', sans-serif;
  }
  body {
    min-height: 100vh; background: #fff;
  }
  .container {
    max-width: 1200px; margin: 0 auto; padding: 24px 20px 60px; background: #fff;
    min-height: 400px;
  }

  /* ===== 검색 박스 ===== */
  .search-box {
    display: flex; justify-content: center; gap: 8px; margin: 0 auto 28px auto;
    max-width: 600px;
  }
  .search-input {
    flex: 1; padding: 10px 14px; font-size: 15px;
    border: 1px solid #d1d5db; border-radius: 9999px;
    outline: none; transition: border .2s;
  }
  .search-input:focus {
    border-color: #111;
  }
  .search-btn {
    padding: 10px 18px; font-size: 15px; font-weight: 600;
    background: #111; color: #fff; border: none; border-radius: 9999px;
    cursor: pointer; transition: background .2s;
  }
  .search-btn:hover { background: #333; }

  /* ===== 상품 그리드 ===== */
.product-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: 22px;
  justify-content: center;   /* 가운데 정렬 */
}

#search-results .grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
  gap: 16px;
  justify-content: center;   /* 가운데 정렬 */
}

  @media (max-width: 1024px) { .product-grid { grid-template-columns: repeat(3, 1fr); } }
  @media (max-width: 768px) { .product-grid { grid-template-columns: repeat(2, 1fr); } }
  @media (max-width: 480px) { .product-grid { grid-template-columns: repeat(1, 1fr); } }

  .product-card {
    display: block; text-decoration: none; color: inherit;
    border-radius: 12px; padding: 8px;
    transition: transform .2s, box-shadow .2s;
  }
  .product-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 4px 12px rgba(0,0,0,0.08);
  }
  .thumb {
    width: 100%; aspect-ratio: 1/1; object-fit: cover;
    border-radius: 12px; border: 1px solid #ececef; background: #fafafa;
  }
  .title {
    margin-top: 10px; font-size: 15px; font-weight: 600; color: #111;
    overflow: hidden; white-space: nowrap; text-overflow: ellipsis;
  }
  .desc {
    margin-top: 4px; font-size: 13px; color: #6b7280;
    line-height: 1.35; max-height: 2.7em;
    overflow: hidden; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical;
  }
  .price {
    margin-top: 6px; font-size: 15px; font-weight: 700; color: #111;
  }

  /* ===== 검색 결과 ===== */
  #search-results {
    margin-top: 20px;
  }
  #search-results .result-head {
    font-size: 14px; margin-bottom: 12px;
  }
  #search-results .grid {
    display: grid; grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
    gap: 16px;
  }
  #search-results .card {
    border: 1px solid #e5e7eb; border-radius: 10px; overflow: hidden;
    transition: transform .2s, box-shadow .2s;
  }
  #search-results .card:hover {
    transform: translateY(-3px);
    box-shadow: 0 4px 12px rgba(0,0,0,0.08);
  }
  #search-results .name {
    font-size: 14px; font-weight: 500; margin: 6px 8px; overflow: hidden;
    white-space: nowrap; text-overflow: ellipsis;
  }
  #search-results .price {
    font-size: 14px; font-weight: 600; margin: 0 8px 8px 8px;
  }
  .empty {
    padding: 40px 0; text-align: center; color: #6b7280;
  }
</style>

<div class="container">




  <!-- 상품 리스트 -->
  <c:if test="${not empty products}">
    <div class="product-grid" id="productGrid">
      <c:forEach items="${products}" var="p">
        <a class="product-card" href="${contextPath}/product/detail/${p.productId}">
          <img class="thumb" src="${p.thumbnail.imageUrl}" alt="상품이미지 없음">
          <div class="title">${p.productName}</div>
          <div class="desc">${p.productDescription}</div>
          <div class="price">
            <fmt:formatNumber value="${p.productPrice}" type="number" groupingUsed="true"/>원
          </div>
        </a>
      </c:forEach>
    </div>
  </c:if>
  <div id="search-results" style="display:none;"></div>
</div>

