<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>채팅방 목록</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
body {
    font-family: 'Noto Sans KR', sans-serif;
    background: #fff;
    margin: 0;
    padding: 0;
}

.container-header {
    text-align: center;
    margin-top: 40px;
    margin-bottom: 24px;
}
.container-header h1 {
    font-size: 24px;
    font-weight: bold;
    letter-spacing: -1px;
    color: #222;
    /* display: flex; align-items: center; gap: 6px; 삭제 */
}

.container {
    width: 1000px;
    min-height: 700px;
    display: flex;
    flex-direction: row;
    gap: 20px;
    justify-content: center;
    align-items: flex-start;
    margin: 0 auto;
    background: #fff;
}

/* 왼쪽 채팅방 목록 */
.chatlist-container {
    width: 400px;
    height: 600px;
    border: none;
    padding: 0;
    margin: 0;
}
.chat-list {
    display: flex;
    flex-direction: column;
    gap: 20px;
}
.chatListD {
    display: flex;
    flex-direction: row;
    align-items: center;
    padding: 0 10px;
    gap: 16px;
    cursor: pointer;
    background: #fff;
    border-radius: 18px;
    min-height: 80px;
    transition: background 0.15s;
    box-shadow: none;
    border: none;
}
.chatListD:hover {
    background: #f5f5f5;
}
.chat-profile-img {
    width: 56px;
    height: 56px;
    border-radius: 50%;
    object-fit: cover;
    margin-right: 10px;
    border: 1.5px solid #eee;
    background: #fafafa;
}
.chat-info-area {
    flex: 1 1 0;
    display: flex;
    flex-direction: column;
    gap: 2px;
    min-width: 0;
}
.chat-nickname {
    font-size: 18px;
    font-weight: 700;
    color: #222;
    margin-bottom: 2px;
    letter-spacing: -0.5px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
.chat-message {
    font-size: 15px;
    color: #444;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    max-width: 220px;
}
.chat-meta {
    display: flex;
    flex-direction: column;
    align-items: flex-end;
    min-width: 90px;
    gap: 8px;
}
.chat-time {
    font-size: 14px;
    color: #757575;
    font-weight: 400;
}
.chat-unread-badge {
    display: inline-block;
    width: 22px;
    height: 22px;
    line-height: 20px;
    font-size: 15px;
    background: #fff;
    color: #e74c3c;
    border: 2px solid #e74c3c;
    border-radius: 50%;
    text-align: center;
    font-weight: 700;
    margin-top: 2px;
    margin-right: 5px;
}

/* 오른쪽 채팅창 */
.chat-container {
    width: 400px;
    height: 600px;
    display: flex;
    flex-direction: column;
    justify-content: flex-end; /* 입력창을 바닥에 붙임 */
    padding: 20px;
    box-sizing: border-box;
    background: #fafafa;
}

.chat-input-group {
    display: flex;
    flex-direction: row;
    gap: 8px;
    width: 100%;
   
}

.chat-container input {
   
    min-width: 0;
    padding: 0 10px;
    font-size: 16px;
    height: 38px;
    border: 1px solid #ccc;
    border-radius: 8px;
    background: #fff;
    box-sizing: border-box;
}

.chat-container button {
    height: 38px;
    padding: 0 24px;
    font-size: 16px;
    border: none;
    border-radius: 8px;
    background: #888;
    color: #fff;
    cursor: pointer;
    box-sizing: border-box;
    margin-top: 10px;
}

.chat-profile-img {
    width: 56px;
    height: 56px;
    border-radius: 50%;
    object-fit: cover;
    margin-right: 10px;
    border: 1.5px solid #eee;
    background: #fafafa;
    display: flex;                /* 추가 */
    justify-content: center;      /* 추가 */
    align-items: center;          /* 추가 */
    font-size: 28px;              /* 아이콘 크기 */
    color: #bbb;                  /* 아이콘 컬러 */
}



  </style>
</head>
<body>

<div class="container-header">
	<h1>채팅방 목록</h1>
</div>

<div class="container">
	<div class="chatlist-container">
		<c:forEach items="${chatList}" var="chat">
		    <div class="chatListD">
		       <!-- <div>senderAccountID: ${chat.senderAccountId}</div> --> 
		        <!--  <img class="chat-profile-img" src="${chat.profileImage}" alt="profile"/> -->
		        <c:choose>
				    <c:when test="${empty chat.profileImage}">
				        <span class="chat-profile-img chat-profile-icon">
				            <i class="fa-solid fa-user"></i>
				        </span>
				    </c:when>
				    <c:otherwise>
				        <img class="chat-profile-img" src="${chat.profileImage}" alt="profile"/>
				    </c:otherwise>
				</c:choose>
		        <div class="chat-info-area">
                    <div class="chat-nickname">${chat.receiverAccountId}</div>
                    <div class="chat-message">${chat.chatMessage}</div>
                </div>
		        <div class="chat-meta">
                    <span class="chat-time">
                        <fmt:formatDate value="${chat.chatSentAt}" pattern="a h시 mm분"/>
                    </span>
                </div>
		    </div>
		</c:forEach>
	
	</div>
	<div class="chat-container">
		<input placeholder="채팅메시지를 입력하세요"/>
		<button type="submit">전송</button>
	</div>


</div>

<<<<<<< HEAD
=======
let stompClient = null;
let currentRoomId = null;
let currentSubscription = null;
let isConnected = false;
let productId = null;
let buyerId = null;


// DOMContentLoaded에서 요소가 있는지 체크!
document.addEventListener('DOMContentLoaded', function() {
    const chatlist = document.querySelector('.chatlist-container');
    if (chatlist) {
        chatlist.addEventListener('click', function(e) {
            const chatDiv = e.target.closest('.chatList');
            if (chatDiv) {
               const  roomId = chatDiv.dataset.roomId;
				currentRoomId = roomId;                 
                if (roomId) {
                    loadChatHistory(roomId).then(() => {
                        connectAndSubscribe(roomId);
                    });
                }
            }
        });
    }

    const sendBtn = document.querySelector('button[type="submit"]');
    if (sendBtn) {
        sendBtn.addEventListener('click', function(e){
            e.preventDefault();
            sendMessage(currentRoomId);
        });
    }

    enableChatInput(false);
});

function loadChatHistory(roomId) {
    return fetch(contextPath + '/chat/message?roomId=' + roomId)
        .then(response => {
            if (!response.ok) throw new Error('채팅 내역 응답 오류');
            return response.json();
        })
        .then(data => {
            console.log('data: ', data);
            if (data.product) {
                renderProductInfo(data.product, data.chatMessages);
            } else {
                document.getElementById('product-info-area').innerHTML = '';
            }
            const chatHistoryElem = document.getElementById('chat-history');
            chatHistoryElem.innerHTML = "";
            if (Array.isArray(data.chatMessages)) {
                data.chatMessages.forEach(chat => addChatMessageToHistory(chat));
            }
        })
        .catch(err => {
            console.error("채팅 내역 불러오기 실패:", err);
        });
}

// 상품 정보 표시 함수 (최종 예시)
function renderProductInfo(product, chatMessages) {
    const area = document.getElementById('product-info-area');
    if (!area || !product) return;
    const price = Number(product.productPrice);

    // 함수 호출 확인 로그
    console.log('[renderProductInfo] called', product, chatMessages);

    // chatMessages에서 buyerId 추출
    let buyerId = null;
    if (Array.isArray(chatMessages) && chatMessages.length > 0) {
        buyerId = chatMessages[0].buyerId || null;
        if (!buyerId) {
            const validMsg = chatMessages.find(msg => msg.buyerId != null && msg.buyerId !== "");
            if (validMsg) buyerId = validMsg.buyerId;
        }
    }

    // 디버깅
    console.log('userId:', userId, 'buyerId:', buyerId, 'product:', product);

    let html =
        '<div style="margin-bottom:10px; border-bottom:1px solid #eee; padding-bottom:12px;">'
        + '<strong>상품명:</strong> ' + product.productName + '<br>'
        + '<strong>가격:</strong> ' + (isNaN(price) ? product.productPrice : price.toLocaleString()) + '원 <br>';

    // userId와 buyerId가 일치하면 결제 버튼 추가
    if (userId == buyerId) {
        console.log('[버튼 data-속성]', product.sellerId, product.productName, product.productId);
        html += `<button
            id="pay-btn"
            data-buyer-id="${buyerId}"
            data-seller-id="${product.sellerId}"
            data-product-name="${product.productName}"
            data-product-id="${product.productId}"
        >결제하기</button>`;
    }

    html += '</div>';
    area.innerHTML = html;

    console.log('buyerId: 여기1 ', buyerId);
    console.log('buyerId: 여기2 ', buyerId);
    console.log('buyerId:', buyerId, 'sellerId:', product.sellerId, 'productName:', product.productName, 'productId:', product.productId);
    const payBtn = document.getElementById('pay-btn');
    if (payBtn) {
        payBtn.onclick = function(e) {
            // 반드시 모두 this.getAttribute로 읽으세요!
             const btn = e.currentTarget;
            console.log('btn: ', btn);
            quantity = 1;
            productId = product.productId;
            buyerId = buyerId;
            console.log("buyerId: ", buyerId);
            console.log("sellerId: ",  product.sellerId);
            console.log("productName: ", product.productName);
            console.log("productId: ", product.productId);
            console.log("quantity: ", quantity);
            // 결제 로직
            var payUrl = contextPath + '/order/pay'
            + '?buyerId=' + encodeURIComponent(buyerId)		
            + '&sellerId=' + encodeURIComponent(product.sellerId)
            + '&productName=' + encodeURIComponent(product.productName)
            + '&productId=' + encodeURIComponent(product.productId)
            + '&quantity=' + encodeURIComponent(quantity);
        window.location.href = payUrl;
            
            
            
        };
    }
}

function addChatMessageToHistory(chat) {
    const chatHistoryElem = document.getElementById('chat-history');
    let alignClass = (chat.senderRole === "BUYER") ? "right" : "left";
    let msg = (chat.message !== undefined && chat.message !== null) ? chat.message : chat.chatMessage;
    let formattedTime = formatDateTime(chat.chatCreatedAt);
    console.log("formattedTime: ", formattedTime);
    console.log('msg: ', msg);
    let html =
        '<div class="chat-message ' + alignClass + '">' +
            '<div class="chat-userid">'
                + chat.chatSenderAccountId + ' (' + chat.chatSenderUserName + ') (' + chat.senderRole + ')' +
            '</div>' +
            '<div class="chat-text">' + (msg ? msg : "") + '</div>' +
            '<div class="chat-text">' + formattedTime + '</div>' 
        '</div>';
    chatHistoryElem.innerHTML += html;
    chatHistoryElem.scrollTop = chatHistoryElem.scrollHeight;
}

function formatDateTime(chatCreatedAt) {
	 if (!chatCreatedAt) return "";
	    // chatCreatedAt이 숫자(밀리초)라면 바로 Date 생성, 아니면 파싱
	    const date = new Date(Number(chatCreatedAt));
	    if (isNaN(date.getTime())) return "";
	    const yyyy = date.getFullYear();
	    const mm = String(date.getMonth() + 1).padStart(2, '0');
	    const dd = String(date.getDate()).padStart(2, '0');
	    const HH = String(date.getHours()).padStart(2, '0');
	    const min = String(date.getMinutes()).padStart(2, '0');
	    console.log("yyyy: ", yyyy , "mm: ", mm , "dd: ", "HH: ", HH, "min: ", min);
	    return yyyy + "-" + mm + "-" + dd + " " + HH + ":" + min;
}



function connectAndSubscribe(currentRoomId) {
    if (!stompClient) {
        const socketUrl = contextPath + '/ws-chat';
        console.log("SockJS endpoint 연결 시도:", socketUrl);
        const socket = new SockJS(socketUrl);
        stompClient = Stomp.over(socket);
        isConnected = false;
        enableChatInput(false);
        stompClient.connect({}, function(frame) {
            isConnected = true;
            subscribeRoom(currentRoomId);
            enableChatInput(true); // <== 연결 성공시 활성화!
            console.log("WebSocket 연결 성공:", frame);
        }, function(error) {
            isConnected = false;
            enableChatInput(false);
            console.error("WebSocket 연결 실패:", error);
            alert("채팅 서버 연결에 실패했습니다.");
        });
    } else {
        subscribeRoom(currentRoomId);
        enableChatInput(isConnected);
    }
}

function subscribeRoom(currentRoomId) {
    if (currentSubscription) {
        currentSubscription.unsubscribe();
    }
   
    currentSubscription = stompClient.subscribe('/topic/chat/' + currentRoomId, function(msg) {
        try {
            const chat = JSON.parse(msg.body);
            addChatMessageToHistory(chat);
        } catch (e) {
            console.error("메시지 파싱 실패:", e, msg.body);
        }
    });
}

function enableChatInput(enable) {
    const input = document.querySelector('input[placeholder="채팅메시지를 입력하세요"]');
    const button = document.querySelector('button[type="submit"]');
    if (input && button) {
        input.disabled = !enable;
        button.disabled = !enable;
    }
}

function sendMessage(currentRoomId) {
    if (!stompClient || !isConnected) {
        console.log("stompClient: ", stompClient);
        alert("채팅 서버에 연결되어 있지 않습니다. 잠시 후 다시 시도하세요.");
        return;
    }
    const input = document.querySelector('input[placeholder="채팅메시지를 입력하세요"]');
    const message = input.value;
    console.log("loginUserId: ", loginUserId);
    console.log("보내려는 메시지: ", message);
    if (!message.trim() || !currentRoomId) return;
    try {
        stompClient.send("/app/chat.send", {}, JSON.stringify({
            chatRoomId: currentRoomId,
            chatMessage: message,
            chatSenderAccountId: loginUserId, // 계정 ID와 동일하다면
        	productId: productId,
            buyerId: buyerId
        }));
        input.value = "";
        console.log("메시지 전송 성공:", { currentRoomId: currentRoomId, sender: loginUserId, message });
    } catch (e) {
        console.error("채팅 메시지 전송 중 에러 발생:", e);
        alert("채팅 메시지 전송에 실패했습니다. 콘솔을 확인해 주세요.");
    }
}
</script>
>>>>>>> 59d736e (feat chat_message 보내기)
</body>
</html>