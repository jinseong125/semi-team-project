package org.puppit.controller;


import java.util.List;

import org.puppit.model.dto.ChatMessageDTO;
import org.puppit.model.dto.ChatMessageSearchDTO;
import org.puppit.model.dto.ChatRoomPeopleDTO;
import org.puppit.model.dto.ChatUserDTO;
import org.puppit.service.ChatService;
import org.puppit.service.UserService;

import org.springframework.stereotype.Controller;

import org.puppit.model.dto.ChatMessageDTO;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.SimpMessagingTemplate;

import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Controller;

import lombok.RequiredArgsConstructor;


@RequiredArgsConstructor
@Controller
public class ChatWebSocketController {
	
	private final SimpMessagingTemplate messagingTemplate;
	private final UserService userService;
	private final ChatService chatService;


	
	 // 클라이언트가 /app/chat.send로 메시지 전송
    @MessageMapping("/chat.send")
    public void sendMessage(@Payload ChatMessageDTO chatMessageDTO,
                            SimpMessageHeaderAccessor headerAccessor) {

    	// 1. 여기서 senderId(혹은 loginUserId)로 사용자 정보 조회
        //    예: chatMessageDTO.getSender() 또는 headerAccessor.getSessionAttributes() 등에서 userId 추출
        System.out.println("chatMessageDTO: "+ chatMessageDTO.toString());
        //System.out.println("senderUserId: " + senderUserId);
        System.out.println("senderAccountId: " + chatMessageDTO.getChatSenderAccountId());
        System.out.println("chatMessage: " + chatMessageDTO.getChatMessage());
        System.out.println("chatRoomID: " + chatMessageDTO.getChatRoomId());

        /*
         * chatMessageDTO: ChatMessageDTO [messageId=null, chatRoomId=5, productId=null, chatSender=user02, chatSenderAccountId=user02, chatSenderUserName=null, chatReceiver=null, chatReceiverAccountId=null, chatReceiverUserName=null, chatMessage=test, chatCreatedAt=null, senderRole=null, receiverRole=null, buyerId=null]
```````````senderAccountId: user02
```````````chatMessage: test
```````````chatRoomID: 5
         * */
        
        
        // 2. DB 또는 서비스에서 사용자 정보 조회
        //    (ChatService 등 활용)
        ChatUserDTO sender = userService.getUserByUserId(chatMessageDTO.getChatSenderAccountId()); // 직접 구현 필요
        System.out.println("sender: " + sender.toString());
        // sender: ChatUserDTO [userId=2, accountId=user02, userName=김철수, nickName=철수]
        
        

        // 3. 본인이 보낸 메시지에서 receiver 정보, 역할, buyerId 찾기 (가장 최근 메시지를 기준으로 추출)
        ChatRoomPeopleDTO latest = null;
        ChatMessageSearchDTO messageSearchDTO = new ChatMessageSearchDTO(sender.getUserId(), Integer.parseInt(chatMessageDTO.getChatRoomId()));
        List<ChatRoomPeopleDTO> chatRoomPeoples = chatService.getUserRoleANDAboutChatMessagePeople(messageSearchDTO);
        System.out.println("chatRoomPeoples: " + chatRoomPeoples.toString());
        for (int i = chatRoomPeoples.size()-1; i >= 0; i--) {
        	 ChatRoomPeopleDTO msg = chatRoomPeoples.get(i);
             // 내가 최근에 보낸 메시지라면
             if (msg.getSenderAccountId().equals(sender.getAccountId())) {
                 latest = msg;
                 break;
             }
        	
        }
        System.out.println("latest: " + latest.toString());
        //latest: ChatRoomPeopleDTO [messageId=77, chatRoomId=5, productId=3, chatSender=2, senderAccountId=user02, senderUserName=김철수, receiverAccountId=user03, receiverUserName=이영희, chatMessage=5천원 할인 가능할까요?, chatCreatedAt=2025-08-12 15:03:25.0, senderIsMe=1, receiverIsMe=0, senderRole=BUYER, receiverRole=SELLER, productSellerId=3]
        
     // 4. 역할 및 상대방 정보 추출
        String senderRole = latest.getSenderRole(); // 'BUYER' 또는 'SELLER'
        String receiverAccountId = latest.getReceiverAccountId();
        String receiverUserName  = latest.getReceiverUserName();
        String receiverRole      = latest.getReceiverRole(); // 'BUYER' 또는 'SELLER'
        //Integer buyerId          = latest.getBuyerId();      // 구매자 user_id 
        
        System.out.println("메시지 발신지 senderRole: " + senderRole);
        System.out.println("메시지 수신자 receiverAccountId: " + receiverAccountId);
        System.out.println("메시지 수신자 receiverUserName: " + receiverUserName);
        System.out.println("메시지 수신자 receiverRole: " + receiverRole);
        // chatRoomPeoples: [ChatRoomPeopleDTO [messageId=36, chatRoomId=5, productId=3, 
            // chatSender=2, senderAccountId=user02, senderUserName=김철수, receiverAccountId=user03, receiverUserName=이영희, chatMessage=안녕하세요, 상품3 구매 문의드립니다., chatCreatedAt=2025-08-12 13:52:56.0, senderIsMe=1, receiverIsMe=0, senderRole=BUYER, receiverRole=SELLER, 
        //productSellerId=3], 
        //ChatRoomPeopleDTO [messageId=37, chatRoomId=5, productId=3, chatSender=3, senderAccountId=user03, senderUserName=이영희, receiverAccountId=user02, receiverUserName=김철수, chatMessage=안녕하세요, 무엇이 궁금하신가요?, chatCreatedAt=2025-08-12 13:52:56.0, senderIsMe=0, receiverIsMe=1, senderRole=SELLER, receiverRole=BUYER, productSellerId=3], ChatRoomPeopleDTO [messageId=38, chatRoomId=5, productId=3, chatSender=2, senderAccountId=user02, senderUserName=김철수, receiverAccountId=user03, receiverUserName=이영희, chatMessage=상태는 어떤가요?, chatCreatedAt=2025-08-12 13:52:56.0, senderIsMe=1, receiverIsMe=0, senderRole=BUYER, receiverRole=SELLER, productSellerId=3], ChatRoomPeopleDTO [messageId=39, chatRoomId=5, productId=3, chatSender=3, senderAccountId=user03, senderUserName=이영희, receiverAccountId=user02, receiverUserName=김철수, chatMessage=거의 새것입니다. 사진 보내드릴까요?, chatCreatedAt=2025-08-12 13:52:56.0, senderIsMe=0, receiverIsMe=1, senderRole=SELLER, receiverRole=BUYER, productSellerId=3], ChatRoomPeopleDTO [messageId=40, chatRoomId=5, productId=3, chatSender=2, senderAccountId=user02, senderUserName=김철수, receiverAccountId=user03, receiverUserName=이영희, chatMessage=네, 사진 부탁드려요., chatCreatedAt=2025-08-12 13:52:56.0, senderIsMe=1, receiverIsMe=0, senderRole=BUYER, receiverRole=SELLER, productSellerId=3], ChatRoomPeopleDTO [messageId=41, chatRoomId=5, productId=3, chatSender=3, senderAccountId=user03, senderUserName=이영희, receiverAccountId=user02, receiverUserName=김철수, chatMessage=사진 첨부드렸어요! 확인해주세요., chatCreatedAt=2025-08-12 13:52:56.0, senderIsMe=0, receiverIsMe=1, senderRole=SELLER, receiverRole=BUYER, productSellerId=3], ChatRoomPeopleDTO [messageId=42, chatRoomId=5, productId=3, chatSender=2, senderAccountId=user02, senderUserName=김철수, receiverAccountId=user03, receiverUserName=이영희, chatMessage=잘 받았습니다. 가격 협의 가능할까요?, chatCreatedAt=2025-08-12 13:52:56.0, senderIsMe=1, receiverIsMe=0, senderRole=BUYER, receiverRole=SELLER, productSellerId=3], ChatRoomPeopleDTO [messageId=43, chatRoomId=5, productId=3, chatSender=3, senderAccountId=user03, senderUserName=이영희, receiverAccountId=user02, receiverUserName=김철수, chatMessage=네, 어느 정도 생각하시나요?, chatCreatedAt=2025-08-12 13:52:56.0, senderIsMe=0, receiverIsMe=1, senderRole=SELLER, receiverRole=BUYER, productSellerId=3], ChatRoomPeopleDTO [messageId=77, chatRoomId=5, productId=3, chatSender=2, senderAccountId=user02, senderUserName=김철수, receiverAccountId=user03, receiverUserName=이영희, chatMessage=5천원 할인 가능할까요?, chatCreatedAt=2025-08-12 15:03:25.0, senderIsMe=1, receiverIsMe=0, senderRole=BUYER, receiverRole=SELLER, productSellerId=3]]
        
        
     // 5. chatMessageDTO에 세팅
        chatMessageDTO.setChatSenderAccountId(sender.getAccountId());
        chatMessageDTO.setChatSenderUserName(sender.getUserName());
        chatMessageDTO.setSenderRole(senderRole);

        chatMessageDTO.setChatReceiverAccountId(receiverAccountId);
        chatMessageDTO.setChatReceiverUserName(receiverUserName);
        chatMessageDTO.setReceiverRole(receiverRole);

        
        chatMessageDTO.setChatSenderAccountId(sender.getAccountId());
        chatMessageDTO.setChatSenderUserName(sender.getUserName());
        ChatUserDTO senderInfo = userService.getUserByUserId(chatMessageDTO.getChatSenderAccountId());
        ChatUserDTO receiverInfo = userService.getUserByUserId(receiverAccountId);
        System.out.println("senderInfo: " + senderInfo.toString());
        System.out.println("receiverInfo: " + receiverInfo.toString());
        chatMessageDTO.setChatSender(senderInfo.getUserId());
        chatMessageDTO.setChatReceiver(receiverInfo.getUserId());
        System.out.println("chatSender: " + chatMessageDTO.getChatSender());
     // 6. 메시지 DB 저장 (chatService 등)
        System.out.println("insert 하려는 chatMessageDTO: " + chatMessageDTO.toString());
        Integer insertedRow = chatService.saveChatMessage(chatMessageDTO);
    	System.out.println("insertedRow: " + insertedRow);
    	
    	
        // 예: roomId가 5이면 /topic/chat/3 구독자 모두에게 전송
        String destination = "/topic/chat/" + chatMessageDTO.getChatRoomId();
        messagingTemplate.convertAndSend(destination, chatMessageDTO);
    }
	
	
}
