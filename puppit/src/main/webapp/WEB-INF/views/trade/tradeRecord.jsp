<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="../layout/header.jsp" />
<h1>거래내역 조회</h1>
<table border="1">
  <tbody>
    <c:forEach var="tradeDTO" items="${tradeDTOs}" >
    <tr>
      <td>paymentId: ${tradeDTO.paymentId}</td>
      <td>uuid: ${tradeDTO.uuid}</td>
      <td>buyerId: ${tradeDTO.buyerId}</td>
      <td>sellerId: ${tradeDTO.sellerId}</td>
      <td>productId: ${tradeDTO.productId}</td>
      <td>status: ${tradeDTO.status}</td>
      <td>createdAt: ${tradeDTO.createdAt}</td>
    </tr>
    </c:forEach>
    
  </tbody>
</table>

</body>
</html>

