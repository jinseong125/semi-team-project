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
public class ChatListDTO {
	private Integer roomId;
	private Integer productId;
	private String productName;
	private Integer productPrice;
	private Integer sellerId;
	private String sellerName;
	private String sellerAccountId;
	private Integer otherUserId;
	private String otherAccountId;
	private String otherUserName;
	private String lastMessage;
	private Timestamp lastMessageAT;
	private Integer lastMessageSenderId;
	private String lastMessageSenderAccountId;
	private String lastMessageSenderName;
	private Integer lastMessageReceiverId;
	private String lastMessageReceiverAccountId;
	private String lastMessageReceiverName;
	private Timestamp sortTime;
	private Timestamp chatCreatedAt; // 마지막 메시지 생성 시간 추가
	
	@Override
	public String toString() {
		return "ChatListDTO [roomId=" + roomId + ", productId=" + productId + ", productName=" + productName
				+ ", productPrice=" + productPrice + ", sellerId=" + sellerId + ", sellerName=" + sellerName
				+ ", sellerAccountId=" + sellerAccountId + ", otherUserId=" + otherUserId + ", otherAccountId="
				+ otherAccountId + ", otherUserName=" + otherUserName + ", lastMessage=" + lastMessage
				+ ", lastMessageAT=" + lastMessageAT + ", lastMessageSenderId=" + lastMessageSenderId
				+ ", lastMessageSenderAccountId=" + lastMessageSenderAccountId + ", lastMessageSenderName="
				+ lastMessageSenderName + ", lastMessageReceiverId=" + lastMessageReceiverId
				+ ", lastMessageReceiverAccountId=" + lastMessageReceiverAccountId + ", lastMessageReceiverName="
				+ lastMessageReceiverName + ", sortTime=" + sortTime + ", chatCreatedAt=" + chatCreatedAt + "]";
	}
	

	
	

	

	
	
	
	
	
}
