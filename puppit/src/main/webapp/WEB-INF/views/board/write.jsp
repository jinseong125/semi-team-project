<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="../layout/header.jsp">
  <jsp:param value="Board작성" name="title"/>
</jsp:include>

  <h1>Board Write</h1>
  
  <form method="post"
        action="${contextPath}/board/write">
  
    <div>작성자 : ${sessionScope.nickname}</div>
    
    <label>제목 <input type="text" name="title" autofocus></label>
    <br>
    <textarea name="content">Editor 필요</textarea>
    <br>
    
    <button type="submit">등록</button>
    
  </form>

</body>
</html>