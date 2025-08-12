<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<a href="${contextPath}/product/new"><h2>상품 등록</h2></a>
<a href="${contextPath}/product/myproduct"><h2>상품 관리</h2></a>

<table border = "1" >
  <thead>
  <tr>
    <th>사진</th><th>판매 상태</th><th>상품명</th>
    <th>카테고리</th><th>가격</th><th>등록일</th><th>최근 수정일</th>
  </tr>
  </thead>
  <tbody>
  <c:forEach var="item" items="${items}">
    <tr>
      <td>
        <c:choose>
          <c:when test="${item.thumbnail != null && item.thumbnail.imageUrl != null}">
            <img src="${item.thumbnail.imageUrl}" style="width:80px;height:80px;object-fit:cover;">
          </c:when>
          <c:otherwise>
            <img src="${pageContext.request.contextPath}/resources/img/no-image.png" style="width:80px;height:80px;">
          </c:otherwise>
        </c:choose>
      </td>

      <td>${item.status.statusName}</td>
      <td>
        <a href="${pageContext.request.contextPath}/product/detail/${item.productId}">
            ${item.productName}
        </a>
      </td>
      <td>${item.category.categoryName}</td>
      <td><fmt:formatNumber value="${item.productPrice}" type="number"/></td>
      <td><fmt:formatDate value="${item.productCreatedAt}" pattern="yyyy-MM-dd-HH:mm"/></td>  <!-- 변경 -->
      <td><fmt:formatDate value="${item.productUpdatedAt}" pattern="yyyy-MM-dd-HH:mm"/></td>  <!-- 변경 -->
    </tr>
  </c:forEach>

  </tbody>
</table>
</body>
</html>