<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>

<!-- 안전한 기본값 주입 -->
<c:if test="${empty contextPath}">
  <c:set var="contextPath" value="${pageContext.request.contextPath}" />
</c:if>
<c:if test="${empty loginUserId}">
  <c:set var="loginUserId" value="${sessionScope.sessionMap.accountId}" />
</c:if>
<c:if test="${empty userId}">
  <c:set var="userId" value="${sessionScope.sessionMap.userId}" />
</c:if>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />

<!-- Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />

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

/* 카테고리 셀렉트 */
.category { position: relative; display: inline-flex; align-items: center; }
.category select {
  appearance: none; border: 1px solid #d1e3ff; border-radius: 12px; background: #f9fbff;
  font: inherit; outline: none; padding: 10px 36px 10px 14px; cursor: pointer; color: #333;
  transition: all .2s;
}
.category select:hover { border-color: #4a90e2; box-shadow: 0 0 6px rgba(74,144,226,.3);}
.category select:focus { border-color: #1c6dd0; box-shadow: 0 0 6px rgba(28,109,208,.4); }
.category .chev { position:absolute; right:14px; pointer-events:none; color:#4a90e2; font-size:12px; }

/* 자동완성 리스트 */
#autocompleteList {
  position:absolute; top:48px; left:0; width:85%;
  background:#fff; border:1px solid #ddd; border-radius:8px;
  display:none; z-index:1000; max-height:200px; overflow-y:auto; list-style:none; padding:0; margin:0;
}
#autocompleteList li { padding:10px 14px; cursor:pointer; border-bottom:1px solid #f3f3f3; }
#autocompleteList li:hover { background:#f9f9f9; }

/* 인기검색어 */
#top-keywords {margin-top:4px;font-size:14px;color:#444;}
#top-keywords .keyword {margin-right:8px;color:#0073e6;cursor:pointer;}
#top-keywords .keyword:hover {text-decoration:underline;}

/* 알림 팝업 */
#alarmArea {
  background:#fffbe7; border:1px solid #ffe066; border-radius:10px; padding:10px 18px;
  font-size:15px; color:#8d6708; max-width:340px; min-width:200px; box-sizing:border-box; word-break:break-word;
  z-index:5000; position:fixed; top:24px; right:24px; display:none; margin:0;
  box-shadow:0 4px 16px rgba(0,0,0,.08);
}
#alarmArea ul {margin:0; padding:0; list-style:none;}
#alarmArea li {margin-bottom:6px;}
#alarmArea .alarm-close {
  position:absolute; top:10px; right:14px; background:transparent; border:none; font-size:18px; color:#c8a700;
  cursor:pointer; z-index:10; padding:0; line-height:1;
}
#alarmBell.red { color:#e74c3c !important; transform:scale(1.2); transition:color .2s, transform .2s; }
</style>
</head>

<body>
<!-- ===== 헤더 ===== -->
<div class="header">
  <!-- 좌측: 로고 + 검색/카테고리 -->
  <div class="left">
    <a class="logo" href="${contextPath}">
      <img src="${contextPath}/resources/image/DOG.jpg" alt="puppit" width="100" />
    </a>

    <div class="left-col">
      <!-- 검색창 -->
      <div class="searchBar">
        <i class="fa-solid fa-magnifying-glass" id="do-search"></i>
        <input type="text" class="input" id="search-input" placeholder="검색어를 입력하세요" autocomplete="off" />
        <ul id="autocompleteList"></ul>
      </div>

      <!-- 인기검색어 -->
      <div id="top-keywords">로딩 중...</div>

      <!-- 카테고리 -->
      <div class="meta-row">
        <label class="category">
          <select id="categorySelect">
            <option value="" disabled selected hidden>카테고리</option>
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

  <!-- 우측: 사용자/버튼 -->
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
<hr />

<!-- 라이브러리 -->
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1.6.1/dist/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.2/stomp.min.js"></script>



<script>



// ===== 전역 컨텍스트 (한 번만 정의) =====
window.contextPath = "${contextPath}";
window.loginUserId = "${loginUserId}";
window.userId      = "${userId}";
const isLoggedIn   = "${not empty sessionScope.sessionMap.accountId}" === "true";

// DOM
const input     = document.getElementById("search-input");
const btn       = document.getElementById("do-search");
const autoList  = document.getElementById("autocompleteList");
const alarmArea = document.getElementById("alarmArea");
const alarmBell = document.getElementById("alarmBell");
const categorySelect = document.getElementById("categorySelect");

// 헤더 → 메인에게 "이 필터로 다시 불러!" 알림
function applyFilter(partial) {
  window.dispatchEvent(new CustomEvent('puppit:applyFilter', { detail: partial || {} }));
}

// ===== 인기검색어 =====
async function loadTopKeywords() {
  const top = document.getElementById("top-keywords");
  try {
    const res = await fetch(contextPath + "/search/top", { headers: { 'Accept': 'application/json' } });
    if (!res.ok) throw new Error("HTTP " + res.status);

    const data = await res.json();

    if (!Array.isArray(data) || data.length === 0) {
      top.textContent = "인기검색어가 없습니다.";
      return;
    }

    // 공백 제거 후 최대 5개만 사용 (혹시 서버에서 더 내려올 수도 있으니 방어)
    const keywords = data
      .map(k => (k ?? '').toString().trim())
      .filter(Boolean)
      .slice(0, 5);

    if (keywords.length === 0) {
      top.textContent = "인기검색어가 없습니다.";
      return;
    }

    // DOM으로 안전하게 렌더링
    top.innerHTML = '';
    keywords.forEach(kw => {
      const span = document.createElement('span');
      span.className = 'keyword';
      span.dataset.kw = kw;
      span.textContent = '#' + kw;
      span.style.marginRight = '8px';
      span.addEventListener('click', () => {
        const input = document.getElementById('search-input');
        if (input) input.value = kw;
        applyFilter({ q: kw, category: '' });
      });
      top.appendChild(span);
    });
  } catch (e) {
    console.error(e);
    top.textContent = "인기검색어를 불러올 수 없습니다.";
  }
}




// ===== 자동완성 =====
input && input.addEventListener("keyup", async () => {
  const keyword = input.value.trim();
  if (keyword.length === 0) { autoList.style.display = "none"; return; }

  try {
    const res = await fetch(contextPath + "/product/autocomplete?keyword=" + encodeURIComponent(keyword));
    const data = await res.json();
    autoList.innerHTML = "";
    if (Array.isArray(data) && data.length > 0) {
      data.forEach(item => {
        const li = document.createElement("li");
        li.textContent = item;
        li.addEventListener("click", () => {
          input.value = item;
          applyFilter({ q: item, category: '' });
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
input && input.addEventListener("blur", () => setTimeout(() => autoList.style.display = "none", 200));

// 검색 실행
function doSearch() {
  const q = (input?.value || '').trim();
  if (!q) return;
  applyFilter({ q, category: '' });
}
input && input.addEventListener('keydown', e => { if (e.key === 'Enter') doSearch(); });
btn   && btn.addEventListener('click', doSearch);

// ===== 카테고리 변경 시 메인으로 이벤트만 전달 =====
categorySelect && categorySelect.addEventListener("change", function() {
  const selected = this.value;
  if (selected && selected !== "카테고리") {
    applyFilter({ category: selected, q: '' });
  }
});

// ===== 알림 & 채팅 =====
let stompClient = null;
let currentChatRoomId = null;
const activeRooms = {};
let alarmClosed = false;

// 접속자 관리
function setUserInRoom(roomId, role) {
  if (!activeRooms[roomId]) activeRooms[roomId] = { buyer:false, seller:false };
  activeRooms[roomId][(role || '').toLowerCase()] = true;
  currentChatRoomId = roomId;
}
function setUserOutRoom(roomId, role) {
  if (!activeRooms[roomId]) return;
  activeRooms[roomId][(role || '').toLowerCase()] = false;
  currentChatRoomId = null;
}
function isUserInRoom(roomId, role) {
  return activeRooms[roomId] && activeRooms[roomId][(role || '').toLowerCase()];
}

function closeAlarmPopup() {
  alarmArea.style.display = "none";
  alarmArea.innerHTML = "";
  if (alarmBell) alarmBell.style.display = "inline-block";
  if (window.alarmInterval) clearInterval(window.alarmInterval);
  alarmClosed = true;
  localStorage.setItem('puppitAlarmClosed', 'true');
}

function removeUnreadBadge(roomId) {
  document.querySelectorAll('.chatList[data-room-id="' + roomId + '"] .unread-badge').forEach(badge => {
    badge.style.display = 'none';
    badge.textContent = '';
  });
}
function removeAlarmPopupRoom(roomId) {
  const links = alarmArea.querySelectorAll('.alarm-link[data-room-id="' + roomId + '"]');
  links.forEach(link => {
    const li = link.closest('li');
    if (li) li.remove();
  });
  const remain = alarmArea.querySelectorAll('.alarm-link');
  if (remain.length === 0) closeAlarmPopup();
}
function showAlarmPopup(alarms = []) {
  const arr = Array.isArray(alarms) ? alarms : [alarms];
  const ids = new Set();
  const dedup = arr.filter(a => a && a.roomId && a.messageId && !ids.has(a.messageId) && ids.add(a.messageId));

  const roomGroups = {};
  dedup.forEach(a => {
    const r = a.roomId;
    if (!roomGroups[r]) roomGroups[r] = { alarms: [], lastAlarm: null, count: 0 };
    roomGroups[r].alarms.push(a);
  });
  Object.keys(roomGroups).forEach(r => {
    const list = roomGroups[r].alarms;
    list.sort((a,b) => new Date(b.chatCreatedAt||b.messageCreatedAt||0) - new Date(a.chatCreatedAt||a.messageCreatedAt||0));
    roomGroups[r].lastAlarm = list[0];
    roomGroups[r].count = list.length;
  });

  alarmClosed = false;
  localStorage.setItem('puppitAlarmClosed', 'false');

  let html = '<button class="alarm-close" onclick="closeAlarmPopup()" title="닫기">&times;</button><ul>';
  Object.values(roomGroups).forEach(g => {
    const a = g.lastAlarm || {};
    html += '<li>'
      + '<a href="javascript:void(0);" class="alarm-link"'
      + ' data-room-id="' + (a.roomId||'') + '"'
      + ' data-message-id="' + (a.messageId||'') + '"'
      + ' data-chat-message="' + ((a.chatMessage||'')+'').replace(/"/g, '&quot;') + '">'
      + '<b>새 메시지:</b> ' + (a.chatMessage || '')
      + ' <span style="color:#aaa;">(' + (a.productName||'') + ')</span>'
      + ' <span style="color:#888;">' + (a.messageCreatedAt||'') + '</span>'
      + (g.count>1 ? ' <span style="color:#e74c3c;font-weight:bold;">(안읽은 메시지 ' + g.count + '개)</span>' : '')
      + '<br><span style="font-size:13px;">From: '+(a.senderAccountId||'')+' | To: '+(a.receiverAccountId||'')+'</span>'
      + '</a></li>';
  });
  html += '</ul>';

  alarmArea.innerHTML = html;
  alarmArea.style.display = "block";
  if (alarmBell) { alarmBell.classList.add('red'); alarmBell.style.display = "inline-block"; }

  // 클릭 바인딩
  setTimeout(() => {
    alarmArea.querySelectorAll('.alarm-link').forEach(link => {
      link.addEventListener('click', () => {
        const roomId = link.getAttribute('data-room-id');
        const chatMessage = link.getAttribute('data-chat-message');
        const group = roomGroups[roomId];
        const count = group?.count || 1;

        // 읽음 처리
        const url = count > 1 ? '/api/alarm/readAll' : '/api/alarm/read';
        const body = count > 1
          ? { roomId, userId, count }
          : { roomId, userId, messageId: link.getAttribute('data-message-id') };

        fetch(contextPath + url, {
          method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(body)
        }).catch(console.error).finally(() => {
          removeUnreadBadge(roomId);
          removeAlarmPopupRoom(roomId);
        });

        // 채팅목록 갱신 or 이동
        const isChatListPage = window.location.pathname.indexOf('/chat/recentRoomList') !== -1;
        if (typeof window.highlightChatRoom === 'function' && isChatListPage) {
          window.highlightChatRoom(roomId);
          if (typeof window.updateChatListLastMessage === 'function') {
            window.updateChatListLastMessage(roomId, chatMessage);
          }
          closeAlarmPopup();
        } else {
          const url = contextPath + '/chat/recentRoomList'
            + '?highlightRoomId=' + encodeURIComponent(roomId)
            + '&highlightMessage=' + encodeURIComponent(chatMessage || '');
          window.location.href = url;
        }
      });
    });
  }, 30);
}

function loadAlarms() {
  if (alarmClosed || !userId || isNaN(userId)) {
    alarmArea.style.display = "none";
    alarmArea.innerHTML = "";
    if (alarmBell) alarmBell.style.display = "inline-block";
    return;
  }
  fetch(contextPath + "/api/alarm?userId=" + userId)
    .then(r => r.ok ? r.json() : Promise.reject(r.status))
    .then(data => {
      if (!Array.isArray(data) || data.length === 0) {
        alarmArea.innerHTML =
          '<button class="alarm-close" onclick="closeAlarmPopup()" title="닫기">&times;</button>' +
          '<div class="empty" style="padding-top:18px;">알림이 없습니다.</div>';
        alarmArea.style.display = "block";
        if (alarmBell) alarmBell.style.display = "none";
      } else {
        showAlarmPopup(data);
      }
    })
    .catch(err => {
      console.error('알림 로딩 에러:', err);
      alarmArea.innerHTML = '<span style="color:red;">알림을 불러올 수 없습니다.</span>';
      alarmArea.style.display = "block";
    });
}

function connectSocket() {
  const socket = new SockJS(contextPath + '/ws-chat');
  stompClient = Stomp.over(socket);
  stompClient.connect({}, () => {
    // 알림
    stompClient.subscribe('/topic/notification', (msg) => {
      const n = JSON.parse(msg.body || '{}');
      if (String(n.receiverAccountId) !== String(loginUserId)) return;              // 수신자만
      if (String(currentChatRoomId) === String(n.roomId)) return;                   // 같은 방에 있으면 무음
      showAlarmPopup([n]);
    });
    // 채팅
    stompClient.subscribe('/topic/chat', (msg) => {
      const chat = JSON.parse(msg.body || '{}');
      const toMe = (String(chat.chatReceiverAccountId) === String(loginUserId)) ||
                   (String(chat.chatReceiver) === String(userId));
      if (!toMe) return;
      if (String(currentChatRoomId) === String(chat.chatRoomId)) return;
      showAlarmPopup([chat]);
    });
  });
}

function loadUnreadCounts() {
  fetch(contextPath + '/api/chat/unreadCount?userId=' + userId)
    .then(r => r.json())
    .then(updateUnreadBadges)
    .catch(console.error);
}
function updateUnreadBadges(map) {
  document.querySelectorAll('.chat-room-item').forEach(room => {
    const roomId = room.getAttribute('data-room-id');
    const count = map?.[roomId] || 0;
    let badge = room.querySelector('.unread-badge');
    if (!badge) {
      badge = document.createElement('span');
      badge.className = 'unread-badge';
      room.appendChild(badge);
    }
    if (count > 0) { badge.textContent = count; badge.style.display = 'inline-block'; }
    else { badge.style.display = 'none'; badge.textContent = ''; }
  });
}

// 알림 종 클릭 시 팝업 열기
alarmBell && alarmBell.addEventListener("click", () => {
  alarmClosed = false;
  localStorage.setItem('puppitAlarmClosed', 'false');
  alarmArea.style.display = "block";
  alarmBell.style.display = "none";
  loadAlarms();
  window.alarmInterval = setInterval(loadAlarms, 30000);
  alarmBell.classList.remove('red');
});

// 초기화
document.addEventListener('DOMContentLoaded', () => {
  loadTopKeywords();

  // 알림 초기 상태
  if (isLoggedIn && userId && !isNaN(userId)) {
    const stored = localStorage.getItem('puppitAlarmClosed');
    alarmClosed = stored === 'true';
    if (!alarmClosed) {
      alarmArea.style.display = "block";
      if (alarmBell) alarmBell.style.display = "none";
      loadAlarms();
      window.alarmInterval = setInterval(loadAlarms, 30000);
    } else {
      alarmArea.style.display = "none";
      alarmArea.innerHTML = "";
      if (alarmBell) alarmBell.style.display = "inline-block";
    }
    connectSocket();
  }

  // 채팅 리스트 페이지면 미읽음 뱃지 로딩
  const isChatListPage = window.location.pathname.includes("/chat/recentRoomList");
  if (isLoggedIn && isChatListPage) loadUnreadCounts();
});

// 필요한 함수 전역 노출(다른 페이지에서 사용할 수 있게)
window.closeAlarmPopup = closeAlarmPopup;
window.removeUnreadBadge = removeUnreadBadge;
window.removeAlarmPopupRoom = removeAlarmPopupRoom;
</script>
</body>
</html>
