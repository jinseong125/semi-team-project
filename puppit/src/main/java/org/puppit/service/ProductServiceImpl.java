package org.puppit.service;

import lombok.RequiredArgsConstructor;
import org.puppit.model.dto.*;
import org.puppit.repository.ProductDAO;
import org.puppit.util.PageUtil;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class ProductServiceImpl implements ProductService {

    private final ProductDAO productDAO;
    private final S3Service s3Service;
    private final PageUtil pageUtil;

    /** 상품 등록 */
    @Transactional
    @Override
    public int registerProduct(ProductDTO productDTO, List<MultipartFile> imageFiles) {
        productDAO.insertProduct(productDTO);

        if (productDTO.getStatusId() == null) {
            productDTO.setStatusId(1);
        }

        for (int i = 0; i < imageFiles.size(); i++) {
            MultipartFile file = imageFiles.get(i);
            if (!file.isEmpty()) {
                try {
                    Map<String, String> uploadResult = s3Service.uploadFile(file, "product");

                    ProductImageDTO imageDTO = new ProductImageDTO();
                    imageDTO.setProductId(productDTO.getProductId());
                    imageDTO.setImageUrl(uploadResult.get("fileUrl"));
                    imageDTO.setImageKey(uploadResult.get("fileName"));
                    imageDTO.setThumbnail(i == 0);

                    productDAO.insertProductImage(imageDTO);

                    if (i == 0) {
                        productDAO.updateThumbnail(productDTO.getProductId(), imageDTO.getImageId());
                    }
                } catch (IOException e) {
                    throw new RuntimeException("이미지 업로드 실패", e);
                }
            }
        }

        return productDTO.getProductId();
    }

    /** 상품 등록 폼 데이터 */
    @Override
    public Map<String, List<?>> getProductFormData() {
        Map<String, List<?>> map = new HashMap<>();
        map.put("categories", productDAO.getCategories());
        map.put("locations", productDAO.getLocations());
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

    @Override
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


    @Override
    public List<ProductSearchDTO> searchByNew(String searchName) {
        return productDAO.searchByNew(searchName);
    }

    @Override
    public Map<String, Object> getProducts(PageDTO dto, HttpServletRequest request) {
        String sort = request.getParameter("sort");
        if (sort == null || !(sort.equalsIgnoreCase("ASC") || sort.equalsIgnoreCase("DESC"))) {
            sort = "DESC";
        }
        int itemCount = productDAO.getProductCount();
        dto.setItemCount(itemCount);

        List<ProductDTO> products = productDAO.getProductList(); // 단순화

        return Map.of("products", products, "pageCount", dto.getPageCount());
    }

    @Override
    public List<String> getAutoComplete(String keyword) {
        return productDAO.getAutoComplete(keyword);
    }

    /** 상품 수정 */
    @Transactional
    @Override
    public int updateProduct(ProductDTO productDTO, List<Integer> deleteImageIds, List<MultipartFile> imageFiles) throws Exception {
        productDAO.updateProduct(productDTO);

        if (deleteImageIds != null && !deleteImageIds.isEmpty()) {
            for (Integer imageId : deleteImageIds) {
                ProductImageDTO img = productDAO.getImageById(imageId);
                if (img != null) {
                    s3Service.deleteFile(img.getImageUrl());
                    productDAO.deleteImage(imageId);
                }
            }
        }

        if (imageFiles != null && !imageFiles.isEmpty()) {
            for (MultipartFile file : imageFiles) {
                if (!file.isEmpty()) {
                    Map<String, String> uploadResult = s3Service.uploadFile(file, "product");

                    ProductImageDTO imageDTO = new ProductImageDTO();
                    imageDTO.setProductId(productDTO.getProductId());
                    imageDTO.setImageUrl(uploadResult.get("fileUrl"));
                    imageDTO.setImageKey(uploadResult.get("fileName"));
                    imageDTO.setThumbnail(false);

                    productDAO.insertProductImage(imageDTO);
                }
            }
        }

        List<ProductImageDTO> remainImages = productDAO.getProductImages(productDTO.getProductId());
        if (!remainImages.isEmpty()) {
            productDAO.unsetAllThumbnails(productDTO.getProductId());
            productDAO.setThumbnail(remainImages.get(0).getImageId());
            productDAO.updateThumbnail(productDTO.getProductId(), remainImages.get(0).getImageId());
        }

        return productDTO.getProductId();
    }

    @Override
    public int deleteProduct(Integer productId) {
        return productDAO.deleteProduct(productId);
    }

    @Override
    public List<ProductDTO> getProductsByCategory(String categoryName) {
      return productDAO.getProductsByCategory(categoryName);
    }


    public ProductImageDTO getThumbnailImage(Integer productId) {
        return productDAO.getThumbnailImage(productId);
    }

    @Override
    public List<ProductImageDTO> getProductImages(Integer productId) {
        return productDAO.getProductImages(productId);

    }

    @Transactional
    @Override
    public void setThumbnail(Integer productId, Integer imageId) {
        productDAO.unsetAllThumbnails(productId);
        productDAO.setThumbnail(imageId);
        productDAO.updateThumbnail(productId, imageId);
    }

    @Transactional
    @Override
    public void deleteImage(Integer imageId) throws Exception {
        ProductImageDTO img = productDAO.getImageById(imageId);
        if (img != null) {
            s3Service.deleteFile(img.getImageUrl());
            productDAO.deleteImage(imageId);
        }
    }

    @Override
    public List<ProductDTO> mainProducts() {
      return productDAO.mainProducts();
    }

    @Override
    public ProductDTO detailProducts(Integer productId) {
      return productDAO.detailProducts(productId);
    }
}
