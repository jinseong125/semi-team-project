package org.puppit.model.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
@Builder
public class UserStatusDTO {
  
  private Integer loginId;
  private Integer userId;
  private String accountId;
  private LocalDateTime loginAt;

}
