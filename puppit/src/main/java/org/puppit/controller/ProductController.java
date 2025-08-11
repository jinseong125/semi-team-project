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

@Controller
@RequiredArgsConstructor
@RequestMapping("/product")
public class ProductController {

    private final ProductService productService;

    /** 상품 등록 폼 */
    @GetMapping("/new")
    public String newForm(ProductDTO productDTO , Model model) {

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
                         RedirectAttributes ra) {

        product.setSellerId(1); // <-- DB에 user_id=1 이 실제로 있어야 함

        // 기본 상태값 (예: 1=ACTIVE)
        if (product.getStatusId() == 0) {
            product.setStatusId(1);
        }

        int id = productService.registerProduct(product);
        ra.addFlashAttribute("msg", "상품 등록 완료 #" + id);
        return "redirect:/product/list";
    }




}
