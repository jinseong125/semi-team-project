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
<body>
	<h1>Puppit 회원가입 화면</h1>
	<form method="post"
	      action="${contextPath}/user/login">
		<input type="hidden" name="url" value="${url}"/>
		<label>이메일 : <input type="text" name="email"/></label>
		<br>
		<label>비밀번호 : <input type="password" name="password"/> </label>
		<br>
		<button type="submit">로그인</button>
		<button type="button" onclick="onSignup()">회원가입</button>
	</form>
	
	<c:if test="${not empty error}">
		<div style="font-size: 12px; color: red;">${error}</div>
	
	</c:if>
	
	
	
	
	<script type="text/javascript">
		function onSignup() {
		  location.href="${contextPath}/user/signup"; // 추후 회원가입 화면으로 이동할 수 있도록 구현
		}
	
	
	</script>
	
	
</body>
</html>