package org.puppit.model.dto;

import java.util.List;

import lombok.Data;

@Data
public class ScrollResponseDTO<T> {
  private Integer productId;
  private String productName;
  private String productDescription;
  private Integer productPrice;
  
  @Override
  public String toString() {
    return "ScrollResponseDTO [productId=" + productId + ", productName=" + productName + ", productDescription="
        + productDescription + ", productPrice=" + productPrice + "]";
  }
  
  
}
