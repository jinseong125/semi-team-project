<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
Map<String, Object> sessionMap = (Map<String, Object>) session.getAttribute("sessionMap");
String accountId = "";
Integer userId = 0;
if (sessionMap != null) {
    Object accountIdObj = sessionMap.get("accountId");
    if (accountIdObj != null) {
        accountId = accountIdObj.toString();
    }
    Object userIdObj = sessionMap.get("userId");
    if (userIdObj != null) {
        userId = Integer.parseInt(userIdObj.toString());
    }
}
%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="loginUserId" value="<%= accountId %>" />
<c:set var="userId" value="<%=userId %>"/>
<c:set var="highlightRoomIdStr" value="${highlightRoomIdStr}"/>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>채팅방 목록</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; background: #fff; margin: 0; padding: 0; }
        .container-header { text-align: center; margin-top: 40px; margin-bottom: 24px; }
        .container-header h1 { font-size: 24px; font-weight: bold; letter-spacing: -1px; color: #222; }
        .container { width: 1000px; min-height: 700px; display: flex; flex-direction: row; gap: 20px; justify-content: center; align-items: flex-start; margin: 0 auto; background: #fff; }
        .chatlist-container { width: 400px; height: 600px; border: none; padding: 0; margin: 0; overflow-y: auto; }
        .chat-list { display: flex; flex-direction: column; gap: 20px; }
        .chatList { display: flex; flex-direction: row; align-items: center; padding: 0 10px; gap: 16px; cursor: pointer; background: #fff; border-radius: 18px; min-height: 80px; transition: background 0.15s; box-shadow: none; border: none; }
        .chatList:hover { background: #f5f5f5; }
        .chat-profile-img { width: 56px; height: 56px; border-radius: 50%; object-fit: cover; margin-right: 10px; border: 1.5px solid #eee; background: #fafafa; display: flex; justify-content: center; align-items: center; font-size: 28px; color: #bbb; }
        .chat-info-area { flex: 1 1 0; display: flex; flex-direction: column; gap: 2px; min-width: 0; }
        .chat-nickname { font-size: 18px; font-weight: 700; color: #222; margin-bottom: 2px; letter-spacing: -0.5px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .chat-message { font-size: 15px; color: #444; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 220px; }
        .chat-meta { display: flex; flex-direction: column; align-items: flex-end; min-width: 90px; gap: 8px; }
        .chat-time { font-size: 14px; color: #757575; font-weight: 400; }
        .chat-unread-badge { display: inline-block; width: 22px; height: 22px; line-height: 20px; font-size: 15px; background: #fff; color: #e74c3c; border: 2px solid #e74c3c; border-radius: 50%; text-align: center; font-weight: 700; margin-top: 2px; margin-right: 5px; }
        .chat-container { width: 400px; height: 600px; display: flex; flex-direction: column; justify-content: flex-end; padding: 20px; box-sizing: border-box; background: #fafafa; }
        .chat-input-group { display: flex; flex-direction: row; gap: 8px; width: 100%; }
        .chat-container input { min-width: 0; padding: 0 10px; font-size: 16px; height: 38px; border: 1px solid #ccc; border-radius: 8px; background: #fff; box-sizing: border-box; }
        .chat-container button { height: 38px; padding: 0 24px; font-size: 16px; border: none; border-radius: 8px; background: #888; color: #fff; cursor: pointer; box-sizing: border-box; margin-top: 10px; }
        .chat-history { display: flex; flex-direction: column; align-items: flex-start; width: 100%; gap: 12px; margin-bottom: 16px; overflow-y: auto; flex: 1; scrollbar-width: none; -ms-overflow-style: none; }
        .chat-history::-webkit-scrollbar { display: none; }
        .chat-history .chat-message { max-width: 60%; min-width: 80px; padding: 10px 16px; border-radius: 12px; margin-bottom: 4px; display: flex; flex-direction: column; background: #eee; box-sizing: border-box; word-break: break-word; height: auto; overflow: visible; }
        .chat-history .chat-message.right { align-self: flex-end !important; background: #e9f7fe; text-align: right; }
        .chat-history .chat-message.left { align-self: flex-start !important; background: #eee; text-align: left; }
        .chat-history .chat-message .chat-userid { font-size: 13px; color: #888; margin-bottom: 2px; }
        .chat-history .chat-message .chat-text { font-size: 15px; margin-bottom: 2px; white-space: pre-wrap; overflow-wrap: break-word; word-break: break-word; }
        .chat-history .chat-message .chat-time { font-size: 12px; color: #aaa; margin-top: 2px; align-self: flex-end; }
        .chatList.highlight { background: #fff8e1; border: 2px solid #ffb300; }	
        .center-message { text-align:center; margin:20px 0; color:#888; }
        .notification {
            position: fixed;
            right: -100px;
            top: 20px;
            width: 200px;
            background-color: #f9f9f9;
            border: 1px solid #ccc;
            padding: 10px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            transition: right 1s;
        }
        .chat-input-group textarea {
		    flex: 1; /* 입력창이 버튼보다 넓게 설정 */
		    height: 180px; /* 20줄을 입력할 수 있는 높이 */
		    padding: 10px; /* 입력창 내부 여백 */
		    font-size: 16px; /* 읽기 좋은 텍스트 크기 */
		    border: 1px solid #ccc; /* 입력창 테두리 */
		    border-radius: 10px; /* 둥근 테두리 */
		    background-color: #f9f9f9; /* 부드러운 배경색 */
		    box-sizing: border-box; /* 전체 크기 포함 */
		    resize: none; /* 크기 조정 비활성화 */
		    overflow-y: auto; /* 스크롤 활성화 */
		    font-family: 'Noto Sans KR', sans-serif; /* 한국어 폰트 */
		}
        
        
    </style>
</head>
<body>
<div class="container-header">
    <h1>채팅방 목록</h1>
</div>
<div class="container">
    <div class="chatlist-container" id="chatlist-container">
        <div id="chatListRenderArea">
            <c:forEach items="${chatList}" var="chat">
                <div class="chatList" data-room-id="${chat.roomId}">
                    <span class="chat-profile-img chat-profile-icon">
                        <i class="fa-solid fa-user"></i>
                    </span>
                    <div class="chat-info-area" style="cursor:pointer;">
                        <div class="chat-nickname">
                             <c:choose>
                                <c:when test="${not empty chat.productName}">
                                    <c:out value="${chat.productName}" />  (<c:out value="${chat.sellerAccountId}" />)
                                </c:when>
                                <c:otherwise>
                                    상품판매자와 채팅을 시작해보세요
                                </c:otherwise>
                            </c:choose>
                        </div>
                         
                        <div class="chat-message">
                            <c:choose>
                                <c:when test="${not empty chat.lastMessage}">
                                    <c:out value="${chat.lastMessage}" />
                                </c:when>
                                <c:otherwise>
                                    상품판매자와 채팅을 시작해보세요
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
    <div class="chat-container">
	   <!--   <div class="chat-header" id="chat-header" style="padding: 10px; font-size: 16px; font-weight: bold; background: #f5f5f5; border-bottom: 1px solid #ddd;">
	        
	    </div>  -->
        <div class="product-info-area" id="product-info-area"></div>
        <div class="center-message" id="center-message">상품 판매자와 채팅을 시작해보세요</div>
        <div class="chat-history" id="chat-history"></div>
        <div class="chat-input-group">
            <textarea placeholder="채팅메시지를 입력하세요"></textarea>
            <button type="submit">전송</button>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1.6.1/dist/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.2/stomp.min.js"></script>
<script>
const contextPath = "${contextPath}";
const loginUserId = '<c:out value="${loginUserId}" />'; // 작은따옴표로 감싸 JS 문자열로 안전하게
const userId = <c:out value="${userId}" />;             // 숫자는 그대로

const centerMessage = document.getElementById('center-message');
const chatHistory = document.getElementById('chat-history');
const productInfoArea = document.getElementById('product-info-area');

//렌더링된 메시지를 추적하기 위한 Set
const renderedMessageIds = new Set();

let stompClient = null;
let currentRoomId = null;
let currentSubscription = null;
let isConnected = false;
let productId = null;
let buyerId = null;

document.addEventListener('DOMContentLoaded', function() {
    const chatlist = document.getElementById('chatlist-container');
    chatlist.addEventListener('click', function(e) {
        const chatDiv = e.target.closest('.chatList');
        if (chatDiv) {
            const roomId = chatDiv.dataset.roomId;
            currentRoomId = roomId;
            if (roomId) {
                loadChatHistory(roomId).then(() => {
                    connectAndSubscribe(roomId);
                });
            }
        }
    });

    const sendBtn = document.querySelector('button[type="submit"]');
    if (sendBtn) {
        sendBtn.addEventListener('click', function(e){
            e.preventDefault();
            sendMessage(currentRoomId);
        });
    }
    enableChatInput(false);
    
    // websocket 연결 시작
    connectAndSubscribe();
});

function loadChatHeader(product, buyerId, sellerId, sellerAccountId, buyerAccountId) {
    const chatHeader = document.getElementById('chat-header');
    console.log('loadChatHeader 호출됨');
    console.log('chatHeader:', chatHeader);
    console.log('buyerId:', buyerId, 'sellerId:', sellerId, 'sellerAccountId:', sellerAccountId, 'buyerAccountId:', buyerAccountId);

    // sellerAccountId와 buyerAccountId를 안전하게 처리
    const sellerText = typeof sellerAccountId === 'string' && sellerAccountId.trim() !== '' ? sellerAccountId : "정보 없음";
    const buyerText = typeof buyerAccountId === 'string' && buyerAccountId.trim() !== '' ? buyerAccountId : "구매자 계정 정보 없음";

    if (String(userId) === String(buyerId)) {
        // 현재 사용자가 구매자인 경우
        chatHeader.innerHTML = `<strong>상품 판매자:</strong> ${sellerText}`;
    } else if (String(userId) === String(sellerId)) {
        // 현재 사용자가 판매자인 경우
        chatHeader.innerHTML = `<strong>구매자:</strong> ${buyerText}`;
    } else {
        // 알 수 없는 역할일 경우 기본 메시지 표시
        chatHeader.innerHTML = `<strong>채팅 상대 정보를 불러올 수 없습니다.</strong>`;
    }
}

function loadChatHistory(roomId) {
	renderedMessageIds.clear(); // 올바른 변수명 방 진입시 이전 메시지 ID 초기화
    return fetch(contextPath + '/chat/message?roomId=' + roomId)
        .then(response => response.json())
        .then(data => {
            console.log('Server Response:', data); // 서버 응답 로그 출력

            let buyerId = null; // 구매자 ID 초기화
            const sellerId = data.product.sellerId || null; // 판매자 ID
            const sellerAccountId = data.product.chatSellerAccountId || ""; // 판매자의 accountId
            let buyerAccountId = ""; // 구매자의 accountId 초기화

            // 🔥 buyerId와 buyerAccountId 추출
            if (data.chatMessages && data.chatMessages.length > 0) {
                const buyerMessage = data.chatMessages.find(msg => msg.senderRole === "BUYER");
                if (buyerMessage) {
                    buyerId = buyerMessage.buyerId || null;
                    buyerAccountId = buyerMessage.chatSenderAccountId || ""; // 구매자의 accountId 추출
                }
            }

            console.log("buyerId: ", buyerId, " sellerId: ", sellerId, " sellerAccountId: ", sellerAccountId, " buyerAccountId: ", buyerAccountId);

            //loadChatHeader(data.product, buyerId, sellerId, sellerAccountId, buyerAccountId);
            renderProductInfo(data.product, data.chatMessages || []);

            chatHistory.innerHTML = "";
            const messages = Array.isArray(data.chatMessages) ? data.chatMessages : [];
            messages.forEach(chat => {
            	addChatMessageToHistory(chat);
            	renderedMessageIds.add(chat.messageId);
            	
            });

            // 🔥 메시지가 있으면 안내 문구 숨기기
            if (messages.length > 0) {
                centerMessage.style.display = "none";
            } else {
                centerMessage.style.display = "block";
            }
        });
}
function renderProductInfo(product, chatMessages) {
	  console.log('Rendering Product Info:', product); // 서버에서 전달된 product 확인
    const price = Number(product.productPrice);
    let html =
        '<div style="margin-bottom:10px; border-bottom:1px solid #eee; padding-bottom:12px;">'
        + '<strong>상품명:</strong> ' + product.productName + '<br>'
        + '<strong>가격:</strong> ' + (isNaN(price) ? product.productPrice : price.toLocaleString()) + '원 <br>';

    // 🔥 로그인된 사용자와 판매자가 다른 경우 결제 버튼 추가
    if (String(userId) !== String(product.sellerId)) {
        html += `<button
            id="pay-btn"
            	    data-buyer-id="\${userId}" // 로그인된 사용자를 buyerId로 설정
                    data-seller-id="\${product.sellerId}"
                    data-seller-account-id="\${product.chatSellerAccountId}" // Fix: Bind chatSellerAccountId directly from product object
                    data-product-name="\${product.productName}"
                    data-product-id="\${product.productId}"
        >결제하기</button>`;
    }

    html += '</div>';
    productInfoArea.innerHTML = html;

    const payBtn = document.getElementById('pay-btn');
    if (payBtn) {
        payBtn.onclick = function(e) {
            const btn = e.currentTarget;
            console.log("btn.dataset: ", btn.dataset); // 버튼 데이터 확인
            const buyerId = btn.dataset.buyerId; // buyerId 가져오기

            // 반드시 data-seller-account-id를 읽어서 콘솔에 찍음!
            const chatSellerAccountId = btn.dataset.sellerAccountId; // Fix: Access chatSellerAccountId from dataset
            console.log('결제버튼 클릭 - chatSellerAccountId:', chatSellerAccountId);
            const quantity = 1;
            const productId = product.productId;
            const payUrl = contextPath + '/order/pay'
            	+ '?buyerId=' + encodeURIComponent(buyerId)
                + '&sellerId=' + encodeURIComponent(product.sellerId)
                + '&chatSellerAccountId=' + encodeURIComponent(chatSellerAccountId)
                + '&productName=' + encodeURIComponent(product.productName)
                + '&productId=' + encodeURIComponent(product.productId)
                + '&quantity=' + encodeURIComponent(quantity);
            window.location.href = payUrl;
        };
    }
}

//채팅 메시지 화면에 추가
function addChatMessageToHistory(chat) {
    console.log('Rendering message:', chat);

    // chatHistory 요소 확인
    if (!chatHistory) {
        console.error('Chat history element not found.');
        return;
    }

    // 발신자와 수신자에 따라 메시지 정렬
    const alignClass = (String(chat.chatSenderAccountId) === String(loginUserId)) ? "right" : "left";
    const msg = chat.chatMessage || ""; // 메시지 내용
    const senderName = chat.chatSenderUserName || "알 수 없음"; // 발신자 이름
    const formattedTime = formatChatTime(chat.chatCreatedAt || "");

    const html =
        '<div class="chat-message ' + alignClass + '">' +
        '<div class="chat-userid">' + (chat.chatSenderAccountId || "") + '</div>' +
        '<div class="chat-text">' + msg + '</div>' +
        '<div class="chat-time">' + formattedTime + '</div>' +
        '</div>';
    chatHistory.innerHTML += html;

    // 최신 메시지로 스크롤 이동
    chatHistory.scrollTop = chatHistory.scrollHeight;

    // 마지막 렌더링된 메시지 시간 저장
    chatHistory.lastRenderedMessageTime = chat.chatCreatedAt;
}


//시간 형식 변환 함수 추가
function formatChatTime(timeString) {
    const timestamp = Number(timeString);
    if (isNaN(timestamp)) {
        return "시간 정보 없음";
    }
    const date = new Date(Number(timeString));
    const options = {
        year: "numeric",
        month: "2-digit",
        day: "2-digit",
        hour: "2-digit",
        minute: "2-digit",
        second: "2-digit",
        hour12: true,
    };
    return new Intl.DateTimeFormat("ko-KR", options).format(date);
}

//WebSocket 연결 및 구독
function connectAndSubscribe(currentRoomId) {
    if (!stompClient) {
        const socket = new SockJS(contextPath + '/ws-chat'); // 서버의 WebSocket 엔드포인트
        stompClient = Stomp.over(socket);
        
        console.log("Attempting WebSocket connection..."); // 연결 시도 로그
        stompClient.connect({}, function() {
            isConnected = true;
            console.log("WebSocket connected!"); // WebSocket 연결 성공
            
            // 알림 구독 호출
            subscribeNotifications();
            
            // 채팅방에 연결된 경우 구독
            if (currentRoomId) {
            	subscribeRoom(currentRoomId); // 현재 채팅방에 구독	
            }
            
            enableChatInput(true); // 채팅 입력 활성화
        }, function() {
            console.error('WebSocket connection error. Retrying...');
            setTimeout(() => connectAndSubscribe(currentRoomId), 5000); // 5초 후 재시도
        });
    } else {

    	 console.log("Reusing existing WebSocket connection.");
         // 알림 구독 호출
         subscribeNotifications();
         if (currentRoomId) {
             subscribeRoom(currentRoomId);
         }
         enableChatInput(isConnected);
    }
}
function subscribeRoom(currentRoomId) {
    if (currentSubscription) {
        currentSubscription.unsubscribe(); // 기존 구독 해제
    }


    console.log(`Subscribing to room: /topic/chat/${currentRoomId}`); // 구독 로그
    currentSubscription = stompClient.subscribe('/topic/chat/' + currentRoomId, function (msg) {
        const chat = JSON.parse(msg.body);
        console.log('Received message:', chat);

        // 중복 렌더링 방지: 이미 렌더링된 messageId인지 확인

        //if (renderedMessageIds.has(chat.messageId)) {
        //    console.log('Duplicate message detected, skipping rendering.');
        //    return;
        //}

        // 메시지 데이터 유효성 검증
        if (!chat || !chat.chatRoomId || !chat.chatMessage) {
            console.error('Invalid message data received:', chat);
            return;
        }

        // 현재 채팅방인지 확인
        if (String(chat.chatRoomId) !== String(currentRoomId)) {
            console.log('Message does not belong to this room. Ignoring...');
            return;
        }
        
        

        if (renderedMessageIds.has(chat.messageId)) {
            console.log('Duplicate message detected, skipping rendering.');
            return;
        }


        // 메시지를 화면에 추가
        addChatMessageToHistory(chat);

        // 렌더링된 messageId를 저장
        renderedMessageIds.add(chat.messageId);

        // 마지막 렌더링된 메시지 시간 저장
        //chatHistory.lastRenderedMessageTime = chat.chatCreatedAt;


        // 안내 문구 숨기기
        centerMessage.style.display = "none";
    });
}

function subscribeNotifications() {
    stompClient.subscribe('/topic/notification', function(notification) {
        const data = JSON.parse(notification.body);
        console.log('Notification received:', data);

        // 알림 처리: 메시지의 전송자에게 알림 표시

        if (data.receiverAccountId === loginUserId) {
        	 console.log("Displaying notification for receiver:", loginUserId);

            displayNotification(
                data.senderAccountId,
                data.chatMessage,
                data.senderRole,
                data.chatCreatedAt,
                data.productName
            );

        } else {
            console.log("Notification ignored. Receiver:", data.receiverAccountId, "Current user:", loginUserId);

        }
    });
}
function displayNotification(senderAccountId, chatMessage, senderRole, chatCreatedAt, productName) {

   console.log('Displaying notification:', {
        senderAccountId, chatMessage, senderRole, chatCreatedAt, productName
    });

    

    // chatCreatedAt을 밀리초 기반 타임스탬프로 처리하고 형식 변환
    let formattedTime = "시간 정보 없음";
    if (!isNaN(Number(chatCreatedAt))) {
        const date = new Date(Number(chatCreatedAt));
        const options = {
            year: "numeric",
            month: "2-digit",
            day: "2-digit",
            hour: "2-digit",
            minute: "2-digit",
            second: "2-digit",
            hour12: true // 오전/오후 표시
        };
        formattedTime = new Intl.DateTimeFormat("ko-KR", options).format(date);
    }

    const notification = document.createElement('div');
    notification.className = 'notification';

    // 문자열 방식으로 데이터 바인딩
    let notificationHTML = "<strong>" + senderRole + ":</strong> " + chatMessage + "<br>";
    notificationHTML += "<small>" + formattedTime + " - " + productName + "</small>";
    notification.innerHTML = notificationHTML;
    document.body.appendChild(notification);

    setTimeout(() => {
        notification.style.right = '20px';
    }, 100);

    setTimeout(() => {
        notification.remove();
    }, 120000);
}

function enableChatInput(enable) {
    const input = document.querySelector('input[placeholder="채팅메시지를 입력하세요"]');
    const button = document.querySelector('button[type="submit"]');
    if (input && button) {
        input.disabled = !enable;
        button.disabled = !enable;
    }
}

//메시지 전송
function sendMessage(currentRoomId) {
    if (!stompClient || !isConnected) return;

    const input = document.querySelector('textarea[placeholder="채팅메시지를 입력하세요"]');
    const message = input.value.trim();
    if (!message || !currentRoomId) return;

    const productId = document.querySelector('#pay-btn')?.dataset.productId;
    const buyerId = userId;

    const productSellerId = document.querySelector('#pay-btn')?.dataset.sellerId;
    const senderRole = (String(userId) === String(productSellerId)) ? "SELLER" : "BUYER";

    const chatMessage = {
        chatRoomId: currentRoomId,
        chatMessage: message,
        chatSenderAccountId: loginUserId,
        productId: productId,
        buyerId: buyerId,
        senderRole: senderRole,
        chatCreatedAt: Date.now().toString(),
        messageId: Date.now().toString() + "-" + loginUserId // 고유 messageId 생성
    };

    
    // WebSocket을 통해 메시지 전송
    stompClient.send("/app/chat.send", {}, JSON.stringify(chatMessage));


    // 입력창 초기화
    input.value = "";
}


</script>
</body>
</html>