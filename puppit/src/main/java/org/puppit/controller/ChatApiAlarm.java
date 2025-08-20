package org.puppit.controller;

import java.util.List;

import org.puppit.model.dto.NotificationDTO;
import org.puppit.service.ChatService;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/api")
@RequiredArgsConstructor
public class ChatApiAlarm {

	private final ChatService chatService;
	
	
	@GetMapping(value = "/alarm",  produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List< NotificationDTO> getUnreadAlarms(@RequestParam Integer userId) {
		List<NotificationDTO> unreadAlarms = chatService.getUnreadAlarms(userId);
		System.out.println("안읽은 알림: " + chatService.getUnreadAlarms(userId) );
		return unreadAlarms;
	}
}
