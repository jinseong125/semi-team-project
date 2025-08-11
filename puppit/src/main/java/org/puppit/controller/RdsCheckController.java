package org.puppit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@Controller
public class RdsCheckController {

    private final DataSource dataSource;

    public RdsCheckController(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @ResponseBody
    @GetMapping("/rds-check")
    public String rdsCheck() {
        String sql = "SELECT message FROM rds_test_check LIMIT 1";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getString(1); // "This is RDS"
            } else {
                return "NO ROW";
            }
        } catch (Exception e) {
            return "DB FAIL: " + e.getMessage();
        }
    }
}