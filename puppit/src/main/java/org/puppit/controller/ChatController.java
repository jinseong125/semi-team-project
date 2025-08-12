package org.puppit.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.puppit.model.dto.ChatListDTO;
import org.puppit.model.dto.ChatMessageDTO;
import org.puppit.model.dto.ChatMessageProductDTO;
import org.puppit.model.dto.ChatMessageSelectDTO;
import org.puppit.service.ChatService;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@RequestMapping("/chat")
@Controller
public class ChatController {
	
	private final ChatService chatService;
	
	@GetMapping("/list")
	public String chats(Model model, HttpSession session) {
		int userId = (Integer) session.getAttribute("userId");
		List<ChatListDTO> chatList = chatService.getChatRooms(userId);
		System.out.println("chatList: " + chatList);
		model.addAttribute("chatList", chatList);		
		return "chat/list";
	}
	
	@GetMapping(value = "/message", produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Map<String, Object> chatMessage(ChatMessageSelectDTO chatMessageSelectDTO, Model model) {
		// 현재로그인된 사용자 (loginUserId가 1번으로 가정), roomId: 1번으로 가정, 
		System.out.println("/chat/message 요청");
		System.out.println("chatMessageSelectDTO: " + chatMessageSelectDTO.toString());
		List<ChatMessageDTO> chatMessages = chatService.getChatMessageList(chatMessageSelectDTO);
		System.out.println("messages: " + chatMessages.toString());
		System.out.println("chatMessages.length: " + chatMessages.size());
		model.addAttribute("chatMessages", chatMessages.toString());
		model.addAttribute("loginUserId", chatMessageSelectDTO.getLoginUserId());
		List<ChatListDTO> chatList = chatService.getChatRooms(chatMessageSelectDTO.getRoomId());
		model.addAttribute("chatList", chatList);
		ChatMessageProductDTO product = chatService.getProduct(Integer.parseInt(chatMessages.get(0).getProductId()));
		System.out.println("product: " + product.toString() );
		Map<String, Object> map = new HashMap<>();
	    map.put("chatMessages", chatMessages);
	    
	    ChatMessageProductDTO product2 = null;
	    if (chatMessages != null && !chatMessages.isEmpty()) {
	        try {
	            String pid = chatMessages.get(0).getProductId();
	            if (pid != null && !pid.isEmpty()) {
	                product2 = chatService.getProduct(Integer.parseInt(pid));
	                System.out.println("product2: " + product2);
	            } else {
	                System.err.println("productId is null or empty");
	            }
	        } catch (Exception e) {
	            System.err.println("상품 정보 조회 에러: " + e.getMessage());
	        }
	    } else {
	        System.err.println("chatMessages가 비어있음");
	    }
	    
	    
	    
	    map.put("product", product);
		return map;
	}
}
