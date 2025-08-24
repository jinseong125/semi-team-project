package org.puppit.repository;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.puppit.model.dto.AlarmDuplicationDTO;
import org.puppit.model.dto.AlarmReadDTO;
import org.puppit.model.dto.NotificationDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class AlarmDAO {
	 @Autowired
     private SqlSessionTemplate sqlSessionTemplate;

	 public int countDuplicateAlarm(AlarmDuplicationDTO alarmDuplicationDTO) {
	     return sqlSessionTemplate.selectOne("mybatis.mapper.alarmMapper.countDuplicateAlarm", alarmDuplicationDTO);
	 }

	public int updateReadStatus(AlarmReadDTO dto) {
		return sqlSessionTemplate.update("mybatis.mapper.alarmMapper.updateReadStatus", dto);
		
	}

}
