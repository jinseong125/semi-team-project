package org.puppit.repository;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.puppit.model.dto.ProductDTO;
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

}
