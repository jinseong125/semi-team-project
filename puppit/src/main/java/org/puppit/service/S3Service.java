package org.puppit.service;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.ObjectMetadata;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class S3Service {

    private final AmazonS3 amazonS3;

    public Map<String, String> uploadFile(MultipartFile file, String folderName) throws IOException {
        String bucketName = "jscode-upload-images" ;// 환경변수에 버킷명

        String fileName = folderName + "/" + UUID.randomUUID() + "_" + file.getOriginalFilename();

        ObjectMetadata metadata = new ObjectMetadata();
        metadata.setContentType(file.getContentType());
        metadata.setContentLength(file.getSize());

        amazonS3.putObject(bucketName, fileName, file.getInputStream(), metadata);

        String fileUrl = amazonS3.getUrl(bucketName, fileName).toString();

        Map<String, String> result = new HashMap<>();
        result.put("fileName", fileName);
        result.put("fileUrl", fileUrl);

        return result;
    }

}

