<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="../layout/header.jsp">
  <jsp:param value="Home" name="title" />
</jsp:include>

  <main>
    <div>
      <h1>비밀번호 재확인</h1>
       <form method="post" action="${contextPath}/user/checkPassword">
        <div>
          <input type="password" name="userPassword" id="userPassword" placeholder="비밀번호">
        </div>
          <button type="submit">확인</button>
       </form>
       
    <div class="msg">${msg}</div>
   </div>
  </main>

</body>
</html>