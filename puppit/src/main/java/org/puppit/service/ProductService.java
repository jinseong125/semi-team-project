package org.puppit.service;

import org.puppit.model.dto.PageDTO;
import org.puppit.model.dto.ProductDTO;
import org.puppit.model.dto.ProductSearchDTO;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

public interface ProductService {
    /** �긽�뭹 �벑濡� �썑 �깮�꽦�맂 productId 諛섑솚 */
    int registerProduct(ProductDTO productDTO, List<MultipartFile> imageFiles);

    // org.puppit.service.ProductService
    public Map<String, List<?>> getProductFormData();
    
    public List<ProductDTO> getProductList();
    
    public ProductDTO getProductDetail(Integer productId);
    

    public ProductDTO getProductById(Integer productId);

    
    public Map<String, Object> getUsers(ProductDTO dto, HttpServletRequest request);


    public List<ProductDTO> selectMyProducts(Integer sellerId);

    public List<ProductSearchDTO> searchByNew(String searchName);
    
    Map<String, Object> getProducts(PageDTO dto, HttpServletRequest request);
    

}
