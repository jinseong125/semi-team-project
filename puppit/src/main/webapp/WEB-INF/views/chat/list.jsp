<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
        .chatlist-container { width: 400px; height: 600px; border: none; padding: 0; margin: 0; }
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
    </style>
</head>
<body>
<div class="container-header">
    <h1>채팅방 목록</h1>
</div>
<div class="container">
    <div class="chatlist-container">
        <c:forEach items="${chatList}" var="chat">
            <div class="chatList" data-room-id="${chat.roomId}">
                <span class="chat-profile-img chat-profile-icon">
                    <i class="fa-solid fa-user"></i>
                </span>
                <div class="chat-info-area" style="cursor:pointer;">
                    <div class="chat-nickname">${chat.lastMessageSenderAccountId}</div>
                    <div class="chat-message">${chat.lastMessage}</div>
                </div>
                <div class="chat-meta">
                    <span class="chat-time">
                        <fmt:formatDate value="${chat.lastMessageAT}" pattern="a h시 mm분"/>
                    </span>
                </div>
            </div>
        </c:forEach>
    </div>
    <div class="chat-container">
        <div class="product-info-area" id="product-info-area"></div>
        <div class="chat-history" id="chat-history"></div>
        <div class="chat-input-group">
            <input placeholder="채팅메시지를 입력하세요"/>
            <button type="submit">전송</button>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1.6.1/dist/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.2/stomp.min.js"></script>
<script>
const contextPath = "${contextPath}";
const loginUserId = "${loginUserId}";
const userId = "${userId}";

let stompClient = null;
let currentRoomId = null;
let currentSubscription = null;
let isConnected = false;
let productId = null;
let buyerId = null;

document.addEventListener('DOMContentLoaded', function() {
    const chatlist = document.querySelector('.chatlist-container');
    if (chatlist) {
        chatlist.addEventListener('click', function(e) {
            const chatDiv = e.target.closest('.chatList');
            if (chatDiv) {
                const roomId = chatDiv.dataset.roomId;
                currentRoomId = roomId;  
                console.log("currentRoomId: ", currentRoomId);
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
            console.log('채팅방 데이터:', data);

            if (data.product) {
                renderProductInfo(data.product, data.chatMessages || []);
            } else {
                document.getElementById('product-info-area').innerHTML = '';
            }

            const chatHistoryElem = document.getElementById('chat-history');
            chatHistoryElem.innerHTML = "";
            const messages = Array.isArray(data.chatMessages) ? data.chatMessages : [];
            messages.forEach(chat => addChatMessageToHistory(chat));
        })
        .catch(err => {
            console.error("채팅 내역 불러오기 실패:", err);
        });
}

// 수정: 매개변수에서 chatSellerAccountId 제거
function renderProductInfo(product, chatMessages) {
    const area = document.getElementById('product-info-area');
    if (!area || !product) return;
    const price = Number(product.productPrice);

    // chatSellerAccountId를 chatMessages에서 가져온다!
    let chatSellerAccountId = '';
    if (Array.isArray(chatMessages) && chatMessages.length > 0) {
        if ('chatSellerAccountId' in chatMessages[0]) {
            chatSellerAccountId = chatMessages[0].chatSellerAccountId || '';
        }
    }
    
    // 만약 값이 없으면 product.sellerAccountId로 대체 (백엔드에서 내려주는 경우)
    if (!chatSellerAccountId && product.sellerAccountId) {
        chatSellerAccountId = product.sellerAccountId;
    }
    
    console.log("render - chatSellerAccountId: ", chatSellerAccountId);

    let resolvedBuyerId = null;
    if (Array.isArray(chatMessages) && chatMessages.length > 0) {
        resolvedBuyerId = chatMessages[0].buyerId || null;
        if (!resolvedBuyerId) {
            const validMsg = chatMessages.find(msg => msg.buyerId != null && msg.buyerId !== "");
            if (validMsg) resolvedBuyerId = validMsg.buyerId;
        }
    }

    let html =
        '<div style="margin-bottom:10px; border-bottom:1px solid #eee; padding-bottom:12px;">'
        + '<strong>상품명:</strong> ' + product.productName + '<br>'
        + '<strong>가격:</strong> ' + (isNaN(price) ? product.productPrice : price.toLocaleString()) + '원 <br>';

    if (userId == resolvedBuyerId) {
        html += `<button
            id="pay-btn"
            data-buyer-id="\${resolvedBuyerId}"
            data-seller-id="\${product.sellerId}"
            data-seller-account-id="\${chatSellerAccountId}"
            data-product-name="\${product.productName}"
            data-product-id="\${product.productId}"
        >결제하기</button>`;
    }

    html += '</div>';
    area.innerHTML = html;

    const payBtn = document.getElementById('pay-btn');
    if (payBtn) {
        payBtn.onclick = function(e) {
            const btn = e.currentTarget;
            console.log(btn);
            console.log(btn.dataset)
            // 반드시 data-seller-account-id를 읽어서 콘솔에 찍음!
            chatSellerAccountId =  btn.dataset.sellerAccountId;
            console.log('결제버튼 클릭 - chatSellerAccountId:', chatSellerAccountId); // 여기서 찍힘
            quantity = 1;
            productId = product.productId;
            buyerId = resolvedBuyerId;
            var payUrl = contextPath + '/order/pay'
                + '?buyerId=' + encodeURIComponent(resolvedBuyerId)
                + '&sellerId=' + encodeURIComponent(product.sellerId)
                + '&chatSellerAccountId=' + encodeURIComponent(chatSellerAccountId)
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
    let html =
        '<div class="chat-message ' + alignClass + '">' +
            '<div class="chat-userid">'
                + (chat.chatSenderAccountId || "") + ' (' + (chat.chatSenderUserName || "") + ') (' + (chat.senderRole || "") + ')' +
            '</div>' +
            '<div class="chat-text">' + (msg ? msg : "") + '</div>' +
            '<div class="chat-text">' + formattedTime + '</div>' +
        '</div>';
    chatHistoryElem.innerHTML += html;
    chatHistoryElem.scrollTop = chatHistoryElem.scrollHeight;
}

function formatDateTime(chatCreatedAt) {
    if (!chatCreatedAt) return "";
    const date = new Date(Number(chatCreatedAt));
    if (isNaN(date.getTime())) return "";
    const yyyy = date.getFullYear();
    const mm = String(date.getMonth() + 1).padStart(2, '0');
    const dd = String(date.getDate()).padStart(2, '0');
    const HH = String(date.getHours() + 1).padStart(2, '0');
    const min = String(date.getMinutes()).padStart(2, '0');
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
            enableChatInput(true);
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
        alert("채팅 서버에 연결되어 있지 않습니다. 잠시 후 다시 시도하세요.");
        return;
    }
    const input = document.querySelector('input[placeholder="채팅메시지를 입력하세요"]');
    const message = input.value;
    if (!message.trim() || !currentRoomId) return;

    // pay-btn에서 chatSellerAccountId 읽기
    let chatSellerAccountId = "";
    const payBtn = document.getElementById('pay-btn');
    if (payBtn) {
        chatSellerAccountId = payBtn.getAttribute("data-seller-account-id") || "";
    }
    console.log('chatSellerAccountId: ', chatSellerAccountId);
    try {
        stompClient.send("/app/chat.send", {}, JSON.stringify({
            chatRoomId: currentRoomId,
            chatMessage: message,
            chatSenderAccountId: loginUserId,
            chatSellerAccountId: chatSellerAccountId,
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
</body>
</html>