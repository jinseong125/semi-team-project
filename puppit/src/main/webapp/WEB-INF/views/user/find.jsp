<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<h2 style="text-align: center">아이디/비밀번호 찾기</h2>

  <div id="content" style="text-align: center;">
    <form id="find" action="${contextPath}/user/find" method="post">
      <div class="form-group">
       <input type="text" name="userName" id="userName" placeholder="이름">
      </div>
      <div class="form-group">
        <input type="email" name="userEmail" id="userEmail" placeholder="이메일">
      </div>
      <button type="submit" id="id-find">아이디 찾기</button>
   </form>
     <div style="font-size: 12px; color: red;">${msg}</div>
  </div>


</body>
</html>