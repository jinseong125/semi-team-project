<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>결제 화면</title>
<script src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
<script>
  const IMP = window.IMP;
  IMP.init("imp85811517"); 

  function requestPay() {
    const uid = document.getElementById("uid").value;
    const amount = document.getElementById("amount").value;

    if (!uid || !amount) {
      alert("유저 ID와 금액을 입력하세요.");
      return;
    }

    IMP.request_pay({
      pg: "html5_inicis",       
      pay_method: "card",
      name: "포인트 충전",
      amount: amount,
      buyer_name: "테스트유저",
      buyer_email: "test@example.com"
    }, function (rsp) {
      if (rsp.success) {
        // 결제 성공 → 서버에 imp_uid 전송하여 검증 요청
        fetch("${contextPath}/payment/verify", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            imp_uid: rsp.imp_uid,
            uid: uid
          })
        })
        .then(res => res.json())
        .then(result => {
          if (result.success) {
            alert("충전 성공!");
          } else {
            alert("결제는 성공했지만 검증에 실패했습니다.");
          }
        });
      } else {
        alert("결제 실패: " + rsp.error_msg);
      }
    });
  }
</script>
</head>
<body>
  <h1>결제 화면</h1>
  <label>충전할 유저ID:</label>
  <input type="text" id="uid">
  <br>
  <label>충전할 포인트:</label>
  <input type="text" id="amount">
  <h2>충전할 포인트 선택</h2>
  <select>
    <option>100</option>
    <option>200</option>
    <option>500</option>
    <option>1000</option>
  </select>
  <button type="button" onclick="requestPay()">결제하기</button>
</body>
</html>
