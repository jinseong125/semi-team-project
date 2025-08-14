<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<style>
  table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
    font-size: 14px;
  }
  th, td {
    border-bottom: 1px solid #ddd;
    padding: 10px;
    text-align: center;
    vertical-align: middle;
  }
  th {
    background-color: #f8f8f8;
    font-weight: bold;
  }
  .thumbnail img {
    width: 80px;
    height: 80px;
    object-fit: cover;
    border-radius: 4px;
  }
  .no-image {
    width: 80px;
    height: 80px;
    background-color: #f0f0f0;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #999;
    font-size: 12px;
    border-radius: 4px;
  }
</style>
<div class="nav-menu" style="display:flex; gap:20px; margin-bottom:20px;">
  <!-- 상품 등록 페이지로 이동 -->
  <a href="${contextPath}/product/new"
     style="text-decoration:none; color:#333; font-weight:bold;">
    상품 등록
  </a>

  <!-- 현재 상품관리 페이지 새로고침 -->
  <a href="${contextPath}/product/myproduct"
     style="text-decoration:none; color:#333; font-weight:bold;">
    상품 관리
  </a>
</div>

<table>
  <thead>
  <tr>
    <th>사진</th>
    <th>판매 상태</th>
    <th>상품명</th>
    <th>카테고리</th>
    <th>가격</th>
    <th>등록일</th>
    <th>최근 수정일</th>
  </tr>
  </thead>
  <tbody>
  <c:forEach var="item" items="${items}">
    <tr>
      <td class="thumbnail">
        <c:choose>
          <c:when test="${not empty item.thumbnail.imageUrl}">
            <a href="${contextPath}/product/detail/${item.productId}">
              <img src="${item.thumbnail.imageUrl}" alt="상품 이미지"/>
            </a>
          </c:when>
        </c:choose>
      </td>
      <td>${item.status.statusName}</td>
      <td>${item.productName}</td>
      <td>${item.category.categoryName}</td>
      <td><fmt:formatNumber value="${item.productPrice}" pattern="#,###"/></td>
      <td><fmt:formatDate value="${item.productCreatedAt}" pattern="yyyy-MM-dd"/></td>
      <td><fmt:formatDate value="${item.productUpdatedAt}" pattern="yyyy-MM-dd"/></td>
    </tr>
  </c:forEach>
  </tbody>
</table>
</body>
</html>