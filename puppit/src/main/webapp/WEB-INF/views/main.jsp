<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="./layout/header.jsp">
  <jsp:param value="Home" name="title"/>
</jsp:include>  

<img src="${contextPath}/resources/image/MainLogo.png" width="500px"/>


</body>
</html>