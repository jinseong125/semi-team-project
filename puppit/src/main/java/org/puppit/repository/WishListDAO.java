package org.puppit.repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.puppit.model.dto.ProductAndImageDTO;
import org.puppit.model.dto.ProductDTO;
import org.puppit.model.dto.ProductImageDTO;
import org.puppit.model.dto.WishListDTO;
import org.springframework.stereotype.Repository;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class WishListDAO {
  
  private final SqlSessionTemplate sst;
  
  public List<WishListDTO> getWishListByUserId(Integer userId) {
    return sst.selectList("mybatis.mapper.wishListMapper.getWishListByUserId", userId);
  }
  public ProductDTO getProductById(Integer productId) {
    return sst.selectOne("mybatis.mapper.wishListMapper.getProductById", productId);
  }
  public Integer deleteWishListByUserAndProduct(Integer userId, Integer productId) {
    Map<String, Object> map = new HashMap<>();
    
    map.put("userId", userId);
    map.put("productId", productId);
    
    return sst.delete("mybatis.mapper.wishListMapper.deleteWishListByUserAndProduct", map);
  }
  public Integer deleteAllWishListByUser(Integer userId) {
    return sst.delete("mybatis.mapper.wishListMapper.deleteAllWishListByUser", userId);
  }
  public ProductImageDTO getProductImage(Integer productId) {
    return sst.selectOne("mybatis.mapper.wishListMapper.getProductImage", productId);
  }
  public ProductAndImageDTO getProductAndImage(Integer productId) {
    return sst.selectOne("mybatis.mapper.wishListMapper.getProductAndImage", productId);
  }

}
