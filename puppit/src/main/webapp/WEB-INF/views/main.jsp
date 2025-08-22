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
  html, body {
    height: 100%; margin: 0; padding: 0; background: #fff; font-family: 'Pretendard', sans-serif;
  }
  body {
    min-height: 100vh; background: #fff;
  }
  .container {
    max-width: 1200px; margin: 0 auto; padding: 24px 20px 60px; background: #fff;
    min-height: 400px;
  }

  /* ===== 검색 박스 ===== */
  .search-box {
    display: flex; justify-content: center; gap: 8px; margin: 0 auto 28px auto;
    max-width: 600px;
  }
  .search-input {
    flex: 1; padding: 10px 14px; font-size: 15px;
    border: 1px solid #d1d5db; border-radius: 9999px;
    outline: none; transition: border .2s;
  }
  .search-input:focus {
    border-color: #111;
  }
  .search-btn {
    padding: 10px 18px; font-size: 15px; font-weight: 600;
    background: #111; color: #fff; border: none; border-radius: 9999px;
    cursor: pointer; transition: background .2s;
  }
  .search-btn:hover { background: #333; }

  /* ===== 상품 그리드 ===== */
.product-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: 22px;
  justify-content: center;   /* 가운데 정렬 */
}

#search-results .grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
  gap: 16px;
  justify-content: center;   /* 가운데 정렬 */
}

  @media (max-width: 1024px) { .product-grid { grid-template-columns: repeat(3, 1fr); } }
  @media (max-width: 768px) { .product-grid { grid-template-columns: repeat(2, 1fr); } }
  @media (max-width: 480px) { .product-grid { grid-template-columns: repeat(1, 1fr); } }

  .product-card {
    display: block; text-decoration: none; color: inherit;
    border-radius: 12px; padding: 8px;
    transition: transform .2s, box-shadow .2s;
  }
  .product-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 4px 12px rgba(0,0,0,0.08);
  }
  .thumb {
    width: 100%; aspect-ratio: 1/1; object-fit: cover;
    border-radius: 12px; border: 1px solid #ececef; background: #fafafa;
  }
  .title {
    margin-top: 10px; font-size: 15px; font-weight: 600; color: #111;
    overflow: hidden; white-space: nowrap; text-overflow: ellipsis;
  }
  .desc {
    margin-top: 4px; font-size: 13px; color: #6b7280;
    line-height: 1.35; max-height: 2.7em;
    overflow: hidden; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical;
  }
  .price {
    margin-top: 6px; font-size: 15px; font-weight: 700; color: #111;
  }

  /* ===== 검색 결과 ===== */
  #search-results {
    margin-top: 20px;
  }
  #search-results .result-head {
    font-size: 14px; margin-bottom: 12px;
  }
  #search-results .grid {
    display: grid; grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
    gap: 16px;
  }
  #search-results .card {
    border: 1px solid #e5e7eb; border-radius: 10px; overflow: hidden;
    transition: transform .2s, box-shadow .2s;
  }
  #search-results .card:hover {
    transform: translateY(-3px);
    box-shadow: 0 4px 12px rgba(0,0,0,0.08);
  }
  #search-results .name {
    font-size: 14px; font-weight: 500; margin: 6px 8px; overflow: hidden;
    white-space: nowrap; text-overflow: ellipsis;
  }
  #search-results .price {
    font-size: 14px; font-weight: 600; margin: 0 8px 8px 8px;
  }
  .empty {
    padding: 40px 0; text-align: center; color: #6b7280;
  }
</style>

<div class="container">




  <!-- 상품 리스트 -->
  <c:if test="${not empty products}">
    <div class="product-grid" id="productGrid">
      <c:forEach items="${products}" var="p">
        <a class="product-card" href="${contextPath}/product/detail/${p.productId}">
          <img class="thumb" src="${p.thumbnail.imageUrl}" alt="상품이미지 없음">
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
	  var results = document.getElementById('search-results');
	  var mainGrid = document.getElementById('productGrid');
	  var input = document.getElementById('search-input');
	  var btn = document.getElementById('do-search');

	  var size = 60;
	  var loading = false;
	  var endOfData = false;
	  var offset = mainGrid ? mainGrid.children.length : 0; // ✅ 초기 렌더 개수 기준
	  var lastRequestedOffset = -1; // 같은 offset 중복 호출 방지

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
      return;
    }
    var cards = list.map(function (p) {
      var id = p.productId;
      var name = p.productName || '';
      var price = p.productPrice ? new Intl.NumberFormat('ko-KR').format(p.productPrice) + '원' : '';
      var desc = p.productDescription || '';
      var imgUrl =
        (p.thumbnail && p.thumbnail.imageUrl) ? p.thumbnail.imageUrl :
        (p.thumbImageUrl ? p.thumbImageUrl : (contextPath + '/resources/image/no-image.png'));
      return (
        '<a class="product-card" href="' + contextPath + '/product/detail/' + id + '">' +
        '<img class="thumb" src="' + imgUrl + '" alt="상품이미지 없음">' +
        '<div class="title">' + name + '</div>' +
        '<div class="desc">' + desc + '</div>' +
        '<div class="price">' + price + '</div>' +
        '</a>'
      );
    }).join('');
    mainGrid.insertAdjacentHTML('beforeend', cards);
  }

  async function fetchProducts() {
	  if (loading || endOfData) return;

	  // 같은 offset 중복 요청 가드
	  if (offset === lastRequestedOffset) return;
	  lastRequestedOffset = offset;

	  loading = true;
	  const url = contextPath + "/product/list?offset=" + offset + "&size=" + size;

	  try {
	    const res = await fetch(url, { headers: { 'Accept': 'application/json' } });
	    if (!res.ok) throw new Error("HTTP " + res.status);

	    const data = await res.json();

	    // 백엔드 키 사용: products, itemCount, hasMore
	    const list = Array.isArray(data.products) ? data.products : [];
	    const total = Number.isFinite(data.itemCount) ? data.itemCount : null;
	    const more  = (typeof data.hasMore === 'boolean') ? data.hasMore : null;

	    if (list.length > 0) {
	      appendProducts(list);

	      // ① offset 갱신 (append 이후)
	      offset = mainGrid.children.length;
	      
	      if (more !== null) {
	          endOfData = !more;
	        }
	        else if (total !== null && offset >= total) {
	          endOfData = true;
	        }
	    } else {
	      endOfData = true;
	    }
	  } catch (e) {
	    console.error(e);
	    endOfData = true; // 실패 시 무한 루프 방지
	  } finally {
	    loading = false;
	  }
	}


  let scrollTimer;
  window.addEventListener('scroll', function () {
    if (scrollTimer) clearTimeout(scrollTimer);
    scrollTimer = setTimeout(() => {
      if (results && results.style.display !== "none" && results.innerHTML.trim() !== "") return;
      if (loading || endOfData || !mainGrid || mainGrid.style.display === 'none') return;

      if (document.documentElement.scrollTop + window.innerHeight >= document.documentElement.scrollHeight - 100) {
        fetchProducts();
      }
    }, 200);
  });

  // ------- 카테고리 선택 이벤트 ------- 
  var categorySelect = document.getElementById('categorySelect');

  categorySelect && categorySelect.addEventListener('change', function () {
    var value = categorySelect.value;

    if (!value) {
      // 카테고리 선택 안 했으면 메인 상품 다시 보이게
      if (mainGrid) mainGrid.style.display = 'grid';
      results.style.display = 'none';
      return;
    }

    // 카테고리 선택 시 메인 상품 숨기고 결과 영역 보여줌
    if (mainGrid) mainGrid.style.setProperty("display", "none", "important");
    results.style.display = 'block';
    results.innerHTML = '<div class="empty">카테고리 검색 중...</div>';

    var url = contextPath + '/product/category?categoryName=' + encodeURIComponent(value);
    fetch(url, { headers: { 'Accept': 'application/json' } })
      .then(res => res.json())
      .then(data => {
        var list = Array.isArray(data) ? data : [];
        renderSearch(list, value); // 기존 검색 결과 함수 재활용
      })
      .catch(() => {
        results.innerHTML = '<div class="empty">카테고리 검색 중 오류 발생</div>';
      });
  });

})(); 

  async function fillIfShort() {
    // 검색 모드가 아니고, 메인 그리드가 보이며, 스크롤이 안 생겼을 때
    while (!endOfData &&
           mainGrid &&
           mainGrid.style.display !== 'none' &&
           document.documentElement.scrollHeight <= window.innerHeight) {
      await fetchProducts();
    }
  }

  // DOM 준비되면 한 번 호출
  document.addEventListener('DOMContentLoaded', fillIfShort);



	

</script>
