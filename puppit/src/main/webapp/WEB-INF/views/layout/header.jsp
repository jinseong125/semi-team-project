<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!-- contextPath 변수 선언 (조건부!) -->
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
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<!-- Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<style>
/* ===== 헤더 기본 레이아웃 ===== */

.header {
display:flex;
justify-content:space-between;
align-items:flex-start;
max-width:1200px;
margin:0 auto;
padding:16px 20px;
}
.left {
display:flex;
align-items:flex-start;
gap:18px;
}
.left-col {
display:flex;
flex-direction:column;
gap:14px;
min-width:420px;
}
.searchBar {
position:relative;
width:100%;
max-width:600px;
}
.searchBar .input {
width:85%;
height:44px;
padding:0 44px 0 40px;
border:1px solid #e5e7eb;
border-radius:12px;
background:#f5f7fa;
outline:none;
}
.searchBar .fa-magnifying-glass {
position:absolute;
left:14px;
top:50%;
transform:translateY(-50%);
color:#666;
cursor:pointer;
}
.meta-row {
display:flex;
align-items:center;
gap:16px;
}
.right {
display:flex;
flex-direction:column;
align-items:flex-end;
gap:12px;
}
a {
text-decoration:none;
color:inherit;
}
.top-actions {
display:flex;
gap:10px;
}
/* 공통 버튼 */
.btn {
  padding:6px 12px;
  border:1px solid #d1d5db;
  border-radius:8px;
  background:#fff;
  cursor:pointer;
  transition: all 0.2s ease-in-out; /* 부드럽게 변화 */
}

/* 기본 버튼 hover (로그인/회원가입 등) */
.btn:hover {
  background:#f5f7fa;   /* 연한 회색 배경 */
  border-color:#aaa;    /* 테두리 살짝 진하게 */
  color:#111;           /* 글자 조금 더 진하게 */
}

/* 어두운 버튼 (상품 관리) */
.btn.dark {
  background:#111;
  color:#fff;
  border-color:#111;
}

/* dark 버튼 hover */
.btn.dark:hover {
  background:#333;   /* 더 밝은 회색 검정 */
  border-color:#333;
}


/* 카테고리 셀렉트 */
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
  transition: all .2s;
}
.category select:hover { 
border-color: #4a90e2; 
box-shadow: 0 0 6px rgba(74,144,226,.3);
}
.category select:focus { 
border-color: #1c6dd0; 
box-shadow: 0 0 6px rgba(28,109,208,.4); 
}
.category .chev { 
position:absolute; 
right:14px; 
pointer-events:none; 
color:#4a90e2; 
font-size:12px; 
}

/* 자동완성 리스트 */
#autocompleteList {
  position:absolute; 
  top:48px; 
  left:0;
  width:85%;
  background:#fff; 
  border:1px solid #ddd; 
  border-radius:8px;
  display:none; 
  z-index:1000; 
  max-height:200px; 
  overflow-y:auto; 
  list-style:none;
  padding:0; 
  margin:0;
}
#autocompleteList li { 
padding:10px 14px; 
cursor:pointer; 
border-bottom:1px solid #f3f3f3; 
}
#autocompleteList li:hover { 
background:#f9f9f9; 
}


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

.notification {
    position: fixed;
    right: 20px;
    top: 20px;    /* 항상 화면 위쪽에 */
    z-index: 9999;  /* 다른 요소 위에 보이게 */
    width: 300px;
    background-color: #f9f9f9;
    border: 1px solid #ccc;
    padding: 10px;
    border-radius: 5px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    transition: right 1s;
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
      <button id="chatBtn" class="btn" style="background:black;color:#6c757d;" title="채팅방 목록으로 이동">
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

<hr>

<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1.6.1/dist/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.2/stomp.min.js"></script>

<script>
	
//===== 전역 컨텍스트 =====
window.contextPath = "${contextPath}";
window.loginUserId = "${loginUserId}";
window.userId      = "${userId}";
window.myAccountId = "${loginUserId}";
window.notificationSubscription = null;
let stompClient = null;
let currentChatRoomId = null;

// DOM
const input     = document.getElementById("search-input");
const btn       = document.getElementById("do-search");
const autoList  = document.getElementById("autocompleteList");
const alarmArea = document.getElementById("alarmArea");
let alarmBell = document.getElementById("alarmBell");
const categorySelect = document.getElementById("categorySelect");

//=== 수정: isLoggedIn 전역 변수 정의 (에러 방지!) ===
const isLoggedIn = "${not empty sessionScope.sessionMap.accountId}" === "true";


// 헤더 → 메인에게 "이 필터로 다시 불러!" 알림
function applyFilter(partial) {
  window.dispatchEvent(new CustomEvent('puppit:applyFilter', { detail: partial || {} }));
}

	

	
	let alarmShownOnce = false;
	//let contextPath = "${contextPath}";
	//  let loginUserId = "${loginUserId}";
	//  let userId = "${userId}";
	
	
 
  var results = document.getElementById('search-results');





  var results = document.getElementById('search-results');
let alarmClosed = false; // 팝업 닫힘 상태




document.addEventListener("DOMContentLoaded", function() {
	 console.log("DOMContentLoaded fired!");
	  console.log("loginUserId:", window.loginUserId, "userId:", window.userId);

	  // 웹소켓 커넥션 및 알림 구독: 항상 활성화!
	  if (!window.stompClient || !window.stompClient.connected) {
	    console.log("Connecting websocket...");
	    const socket = new SockJS(window.contextPath + '/ws-chat');
	    window.stompClient = Stomp.over(socket);
	    window.stompClient.connect({}, function(frame) {
	      window.isConnected = true;
	      console.log("STOMP connected!", frame);
	      subscribeNotifications();
	    });
	  } else {
	    console.log("Websocket already connected, subscribing notifications...");
	    subscribeNotifications();
	  }
	  
	  
	  //alarmArea = document.getElementById("alarmArea");
	  alarmBell = document.getElementById("alarmBell");
	  const isChatListPage = window.location.pathname.indexOf("/chat/recentRoomList") !== -1;
	  var chatBtn = document.getElementById('chatBtn');
	  loadTopKeywords();

	  if (chatBtn) {
	    chatBtn.addEventListener('click', function(e) {
	      e.preventDefault();
	      // 1. JSON 데이터 받기
	      fetch(contextPath + '/api/chat/recentRoomList', {
	        method: 'GET',
	        headers: { 'Accept': 'application/json' }
	      })
	      .then(response => {
	        if (!response.ok) throw new Error('서버 오류: ' + response.status);
	        return response.json();
	      })
	      .then(data => {
	        // 콘솔에 찍기!
	        console.log('profileImage:', data.profileImage);
	        console.log('chats:', data.chats);
	        // 2. 화면 이동 (JSP 렌더링)
	        window.location.href = contextPath + '/chat/recentRoomList';
	        // 화면 이동 후 JSP에서 기존대로 chatList, profileImage 사용 가능
	      })
	      .catch(err => {
	        console.error('[채팅 fetch] 에러:', err);
	        window.location.href = contextPath + '/chat/recentRoomList';
	      });
	    });
	  }

	  if (isLoggedIn === "true" && isChatListPage) {
	    loadUnreadCounts();
	    connectSocket();
	  }

	  if (isLoggedIn === "true" && userId && !isNaN(userId)) {
	    if (localStorage.getItem('puppitAlarmClosed') === null) {
	      alarmClosed = false;
	      localStorage.setItem('puppitAlarmClosed', 'false');
	    } else {
	      alarmClosed = localStorage.getItem('puppitAlarmClosed') === 'true';
	    }

	    // 기존 if-else 내부에 connectSocket()이 있을 필요 없음!
	    // 무조건 실행!
	    connectSocket();

	    if (!alarmClosed) {
	      alarmArea.style.display = "block";
	      alarmBell.style.display = "none";
	      loadAlarms();
	      setInterval(loadAlarms, 30000);
	      //connectSocket();
	    } else {
	      alarmArea.style.display = "none";
	      alarmArea.innerHTML = "";
	      alarmBell.style.display = "inline-block";
	      //connectSocket(); // 팝업이 닫혀있어도 소켓은 연결!
	    }
	  }

	  if (alarmBell) {
	    alarmBell.addEventListener("click", function() {
	      alarmClosed = false;
	      console.log("alarmBell button clicked");
	      localStorage.setItem('puppitAlarmClosed', 'false');
	      alarmArea.style.display = "block";
	      alarmBell.style.display = "none";
	      loadAlarms();
	      window.alarmInterval = setInterval(loadAlarms, 30000);
	      alarmBell.classList.remove('red');
	    });
	  }

	  const categorySelect = document.getElementById("categorySelect");
	  if (categorySelect) {
	    categorySelect.addEventListener("change", function() {
	      const selected = this.value;
	      if (selected && selected !== "카테고리") {
	        loadCategory(selected);
	      }
	    });
	  }
	}); // <-- 문법 오류 방지: 이벤트 핸들러 끝
	
	function subscribeRoom(currentRoomId) {
		if (currentSubscription) currentSubscription.unsubscribe();
	    currentSubscription = stompClient.subscribe('/topic/chat/' + currentRoomId, function (msg) {
	        const chat = JSON.parse(msg.body);
	       
	        let rawTime = chat.chatCreatedAt || "";
	        console.log("addChatMessageToHistory: rawTime =", rawTime, typeof rawTime);
	       
	         // === 하이라이트 처리 코드 START ===
	        // 메시지 송신자 역할
	        const senderRole = chat.senderRole; // "BUYER" 또는 "SELLER"
	        
	        // 현재 사용자 역할
	        let currentUserRole = (String(userId) === String(chat.chatSender)) ? senderRole : (senderRole === "BUYER" ? "SELLER" : "BUYER");

	        // 구매자/판매자 접속자 기록
	        setUserInRoom(chat.chatRoomId, senderRole);
	        setUserInRoom(chat.chatRoomId, currentUserRole);

	        // === 하이라이트 처리 코드 START ===
	        // 메시지의 수신자가 현재 로그인한 사용자일 때만 하이라이트!
	        // userId(숫자)와 chat.chatReceiver(숫자) 또는
	        // loginUserId(문자열)와 chat.chatReceiverAccountId(문자열) 비교
	        if (
	        		String(chat.chatReceiver) === String(userId) ||
	        	     String(chat.chatReceiverAccountId) === String(loginUserId)
	        	    && String(chat.chatSenderAccountId) !== String(loginUserId) 
	        ) {
	            highlightChatRoom(chat.chatRoomId);
	        } else {
	            removeHighlightChatRoom(chat.chatRoomId);
	        }
	        // === 하이라이트 처리 코드 END ===
	        
	       if (String(currentRoomId) === String(chat.chatRoomId)) {
	            addChatMessageToHistory(chat);
	            centerMessage.style.display = "none";
	             // === 결제버튼 갱신을 위해 상품영역 재렌더링 ===
	            // chatHistory.innerHTML에 메시지 추가 후, product, chatMessages를 다시 계산
	            // window.lastProductInfo, chatHistory에서 메시지 목록 추출
	            if (window.lastProductInfo) {
	                // 채팅 메시지 목록을 chatHistory에서 직접 추출 (이미 렌더링된 메시지들)
	                // 하지만 서버에서 내려온 chatMessages가 최신일 수 있으니, 아래처럼 메시지 배열 관리가 필요
	                // 간단하게: chatHistory에 있는 메시지들을 모을 수도 있지만, 
	                // 최신 메시지(chat)까지 포함하여 productInfoArea 갱신
	                // 기존 채팅방 메시지 배열이 있으면 거기에 push
	                if (!window.currentChatMessages) window.currentChatMessages = [];
	                window.currentChatMessages.push(chat);

	                // productInfoArea 재렌더링
	                renderProductInfo(window.lastProductInfo, window.currentChatMessages);
	            }
	            
	            
	            
	        } else if (!isMine) {
	            // 수신자인 경우에만 알림 표시
	            displayNotification(
	                chat.chatSenderAccountId,
	                chat.chatMessage,
	                chat.senderRole,
	                chat.chatCreatedAt,
	                chat.productName
	            );
	        }
	    });
	}
	
	
	function subscribeNotifications() {
		  console.log('subscribeNotifications 호출됨!');
		  if (window.notificationSubscription) return;
		  window.notificationSubscription = window.stompClient.subscribe('/topic/notification', function(notification) {
		    const data = JSON.parse(notification.body);
		    console.log('알림 메시지 도착:', notification);
		    console.log('알림 데이터 파싱:', data);

		    if (String(data.receiverAccountId) !== String(loginUserId)) return;

		    // 1. /chat/recentRoomList가 아닌 경우 무조건 알림 팝업
		       if (window.location.pathname.indexOf("/chat/recentRoomList") === -1) {
		           displayNotification(data.senderAccountId,
		                   data.chatMessage,
		                   data.senderRole,
		                   data.chatCreatedAt,
		                   data.productName,
		                   data.receiverAccountId);
		           
		       }

		       // 2. /chat/recentRoomList에 없거나 해당 room에 접속 중이 아니면 알림
		       if (
		           window.location.pathname !== "/chat/recentRoomList" ||
		           String(currentRoomId) !== String(data.roomId)
		       ) {
		           displayNotification( data.senderAccountId,
		                   data.chatMessage,
		                   data.senderRole,
		                   data.chatCreatedAt,
		                   data.productName,
		                   data.receiverAccountId);
		       }

		  });
		}
	
	

	function displayNotification(senderAccountId, chatMessage, senderRole, chatCreatedAt, productName, receiverAccountId) {
	  console.log('header - senderAccountId: ', senderAccountId);
	  console.log('header - chatMessage: ', chatMessage);
	  console.log('header - senderRole: ', senderRole);
	  console.log('header - chatCreatedAt: ', chatCreatedAt);
	  console.log('header - productName: ', productName);
	  console.log('header - receiverAccountId: ', receiverAccountId);

	  const notification = document.createElement('div');
	  notification.className = 'notification';

	  notification.innerHTML =
	      '<button class="alarm-close" onclick="closeAlarmPopup()" title="닫기">&times;</button>' +
	      '<ul>' +
	          '<li>' +
	              '<a href="javascript:void(0);" ' +
	              'class="alarm-link" ' +
	              'data-chat-message="' + (chatMessage || '').replace(/"/g, '&quot;') + '">' +
	              '<b>새 메시지:</b> ' + (chatMessage || '') +
	              ' <span style="color:#aaa;">(' + (productName || '') + ')</span>' +
	              ' <span style="color:#888;">' + (chatCreatedAt || '') + '</span>' +
	              '<br><span style="font-size:13px;">From: ' + (senderAccountId || '') + ' | To: ' + (receiverAccountId || '') + '</span>' +
	              '</a>' +
	          '</li>' +
	      '</ul>';

	  document.body.appendChild(notification);

	  setTimeout(() => {
	      notification.style.right = '20px';
	  }, 100);

	  setTimeout(() => {
	      notification.remove();
	  }, 120000);
	}
	
	
	

//1. 웹소켓 연결 및 구독 (알림+채팅 모두)
	function connectSocket() {
	    console.log("connectSocket called");

	    // SockJS + STOMP 연결
	    var socket = new SockJS(contextPath + '/ws-chat');
	    stompClient = Stomp.over(socket);

	    stompClient.connect({}, function(frame) {
	        console.log("STOMP connected:", frame);

	        // =========================
	        // 1️⃣ 알림 메시지 구독
	        // =========================
	        stompClient.subscribe('/topic/notification', function(msg) {
	            console.log('notification msg:', msg);
	            let notification = JSON.parse(msg.body);
	            console.log('notification parsed:', notification);

	            // 수신자가 로그인 사용자와 다르면 무시
	            if (String(notification.receiverAccountId) !== String(loginUserId)) {
	                return;
	            }

	            // 채팅방에 접속 중이 아닐 때만 알림
	            if (String(currentChatRoomId) !== String(notification.roomId)) {
	                console.log('currentChatRoomId:', currentChatRoomId);
	                showAlarmPopup([notification]);

	                const alarmBell = document.getElementById("alarmBell");
	                if (alarmBell) {
	                    alarmBell.classList.add('red');
	                    alarmBell.style.display = "inline-block";
	                }
	            }
	        });

	        // =========================
	        // 2️⃣ 채팅 메시지 구독
	        // =========================
	        stompClient.subscribe('/topic/chat', function(msg) {
	            console.log("chat message received:", msg);
	            let chat = JSON.parse(msg.body);
	            console.log('chat parsed:', chat);

	            // 메시지 수신자가 로그인 사용자일 때만 처리
	            if (String(chat.chatReceiverAccountId) !== String(loginUserId)) {
	                return;
	            }

	            // 채팅방에 접속 중이 아닐 때만 알림
	            if (String(currentChatRoomId) !== String(chat.chatRoomId)) {
	                alarmClosed = false; // 실시간 알림이 오면 false
	                localStorage.setItem('puppitAlarmClosed', 'false');

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

	  //var alarmArea = document.getElementById("alarmArea");
	  console.log('alarmArea: ', alarmArea);

	  if (!Array.isArray(alarms)) {
	    console.log("return: alarms is not array");
	    alarms = [alarms];
	  }
	  if (!alarmArea) {
	    console.warn("return: alarmArea DOM not found!");
	    return;
	  }
	  if (!alarms || alarms.length === 0) {
	    console.warn("return: alarms is empty");
	    return;
	  }

	  alarms.forEach((alarm, idx) => {
	    console.log(`forEach alarm[${idx}]:`, alarm);
	  });
		  
	  alarmArea.style.display = "block"; // 여기 반드시!
	  alarmClosed = false;
	  localStorage.setItem('puppitAlarmClosed', 'false');
	  
	  // 중복 메시지 제거만 수행 (receiver 체크는 이미 filteredAlarm에서 처리)
	  const msgIdSet = new Set();
	  const deduped = alarms.filter((alarm) => {
	    if (!alarm || !alarm.roomId || !alarm.messageId) return false;
	    if (msgIdSet.has(alarm.messageId)) return false;
	    msgIdSet.add(alarm.messageId);
	    return true;
	  });
	  // deduped 결과도 찍기
	  console.log('deduped:', deduped);

	  // === 팝업 UI용 roomId별로 그룹화 및 집계 ===
	  // { roomId: { alarms: [], lastAlarm: {}, count: N } }
 	  const roomGroups = {};
		deduped.forEach(alarm => {
		  const roomId = alarm.roomId;
		  if (!roomGroups[roomId]) {
		    roomGroups[roomId] = { alarms: [], lastAlarm: null };
		  }
		  roomGroups[roomId].alarms.push(alarm);
		});
		console.log('roomGroups:', roomGroups); // 디버깅
			  
	  // 각 roomId별로 마지막 메시지와 미읽음 개수 산출
		Object.keys(roomGroups).forEach(roomId => {
		  const alarms = roomGroups[roomId].alarms;
		  alarms.sort((a, b) => {
		    const tsA = typeof a.chatCreatedAt === "string" ? new Date(a.chatCreatedAt).getTime() : a.chatCreatedAt;
		    const tsB = typeof b.chatCreatedAt === "string" ? new Date(b.chatCreatedAt).getTime() : b.chatCreatedAt;
		    return tsB - tsA;
		  });
		  roomGroups[roomId].lastAlarm = alarms[0];
		  roomGroups[roomId].count = alarms.length;
		});
	  
		
	  
	 
	  // 🚩 여기! 알림이 오면 무조건 팝업을 띄움
	  alarmClosed = false;
	  localStorage.setItem('puppitAlarmClosed', 'false');

	  
	  

	  var html = '<button class="alarm-close" onclick="closeAlarmPopup()" title="닫기">&times;</button><ul>';
	  Object.values(roomGroups).forEach(group => {
	    const alarm = group.lastAlarm;
	    html += '<li>'
	      + '<a href="javascript:void(0);" '
	      + 'class="alarm-link" '
	      + 'data-room-id="' + alarm.roomId + '" '
	      + 'data-message-id="' + (alarm.messageId || '') + '" '
	      + 'data-chat-message="' + (alarm.chatMessage || '').replace(/"/g, '&quot;') + '" '
	      + '>'
	      + '<b>새 메시지:</b> ' + (alarm.chatMessage || '')
	      + ' <span style="color:#aaa;">(' + (alarm.productName || '') + ')</span>'
	      + ' <span style="color:#888;">' + (alarm.messageCreatedAt || '') + '</span>';
	      
	      // 여기서 group.count가 2 이상이면 표시
	      if (group.count && group.count > 1) {
	        html += ' <span style="color:#e74c3c; font-weight:bold;">(안읽은 메시지 ' + group.count + '개)</span>';
	      }
	      html += '<br><span style="font-size:13px;">From: ' + (alarm.senderAccountId || '') + ' | To: ' + (alarm.receiverAccountId || '') + '</span>'
	      + '</a></li>';
	  });
	  html += '</ul>';
	  alarmArea.innerHTML = html;

	  
	  // 🚩 알림 팝업의 알림 메시지 클릭 이벤트 바인딩
	  setTimeout(function() {
		  document.querySelectorAll('#alarmArea .alarm-link').forEach(function(alarmLink, idx) {
		    alarmLink.addEventListener('click', function(e) {
		      var roomId = alarmLink.getAttribute('data-room-id');
		      var chatMessage = alarmLink.getAttribute('data-chat-message');
		      var messageId = alarmLink.getAttribute('data-message-id'); // 메시지의 고유 ID

		      // deduped[idx]가 현재 alarm 객체!
		      var alarm = deduped[idx];

		      // 1. li 제거
		      var liElem = alarmLink.closest('li');
		      if (liElem) liElem.remove();

		      // 2. 현재 클릭한 roomId에 해당하는 group.count 찾기
		      //var groupCount = 1; // 기본값
	    	  var groupCount = roomGroups && roomGroups[roomId] && roomGroups[roomId].count ? roomGroups[roomId].count : 1;


		      // 3. groupCount 값에 따라 분기
		      if (groupCount === 1) {
		        fetch(contextPath + '/api/alarm/read', {
		          method: 'POST',
		          headers: { 'Content-Type': 'application/json' },
		          body: JSON.stringify({ roomId: roomId, userId: userId, messageId: messageId })
		        })
		        .then(res => {
		          if (!res.ok) throw new Error('알림 읽음 처리 실패');
		          return res.json();
		        })
		        .then(data => {
		          console.log('알림 읽음 처리 완료', data);
		        })
		        .catch(err => {
		          console.error('알림 읽음 처리 에러', err);
		        });
		      } else if (groupCount > 1) {
		    	// groupCount 안전하게 가져오기
		    	  fetch(contextPath + '/api/alarm/readAll', {
		    		  method: 'POST',
		    		  headers: { 'Content-Type': 'application/json' },
		    		  body: JSON.stringify({
		    		    roomId: roomId,
		    		    userId: userId,
		    		    count: groupCount // 반드시 숫자! (undefined/null 방지)
		    		  })
		    		})
		    		.then(res => {
		    		  if (!res.ok) throw new Error('채팅방 전체 알림 읽음 처리 실패');
		    		  return res.json();
		    		})
		    		.then(data => {
		    		  console.log('채팅방 전체 알림 읽음 처리 완료', data);
		    		  // UI에서 알림 및 뱃지 제거
		              removeUnreadBadge(roomId); // list.jsp와 동일 함수 (window로 등록 가능)
		              removeAlarmPopupRoom(roomId);
		    		})
		    		.catch(err => {
		    		  console.error('채팅방 전체 알림 읽음 처리 에러', err);
		    		});
		      }

		      // 페이지 이동 처리 등 기존 로직은 그대로
		      var isChatListPage = window.location.pathname.indexOf('/chat/recentRoomList') !== -1;
		      if (typeof window.highlightChatRoom === 'function' && isChatListPage) {
		        window.highlightChatRoom(roomId);
		        window.updateChatListLastMessage(roomId, chatMessage);
		        closeAlarmPopup();
		      } else {
		        var url = contextPath + '/chat/recentRoomList'
		          + '?highlightRoomId=' + encodeURIComponent(roomId)
		          + '&highlightMessage=' + encodeURIComponent(chatMessage);
		        window.location.href = url;
		      }
		    });
		  });
		}, 30);
	  
	}

	  function closeAlarmPopup() {
		    //var alarmArea = document.getElementById("alarmArea");
		    alarmArea.style.display = "none";
		    alarmArea.innerHTML = "";
		    var alarmBell = document.getElementById("alarmBell");
		    if (alarmBell) alarmBell.style.display = "inline-block";
		    if(window.alarmInterval) clearInterval(window.alarmInterval);
		    alarmClosed = true;
		    localStorage.setItem('puppitAlarmClosed', 'true');
		  }

	  function loadAlarms() {
		    //var alarmArea = document.getElementById("alarmArea");  
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
		    	// === 로그인한 사용자가 receiver로 받은 알림만 보여주기 ===
			   //const filtered = Array.isArray(data)
				//  ? data.filter(alarm => String(alarm.userId) === String(loginUserId))
				//  : [];
			  if (data.length === 0) {
				  alarmArea.innerHTML = `
				    <button class="alarm-close" onclick="closeAlarmPopup()" title="닫기" style="position:absolute;top:10px;right:14px;background:transparent;border:none;font-size:18px;color:#c8a700;cursor:pointer;z-index:10;padding:0;line-height:1;">&times;</button>
				    <div class="empty" style="padding-top:18px;">알림이 없습니다.</div>
				  `;
				  alarmArea.style.display = "block";
				  var alarmBell = document.getElementById("alarmBell");
				  if (alarmBell) alarmBell.style.display = "none";
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

  
	  function loadUnreadCounts() {
		  fetch(contextPath + '/api/chat/unreadCount?userId=' + userId)
		    .then(res => res.json())
		    .then(unreadCounts => {
		      updateUnreadBadges(unreadCounts);
		    });
		}
		function updateUnreadBadges(unreadCounts) {
		  document.querySelectorAll('.chat-room-item').forEach(function(roomElem) {
		    var roomId = roomElem.getAttribute('data-room-id');
		    var count = unreadCounts[roomId] || 0;
		    let badge = roomElem.querySelector('.unread-badge');
		    if (!badge) {
		      badge = document.createElement('span');
		      badge.className = 'unread-badge';
		      roomElem.appendChild(badge);
		    }
		    if (count > 0) {
		      badge.textContent = count;
		      badge.style.display = 'inline-block';
		    } else {
		      badge.style.display = 'none';
		    }
		  });
		}	

		// 미읽음 뱃지 제거 함수 (list.jsp와 동일)
		function removeUnreadBadge(roomId) {
		  document.querySelectorAll('.chatList[data-room-id="' + roomId + '"] .unread-badge').forEach(badge => {
		    badge.style.display = 'none';
		    badge.textContent = '';
		  });
		}
		// 알림 팝업에서 해당 roomId의 알림 메시지 삭제
		function removeAlarmPopupRoom(roomId) {
		  //const alarmArea = document.getElementById('alarmArea');
		  if (alarmArea) {
		    const alarmLinks = alarmArea.querySelectorAll('.alarm-link[data-room-id="' + roomId + '"]');
		    alarmLinks.forEach(link => {
		      const liElem = link.closest('li');
		      if (liElem) liElem.remove();
		    });
		    // 알림 모두 없어지면 팝업 닫기
		    const remainLinks = alarmArea.querySelectorAll('.alarm-link');
		    if (remainLinks.length === 0) {
		      closeAlarmPopup();
		    }
		  }
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

  // ===================== 자동완성 =====================
  function formatPrice(v) {
    if (v === null || v === undefined) return '';
    try { return new Intl.NumberFormat('ko-KR').format(v) + '원'; }
    catch (e) { return v + '원'; }
  }

  function render(list, keyword) {
	  
	  console.log('list: ', list);
	  
	  if (!Array.isArray(list)) list = [];
	  if (!list.length) {
	    results.innerHTML =
	      '<div class="result-head"><b>"' + keyword + '"</b> 검색 결과 0건</div>' +
	      '<div class="empty">조건에 맞는 상품이 없습니다.</div>';
	    return;
	  }

	  var head = '<div class="result-head"><b>"' + keyword + '"</b> 검색 결과 ' + list.length + '건</div>';
	  
	  var cards = list.map(function (p) {
		  
	    console.log('카테고리 검색 p: ', p);	
	    
	    var id = p.productId;
	    var name = p.productName || '';
	    var price = formatPrice(p.productPrice);

	    // 이미지 처리
	    var img = p.productImage || "";
	    //var imgSrc = "";
	    if (img) {
	      if (img.startsWith("http")) {
	        // S3 같은 절대경로
	        //imgSrc = img;
	        console.log('s3 imgSrc: ', img);
	      } else if (img.startsWith("/uploads/")) {
	        // 이미 /uploads/가 포함된 상대경로
	       // imgSrc = contextPath + img;
	        console.log('이미 /uploads/가 포함된 상대경로 imgSrc: ', img);
	      } else {
	        // 단순 파일명만 있는 경우
	        imgSrc = contextPath + "/uploads/" + img;
	        console.log('단순 파일명만 있는 경우 imgSrc: ', img);
	      }
	    } else {
	      // 이미지가 아예 없을 때 기본 이미지 지정
	      img = contextPath + "/resources/image/no-image.png";
	    }
	    
	    const resultCard = '<div class="card">'
		    + '  <a href="' + contextPath + '/product/detail/' + id + '">'
		    + '    <img src="' + img + '" alt="' + name + '"/>'   // 🚩 여기 반드시 imgSrc 사용
		    + '    <div class="name">' + name + '</div>'
		    + '    <div class="price">' + price + '</div>'
		    + '  </a>'
		    + '</div>'; 
		 return resultCard;

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
	  console.log('엔터이벤트');
    const keyword = input.value.trim();
    console.log('keyword: ', keyword);
    if (keyword.length === 0) {
      autoList.style.display = "none";
      return;
    }
    try {
      const res = await fetch(contextPath + "/product/autocomplete?keyword=" + encodeURIComponent(keyword));
      const data = await res.json();
	  console.log('data: ', data);
      autoList.innerHTML = "";
      if (data.length > 0) {
        data.forEach(item => {
          const li = document.createElement("li");
          console.log('item: ', item);
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
  window.showAlarmPopup = showAlarmPopup;
  window.removeUnreadBadge = removeUnreadBadge;
  window.removeAlarmPopupRoom = removeAlarmPopupRoom;
  window.closeAlarmPopup = closeAlarmPopup;
</script>