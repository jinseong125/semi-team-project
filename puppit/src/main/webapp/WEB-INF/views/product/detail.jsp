<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<div class="product-detail-container">
    <h2>${product.productName}</h2>
    <%-- <p>카테고리: ${product.categoryId}</p>
    <p>위치: ${product.locationId}</p>
    <p>상태: ${product.conditionId}</p>
    <p>판매상태: ${product.statusId}</p> --%>
    <p>가격: <fmt:formatNumber value="${product.productPrice}" type="currency" /></p>
    <p>등록일: <fmt:formatDate value="${product.productCreatedAt}" pattern="yyyy-MM-dd HH:mm" /></p>
    <hr>
    <div class="description">
        ${product.productDescription}
    </div>
</div>

<style>
.product-detail-container {
    max-width: 800px;
    margin: 30px auto;
    padding: 20px;
    background: #fff;
    border: 1px solid #eee;
    border-radius: 8px;
}
.product-detail-container h2 {
    font-size: 28px;
    margin-bottom: 10px;
}
.product-detail-container p {
    font-size: 16px;
    margin: 5px 0;
}
.description {
    margin-top: 20px;
    padding: 15px;
    background: #fafafa;
    border: 1px solid #ddd;
    border-radius: 5px;
}
</style>


