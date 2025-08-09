<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="loginUserId" value="${loginUserId}" />
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


/*채팅 메시지들 정렬용 css*/
.chat-history {
    display: flex;
    flex-direction: column;
    gap: 12px;
    margin-bottom: 16px;
    overflow-y: auto;
    flex: 1;
}
.chat-message {
    max-width: 60%;
    padding: 10px 16px;
    border-radius: 12px;
    margin-bottom: 4px;
    display: flex;
    flex-direction: column;
    word-break: break-all;
}
.chat-message.right {
    align-self: flex-end;
    background: #e9f7fe;
    text-align: right;
}
.chat-message.left {
    align-self: flex-start;
    background: #eee;
    text-align: left;
}
.chat-userid {
    font-size: 13px;
    color: #888;
    margin-bottom: 2px;
}

.chat-text {
    font-size: 15px;
    margin-bottom: 2px;
    /* 아래 두 줄 추가 */
    white-space: pre-line;
    word-break: break-all;
}

.chat-time {
    font-size: 12px;
    color: #aaa;
    margin-top: 2px;
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
                <div class="chat-info-area" style="cursor:pointer;">
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

    <!-- 채팅내역 + 입력창 (오른쪽) -->
    <div class="chat-container">
        <div class="chat-history" id="chat-history"></div>
        <div class="chat-input-group">
            <input placeholder="채팅메시지를 입력하세요"/>
            <button type="submit">전송</button>
        </div>
    </div>
</div>

<script>
const contextPath = "${contextPath}";


document.addEventListener('DOMContentLoaded', function() {
    document.querySelector('.chatlist-container').addEventListener('click', function(e) {
        const chatDiv = e.target.closest('.chatList');
        if (chatDiv) {
            const roomId = chatDiv.dataset.roomId;
            const senderId = "1"; // 반드시 string으로!
            if (!roomId) {
                alert("roomId가 비어 있습니다!");
                return;
            }
            console.log('roomId:', roomId, 'senderId:', senderId);

            const url = contextPath + "/chat/message?roomId=" + roomId + "&loginUserId=" + senderId;
            console.log("fetch url:", url);
            fetch(url)
            .then(res => res.json())
            .then(list => {
                console.log("list:", list, Array.isArray(list));
                let html = "";
                list.forEach(msg => {
                    console.log('msg:', msg);
                    // 아래에서 값을 반드시 console로 찍어보세요!
                    console.log('chatSenderAccountId:', msg.chatSenderAccountId);
                    console.log('chatSenderUserName:', msg.chatSenderUserName);
                    console.log('chatMessage:', msg.chatMessage);
                    console.log('chatCreatedAt:', msg.chatCreatedAt);

                    // 실 데이터 확인
                    console.log('accountId:', msg.chatSenderAccountId, 'username:', msg.chatSenderUserName, 'msg:', msg.chatMessage);
					                    
                    // 본인 메시지 구분 (타입 맞추기)
                    const alignClass = (String(msg.chatSender) === senderId) ? "right" : "left";

                    // 시간 포맷팅 (숫자 → Date)
                    let chatTime = "";
				    if (msg.chatCreatedAt) {
				        chatTime = new Date(msg.chatCreatedAt).toLocaleString('ko-KR');
				    }

				    html +=
				        '<div class="chat-message ' + alignClass + '">' +
				          '<div class="chat-userid">' + msg.chatSenderAccountId + ' (' + msg.chatSenderUserName + ')</div>' +
				          '<div class="chat-text">' + msg.chatMessage + '</div>' +
				          '<div class="chat-time">' + chatTime + '</div>' +
				        '</div>';
                });
                console.log("최종 html:", html);

                const chatHistoryElem = document.getElementById('chat-history');
                if (!chatHistoryElem) {
                    alert("#chat-history 요소가 없습니다!");
                    return;
                }
                chatHistoryElem.innerHTML = html;

                console.log("chat-history innerHTML:", chatHistoryElem.innerHTML);
            })
            .catch(err => console.error("fetch 실패:", err));
        }
    });
});

// formatKoreanTime은 timestamp(ms)도 지원하게!
function formatKoreanTime(ts) {
    if (!ts) return "";
    // 숫자인 경우(UNIX timestamp ms) 처리
    const d = new Date(Number(ts));
    let hour = d.getHours();
    let min = d.getMinutes();
    const ampm = hour < 12 ? "오전" : "오후";
    hour = hour % 12; if (hour === 0) hour = 12;
    return `${ampm} ${hour}시 ${min < 10 ? '0' + min : min}분`;
}

</script>





</body>
</html>