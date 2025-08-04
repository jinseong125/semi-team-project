<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<jsp:include page="../layout/header.jsp">
  <jsp:param value="${board.bid}번 게시글" name="title"/>
</jsp:include>

  <h1>Board Detail</h1>
  
  <div>작성자 : ${board.user.nickname}</div>
  <div>작성일 : ${board.createdAt}</div>
  <div>수정일 : ${board.modifiedAt == null ? board.createdAt : board.modifiedAt}</div>
  
  <hr>
  
  <h1>${board.title}</h1>
  <pre>${board.content}</pre>

  <hr>
  
  <button onclick="onModifyForm()">수정</button>

  <script type="text/javascript">
    function onModifyForm() {
      location.href = "${contextPath}/board/modify?bid=${board.bid}";
    }
  
  </script>

</body>
</html>