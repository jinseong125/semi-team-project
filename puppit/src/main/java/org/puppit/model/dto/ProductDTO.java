package org.puppit.model.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.sql.Timestamp;


@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class ProductDTO {


    private Integer productId;
    private Integer locationId;
    private Integer categoryId;
    private Integer sellerId;
    private Integer conditionId;
    private Integer statusId;
    private String productName;
    private Integer productPrice;
    private String productDescription;
    private Timestamp productCreatedAt;
    private Timestamp productUpdatedAt;
    private int totalCount;



    private CategoryDTO      category;
    private ProductStatusDTO  status;
    private ProductImageDTO   thumbnail;

    
    

}
