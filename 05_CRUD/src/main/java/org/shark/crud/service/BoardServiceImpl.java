package org.shark.crud.service;

import java.util.List;

import org.shark.crud.model.dto.BoardDTO;
import org.shark.crud.repository.BoardDAO;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;


@RequiredArgsConstructor
@Service  // 서비스 레벨에서 사용하는 @Component
public class BoardServiceImpl implements BoardService {
  
private final BoardDAO boardDAO;
  
  @Override
  public List<BoardDTO> findAllBoards() {
    return boardDAO.getBoards();
  }

  @Override
  public Integer getBoardCount() {
    return boardDAO.getBoardCount();
  }
  
  @Override
  public BoardDTO findBoardById(Integer bid) {
    return boardDAO.getBoardById(bid);
  }

  @Override
  public boolean addBoard(BoardDTO board) {
    return boardDAO.insertBoard(board) == 1;
  }

  @Override
  public boolean modifyBoard(BoardDTO board) {
    return boardDAO.updateBoard(board) == 1;
  }

  @Override
  public boolean removeBoard(Integer bid) {
    return boardDAO.deleteBoardById(bid) == 1;
  }

}
