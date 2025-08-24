package org.puppit.service;

import org.puppit.model.dto.AlarmReadDTO;
import org.puppit.repository.AlarmDAO;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class ChatAlarmServiceImpl implements ChatAlarmService {

	private final AlarmDAO alarmDAO;
	
	
	@Override
	public Integer readAlarm(Integer messageId) {
		// TODO Auto-generated method stub
		return null;
	}


	@Override
	public int markAsRead(AlarmReadDTO dto) {
	 return alarmDAO.updateReadStatus(dto);
		
	}

}
