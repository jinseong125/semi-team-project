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
/* ===== 상품 그리드 ===== */
.product-grid {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 24px;
}

@media ( max-width :1024px) {
  .product-grid {
    grid-template-columns: repeat(3, 1fr);
  }
}

@media ( max-width :768px) {
  .product-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

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
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.06);
}

.product-card:hover {
  transform: translateY(-6px) scale(1.02);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.12);
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
  transform: scale(1.05);
}

/* ===== 상품명 ===== */
.product-title {
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
.product-desc {
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
.product-price {
  margin: 0 12px 12px;
  font-size: 15px;
  font-weight: 700;
  color: #e74c3c;
}

/* ===== 검색 결과 ===== */
#search-results { background: #fff; }

.empty {
  text-align: center;
  padding: 20px;
  color: #777;
}
</style>


<div class="container">
  <!-- 상품 리스트 -->
  <c:if test="${not empty products}">
    <div class="product-grid" id="productGrid">
      <c:forEach items="${products}" var="p">
        <a class="product-card" href="${contextPath}/product/detail/${p.productId}">
<img class="thumb"
     src="${p.thumbnail.imageUrl}"
     alt="${p.productName}"
     onerror="this.onerror=null; this.src='${contextPath}/resources/image/no-image.png';">
          <div class="product-title">${p.productName}</div>
          <div class="product-desc">${p.productDescription}</div>
          <div class="product-price">
            <fmt:formatNumber value="${p.productPrice}" type="number" groupingUsed="true"/>원
          </div>
        </a>
      </c:forEach>
    </div>
  </c:if>
</div>


<script>
(() => {
  document.addEventListener('DOMContentLoaded', () => {
    const params = new URLSearchParams(window.location.search);
    const q = params.get("q");
    const category = params.get("category");

    if (q) {
      search(q);
    } else if (category) {
      loadCategory(category);
    } else {
      fillIfShort();
    }
  });

  const mainGrid = document.getElementById('productGrid');
  const size    = 40;

  let loading = false;
  let endOfData = false;
  let offset = mainGrid ? mainGrid.querySelectorAll('.product-card').length : 0;
  let lastRequestedOffset = -1;

  const seenIds = new Set(
    Array.from(mainGrid ? mainGrid.querySelectorAll('.product-card') : [])
      .map(a => {
        try {
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
      if (!id || seenIds.has(id)) continue;
      seenIds.add(id);

      const name  = p.productName || '';
      const price = p.productPrice ? formatPrice(p.productPrice) : '';
      const imgUrl =
        (p.thumbnail && p.thumbnail.imageUrl) ? p.thumbnail.imageUrl :
        (p.thumbImageUrl ? p.thumbImageUrl : (contextPath + '/resources/image/no-image.png'));

      html +=
        '<a class="product-card" href="' + contextPath + '/product/detail/' + id + '">' +
          '<img class="thumb" src="' + imgUrl + '" alt="상품이미지 없음">' +
          '<div class="product-title">' + name + '</div>' +
          '<div class="product-price">' + price + '</div>' +
        '</a>';

      added++;
    }

    if (added > 0) {
      mainGrid.insertAdjacentHTML('beforeend', html);
      offset = mainGrid.querySelectorAll('.product-card').length;
    }
  };

  let currentFilter = { q:'', category:'', sort:'DESC' };
    
  const fetchProducts = async () => {
    if (loading || endOfData) return;
    if (offset === lastRequestedOffset) return;
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

        if (more !== null) {
          endOfData = !more;
        } else if ((total !== null && offset >= total) || list.length < size) {
          endOfData = true;
        }

        if (offset === before && !endOfData) {
          lastRequestedOffset = -1;
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

  // 스크롤 핸들러
  let scrollTimer;
  function scrollHandler() {
    if (scrollTimer) clearTimeout(scrollTimer);
    scrollTimer = setTimeout(() => {
      if (loading || endOfData) return;
      if (document.documentElement.scrollTop + window.innerHeight >= document.documentElement.scrollHeight - 100) {
        fetchProducts();
      }
    }, 50);
  }
  window.addEventListener("scroll", scrollHandler);

  // 초기 화면이 짧을 때 자동으로 채우기
  const fillIfShort = async () => {
    while (!endOfData &&
           mainGrid &&
           mainGrid.style.display !== 'none' &&
           document.documentElement.scrollHeight <= window.innerHeight) {
      await fetchProducts();
    }
  };

  // 헤더에서 필터 이벤트 수신
  window.addEventListener('puppit:applyFilter', (e) => {
    const { q = '', category = '' } = e.detail || {};
    offset = 0;
    endOfData = false;
    lastRequestedOffset = -1;
    seenIds.clear();

    if (mainGrid) { mainGrid.innerHTML = ''; mainGrid.style.display = 'grid'; }

    currentFilter = { ...currentFilter, q, category };

    const input = document.getElementById('search-input');
    if (input) input.value = q;

    fetchProducts();
  });

  async function loadCategory(categoryName) {
    offset = 0;
    endOfData = false;
    lastRequestedOffset = -1;
    seenIds.clear();
    mainGrid.innerHTML = "";

    currentFilter = { ...currentFilter, category: categoryName, q: "" };

    await fetchProducts();
  }
  window.loadCategory = loadCategory;

  async function search(keyword) {
    const q = (keyword || "").trim();
    if (!q) return;

    offset = 0;
    endOfData = false;
    lastRequestedOffset = -1;
    seenIds.clear();
    mainGrid.innerHTML = "";

    currentFilter = { ...currentFilter, q, category: "" };

    await fetchProducts();
  }

})();
</script>
