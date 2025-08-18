<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="./layout/header.jsp" />

<script>
  const msg = "${msg}";
  if (msg && msg.trim() !== "") alert(msg);
</script>

<style>
  html, body { height: 100%; margin: 0; padding: 0; background: #fff; }
  body { min-height: 100vh; background: #fff; }
  .container { max-width:1200px; margin:0 auto; padding:24px 20px 60px; background:#fff; min-height: 400px; }
  .product-grid { display:grid; grid-template-columns:repeat(4,1fr); gap:22px; }
  @media (max-width:1024px){ .product-grid { grid-template-columns:repeat(3,1fr) } }
  @media (max-width:768px){ .product-grid { grid-template-columns:repeat(2,1fr) } }
  .product-card { display:block; text-decoration:none; color:inherit; min-height:200px; }
  .thumb { width:100%; aspect-ratio:1/1; object-fit:cover; border-radius:12px; border:1px solid #ececef; background:#fafafa; }
  .title { margin-top:8px; font-size:14px; color:#111; font-weight:600; line-height:1.3 }
  .desc { margin-top:2px; font-size:12px; color:#6b7280; line-height:1.35; max-height:3.6em; overflow:hidden; display:-webkit-box; -webkit-line-clamp:3; -webkit-box-orient:vertical; }
  .price { margin-top:4px; font-size:14px; font-weight:700; }
  .search-box { display:flex; gap:8px; margin-bottom:24px; align-items:center; }
  .search-input { flex:1; padding:8px 14px; font-size:15px; border:1px solid #bbb; border-radius:6px; }
  .search-btn { padding:8px 18px; font-size:15px; background:#111; color:#fff; border:none; border-radius:6px; cursor:pointer; }
  #search-results { background: #fff; }
</style>

<div class="container">

  <!-- 상품 리스트 -->
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
  <div id="search-results" style="display:none;"></div>
</div>

<script>
(function () {
  var contextPath = '${contextPath}';
  var input = document.getElementById('search-input');
  var btn = document.getElementById('do-search');
  var results = document.getElementById('search-results');
  var mainGrid = document.getElementById('productGrid');
  var size = 16;
  var loading = false;
  var endOfData = false;

  // offset을 직접 관리 (최초 렌더링된 상품 개수로 초기화)
  var offset = mainGrid ? mainGrid.children.length : 0;

  function formatPrice(v) {
    if (v === null || v === undefined) return '';
    try { return new Intl.NumberFormat('ko-KR').format(v) + '원'; }
    catch (e) { return v + '원'; }
  }

  function renderSearch(list, keyword) {
    if (!Array.isArray(list)) list = [];
    if (!list.length) {
      results.innerHTML =
        '<div class="result-head"><b>"' + keyword + '"</b> 검색 결과 0건</div>' +
        '<div class="empty">조건에 맞는 상품이 없습니다.</div>';
      results.style.display = "block";
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
    results.style.display = "block";
    results.scrollIntoView({ behavior: 'smooth', block: 'start' });
  }

  async function search(keyword) {
    var q = (keyword || '').trim();
    if (!q) {
      results.innerHTML = '<div class="empty">검색어를 입력하세요.</div>';
      results.style.display = "block";
      if (mainGrid) mainGrid.style.display = 'grid';
      return;
    }
    if (mainGrid) mainGrid.style.display = 'none';
    results.innerHTML = '<div class="empty">검색 중...</div>';
    results.style.display = "block";
    var url = contextPath + '/product/search?searchName=' + encodeURIComponent(q);
    try {
      const res = await fetch(url, { headers: { 'Accept': 'application/json' } });
      if (!res.ok) throw new Error('HTTP ' + res.status);
      const data = await res.json();
      var list = Array.isArray(data) ? data : [];
      renderSearch(list, q);
    } catch (err) {
      results.innerHTML = '<div class="empty">검색 중 오류가 발생했습니다.</div>';
      results.style.display = "block";
    }
  }

  input && input.addEventListener('keydown', function (e) {
    if (e.key === 'Enter') search(input.value);
  });

  btn && btn.addEventListener('click', function () {
    search(input.value);
  });

  input && input.addEventListener('input', function () {
    if (!input.value.trim()) {
      results.style.display = "none";
      if (mainGrid) mainGrid.style.display = 'grid';
    }
  });

  // ------- 무한 스크롤 기능 -------
  function appendProducts(list) {
    if (!Array.isArray(list) || !list.length) {
      console.log("appendProducts: 추가할 상품 없음");
      return;
    }
    var cards = list.map(function (p) {
      var id = p.productId;
      var name = p.productName || '';
      var price = p.productPrice ? new Intl.NumberFormat('ko-KR').format(p.productPrice) + '원' : '';
      var desc = p.productDescription || '';
      return (
        '<a class="product-card" href="' + contextPath + '/product/detail/' + id + '">' +
        '<div class="title">' + name + '</div>' +
        '<div class="desc">' + desc + '</div>' +
        '<div class="price">' + price + '</div>' +
        '</a>'
      );
    }).join('');
    mainGrid.insertAdjacentHTML('beforeend', cards);
  }

  window.addEventListener('scroll', async function () {
	  if (results && results.style.display !== "none" && results.innerHTML.trim() !== "") return;
	  if (loading || endOfData || !mainGrid || mainGrid.style.display === 'none') return;

	  if ((window.innerHeight + window.scrollY) >= document.body.offsetHeight - 200) {
	    loading = true;

	    // 스크롤 시점에서 최신 offset 계산
	    offset = mainGrid ? mainGrid.children.length : offset;
	    console.log("offset:", offset);

	    const url = contextPath + "/product/list?offset=" + offset + "&size=" + size;
	    console.log("Fetching:", url);

	    try {
	      const res = await fetch(url, { headers: { 'Accept': 'application/json' } });
	      if (!res.ok) throw new Error("HTTP " + res.status);
	      
	      const data = await res.json();
	      const products = Array.isArray(data.products) ? data.products : [];
	      console.log("products.length:", products.length);

	      if (products.length > 0) {
	        appendProducts(products);
	        // fetch 성공 후 offset 업데이트
	        offset = mainGrid.children.length;
	        if (products.length < size) endOfData = true;
	      } else {
	        endOfData = true;
	      }
	    } catch (e) {
	      console.error(e);
	    }
	    loading = false;
	  }
	});
})();
</script>