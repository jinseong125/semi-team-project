<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>결제 화면</title>
</head>
<body>
  <h1>결제 화면</h1>
  <form action="${contextPath}/payment/insertPoint" method="post">
    충전할 유저ID: <input type="text" name="uid">
    <br>
    충전할 금액: <input type="text" name="amount">
    <br>
    <button type="submit">확인</button>
  </form>
</body>
</html>