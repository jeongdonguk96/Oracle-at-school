-- 1. 테이블 생성하기
CREATE TABLE ex1_1(
    column1 CHAR(10), -- 10개의 고정길이라 3글자를 추가해도 7글자 공간이 남음
    column2 VARCHAR2(10), -- 가변길이라 길이를 10개로 생성해도 추가한 ]만큼만 저장하고 공백 없음
    column3 NVARCHAR2(10),
    column4 NUMBER
);

-- 2. 데이터 타입
-- 2-1 문자형 타입
-- (1) 고정길이, 가변길이
INSERT INTO ex1_1(column1, column2) VALUES('abc', 'abc');

-- 저장내용 확인
SELECT column1, LENGTH(column1), column1, LENGTH(column2)
    FROM ex1_1;
    
-- (2) byte, char 비교
-- 오라클에서는 한글 1자가 3,byte
CREATE TABLE ex1_2(
    column1 VARCHAR2(3), -- 3byte 할당
    column2 VARCHAR2(3 byte),
    column3 VARCHAR2(3 char) -- 3 char 할당 (한글로 3글자)
);

-- 영문저장 예
INSERT INTO ex1_2 VALUES('abc','abc','abc');
SELECT column1, LENGTH(column1),
      column2, LENGTH(column2),
      column3, LENGTH(column3)
      FROM ex1_2;
      
-- 한글저장 틀린 예
INSERT INTO ex1_2 VALUES('홍길동','홍길동','홍길동'); -- 한글은 1글자당 1byte라 오류가 남
-- 한글저장 옳은 예
INSERT INTO ex1_2(column3) VALUES('홍길동');
-- 저장내용 확인                                    -- LENGTH는 길이 불러냄
SELECT column3, LENGTH(column3), LENGTHB(column3)  -- LENGTHB는 바이트단위로 길이 불러냄
 FROM ex1_2;

-- 2-2 숫자형 데이터 타입
CREATE TABLE ex1_3(
  col_int INTEGER,
  col_dec DECIMAL,
  col_num NUMBER -- 모두 38이 기본이고 NUMBER형을 띄기 때문에 NUMBER로 퉁쳐서 사용하는 게 좋다
);

desc ex1_3;

-- 2-3 날짜형 데이터 타입
CREATE TABLE ex1_4(
  col_date DATE, -- 년월일 저장
  col_timestamp TIMESTAMP -- 년월일분초 저장
);

INSERT INTO ex1_4 VALUES(SYSDATE, SYSTIMESTAMP);
SELECT * FROM ex1_4;

-- 3. 제약조건
-- 3-1 NOT NULL
CREATE TABLE ex1_5(
  col_null VARCHAR2(10),
  col_not_null VARCHAR2(10) NOT NULL -- 반드시 데이터를 넣어야 하는 컬럼 (NULL이 있을 수 없음)
);

INSERT INTO ex1_5 VALUES('aa', ''); -- NOT NULL 컬럼에 데이터를 넣지 않아 오류 발생
INSERT INTO ex1_5 VALUES('aa', 'bb');

-- 3-2 UNIQUE
CREATE TABLE ex1_6(
  col_unique_null VARCHAR2(10) UNIQUE,
  col_unique_not_null VARCHAR2(10) UNIQUE NOT NULL,
  col_unique VARCHAR2(10),
  CONSTRAINT col_cons_unique UNIQUE(col_unique) -- UNIQUE컬럼을 별도로 지정
);

INSERT INTO ex1_6 VALUES('aa','aa','aa');
INSERT INTO ex1_6 VALUES('aa','aa','aa'); -- 제약조건에 위배돼 저장되지 않음
-- NULL 입력 확인
INSERT INTO ex1_6 VALUES('','bb','bb'); -- NULL은 중복처리가 안됨
INSERT INTO ex1_6 VALUES('','cc','cc');
SELECT * FROM ex1_6;
-- 제약조건 확인방법
SELECT constraint_name, constraint_type, search_condition,table_name
  FROM user_constraints -- 제약조건을 관리하는 테이블
WHERE table_name='EX1_6';

-- 3-3 PRIMARY KEY 
CREATE TABLE ex1_7(
  col1 VARCHAR2(10) PRIMARY KEY, -- PRIMARY KEY에는 NULL도, 중복도 들어갈 수 없다
  col2 VARCHAR2(10)
);

INSERT INTO ex1_7 VALUES ('aa', 'aa');
INSERT INTO ex1_7 VALUES ('aa', 'bb');
SELECT * FROM ex1_7;

-- (1) CONSTRAINT구문을 이용해 기본키 생성 (UNIQUE도 동일)
CREATE TABLE ex1_8(
  col1 VARCHAR2(10),
  col2 VARCHAR2(10),
  CONSTRAINT pk_col1 PRIMARY KEY(col1)
);
SELECT * FROM ex1_8;

-- (2) 여러 개의 기본키 지정
CREATE TABLE multiple_key(
  emp_id number,
  name VARCHAR2(30),
  age number(5),
  CONSTRAINT pk_multi PRIMARY KEY(emp_id, name)
);
INSERT INTO multiple_key VALUES (1, '철수', 25);
INSERT INTO multiple_key VALUES (1, '철수', 30); -- id와 name이 중복돼 무결성 제약조건에 위배
INSERT INTO multiple_key VALUES (1, '영희', 25); -- id는 같아도 name이 달라 제약조건에 부합

-- 3-4 FOREIGN KEY
-- (1) 고객 데이터 테이블
CREATE TABLE ex_customer(
  cid NUMBER PRIMARY KEY,
  name VARCHAR2(30),
  age NUMBER(5)
);
-- (2) 고객 주문 테이블
CREATE TABLE ex_orders(
  order_id NUMBER PRIMARY KEY,
  order_date DATE,
  cid NUMBER, -- 단순히 열 생성해서 외래키가 생성되지 않고 따로 만들어줘야함
  amount NUMBER,
  CONSTRAINT fk_customer_id FOREIGN KEY(cid)
    REFERENCES ex_customer(cid)
);
INSERT INTO ex_orders VALUES (1, SYSDATE, 100, 10000); -- cid에 대한 부모키가 없어서 제약조건 위배
-- 외래키가 존재하는 테이블에 데이터 넣기
INSERT INTO ex_customer VALUES (100, '홍길동', 20); -- ex_customer에 데이터 INSERT
INSERT INTO ex_orders VALUES (1, SYSDATE, 100, 10000);  

-- 2개의 테이블 확인
SELECT * FROM ex_orders;
SELECT * FROM ex_customer;

-- 3-5 CHECK (입력할 수 있는 값의 범위를 지정)
CREATE TABLE ex1_9(
  num1 NUMBER,
  gender VARCHAR2(10),
  CONSTRAINT check1 CHECK(num1 BETWEEN 1 and 9),
  CONSTRAINT check2 CHECK(gender IN ('M', 'W'))
);
INSERT INTO ex1_9 VALUES(1, 'W');
INSERT INTO ex1_9 VALUES(0, 'W'); -- num1의 CHECK 제약조건 위배

-- 3-6 DEFAULT (컬럼의 기본값을 지정)
CREATE TABLE ex1_10(
  col1 VARCHAR2(10) NOT NULL,
  col2 VARCHAR2(10),
  create_date DATE DEFAULT SYSDATE -- 현재일자를 테이블에 자동으로 생성
);
INSERT INTO ex1_10(col_1, col2) VALUES ('aa', 'bb');
SELECT * FROM ex1_10;

-- 4. 테이블 변경
-- 4-1 테이블 삭제
DROP TABLE ex1_10; -- 테이블 삭제
DROP TABLE ex1_10 CASCADE CONSTRAINTS; -- 테이블 및 제약조건 삭제
-- 4-2 컬럼명 변겅
ALTER TABLE ex1_10 RENAME COLUMN col1 TO col_1; -- ALTER와 RENAME COLUMN
-- 4-3 컬럼타입 변경
ALTER TABLE ex1_10 MODIFY col2 VARCHAR2(30); -- ALTER와 MODIFY
-- 4-4 컬럼 추가
ALTER TABLE ex1_10 ADD col3 VARCHAR2(30); -- ALTER와 ADD
-- 4-5 컬럼 삭제
ALTER TABLE ex1_10 DROP COLUMN col3; -- ALTER와 DROP COLUMN
-- 4-6 제약조건(기본키) 추가
ALTER TABLE ex1_10 ADD CONSTRAINT pk_ex1_10 PRIMARY KEY(col_1); -- ADD CONSTRAINT - PRIMARY KEY
-- 4-7 제약조건(기본키) 삭제
ALTER TABLE ex1_10 DROP CONSTRAINT pk_ex1_10; -- DROP CONSTRAINT
-- 4-8 테이블 복사
CREATE TABLE ex1_11 AS SELECT col_1, col2 FROM ex1_10;

-- 5. VIEW
CREATE OR REPLACE VIEW cust_view AS
  SELECT cust_id, cust_name, cust_gender, cust_city
    FROM customers;
SELECT * FROM cust_view;
SELECT * FROM user_views; -- 뷰를 관리하는 테이블
-- 5-1 뷰 삭제
DROP VIEW cust_view;

-- 6. INDEX
-- 6-1 인덱스 생성
DELETE FROM ex1_10; -- 행 내용 삭제
commit;
CREATE UNIQUE INDEX idx_ex1_10 ON ex1_10(col_1); -- UNIQUE INDEX ON
INSERT INTO ex1_10(col_1, col2) VALUES('aa','bb');
INSERT INTO ex1_10(col_1, col2) VALUES('bb','gg'); 
INSERT INTO ex1_10(col_1, col2) VALUES('cc','qq');
INSERT INTO ex1_10(col_1, col2) VALUES('dd','ww');
INSERT INTO ex1_10(col_1, col2) VALUES('ee','zz');
commit;
-- 인덱스를 사용하는 조회
SELECT * FROM ex1_10 ORDER BY col_1; -- idx_ex1_10 인덱스를 사용
-- 인덱스 생성 확인
SELECT * FROM user_indexes -- 인덱스를 관리하는 테이블
  WHERE table_name='EX1=10';
-- 인덱스 삭제
DROP INDEX idx_ex1_10;

-- 7. SYNONYM
-- 7-1 private 시노님 생성 (channels테이블의 private 시노님 생성)
CREATE OR REPLACE SYNONYM syn_channel FOR channels; -- private 생략가능(기본이 private)
SELECT * FROM syn_channel; -- 생성한 시노님 사용
-- 7-2 public 시노님 생성
CREATE OR REPLACE PUBLIC SYNONYM syn_channel2 FOR channels;
-- public 시노님에 대한 select권한 부여
GRANT SELECT ON syn_channel2 TO PUBLIC;
-- 시노님 생성 확인
SELECT * FROM ALL_SYNONYMS
  WHERE TABLE_NAME ='CHANNELS'; -- 시노님을 관리하는 테이블
-- 시노님 삭제
DROP SYNONYM syn_channel;

-- 8. SEQUENCE
-- 8.1 시퀀스 생성
CREATE SEQUENCE my_seq
INCREMENT BY 1
START WITH 1
MINVALUE 1
MAXVALUE 1000
NOCYCLE
NOCACHE;
-- 8.2 시퀀스 사용
INSERT INTO ex1_9(num1) VALUES (my_seq.NEXTVAL);
-- 8.3 시퀀스 삭제
DROP SEQUENCE my_seq;

-- 9. 파티션 테이블
-- 테이블 스페이스 생성 (선택사항)
CREATE TABLESPACE test_tbs1 DATAFILE'D:\OracleDB\TEST_TBS1.DBF'
  SIZE 10M AUTOEXTEND ON NEXT 5M;
CREATE TABLESPACE test_tbs2 DATAFILE'D:\OracleDB\TEST_TBS2.DBF'
  SIZE 10M AUTOEXTEND ON NEXT 5M;
CREATE TABLESPACE test_tbs3 DATAFILE'D:\OracleDB\TEST_TBS3.DBF'
  SIZE 10M AUTOEXTEND ON NEXT 5M;
CREATE TABLESPACE test_tbs4 DATAFILE'D:\OracleDB\TEST_TBS4.DBF'
  SIZE 10M AUTOEXTEND ON NEXT 5M;
  
-- 9-2 RANGE 파티션 테이블 생성 ( 범위로 묶는 파티션테이블)
CREATE TABLE mypart(
  my_no NUMBER,
  my_year NUMBER NOT NULL,
  my_month NUMBER NOT NULL,
  my_day NUMBER NOT NULL,
  my_value NUMBER NOT NULL
)
PARTITION BY RANGE(my_year, my_month, my_day) -- 년월일 3개를 기준으로 테이블을 나눔
(
  PARTITION my_q1 VALUES LESS THAN(2019, 07, 01) TABLESPACE TEST_TBS1,
  PARTITION my_q2 VALUES LESS THAN(2020, 01, 01) TABLESPACE TEST_TBS2,
  PARTITION my_q3 VALUES LESS THAN(2020, 07, 01) TABLESPACE TEST_TBS3
);
-- 파티션 테이블에 데이터 추가
INSERT INTO mypart VALUES(1, 2019, 01, 03, 00);
INSERT INTO mypart VALUES(2, 2020, 05, 03, 00);
INSERT INTO mypart VALUES(3, 2020, 01, 03, 00);
INSERT INTO mypart VALUES(4, 2019, 06, 03, 00);
INSERT INTO mypart VALUES(5, 2020, 11, 13, 00);
INSERT INTO mypart VALUES(6, 2020, 06, 30, 00);
INSERT INTO mypart VALUES(7, 2019, 08, 21, 00);
commit;

SELECT * FROM mypart WHERE my_year='2019'; -- 기존 방식으로 읽기

SELECT * FROM mypart PARTITION(my_q1); -- 파티션으로 원하는 테이블을 묶어 읽기
SELECT * FROM mypart PARTITION(my_q2);
SELECT * FROM mypart PARTITION(my_q3);

-- 9-2 LIST 파티션 테이블 생성 (리스트로 묶는 파티션테이블)
CREATE TABLE EMP_LIST_PT (
  EMP_NO NUMBER NOT NULL,
  ENAME VARCHAR2(20),
  JOB VARCHAR2(20),
  MGR NUMBER(4),
  HIREDATE DATE,
  SAL NUMBER(7,2),
  COMM NUMBER(7,2),
  DEPT_NO NUMBER(2)
)
PARTITION BY LIST(JOB)
(
  PARTITION EMP_LIST_PT1 VALUES ('MANAGER') TABLESPACE TEST_TBS1,
  PARTITION EMP_LIST_PT2 VALUES ('SALESMAN') TABLESPACE TEST_TBS2,
  PARTITION EMP_LIST_PT3 VALUES ('ANALYST') TABLESPACE TEST_TBS3,
  PARTITION EMP_LIST_PT4 VALUES ('PRESIDENT', 'CLERK') TABLESPACE TEST_TBS4
);

SELECT * FROM ALL_TAB_PARTITIONS -- 파티션을 관리하는 테이블
  WHERE TABLE_NAME = 'EMP_LIST_PT';

INSERT INTO emp_list_pt VALUES(1, 'SMITH',  'CLERK',     7902, SYSDATE,  800, NULL, 20);
INSERT INTO emp_list_pt VALUES(2, 'ALLEN',  'SALESMAN',  7698, SYSDATE, 1600,  300, 30);
INSERT INTO emp_list_pt VALUES(3, 'WARD',   'SALESMAN',  7698, SYSDATE, 1250,  500, 30);
INSERT INTO emp_list_pt VALUES(4, 'JONES',  'MANAGER',   7839, SYSDATE,  2975, NULL, 20);
INSERT INTO emp_list_pt VALUES(5, 'MARTIN', 'SALESMAN',  7698, SYSDATE, 1250, 1400, 30);
INSERT INTO emp_list_pt VALUES(6, 'BLAKE',  'MANAGER',   7839, SYSDATE,  2850, NULL, 30);
INSERT INTO emp_list_pt VALUES(7, 'CLARK',  'MANAGER',   7839, SYSDATE,  2450, NULL, 10);
INSERT INTO emp_list_pt VALUES(8, 'SCOTT',  'ANALYST',   7566, SYSDATE, 3000, NULL, 20);
INSERT INTO emp_list_pt VALUES(9, 'KING',   'PRESIDENT', NULL, SYSDATE, 5000, NULL, 10);
INSERT INTO emp_list_pt VALUES(10, 'TURNER', 'SALESMAN',  7698,SYSDATE,  1500,    0, 30);
INSERT INTO emp_list_pt VALUES(11, 'ADAMS', 'CLERK', 7788,SYSDATE,1100,NULL,20);
INSERT INTO emp_list_pt VALUES(12, 'JAMES',  'CLERK',     7698, SYSDATE,   950, NULL, 30);
INSERT INTO emp_list_pt VALUES(13, 'FORD',   'ANALYST',   7566, SYSDATE,  3000, NULL, 20);
INSERT INTO emp_list_pt VALUES(14, 'MILLER', 'CLERK',     7782,  SYSDATE, 1300, NULL, 10);
commit;
-- 전체 데이터 조회
SELECT * FROM emp_list_pt;
-- 특정 파티션에서 데이터 조회
SELECT * FROM emp_list_pt PARTITION(emp_list_pt1);
SELECT * FROM emp_list_pt PARTITION(emp_list_pt2);
SELECT * FROM emp_list_pt PARTITION(emp_list_pt3);
SELECT * FROM emp_list_pt PARTITION(emp_list_pt4);
-- 파티션 삭제
ALTER TABLE emp_list_pt DROP PARTITION emp_list_pt1;
ALTER TABLE emp_list_pt DROP PARTITION emp_list_pt2;
ALTER TABLE emp_list_pt DROP PARTITION emp_list_pt3;
ALTER TABLE emp_list_pt DROP PARTITION emp_list_pt4;
DROP TABLE emp_list_pt CASCADE CONSTRAINTS;

-- 8.1 시퀀스 생성
CREATE SEQUENCE orders_seq
INCREMENT BY 1
START WITH 1000
MINVALUE 1
MAXVALUE 99999999
NOCYCLE
NOCACHE;
