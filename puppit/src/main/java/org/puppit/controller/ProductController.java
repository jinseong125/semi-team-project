package org.puppit.controller;

import lombok.RequiredArgsConstructor;
import org.puppit.model.dto.ProductDTO;
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
    public String newForm(ProductDTO productDTO, Model model, HttpSession session,
                          RedirectAttributes ra) {
        Integer sellerId = (Integer) session.getAttribute("userId");
        if (sellerId == null) {
            ra.addFlashAttribute("error", "상품 등록은 로그인 후 이용 가능합니다.");
            return "redirect:/user/login";
        }

        // 셀렉트 박스 데이터
        var formData = productService.getProductFormData();
        model.addAttribute("categories", formData.get("categories"));
        model.addAttribute("locations", formData.get("locations"));
        model.addAttribute("conditions", formData.get("conditions"));
        model.addAttribute("product", new ProductDTO());

        return "product/productForm";
    }

    @PostMapping("/new")
    public String create(@ModelAttribute ProductDTO productDTO,
                         HttpSession session,
                         RedirectAttributes ra) {

        Integer sellerId = (Integer) session.getAttribute("userId");
        if (sellerId == null) {
            ra.addFlashAttribute("error", "상품 등록은 로그인 후 이용 가능합니다.");
            return "redirect:/user/login";
        }

        // 로그인 한 경우 → sellerId 주입
        productDTO.setSellerId(sellerId);

        // 기본 상태값 (예: 1=ACTIVE)
        // 수정: null 체크 후 비교
        if (productDTO.getStatusId() == null || productDTO.getStatusId() == 0) { // 수정
            productDTO.setStatusId(1);
        }

        // 수정: productService가 null인지 방어
        if (productService == null) { // 수정
            ra.addFlashAttribute("error", "상품 등록 서비스가 준비되지 않았습니다.");
            return "redirect:/product/new";
        }

        int id = productService.registerProduct(productDTO);

        ra.addFlashAttribute("msg", "상품 등록 완료 #" + id);
        return "redirect:/product/myproduct";
    }

    @GetMapping("/detail/{productId}")
    public String getProductDetail(@PathVariable int productId, Model model) {
        var productDetail = productService.getProductDetail(productId); // 수정
        if (productDetail == null) { // 수정
            model.addAttribute("error", "해당 상품을 찾을 수 없습니다.");
            return "error/404";
        }
        System.out.println("product: " + productDetail.toString());
        model.addAttribute("product", productDetail);
        return "product/detail";
    }

    @GetMapping("/user/scroll")
    public String scrollList() {
        return "user/scroll";
    }

    @GetMapping("/myproduct")
    public String myProduct(HttpSession session, RedirectAttributes ra, Model model) {
        Integer sellerId = (Integer) session.getAttribute("userId");

        if (sellerId == null) {
            ra.addFlashAttribute("error", "상품 관리는 로그인 후 이용 가능합니다.");
            return "redirect:/user/login";
        }
        List<ProductDTO> items = productService.selectMyProducts(sellerId);
        model.addAttribute("items", items);

        return "product/myproduct";
    }
}
