package org.shark.crud.service;

import java.util.List;

import org.shark.crud.model.dto.BoardDTO;

// 주요 네이밍 : get, find, create, add, update, modify, delete, remove 등

public interface BoardService {
  List<BoardDTO> findAllBoards();
  Integer getBoardCount();
  BoardDTO findBoardById(Integer bid);
  boolean addBoard(BoardDTO board);
  boolean modifyBoard(BoardDTO board);
  boolean removeBoard(Integer bid);
}
