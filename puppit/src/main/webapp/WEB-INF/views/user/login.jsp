<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Insert title here</title>
</head>
<style>
 .main {
 text-align: center;
 }
</style>
<body>

<div class="main">
	<h1>Puppit 로그인</h1>
	<form method="post"
	      action="${contextPath}/user/login">
		<label>아이디 : <input type="text" name="accountId"/></label>
		<br>
		<label>비밀번호 : <input type="password" name="userPassword"/> </label>
		<br>
		<button type="submit" onclick="onLogin()">로그인</button>
	</form>
	
	<c:if test="${not empty error}">
		<div style="font-size: 12px; color: red;">${error}</div>
	
	</c:if>
</div>
	
	
	
	
	<script type="text/javascript">

		 const msg = "${msg}";
		    if (msg !== "")
		      alert(msg);
	
	</script>
	
	
</body>
</html>