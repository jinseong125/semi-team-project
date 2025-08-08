package org.puppit.controller;

import java.util.List;

import org.puppit.model.dto.ChatListDTO;
import org.puppit.model.dto.ChatMessageDTO;
import org.puppit.model.dto.ChatMessageSelectDTO;
import org.puppit.service.ChatService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@RequestMapping("/chat")
@Controller
public class ChatController {
	
	private final ChatService chatService;
	
	@GetMapping("/list")
	public String chats(Model model) {
		List<ChatListDTO> chatList = chatService.getChatRooms("1");
		System.out.println("chatList: " + chatList);
		model.addAttribute("chatList", chatList);		
		return "chat/list";
	}
	
	@GetMapping("/message")
	public String chatMessage(ChatMessageSelectDTO chatMessageSelectDTO, Model model) {
		// 현재로그인된 사용자 (loginUserId가 1번으로 가정), roomId: 1번으로 가정, 
		System.out.println("/chat/message 요청");
		List<ChatMessageDTO> chatMessages = chatService.getChatMessageList(chatMessageSelectDTO);
		System.out.println(chatMessageSelectDTO.getLoginUserId() + "가 "  + chatMessageSelectDTO.getRoomId() + "방에서 나눈 대화 : " + chatMessages);
		model.addAttribute("chatMessages", chatMessages);
		model.addAttribute("loginUserId", chatMessageSelectDTO.getLoginUserId());
		List<ChatListDTO> chatList = chatService.getChatRooms(chatMessageSelectDTO.getRoomId().toString());
		model.addAttribute("chatList", chatList);
		return "chat/list";
	}
}
