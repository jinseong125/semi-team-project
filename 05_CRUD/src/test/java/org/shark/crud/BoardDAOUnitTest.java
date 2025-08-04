package org.shark.crud;

import static org.junit.Assert.*;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.shark.crud.model.dto.BoardDTO;
import org.shark.crud.model.dto.UserDTO;
import org.shark.crud.repository.BoardDAO;
import org.shark.crud.repository.UserDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class) // JUnit4를 이용한 테스트
@ContextConfiguration(locations = {// Test 시 필요한 빈 (Bean)을 찾을 장소를 작성 (root-context.xml 의 4개 빈과 UserDAO 빈)
    "file:src/main/webapp/WEB-INF/spring/root-context.xml"// root-context.xml
   ,"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"}) // @Repository는 component-scan이 있어야 동작하므로 추가
public class BoardDAOUnitTest {

  @Autowired // 테스트 코드는 DI를 필드 주입 방식으로 처리한다
  private BoardDAO boardDAO;
  
  @Test
  public void 목록_가져오기_테스트() {
   // assertEquals(3,boardDAO.getBoards().size());
    assertEquals("나는 상어", boardDAO.getBoards().get(0).getTitle());
  }

  @Test
  public void 신규등록_테스트() {
    UserDTO user = UserDTO.builder()
                        .uid(3)
                        .build();
    
    BoardDTO board = BoardDTO.builder()
                           .title("테스트제목")
                           .content("테스트내용")
                           .user(user)
                           .build();
    assertEquals(1, boardDAO.insertBoard(board));
  }
  
}
