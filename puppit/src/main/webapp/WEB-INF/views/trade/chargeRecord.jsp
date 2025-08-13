<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="../layout/header.jsp" />
<h1>충전내역 조회</h1>
<table border="1">
  <tbody>
    <c:forEach var="pointDTO" items="${pointDTOs}" >
    <tr>
      <td>chargeId: ${pointDTO.chargeId}</td>
      <td>userId: ${pointDTO.userId}</td>
      <td>pointChargeAmount: ${pointDTO.pointChargeAmount}</td>
      <td>pointChargeOrderNumber: ${pointDTO.pointChargeOrderNumber}</td>
      <td>pointChargeChargedAt: ${pointDTO.pointChargeChargedAt}</td>
    </tr>
    </c:forEach>
    
  </tbody>
</table>

</body>
</html>
