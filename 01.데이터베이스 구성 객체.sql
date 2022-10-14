-- 1. ���̺� �����ϱ�
CREATE TABLE ex1_1(
    column1 CHAR(10), -- 10���� �������̶� 3���ڸ� �߰��ص� 7���� ������ ����
    column2 VARCHAR2(10), -- �������̶� ���̸� 10���� �����ص� �߰��� ]��ŭ�� �����ϰ� ���� ����
    column3 NVARCHAR2(10),
    column4 NUMBER
);

-- 2. ������ Ÿ��
-- 2-1 ������ Ÿ��
-- (1) ��������, ��������
INSERT INTO ex1_1(column1, column2) VALUES('abc', 'abc');

-- ���峻�� Ȯ��
SELECT column1, LENGTH(column1), column1, LENGTH(column2)
    FROM ex1_1;
    
-- (2) byte, char ��
-- ����Ŭ������ �ѱ� 1�ڰ� 3,byte
CREATE TABLE ex1_2(
    column1 VARCHAR2(3), -- 3byte �Ҵ�
    column2 VARCHAR2(3 byte),
    column3 VARCHAR2(3 char) -- 3 char �Ҵ� (�ѱ۷� 3����)
);

-- �������� ��
INSERT INTO ex1_2 VALUES('abc','abc','abc');
SELECT column1, LENGTH(column1),
      column2, LENGTH(column2),
      column3, LENGTH(column3)
      FROM ex1_2;
      
-- �ѱ����� Ʋ�� ��
INSERT INTO ex1_2 VALUES('ȫ�浿','ȫ�浿','ȫ�浿'); -- �ѱ��� 1���ڴ� 1byte�� ������ ��
-- �ѱ����� ���� ��
INSERT INTO ex1_2(column3) VALUES('ȫ�浿');
-- ���峻�� Ȯ��                                    -- LENGTH�� ���� �ҷ���
SELECT column3, LENGTH(column3), LENGTHB(column3)  -- LENGTHB�� ����Ʈ������ ���� �ҷ���
 FROM ex1_2;

-- 2-2 ������ ������ Ÿ��
CREATE TABLE ex1_3(
  col_int INTEGER,
  col_dec DECIMAL,
  col_num NUMBER -- ��� 38�� �⺻�̰� NUMBER���� ��� ������ NUMBER�� ���ļ� ����ϴ� �� ����
);

desc ex1_3;

-- 2-3 ��¥�� ������ Ÿ��
CREATE TABLE ex1_4(
  col_date DATE, -- ����� ����
  col_timestamp TIMESTAMP -- ����Ϻ��� ����
);

INSERT INTO ex1_4 VALUES(SYSDATE, SYSTIMESTAMP);
SELECT * FROM ex1_4;

-- 3. ��������
-- 3-1 NOT NULL
CREATE TABLE ex1_5(
  col_null VARCHAR2(10),
  col_not_null VARCHAR2(10) NOT NULL -- �ݵ�� �����͸� �־�� �ϴ� �÷� (NULL�� ���� �� ����)
);

INSERT INTO ex1_5 VALUES('aa', ''); -- NOT NULL �÷��� �����͸� ���� �ʾ� ���� �߻�
INSERT INTO ex1_5 VALUES('aa', 'bb');

-- 3-2 UNIQUE
CREATE TABLE ex1_6(
  col_unique_null VARCHAR2(10) UNIQUE,
  col_unique_not_null VARCHAR2(10) UNIQUE NOT NULL,
  col_unique VARCHAR2(10),
  CONSTRAINT col_cons_unique UNIQUE(col_unique) -- UNIQUE�÷��� ������ ����
);

INSERT INTO ex1_6 VALUES('aa','aa','aa');
INSERT INTO ex1_6 VALUES('aa','aa','aa'); -- �������ǿ� ����� ������� ����
-- NULL �Է� Ȯ��
INSERT INTO ex1_6 VALUES('','bb','bb'); -- NULL�� �ߺ�ó���� �ȵ�
INSERT INTO ex1_6 VALUES('','cc','cc');
SELECT * FROM ex1_6;
-- �������� Ȯ�ι��
SELECT constraint_name, constraint_type, search_condition,table_name
  FROM user_constraints -- ���������� �����ϴ� ���̺�
WHERE table_name='EX1_6';

-- 3-3 PRIMARY KEY 
CREATE TABLE ex1_7(
  col1 VARCHAR2(10) PRIMARY KEY, -- PRIMARY KEY���� NULL��, �ߺ��� �� �� ����
  col2 VARCHAR2(10)
);

INSERT INTO ex1_7 VALUES ('aa', 'aa');
INSERT INTO ex1_7 VALUES ('aa', 'bb');
SELECT * FROM ex1_7;

-- (1) CONSTRAINT������ �̿��� �⺻Ű ���� (UNIQUE�� ����)
CREATE TABLE ex1_8(
  col1 VARCHAR2(10),
  col2 VARCHAR2(10),
  CONSTRAINT pk_col1 PRIMARY KEY(col1)
);
SELECT * FROM ex1_8;

-- (2) ���� ���� �⺻Ű ����
CREATE TABLE multiple_key(
  emp_id number,
  name VARCHAR2(30),
  age number(5),
  CONSTRAINT pk_multi PRIMARY KEY(emp_id, name)
);
INSERT INTO multiple_key VALUES (1, 'ö��', 25);
INSERT INTO multiple_key VALUES (1, 'ö��', 30); -- id�� name�� �ߺ��� ���Ἲ �������ǿ� ����
INSERT INTO multiple_key VALUES (1, '����', 25); -- id�� ���Ƶ� name�� �޶� �������ǿ� ����

-- 3-4 FOREIGN KEY
-- (1) �� ������ ���̺�
CREATE TABLE ex_customer(
  cid NUMBER PRIMARY KEY,
  name VARCHAR2(30),
  age NUMBER(5)
);
-- (2) �� �ֹ� ���̺�
CREATE TABLE ex_orders(
  order_id NUMBER PRIMARY KEY,
  order_date DATE,
  cid NUMBER, -- �ܼ��� �� �����ؼ� �ܷ�Ű�� �������� �ʰ� ���� ����������
  amount NUMBER,
  CONSTRAINT fk_customer_id FOREIGN KEY(cid)
    REFERENCES ex_customer(cid)
);
INSERT INTO ex_orders VALUES (1, SYSDATE, 100, 10000); -- cid�� ���� �θ�Ű�� ��� �������� ����
-- �ܷ�Ű�� �����ϴ� ���̺� ������ �ֱ�
INSERT INTO ex_customer VALUES (100, 'ȫ�浿', 20); -- ex_customer�� ������ INSERT
INSERT INTO ex_orders VALUES (1, SYSDATE, 100, 10000);  

-- 2���� ���̺� Ȯ��
SELECT * FROM ex_orders;
SELECT * FROM ex_customer;

-- 3-5 CHECK (�Է��� �� �ִ� ���� ������ ����)
CREATE TABLE ex1_9(
  num1 NUMBER,
  gender VARCHAR2(10),
  CONSTRAINT check1 CHECK(num1 BETWEEN 1 and 9),
  CONSTRAINT check2 CHECK(gender IN ('M', 'W'))
);
INSERT INTO ex1_9 VALUES(1, 'W');
INSERT INTO ex1_9 VALUES(0, 'W'); -- num1�� CHECK �������� ����

-- 3-6 DEFAULT (�÷��� �⺻���� ����)
CREATE TABLE ex1_10(
  col1 VARCHAR2(10) NOT NULL,
  col2 VARCHAR2(10),
  create_date DATE DEFAULT SYSDATE -- �������ڸ� ���̺� �ڵ����� ����
);
INSERT INTO ex1_10(col_1, col2) VALUES ('aa', 'bb');
SELECT * FROM ex1_10;

-- 4. ���̺� ����
-- 4-1 ���̺� ����
DROP TABLE ex1_10; -- ���̺� ����
DROP TABLE ex1_10 CASCADE CONSTRAINTS; -- ���̺� �� �������� ����
-- 4-2 �÷��� ����
ALTER TABLE ex1_10 RENAME COLUMN col1 TO col_1; -- ALTER�� RENAME COLUMN
-- 4-3 �÷�Ÿ�� ����
ALTER TABLE ex1_10 MODIFY col2 VARCHAR2(30); -- ALTER�� MODIFY
-- 4-4 �÷� �߰�
ALTER TABLE ex1_10 ADD col3 VARCHAR2(30); -- ALTER�� ADD
-- 4-5 �÷� ����
ALTER TABLE ex1_10 DROP COLUMN col3; -- ALTER�� DROP COLUMN
-- 4-6 ��������(�⺻Ű) �߰�
ALTER TABLE ex1_10 ADD CONSTRAINT pk_ex1_10 PRIMARY KEY(col_1); -- ADD CONSTRAINT - PRIMARY KEY
-- 4-7 ��������(�⺻Ű) ����
ALTER TABLE ex1_10 DROP CONSTRAINT pk_ex1_10; -- DROP CONSTRAINT
-- 4-8 ���̺� ����
CREATE TABLE ex1_11 AS SELECT col_1, col2 FROM ex1_10;

-- 5. VIEW
CREATE OR REPLACE VIEW cust_view AS
  SELECT cust_id, cust_name, cust_gender, cust_city
    FROM customers;
SELECT * FROM cust_view;
SELECT * FROM user_views; -- �並 �����ϴ� ���̺�
-- 5-1 �� ����
DROP VIEW cust_view;

-- 6. INDEX
-- 6-1 �ε��� ����
DELETE FROM ex1_10; -- �� ���� ����
commit;
CREATE UNIQUE INDEX idx_ex1_10 ON ex1_10(col_1); -- UNIQUE INDEX ON
INSERT INTO ex1_10(col_1, col2) VALUES('aa','bb');
INSERT INTO ex1_10(col_1, col2) VALUES('bb','gg'); 
INSERT INTO ex1_10(col_1, col2) VALUES('cc','qq');
INSERT INTO ex1_10(col_1, col2) VALUES('dd','ww');
INSERT INTO ex1_10(col_1, col2) VALUES('ee','zz');
commit;
-- �ε����� ����ϴ� ��ȸ
SELECT * FROM ex1_10 ORDER BY col_1; -- idx_ex1_10 �ε����� ���
-- �ε��� ���� Ȯ��
SELECT * FROM user_indexes -- �ε����� �����ϴ� ���̺�
  WHERE table_name='EX1=10';
-- �ε��� ����
DROP INDEX idx_ex1_10;

-- 7. SYNONYM
-- 7-1 private �ó�� ���� (channels���̺��� private �ó�� ����)
CREATE OR REPLACE SYNONYM syn_channel FOR channels; -- private ��������(�⺻�� private)
SELECT * FROM syn_channel; -- ������ �ó�� ���
-- 7-2 public �ó�� ����
CREATE OR REPLACE PUBLIC SYNONYM syn_channel2 FOR channels;
-- public �ó�Կ� ���� select���� �ο�
GRANT SELECT ON syn_channel2 TO PUBLIC;
-- �ó�� ���� Ȯ��
SELECT * FROM ALL_SYNONYMS
  WHERE TABLE_NAME ='CHANNELS'; -- �ó���� �����ϴ� ���̺�
-- �ó�� ����
DROP SYNONYM syn_channel;

-- 8. SEQUENCE
-- 8.1 ������ ����
CREATE SEQUENCE my_seq
INCREMENT BY 1
START WITH 1
MINVALUE 1
MAXVALUE 1000
NOCYCLE
NOCACHE;
-- 8.2 ������ ���
INSERT INTO ex1_9(num1) VALUES (my_seq.NEXTVAL);
-- 8.3 ������ ����
DROP SEQUENCE my_seq;

-- 9. ��Ƽ�� ���̺�
-- ���̺� �����̽� ���� (���û���)
CREATE TABLESPACE test_tbs1 DATAFILE'D:\OracleDB\TEST_TBS1.DBF'
  SIZE 10M AUTOEXTEND ON NEXT 5M;
CREATE TABLESPACE test_tbs2 DATAFILE'D:\OracleDB\TEST_TBS2.DBF'
  SIZE 10M AUTOEXTEND ON NEXT 5M;
CREATE TABLESPACE test_tbs3 DATAFILE'D:\OracleDB\TEST_TBS3.DBF'
  SIZE 10M AUTOEXTEND ON NEXT 5M;
CREATE TABLESPACE test_tbs4 DATAFILE'D:\OracleDB\TEST_TBS4.DBF'
  SIZE 10M AUTOEXTEND ON NEXT 5M;
  
-- 9-2 RANGE ��Ƽ�� ���̺� ���� ( ������ ���� ��Ƽ�����̺�)
CREATE TABLE mypart(
  my_no NUMBER,
  my_year NUMBER NOT NULL,
  my_month NUMBER NOT NULL,
  my_day NUMBER NOT NULL,
  my_value NUMBER NOT NULL
)
PARTITION BY RANGE(my_year, my_month, my_day) -- ����� 3���� �������� ���̺��� ����
(
  PARTITION my_q1 VALUES LESS THAN(2019, 07, 01) TABLESPACE TEST_TBS1,
  PARTITION my_q2 VALUES LESS THAN(2020, 01, 01) TABLESPACE TEST_TBS2,
  PARTITION my_q3 VALUES LESS THAN(2020, 07, 01) TABLESPACE TEST_TBS3
);
-- ��Ƽ�� ���̺� ������ �߰�
INSERT INTO mypart VALUES(1, 2019, 01, 03, 00);
INSERT INTO mypart VALUES(2, 2020, 05, 03, 00);
INSERT INTO mypart VALUES(3, 2020, 01, 03, 00);
INSERT INTO mypart VALUES(4, 2019, 06, 03, 00);
INSERT INTO mypart VALUES(5, 2020, 11, 13, 00);
INSERT INTO mypart VALUES(6, 2020, 06, 30, 00);
INSERT INTO mypart VALUES(7, 2019, 08, 21, 00);
commit;

SELECT * FROM mypart WHERE my_year='2019'; -- ���� ������� �б�

SELECT * FROM mypart PARTITION(my_q1); -- ��Ƽ������ ���ϴ� ���̺��� ���� �б�
SELECT * FROM mypart PARTITION(my_q2);
SELECT * FROM mypart PARTITION(my_q3);

-- 9-2 LIST ��Ƽ�� ���̺� ���� (����Ʈ�� ���� ��Ƽ�����̺�)
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

SELECT * FROM ALL_TAB_PARTITIONS -- ��Ƽ���� �����ϴ� ���̺�
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
-- ��ü ������ ��ȸ
SELECT * FROM emp_list_pt;
-- Ư�� ��Ƽ�ǿ��� ������ ��ȸ
SELECT * FROM emp_list_pt PARTITION(emp_list_pt1);
SELECT * FROM emp_list_pt PARTITION(emp_list_pt2);
SELECT * FROM emp_list_pt PARTITION(emp_list_pt3);
SELECT * FROM emp_list_pt PARTITION(emp_list_pt4);
-- ��Ƽ�� ����
ALTER TABLE emp_list_pt DROP PARTITION emp_list_pt1;
ALTER TABLE emp_list_pt DROP PARTITION emp_list_pt2;
ALTER TABLE emp_list_pt DROP PARTITION emp_list_pt3;
ALTER TABLE emp_list_pt DROP PARTITION emp_list_pt4;
DROP TABLE emp_list_pt CASCADE CONSTRAINTS;

-- 8.1 ������ ����
CREATE SEQUENCE orders_seq
INCREMENT BY 1
START WITH 1000
MINVALUE 1
MAXVALUE 99999999
NOCYCLE
NOCACHE;
