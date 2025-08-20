package org.puppit.model.dto;

import org.springframework.stereotype.Service;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class ProductImageLIstDTO {

  private Integer imageId;
  private Integer productId;
  private String imageUrl;
  private boolean isThumbnail;
  
  @Override
  public String toString() {
    return "ProductImageLIstDTO [imageId=" + imageId + ", productId=" + productId + ", imageUrl=" + imageUrl
        + ", isThumbnail=" + isThumbnail + "]";
  }
  
  
}  
