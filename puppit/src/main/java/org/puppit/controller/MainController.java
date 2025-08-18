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
  

  // ���� ���� �� JSP���� ù 8�� ��ǰ ������
  @RequestMapping(value = "/")
  public String main(PageDTO dto
          , HttpServletRequest request
          , Model model) {
    dto.setSize(16);
    dto.setPage(1);
    dto.setOffset(0); // <---- �ݵ�� ���� �־��ְų�, ���񽺿��� ���
    Map<String, Object> map  = productService.getProducts(dto, request);
      System.out.println("map: " + map.get("products"));
    
    model.addAttribute("products", map.get("products"));
      return "main";
  }

  // ���ѽ�ũ�� API: offset�� size�� �޾Ƽ� ��ǰ ����Ʈ�� ��ȯ
  @GetMapping(value = "/product/list", produces = "application/json" )
  public ResponseEntity<Map<String, Object>> getProducts(
      @RequestParam(value="offset", defaultValue="0") int offset,
        @RequestParam(value="size", defaultValue="16") int size, HttpServletRequest request) {
    PageDTO dto = new PageDTO();
      dto.setOffset(offset);
      dto.setSize(size);

      Map<String, Object> map = productService.getProducts(dto, request);
      return ResponseEntity.ok(map); // �׻� 200 ��ȯ
  }
}