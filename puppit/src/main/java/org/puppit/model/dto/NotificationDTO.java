package org.puppit.model.dto;


import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class NotificationDTO {
	private String senderAccountId;
	private String receiverAccountId;
	private String chatMessage;
	private String senderRole;
	private Timestamp chatCreatedAt;
	private String productName;
	
	@Override
	public String toString() {
		return "NotificationDTO [senderAccountId=" + senderAccountId + ", receiverAccountId=" + receiverAccountId
				+ ", chatMessage=" + chatMessage + ", senderRole=" + senderRole + ", chatCreatedAt=" + chatCreatedAt
				+ ", productName=" + productName + "]";
	}
}
