package org.puppit.model.dto;

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
public class UserDTO {

  private Integer userId;
  private String acountId;
  private String userName;
  private String nickName;
  private String userPassword;
  private String userEmail;
  private String userPhone;
}
