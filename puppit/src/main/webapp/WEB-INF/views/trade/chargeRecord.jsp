<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="../layout/header.jsp" />

<style>
:root {
  --bg: #fff;
  --card: #fff;
  --text: #111;
  --muted: #8a8f98;
  --primary: #4f86ff;
  --line: #dfe3ea;
  --shadow: 0 8px 24px rgba(0, 0, 0, .08);
}

body {
  margin: 0;
  background: var(--bg);
  color: var(--text);
  font-family: system-ui, -apple-system, "Segoe UI", Roboto, "Noto Sans KR", sans-serif;
}

.wrap {
  max-width: 1200px;
  margin: 24px auto;
  padding: 0 20px 24px;
}

.header-row {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  margin-bottom: 14px;
}

.title {
  font-size: 22px;
  font-weight: 800;
}

.count {
  color: var(--muted);
  font-size: 14px;
}

.card {
  background: var(--card);
  border: 1px solid var(--line);
  border-radius: 16px;
  box-shadow: var(--shadow);
  overflow: hidden;
}

.table {
  width: 100%;
  border-collapse: collapse;
}

.table thead th {
  text-align: left;
  padding: 14px 16px;
  font-size: 13px;
  color: var(--muted);
  background: #fafbfc;
  border-bottom: 1px solid var(--line);
  white-space: nowrap;
}

.table tbody td {
  padding: 14px 16px;
  border-bottom: 1px solid var(--line);
  font-size: 14px;
}

.table tbody tr:hover {
  background: #fcfdff;
}

.badge-amount {
  display: inline-block;
  padding: 6px 10px;
  border-radius: 999px;
  background: rgba(79, 134, 255, .08);
  border: 1px solid rgba(79, 134, 255, .25);
  font-weight: 800;
}

.mono {
  font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", monospace;
  letter-spacing: .2px;
}

.empty {
  padding: 28px 20px;
  text-align: center;
  color: var(--muted);
}
</style>

<div class="wrap">
  <div class="header-row">
    <div class="title">포인트 충전 내역</div>
    <div class="count">
      총 <strong>${fn:length(pointDTOs)}</strong>건
    </div>
  </div>

  <div class="card">
    <c:choose>
      <c:when test="${not empty pointDTOs}">
        <table class="table">
          <thead>
            <tr>
              <th>충전 시간</th>
              <th>주문번호</th>
              <th>충전 금액</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="pointDTO" items="${pointDTOs}">
              <tr>
                <!-- 충전 시간 -->
                <td>
                  <fmt:formatDate value="${pointDTO.pointChargeChargedAt}" pattern="yyyy-MM-dd HH:mm" />
                </td>
                <!-- 주문번호 -->
                <td class="mono">
                  ${pointDTO.pointChargeOrderNumber}
                </td>
                <!-- 충전 금액 -->
                <td>
                  <span class="badge-amount">
                    <fmt:formatNumber value="${pointDTO.pointChargeAmount}" type="number" /> P
                  </span>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </c:when>
      <c:otherwise>
        <div class="empty">아직 충전 내역이 없습니다.</div>
      </c:otherwise>
    </c:choose>
  </div>
</div>

</body>
</html>
