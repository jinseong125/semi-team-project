package org.puppit.repository;

import org.apache.ibatis.session.SqlSession;
import org.puppit.model.dto.*;
import org.springframework.stereotype.Repository;

import lombok.RequiredArgsConstructor;

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
        sqlSession.insert("product.insertProductImage", productImageDTO);
        return productImageDTO.getImageId();
    }
    public List<ProductImageDTO> getProductImages(int productId){
        return sqlSession.selectList("product.getProductImages", productId);
    }

    public ProductDTO getProductById(Integer productId){
        return sqlSession.selectOne("product.getProductById");
    }

    public List<ProductDTO> getProductList() {
      System.out.println("productList: " + sqlSession.selectList("product.getProductList"));
      return sqlSession.selectList("product.getProductList");

    }

    public ProductDTO getProductDetail(Integer productId) {
      return sqlSession.selectOne("product.getProductDetail", productId);
    }

}
