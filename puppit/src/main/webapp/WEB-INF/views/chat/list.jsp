<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
	Object accountIdObj = session.getAttribute("accountId");
	String accountId = "";
	if (accountIdObj != null) {
	    accountId = accountIdObj.toString();
	}
%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="loginUserId" value="<%= accountId %>" />
<c:set var="roomId" value="${roomId}" />
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
.chatList {
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
.chatList:hover {
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
    display: flex;
    justify-content: center;
    align-items: center;
    font-size: 28px;
    color: #bbb;
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
    justify-content: flex-end;
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

/* 채팅 내역(오른쪽 채팅창) */
.chat-history {
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    width: 100%;
    gap: 12px;
    margin-bottom: 16px;
    overflow-y: auto;
    flex: 1;
    scrollbar-width: none;         /* Firefox */
    -ms-overflow-style: none;      /* IE, Edge */
}
.chat-history::-webkit-scrollbar {
    display: none;                 /* Chrome, Safari, Opera */
}
.chat-history .chat-message {
    max-width: 60%;
    min-width: 80px;
    padding: 10px 16px;
    border-radius: 12px;
    margin-bottom: 4px;
    display: flex;
    flex-direction: column;
    background: #eee;
    box-sizing: border-box;
    word-break: break-word;
    height: auto;
    overflow: visible;
}
.chat-history .chat-message.right {
    align-self: flex-end !important;
    background: #e9f7fe;
    text-align: right;
}
.chat-history .chat-message.left {
    align-self: flex-start !important;
    background: #eee;
    text-align: left;
}
.chat-history .chat-message .chat-userid {
    font-size: 13px;
    color: #888;
    margin-bottom: 2px;
}
.chat-history .chat-message .chat-text {
    font-size: 15px;
    margin-bottom: 2px;
    white-space: pre-wrap;
    overflow-wrap: break-word;
    word-break: break-word;
}
.chat-history .chat-message .chat-time {
    font-size: 12px;
    color: #aaa;
    margin-top: 2px;
    align-self: flex-end;
}
  </style>
</head>
<body>

<div class="container-header">
    <h1>채팅방 목록</h1>
</div>

<div class="container">
    <!-- 채팅방 목록(왼쪽, 항상 유지) -->
    <div class="chatlist-container">
        <c:forEach items="${chatList}" var="chat">
            <div class="chatList" data-room-id="${chat.roomId}" >
                
                        <span class="chat-profile-img chat-profile-icon">
                            <i class="fa-solid fa-user"></i>
                        </span>
                   
                <div class="chat-info-area" style="cursor:pointer;">
                    <div class="chat-nickname">${chat.lastMessageReceiverAccountId}</div>
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

    <!-- 채팅내역 + 입력창 (오른쪽) -->
    <div class="chat-container">
    	<div class="product-info-area" id="product-info-area"></div>
        <div class="chat-history" id="chat-history"></div>
        <div class="chat-input-group">
            <input placeholder="채팅메시지를 입력하세요"/>
            <button type="submit">전송</button>
        </div>
    </div>
</div>

<script>
const contextPath = "${contextPath}";
const loginUserId = "${loginUserId}";

document.addEventListener('DOMContentLoaded', function() {
    document.querySelector('.chatlist-container').addEventListener('click', function(e) {
        const chatDiv = e.target.closest('.chatList');
        if (chatDiv) {
            const roomId = chatDiv.dataset.roomId;
            const senderId = loginUserId; // 세션에서 가져온 유저 아이디 사용
            if (!roomId) {
                alert("roomId가 비어 있습니다!");
                return;
            }
            const url = contextPath + "/chat/message?roomId=" + roomId + "&loginUserId=" + senderId;
            fetch(url)
            .then(res => res.json())
            .then(map => {
                const productInfoElem = document.getElementById('product-info-area');
                if (productInfoElem) {
                    const chatMessages = map.chatMessages || [];
                    if (chatMessages.length > 0) {
                        // 첫번째 메시지에서 필요한 정보 추출
                        const firstMsg = chatMessages[0];
                        // sellerId는 productSellerId 또는 senderSellerId/receiverSellerId 중 실제 값이 있는 것으로 선택
                        let sellerId = firstMsg.productSellerId || firstMsg.senderSellerId || firstMsg.receiverSellerId || "";
                        sellerId = sellerId ? sellerId.toString() : "";
                        let buyerId = "";
                        if (firstMsg.senderRole === "BUYER") buyerId = firstMsg.chatSenderAccountId;
                        else if (firstMsg.receiverRole === "BUYER") buyerId = firstMsg.chatReceiverAccountId;

                        // 상품 정보는 map.product 또는 메시지에서 가져옴
                        let pname = "";
                        let pprice = "";
                        if (map.product) {
                            pname = map.product.productName || "";
                            pprice = (map.product.productPrice != null ? map.product.productPrice : "");
                        } else {
                            pname = firstMsg.productName || "";
                            pprice = (firstMsg.productPrice != null ? firstMsg.productPrice : "");
                        }

                        // 디버깅
                        console.log("loginUserId:", loginUserId, "sellerId:", sellerId, "buyerId:", buyerId);

                        let productHtml =
                            '<div class="product-info" style="margin-bottom:16px;padding:12px;background:#f3f3f3;border-radius:10px;">'
                            + '<b>상품명:</b> ' + pname
                            + '<br><b>가격:</b> ' + pprice + '원';

                        // SELLER가 보는 화면이면 버튼 추가 (타입을 맞춰서 비교!)
                        if (String(loginUserId) === String(buyerId)) {
                            productHtml +=
                                '<br><button id="pay-btn"'
                                + ' style="margin-top:12px;padding:10px 24px;background:#e74c3c;color:#fff;border:none;border-radius:8px;font-size:16px;cursor:pointer;"'
                                + ' data-buyer-id="' + buyerId + '"'
                                + ' data-seller-id="' + sellerId + '"'
                                + ' data-product-name="' + pname + '"'
                                + ' data-qty="1"'
                                + '>'
                                + '결제하기'
                                + '</button>';
                        }

                        productHtml += '</div>';
                        productInfoElem.innerHTML = productHtml;

                        // 결제하기 버튼 이벤트 바인딩
                        setTimeout(function() {
                            var payBtn = document.getElementById('pay-btn');
                            if (payBtn) {
                                payBtn.onclick = function() {
                                    var buyerId = this.getAttribute('data-buyer-id');
                                    var sellerId = this.getAttribute('data-seller-id');
                                    var productName = this.getAttribute('data-product-name');
                                    var qty = this.getAttribute('data-qty');
                                    var payUrl = contextPath + '/order/pay'
                                        + '?buyerId=' + encodeURIComponent(buyerId)
                                        + '&sellerId=' + encodeURIComponent(sellerId)
                                        + '&productName=' + encodeURIComponent(productName)
                                        + '&qty=' + encodeURIComponent(qty);
                                    window.location.href = payUrl;
                                };
                            }
                        }, 0);
                    } else {
                        productInfoElem.innerHTML = "";
                    }
                }

                const list = map.chatMessages || [];
                let html = "";   
                list.forEach(msg => {
                    const alignClass = (msg.senderRole === "BUYER") ? "right" : "left";
                    let chatTime = "";
                    if (msg.chatCreatedAt) {
                        chatTime = formatKoreanTime(msg.chatCreatedAt);
                    }
                    html +=
                        '<div class="chat-message ' + alignClass + '">' +
                            '<div class="chat-userid">' +
                                msg.chatSenderAccountId + ' (' + msg.chatSenderUserName + ') (' + msg.senderRole + ')' +
                            '</div>' +
                            '<div class="chat-text">' + msg.chatMessage + '</div>' +
                            '<div class="chat-time">' + chatTime + '</div>' +
                        '</div>';
                });
                const chatHistoryElem = document.getElementById('chat-history');
                if (!chatHistoryElem) {
                    alert("#chat-history 요소가 없습니다!");
                    return;
                }
                chatHistoryElem.innerHTML = html;
                chatHistoryElem.scrollTop = chatHistoryElem.scrollHeight;
            })
            .catch(err => console.error("fetch 실패:", err));
        }
    });
});

// formatKoreanTime은 timestamp(ms)도 지원하게!
function formatKoreanTime(ts) {
    if (!ts) return "";
    let d;
    if (typeof ts === "string" && ts.length > 0 && !isNaN(Number(ts))) {
        d = new Date(Number(ts));
    } else if (typeof ts === "number") {
        d = new Date(ts);
    } else {
        d = new Date(ts);
    }
    if (isNaN(d.getTime())) return "";
    let hour = d.getHours();
    let min = d.getMinutes();
    const ampm = hour < 12 ? "오전" : "오후";
    hour = hour % 12; if (hour === 0) hour = 12;
    return `${ampm} ${hour}시 ${min < 10 ? '0' + min : min}분`;
}
</script>
</body>
</html>