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
    private int productId;
    private int locationId;
    private int categoryId;
    private int sellerId;
    private int conditionId;
    private int statusId;
    private String productName;
    private int productPrice;
    private String productDescription;
    private Timestamp productCreatedAt;
    private Timestamp productUpdatedAt;
}
