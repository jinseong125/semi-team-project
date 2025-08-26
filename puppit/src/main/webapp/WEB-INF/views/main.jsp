<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="./layout/header.jsp" />

 <script type="application/json" id="flash-msg"><c:out value='${msg}'/></script>
 <script>
   (function () {
     var el = document.getElementById('flash-msg');
     var msg = el ? el.textContent : '';
     if (msg && msg.trim() !== '') alert(msg);
   })();
 </script>

<style>
  html, body { 
    height: 100%; 
    margin: 0; 
    padding: 0; 
    background: #fff;
    font-family: 'Pretendard', 'Noto Sans KR', sans-serif;
  }

  body { 
  min-height: 100vh;  /* vh - ViewPoint Height (브라우저 화면 높이) */
  }

  .container { 
    max-width: 1200px;
    margin: 0 auto; 
    padding: 24px 20px 60px;
    background: #fff; 
    min-height: 400px; 
  }

  /* ===== 상품 그리드 ===== */
  .product-grid { 
    display: grid; 
    grid-template-columns: repeat(5, 1fr); 
    gap: 24px; 
  }
  @media (max-width:1024px){ .product-grid { grid-template-columns: repeat(3, 1fr); } }
  @media (max-width:768px){ .product-grid { grid-template-columns: repeat(2, 1fr); } }

  /* ===== 상품 카드 ===== */
  .product-card { 
    display: block; 
    text-decoration: none; 
    color: inherit; 
    background: #fff;
    border-radius: 14px; 
    border: 1px solid #ececef; 
    overflow: hidden;
    transition: all 0.25s ease-in-out;
    box-shadow: 0 1px 4px rgba(0,0,0,0.06);
  }

  .product-card:hover {
    transform: translateY(-6px) scale(1.02);
    box-shadow: 0 10px 20px rgba(0,0,0,0.12);
  }

  /* ===== 썸네일 이미지 ===== */
  .thumb { 
    width: 100%; 
    aspect-ratio: 1/1; 
    object-fit: cover; 
    border-bottom: 1px solid #f1f1f1; 
    background: #f8f8f8; 
    transition: transform 0.3s ease;
  }
  .product-card:hover .thumb {
    transform: scale(1.05); /* 이미지 살짝 확대 */
  }

  /* ===== 상품명 ===== */
  .title { 
    margin: 10px 12px 4px;
    font-size: 15px; 
    color: #111; 
    font-weight: 600; 
    line-height: 1.4;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  /* ===== 설명 ===== */
  .desc { 
    margin: 0 12px 6px;
    font-size: 13px; 
    color: #6b7280; 
    line-height: 1.4; 
    max-height: 2.8em; 
    overflow: hidden; 
    display: -webkit-box; 
    -webkit-line-clamp: 2; 
    -webkit-box-orient: vertical; 
  }

  /* ===== 가격 ===== */
  .price { 
    margin: 0 12px 12px;
    font-size: 15px; 
    font-weight: 700; 
    color: #e74c3c; /* 강조색 */
  }

  /* ===== 검색 박스 ===== */
  .search-box { 
    display: flex; 
    gap: 8px; 
    margin-bottom: 24px; 
    align-items: center; 
  }

  .search-input { 
    flex: 1; 
    padding: 10px 14px; 
    font-size: 15px; 
    border: 1px solid #ddd; 
    border-radius: 8px; 
    outline: none;
    transition: border-color 0.2s, box-shadow 0.2s;
  }
  .search-input:focus {
    border-color: #4a90e2;
    box-shadow: 0 0 4px rgba(74,144,226,0.4);
  }

  .search-btn { 
    padding: 10px 18px; 
    font-size: 15px; 
    background: #111; 
    color: #fff; 
    border: none; 
    border-radius: 8px; 
    cursor: pointer; 
    transition: background 0.2s;
  }
  .search-btn:hover {
    background: #333;
  }

  /* ===== 검색 결과 ===== */
  #search-results { background: #fff; }
  .empty { text-align: center; padding: 20px; color: #777; }
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
(() => {
  const input   = document.getElementById('search-input');
  const btn     = document.getElementById('do-search');
  const results = document.getElementById('search-results');
  const mainGrid= document.getElementById('productGrid');
  const size    = 40;

  let loading = false;
  let endOfData = false;

  // 초기 로드된 카드 개수 기준 오프셋
  let offset = mainGrid ? mainGrid.querySelectorAll('.product-card').length : 0;

  // 같은 offset 중복 호출 방지
  let lastRequestedOffset = -1;

  // 이미 렌더된 상품ID 추적(중복표시 방지; 선택사항)
  const seenIds = new Set(
    Array.from(mainGrid ? mainGrid.querySelectorAll('.product-card') : [])
      .map(a => {
        try {
          // href: /product/detail/{id}
          const parts = a.getAttribute('href').split('/');
          return Number(parts[parts.length - 1]);
        } catch (_) { return null; }
      })
      .filter(Boolean)
  );

  const formatPrice = v => {
    if (v == null) return '';
    try { return new Intl.NumberFormat('ko-KR').format(v) + '원'; }
    catch { return v + '원'; }
  };

  const appendProducts = (list) => {
    if (!Array.isArray(list) || !list.length) return;

    let html = '';
    let added = 0;

    for (const p of list) {
      const id    = p.productId;
      if (!id || seenIds.has(id)) continue; // 중복/이상치 건너뛰기
      seenIds.add(id);

      const name  = p.productName || '';
      const price = p.productPrice ? formatPrice(p.productPrice) : '';
      const desc  = p.productDescription || '';

      // 썸네일 안전하게 선택 (thumbnail.imageUrl -> thumbImageUrl -> no-image)
      const imgUrl =
        (p.thumbnail && p.thumbnail.imageUrl) ? p.thumbnail.imageUrl :
        (p.thumbImageUrl ? p.thumbImageUrl : (contextPath + '/resources/image/no-image.png'));

      html +=
        '<a class="product-card" href="' + contextPath + '/product/detail/' + id + '">' +
          '<img class="thumb" src="' + imgUrl + '" alt="상품이미지 없음">' +
          '<div class="title">' + name + '</div>' +
          '<div class="price">' + price + '</div>' +
        '</a>';

      added++;
    }

    if (added > 0) {
      mainGrid.insertAdjacentHTML('beforeend', html);
      // 실제로 붙인 개수만큼 offset 갱신
      offset = mainGrid.querySelectorAll('.product-card').length;
    }
  };

  let currentFilter = { q:'', category:'', sort:'DESC' };
    
  const fetchProducts = async () => {
    if (loading || endOfData) return;
    if (offset === lastRequestedOffset) return; // 같은 offset 재요청 방지
    lastRequestedOffset = offset;

    loading = true;
    
    const url =
    	  contextPath + "/product/list?offset=" + offset + "&size=" + size
    	  + (currentFilter.q ? "&q=" + encodeURIComponent(currentFilter.q) : "")
    	  + (currentFilter.category ? "&category=" + encodeURIComponent(currentFilter.category) : "")
    	  + "&sort=" + encodeURIComponent(currentFilter.sort);


    try {
      const res = await fetch(url, { headers: { 'Accept': 'application/json' } });
      if (!res.ok) throw new Error("HTTP " + res.status);

      const data  = await res.json();
      const list  = Array.isArray(data.products) ? data.products : [];
      const total = Number.isFinite(data.itemCount) ? data.itemCount : null;
      const more  = (typeof data.hasMore === 'boolean') ? data.hasMore : null;

      if (list.length > 0) {
        const before = offset;
        appendProducts(list);

        // 종료 판정: hasMore 우선, 없으면 itemCount/길이로 판단
        if (more !== null) {
          endOfData = !more;
        } else if ((total !== null && offset >= total) || list.length < size) {
          endOfData = true;
        }

        // 서버가 중복을 보내서 하나도 안 붙었다면 다음 페이지 시도 (옵션)
        if (offset === before && !endOfData) {
          lastRequestedOffset = -1; // 바로 다음 offset으로 재시도 허용
          offset += size;
          return fetchProducts();
        }
      } else {
        endOfData = true;
      }
    } catch (e) {
      console.error(e);
      endOfData = true;
    } finally {
      loading = false;
    }
  };
  window.fetchProducts = fetchProducts;

  // 검색(필요 시 유지)
  const search = async (keyword) => {
    const q = (keyword || '').trim();
    if (!q) {
      results.innerHTML = '<div class="empty">검색어를 입력하세요.</div>';
      results.style.display = "block";
      if (mainGrid) mainGrid.style.display = 'grid';
      return;
    }
    
    if (mainGrid) mainGrid.style.display = 'none';
    results.innerHTML = '<div class="empty">검색 중...</div>';
    results.style.display = "block";
    const url = contextPath + '/product/search?searchName=' + encodeURIComponent(q);
    
    try {
      const res = await fetch(url, { headers: { 'Accept': 'application/json' } });
      if (!res.ok) throw new Error('HTTP ' + res.status);
      const data = await res.json();
      const list = Array.isArray(data) ? data : [];
      const head  = '<div class="result-head"><b>"' + q + '"</b> 검색 결과 ' + list.length + '건</div>';
      const cards = list.map(p => makeProductCardHTML(p, contextPath)).join('');
      results.innerHTML = head + '<div class="product-grid">' + cards + '</div>';

      results.style.display = "block";
      results.scrollIntoView({ behavior: 'smooth', block: 'start' });
    } catch (err) {
      results.innerHTML = '<div class="empty">검색 중 오류가 발생했습니다.</div>';
      results.style.display = "block";
    }
  };

  input && input.addEventListener('keydown', (e) => {
    if (e.key === 'Enter') search(input.value);
  });
  btn && btn.addEventListener('click', () => search(input.value));
  input && input.addEventListener('input', () => {
    if (!input.value.trim()) {
      results.style.display = "none";
      if (mainGrid) mainGrid.style.display = 'grid';
    }
  });

  // 스크롤 핸들러 (디바운스)
  let scrollTimer;
  window.addEventListener('scroll', () => {
    if (scrollTimer) clearTimeout(scrollTimer);
    scrollTimer = setTimeout(() => {
    	if (loading || endOfData) return;
    	if (document.documentElement.scrollTop + window.innerHeight >= document.documentElement.scrollHeight - 100) {
    	  fetchProducts();
    	}

    }, 50);
  });

  // 초기 화면이 짧을 때 자동으로 채우기(옵션)
  const fillIfShort = async () => {
    while (!endOfData &&
           mainGrid &&
           mainGrid.style.display !== 'none' &&
           document.documentElement.scrollHeight <= window.innerHeight) {
      await fetchProducts();
    }
  };
  document.addEventListener('DOMContentLoaded', fillIfShort);
  window.search = search;

  //메인에서 현재 필터(카테고리/검색어) 상태를 가지고 있다고 가정
  const filter = { category: '', q: '', sort: 'DESC' }; // 예시
  
//헤더에서 날아오는 필터 적용 이벤트 수신
  window.addEventListener('puppit:applyFilter', (e) => {
    const { q = '', category = '' } = e.detail || {};
    const results = document.getElementById('search-results');
    const mainGrid = document.getElementById('productGrid');
    console.log('category: ', category);

    // 무한스크롤 상태 초기화
    offset = 0;
    endOfData = false;
    lastRequestedOffset = -1;
    seenIds.clear();

    // 상태 초기화
    if (results) { results.style.display = 'none'; results.innerHTML = ''; }
    if (mainGrid) { mainGrid.innerHTML = ''; mainGrid.style.display = 'grid'; }

    // 필터 갱신
    currentFilter = { ...currentFilter, q, category };

    // 검색창 input 값도 동기화
    const input = document.getElementById('search-input');
    if (input) input.value = q;

    // ✅ 무조건 fetchProducts 실행
    fetchProducts();
  });

  
  async function loadCategory(categoryName) {
	    const results = document.getElementById('search-results');
	    const mainGrid = document.getElementById('productGrid');

	    if (mainGrid) mainGrid.style.display = 'none';
	    results.style.display = 'block';
	    results.innerHTML = '<div class="empty">카테고리 불러오는 중...</div>';

	    try {
	    	//
	      const url = contextPath + "/product/list?offset=0&size=40&category=" + encodeURIComponent(categoryName);
	      const res = await fetch(url, { headers: { 'Accept': 'application/json' } });
	      if (!res.ok) throw new Error('HTTP ' + res.status);
	      
	      const data = await res.json();
	      const list = Array.isArray(data.products) ? data.products : [];
	      const total = Number.isFinite(data.itemCount) ? data.itemCount : list.length;

	      const cards = list.map(p => makeProductCardHTML(p, contextPath)).join('');
	      results.innerHTML =
	        '<div class="result-head"><b>"' + categoryName + '"</b> 검색 결과 ' + total + '건</div>' +
	        '<br>' +
	        '<div class="product-grid">' + cards + '</div>';

	      results.scrollIntoView({ behavior: 'smooth', block: 'start' });
	    } catch (e) {
	      console.error(e);
	      results.innerHTML = '<div class="empty">카테고리 불러오기 오류</div>';
	    }
	  }



  window.loadCategory = loadCategory;

  function makeProductCardHTML(p, contextPath) {
	  const id    = p.productId;
	  const name  = p.productName || '';
	  const price = (p.productPrice != null)
	    ? (new Intl.NumberFormat('ko-KR').format(p.productPrice) + '원') : '';
	  const img   =
	    (p.thumbnail && p.thumbnail.imageUrl) ? p.thumbnail.imageUrl
	      : (p.productImage ? (contextPath + '/uploads/' + p.productImage)
	      : (contextPath + '/resources/image/no-image.png'));

	  return (
	    '<a class="product-card" href="' + contextPath + '/product/detail/' + id + '">' +
	    '  <img class="thumb" src="' + img + '" alt="상품이미지 없음">' +
	    '  <div class="title">' + name + '</div>' +
	    '  <div class="price">' + price + '</div>' +
	    '</a>'
	  );
	}
  
  
})();



</script>
