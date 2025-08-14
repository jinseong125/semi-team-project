package org.puppit.service;

import lombok.RequiredArgsConstructor;
import org.puppit.model.dto.ProductDTO;
import org.puppit.model.dto.ProductImageDTO;
import org.puppit.model.dto.ProductSearchDTO;
import org.puppit.model.dto.ScrollResponseDTO;
import org.puppit.repository.ProductDAO;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

@Service
@RequiredArgsConstructor
public class ProductServiceImpl implements ProductService {

    private final ProductDAO productDAO;
    private final S3Service s3Service;

    @Transactional
    @Override
    public int registerProduct(ProductDTO productDTO, List<MultipartFile> imageFiles) {
        // 1. 상품 저장
        productDAO.insertProduct(productDTO);

        // 상태값 기본 지정 (null이면 1=판매중)
        if (productDTO.getStatusId() == null) {
            productDTO.setStatusId(1);
        }

        // 2. 이미지 저장 (첫 번째 이미지만 썸네일)
        for (int i = 0; i < imageFiles.size(); i++) {
            MultipartFile file = imageFiles.get(i);
            if (!file.isEmpty()) {
                try {
                    // S3 업로드
                    Map<String, String> uploadResult = s3Service.uploadFile(file, "product");

                    ProductImageDTO imageDTO = new ProductImageDTO();
                    imageDTO.setProductId(productDTO.getProductId());
                    imageDTO.setImageUrl(uploadResult.get("fileUrl"));   // ✅ S3Service 반환 key와 일치
                    imageDTO.setImageKey(uploadResult.get("fileName"));  // ✅ S3Service 반환 key와 일치
                    imageDTO.setThumbnail(i == 0); // 첫 번째 이미지만 썸네일

                    // DB 저장
                    productDAO.insertProductImage(imageDTO);

                } catch (IOException e) {
                    throw new RuntimeException("이미지 업로드 실패", e);
                }
            }
        }

        return productDTO.getProductId();
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

//    @Transactional(readOnly = true)
//    public ScrollResponseDTO<ProductDTO> getProductsForScroll(Long cursor, int size) {
//      List<ProductDTO> list = productDAO.findProductsAfter(cursor, size);
//
//      ScrollResponseDTO<ProductDTO> responseDTO = new ScrollResponseDTO<ProductDTO>();
//      responseDTO.setItem(list);
//
//      if(list.isEmpty()) {
//        responseDTO.setHasMore(false);
//        responseDTO.setNextCursor(null);
//        return responseDTO;
//      }
//
//      Long next = list.get(list.size() - 1).getProductId().longValue();
//      responseDTO.setNextCursor(next);
//
//      responseDTO.setHasMore(list.size() == size);
//        return responseDTO;
//
//    }

    @Override
    public List<ProductSearchDTO> searchByNew(String searchName) {
      return productDAO.searchByNew(searchName);
    }

    @Override
    public List<ProductDTO> getProducts(int offset, int size) {
      
      return productDAO.selectProducts(offset, size);
    }


}