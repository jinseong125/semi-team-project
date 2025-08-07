package org.puppit.controller;

import java.util.List;

import org.puppit.model.dto.ChatListDTO;
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
}
