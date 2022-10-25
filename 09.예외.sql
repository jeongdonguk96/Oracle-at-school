-- 예외처리
-- 프로시저 호출의 2가지 방법

-- 1. 예외처리가 없는 익명블록
DECLARE
  vn_num NUMBER := 0;
BEGIN
  vn_num := vn_num / 0; -- 예외 발생지점
  DBMS_OUTPUT.PUT_LINE('DONE');
END;

-- 1-2. 위를 예외처리한 익명블록
DECLARE
  vn_num NUMBER := 0;
BEGIN
  vn_num := vn_num / 0; -- 예외 발생지점
  DBMS_OUTPUT.PUT_LINE('DONE');
  
  EXCEPTION WHEN others THEN
  DBMS_OUTPUT.PUT_LINE('예외가 발생했습니다.');
END;
-----------------------------------------------------------------------------------------
-- 2. 예외처리가 없는 프로시저
CREATE OR REPLACE PROCEDURE no_exception_proc
IS
  vn_num NUMBER := 0;
BEGIN
  vn_num := vn_num / 0; -- 예외 발생지점
  DBMS_OUTPUT.PUT_LINE('DONE');
END;

-- 예외처리가 없는 프로시저 호출
DECLARE

BEGIN
  no_exception_proc();
  DBMS_OUTPUT.PUT_LINE('DONE');
END;

-- 2-2. 위를 예외처리한 프로시저
CREATE OR REPLACE PROCEDURE exception_proc
IS
  vn_num NUMBER := 0;
BEGIN
  vn_num := vn_num / 0; -- 예외 발생지점
  DBMS_OUTPUT.PUT_LINE('DONE');
  
  EXCEPTION WHEN others THEN
  -- DBMS_OUTPUT.PUT_LINE('예외가 발생했습니다.');
  DBMS_OUTPUT.PUT_LINE('예외의 오류 코드 = ' || SQLCODE ); -- SQLCODE : 예외코드
  DBMS_OUTPUT.PUT_LINE('예외의 오류 메세지 = ' || SQLERRM ); -- SQLEERM : 예외 정보
  DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 예외 발생지점 표시
END;

-- 예외처리한 프로시저 호출
DECLARE

BEGIN
  exception_proc();
  DBMS_OUTPUT.PUT_LINE('DONE');
END;
-----------------------------------------------------------------------------------------
-- 예외처리 연습문제 1
-- 사원번호와 직책번호를 파라미터로 받아 해당 사원의 직책번호를 갱신하는 프로시저를 작성
-- 입력받은 사원번호가 없는 사원번호라면 예외처리를 이용
CREATE OR REPLACE PROCEDURE p_upd_jobid(vn_employee_id employees.employee_id%TYPE,
                                        vs_job_id jobs.job_id%TYPE)
IS
  v_job_id jobs.job_id%TYPE;
BEGIN
  SELECT job_id
    INTO v_job_id
    FROM jobs
   WHERE job_id = vs_job_id;
 
  UPDATE employees
     SET job_id = vs_job_id
   WHERE employee_id = vn_employee_id;
  commit;
  
  EXCEPTION
    WHEN no_data_found THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      DBMS_OUTPUT.PUT_LINE(vs_job_id || '에 해당하는 job_id가 없습니다.');
    WHEN others THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- 예외처리한 프로시저 호출
EXEC p_upd_jobid(207, 'ST_EMP');
-----------------------------------------------------------------------------------------
-- 3. 사용자 정의 예외
-- 매개변수에 부서번호가 잘못 들어왔을 경우 예외 처리
-- 사원명, 부서번호를 입력받아 사원테이블에 insert, 부서번호가 틀리면 예외처리
CREATE OR REPLACE PROCEDURE ch07_ins_emp_proc (p_emp_name employees.emp_name%TYPE,
                                               p_department_id departments.department_id%TYPE )
IS
  vn_employee_id employees.employee_id%TYPE;
  vd_curr_date DATE := SYSDATE;
  vn_cnt NUMBER := 0;
  ex_invalid_depid EXCEPTION; -- 잘못된 부서번호일 경우 예외 선언
BEGIN
  SELECT COUNT(*) -- 부서 테이블에서 해당 부서번호 존재유무 체크
    INTO vn_cnt FROM departments
   WHERE department_id = p_department_id;
  
  IF vn_cnt = 0 THEN
    RAISE ex_invalid_depid;
  END IF;

  SELECT MAX(employee_id) + 1 -- employee_id의 max값에 +1
    INTO vn_employee_id
    FROM employees;
    
-- 사용자 예외처리 예제이므로 최소한의 데이터만 입력
  INSERT INTO employees (employee_id, emp_name, hire_date, department_id)
         VALUES (vn_employee_id, p_emp_name, vd_curr_date, p_department_id );
  COMMIT;
  
  EXCEPTION
    WHEN ex_invalid_depid THEN
    DBMS_OUTPUT.PUT_LINE('해당 부서번호가 없습니다');
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
-- 예외처리한 프로시저 호출
EXEC ch07_ins_emp_proc('홍길동', 999);
-----------------------------------------------------------------------------------------
-- 사용자 정의 예외처리 연습문제 1
-- 프로시저명 : grade_output_procp(p_grade char)
-- CASE조건문을 이용해 학점에 따라 A:매우 우수, B:우수, C:보통, D:부족, F:과락을 출력하는 프로시저 작성
-- 학점이 없을 때 사용자 정의 예외를 발생시킨다 - 예외명 : ex_grade_not_found
-- 출력 예 : 당신의 학점은 OO입니다. or 존재하지 않는 등급입니다.
CREATE OR REPLACE PROCEDURE grade_output_proc(p_grade CHAR)

IS
  vs_grade VARCHAR2(20);
  ex_invalid_grade EXCEPTION;
BEGIN

  CASE
    WHEN p_grade = 'A' THEN
      vs_grade := '매우 우수';
    WHEN p_grade = 'B' THEN
      vs_grade := '우수';
    WHEN p_grade = 'C' THEN
      vs_grade := '중간';
    WHEN p_grade = 'D' THEN
      vs_grade := '낮음';
    WHEN p_grade = 'F' THEN
      vs_grade := '과락';
    ELSE
    RAISE ex_invalid_grade;
  END CASE;
  
  DBMS_OUTPUT.PUT_LINE('당신의 학점은 ' || vs_grade || '입니다.');
  
  EXCEPTION
  WHEN ex_invalid_grade THEN
  DBMS_OUTPUT.PUT_LINE('존재하지 않는 등급입니다.');
  WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE(SQLERRM);
  
END;
-- 예외처리한 프로시저 호출
EXEC grade_output_proc('F');
-----------------------------------------------------------------------------------------
-- 4.프라그마 예외 - 사용자 정의 예외를 실제 예외명과 예외코드로 등록
-- 프라그마 예외 연습문제 1
-- 매개변수에 부서번호가 잘못 들어왔을 경우 예외 처리
-- 사원명, 부서번호, 입사월을 입력받아 사원테이블에 insert
-- 입사월이 틀리거나 부서번호가 틀리면 예외처리
CREATE OR REPLACE PROCEDURE ch07_ins_emp_proc (p_emp_name employees.emp_name%TYPE,
                                               p_department_id departments.department_id%TYPE,
                                               p_hire_month VARCHAR2)
IS
  vn_employee_id employees.employee_id%TYPE;
  vd_curr_date DATE := SYSDATE;
  vn_cnt NUMBER := 0;
  ex_invalid_depid EXCEPTION; -- 잘못된 부서번호일 경우 예외 선언
  ex_invalid_month EXCEPTION; -- 잘못된 입사월일 경우 예외 선언
  PRAGMA EXCEPTION_INIT(ex_invalid_month, -20001); -- 예외를 실제로 생성(예외명과 예외코드 연결)
BEGIN
  SELECT COUNT(*) -- 부서 테이블에서 해당 부서번호 존재유무 체크
    INTO vn_cnt FROM departments
   WHERE department_id = p_department_id;
  
  IF vn_cnt = 0 THEN
    RAISE ex_invalid_depid;
  END IF;
  
  IF SUBSTR(p_hire_month, 5, 2) NOT BETWEEN '01' AND '12' THEN
    RAISE ex_invalid_month;
  END IF;
    
  SELECT MAX(employee_id) + 1 -- employee_id의 max값에 +1
    INTO vn_employee_id
    FROM employees;
    
-- 사용자 예외처리 예제이므로 최소한의 데이터만 입력
  INSERT INTO employees (employee_id, emp_name, hire_date, department_id)
         VALUES (vn_employee_id, p_emp_name, TO_DATE(p_hire_month || '01'), p_department_id );
  COMMIT;
  
  EXCEPTION
    WHEN ex_invalid_depid THEN
      DBMS_OUTPUT.PUT_LINE('해당 부서번호가 없습니다.');
    WHEN ex_invalid_month THEN
      DBMS_OUTPUT.PUT_LINE(SQLCODE);
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      DBMS_OUTPUT.PUT_LINE('월의 범위가 아닙니다.');
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
    
END;
-- 예외처리한 프로시저 호출
EXEC ch07_ins_emp_proc('홍길동', 110, '202214');
-----------------------------------------------------------------------------------------
-- 5. RAISE APPLICATION ERROR - 사용자 정의 예외를 예외발생 시점에 직접 매개변수로 작성
-- RAISE APPLICATION ERROR 연습문제 1
-- 매개변수로 양수만 입력받아 처리하는 프로시저
CREATE OR REPLACE PROCEDURE ch07_raise_test_proc(p_num NUMBER)
IS
BEGIN
  IF p_num < 0 THEN
    RAISE_APPLICATION_ERROR (-20000, '양수만 입력받을 수 있습니다!'); -- 예외발생 때 예외코드, 메세지 등록
  END IF;
  
  DBMS_OUTPUT.PUT_LINE(p_num);

  EXCEPTION
  WHEN INVALID_NUMBER THEN
    DBMS_OUTPUT.PUT_LINE('양수만 입력 가능합니다!');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLCODE);
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

EXEC ch07_raise_test_proc(-1);
-----------------------------------------------------------------------------------------
-- 6. 효율적인 예외 처리
-- 에러 로그 테이블 생성 - 예외처리 관리 테이블
CREATE TABLE error_log (
error_seq NUMBER, -- 에러 시퀀스
prog_name VARCHAR2(80), -- 프로그램명
error_code NUMBER, -- 에러 코드
error_message VARCHAR2(300), -- 에러 메시지
error_line VARCHAR2(100), -- 에러 라인
error_date DATE DEFAULT SYSDATE -- 에러 발생 일자
);

-- 에러 로그 프로시저
CREATE OR REPLACE PROCEDURE error_log_proc ( p_prog_name error_log.prog_name%TYPE,
                                             p_error_code error_log.error_code%TYPE,
                                             p_error_message error_log.error_message%TYPE,
                                             p_error_line error_log.error_line%TYPE )
IS
BEGIN
  INSERT INTO error_log (error_seq, prog_name, error_code, error_message, error_line)
  VALUES (error_seq.NEXTVAL, p_prog_name, p_error_code, p_error_message, p_error_line);

  COMMIT;
END;

-- (1) 예외테이블 연습문제 1
CREATE OR REPLACE PROCEDURE ch07_ins_emp_proc (p_emp_name employees.emp_name%TYPE,
                                               p_department_id departments.department_id%TYPE,
                                               p_hire_month VARCHAR2)
IS
  vs_proc_name VARCHAR2(100) := 'ch07_ins_emp_proc';
  vn_employee_id employees.employee_id%TYPE;
  vd_curr_date DATE := SYSDATE;
  vn_cnt NUMBER := 0;
  ex_invalid_depid EXCEPTION; -- 잘못된 부서번호일 경우 예외 선언
  PRAGMA EXCEPTION_INIT(ex_invalid_depid, -20000);
  ex_invalid_month EXCEPTION; -- 잘못된 입사월일 경우 예외 선언
  PRAGMA EXCEPTION_INIT(ex_invalid_month, -20001);
  v_error_code error_log.error_code%TYPE; -- 예외관리테이블의 내용을 담을 변수
  v_error_message error_log.error_message%TYPE; -- 예외관리테이블의 내용을 담을 변수
  v_error_line error_log.error_line%TYPE; -- 예외관리테이블의 내용을 담을 변수
BEGIN
  SELECT COUNT(*) -- 부서 테이블에서 해당 부서번호 존재유무 체크
    INTO vn_cnt FROM departments
   WHERE department_id = p_department_id;
  
  IF vn_cnt = 0 THEN
    RAISE ex_invalid_depid;
  END IF;
  
  IF SUBSTR(p_hire_month, 5, 2) NOT BETWEEN '01' AND '12' THEN
    RAISE ex_invalid_month;
  END IF;
    
  SELECT MAX(employee_id) + 1 -- employee_id의 max값에 +1
    INTO vn_employee_id
    FROM employees;
    
    INSERT INTO employees (employee_id, emp_name, hire_date, department_id)
         VALUES (vn_employee_id, p_emp_name, TO_DATE(p_hire_month || '01'), p_department_id );
  COMMIT;
  
  EXCEPTION
    WHEN ex_invalid_depid THEN
      v_error_code := SQLCODE;
      v_error_message := '해당 부서번호가 없습니다.';
      v_error_line := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      rollback;
      error_log_proc(vs_proc_name, v_error_code, v_error_message, v_error_line);
    WHEN ex_invalid_month THEN
      v_error_code := SQLCODE;
      v_error_message := SQLERRM;
      v_error_line := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      rollback;
      error_log_proc(vs_proc_name, v_error_code, v_error_message, v_error_line);
    WHEN OTHERS THEN
      v_error_code := SQLCODE;
      v_error_message := SQLERRM;
      v_error_line := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      rollback;
      error_log_proc(vs_proc_name, v_error_code, v_error_message, v_error_line);
    
END;
-- ch07_ins_emp_proc() 실행
EXEC ch07_ins_emp_proc('홍길동', 350, '202210'); -- 부서번호가 틀린 문장
EXEC ch07_ins_emp_proc('홍길동', 110, '202215'); -- 입사월이 틀린 문장

-- 사용자 정의 예외 테이블 생성
CREATE TABLE app_user_define_error (
  error_code NUMBER, -- 에러 코드
  error_message VARCHAR2(300), -- 에러 메시지
  create_date DATE DEFAULT SYSDATE, -- 에러 발생 일자
  PRIMARY KEY (error_code)
);

INSERT INTO app_user_define_error (error_code, error_message)
VALUES (-20001, '지정한 월이 부적합합니다.');
INSERT INTO app_user_define_error (error_code, error_message)
VALUES (-20000, '해당 부서가 없습니다.');

COMMIT;

-- APP_USER_DEFINE_ERROR(사용자 정의 예외)테이블을 이용한 예외처리 수정
CREATE OR REPLACE PROCEDURE error_log_proc ( p_prog_name error_log.prog_name%TYPE,
                                             p_error_code error_log.error_code%TYPE,
                                             p_error_message error_log.error_message%TYPE,
                                             p_error_line error_log.error_line%TYPE )
IS
  vs_error_message error_log.error_message%TYPE;
BEGIN
  
  BEGIN
    -- 에러코드를 조건으로 app_user_define_error테이블 조회
    SELECT error_message
      INTO vs_error_message
      FROM app_user_define_error
     WHERE error_code = p_error_code;
  
    -- 에러코드가 존재하지 않으면 예외 처리
    EXCEPTION
      WHEN no_data_found THEN
        vs_error_message := p_error_message;
  END;
  
  INSERT INTO error_log (error_seq, prog_name, error_code, error_message, error_line)
       VALUES (error_seq.NEXTVAL, p_prog_name, p_error_code, vs_error_message, p_error_line);

  COMMIT;
END;

-- APP_USER_DEFINE_ERROR테이블을 사용한 예외 입력처리 연습문제 1
CREATE OR REPLACE PROCEDURE ch07_ins_emp_proc (p_emp_name employees.emp_name%TYPE,
                                               p_department_id departments.department_id%TYPE,
                                               p_hire_month VARCHAR2)
IS
  vs_proc_name VARCHAR2(100) := 'ch07_ins_emp_proc';
  vn_employee_id employees.employee_id%TYPE;
  vd_curr_date DATE := SYSDATE;
  vn_cnt NUMBER := 0;
  ex_invalid_depid EXCEPTION; -- 잘못된 부서번호일 경우 예외 선언
  PRAGMA EXCEPTION_INIT(ex_invalid_depid, -20000);
  ex_invalid_month EXCEPTION; -- 잘못된 입사월일 경우 예외 선언
  PRAGMA EXCEPTION_INIT(ex_invalid_month, -20001);
  v_error_code error_log.error_code%TYPE; -- 예외관리테이블의 내용을 담을 변수
  v_error_message error_log.error_message%TYPE; -- 예외관리테이블의 내용을 담을 변수
  v_error_line error_log.error_line%TYPE; -- 예외관리테이블의 내용을 담을 변수
BEGIN
  SELECT COUNT(*) -- 부서 테이블에서 해당 부서번호 존재유무 체크
    INTO vn_cnt FROM departments
   WHERE department_id = p_department_id;
  
  IF vn_cnt = 0 THEN
    RAISE ex_invalid_depid;
  END IF;
  
  IF SUBSTR(p_hire_month, 5, 2) NOT BETWEEN '01' AND '12' THEN
    RAISE ex_invalid_month;
  END IF;
    
  SELECT MAX(employee_id) + 1 -- employee_id의 max값에 +1
    INTO vn_employee_id
    FROM employees;
    
    INSERT INTO employees (employee_id, emp_name, hire_date, department_id)
         VALUES (vn_employee_id, p_emp_name, TO_DATE(p_hire_month || '01'), p_department_id );
  COMMIT;
  
  EXCEPTION
    WHEN ex_invalid_depid THEN
      v_error_code := SQLCODE;
      v_error_line := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      rollback;
      error_log_proc(vs_proc_name, v_error_code, v_error_message, v_error_line);
    WHEN ex_invalid_month THEN
      v_error_code := SQLCODE;
      v_error_line := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      rollback;
      error_log_proc(vs_proc_name, v_error_code, v_error_message, v_error_line);
    WHEN OTHERS THEN
      v_error_code := SQLCODE;
      v_error_message := SQLERRM;
      v_error_line := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      rollback;
      error_log_proc(vs_proc_name, v_error_code, v_error_message, v_error_line);
    
END;
delete ERROR_LOG;
COMMIT;

-- ch07_ins_emp_proc() 실행
EXEC ch07_ins_emp_proc('홍길동', 400, '202210'); -- 부서번호가 틀린 문장
EXEC ch07_ins_emp_proc('홍길동', 110, '202215'); -- 입사월이 틀린 문장
-----------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------