package kr.or.ddit.service;

import java.util.List;

import kr.or.ddit.domain.ASchedule;
import kr.or.ddit.domain.Allocation;
import kr.or.ddit.domain.StudentLecture;

public interface AScheduleService {
	
	// 일정 등록
	public int register(ASchedule aSchedule);
}
