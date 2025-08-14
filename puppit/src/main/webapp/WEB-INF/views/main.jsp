<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="./layout/header.jsp" />

<script>
  const msg = "${msg}";
  if (msg && msg.trim() !== "") 
	  alert(msg);
</script>

<style>
  .container {
    max-width:1200px;
    margin:0 auto;
    padding:24px 20px 60px;
    background:#fff;
  }
  
  .product-grid {
    display:grid;
    grid-template-columns:repeat(4,1fr);
    gap:22px;
  }
  
  @media (max-width:1024px){
    .product-grid {
      grid-template-columns:repeat(3,1fr)
    }
  }
  @media (max-width:768px){
    .product-grid {
      grid-template-columns:repeat(2,1fr)
    }
  }

  /* 카드 자체를 a로 사용 */
  .product-card{display:block;text-decoration:none;color:inherit}
  .thumb {
    width:100%;
    aspect-ratio:1/1;
    object-fit:cover;
    border-radius:12px;
    border:1px solid #ececef;
    background:#fafafa;
  }
  
  .title {
    margin-top:8px;
    font-size:14px;
    color:#111;
    font-weight:600;
    line-height:1.3
  }
  .desc {
    margin-top:2px;
    font-size:12px;
    color:#6b7280;
    line-height:1.35;
    max-height:3.6em;
    overflow:hidden;
    display:-webkit-box;
    -webkit-line-clamp:3;
    -webkit-box-orient:vertical;
  }
  
  .price {
    margin-top:4px;
    font-size:14px;
    font-weight:700;
  }
</style>

<div class="container">
  <c:if test="${not empty products}">
    <div class="product-grid" id="productGrid">
      <c:forEach items="${products}" var="p">
        <a class="product-card" href="${contextPath}/product/detail/${p.productId}">
          <div class="title">${p.productName}</div>
          <div class="desc">${p.productDescription}</div>
          <div class="price">
            <fmt:formatNumber value="${p.productPrice}" type="number" groupingUsed="true"/>원
          </div>
        </a>
      </c:forEach>
    </div>
  </c:if>

  <!-- 검색 결과 영역 -->
  <div id="search-results"></div>
</div>

<script>
(function () {
  console.log('[search] boot');

  var contextPath = '${contextPath}';
  var input = document.getElementById('search-input');
  var btn = document.getElementById('do-search');
  var results = document.getElementById('search-results');
  var mainGrid = document.getElementById('productGrid'); // 메인 상품 목록

  function formatPrice(v) {
    if (v === null || v === undefined) return '';
    try { return new Intl.NumberFormat('ko-KR').format(v) + '원'; }
    catch (e) { return v + '원'; }
  }

   function render(list, keyword) {
    if (!Array.isArray(list)) list = [];

    if (!list.length) {
      results.innerHTML =
        '<div class="result-head"><b>"' + keyword + '"</b> 검색 결과 0건</div>' +
        '<div class="empty">조건에 맞는 상품이 없습니다.</div>';
      return;
    }

    var head = '<div class="result-head"><b>"' + keyword + '"</b> 검색 결과 ' + list.length + '건</div>';
    var cards = list.map(function (p) {
      var id = p.productId;
      var name = p.productName ? p.productName : '';
      var price = formatPrice(p.productPrice);
      var imgSrc = p.productImage
        ? (contextPath + '/uploads/' + p.productImage)
        : (contextPath + '/resources/image/no-image.png');

      return ''
        + '<div class="card">'
        + '  <a href="' + contextPath + '/product/detail/' + id + '">'
        + '    <img src="' + imgSrc + '" alt="" style="width:100%;height:180px;object-fit:cover;border-radius:8px;">'
        + '    <div class="name">' + name + '</div>'
        + '    <div class="price">' + price + '</div>'
        + '  </a>'
        + '</div>';
    }).join('');

    results.innerHTML = head + '<div class="grid">' + cards + '</div>';
    results.scrollIntoView({ behavior: 'smooth', block: 'start' });
  } 

  async function search(keyword) {
    var q = (keyword || '').trim();
    if (!q) {
      results.innerHTML = '<div class="empty">검색어를 입력하세요.</div>';
      if (mainGrid) mainGrid.style.display = 'grid'; // 검색어 없으면 다시 보여줌
      return;
    }

    // 검색 시작 시 메인 상품 목록 숨기기
    if (mainGrid) mainGrid.style.display = 'none';

    results.innerHTML = '<div class="empty">검색 중...</div>';

    var url = contextPath + '/product/search?searchName=' + encodeURIComponent(q);
    console.log('[search] fetch:', url);

    try {
      const res = await fetch(url, { headers: { 'Accept': 'application/json' } });
      if (!res.ok) throw new Error('HTTP ' + res.status);
      
      const data = await res.json();
      var list = Array.isArray(data) ? data : [];
      render(list, q);
    } catch (err) {
      console.error('[search] fetch error:', err);
      results.innerHTML = '<div class="empty">검색 중 오류가 발생했습니다.</div>';
    }
  }

  // Enter로 검색
  input.addEventListener('keydown', function (e) {
    if (e.key === 'Enter') {
      search(input.value);
    }
  });

  // 돋보기 클릭
  btn.addEventListener('click', function () {
    search(input.value);
  });

  window.__search = search;
})();
</script>
