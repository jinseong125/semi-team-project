package org.shark.crud.model.dto;

import java.sql.Timestamp;

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
@Builder
@ToString
public class BoardDTO {
  private Integer bid;
  private UserDTO user;
  private String title;
  private String content;
  private Timestamp createdAt;
  private Timestamp modifiedAt;
 
}
