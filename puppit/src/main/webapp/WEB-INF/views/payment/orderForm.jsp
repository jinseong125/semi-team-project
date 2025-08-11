<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="../layout/header.jsp" />

<form action="${contextPath}/order/pay" method="post">
  <div>구매자ID: ${buyerId}</div>
  <div>판매자ID: ${sellerId}</div>
  <div>거래상품: ${prodId}</div>
  <div>상품수량: ${quantity}</div>
  <input type="hidden" name="buyerId" value="${buyerId}">
  <input type="hidden" name="sellerId" value="${sellerId}">
  <input type="hidden" name="prodId" value="${prodId}">
  <input type="hidden" name="quantity" value="${quantity}">
  <br>
  <button type="submit">결제</button>
</form>


</body>
</html>