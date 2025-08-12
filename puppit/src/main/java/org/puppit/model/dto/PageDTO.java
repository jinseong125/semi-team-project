package org.puppit.model.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PageDTO {

  private int page = 1;
  private int size = 8;
  private int offset;
  
  private int productCount;
  private int pageCount;
  private int beginPage;
  private int endPage;
  
  public PageDTO() { }
  
  public PageDTO(int page, int size, int productCount) {
    this.page = page;
    this.size = size;
    this.productCount = productCount;
  }
 
}
