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
      Map<String, Object> params = new HashMap<>();         //----- MyBatis濡� �뿬�윭 媛쒖쓽 �뙆�씪誘명꽣瑜� �븳 踰덉뿉 蹂대궡湲� �쐞�빐�꽌 HashMap�궗�슜.
      params.put("cursor", cursor);
      params.put("size", size);
      return sqlSession.selectList("product.findProductsAfter", params);
    }
    
     public List<ProductSearchDTO> searchByNew(String searchName) {
       return sqlSession.selectList("search.searchByNew", searchName);
     }

     public List<ProductDTO> selectProducts(int offset, int size) {
       Map<String, Object> params = new HashMap<>();
       params.put("offset", offset);
       params.put("size", size);
       System.out.println("offset: " + params.get("offset"));
       System.out.println("size: " + params.get("size"));
       return sqlSession.selectList("product.selectProducts", params);
   }
     
     public List<ProductDTO> getProducts(Map<String, Object> map) {
    	
         System.out.println("offset: " + map.get("offset"));
         System.out.println("size: " + map.get("size"));
    	    return sqlSession.selectList("product.getProducts", map);
    	  }
    	  
	  public Integer getProductCount() {
	    return sqlSession.selectOne("product.getProductCount");
	  }


    public int updateProduct(ProductDTO productDTO) {
        return sqlSession.update("product.updateProduct", productDTO);
    }

    public int deleteProduct(Integer productId) {
        return sqlSession.delete("product.deleteProduct", Map.of("productId", productId));
    }



}
