package org.puppit.service;

import java.util.List;

import org.puppit.model.dto.ProductAndImageDTO;
import org.puppit.model.dto.ProductDTO;
import org.puppit.model.dto.ProductImageDTO;
import org.puppit.model.dto.WishListDTO;
import org.puppit.repository.WishListDAO;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class WishListService {
  
  private final WishListDAO wishListDAO;
  
  public List<WishListDTO> getWishListByUserId(Integer userId) {
    return wishListDAO.getWishListByUserId(userId);
  }
  public ProductDTO getProductById(Integer productId) {
    return wishListDAO.getProductById(productId);
  }
  public boolean deleteWishListByUserAndProduct(Integer userId, Integer productId) {
    return wishListDAO.deleteWishListByUserAndProduct(userId, productId) == 1;
  }
  public boolean deleteAllWishListByUser(Integer userId) {
    return wishListDAO.deleteAllWishListByUser(userId) == 1;
  }
  public ProductImageDTO getProductImage(Integer productId) {
    return wishListDAO.getProductImage(productId);
  }
  public ProductAndImageDTO getProductAndImage(Integer productId) {
    return wishListDAO.getProductAndImage(productId);
  }

}
