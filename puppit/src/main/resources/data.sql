INSERT INTO tbl_user(email, password, nickname) VALUES
  ("sunflower@gmail.com", "sunflower" , "sunflower"),
  ("tiger@gmail.com", "tiger","tiger"),
  ("shark@gmail.com" ,"shark", "shark");

INSERT INTO tbl_board(uid, title, content) VALUES
  (1, "나는 해바라기", "나는 해바라기입니다."),
  (2, "나는 호랑이", "나는 호랑이입니다."),
  (3, "나는 상어", "나는 상어입니다.");
  
COMMIT;