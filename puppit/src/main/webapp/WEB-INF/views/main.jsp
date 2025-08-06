<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="./layout/header.jsp">
  <jsp:param value="Home" name="title"/>
</jsp:include>  

<img src="${contextPath}/resources/image/main.jpg" width="1024px"/>

<!-- 테스트 변경사항123 이유천 -->  

</body>
</html>