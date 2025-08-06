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
public class PointDTO {
  private Integer chargeId;
  private Integer userId;
  private Integer pointChargeAmount;
  private String pointChargeImpUid;
  private String pointChargeOrderNumber;
  private Timestamp pointChargeChargedAt; 
}
