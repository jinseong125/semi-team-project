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
public class ChatListDTO {
	private Integer roomId;
	private boolean chatIsRead;
	private String chatMessage;
	private Timestamp chatSentAt;
	private String chatSenderId;
	private String chatReceiverId;
	private String profileImage;
	private String senderAccountId;
	private String receiverAccountId;
	private int unreadCount;
	
	@Override
	public String toString() {
		return "ChatListDTO [roomId=" + roomId + ", chatIsRead=" + chatIsRead + ", chatMessage=" + chatMessage
				+ ", chatSentAt=" + chatSentAt + ", chatSenderId=" + chatSenderId + ", chatReceiverId=" + chatReceiverId
				+ ", profileImage=" + profileImage + ", senderAccountId=" + senderAccountId + ", receiverAccountId="
				+ receiverAccountId + ", unreadCount=" + unreadCount + "]";
	}
	
	
	
}
