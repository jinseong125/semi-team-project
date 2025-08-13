<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Insert title here</title>
<style>
  .user {
  box-sizing: border-box;
  width: 1024px;
  height: 120px;
  margin: 10px auto;
  border: 1px solid gray;
  cursor: pointer;
  text-align: center;
  line-height: 120px;
  }
	  .user > span {
    color: tomato;
    display: inline-block;
    box-sizing: border-box;
  }
  .user > span:nth-of-type(n) { width: 19.5%; }
</style>
</head>
<body>
  
  <h1 style="text-align: center;">회원 목록</h1>
  
  <div style="text-align: center; margin-bottom: 20px;">
    <button id="sort-desc" type="button" style="margin-right: 10px;">최신순</button>
    <button id="sort-asc" type="button">과거순</button>
  </div>
  
  <div id="user-list"></div>
  <div id="scroll-anchor"></div> <!-- 감지 대상 요소 -->
  
  <div id="loading" style="display:none;">로딩중...</div>
  <div id="end" style="display:none;">모든 게시물을 다 불러왔습니다.</div>
  
  <script>
  
    let page = 1;
    let pageCount = 0;
    let isLoading = false;
    let isEnd = false;
    let sort = "DESC";  // 디폴트로 DESC 설정
    
    //----- 회원 리스트 렌더링
    function renderUserList(users) {
      const userList = document.getElementById("user-list");
      users.forEach(user => {
        const div = document.createElement("div");
        div.className = "user";
        div.dataset.uid = user.uid;
        div.innerHTML = `
          <span>\${user.lastName}</span>
          <span>\${user.firstName}</span>
          <span>\${user.email}</span>
          <span>\${user.gender}</span>
          <span>\${user.ipAddress}</span>
        `;
        userList.appendChild(div);
      });
    }
    
    //----- 로딩/종료 메시지 표시 제어
    function showLoading(show) {
      document.getElementById("loading").style.display = show ? "block" : "none";
    }
    function showEndMessage(show) {
      document.getElementById("end").style.display = show ? "block" : "none";
    }
    
    //----- 데이터 요청
    async function fetchUserList() {
      //***** 로딩중 또는 마지막 페이지 도달 시 요청 중지
      if (isLoading || isEnd) 
        return;
      //***** 데이터 가져오기 전에는 로딩중으로 표시
      isLoading = true;
      showLoading(true);
      //***** 데이터 가져오기
      try {
        const response = await fetch(`${contextPath}/api/user/scroll/list?page=\${page}&sort=\${sort}`);
        if (!response.ok)
          throw new Error(response.status);
        const jsonData = await response.json();
        pageCount = jsonData.pageCount || 0;
        const users = jsonData.users;
        if (users && users.length > 0) {  // 회원 리스트를 가져왔다면 화면에 렌더링
          renderUserList(users);
        }
        if (page >= pageCount) {  // 마지막 페이지 도달 처리
          isEnd = true;
          showEndMessage(true);
          observer.disconnect(); // 더 이상 관찰 중단
        }
      } catch (error) {
        alert("목록 요청 실패: " + error.message);
      } finally {
        isLoading = false;
        showLoading(false);
      }
    }
    
    //----- 정렬 변경 함수
    function changeSort(newSort) {
      // 이미 선택된 정렬이면 무시함
      if (sort === newSort)
        return;
      // 정렬 변경
      sort = newSort;
      // 상태 초기화
      page = 1;
      pageCount = 0;
      isLoading = false;
      isEnd = false;
      document.getElementById("user-list").innerHTML = "";
      showEndMessage(false);
      showLoading(false);
      // 목록 가져오기
      fetchUserList();
    }
    
    //----- 정렬 버튼 이벤트
    document.getElementById("sort-desc").addEventListener("click", function(e){
      changeSort("DESC");
    });
    document.getElementById("sort-asc").addEventListener("click", function(e){
      changeSort("ASC");
    });
    
 

	//----- Intersection Observer 콜백함수
    const callback = (entries, observer) => {
      entries.forEach(entry => {
        if (entry.isIntersecting && !isLoading && !isEnd) {
          page++;
          fetchUserList();
        }
      });
    };
    
    
    const observer = new IntersectionObserver(callback, {
      root: null, //---------- 뷰포트 기준
      rootMargin: "50px", //-- 뷰포트 바깥 50px 내에서 미리 로딩 가능
      threshold: 0  //-------- 조금이라도 보이면 callback 실행
    });
    
    // 초기화 함수
    function initInfiniteScroll() {
      page = 1;
      pageCount = 0;
      isLoading = false;
      isEnd = false;
    
      document.getElementById("user-list").innerHTML = "";
      showEndMessage(false);
      showLoading(false);
    
      fetchUserList();
    
      // 감지 대상 요소를 옵저버에 등록
      const anchor = document.getElementById("scroll-anchor");
      observer.observe(anchor);
    }
    
    // DOM 준비 시 초기화
    window.addEventListener("DOMContentLoaded", initInfiniteScroll);
    
  </script>

</body>
</html>
