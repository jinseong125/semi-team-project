package org.puppit.model.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class TradeDTO {
  private Integer paymentId;
  private String uuid;
  private Integer buyerId;
  private String sellerId;
  private String productId;
  private String status; 
  private Timestamp createdAt;
}
