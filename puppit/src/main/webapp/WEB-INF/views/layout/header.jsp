<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" scope="request" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<!-- Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<style>
/* ===== 헤더 기본 레이아웃 ===== */
.header {display:flex;justify-content:space-between;align-items:flex-start;max-width:1200px;margin:0 auto;padding:16px 20px;}
.left {display:flex;align-items:flex-start;gap:18px;}
.left-col {display:flex;flex-direction:column;gap:14px;min-width:420px;}
.searchBar {position:relative;width:100%;max-width:600px;}
.searchBar .input {width:85%;height:44px;padding:0 44px 0 40px;border:1px solid #e5e7eb;border-radius:12px;background:#f5f7fa;outline:none;}
.searchBar .fa-magnifying-glass {position:absolute;left:14px;top:50%;transform:translateY(-50%);color:#666;cursor:pointer;}
.meta-row{display:flex;align-items:center;gap:16px;}
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

/* ===== 카테고리 셀렉트 박스 ===== */
.category {
  position: relative;
  display: inline-flex;
  align-items: center;
}

.category select {
  appearance: none;
  border: 1px solid #d1e3ff;
  border-radius: 12px;
  background: #f9fbff;
  font: inherit;
  outline: none;
  padding: 10px 36px 10px 14px;
  cursor: pointer;
  color: #333;
  transition: all 0.2s ease-in-out;
}

/* hover 효과 */
.category select:hover {
  border-color: #4a90e2;
  box-shadow: 0 0 6px rgba(74,144,226,0.3);
}

/* focus 효과 */
.category select:focus {
  border-color: #1c6dd0;
  box-shadow: 0 0 6px rgba(28,109,208,0.4);
}

/* 옵션 스타일 */
.category select option {
  padding: 10px;
  border-radius: 8px;
  background: #fff;
}

/* 드롭다운 아이콘 */
.category .chev {
  position: absolute;
  right: 14px;
  pointer-events: none;
  color: #4a90e2;
  font-size: 12px;
}

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

/* 알림 팝업 */
#alarmArea {
  background:#fffbe7;
  border:1px solid #ffe066;
  border-radius:10px;
  padding:10px 18px;
  font-size:15px;
  color:#8d6708;
  max-width:340px;
  min-width:200px;
  box-sizing:border-box;
  word-break:break-word;
  z-index:5000;
  position:fixed;
  top:24px;
  right:24px;
  margin:0;
  display:none;
  box-shadow: 0 4px 16px rgba(0,0,0,0.08);
}
#alarmArea ul {margin:0; padding:0; list-style:none;}
#alarmArea li {margin-bottom:6px;}
#alarmArea .alarm-close {
  position:absolute;
  top:10px;
  right:14px;
  background:transparent;
  border:none;
  font-size:18px;
  color:#c8a700;
  cursor:pointer;
  z-index:10;
  padding:0;
  line-height:1;
}

#alarmBell.red {
  color: #e74c3c !important;
  transform: scale(1.2);
  transition: color 0.2s, transform 0.2s;
}


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
            <option value="">카테고리</option>
            <option value="사료">사료</option>
            <option value="간식">간식</option>
            <option value="외출용품">외출용품</option>
            <option value="기타용품">기타용품</option>
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
         
        <button id="alarmBell" style="background:none;border:none;display:none;cursor:pointer;font-size:22px;margin-left:8px;" title="알림창 열기">
	       <i class="fa-regular fa-bell"></i>
	    </button>
        <a href="${contextPath}/user/logout">로그아웃</a>
        <!-- 채팅 버튼 -->
        <button id="chatBtn" class="btn" style="background:black;color:#6c757d;" onclick="location.href='${contextPath}/chat/recentRoomList'" title="채팅방 목록으로 이동">
          <i class="fa-regular fa-comment-dots"></i> 채팅
        </button>
      </c:otherwise>
    </c:choose>
    </div>
    <div class="bottom-actions">
      <a href="${contextPath}/product/myproduct" class="btn dark">상품 관리</a>
    </div>
  </div>
</div>
  <div id="alarmArea"></div>
<div id="search-results"></div>

<hr>

<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1.6.1/dist/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.2/stomp.min.js"></script>
<script>
	// JSP에서 세션 정보를 JS 변수로 전달
	var contextPath = "${pageContext.request.contextPath}";
	const userId = "${sessionScope.sessionMap.userId}";
	const isLoggedIn = "${not empty sessionScope.sessionMap.accountId}";
	const input = document.getElementById("search-input");

	let stompClient = null;
	//채팅방 접속 상태
	let currentChatRoomId = null;
	let alarmShownOnce = false;
	
	
	
  var btn = document.getElementById('do-search');
  var results = document.getElementById('search-results');
  var autoList = document.getElementById('autocompleteList');
  
  // 1. 페이지가 로딩될 때마다 알림 닫힘 상태를 항상 false로 초기화!



let alarmClosed = false; // 팝업 닫힘 상태
let alarmArea, alarmBell;

document.addEventListener("DOMContentLoaded", function() {
  alarmArea = document.getElementById("alarmArea");
  alarmBell = document.getElementById("alarmBell");

  if (isLoggedIn === "true" && userId && !isNaN(userId)) {
    if (localStorage.getItem('puppitAlarmClosed') === null) {
      alarmClosed = false;
      localStorage.setItem('puppitAlarmClosed', 'false');
    } else {
      alarmClosed = localStorage.getItem('puppitAlarmClosed') === 'true';
    }

    if (!alarmClosed) {
      alarmArea.style.display = "block";
      alarmBell.style.display = "none";
      loadAlarms();
      setInterval(loadAlarms, 30000);
      connectSocket();
    } else {
      alarmArea.style.display = "none";
      alarmArea.innerHTML = "";
      alarmBell.style.display = "inline-block";
      connectSocket(); // 팝업이 닫혀있어도 소켓은 연결!
    }
  }

  if (alarmBell) {
    alarmBell.addEventListener("click", function() {
      alarmClosed = false;
      localStorage.setItem('puppitAlarmClosed', 'false');
      alarmArea.style.display = "block";
      alarmBell.style.display = "none";
      loadAlarms();
      window.alarmInterval = setInterval(loadAlarms, 30000);
      alarmBell.classList.remove('red');
    });
  }
});
//1. 웹소켓 연결 및 구독 (알림+채팅 모두)
  function connectSocket() {
    var socket = new SockJS(contextPath + '/ws-chat');
    stompClient = Stomp.over(socket);
    stompClient.connect({}, function(frame) {
        // 알림 메시지 구독 (모든 알림)
        stompClient.subscribe('/topic/notification', function(msg) {
          console.log('msg: ', msg);
          let notification = JSON.parse(msg.body);
          console.log('notification: ', notification);
          // 본인에게 온 알림만
          if (String(notification.receiverAccountId || notification.userId) !== String(userId)) {
        	  console.log('여기서 걸리나');
        	  showAlarmPopup([notification]);
        	  return;
          }
        	  
          // [핵심] 채팅방에 접속중이 아닐 때 알림 팝업!
          if (String(currentChatRoomId) !== String(notification.roomId)) {
        	  console.log('현재 채팅방 접속중 아님');
            showAlarmPopup([notification]);
            const alarmBell = document.getElementById("alarmBell");
            if (alarmBell) {
              alarmBell.classList.add('red');
              alarmBell.style.display = "inline-block";
            }
          }
        });
        // 채팅 메시지 구독 (모든 채팅방)
        stompClient.subscribe('/topic/chat', function(msg) {
          let chat = JSON.parse(msg.body);
          // 본인에게 온 메시지라면 무시 (알림만 뜨게 할 경우 상대방이 보낸 것만)
          if (String(chat.chatSenderAccountId) === String(userId)) return;
          // [핵심] 채팅방에 접속중이 아닐 때 알림 팝업!
          if (String(currentChatRoomId) !== String(chat.chatRoomId)) {
            showAlarmPopup([chat]);
            const alarmBell = document.getElementById("alarmBell");
            if (alarmBell) {
              alarmBell.classList.add('red');
              alarmBell.style.display = "inline-block";
            }
          }
        });
      });
 }

//접속자 관리 함수 (채팅방 입장/퇴장시 호출)
	function setUserInRoom(roomId, role) {
		if (!activeRooms[roomId]) activeRooms[roomId] = { buyer: false, seller: false };
		activeRooms[roomId][role.toLowerCase()] = true;
		currentChatRoomId = roomId;
	}
	function setUserOutRoom(roomId, role) {
		if (!activeRooms[roomId]) return;
		activeRooms[roomId][role.toLowerCase()] = false;
		currentChatRoomId = null;
	}
	function isUserInRoom(roomId, role) {
		return activeRooms[roomId] && activeRooms[roomId][role.toLowerCase()];
	}
	// 알림 팝업 처리
	function showAlarmPopup(alarms = [], force = false) {
	  console.log('showAlarmPopup 호출, alarms:', alarms);

	  // alarms가 배열인지 확인 및 변환
	  if (!Array.isArray(alarms)) alarms = [alarms];

	  // forEach로 먼저 모든 값 찍기 (디버깅)
	  alarms.forEach((alarm, idx) => {
	    console.log(`forEach alarm[${idx}]:`, alarm);
	  });

	  // filter 내부에서도 찍힘
	  const msgIdSet = new Set();
	  const deduped = alarms.filter((alarm, idx) => {
	    console.log(`filter alarm[${idx}]:`, alarm);
	    if (!alarm || !alarm.roomId || !alarm.messageId) return false;
	    if (msgIdSet.has(alarm.messageId)) return false;
	    msgIdSet.add(alarm.messageId);
	    return true;
	  });

	  // deduped 결과도 찍기
	  console.log('deduped:', deduped);

	  var alarmArea = document.getElementById("alarmArea");
	  var html = '<button class="alarm-close" onclick="closeAlarmPopup()" title="닫기">&times;</button><ul>';
	  deduped.forEach(function(alarm) {
	    html += '<li>'
	      + '<a href="' + contextPath + '/chat/recentRoomList?highlightRoomId=' + alarm.roomId  + '&highlightMessageId=' + (alarm.messageId || '') + '" style="color:inherit;text-decoration:none;">'
	      + '<b>새 메시지:</b> ' + (alarm.chatMessage || '')
	      + ' <span style="color:#aaa;">(' + (alarm.productName || '') + ')</span>'
	      + ' <span style="color:#888;">' + (alarm.messageCreatedAt || '') + '</span><br>'
	      + '<span style="font-size:13px;">From: ' + (alarm.senderAccountId || '') + ' | To: ' + (alarm.receiverAccountId || '') + '</span>'
	      + '</li>';
	  });
	  html += '</ul>';
	  alarmArea.innerHTML = html;
	  alarmArea.style.display = "block";
	  alarmShownOnce = true;
	}

	  function closeAlarmPopup() {
		    var alarmArea = document.getElementById("alarmArea");
		    alarmArea.style.display = "none";
		    alarmArea.innerHTML = "";
		    var alarmBell = document.getElementById("alarmBell");
		    if (alarmBell) alarmBell.style.display = "inline-block";
		    if(window.alarmInterval) clearInterval(window.alarmInterval);
		    alarmClosed = true;
		    localStorage.setItem('puppitAlarmClosed', 'true');
		  }

	  function loadAlarms() {
		    var alarmArea = document.getElementById("alarmArea");  
		    if (alarmClosed) {
		    	console.log('alarm closed');
		      alarmArea.style.display = "none";
		      alarmArea.innerHTML = "";
		      var alarmBell = document.getElementById("alarmBell");
		      if (alarmBell) alarmBell.style.display = "inline-block";
		      return;
		    }
		    if (!userId || isNaN(userId)) {
		      alarmArea.innerHTML = "";
		      alarmArea.style.display = "none";
		      return;
		    }
		    fetch(contextPath + "/api/alarm?userId=" + userId)
		      .then(res => {
		        if (!res.ok) throw new Error("서버 오류");
		        return res.json();
		      })
		      .then(data => {
		    	  console.log('data: ', data);
		        if (data.length === 0) {
		          alarmArea.innerHTML = "";
		          alarmArea.style.display = "none";
		          var alarmBell = document.getElementById("alarmBell");
		          if (alarmBell) alarmBell.style.display = "inline-block";
		        } else {
		          showAlarmPopup(data);
		        }
		      })
		      .catch(err => {
		        console.error(err);
		        alarmArea.innerHTML = '<span style="color:red;">알림을 불러올 수 없습니다.</span>';
		        alarmArea.style.display = "block";
		        showAlarmPopup([], true);
		      });
		  }

  

  
  
  
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
      const res = await fetch("${contextPath}/search/top");
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
          const kw = el.textContent.replace("#", "").trim();
          input.value = kw;

          // 메인 상품 숨기기
          const mainGrid = document.getElementById("productGrid");
          if (mainGrid) mainGrid.style.setProperty("display", "none", "important");

          // 결과 영역 보이기
          results.style.display = "block";
          results.innerHTML = '<div class="empty">"' + kw + '" 검색 중...</div>';

          // 기존 검색 함수 실행
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
  document.addEventListener("DOMContentLoaded", function() {
	  const categorySelect = document.getElementById("categorySelect");
	  if (categorySelect) {
	    categorySelect.addEventListener("change", function() {
	      const selected = this.value;
	      if (selected && selected !== "카테고리") {
	        loadCategory(selected);
	      }
	    });
	  }
	});


  window.__search = search;
</script>



