package org.puppit.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.puppit.model.dto.AlarmReadDTO;
import org.puppit.model.dto.NotificationDTO;
import org.puppit.model.dto.UserDTO;
import org.puppit.service.ChatAlarmService;
import org.puppit.service.ChatService;
import org.puppit.service.UserService;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/api")
@RequiredArgsConstructor
public class ChatApiAlarmController {

	private final ChatService chatService;
	private final ChatAlarmService alarmService;
	private final UserService userService;
	
	
	@GetMapping(value = "/alarm",  produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List< NotificationDTO> getUnreadAlarms(@RequestParam Integer userId) {
		List<NotificationDTO> unreadAlarms = chatService.getUnreadAlarms(userId);
		System.out.println("안읽은 알림: " + chatService.getUnreadAlarms(userId) );
		return unreadAlarms;
	}
	
	@PostMapping(value = "/alarm/read",  produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public ResponseEntity<?> readAlarm(@RequestBody AlarmReadDTO alarmReadDTO) {
	    try {
	        System.out.println("messageId: " + alarmReadDTO.getMessageId());
	        UserDTO user = userService.getUserId(alarmReadDTO.getChatReceiver());
	        if (user == null) {
	            Map<String, Object> result = new HashMap<>();
	            result.put("result", "fail");
	            result.put("error", "해당 chatReceiver에 대한 사용자 정보가 없습니다.");
	            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(result);
	        }
	        alarmReadDTO.setChatReceiverUserId(user.getUserId());
	        int readUpdateCount = alarmService.markAsRead(alarmReadDTO);
	        System.out.println("알림 메시지 읽음 여부: " + readUpdateCount);
	        return ResponseEntity.ok().body(java.util.Map.of("result", "ok"));
	    } catch (Exception e) {
	        Map<String, Object> result = new HashMap<>();
	        result.put("result", "fail");
	        result.put("error", e.getMessage() == null ? "" : e.getMessage());
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(result);
	    }
	}
	
	
	@PostMapping(value = "/alarm/readAll", produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public ResponseEntity<?> readAllAlarms(@RequestBody Map<String, Object> params) {
	    try {
	        Integer roomId = Integer.valueOf(params.get("roomId").toString());
	        Integer userId = Integer.valueOf(params.get("userId").toString());
	        Integer groupCount = Integer.valueOf(params.get("count").toString());
	        int n = alarmService.markAllAsRead(roomId, userId, groupCount);
	        System.out.println("roomId: " + roomId + ",userId: " + userId + ",groupCount: " + groupCount + ",n: " + n);
	        
	        
	        return ResponseEntity.ok(Map.of("result", "ok", "count", n));
	    } catch (Exception e) {
	        Map<String, Object> result = new HashMap<>();
	        result.put("result", "fail");
	        result.put("error", e.getMessage() == null ? "" : e.getMessage());
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(result);
	    }
	}
}
