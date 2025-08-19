<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="../layout/header.jsp" />

<style>
  body {
    margin: 0;
    background: #fff;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Noto Sans KR', sans-serif;
    color: #111;
  }

  .wrap {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
  }

  .title {
    font-size: 24px;
    font-weight: bold;
    margin-bottom: 20px;
  }

  .product-card {
    background: #fff;
    border: 1px solid #dfe3ea;
    border-radius: 16px;
    padding: 16px;
    margin-bottom: 16px;
    box-shadow: 0 8px 24px rgba(0, 0, 0, .08);
    cursor: pointer;
    text-decoration: none;
    display: block;
    color: inherit;
  }

  .product-name {
    font-size: 18px;
    font-weight: 700;
    margin-bottom: 8px;
  }

  .product-price {
    font-size: 16px;
    color: #4f86ff;
    font-weight: 600;
    margin-bottom: 6px;
  }

  .product-desc {
    font-size: 14px;
    color: #555;
  }

  .back-btn {
    background: none;
    border: none;
    color: #333;
    font-size: 18px;
    cursor: pointer;
    margin-bottom: 20px;
  }

  .back-btn:hover {
    text-decoration: underline;
  }
</style>

<div class="wrap">
  <button class="back-btn" onclick="history.back()"><i class="fa-solid fa-arrow-left"></i> 뒤로가기</button>
  <div class="title"><i class="fa-solid fa-heart"></i> 찜 목록</div>

  <c:choose>
    <c:when test="${not empty products}">
      <c:forEach var="product" items="${products}">
        <c:forEach var="like" items="${likes}">
          <c:if test="${product.productId == like.productId}">
            <a href="${contextPath}/product/detail/${product.productId}" class="product-card">
              <div class="product-name">${product.productName}</div>
              <div class="product-price">
                <fmt:formatNumber value="${product.productPrice}" type="currency" currencySymbol="₩" />
              </div>
              <div class="product-desc">${product.productDescription}</div>
            </a>
          </c:if>
        </c:forEach>
      </c:forEach>
    </c:when>
    <c:otherwise>
      <p>찜한 상품이 없습니다.</p>
    </c:otherwise>
  </c:choose>
</div>
</body>
</html>
