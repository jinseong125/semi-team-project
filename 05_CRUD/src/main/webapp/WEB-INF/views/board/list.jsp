<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="../layout/header.jsp">
  <jsp:param value="Board게시판" name="title"/>
</jsp:include>

  <h1>Board List</h1>
  
  <table border="1">
    <caption>${boardCount}개 게시글이 있습니다.</caption>
    <tbody>
      <c:forEach items="${boards}" var="board">
        <tr>
          <td><a href="${contextPath}/board/detail?bid=${board.bid}">${board.title}</a></td>
          <td>${board.user.nickname}</td>
          <td><fmt:formatDate value="${board.createdAt}" pattern="yyyy-MM-dd"/></td>
        </tr>
      </c:forEach>
    </tbody>
  </table>
  
  <a href="${contextPath}/board/write">작성</a>

</body>
</html>