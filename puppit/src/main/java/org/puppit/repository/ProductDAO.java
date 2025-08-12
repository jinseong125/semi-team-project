package org.puppit.repository;

import org.apache.ibatis.session.SqlSession;
import org.puppit.model.dto.CategoryDTO;
import org.puppit.model.dto.ConditionDTO;
import org.puppit.model.dto.LocationDTO;
import org.puppit.model.dto.ProductDTO;
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

    public ProductDTO getProductById(Integer productId){
        return sqlSession.selectOne("product.getProductById", productId);
    }


}
