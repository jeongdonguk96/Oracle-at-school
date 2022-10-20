-- 1. SELECT문

-- 1-1 기본연산자로 EMPLOYEES테이블에서 급여가 5000이 넘는 사원의 사원번호, 사원명, 급여 조회
SELECT employee_id, emp_name, salary FROM employees
  WHERE salary>5000 ORDER BY salary;
  
-- 내림차순으로 정렬 (DESC)
SELECT employee_id, emp_name, salary FROM employees
  WHERE salary>5000 ORDER BY salary DESC;
  
-- EMPLOYEES테이블에서 직책이 st_clerk인 사원을 조회 후 사원명을 기준으로 정렬
SELECT employee_id, emp_name FROM employees
  WHERE job_id = 'ST_CLERK' ORDER BY emp_name;
  
-- 1-2 논리연산자 OR을 이용해 EMPLOYEES테이블에서 직책이 st_clerk이거나 급여가 3000초과인 사원을 조회 후 사원명을 기준으로 정렬  
SELECT employee_id, emp_name FROM employees
  WHERE salary>3000 OR job_id = 'ST_CLERK' ORDER BY emp_name;
  
-- 1-3 논리연산자 AND를 이용해 EMPLOYEES테이블에서 직책이 st_clerk이면서 급여가 3000초과인 사원을 조회 후 사원명을 기준으로 정렬  
SELECT employee_id, emp_name FROM employees
  WHERE salary>3000 AND job_id = 'ST_CLERK' ORDER BY emp_name;
  
-- sales테이블에서 amount_sold가 50이상인 사원의 사원번호, 판매액을 사원번호 순으로 조회
SELECT employee_id, amount_sold FROM sales
  WHERE amount_sold>50 ORDER BY employee_id;
  
-- 1-4 LIKE연산자를 이용해 St가 이름 제일 앞에 붙은 사원 조회
SELECT employee_id, emp_name FROM employees
  WHERE emp_name LIKE 'St%';
  
  -- like를 이용해 St가 이름 중간에 붙은 사원 조회
SELECT employee_id, emp_name FROM employees
  WHERE emp_name LIKE '%St%';
  
-- like를 이용해 King이 이름 제일 뒤에 붙은 사원 조회
SELECT employee_id, emp_name FROM employees
  WHERE emp_name LIKE '%King';
  
-- employees테이블에서 phone_number에 '1234'가 들어가는 사원의 사원번호, 사원명, 전화번호를 조회
SELECT employee_id, emp_name, phone_number FROM employees
  WHERE phone_number LIKE '%1234%';
  
-- 1-5 IN연산자를 이용해 소속부서가 10, 20, 40에 속하는 사원의 사원명, 부서번호, 전화번호를 조회
SELECT emp_name, department_id, phone_number FROM employees
  WHERE department_id IN (10, 20, 40);
  
-- customers테이블에서 year_of_birth가 1970, 1975년이면서 이름이 'A'로 시작하는 고객의
-- 고객명, 태어난 해, 성별, 거주도시를 이름순으로 조회
SELECT cust_name, cust_year_of_birth, cust_gender, cust_city FROM customers
  WHERE cust_year_of_birth IN(1970, 1975) AND cust_name LIKE 'A%'
  ORDER BY cust_name;
  
-- 1-6 BETWEEN~AND를 이용해 sales테이블에서 1998년 1월부터 12월까지 매출액 합계를 조회
SELECT SUM(amount_sold) FROM sales
  WHERE sales_month BETWEEN '199801' AND '199812';
  
-- sales테이블에서 1999년 1월부터 6월까지 총 판매수량 합계를 조회
SELECT SUM(quantity_sold) AS "총 판매수량" FROM sales
  WHERE sales_month BETWEEN '199801' AND '199806'; 
  
-- 1-7 DISTINCT
-- (1) ALL을 이용해 스페인에 거주하는 고객들의 도시목록 조회
SELECT ALL cust_city FROM customers -- ALL은 항상 디폴트
  WHERE country_id='52778';
  
-- (2) DISTINCT를 이용해 스페인에 거주하는 고객들의 도시목록 조회 (중복된 행을 제거)
SELECT DISTINCT cust_city FROM customers -- ALL은 항상 디폴트
  WHERE country_id='52778';
  
-- DISTINCT를 이용해 EMPLOYEES테이블에서 급여가 6000이상인 사원들의 부서목록을 조회
SELECT DISTINCT department_id FROM employees
  WHERE salary>=6000 ORDER BY department_id;
  
-- 1-8 GROUP BY -- 집계를 내는 데 사용
-- customers테이블에서 고객이 거주하는 도시별 고객수 조회
SELECT cust_city, count(cust_city) FROM customers
  WHERE country_id='52778' GROUP BY cust_city;
  
-- employees테이블에서 부서별로 그룹화해서 부서번호와 사원수 조회
SELECT department_id, count(department_id) FROM employees
  GROUP BY department_id ORDER BY department_id;
  
-- sales테이블에서 판매월별 매출액 합계 조회
SELECT sales_month, SUM(amount_sold) FROM sales
  GROUP BY sales_month;
  
-- (1) GROUP BY ~ HAVING문
-- customers테이블에서 고객이 거주하는 도시별 고객수 조회 후 고객수가 500명 이상인 도시명과 고객 수 조회
SELECT cust_city, count(cust_city) FROM customers
  GROUP BY cust_city HAVING count(cust_city)>=500 ORDER BY count(cust_city) desc;
  
-- EMPLOYEES테이블에서 부서별로 그룹화 후 인원수가 20명 이상인 부서의 부서번호와 사원수 조회
SELECT department_id, count(employee_id) FROM employees
  GROUP BY department_id HAVING count(employee_id)>=20;
  
-- (2) ROLLUP(레벨별로 집계결과 반환)
-- 기존 GROUP BY문으로 국내 대출현황을 기간별, 대출구분별로 2013년 대출 총잔액을 집계
SELECT period, gubun, SUM(loan_jan_amt) FROM kor_loan_status
 WHERE period LIKE '2013%' GROUP BY period, gubun ORDER BY period;
 
-- ROLLUP문으로 국내 대출현황을 기간별, 대출구분별로 2013년 대출 총잔액을 집계
SELECT period, gubun, SUM(loan_jan_amt) FROM kor_loan_status
 WHERE period LIKE '2013%' GROUP BY ROLLUP(period, gubun) ORDER BY period;
 
-- (3) CUBE(가능한 모든 조합별로 집계)
-- CUBE문으로 국내 대출현황을 기간별, 대출구분별로 2013년 대출 총잔액을 집계
 SELECT period, gubun, SUM(loan_jan_amt) FROM kor_loan_status
 WHERE period LIKE '2013%' GROUP BY CUBE(period, gubun) ORDER BY period;
 
-- (4) GROUPING SETS
-- GROUPING SETS문으로 국내 대출현황을 기간별, 대출구분별로 2013년 대출 총잔액을 집계
 SELECT period, gubun, SUM(loan_jan_amt) FROM kor_loan_status
 WHERE period LIKE '2013%' GROUP BY GROUPING SETS(period, gubun) ORDER BY period;
 
 -- 2. INSERT
 CREATE TABLE ex2_1(
    col1 VARCHAR(20),
    col2 NUMBER,
    col3 DATE
 );
 
 -- 일반적인 INSERT문
 INSERT INTO ex2_1(col1, col2, col3) VALUES('ABC', 10, sysdate);
 
 -- 일부 컬럼에 데이터를 저장할 때
 INSERT INTO ex2_1(col1, col2) VALUES('DEF', 20);
 
 -- 모든 컬럼에 데이터를 저장할 때
 INSERT INTO ex2_1 VALUES('GHI', 30, sysdate);
 
CREATE TABLE ex2_2(
   emp_id NUMBER,
   emp_name VARCHAR2(80),
   salary NUMBER,
   manager_id NUMBER
 );
 
 -- EMPLOYEES테이블에서 사번, 사원명, 급여, 관리자 사번을 조회 후 ex2_2테이블에 INSERT
INSERT INTO ex2_2(emp_id, emp_name, salary, manager_id)
SELECT employee_id, emp_name, salary, manager_id
FROM employees;

 -- ex2_2와 같은 ex2_3테이블 생성 후 EMPLOYEE테이블에서 관리자 사번이 124이고
 -- 급여가 2000~3000인 사원을 조회 후 ex2_3테이블에 INSERT
CREATE TABLE ex2_3(
   emp_id NUMBER,
   emp_name VARCHAR2(80),
   salary NUMBER,
   manager_id NUMBER
 );
 
INSERT INTO ex2_3(emp_id, emp_name, salary, manager_id)
SELECT employee_id, emp_name, salary, manager_id
FROM employees
WHERE salary BETWEEN 2000 AND 3000 AND manager_id=124;

-- 3. UPDATE

-- ex2_3테이블에서 사원번호가 198인 사원의 급여를 3500으로 변경
UPDATE ex2_3 SET salary=3500
WHERE emp_id=198;

-- ex2_3테이블에서 사원번호가 199인 사원의 이름을 홍길동으로 변경
UPDATE ex2_3 SET emp_name='홍길동'
WHERE emp_id=199;
SELECT * FROM ex2_3;

-- 4. DELETE
-- ex2_3테이블에서 사원번호가 198인 사원을 삭제
DELETE ex2_3
WHERE emp_id=198;

-- 5. MERGE (지정하는 조건을 비교해 INSERT 혹은 UPDATE를 수행)
-- newjoin(신규고객 테이블)과 cust(기존고객 테이블)
-- newjoin에 입력된 고객에 대해 cust테이블에 존재하면 cust에 UPDATE 없으면 cust에 INSERT
CREATE TABLE newjoin( -- newjoin테이블 생성
  cust_id NUMBER PRIMARY KEY,
  cust_name VARCHAR(10),
  phone NUMBER
);

CREATE SEQUENCE cust_seq -- newjoin_id를 시퀀스로 처리
INCREMENT BY 1
START WITH 1
MINVALUE 1
MAXVALUE 1000
NOCYCLE
NOCACHE;
INSERT INTO newjoin VALUES(cust_seq.NEXTVAL, '홍길동', 01080256181); -- newjoin에 내용 저장
INSERT INTO newjoin VALUES(cust_seq.NEXTVAL, '김미소', 01012345678);
INSERT INTO newjoin VALUES(cust_seq.NEXTVAL, '박민영', 01000000000);

CREATE TABLE cust( -- cust테이블 생성
  cust_id NUMBER,
  cust_name VARCHAR(10),
  phone NUMBER,
  visit_count NUMBER DEFAULT 0
);

CREATE SEQUENCE cust_seq2 -- cust_id를 시퀀스로 처리
INCREMENT BY 1
START WITH 1
MINVALUE 1
MAXVALUE 1000
NOCYCLE
NOCACHE;
INSERT INTO cust VALUES(cust_seq2.NEXTVAL, '홍길동', 01080256181, 3); -- cust에 내용 저장

-- MERGE문 사용
MERGE INTO cust C-- 병합할 테이블, cust테이블의 별명 C
USING (SELECT cust_id, cust_name, phone FROM newjoin) N-- 병합될 테이블과 컬럼, newjoin 별명 N
ON (C.cust_id = N.cust_id) -- cust테이블에 업데이트 될 조건
WHEN MATCHED THEN
     UPDATE SET C.visit_count = C.visit_count+1 -- 기존 방문이력이 있으면 +1 UPDATE
WHEN NOT MATCHED THEN
     INSERT (C.cust_id, C.cust_name, C.phone, C.visit_count) -- 없으면 새로 INSERT
     VALUES (N.cust_id, N.cust_name, N.phone, 1);
     
-- 6. COMMIT, ROLLBACK, SAVEPOINT
-- 테스트테이블 생성
CREATE TABLE dept AS
SELECT department_id, department_name
  FROM departments;
  
-- dept테이블에서 부서번호 10을 총무부로 수정
UPDATE dept SET department_name='총무기획부'
WHERE department_id=10;
commit; -- 데이터를 DB에 최종 반영
rollback; -- 데이터를 이전 상태로 되돌리기

-- SAVEPOINT -- 특정지점에 savepoint를 깃하고 나중에 다시 돌아올 수 있게 함
             -- 테이블과 무관하게 명령자체만을 순서로 인식함
             
-- (1) dept테이블에서 부서번호가 40인 부서 삭제
DELETE dept WHERE department_id=40;
commit;

-- (2) SAVEPOINT c1을 설정하고 부서번호가 30인 부서 삭제
SAVEPOINT c1;
DELETE dept WHERE department_id=30;

-- (3) SAVEPOINT c2을 설정하고 부서번호가 10인 부서 삭제
SAVEPOINT c2;
DELETE dept WHERE department_id=10;

-- (4) SAVEPOINT c2까지 ROLLBACK
rollback to c2;

-- TRUNCATE 완전 삭제. DELETE와 달리 롤백이 소용 없다.
TRUNCATE TABLE dept;


-- 7. 의사컬럼

-- 7-1 ROWRUM (정해진 레코드 수만큼 조회할 때 사용)
SELECT ROWNUM, employee_id, emp_name
  FROM employees
  WHERE ROWNUM <=10;
  
-- 7-2 ROWID(행에 id가 숨겨져있는데 그 주소값을 나타냄. 행을 식별하는 유일한 값)
-- 중복된 데이터를 가진 테이블에서 ROWID를 이용해 특정 데이터를 제거
CREATE TABLE emp(
  emp_name VARCHAR2(10),
  dept_no NUMBER
);

INSERT INTO emp VALUES('홍길동', 30);
INSERT INTO emp VALUES('유관순', 30);
INSERT INTO emp VALUES('이순진', 30);
INSERT INTO emp VALUES('박해미', 30);
INSERT INTO emp VALUES('홍길동', 30);
commit;
DELETE emp
WHERE emp_name='홍길동' AND dept_no=30;
-- 가장 나중에 저장된 '홍길동'레코드 삭제. 즉, 주소값이 제일 큰 '홍길동' 삭제
-- 가장 최근의 데이터일수록 rowid가 큰값을 할당
SELECT MAX(ROWID) ,emp_name, dept_no FROM emp 
  GROUP BY emp_name, dept_no;

-- 중복된 데이터 삭제 (subQUERY)
DELETE emp WHERE rowid IN
(SELECT MAX(ROWID) FROM emp 
  GROUP BY emp_name, dept_no);
SELECT * FROM emp;

-- 8. 연산자

-- 8-1 수식연산자 *을 이용해 EMPLOYEE테이블에서 JOB_ID가 IT_PROG인 사원의 사번, 급여, 연봉을 조회
SELECT employee_id, salary, salary*12 연봉 FROM employees 
  WHERE job_id='IT_PROG';
  
-- 8-2 문자열연산자 || (두개 이상의 컬럼을 하나의 컬럼으로 이어 붙이는 연산) 
-- 미국 국적의 고객명과 주소를 조회
SELECT cust_name, cust_state_province || cust_city || cust_street_address 주소
  FROM customers WHERE country_id=52790 ORDER BY cust_state_province;
  
-- EMPLOYEE테이블에서 사원번호||사원명 형식으로 최초 10건만 조회
SELECT employee_id || ' : ' || emp_name "사원번호 : 이름" FROM employees
 WHERE ROWNUM <=10;
 
-- 8-3 조건연산자
-- (1) CASE연산자(CASE ~ END로 끝나는 문)
-- EMPLOYEE테이블에서 급여로 등급을 나눠 사원명, 급여, 등급을 조회
SELECT employee_id, salary,
CASE WHEN salary < 5000 THEN 'C등급' -- CASE부터 END까지가 하나의 컬럼
WHEN salary BETWEEN 5000 AND 15000 THEN 'B등급'
ELSE 'A등급'
END
AS 급여등급 -- CASE연산자는 새로운 컬럼을 만들어 내기 때문에 이름을 부여하는 게 좋다
FROM employees ORDER BY salary;

-- EMPLOYEE테이블에서 사원번호, 사원명, job_id, 급여, 인상된급여를 조회
-- CASE1 job_id가 ST_MAN이면 인상된 급여에 급여1*1 저장
-- CASE2 SA_REP면 급여*1.05 저장
-- CASE3 FI_ACCOUNT면 급여*1 저장
-- ELSE 급여*1.03 저장
SELECT employee_id, emp_name, job_id, salary,
CASE WHEN job_id='ST_MAN' THEN salary*1.1
WHEN job_id='SA_REP' THEN salary*1.05
WHEN job_id='FI_ACCOUNT' THEN salary*1
ELSE salary*1.03
END AS raisedsalary -- 기존에 저장된 컬럼이 아닌 조합해서 만들어낸 컬럼이라 명명하는 게 좋음
FROM employees ORDER BY job_id;

-- (2) ANY연산자(기본적으로 IN과 비슷하지만 비교연산자들을 활용해 다양한 방식으로 비교 가능
-- CUSTOMERS테이블에서 거주도시가 CA, CO, AR중 하나인 고객의 고객명, 수입등급, 주명 조회
SELECT cust_name, cust_income_level, cust_state_province FROM customers
  WHERE cust_state_province=ANY('CA', 'CO', 'AR');
  -- WHERE cust_state_province IN('CA', 'CO', 'AR'); IN과 비슷한 기능이지만 다양한 비교 가능
  
-- (3) ALL연산자 (괄호 안의 모든 값을 만족하는 데이터를 조회)
-- EMPLOYEES테이블에서 job_id가 'SA_MAN'인 사원보다 급여를 많이 받는 사원의 사원명, job_id,salary 조회
SELECT employee_id, emp_name, job_id, salary FROM employees
WHERE salary > ALL(select salary from employees where job_id='SA_MAN')
AND job_id <> 'SA_MAN';

-- (4) EXISTS (조건에 만족하는 데이터가 있으면 조회) 
-- skip
SELECT employee_id, salary FROM employees
  WHERE salary=ANY(2000, 3000, 4000) ORDER BY employee_Id;
SELECT employee_id, salary FROM employees
  WHERE salary!=ALL(2000, 3000, 4000) ORDER BY employee_Id;

CREATE TABLE ex3_3(
  employee_id NUMBER,
  sales NUMBER,
  sales_month NUMBER
);

MERGE INTO ex3_3 e-- 병합할 테이블, cust테이블의 별명 C
USING (SELECT e, cust_name, phone FROM newjoin) N-- 병합될 테이블과 컬럼, newjoin 별명 N
ON (C.cust_id = N.cust_id) -- cust테이블에 업데이트 될 조건
WHEN MATCHED THEN
     UPDATE SET C.visit_count = C.visit_count+1 -- 기존 방문이력이 있으면 +1 UPDATE
WHEN NOT MATCHED THEN
     INSERT (C.cust_id, C.cust_name, C.phone, C.visit_count) -- 없으면 새로 INSERT
     VALUES (N.cust_id, N.cust_name, N.phone, 1);
     
-- SQL 연습문제 (1)
-- IN을 이용하는 문장을 
SELECT employee_id, salary
FROM employees
WHERE salary IN (2000, 3000, 4000);

-- ANY를 이용하는 문장으로 바꾸시오
SELECT employee_id, salary
FROM employees
WHERE salary = ANY (2000, 3000, 4000);

-- SQL 연습문제 (2)
-- IN을 이용하는 문장을 
SELECT employee_id, salary
FROM employees
WHERE salary NOT IN (2000, 3000, 4000);

-- ALL를 이용하는 문장으로 바꾸시오
SELECT employee_id, salary
FROM employees
WHERE salary != ALL (2000, 3000, 4000);
