package org.puppit.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class IamPortService {
    private final String API_KEY;
    private final String API_SECRET;
    private final RestTemplate restTemplate = new RestTemplate();

    public IamPortService(@Value("${iamport.api.key}") String API_KEY,
                          @Value("${iamport.api.secret}") String API_SECRET) {
      this.API_KEY = API_KEY;
      this.API_SECRET = API_SECRET;
    }
    // 1. 아임포트 access_token 발급
    @SuppressWarnings("unchecked")
    private String getAccessToken() {
        String url = "https://api.iamport.kr/users/getToken";

        Map<String, String> body = new HashMap<>();
        body.put("imp_key", API_KEY);
        body.put("imp_secret", API_SECRET);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<Map<String, String>> entity = new HttpEntity<>(body, headers);

        ResponseEntity<Map> response = restTemplate.postForEntity(url, entity, Map.class);

        Map responseBody = response.getBody();
        Map<String, Object> responseData = (Map<String, Object>) responseBody.get("response");

        return (String) responseData.get("access_token");
    }

    // 2. 결제정보 조회 (imp_uid로)
    @SuppressWarnings("unchecked")
    public int getAmountByImpUid(String impUid) {
      String accessToken = getAccessToken();

      HttpHeaders headers = new HttpHeaders();
      headers.set("Authorization", accessToken);

      HttpEntity<Void> entity = new HttpEntity<>(headers);

      String url = "https://api.iamport.kr/payments/" + impUid;

      ResponseEntity<Map> response = restTemplate.exchange(url, HttpMethod.GET, entity, Map.class);
      Map responseBody = response.getBody();

      if (responseBody.get("response") == null) {
          return -1;
      }

      Map<String, Object> responseData = (Map<String, Object>) responseBody.get("response");

      Object amountObj = responseData.get("amount");
      if (amountObj instanceof Number) {
          return ((Number) amountObj).intValue();  
      } else {
          return -1;
      }
  }

}
