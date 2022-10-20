-- PLSQL
-- 1. 익명블록 -- DECLARE : 선언부, BEGIN : 실행부, END : 끝
DECLARE
   vi_num NUMBER;
   BEGIN
     vi_num := 100;
     DBMS_OUTPUT.PUT_LINE(vi_num);
   END;

-- 2. 연산자
DECLARE
  a INTEGER := 2**2*3**2; -- 변수선언
BEGIN
  DBMS_OUTPUT.PUT_LINE('a=' || TO_CHAR(a));
END;

-- 3.DML - select, insert, update, delete가 포함된 데이터 조작어
DECLARE
  vs_emp_name VARCHAR2(100);
  vs_dept_name VARCHAR2(80);
BEGIN
  SELECT e.emp_name, d.department_name
    INTO vs_emp_name, vs_dept_name -- INTO를 통해 SELECT한 컬럼을 변수화할 수 있음
    FROM employees e, departments d
   WHERE e.department_id = d.department_id
     AND employee_id = 100;
     
     DBMS_OUTPUT.put_line(vs_emp_name || ' : ' || vs_dept_name); 
END;

-- DML 연습문제
-- 사원번호가 110인 사원의 인센티브 계산, 인센티브율은 0.12(급여*인센티브율)
-- 출력내용 : 사원명 - 인센티브 금액
DECLARE
  vs_emp_name VARCHAR2(10);
  vn_insenplus NUMBER;
BEGIN
  SELECT emp_name, salary+(salary*0.12) insenplus
    INTO vs_emp_name, vn_insenplus
    FROM employees
   WHERE employee_id = 110;
   
   DBMS_OUTPUT.put_line(vs_emp_name || ' - ' || vn_insenplus);
END;

-- 4. 변수규칙
-- (1) 변수에 큰 따옴표를 사용할 수 있다.
-- (2) 대소문자 구분이 있다.
DECLARE
  "WELCOME" VARCHAR2(10) := 'WELCOME';
  "welcome" VARCHAR2(10) := 'welcome';
BEGIN
  DBMS_OUTPUT.put_line(WELCOME);
  DBMS_OUTPUT.put_line(welcome);
END;  

-- (3) 큰 따옴표를 사용하면 예약어도 변수로 사용 가능.
DECLARE
  "DECLARE" VARCHAR2(20) := '예약어';
  "Declare" VARCHAR2(20) := '다른 변수';
BEGIN
  DBMS_OUTPUT.put_line("DECLARE");
  DBMS_OUTPUT.put_line("Declare");
END;

-- 5. %TYPE키워드 사용
DECLARE
  vs_emp_name employees.emp_name%TYPE;
  vs_dept_name departments.department_name%TYPE;
BEGIN
  SELECT e.emp_name, d.department_name
    INTO vs_emp_name, vs_dept_name
    FROM employees e, departments d
   WHERE e.department_id = d.department_id
     AND employee_id = 100;
     
     DBMS_OUTPUT.put_line(vs_emp_name || ' : ' || vs_dept_name); 
END;

-- PLSQL 연습문제
-- employees테이블에서 사원번호가 201인 사원의 이름과 이메일주소를 출력하는 익명블록 작성
-- 출력내용 : 이름 : 이메일주소
DECLARE
  vs_emp_name employees.emp_name%TYPE;
  vs_email employees.email%TYPE;
BEGIN
  SELECT emp_name, email
    INTO vs_emp_name, vs_email
    FROM employees
   WHERE employee_id = 201;

    DBMS_OUTPUT.put_line(vs_emp_name || ' : ' || vs_email); 
END;   

-- employees테이블에서 최대 사원번호를 검색해서
-- 최대사원번호+1인 신규사원 추가
-- 입력항목 : 사원번호, 사원명(이순신), 이메일(SSLEE), 입사일자(현재일자), 부서번호(50)

DECLARE
  vn_max employees.employee_id%TYPE;
BEGIN
  SELECT MAX(employee_id)
    INTO vn_max
    FROM employees;
    
    INSERT INTO employees(employee_id, emp_name, email, hire_date, department_id)
         VALUES (vn_max+1, '이순신', 'SSLEE', sysdate, 50);
    commit;
END;
   
-- 6. 제어문
-- 6-1. IF 조건문
-- (1) 큰 수를 출력하는 IF문
DECLARE
  vn_num1 NUMBER := 10;
  vn_num2 NUMBER := 20;
BEGIN
  IF vn_num1 >= vn_num2 THEN
  DBMS_OUTPUT.put_line('큰 수는 ' || vn_num1);
  ELSE DBMS_OUTPUT.put_line('큰 수는 ' || vn_num2);
  END IF;
END;

-- (2) DBMS_RANDOM패키지를 이용해 10~120사이의 숫자를 생성해 부서번호로 생성
--     그 부서의 첫번째 사원의 급여를 조회해 (rownum = 1)
--     급여가 3000보다 적으면 '낮음'
--     3000~6000사이면 '중간'
--     6001~10000사이면 '높음'
--     10001이상이면 '최상위'
--     출력형식 : "사원명, 급여금액, 급여수준:중간"
DECLARE
  vn_dept_id NUMBER := 0;
  vs_emp_name employees.emp_name%TYPE;
  vn_salary NUMBER := 0;
BEGIN
  -- 가상의 부서번호 생성
  vn_dept_id := ROUND(DBMS_RANDOM.VALUE(10, 120), -1);
  DBMS_OUTPUT.put_line('부서번호 = ' || vn_dept_id);
  -- 첫번째 사원의 급여 조회
  SELECT emp_name, salary
    INTO vs_emp_name, vn_salary
    FROM employees
   WHERE department_id = vn_dept_id
     AND rownum = 1;
    DBMS_OUTPUT.put_line('첫번째 사원의 급여 = ' || vn_salary);
    -- IF조건문으로 출력
    IF vn_salary < 3000 THEN
    DBMS_OUTPUT.put_line(vs_emp_name || ', ' || vn_salary || ', ' || '급여수준 : 낮음');
    ELSIF vn_salary BETWEEN 3000 AND 6000 THEN
    DBMS_OUTPUT.put_line(vs_emp_name || ', ' || vn_salary || ', ' || '급여수준 : 중간');
    ELSIF vn_salary BETWEEN 6001 AND 10000 THEN
    DBMS_OUTPUT.put_line(vs_emp_name || ', ' || vn_salary || ', ' || '급여수준 : 높음');
    ELSE DBMS_OUTPUT.put_line(vs_emp_name || ', ' || vn_salary || ', ' || '급여수준 : 최상위');
    END IF;
END;

-- 6.2 CASE 조건문
-- (1) DBMS_RANDOM패키지를 이용해 10~120사이의 숫자를 생성해 부서번호로 생성
--     그 부서의 첫번째 사원의 급여를 조회해 (rownum = 1)
--     급여가 3000보다 적으면 '낮음'
--     3000~6000사이면 '중간'
--     6001~10000사이면 '높음'
--     10001이상이면 '최상위'
--     출력형식 : "사원명, 급여금액, 급여수준:중간"
DECLARE
  vn_dept_id NUMBER := 0;
  vs_emp_name employees.emp_name%TYPE;
  vn_salary NUMBER := 0;
BEGIN
  -- 가상의 부서번호 생성
  vn_dept_id := ROUND(DBMS_RANDOM.VALUE(10, 120), -1);
  DBMS_OUTPUT.put_line('부서번호 = ' || vn_dept_id);
  -- 첫번째 사원의 급여 조회
  SELECT emp_name, salary
    INTO vs_emp_name, vn_salary
    FROM employees
   WHERE department_id = vn_dept_id
     AND rownum = 1;
    DBMS_OUTPUT.put_line('첫번째 사원의 급여 = ' || vn_salary);
  -- CASE조건문의 1번째 유형으로 출력
    CASE
      WHEN vn_salary < 3000 THEN
        DBMS_OUTPUT.put_line(vs_emp_name || ', ' || vn_salary || ', ' || '급여수준 : 낮음');
      WHEN vn_salary BETWEEN 3000 AND 6000 THEN
        DBMS_OUTPUT.put_line(vs_emp_name || ', ' || vn_salary || ', ' || '급여수준 : 중간');
      WHEN vn_salary BETWEEN 6001 AND 10000 THEN
        DBMS_OUTPUT.put_line(vs_emp_name || ', ' || vn_salary || ', ' || '급여수준 : 높음');
      ELSE DBMS_OUTPUT.put_line(vs_emp_name || ', ' || vn_salary || ', ' || '급여수준 : 최상위');
    END CASE;
END;

-- (2) 오늘날짜를 내장함수(TO_CHAR())를 이용해 요일의 값을 산출
--     요일의 값이 1이면 '오늘은 일요일입니다', 2면 '오늘을 월요일입니다.'를 7까지 출력
DECLARE
  vn_day NUMBER := TO_CHAR(sysdate, 'D'); -- 내장함수는 직접 호출 가능
BEGIN
  
  -- CASE조건문의 2번째 유형으로 출력
    CASE vn_day
      WHEN 1 THEN
        DBMS_OUTPUT.put_line('오늘은 일요일입니다.');
      WHEN 2 THEN
        DBMS_OUTPUT.put_line('오늘은 월요일입니다.');
      WHEN 3 THEN
        DBMS_OUTPUT.put_line('오늘은 화요일입니다.');
      WHEN 4 THEN
        DBMS_OUTPUT.put_line('오늘은 수요일입니다.');
      WHEN 5 THEN
        DBMS_OUTPUT.put_line('오늘은 목요일입니다.'); 
      WHEN 6 THEN
        DBMS_OUTPUT.put_line('오늘은 금요일입니다.'); 
      ELSE DBMS_OUTPUT.put_line('오늘은 토요일입니다.'); 
    END CASE;
END;

-- 6-3. LOOP 반복문
-- (1) 구구단 3단
DECLARE
  vn_base_num NUMBER := 3;
  vn_cnt NUMBER := 1;
BEGIN
  LOOP
    DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || vn_cnt || '= '
                          || vn_base_num * vn_cnt);
    vn_cnt := vn_cnt + 1;
    
    EXIT WHEN vn_cnt > 9;
  END LOOP;
END;

-- (2) 2~50까지의 정수 중 소수를 구하시오
-- 이중 LOOP문 사용
DECLARE
  vn_cnt NUMBER := 2; -- 50까지 증가하는 수
  j NUMBER;
BEGIN
  LOOP
  
    j := 2;
    LOOP
      
      -- j로 나누어 나머지가 0이면 LOOP를 EXIT한다.
      EXIT WHEN (MOD(vn_cnt, j) = 0);
      j := j + 1;
    END LOOP;
    
    IF vn_cnt = j THEN
       DBMS_OUTPUT.put(vn_cnt || ', ');
    END IF;
    
    vn_cnt := vn_cnt + 1;
    EXIT WHEN vn_cnt > 50;
  END LOOP;
  DBMS_OUTPUT.put_line('');
END;

-- 6-4. WHILE LOOP
-- (1) 구구단 3단
DECLARE
  vn_base_num NUMBER := 3;
  vn_cnt NUMBER := 0 ;
BEGIN
  WHILE vn_cnt <= 9
  LOOP
    DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || vn_cnt || '= '
                          || vn_base_num * vn_cnt);
    vn_cnt := vn_cnt + 1;
  END LOOP;
END;  

-- 6-5. FOR LOOP
-- (1) 구구단 3단
DECLARE
  vn_base_num NUMBER := 3;
BEGIN
  FOR i IN 1..9
  LOOP
    DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || i || '= '
                          || vn_base_num * i);
  END LOOP;
END;

-- (2) employes테이블에서 전체 사원의 수를 조회
--     FOR LOOP를 이용해 위의 사원 수 만큼 emp_temp테이블에 데이터를 insert
-- emp_temp테이블 생성
CREATE TABLE emp_temp(
    emp_id NUMBER,         -- index값
    emp_email VARCHAR2(30) -- anyone@email.com
);

DECLARE
  vn_rec_cnt NUMBER;
BEGIN
  SELECT count(*)
    INTO vn_rec_cnt
    FROM employees;
    
  FOR i IN 1..vn_rec_cnt
  LOOP
  
    INSERT INTO emp_temp(emp_id, emp_email) VALUES(i, 'anyone@email.com');
  END LOOP;
END;

-- 6-5. CONTINUE
-- (1) 구구단 3단
DECLARE
  vn_base_num NUMBER := 3;
BEGIN
  FOR i IN 1..9
  LOOP
    CONTINUE WHEN i = 5;
    DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || i || '= '
                          || vn_base_num * i);
  END LOOP;
END;

-- 6-6. GOTO
-- (1) 구구단 3단 중 i가 지정한 숫자가 됐을 때 4단으로 넘어가기
DECLARE
  vn_base_num NUMBER := 3;
BEGIN
  <<third>>
  FOR i IN 1..9
  LOOP
    DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || i || '= ' || vn_base_num * i);
    IF i=3 THEN GOTO fourth;
    END IF;
  END LOOP;
  <<fourth>>
    vn_base_num := 4;
  FOR i IN 1..9
  LOOP
    DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || i || '= ' || vn_base_num * i);
  END LOOP;
END;