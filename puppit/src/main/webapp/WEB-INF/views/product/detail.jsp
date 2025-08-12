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

	<c:if test="${not empty product}">
		<input type="hidden" name="productId"
			value="${product.productId}" />

		<div>
			<label>상품명</label> <input type="text" name="productName" value="${product.productName}" />
		</div>

		<div>
			<label>가격(원)</label> <input type="number" name="productPrice" value="${product.productPrice}"
				readonly="readonly"/>	
		</div>

		<label>설명</label>
    	<textarea name="productDescription" >${product.productDescription}</textarea>
		<div>
	</c:if>
  </div>
  



</body>
</html>
