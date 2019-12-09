# DML

# 1.
# EMPNO : 8000 , ENAME : 최수만, JOB : 방장, MGR : 7902
# HIREDATE : NOW(), SAL : 2000, COMM : 100 , DEPTNO : 40
INSERT INTO emp(empno, ename,job, mgr, hiredate, sal, comm, deptno) 
VALUES(8001,'최수만','방장',7902, CURDATE(),2000, 100, 40);

DELETE 
DESC emp;

# 2.
# UPDATE, 할 때 조건문을 달지 않으면 전체다 update된다.
UPDATE member
SET addr = '미국'
WHERE num = 4;

# 3.
# DELETE
DELETE
FROM member
WHERE num = 5; #primary key 반드시 지울 것(안 그러면 여러개가 지워질수도)

# 4.
# TCL
# 회원 --> 물품구입
# [주문(INSERT) - 결제(INSERT) - 배송(INSERT) - 재고(UPDATE,INSERT) - SMS(INSERT)]
# 어디 하나가 문제가 발생하면 주문부터 SMS까지 다같이 작동해야한다.
# 이걸 하나로 묶어서 관리하는 것
# 하나 하나를 operation(작업단위)이라 하고 operation들을 하나로 묶는 것이 Transaction
# 하나하나의 작업단위들을 묶어서 하나의 작업단위인 것처럼 전체를 처리하거나 처리하지 않거나 한다.
# commit(끝까지 성공하면), roll back(하나라도 실패시)
# 시작과 끝이 존재
# But 속도가 느려진다. 하지만 속도보다 위험관리가 우선이기에 하나로 묶는 것

SELECT @@AUTOCOMMIT; # 1이면 INSERT를 못함.

# 껐다 다시키면 1로 다시 setting (MariaDB 특징)
SET AUTOCOMMIT = 0; 
# 이렇게 해서 select로 결과값을 출력해도 들어간게 아니다.
# 허상으로 들어간 것이다.
# console로 확인해보면 없다.
INSERT INTO member(num, NAME, addr) VALUES(10, 'aa', 'aaa');
UPDATE member SET NAME='bb' WHERE num = 1;
# commit 하는 순간 위에 모든 것이 실제 실행
COMMIT; # 끝을 알림


# java에서 sql 실행시
# select 성공, 실패를 출력
# insert, delete, update는 적용(갱신)된 행 개수를 return