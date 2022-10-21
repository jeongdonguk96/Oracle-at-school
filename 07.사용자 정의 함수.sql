-- 1. 사용자 정의 함수
-- 1-1. 매개변수가 있는 함수 
-- (1)나머지를 반환하는 함수 생성 : my_mod()
CREATE OR REPLACE FUNCTION my_mod(num1 NUMBER, num2 NUMBER)
  RETURN NUMBER
IS -- 변수선언부
  vn_quotient NUMBER; -- 몫 저장
  vn_remainder NUMBER; -- 나머지 저장
BEGIN
  vn_quotient := TRUNC(num1 / num2);
  vn_remainder := num1 - (num2 * vn_quotient);
  
  RETURN vn_remainder;
END;

-- (*)사용자 정의 함수 사용방법
-- (1) SELECT문에서 사용
SELECT my_mod(14,3) FROM dual;
-- (2) 익명프로시저에서 호출
DECLARE
  num1 NUMBER := 10;
  num2 NUMBER := 3;
BEGIN
  
  DBMS_OUTPUT.put_line('10을 3으로 나눈 나머지 = ' || my_mod(num1, num2));
END;

-- (2) 국가번호를 매개변수로 받아 countrie테이블을 조회해
--      국가명을 반환하는 함수
--      함수명 : fn_get_country_name(p.country_id NUMBER)
CREATE OR REPLACE FUNCTION fn_get_country_name(p_country_id NUMBER)
  RETURN VARCHAR2
IS
  vs_country_name VARCHAR2(40);
BEGIN
  SELECT country_name
    INTO vs_country_name
    FROM countries
   WHERE country_id = p_country_id;
  
  RETURN vs_country_name;
END;

-- SELECTG문에서 실행
SELECT fn_get_country_name(52776) FROM dual;
-- 익명프로시저에서 실행
DECLARE
  vn_country_id countries.country_id%TYPE;
BEGIN
  vn_country_id := 52778;
  
  DBMS_OUTPUT.PUT_line(vn_country_id || ' : ' || fn_get_country_name(vn_country_id));
END;

-- fn_get_country_name() 함수 수정
-- 국가코드가 없는 경우 '해당 국가 없음'으로 표시
CREATE OR REPLACE FUNCTION fn_get_country_name(p_country_id NUMBER)
  RETURN VARCHAR2
IS
  vs_country_name VARCHAR2(40);
  vn_count NUMBER;
BEGIN
  SELECT COUNT(*) -- 국가코드 존재여부 확인
    INTO vn_count
    FROM countries
   WHERE country_id = p_country_id;

  IF vn_count = 0 THEN
     vs_country_name := '해당 국가 없음';
  ELSE
    SELECT country_name
      INTO vs_country_name
      FROM countries
     WHERE country_id = p_country_id;
  END IF;
   
  RETURN vs_country_name;
END;

-- (3) 사용자 정의 함수 연습문제
-- 함수명: fn_get_max_sales(p_country_id NUMBER)
-- 국가id를 입력 받아 그 국적의 고객에 대해 최대 판매액을 구하는 함수 작성
-- 매개변수의 국가id가 없으면 최대 판매액을 0을 반환
-- 관련 테이블: CUSTOMERS, SALES
CREATE OR REPLACE FUNCTION fn_get_max_sales(p_country_id NUMBER)
RETURN NUMBER
IS
    vn_count     NUMBER;
    vn_max_sales NUMBER;
BEGIN
    -- 국가코드 존재여부 확인
    SELECT COUNT(*)
        INTO  vn_count
       FROM countries
     WHERE country_id = p_country_id;
     
    IF vn_count=0 THEN
        vn_max_sales := 0;
    ELSE
        SELECT MAX(AMOUNT_SOLD)
            INTO  vn_max_sales
           FROM customers c, sales s
         WHERE c.cust_id=s.cust_id
              AND c.country_id = p_country_id;
    END IF;
    
    return vn_max_sales;
END;

-- fn_get_max_sales() 테스트
SELECT fn_get_max_sales(10000) FROM dual;


-- 2.프로시져
-- (1) jobs테이블에 신규 직책을 insert하는 프로시져
CREATE OR REPLACE PROCEDURE my_new_job_proc
  (p_job_id IN jobs.job_id%TYPE,
   p_job_title IN jobs.job_title%TYPE,
   p_min_salary IN jobs.min_salary%TYPE,
   p_max_salary IN jobs.max_salary%TYPE)
IS
BEGIN
  INSERT INTO jobs(job_id, job_title, min_salary, max_salary)
  VALUES(p_job_id, p_job_title, p_min_salary, p_max_salary);
  commit;
END;
-- 프로시저 실행
EXEC my_new_job_proc('SM_JOB1', 'SAMPLE JOB1', 1000, 5000);

-- (2) my_new_job_proc()를 수정해 job_id의 데이터가 있으면 update 없으면 insert하도록 수정
CREATE OR REPLACE PROCEDURE my_new_job_proc
  (p_job_id IN jobs.job_id%TYPE,
   p_job_title IN jobs.job_title%TYPE,
   p_min_salary IN jobs.min_salary%TYPE,
   p_max_salary IN jobs.max_salary%TYPE)
IS
  vn_cnt NUMBER := 0;
BEGIN
  SELECT COUNT(*) INTO vn_cnt
    FROM jobs
   WHERE job_id = p_job_id;
   
  IF vn_cnt = 0 THEN
    INSERT INTO jobs(job_id, job_title, min_salary, max_salary)
    VALUES(p_job_id, p_job_title, p_min_salary, p_max_salary);
  ELSE
    UPDATE jobs
       SET job_title = p_job_title, min_salary = p_min_salary,
           max_salary = p_max_salary, update_date = sysdate
     WHERE job_id = p_job_id;
  END IF;
  
  commit;
END;  
-- 프로시저 실행
EXEC my_new_job_proc('SM_JOB1', 'SAMPLE 직책', 2000, 4000);
EXEC my_new_job_proc('SM_JOB2', '직책2', 3000, 5000);
-- 프로시저 실행방법 2 - =>사용
EXEC my_new_job_proc(p_job_id => 'SM_JOB3', p_job_title => 'SAMPLE 직책3', p_min_salary => 5000, p_max_salary => 8000);

-- 2-1. 프로시저 매개변수의 기본값 설정
CREATE OR REPLACE PROCEDURE my_new_job_proc
  (p_job_id IN jobs.job_id%TYPE,
   p_job_title IN jobs.job_title%TYPE,
   p_min_salary IN jobs.min_salary%TYPE := 1000,
   p_max_salary IN jobs.max_salary%TYPE := 5000)
IS
BEGIN
  INSERT INTO jobs(job_id, job_title, min_salary, max_salary)
  VALUES(p_job_id, p_job_title, p_min_salary, p_max_salary);
  commit;
END;
-- 프로시저 확인
EXEC my_new_job_proc('SM_JOB4', '직책4');

-- 2-2. OUT매개변수
CREATE OR REPLACE PROCEDURE my_new_job_proc
  (p_job_id IN jobs.job_id%TYPE,
   p_job_title IN jobs.job_title%TYPE,
   p_min_salary IN jobs.min_salary%TYPE := 1000,
   p_max_salary IN jobs.max_salary%TYPE := 5000,
   p_upd_date OUT jobs.update_date%TYPE)
IS
  vn_cnt NUMBER := 0;
  vd_cur_date jobs.update_date%TYPE := sysdate;
BEGIN
  SELECT COUNT(*) INTO vn_cnt
    FROM jobs
   WHERE job_id = p_job_id;
   
  IF vn_cnt = 0 THEN
    INSERT INTO jobs(job_id, job_title, min_salary, max_salary)
    VALUES(p_job_id, p_job_title, p_min_salary, p_max_salary);
  ELSE
    UPDATE jobs
       SET job_title = p_job_title, min_salary = p_min_salary,
           max_salary = p_max_salary, update_date = vd_cur_date
     WHERE job_id = p_job_id;
  END IF;
  
  p_upd_date := vd_cur_date; -- 업데이트시 사용한 값은 out매개변수에 저장
  commit;
END;
-- OUT매개변수 테스트
DECLARE
  vd_upd_date jobs.update_date%TYPE;
BEGIN
  my_new_job_proc('TEST JOB6', '직책 7', 3000, 7000, vd_upd_date);
  
  DBMS_OUTPUT.PUT_LINE('업데이트 일자 : ' || vd_upd_date);
END;

-- 2-3. IN, OUT, IN OUT매개변수 사용
CREATE OR REPLACE PROCEDURE my_param_test_proc(
  p_var1 VARCHAR2, -- IN매개변수
  p_var2 OUT VARCHAR2, -- OUT매개변수 (값이 넣어지지 않음)
  p_var3 IN OUT VARCHAR2) -- IN OUT매개변수
IS

BEGIN
  -- 입력 매개변수의 출력
  DBMS_OUTPUT.PUT_LINE('p_var1 = ' || p_var1);
  DBMS_OUTPUT.PUT_LINE('p_var2 = ' || p_var2);
  DBMS_OUTPUT.PUT_LINE('p_var3 = ' || p_var3);
  
  -- 출력 매개변수에 값을 저장
  p_var2 := 'B2';
  p_var3 := 'C2';
END;
-- my_param_test_proc() 테스트
DECLARE
  v_var1 VARCHAR2(10) := 'A';
  v_var2 VARCHAR2(10) := 'B';
  v_var3 VARCHAR2(10) := 'C';
BEGIN
  my_param_test_proc(v_var1, v_var2, v_var3);
  
  DBMS_OUTPUT.PUT_LINE('v_var1 = ' || v_var1);
  DBMS_OUTPUT.PUT_LINE('v_var2 = ' || v_var2);
  DBMS_OUTPUT.PUT_LINE('v_var3 = ' || v_var3);
END;

-- (1) 연습용테이블 dept_temp 생성
--     departments테이블에서 부서번호, 부서명, parent_id컬럼을 복사해서 생성
CREATE TABLE dept_temp AS
SELECT department_id, department_name, parent_id
  FROM departments;
  
-- 위의 테이블로 프로시저 작성 : my_dept_manager_proc()
-- 매개변수 : p_dept_id, p_dept_name, p_parent_id, p_flag
-- p_flag : 값이 'upsert'이면 테이블 내용을 update하거나 insert 수행
--          값이 'delete'이면 해당 부서를 삭제 -> 부서가 없으면 '부서가 없습니다.' 출력
--          update일 경우 업데이트할 내용이 존재하는지 확인
CREATE OR REPLACE PROCEDURE my_dept_manager_proc
  (p_dept_id IN dept_temp.department_id%TYPE,
   p_dept_name IN dept_temp.department_name%TYPE,
   p_parent_id IN dept_temp.parent_id%TYPE,
   p_flag IN VARCHAR2)
IS
   vn_count NUMBER := 0;
BEGIN
  SELECT COUNT(*)
    INTO vn_count
    FROM dept_temp
   WHERE department_id = p_dept_id;
  IF p_flag = 'upsert' THEN -- update 혹은 insert
    IF vn_count = 0 THEN
      INSERT INTO dept_temp VALUES(p_dept_id, p_dept_name, p_parent_id);
    ELSE 
      UPDATE dept_temp
         SET department_name = p_dept_name, parent_id = p_parent_id
       WHERE department_id = p_dept_id;
    END IF;
  ELSIF p_flag = 'delete' THEN -- 부서 삭제 수행
    IF vn_count = 0 THEN
         DBMS_OUTPUT.PUT_LINE('삭제할 부서가 존재하지 않습니다.');
    ELSE
      DELETE dept_temp
       WHERE department_id = p_dept_id;
    END IF;
  END IF;

commit;
END;

-- my_dept_managet_proc 테스트
EXEC my_dept_manager_proc(300, '테스트부서77', 100, 'upsert');
EXEC my_dept_manager_proc(270, '테스트부서2', 110, 'update');