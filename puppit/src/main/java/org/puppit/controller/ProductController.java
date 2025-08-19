package org.puppit.controller;


import org.puppit.model.dto.ProductDTO;
import org.puppit.model.dto.ProductImageDTO;
import org.puppit.model.dto.ProductSearchDTO;
import org.puppit.repository.ProductDAO;
import org.puppit.service.ProductService;
import org.puppit.service.S3Service;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lombok.RequiredArgsConstructor;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
@RequestMapping("/product")
public class ProductController {

    private final ProductService productService;
    private final S3Service s3Service;
    private final ProductDAO productDAO;

    /** 상품 등록 폼 */
    @GetMapping("/new")
    public String newForm(ProductDTO productDTO, Model model, HttpSession session,
                          RedirectAttributes ra) {
        Object attr = session.getAttribute("sessionMap");
        Map<String, Object> map = (Map<String, Object>)attr;
        Integer sellerId = (Integer) map.get("userId");


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
    public String create(@ModelAttribute ProductDTO product,
                         @RequestParam("imageFiles") List<MultipartFile> imageFiles,
                         @RequestParam(value="attachment", required=false) MultipartFile attachment,    
                         HttpSession session,
                         RedirectAttributes ra) {

        // 1. 로그인 사용자 확인
        Object attr = session.getAttribute("sessionMap");
        Map<String, Object> map = (Map<String, Object>)attr;
        Integer sellerId = (Integer) map.get("userId");

        if (sellerId == null) {
            ra.addFlashAttribute("error", "상품 등록은 로그인 후 이용 가능합니다.");
            return "redirect:/user/login";
        }

        // 2. 판매자 ID 설정
        product.setSellerId(sellerId);

        // 3. 상태 기본값 지정 (판매중)
        if (product.getStatusId() == null) {
            product.setStatusId(1);
        }

        try {
            // 4. 서비스 호출 (상품 + 이미지 등록)
            productService.registerProduct(product, imageFiles);

            // 5. 성공 메시지
            ra.addFlashAttribute("success", "상품이 등록되었습니다.");
            return "redirect:/product/myproduct";

        } catch (RuntimeException e) {
            // 6. 실패 처리
            ra.addFlashAttribute("error", "상품 등록 중 오류가 발생했습니다: " + e.getMessage());
            return "redirect:/product/new";
        }
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

    @GetMapping("/product/scroll")
    public String scrollList() {
        return "product/scroll";
    }

    @GetMapping("/myproduct")
    public String myProduct(HttpSession session, RedirectAttributes ra, Model model) {


        Object attr = session.getAttribute("sessionMap");
        if (attr == null) {
            ra.addFlashAttribute("error", "상품 관리는 로그인 후 이용 가능합니다.");
            return "redirect:/user/login";
        }

        Map<String, Object> map = (Map<String, Object>)attr;
        Integer sellerId = (Integer) map.get("userId");

        List<ProductDTO> items = productService.selectMyProducts(sellerId);
        model.addAttribute("items", items);

        return "product/myproduct";
    }

    
    @GetMapping(value = "/search", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public List<ProductSearchDTO> searchByNew(@RequestParam String searchName) {
        return productService.searchByNew(searchName);
    }

    @GetMapping(value = "/autocomplete", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public List<String> getAutoComplete(@RequestParam("keyword") String keyword) {
      return productService.getAutoComplete(keyword);
    }


    @GetMapping("/edit/{productId}")
    public String editForm(@PathVariable("productId") Integer productId,
                           HttpSession session,
                           RedirectAttributes ra,
                           Model model) {

        // 로그인 확인
        Object attr = session.getAttribute("sessionMap");

        Map<String, Object> map = (Map<String, Object>) attr;
        Integer sellerId = (Integer) map.get("userId");

        // 상품 가져오기
        ProductDTO product = productService.getProductById(productId);

        // 기본 데이터 세팅
        model.addAttribute("product", product);
        model.addAttribute("categories", productDAO.getCategories());
        model.addAttribute("locations", productDAO.getLocations());
        model.addAttribute("conditions", productDAO.getConditions());
        model.addAttribute("images", productDAO.getProductImages(productId));


        return "product/edit";
    }

    // 상품 수정 처리
    @PostMapping("/update")
    public String update(@ModelAttribute ProductDTO product,
                         @RequestParam(value="imageFiles", required=false) List<MultipartFile> imageFiles,
                         HttpSession session,
                         RedirectAttributes ra) {

        // 로그인 확인
        Map<String,Object> map = (Map<String,Object>) session.getAttribute("sessionMap");
        Integer sellerId = (Integer) map.get("userId");

        // 상품 주인 확인
        ProductDTO productDTO = productService.getProductById(product.getProductId());
        if (productDTO == null || !productDTO.getSellerId().equals(sellerId)) {
            ra.addFlashAttribute("error", "권한이 없습니다.");
            return "redirect:/product/myproduct";
        }


        try {

            product.setSellerId(sellerId);

            productService.updateProduct(product, imageFiles);
            ra.addFlashAttribute("success", "상품이 수정되었습니다.");
        } catch (RuntimeException e) {
            ra.addFlashAttribute("error", "상품 수정 실패: " + e.getMessage());
        }

        // 수정 후 → 상세 페이지로 이동
        return "redirect:/product/detail/" + product.getProductId();
    }

    @PostMapping("/delete")
    public String delete(@RequestParam("productId") Integer productId,
                         HttpSession session,
                         RedirectAttributes ra) {


        Map<String,Object> map = (Map<String,Object>) session.getAttribute("sessionMap");
        Integer sellerId = (Integer) map.get("userId");

        /*
         * ProductDTO productDTO = productService.getProductById(productId); if
         * (productDTO == null || !productDTO.getSellerId().equals(sellerId)) {
         * ra.addFlashAttribute("error", "권한이 없습니다."); return
         * "redirect:/product/myproduct"; }
         */



        int result = productService.deleteProduct(productId);
        if (result > 0) {
            ra.addFlashAttribute("success", "상품이 삭제되었습니다.");
        } else {
            ra.addFlashAttribute("error", "상품 삭제 실패 ");
        }


        return "redirect:/product/myproduct";
    }






}