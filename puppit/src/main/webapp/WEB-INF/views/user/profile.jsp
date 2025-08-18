<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<jsp:include page="../layout/header.jsp"></jsp:include>

<h1>프로필 페이지</h1>

<form action="${contextPath}/user/profile" method="post">

  <table border="1">
    <tr>
      <th>아이디</th>
      <td><input type="text" name="accountId" value="${sessionScope.sessionMap.accountId}"> <button>중복확인</button></td>
    </tr>
    <tr>
      <th>이름</th>
      <td><input type="text" name="userName" value="${sessionScope.sessionMap.userName}"></td>
    </tr>
    <tr>
      <th>닉네임</th>
      <td><input type="text" name="nickName" value="${sessionScope.sessionMap.nickName}"> <button>중복확인</button></td>
    </tr>
    <tr>
      <th>이메일</th>
      <td><input type="text" name="userEmail" value="${sessionScope.sessionMap.userEmail}"></td>
    </tr>
  </table>
  <br>
  <button type="submit">적용</button>
</form>
  
</body>
</html>