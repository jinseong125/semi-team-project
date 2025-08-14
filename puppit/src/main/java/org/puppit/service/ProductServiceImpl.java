package org.puppit.service;

import lombok.RequiredArgsConstructor;
import org.puppit.model.dto.ProductDTO;
import org.puppit.model.dto.ScrollResponseDTO;
import org.puppit.repository.ProductDAO;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

@Service
@RequiredArgsConstructor
public class ProductServiceImpl implements ProductService {

    private final ProductDAO productDAO;

    @Transactional
    @Override
    public int registerProduct(ProductDTO productDTO) {

        if (productDTO == null) {
            throw new IllegalArgumentException("요청 데이터가 비어 있습니다.");
        }
        if (productDTO.getProductName() == null || productDTO.getProductName().isBlank()) {
            throw new IllegalArgumentException("상품명은 필수입니다.");
        }
        if (productDTO.getProductDescription() == null || productDTO.getProductDescription().isBlank()) {
            throw new IllegalArgumentException("상품 설명은 필수입니다.");
        }
        if (productDTO.getProductPrice() < 0) {
            throw new IllegalArgumentException("가격은 음수가 될 수 없습니다.");
        }
        // 로그인 연동된 경우: Controller에서 sellerId 세팅해옴
        if (productDTO.getSellerId() <= 0) {
            throw new IllegalArgumentException("판매자 정보가 유효하지 않습니다.");
        }

        return productDAO.insertProduct(productDTO); // useGeneratedKeys로 PK 세팅됨
    }

    // org.puppit.service.ProductServiceImpl

    @Override
    public Map<String, List<?>> getProductFormData() {
        Map<String, List<?>> map = new HashMap<>();
        map.put("categories", productDAO.getCategories());
        map.put("locations",  productDAO.getLocations());
        map.put("conditions", productDAO.getConditions());
        return map;
    }

    @Override
    public ProductDTO getProductById(Integer productId) {
        return productDAO.getProductById(productId);
    }

    @Override
    public List<ProductDTO> selectMyProducts(Integer sellerId) {
        return productDAO.selectMyProducts(sellerId);
    }

    public List<ProductDTO> getProductList() {
      return productDAO.getProductList();
    }

    @Override
    public ProductDTO getProductDetail(Integer productId) {
      return productDAO.getProductDetail(productId);
    }

    @Override
    public Map<String, Object> getUsers(ProductDTO dto, HttpServletRequest request) {
      return null;
    }

    @Transactional(readOnly = true)
    public ScrollResponseDTO<ProductDTO> getProductsForScroll(Long cursor, int size) {
      List<ProductDTO> list = productDAO.findProductsAfter(cursor, size);
      
      ScrollResponseDTO<ProductDTO> responseDTO = new ScrollResponseDTO<ProductDTO>();
      responseDTO.setItem(list);
      
      if(list.isEmpty()) {
        responseDTO.setHasMore(false);
        responseDTO.setNextCursor(null);
        return responseDTO;
      }
      
      Long next = list.get(list.size() - 1).getProductId().longValue();
      responseDTO.setNextCursor(next);
        
      responseDTO.setHasMore(list.size() == size);
        return responseDTO;
      
    }


}