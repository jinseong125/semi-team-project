package org.puppit.repository;

import org.apache.ibatis.session.SqlSession;
import org.puppit.model.dto.*;
import org.springframework.stereotype.Repository;

import lombok.RequiredArgsConstructor;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Repository
@RequiredArgsConstructor
public class ProductDAO {



    private final SqlSession sqlSession;


    public int insertProduct(org.puppit.model.dto.ProductDTO productDTO) {
        sqlSession.insert( "product.insertProduct", productDTO);

        return productDTO.getProductId();
    }

    public List<CategoryDTO> getCategories(){
        return sqlSession.selectList("product.getCategories");
    }

    public List<LocationDTO> getLocations(){
        return sqlSession.selectList("product.getLocations");
    }

    public List<ConditionDTO> getConditions(){
        return sqlSession.selectList("product.getConditions");
    }


    public int insertProductImage(org.puppit.model.dto.ProductImageDTO productImageDTO) {

        return   sqlSession.insert("product.insertProductImage", productImageDTO);
    }
    public List<ProductImageDTO> getProductImages(int productId){
        return sqlSession.selectList("product.getProductImages", productId);
    }

    public ProductDTO getProductById(Integer productId){
        return sqlSession.selectOne("product.getProductById", productId);
    }

    public List<ProductDTO> getProductList() {
      return sqlSession.selectList("product.getProductList");

    }

    public ProductDTO getProductDetail(Integer productId) {
      return sqlSession.selectOne("product.getProductDetail", productId);
    }

    public List<ProductDTO> selectMyProducts(Integer sellerId){
        return sqlSession.selectList("product.selectMyProducts", sellerId);
    }
    
    public List<ProductDTO> findProductsAfter(Long cursor, int size) {
      Map<String, Object> params = new HashMap<>();         //----- MyBatis로 여러 개의 파라미터를 한 번에 보내기 위해서 HashMap사용.
      params.put("cursor", cursor);
      params.put("size", size);
      return sqlSession.selectList("product.findProductsAfter", params);
    }
    /*
     * public List<ProductDTO> searchByNew(String q, String cursorCreatedAt,Long
     * cursorid, int size) { Map<String, Object> params = new HashMap<String,
     * Object>(); params.put("q", q); params.put("cursorCreatedAt",
     * cursorCreatedAt); params.put("cursorCreatedAt") }
     */
}
