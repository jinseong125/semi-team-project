<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="../layout/header.jsp" />

<c:forEach var="tradeDTO" items="${tradeDTOs}" >
  uuid: ${tradoDTO.uuid}
  buyerId: ${tradoDTO.buyerId}
  sellerId: ${tradoDTO.sellerId}
  productId: ${tradoDTO.productId}
  status: ${tradoDTO.status}
  createdAt: ${tradoDTO.createdAt}
</c:forEach>

</body>
</html>

