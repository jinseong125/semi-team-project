<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<!-- Font Awesome 라이브러리 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<title>Puppit</title>
</head>
<body>
<img src="${contextPath}/resources/image/DOG.jpg" width="100px"/>
  <h1>Puppit에 오신걸 환영합니다!</h1>
  <nav>
    <ul>
 
      <li><a href="${contextPath}/">홈</a></li>
      <li><a href="${contextPath}/product/list">상품목록</a></li>
      <li><a href="${contextPath}/user/login">로그인</a></li>
      <li><a href="${contextPath}/user/join">회원가입</a></li>
      <li><a href="${contextPath}/user/mypage">마이페이지</a></li>
      <li><a href="${contextPath}/product/new">상품 등록</a></li>
      
    </ul>
  </nav>
  <hr>