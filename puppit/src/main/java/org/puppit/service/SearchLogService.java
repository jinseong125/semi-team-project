package org.puppit.service;

import java.util.List;

import org.puppit.model.dto.SearchLogDTO;

public interface SearchLogService {

  
  List<SearchLogDTO> getTopKeywords();
  
}
