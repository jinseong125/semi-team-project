<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<div class="grid">
  <c:forEach var="p" items="${products}">
      <div class="card">
          <a href="${pageContext.request.contextPath}/product/detail/${p.productId}">
              <div class="name">${p.productName}</div>
              <div class="price">
                  <fmt:formatNumber value="${p.productPrice}" type="number" groupingUsed="true"/>원
              </div>
          </a>
      </div>
  </c:forEach>
</div>

</body>
</html>