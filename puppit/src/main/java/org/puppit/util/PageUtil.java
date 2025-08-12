package org.puppit.util;

import java.util.Map;

import org.puppit.model.dto.PageDTO;
import org.springframework.stereotype.Component;

@Component
public class PageUtil {

  private static final int PAGE_PER_BLOCK = 10;
  
  public void calculatePaging(PageDTO dto) {

    int page = dto.getPage();
    int size = dto.getSize();
    int productCount = dto.getProductCount();
    
    int offset = (page - 1) * size;
    int pageCount = (int) Math.ceil((double) productCount / size);
    int beginPage = ((page - 1) / PAGE_PER_BLOCK) * PAGE_PER_BLOCK + 1;
    int endPage = Math.min(beginPage + PAGE_PER_BLOCK - 1, pageCount);
    
    dto.setOffset(offset);
    dto.setPageCount(pageCount);
    dto.setBeginPage(beginPage);
    dto.setEndPage(endPage);
  }  
  
  public String getPagingHtml(PageDTO dto, String requestURL, Map<String, Object>params) {
    
    int page = dto.getPage();
    int pageCount = dto.getPageCount();
    int beginPage = dto.getBeginPage();
    int endPage = dto.getEndPage();
    
    String queryString = "";
    if (params != null) {
      StringBuilder queryStringBuilder = new StringBuilder();
      for (Map.Entry<String, Object> entry : params.entrySet()) {
        queryStringBuilder.append("&");
        queryStringBuilder.append(entry.getKey());
        queryStringBuilder.append("=");
        queryStringBuilder.append(entry.getValue());
      }
        queryString = queryStringBuilder.toString();
    }
   StringBuilder builder = new StringBuilder();
   
   builder.append("<style>");
   builder.append(".pagination { display: flex; justify-content: center; width: 400px; margin: 0 auto; }");
   builder.append(".pagination button { display: block; border: none; background-color: #fff; text-align: center; width: 30px; height: 30px; line-height: 30px; cursor: pointer; }");
   builder.append(".pagination .disabled-button { color: silver; cursor: auto; }");
   builder.append(".pagination .focus-page { color: limegreen; }");
   builder.append("</style>");
   
   builder.append("<div class=\"pagination\">");
   
   if (beginPage == 1)
     builder.append("<bytton type=\"button\" class=\"disabled-button\">&lt;</button>");
   else
     builder.append("<button type=\"button\" onclick=\"location.href='" + requestURL + "?page=" + (beginPage - 1) + queryString + "'\">&lt;</button>");
   
   builder.append("<div>");
   
   return builder.toString();
  }
 
}