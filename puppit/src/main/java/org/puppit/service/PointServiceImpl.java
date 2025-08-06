package org.puppit.service;


import org.json.JSONObject;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;


@Service
public class PointServiceImpl implements PointService {



  @Override
  public boolean verifyAndCharge(String impUid, int amount, String userId) {
      try {
          RestTemplate restTemplate = new RestTemplate();

          // 1. Access Token 발급
          String tokenUrl = "https://api.iamport.kr/users/getToken";
          JSONObject tokenRequest = new JSONObject();
          tokenRequest.put("imp_key", "6476012641127056");
          tokenRequest.put("imp_secret", "jWMkNZgQACQQBtWCd3eZbnYoZcY8H7wu7zPuhdJoLv1p3fT6piqF2ZwbJzODHyU73IZv43KNEzF3TSyC");

          HttpHeaders tokenHeaders = new HttpHeaders();
          tokenHeaders.setContentType(MediaType.APPLICATION_JSON);
          HttpEntity<String> tokenEntity = new HttpEntity<>(tokenRequest.toString(), tokenHeaders);

          ResponseEntity<String> tokenResponse = restTemplate.postForEntity(tokenUrl, tokenEntity, String.class);
          JSONObject tokenJson = new JSONObject(tokenResponse.getBody());
          String accessToken = tokenJson.getJSONObject("response").getString("access_token");

          // 2. imp_uid로 결제 정보 조회
          String paymentUrl = "https://api.iamport.kr/payments/" + impUid;
          HttpHeaders paymentHeaders = new HttpHeaders();
          paymentHeaders.setBearerAuth(accessToken);
          HttpEntity<Void> paymentEntity = new HttpEntity<>(paymentHeaders);

          ResponseEntity<String> paymentResponse = restTemplate.exchange(paymentUrl, HttpMethod.GET, paymentEntity, String.class);
          JSONObject paymentJson = new JSONObject(paymentResponse.getBody());
          JSONObject paymentData = paymentJson.getJSONObject("response");

          int paidAmount = paymentData.getInt("amount");

          if (paidAmount == amount) {

              return true;
          } else {
              return false;
          }

      } catch (Exception e) {
          e.printStackTrace();
          return false;
      }
  }
}