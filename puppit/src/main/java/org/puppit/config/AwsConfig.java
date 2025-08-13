package org.puppit.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import software.amazon.awssdk.auth.credentials.DefaultCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;

/** S3Client 빈 생성 */
@Configuration
public class AwsConfig {

    @Value("${aws.region}")  // rootxml에 있는 bucket region
    private String region;

    @Bean
    public S3Client s3Client() {
        return S3Client.builder()
                .region(Region.of(region))  //s3 region
                .credentialsProvider(DefaultCredentialsProvider.create()) // ~/.aws/credentials 등 자동 탐색   // IAM PW
                .build();
    }
}
