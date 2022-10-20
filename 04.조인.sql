CREATE TABLE salesman (
salesman_id   number(8)  primary key,
name           varchar(30),
city             varchar2(20),
commision     number(5,2));

CREATE TABLE customer_ex (
customer_id   number(8) primary key,
cust_name    varchar2(30),
city             varchar2(20),
grade           number(5),
salesman_id   number(8));

insert into salesman VALUES(5001 , 'James Hoog' , 'New York' ,       0.15);
insert into salesman VALUES(5002 , 'Nail Knite' , 'Paris'    ,       0.13);
insert into salesman VALUES(5005 , 'Pit Alex'   , 'London'   ,       0.11);
insert into salesman VALUES(5006 , 'Mc Lyon'    , 'Paris'    ,       0.14);
insert into salesman VALUES(5007 , 'Paul Adam'  , 'Rome'     ,       0.13);
insert into salesman VALUES(5003 , 'Lauson Hen' , 'San Jose' ,       0.12);
insert into salesman VALUES(5008 , '홍길동' , 'Busan' ,       0.12);
commit;

insert into customer_ex VALUES(3002 , 'Nick Rimando'   , 'New York'   ,   100 ,        5001);
insert into customer_ex VALUES(3007 , 'Brad Davis'     , 'New York'   ,   200 ,        5001);
insert into customer_ex VALUES( 3005 , 'Graham Zusi'    , 'California' ,   200 ,        5002);
insert into customer_ex VALUES(3008 , 'Julian Green'   , 'London'     ,   300 ,        5002);
insert into customer_ex VALUES(3004 , 'Fabian Johnson' , 'Paris'      ,   300 ,        5006);
insert into customer_ex VALUES(3009 , 'Geoff Cameron'  , 'Berlin'     ,   100 ,        5003);
insert into customer_ex VALUES( 3003 , 'Jozy Altidor'   , 'Moscow'     ,   200 ,        5007);
insert into customer_ex VALUES(3001 , 'Brad Guzan'     , 'London'     ,     0  ,        5005);
insert into customer_ex VALUES(3010 , '이순신'     , 'Seoul'     ,     0  ,        '');
commit;

create table ORDERS_EX(
ord_no      number(8)  primary key,
purch_amt  number(7,2),
ord_date    date,
customer_id  number(8),
salesman_id  number(8));

INSERT INTO orders_ex VALUES(70001,       150.5,       '2012-10-05',  3005 ,        5002);
INSERT INTO orders_ex VALUES(70009,       270.65,      '2012-09-10',  3001,         5005);
INSERT INTO orders_ex VALUES(70002,       65.26,       '2012-10-05',  3002,         5001);
INSERT INTO orders_ex VALUES(70004,       110.5,       '2012-08-17',  3009,         5003);
INSERT INTO orders_ex VALUES(70007,       948.5,       '2012-09-10',  3005,         5002);
INSERT INTO orders_ex VALUES(70005,       2400.6,      '2012-07-27',  3007,         5001);
INSERT INTO orders_ex VALUES(70008,       5760 ,       '2012-09-10',  3002 ,        5001);
INSERT INTO orders_ex VALUES(70010,       1983.43 ,    '2012-10-10',  3004,         5006);
INSERT INTO orders_ex VALUES(70003,       2480.4 ,     '2012-10-10',  3009 ,        5003);
INSERT INTO orders_ex VALUES(70012,       250.45,      '2012-06-27',  3008 ,        5002);
INSERT INTO orders_ex VALUES(70011,       75.29 ,      '2012-08-17',  3003 ,        5007);
INSERT INTO orders_ex VALUES(70013,       3045.6,      '2012-04-25',  3002,         5001);
commit;

--------------------------------------------------------------------------------------------

CREATE  TABLE cust_ex (
    custid      varchar2(10)  primary key,
    name      varchar2(30),
    birthyear number,
    addr  varchar2(30),
    mobile varchar2(15),
    regdate date);

CREATE  TABLE  buy (
    num  number primary key,
    custid  varchar2(10),
    prodid number,
    price  number,
    quantity  number);

CREATE  TABLE prod (
    prodid  number  primary key,
    prod_name  varchar2(30),
    groupname  varchar2(30)
);

INSERT  INTO  prod  VALUES(1, '노트북', '전자');
INSERT  INTO  prod  VALUES(2, '모니터', '전자');
INSERT  INTO  prod  VALUES(3, '메모리', '전자');
INSERT  INTO  prod  VALUES(4, '청바지', '의류');
INSERT  INTO  prod  VALUES(5, '책', '서적');
INSERT  INTO  prod  VALUES(6, '냉장고', '전자');
INSERT  INTO  prod  VALUES(7, 'TV', '전자');
INSERT  INTO  prod VALUES(8, '운동화', '의류');

INSERT  INTO  cust_ex  values('LSS', '이순신', 1960, '경북', '010-1234-2234', '2017-04-04');
INSERT  INTO  cust_ex  values('YKS', '유관순', 1971, '경남', '010-3556-2234', '2017-06-04');
INSERT  INTO  cust_ex  values('KKC', '강감찬', 1965, '서울', '010-6453-2234', '2017-08-10');
INSERT  INTO  cust_ex  values('JMJ', '정몽주', 1967, '서울', '010-2345-2234', '2017-04-04');
INSERT  INTO  cust_ex  values('JYS', '장영실', 1971, '경기', '010-5673-2234', '2017-07-13');
INSERT  INTO  cust_ex  values('JBK', '장보고', 1970, '경남', '010-3423-2234', '2017-05-03');
INSERT  INTO  cust_ex  values('LYK', '이율곡', 1972, '경남', '010-7876-2234', '2017-03-02');
INSERT  INTO  cust_ex  values('LH', '이황', 1983, '충남', '010-9832-2234', '2017-06-08');
INSERT  INTO  cust_ex  values('HKD', '홍길동', 1990, '서울', '010-7682-2234', '2017-05-01');
INSERT  INTO  cust_ex  values('SSJ', '신숙주', 1992, '경기', '010-4567-2234', '2017-05-08');

INSERT  INTO  buy VALUES(buy_seq.nextval, 'LSS', 8, 30000, 2);
INSERT  INTO  buy VALUES(buy_seq.nextval, 'LSS', 1, 1000000, 1);
INSERT  INTO  buy VALUES(buy_seq.nextval, 'JMJ', 2, 200000, 1);
INSERT  INTO  buy VALUES(buy_seq.nextval, 'LH', 2, 210000, 2);
INSERT  INTO  buy VALUES(buy_seq.nextval, 'LSS', 4, 50000, 5);
INSERT  INTO  buy VALUES(buy_seq.nextval, 'YKS', 3, 30000, 3);
INSERT  INTO  buy VALUES(buy_seq.nextval, 'JYS',5, 25000, 10);
INSERT  INTO  buy VALUES(buy_seq.nextval, 'JYS', 5, 33000, 2);
INSERT  INTO  buy VALUES(buy_seq.nextval, 'LH', 4, 55000, 2);
INSERT  INTO  buy VALUES(buy_seq.nextval, 'SSJ', 8, 23000, 3);
commit;

CREATE SEQUENCE buy_seq START WITH 1 INCREMENT BY 1;

--------------------------------------------------------------------------

-- 카테시안(CROSS) 조인 샘플
CREATE TABLE regions(
    region_id   NUMBER,
    region_name VARCHAR2(20)
);

CREATE TABLE countries_ex(
    country_id    CHAR(2),
    country_name  VARCHAR2(20),
    region_id    NUMBER
);

INSERT INTO regions VALUES(1, 'Europe');
INSERT INTO regions VALUES(2, 'America');
INSERT INTO regions VALUES(3, 'Asia');
INSERT INTO regions VALUES(4, 'Middle East');
INSERT INTO regions VALUES(5, 'Africa');
 
INSERT INTO countries_ex VALUES('AR', 'Argentina', 2);
INSERT INTO countries_ex VALUES('AU', 'Australia', 3);
INSERT INTO countries_ex VALUES('BE', 'Belgium', 1);
INSERT INTO countries_ex VALUES('BR', 'Brazil', 2);
INSERT INTO countries_ex VALUES('CA', 'Canada', 2);
INSERT INTO countries_ex VALUES('CH', 'Switzerland', 1);
INSERT INTO countries_ex VALUES('KR', 'South Korea', 3);
INSERT INTO countries_ex VALUES('CN', 'China', 3);
INSERT INTO countries_ex VALUES('DE', 'Germany', 1);
INSERT INTO countries_ex VALUES('DK', 'Denmark', 1);
INSERT INTO countries_ex VALUES('EG', 'Egypt', 4);
INSERT INTO countries_ex VALUES('FR', 'France', 1);
INSERT INTO countries_ex VALUES('IL', 'Israel', 4);
INSERT INTO countries_ex VALUES('IN', 'India', 3);
INSERT INTO countries_ex VALUES('IT', 'Italy', 1);
INSERT INTO countries_ex VALUES('JP', 'Japan', 3);
INSERT INTO countries_ex VALUES('KW', 'Kuwait', 4);
INSERT INTO countries_ex VALUES('MX', 'Mexico', 2);
INSERT INTO countries_ex VALUES('NG', 'Nigeria', 5);
INSERT INTO countries_ex VALUES('NL', 'Netherlands', 1);
INSERT INTO countries_ex VALUES('SG', 'Singapore', 3);
INSERT INTO countries_ex VALUES('US', 'United States', 2);
INSERT INTO countries_ex VALUES('ZM', 'Zambia', 5);
INSERT INTO countries_ex VALUES('ZW', 'Zimbabwe', 5);

commit;

-- 1. INNER JOIN
-- 1.1 EQUI JOIN (동등조인) - 기본키와 외래키를 매개로 조인
-- 전체 직원의 사원번호, 사원명, 부서번호, 부서명을 조회
SELECT employee_id, emp_name, e.department_id, department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id
ORDER BY employee_id;

-- SQL 연습문제 1
-- 같은 도시에 속하는 고객과 영업사원의 고객명, 도시명, 사원번호, 사원명 조회
SELECT c.cust_name, c.city, s.salesman_id, s.name
FROM customer_ex c, salesman s
WHERE c. city = s. city
ORDER BY city;

-- SQL 연습문제 2
-- 주문금액이 500~2000사이인 주문에 대해서 주문번호, 주문금액, 고객번호, 주문도시 조회
SELECT o.ord_no, o.purch_amt, c.cust_name, c.city
FROM orders_ex o, customer_ex c
WHERE purch_amt BETWEEN 500 AND 2000 AND o.customer_id = c.customer_id;

-- SQL 연습문제 3
-- 수수료를 12%이상 받는 영업사원과 담당하는 고객의 사원번호, 사원명, 수수료, 고객명, 도시명 조회
SELECT s.salesman_id, s.name, s.commision, c.cust_name, c.city
FROM salesman s, customer_ex c
WHERE s.commision>=0.12 AND s.salesman_id=c.salesman_id;

-- 1.2 SEMI JOIN 
-- EXISTS를 이용해 급여가 3000이상인 사원의 부서번호, 부서명 조회
SELECT department_id, department_name
FROM departments d
WHERE EXISTS (SELECT * FROM employees e
              WHERE d.department_id = e.department_id
              AND e.salary>=3000)
ORDER BY d.department_name;

-- IN을 사용해 급여가 3000이상인 사원의 부서번호, 부서명 조회
SELECT department_id, department_name
FROM departments
WHERE department_id IN (SELECT department_id FROM employees WHERE salary>=3000)
ORDER BY department_name;

-- 1.3 ANTI JOIN - SEMI JOIN의 반대
-- NOT IN을 사용해 departments테이블에서 managet_id가 있는 부서의 사원번호, 사원명, 부서번호, 부서명 조회
SELECT e.employee_id, e.emp_name, e.department_id, d.department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id
      AND e.department_id NOT IN(SELECT department_id
                                 FROM departments WHERE manager_id IS NULL)
ORDER BY department_id;

-- NOT EXISTS를 이용해 managet_id가 있는 부서에 속하는 사원수 조회
SELECT count(*)
  FROM employees e
  WHERE NOT EXISTS (SELECT department_id
                      FROM departments d WHERE manager_id IS NULL
                       AND e.department_id = d.department_id)
ORDER BY department_id;

-- 1.4 SELF JOIN - 동일한 테이블을 사용해 조인
-- 부서번호가 20인 사원의 사원번호, 사원명, 부서명 조회
SELECT a.employee_id, a.emp_name, b.employee_id, b.emp_name, a.department_id
  FROM employees a, employees b
 WHERE a.department_id = b.department_id
   AND a.department_id = 20
   AND a.employee_id < b.employee_id;

-- SQL 연습문제 4
-- employees테이블에서 사원번호, 사원명, 부서장번호, 부서장명 조회
SELECT a.employee_id, a.emp_name, b.employee_id manager_id, b.emp_name manager_name
  FROM employees a, employees b
 WHERE a.manager_id = b.employee_id
ORDER BY manager_id;

-- SQL 연습문제 5
-- customer_ex테이블에서 같은 도시에 거주하는 고객의 고객명, 고객명, 도시명 조회
SELECT a.cust_name, b.cust_name, a.city
  FROM customer_ex a, customer_ex b
 WHERE a.city = b.city
   AND a.customer_id < b.customer_id;
-- 중복의 경우는 a와 b에서 각각 한번씩 총 두번 나오는 건데 
-- id번호가 다르기 때문에 크거나 혹은 작은 하나만 조건에 만족하도록 해서 중복을 제거하면 됨

-- 2. OUTER JOIN
-- SQL 연습문제 5
-- cust_ex, buy테이블을 이용해 고객번호, 고객명, 제품번호, 금액 조회
SELECT c.custid, c.name, b.prodid, b.price
  FROM cust_ex c, buy b
 WHERE c.custid = b.custid(+);

-- SQL 연습문제 6
-- employees테이블에서 모든 사원에 대한 사원번호, 사원명, 직책번호, 시작일, 종료일 조회
SELECT e.employee_id, e.emp_name, j.job_id, j.start_date, j.end_date
  FROM employees e, job_history j
 WHERE e.employee_id = j.employee_id(+)
ORDER BY employee_id;

-- SQL 연습문제 7
-- prod, buy테이블에서 제품번호, 금액, 수량, 제품명 조회
SELECT p.prodid, b.price, b.quantity, b.custid
  FROM buy b, prod p
 WHERE b.prodid(+) = p.prodid
ORDER BY prodid;

-- 2.1 CARTESIAN JOIN - WHERE(조건)이 없는 조인
SELECT r.region_id, r.region_name, c.country_id, c.country_name
  FROM regions r, countries_ex c
 WHERE r.region_id=3
   AND r.region_id > c.region_id;
 
-- 3. ANSI JOIN
-- 3.1 ANSI INNER JOIN
-- 2003년 1월 1일 이후에 입사한 사원의 사번, 이름, 부서번호, 부서명 조회
-- (1) 기존 오라클 문법 사용
SELECT e.employee_id, e.emp_name, d.department_id, d.department_name
  FROM employees e, departments d
 WHERE e.department_id = d.department_id
   AND hire_date>TO_DATE('2003-01-01', 'YYYY-MM-DD');
-- (2) ANSI JOIN문법 사용
SELECT e.employee_id, e.emp_name, d.department_id, d.department_name
  FROM employees e
  INNER JOIN departments d
    ON e.department_id = d.department_id
 WHERE hire_date > TO_DATE('2003-01-01', 'YYYY-MM-DD');
 
-- ANSI문법의 LEFT JOIN을 이용해 모든 직원의 발령내역 조회
SELECT e.employee_id, e.emp_name, j.job_id, j.start_date, j.end_date
  FROM employees e
LEFT OUTER JOIN job_history j
    ON e.employee_id = j.employee_id;
    
-- ANSI LEFT JOIN을 이용해 모든 영업사원의 고객정보를 조회하여 사원명순으로 조회
SELECT s.name, s.salesman_id, c.customer_id, c.cust_name, c.city, c.grade
  FROM salesman s
LEFT OUTER JOIN customer_ex c
    ON s.salesman_id = c.salesman_id
ORDER BY s.name;

-- ANSI RIGHT JOIN을 이용해 모든 직원의 발령내역 조회
SELECT e.employee_id, e.emp_name, j.job_id, j.start_date, j.end_date
  FROM job_history j
RIGHT OUTER JOIN employees e
    ON e.employee_id = j.employee_id;

-- 4. FULL JOIN - 합집합
CREATE TABLE TAB_A(col_1 NUMBER);
CREATE TABLE TAB_B(col_1 NUMBER);

INSERT INTO TAB_A VALUES(10);
INSERT INTO TAB_A VALUES(20);
INSERT INTO TAB_A VALUES(40);

INSERT INTO TAB_B VALUES(10);
INSERT INTO TAB_B VALUES(20);
INSERT INTO TAB_B VALUES(30);
commit;

-- ANSI문법의 FULL OUTER JOIN
SELECT a.col_1, b.col_1
  FROM tab_a a
FULL OUTER JOIN tab_b b
    ON a.col_1 = b.col_1;
    
-- SQL 연습문제 8
-- FULL OUTER JOIN을 이용해 모든 영업사원에 대해 고객명, 고객 거주도시, 영업사원명, 담당지역, 수당 조회
SELECT c.cust_name, c.city, s.name, s.city, s.commision
  FROM customer_ex c
FULL OUTER JOIN salesman s
    ON (c.salesman_id = s.salesman_id);