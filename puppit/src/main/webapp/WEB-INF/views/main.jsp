<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="./layout/header.jsp">
  <jsp:param value="Home" name="title"/>
</jsp:include>
<style>
.container {
 width: 1000px
 min-heigh}
</style>

<form action="${contextPath}/search" method="get">
<input type="text" name="keyword" placeholder="검색어 입력">
<button type="submit">검색</button>
</form>


<h3>카테고리</h3>
<ul>
  <li><a href="${contextPath}/category?type=toys">외출용품</a></li>
  <li><a href="${contextPath}/category?type=food">사료</a></li>
  <li><a href="${contextPath}/category?type=clothes">의류</a></li>
  <li><a href="${contextPath}/category?type=accessories">기타용품</a></li>
</ul>

  <script type="text/javascript">
    const msg = "${msg}";
    if(msg !== "")
      alert(msg);
  </script>


</body>
</html>