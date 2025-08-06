package org.puppit.controller;

import org.puppit.service.PointService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class PointController {

    @Autowired
    private PointService pointService;

    @GetMapping("/payment/form")
    public String paymentForm() {
        return "payment/paymentForm";
    }

    @PostMapping("/payment/verify")
    public String verifyPayment(@RequestParam("imp_uid") String impUid,
                                @RequestParam("amount") int amount,
                                Model model) {
        String userId = "testuser";
        boolean success = pointService.verifyAndCharge(impUid, amount, userId);
        model.addAttribute("success", success);
        model.addAttribute("amount", amount);
        return "payment/paymentResult";
    }
}

