<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<h2>아이디/비밀번호 찾기</h2>

    <form id="findForm" action="${contextPath}/user/findIdCheck" method="post">
      <div class="form-group">
       <input type="text" name="userName" id="userName" placeholder="이름">
      </div>
      <div class="form-group">
        <input type="email" name="userEmail" id="userEmail" placeholder="이메일">
      </div>
      <button type="submit" id="id-find" onclick="findSubmit(); return false;">아이디 찾기</button>
   </form>
   
   <div class="result-box">
      <c:choose>
        <c:when test="${empty findId}">
      <p class="inquiry">조회결과가 없습니다.</p>
      </c:when>
        <c:otherwise>
            <p>${findId.id}</p>
        </c:otherwise>
  </c:choose>
</div>

</body>
</html>