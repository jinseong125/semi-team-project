package org.puppit.service;

import org.puppit.model.dto.ProductDTO;

import java.util.List;
import java.util.Map;

public interface ProductService {
    /** 상품 등록 후 생성된 productId 반환 */
    int registerProduct(ProductDTO productDTO);

    // org.puppit.service.ProductService
    public Map<String, List<?>> getProductFormData();

    public ProductDTO getProductById(Integer productId);
}
