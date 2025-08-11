<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="./layout/header.jsp" />

<style>
  .container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 24px 20px 60px;
    background:#fff;
  }

  
  .product-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 22px;
  }
  @media (max-width: 1024px) { .product-grid { grid-template-columns: repeat(3,1fr); } }
  @media (max-width: 768px)  { .product-grid { grid-template-columns: repeat(2,1fr); } }

  .product-box {
    text-align: left;
  }
  .thumb {
    width: 100%;
    aspect-ratio: 1 / 1;
    object-fit: cover;
    border-radius: 12px;
    border: 1px solid #ececef;
    background:#fafafa;
  }
  .title {
    margin-top: 8px;
    font-size: 14px;
    color:#111;
    font-weight: 600;
  }
  .desc {
    margin-top: 2px;
    font-size: 12px;
    color:#6b7280;
  }
  .price {
    margin-top: 4px;
    font-size: 14px;
    font-weight: 700;
  }
</style>

<div class="container">
  <!-- 컨트롤러에서 request.setAttribute("products", List<ProductDTO>) -->
  <!-- ProductDTO: id, name, description, price(BigDecimal/Long), imageUrl -->

  <c:choose>
    <c:when test="${not empty products}">
      <div class="product-grid">
        <c:forEach items="${products}" var="p">
          <div class="product-box">
            <a href="${contextPath}/product/${p.id}">

            </a>
            <div class="title"><c:out value="${p.name}" /></div>
            <div class="desc"><c:out value="${p.description}" /></div>
            <div class="price">
              <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₩" />
            </div>
          </div>
        </c:forEach>
      </div>
    </c:when>
    <c:otherwise>

      <div class="product-grid">
        <c:forEach begin="1" end="8" var="i">
          <div class="product-box">
            <img class="thumb" src="${contextPath}/resources/image/car.png" alt="유모차" />
            <div class="title">유모차</div>
            <div class="desc">상품 정보 입니다</div>
            <div class="price">₩3,0000원</div>
          </div>
        </c:forEach>
      </div>
    </c:otherwise>
  </c:choose>
</div>