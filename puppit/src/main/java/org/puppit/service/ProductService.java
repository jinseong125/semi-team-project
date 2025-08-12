package org.puppit.service;

import org.puppit.model.dto.ProductDTO;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

public interface ProductService {
    /** 상품 등록 후 생성된 productId 반환 */
    int registerProduct(ProductDTO productDTO);

    // org.puppit.service.ProductService
    public Map<String, List<?>> getProductFormData();
    
    public List<ProductDTO> getProductList();
    
    public ProductDTO getProductDetail(Integer productId);
    
    public Map<String, Object> getScrollUsers(ProductDTO dto, HttpServletRequest request);

    public ProductDTO getProductById(Integer productId);
}
