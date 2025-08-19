package org.puppit.model.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PageDTO {

  private int page = 1;
  private int size = 16;
  private int offset;
  
  private int itemCount;  //
  private int pageCount;
  private int beginPage;
  private int endPage;
  
  public PageDTO() { }
  
  public PageDTO(int page, int size, int itemCount) {
	    this.page = page;
	    this.size = size;
	    this.itemCount = itemCount;
	  }
 
}