package org.puppit.model.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class ChatMessageSelectDTO {
	private Integer roomId;
	private Integer userId;
	@Override
	public String toString() {
		return "ChatMessageSelectDTO [roomId=" + roomId + ", userId=" + userId + "]";
	}
	
	
}
