package org.puppit.controller;

import org.puppit.model.dto.PageDTO;
import org.puppit.model.dto.ProductDTO;
import org.puppit.service.ProductService;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lombok.RequiredArgsConstructor;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

@RequiredArgsConstructor
@Controller
public class MainController {
  
  private final ProductService productService;
  

//최초 진입 시 JSP에서 첫 8개 상품 렌더링
  @RequestMapping(value = "/")
  public String main(PageDTO dto
          , HttpServletRequest request
          , Model model) {

	  dto.setSize(20);
	  dto.setPage(1);
	  dto.setOffset(0); // <---- 반드시 직접 넣어주거나, 서비스에서 계산
	 
	  List<ProductDTO> productsImage = productService.mainProducts();

    model.addAttribute("products",productsImage);
      return "main";
  }


  //무한스크롤 API: offset과 size를 받아서 상품 리스트를 반환
  @GetMapping(value = "/product/list", produces = "application/json" )
  public ResponseEntity<Map<String, Object>> getProducts(
		  @RequestParam(value="offset", defaultValue="0") int offset,
		    @RequestParam(value="size", defaultValue="60") int size, HttpServletRequest request) {
	  PageDTO dto = new PageDTO();
	    dto.setOffset(offset);
	    dto.setSize(size);

	    Map<String, Object> map = productService.getProducts(dto, request);
	    return ResponseEntity.ok(map); // 항상 200 반환

  }
}