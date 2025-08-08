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
	private int productId;
	private int chatSender;
	private String chatSenderAccountId;
	private String chatSenderUserName;
	private int chatReceiver;
	private String chatReceiverAccountId;
	private String chatReceiverUserName;
	private String chatMessage;
	private Timestamp chatCreatedAt;
	private String senderRole;
	private String receiverRole;
}
