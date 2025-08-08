package org.puppit.model.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
public class ChatMessageDTO {
	private int messageId;
	private int chatRoomId;
	private int chatSender;
	private int chatReceiver;
	private String chatMessage;
	private Timestamp chatCreatedAt;
	private String senderRole;
}
