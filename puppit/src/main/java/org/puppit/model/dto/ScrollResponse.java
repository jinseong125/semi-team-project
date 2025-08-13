package org.puppit.model.dto;

import java.util.List;

import lombok.Data;

@Data
public class ScrollResponse<T> {
  private List<T> item;
  private Long nextCursor;
  private boolean hasNote;
}
