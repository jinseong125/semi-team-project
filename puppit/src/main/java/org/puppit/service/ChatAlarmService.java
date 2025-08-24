package org.puppit.service;

import org.puppit.model.dto.AlarmReadDTO;

public interface ChatAlarmService {
	public Integer readAlarm(Integer messageId);
	public int markAsRead(AlarmReadDTO dto);
	
}
