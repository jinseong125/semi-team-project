package org.puppit.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.util.Base64;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

import org.springframework.stereotype.Component;

/*
 * java.security.MessageDigest
 * 
 * 1. 자바에서 제공하는 메시지 다이제스트(해시) 알고리즘 기능을 수행하는 핵심 클래스입니다. 
 * 2. 임의 길이의 데이터를 입력받아 고정 길이의 해시 값(메시지 다이제스트)을 생성하는 데 사용됩니다. 대표적으로 MD5, SHA-1, SHA-256 등의 해시 알고리즘을 지원합니다.
 * 3. 주요 특징
 *   1) 입력 데이터를 해시 함수 알고리즘으로 변환해 고정된 크기의 해시 결과(바이트 배열)를 만듭니다.
 *   2) 단방향 해시로, 원본 데이터를 복원할 수 없습니다.
 *   3) 데이터 무결성 검증, 비밀번호 저장, 디지털 서명 등의 보안 용도에서 많이 활용됩니다.
 *   4) getInstance(String algorithm) 메소드로 특정 알고리즘 객체를 가져옵니다.
 *   5) update(byte[] input) 메소드로 데이터를 여러 번 나눠서 처리할 수 있습니다.
 *   6) digest() 메소드로 최종 해시 값을 바이트 배열로 얻습니다.
 */

@Component  //----- Spring Container에 SecureUtil 타입의 빈을 등록합니다.
public class SecureUtil {

  //----- Salt 생성 메소드 (16 바이트)
  public byte[] getSalt() {
    SecureRandom random = new SecureRandom();
    byte[] salt = new byte[16];
    random.nextBytes(salt);
    return salt;
  }
  
  //----- SHA256 해시값 반환 (Salt 적용 없음)
  public String hashSHA256(final String password) {    
    try {
      MessageDigest md = MessageDigest.getInstance("SHA-256");  //----- SHA-256 단방향 암호화 알고리즘 (MD5, SHA-1, SHA-512, SHA3-256 등 가능)
      byte[] hash = md.digest(password.getBytes());
      StringBuilder hexString = new StringBuilder();
      for (byte b : hash) {
        hexString.append(String.format("%02x", b));
      }
      return hexString.toString();
    } catch (NoSuchAlgorithmException e) {
      throw new RuntimeException(e);
    }
  }

  //----- SHA256 해시값 반환 (Salt 적용)
  public String hashSHA256(final String password, final byte[] salt) {    
    try {
      MessageDigest md = MessageDigest.getInstance("SHA-256");  //----- SHA-256 단방향 암호화 알고리즘 (MD5, SHA-1, SHA-512, SHA3-256 등 가능)
      md.update(salt);  //----- Salt 적용
      byte[] hash = md.digest(password.getBytes());
      StringBuilder hexString = new StringBuilder();
      for (byte b : hash) {
        hexString.append(String.format("%02x", b));
      }
      return hexString.toString();
    } catch (NoSuchAlgorithmException e) {
      throw new RuntimeException(e);
    }
  }
  
  //----- 반복횟수가 많은 KDF(Key Derivation Function) 방식을 이용해 더 안전한 비밀번호 해싱 가능(PBKDF2 알고리즘 사용 예시)
  public String hashPBKDF2(final String password, final byte[] salt) {
    // 반복 횟수와 해시 길이 설정 (추천: 65536, 256bit)
    try {
      int iterations = 65536;
      int keyLength = 256;
      PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, iterations, keyLength);
      SecretKeyFactory skf = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
      byte[] hash = skf.generateSecret(spec).getEncoded();
      return Base64.getEncoder().encodeToString(hash);
    } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
      throw new RuntimeException(e);
    }
  }
  
}
