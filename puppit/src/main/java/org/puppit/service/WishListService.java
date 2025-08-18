package org.puppit.service;

import java.util.List;

import org.puppit.model.dto.ProductDTO;
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

}
