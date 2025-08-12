<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="./layout/header.jsp" />

<script>
  const msg = "${msg}";
  if (msg && msg.trim() !== "") 
	  alert(msg);
</script>

<style>
  .container 
  {max-width:1200px
  ;margin:0 auto;
  padding:24px 20px 60px;
  background:#fff;
  }
  
  .product-grid {
  display:grid;
  grid-template-columns:repeat(4,1fr);
  gap:22px;
  }
  
  @media (max-width:1024px){
  .product-grid {
  grid-template-columns:repeat(3,1fr)
  }
  }
  @media (max-width:768px){
  .product-grid {
  grid-template-columns:repeat(2,1fr)
  }
  }

  /* 카드 자체를 a로 사용 */
  .product-card{display:block;text-decoration:none;color:inherit}
  .thumb {
  width:100%;
  aspect-ratio:1/1;
  object-fit:cover;
  border-radius:12px;
  border:1px solid #ececef;
  background:#fafafa;
  }
  
  .title {
  margin-top:8px;
  font-size:14px;
  color:#111;
  font-weight:600;
  line-height:1.3
  }
  .desc {
  margin-top:2px;
  font-size:12px;
  color:#6b7280;
  line-height:1.35;
  max-height:3.6em;
  overflow:hidden;
  display:-webkit-box;
  -webkit-line-clamp:3;
  -webkit-box-orient:vertical;
  }
  
  .price {
  margin-top:4px;
  font-size:14px;
  font-weight:700;
  }
  
</style>

<div class="container">
  <c:if test="${not empty products}">
    <div class="product-grid" id="productGrid">
      <c:forEach items="${products}" var="p">
        <a class="product-card" href="${contextPath}/product/detail/${p.productId}">
          <div class="title">${p.productName}</div>
          <div class="desc">${p.productDescription}</div>
          <div class="price">
            <fmt:formatNumber value="${p.productPrice}" type="number" groupingUsed="true"/>원
          </div>
        </a>
      </c:forEach>
    </div>
  </c:if>
</div>
