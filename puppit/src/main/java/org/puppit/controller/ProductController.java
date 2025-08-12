package org.puppit.controller;

import lombok.RequiredArgsConstructor;
import org.puppit.model.dto.ProductDTO;
import org.puppit.model.dto.UserDTO; // 세션에 넣어둔 로그인 사용자 타입(프로젝트에 맞게 수정)
import org.puppit.service.ProductService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/product")
public class ProductController {

    private final ProductService productService;

    /** 상품 등록 폼 */
    @GetMapping("/new")
    public String newForm(ProductDTO productDTO , Model model , HttpSession session,
                          RedirectAttributes ra) {
        Integer sellerId = (Integer) session.getAttribute("userId");
        if (sellerId == null) {
            // 로그인 안 한 경우 → 로그인 페이지로 리다이렉트
            ra.addFlashAttribute("error", "상품 등록은 로그인 후 이용 가능합니다.");
            return "redirect:/user/login";
        }

        // 셀렉트 박스 데이터
        var formData = productService.getProductFormData();
        model.addAttribute("categories", formData.get("categories"));
        model.addAttribute("locations",  formData.get("locations"));
        model.addAttribute("conditions", formData.get("conditions"));
        model.addAttribute("product", new ProductDTO());

        return "product/productForm";
    }

    @PostMapping("/new")
    public String create(@ModelAttribute ProductDTO product,
                         HttpSession session,
                         RedirectAttributes ra) {

        Integer sellerId =  (Integer) session.getAttribute("userId");
        if (sellerId == null) {
            // 로그인 안 한 경우 → 로그인 페이지로 리다이렉트
            ra.addFlashAttribute("error", "상품 등록은 로그인 후 이용 가능합니다.");
            return "redirect:/user/login";
        }

        // 로그인 한 경우 → sellerId 주입
        product.setSellerId(sellerId);

        // 기본 상태값 (예: 1=ACTIVE)
        if (product.getStatusId() == 0) {
            product.setStatusId(1);
        }

        int id = productService.registerProduct(product);
        ra.addFlashAttribute("msg", "상품 등록 완료 #" + id);
        return "redirect:/product/myproduct";
    }
    
    
    @GetMapping("/detail/{productId}")
    public String getProductDetail(@PathVariable int productId, Model model) {
    System.out.println("product" + productService.getProductDetail(productId).toString());
     model.addAttribute("product", productService.getProductDetail(productId));
      return "product/detail";
    }
      
      @GetMapping("/user/scroll")
      public String scrollList() {
        return "user/scroll";
    }


    @GetMapping("/myproduct")
    public String myProduct(HttpSession session, RedirectAttributes ra, Model model){
        Integer sellerId = (Integer) session.getAttribute("userId");
        if (sellerId == null) {
            ra.addFlashAttribute("error", "상품 관리는 로그인 후 이용 가능합니다.");
            return "redirect:/user/login";
        }
        List<ProductDTO> items = productService.selectMyProducts(sellerId);
        System.out.println(items.toString());
        model.addAttribute("items", items);

        return "product/myproduct";
    }


}
