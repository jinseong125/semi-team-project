productService.getProductDetail(productId)<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8"/>
  <title>상품 등록</title>
  <style>
    form { max-width: 560px; margin: 24px auto; display: grid; gap: 12px; }
    label { display: block; margin-bottom: 6px; font-weight: 600; }
    input[type=text], input[type=number], textarea {
      width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 8px;
    }
    button { padding: 10px 16px; border: 0; border-radius: 8px; cursor: pointer; }
    .submit { background: #222; color: #fff; }
  </style>
</head>
<body>
<h2 style="text-align:center;">상품 등록</h2>

<form action="<c:url value='/product/new'/>" method="post">



  <div>
    <label>상품명</label>
    <input type="text" name="productName" required />
  </div>

  <div>
    <label>가격(원)</label>
    <input type="number" name="productPrice" min="0" step="1" />
  </div>

  <div>
    <label>설명</label>
    <textarea name="productDescription" rows="5" required></textarea>
  </div>


  <!-- 카테고리 -->
  <div>
    <label>카테고리</label>
    <select name="categoryId" required>
      <c:forEach var="c" items="${categories}">
        <!-- CategoryDTO: categoryId, categoryName -->
        <option value="${c.categoryId}">${c.categoryName}</option>
      </c:forEach>
    </select>
  </div>

  <!-- 지역 -->
  <div>
    <label>지역</label>
    <select name="locationId" required>
      <c:forEach var="l" items="${locations}">
        <!-- LocationDTO: locationId, region -->
        <option value="${l.locationId}">${l.region}</option>
      </c:forEach>
    </select>
  </div>

  <!-- 상품 상태(컨디션) -->
  <div>
    <label>상품 상태</label>
    <select name="conditionId" required>
      <c:forEach var="cn" items="${conditions}">
        <!-- ConditionDTO: conditionId, conditionName -->
        <option value="${cn.conditionId}">${cn.conditionName}</option>
      </c:forEach>
    </select>
  </div>




  <div style="display:flex; gap:8px; justify-content:flex-end;">
    <button type="reset">초기화</button>
    <button type="submit" class="submit">등록</button>
  </div>
</form>

</body>
</html>
