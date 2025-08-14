package org.puppit.service;


import org.puppit.model.dto.ProductDTO;
import org.puppit.model.dto.ScrollResponseDTO;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

public interface ProductService {
    /** 상품 등록 후 생성된 productId 반환 */
    int registerProduct(ProductDTO productDTO);
    
    ScrollResponseDTO<ProductDTO> getProductsForScroll(Long cursor, int size);

    // org.puppit.service.ProductService
    public Map<String, List<?>> getProductFormData();
    
    public List<ProductDTO> getProductList();
    
    public ProductDTO getProductDetail(Integer productId);
    

    public ProductDTO getProductById(Integer productId);

    
    public Map<String, Object> getUsers(ProductDTO dto, HttpServletRequest request);


    public List<ProductDTO> selectMyProducts(Integer sellerId);

   

}
