package org.puppit.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
	public String chats(Model model) {
		List<ChatListDTO> chatList = chatService.getChatRooms(1);
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
	    map.put("product", product);
		return map;
	}
}
