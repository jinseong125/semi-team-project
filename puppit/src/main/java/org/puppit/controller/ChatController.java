package org.puppit.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpSession;

import org.puppit.model.dto.ChatListDTO;
import org.puppit.model.dto.ChatMessageDTO;
import org.puppit.model.dto.ChatMessageProductDTO;
import org.puppit.model.dto.ChatMessageSelectDTO;
import org.puppit.model.dto.UserDTO;
import org.puppit.service.ChatService;
import org.puppit.service.UserService;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.RequiredArgsConstructor;


@RequiredArgsConstructor
@RequestMapping("/chat")
@Controller
public class ChatController {
	
	private final UserService userService;
	private final ChatService chatService;

	
	@GetMapping(value = "/message", produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Map<String, Object> chatMessage(ChatMessageSelectDTO chatMessageSelectDTO, Model model) {
	    Map<String, Object> map = new HashMap<>();
	    System.out.println("/chat/message 요청");
	    System.out.println("chatMessageSelectDTO: " + chatMessageSelectDTO.toString());

	    // 채팅 메시지 리스트 가져오기
	    List<ChatMessageDTO> chatMessages = chatService.getChatMessageList(chatMessageSelectDTO);
	    System.out.println("messages: " + (chatMessages != null ? chatMessages.toString() : "null"));
	    System.out.println("chatMessages.size: " + (chatMessages != null ? chatMessages.size() : "null"));

	    // 상품 ID 가져오기
	    Integer productId = null;
	    if (chatMessageSelectDTO.getProductId() != null) {
	        productId = chatMessageSelectDTO.getProductId(); // DTO에서 직접 가져옴
	    } else {
	        productId = chatService.getProductIdByRoomId(chatMessageSelectDTO.getRoomId()); // room 테이블에서 product_id 조회
	    }
	    System.out.println("productId: " + productId);

	    // 빈 리스트 처리
	    if (chatMessages == null || chatMessages.isEmpty()) {
	        System.err.println("chatMessages가 비어 있습니다.");
	        map.put("error", "상품 판매자와 상품에 대해 궁금한 것을 물어보고 상품을 구매해보세요.");
	    } else {
	        map.put("chatMessages", chatMessages);
	    }

	    model.addAttribute("chatMessages", chatMessages != null ? chatMessages.toString() : "null");
	    model.addAttribute("loginUserId", chatMessageSelectDTO.getLoginUserId());

	    // 상품 데이터 가져오기
	    ChatMessageProductDTO product = null;
	    try {
	        if (productId != null) {
	            product = chatService.getProductWithSellerAccountId(productId); // Fetch product with seller's account ID
	            System.out.println("product: " + (product != null ? product.toString() : "null"));
	        } else {
	            System.err.println("productId가 null입니다.");
	        }
	    } catch (Exception e) {
	        System.err.println("상품 정보 조회 에러: " + e.getMessage());
	    }

	    // 상품 정보 map에 추가
	    map.put("product", product);

	    return map;
	}
	
	@GetMapping("/createRoom")
	public String createOrGetChatRoom(@RequestParam int productId, @RequestParam int buyerId, @RequestParam int sellerId, Model model, HttpSession session) {
	    System.out.println("prodouctId: " + productId);
	    System.out.println("buyerId: " + buyerId);
	    System.out.println("sellerId: " + sellerId);
		
		// 1. 이미 해당 buyer/seller/product 조합의 채팅방이 있으면 가져옴
	    Integer roomId = chatService.findExistingRoom(productId, buyerId, sellerId);
	    if (roomId == null) {
	        // 2. 없으면 새로 생성
	        roomId = chatService.createRoom(productId, buyerId, sellerId);
	    }
	    System.out.println("새롭게 생성된 방: " + roomId);
	    // 3. 채팅방 목록으로 이동, 새로 생성된 roomId가 list 최상단에 보이도록
	    return "redirect:/chat/recentRoomList?highlightRoomId=" + roomId;
	   
	}
	
	
	// 2. 채팅방 목록 조회(생성일 기준 내림차순) - 상품상세에서 채팅하기 클릭 등
	@GetMapping("/recentRoomList")
	public String recentRoomList(@RequestParam(value = "highlightRoomId", required = false) Integer highlightRoomId, Model model, HttpSession session) {
	    Map<String, Object> map = (Map<String, Object>) session.getAttribute("sessionMap");
	    if (map == null || map.get("userId") == null) {
	        throw new IllegalStateException("세션 정보가 없습니다. 로그인이 필요합니다.");
	    }

	    Object userIdObj = map.get("userId");
	    int userId;
	    try {
	        userId = Integer.parseInt(userIdObj.toString());
	    } catch (NumberFormatException e) {
	        throw new IllegalArgumentException("사용자 ID 변환 중 오류가 발생했습니다.", e);
	    }

	    List<ChatListDTO> chatList = chatService.getChatRoomsByCreatedDesc(userId);
	   System.out.println("chatList: " + chatList);
	   
	   // 🔥 추가된 부분: ChatListDTO 객체 설정
//	    for (ChatListDTO chatListDTO : chatList) {
//	        chatListDTO.setProductName("상품명"); // 실제 상품명을 설정해야 함
//	        chatListDTO.setSelletAccountId("상품 판매자 ID");
//	    }

	    model.addAttribute("chatList", chatList);
	    model.addAttribute("highlightRoomId", highlightRoomId);
	    return "chat/list";
	}
	
	
	
}
