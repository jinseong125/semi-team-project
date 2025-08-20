<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<!-- Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<style>
/* ===== 기존 스타일 ===== */
.header {display:flex;justify-content:space-between;align-items:flex-start;max-width:1200px;margin:0 auto;padding:16px 20px;}
.left {display:flex;align-items:flex-start;gap:18px;}
.left-col {display:flex;flex-direction:column;gap:14px;min-width:420px;}
.searchBar {position:relative;width:100%;max-width:600px;}
.searchBar .input {width:85%;height:44px;padding:0 44px 0 40px;border:1px solid #e5e7eb;border-radius:12px;background:#f5f7fa;outline:none;}
.searchBar .fa-magnifying-glass {position:absolute;left:14px;top:50%;transform:translateY(-50%);color:#666;cursor:pointer;}
.meta-row{display:flex;align-items:center;gap:16px;}
.category{position:relative;display:inline-flex;align-items:center;gap:10px;padding:10px 14px;border:1px solid #e5e7eb;border-radius:12px;background:#fff;cursor:pointer;}
.category select{appearance:none;border:none;background:transparent;font:inherit;outline:none;padding-right:22px;}
.category .chev{position:absolute;right:10px;pointer-events:none;color:#444;font-size:12px;}
.right{display:flex;flex-direction:column;align-items:flex-end;gap:12px;}
a{text-decoration:none;color:inherit;}
.top-actions{display:flex;gap:10px;}
.btn{padding:6px 12px;border:1px solid #d1d5db;border-radius:8px;background:#fff;cursor:pointer;}
.btn.dark{background:#111;color:#fff;border-color:#111;}
.bottom-actions{display:flex;gap:10px;}
#search-results {max-width:1200px;margin:0 auto;padding:0 20px 24px;}
.result-head {margin:10px 0 16px;color:#374151;}
.empty {padding:24px 8px;color:#6b7280;}
.grid {display:grid;grid-template-columns:repeat(4, 1fr);gap:16px;}
.card {border:1px solid #ececef;border-radius:12px;padding:10px;background:#fff;}
.card .name {margin-top:8px;font-weight:600;}
.card .price {margin-top:4px;color:#555;}

/* 자동완성 리스트 */
#autocompleteList {
  position:absolute;top:48px;left:0;width:85%;
  background:#fff;border:1px solid #ddd;border-radius:8px;
  display:none;z-index:1000;max-height:200px;overflow-y:auto;
  list-style:none;padding:0;margin:0;
}
#autocompleteList li {
  padding:10px 14px;cursor:pointer;border-bottom:1px solid #f3f3f3;
}
#autocompleteList li:hover {background:#f9f9f9;}

/* 인기검색어 */

#top-keywords {margin-top:4px;font-size:14px;color:#444;}
#top-keywords .keyword {margin-right:8px;color:#0073e6;cursor:pointer;}
#top-keywords .keyword:hover {text-decoration:underline;}

</style>
</head>

<body>
<div class="header">
  <!-- 왼쪽 -->
  <div class="left">
    <a class="logo" href="${contextPath}">
      <img src="${contextPath}/resources/image/DOG.jpg" alt="puppit" width="100">
    </a>

    <div class="left-col">
      <!-- 검색창 -->
      <div class="searchBar">
        <i class="fa-solid fa-magnifying-glass" id="do-search"></i>
        <input type="text" class="input" id="search-input" placeholder="검색어를 입력하세요" autocomplete="off">
        <ul id="autocompleteList"></ul>
      </div>

      <!-- 인기검색어 -->
      <div id="top-keywords">로딩 중...</div>

      <!-- 카테고리 -->
      <div class="meta-row">
        <label class="category">
          <select id="categorySelect">
            <option>카테고리</option>
            <option>사료</option>
            <option>간식</option>
            <option>외출용품</option>
            <option>기타용품</option>
          </select>
          <i class="fa-solid fa-chevron-down chev"></i>
        </label>
      </div>
    </div>
  </div>

  <!-- 오른쪽 -->
  <div class="right">
    <div class="top-actions">
    <c:choose>
      <c:when test="${empty sessionScope.sessionMap.accountId}">
        <a href="${contextPath}/user/login" class="btn">로그인</a>
        <a href="${contextPath}/user/signup" class="btn">회원가입</a>
      </c:when>
      <c:otherwise>
        <div>${sessionScope.sessionMap.nickName}님 환영합니다!</div>
        <a href="${contextPath}/user/mypage">마이페이지</a>
        <a href="${contextPath}/user/logout">로그아웃</a>
      </c:otherwise>
    </c:choose>
    </div>
    <div class="bottom-actions">
      <a href="${contextPath}/product/myproduct" class="btn dark">상품 관리</a>
    </div>
  </div>
</div>

<div id="search-results"></div>
<hr>
<script>
  const contextPath = "${pageContext.request.contextPath}";
  const input = document.getElementById("search-input");

  var btn = document.getElementById('do-search');
  var results = document.getElementById('search-results');
  var autoList = document.getElementById('autocompleteList');
  
  document.addEventListener("DOMContentLoaded", () => {
    loadTopKeywords();
  });
  document.getElementById("categorySelect").addEventListener("change", function() {
	const value = this.value;
	if(value) {
		loadCategory(value);
	}
  });
  
  async function loadCategory(categoryName) {
	  results.innerHTML = '<div class="empty">카테고리 불러오는 중...</div>';

	  try {
	    const res = await fetch("${contextPath}/category/product?categoryName=" + encodeURIComponent(categoryName), {
	      headers: { "Accept": "application/json" }
	    });
	    if (!res.ok) throw new Error("HTTP " + res.status);

	    const data = await res.json(); // Controller가 JSON 응답하도록 @ResponseBody 필요
	    console.log("[loadCategory] parsed data:", data);

	    render(data, categoryName); // 기존 render() 함수 재사용
	  } catch (err) {
	    console.error("[loadCategory] fetch error:", err);
	    results.innerHTML = '<div class="empty">카테고리 불러오기 오류</div>';
	  }
	}
  
  
  
  
  
  

  // ===================== 인기검색어 =====================
  async function loadTopKeywords() {
    try {
      const res = await fetch(contextPath + "/search/top");
      if (!res.ok) throw new Error("HTTP " + res.status);
      const data = await res.json();

      console.log("[loadTopKeywords] API Response:", data);

      let html = "";
      data.slice(0, 10).forEach(item => {
        const keyword = item.searchKeyword; 
        if (keyword) {
          html += `<span class="keyword">#` + keyword + `</span>`;
        }
      });

      const topKeywordsElement = document.getElementById("top-keywords");
      if (!topKeywordsElement) throw new Error("top-keywords element not found");
      topKeywordsElement.innerHTML = html;

      // 클릭 이벤트 바인딩
      document.querySelectorAll("#top-keywords .keyword").forEach(el => {
        el.addEventListener("click", () => {
          const kw = el.textContent.replace("#", "");
          input.value = kw;
          search(kw);
        });
      });
    } catch (err) {
      console.error("인기검색어 불러오기 에러:", err);
      document.getElementById("top-keywords").innerHTML = "인기검색어를 불러올 수 없습니다.";
    }
  }

  // ===================== 자동완성 =====================
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
      var name = p.productName || '';
      var price = formatPrice(p.productPrice);

      return ''
        + '<div class="card">'
        + '  <a href="' + contextPath + '/product/detail/' + id + '">'
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
      return;
    }
    results.innerHTML = '<div class="empty">검색 중...</div>';

    var url = contextPath + '/product/search?searchName=' + encodeURIComponent(q);
    console.log('[search] fetch:', url);

    try {
      const res = await fetch(url, { headers: { 'Accept': 'application/json' } });
      if (!res.ok) throw new Error('HTTP ' + res.status);

      const data = await res.json();
      console.log('[search] parsed data:', data);
      render(Array.isArray(data) ? data : [], q);
    } catch (err) {
      console.error('[search] fetch error:', err);
      results.innerHTML = '<div class="empty">검색 중 오류가 발생했습니다.</div>';
    }
  }

  // ===================== 이벤트 =====================
  input.addEventListener("keyup", async () => {
    const keyword = input.value.trim();
    if (keyword.length === 0) {
      autoList.style.display = "none";
      return;
    }
    try {
      const res = await fetch(contextPath + "/product/autocomplete?keyword=" + encodeURIComponent(keyword));
      const data = await res.json();

      autoList.innerHTML = "";
      if (data.length > 0) {
        data.forEach(item => {
          const li = document.createElement("li");
          li.textContent = item;
          li.addEventListener("click", () => {
            input.value = item;
            search(item);
            autoList.style.display = "none";
          });
          autoList.appendChild(li);
        });
        autoList.style.display = "block";
      } else {
        autoList.style.display = "none";
      }
    } catch (err) {
      console.error("자동완성 에러:", err);
    }
  });

  input.addEventListener("blur", () => {
    setTimeout(() => { autoList.style.display = "none"; }, 200);
  });

  input.addEventListener('keydown', function (e) {
    if (e.key === 'Enter') search(input.value);
  });

  btn.addEventListener('click', function () {
    search(input.value);
  });

  window.__search = search;
</script>



