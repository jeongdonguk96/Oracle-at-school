-- 1. 커서 -- 가상의 바구니
-- 커서라는 가상의 바구니에 기존테이블에 있던 내용을 담고, 반복문을 통해 다시 하나씩 꺼내는 방식으로 사용
-- 1-1. 암시적 커서(implicit)
-- (1) 80번 부서의 사원이름을 자신의 이름으로 갱신
DECLARE
  vn_department_id employees.employee_id%TYPE := 80;
BEGIN
  
  UPDATE employees
     SET emp_name = emp_name
   WHERE department_id = vn_department_id;
   
   -- 몇 건의 데이터가 수정되었는지 확인
   DBMS_OUTPUT.PUT_LINE('업데이트된 행의 수 : ' || SQL%ROWCOUNT);
   
   commit;   
END;

-- (2) 임시테이블 emp_temp 생성
-- employees테이블에서 employee_id, emp_name, email을 조회하여 생성
CREATE TABLE emp_temp AS
SELECT employee_id, emp_name, email
  FROM employees;

-- (2-1) 익명블록 작성
-- 사원명이 'B'로 시작하는 사람의 메일을 '이메일 없음'으로 수정하고
-- 업데이트한 행의 수를 출력
DECLARE
BEGIN
  UPDATE emp_temp
     SET email = '이메일 없음'
   WHERE emp_name LIKE 'B%';
   
   DBMS_OUTPUT.PUT_LINE('업데이트된 행의 수 : ' || SQL%ROWCOUNT);
END;

-- 1-2. 명시적 커서(explicit)
-- (1) 부서번호가 90번인 부서에 속한 사원의 이름을 출력하는 익명블록
DECLARE
  -- 사원명 받아오기 위한 변수 선언
  vs_emp_name employees.emp_name%TYPE;
  -- 커서 선언, 매개변수로 부서번호 받기
  CURSOR cur_emp_dep(cp_department_id employees.department_id%TYPE)
  IS
  SELECT emp_name
    FROM employees
   WHERE department_id = cp_department_id;
BEGIN
  -- 커서 오픈(매개변수로 90번 부서를 전달)
  OPEN cur_emp_dep(90);
  
  LOOP
    FETCH cur_emp_dep -- 커서 결과로 나온 행을 패치함(사원명 변수에 할당)
     INTO vs_emp_name; -- 패치된 참조행이 없으면 LOOP 탈출
EXIT WHEN cur_emp_dep%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE(vs_emp_name);
  END LOOP;
  
  CLOSE cur_emp_dep;
END;

-- (2) cd_parent_id를 입력받아 상위 부서에 속하는 사원명과 부서명를 출력하는 익명블록 작성
-- parent_id에 해당하는 데이터가 없을 경우 '~부서에 속하는 사원이 없습니다.' 출력 (SQL%ROWCOUNT이용)
-- 출력 예 - 홍길동 : 생산부
DECLARE
    CURSOR cur_emp_dep_name(cp_parent_id  departments.parent_id%TYPE)
    IS
    SELECT e.emp_name, d.department_name
    FROM employees e,  departments d
     WHERE d.parent_id = cp_parent_id
          AND e.department_id=d.department_id;

    -- 변수 선언
    vn_parent_id    departments.parent_id%TYPE;
    vs_emp_name  employees.emp_name%TYPE;
    vs_dept_name  departments.department_name%TYPE;
BEGIN
    vn_parent_id := 200;
    OPEN cur_emp_dep_name(vn_parent_id);
    
    LOOP
        FETCH cur_emp_dep_name INTO vs_emp_name, vs_dept_name;
        EXIT WHEN cur_emp_dep_name%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(vs_emp_name || ' : ' || vs_dept_name);
    END LOOP;
    
    IF cur_emp_dep_name%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE(vn_parent_id || '번 부서에 속하는 팀이 없습니다.');
    END IF;
    
    CLOSE cur_emp_dep_name;
END;

-- 위의 예제를 FOR LOOP를 사용하여 수정
DECLARE
    CURSOR cur_emp_dep_name(cp_parent_id  departments.parent_id%TYPE)
    IS
    SELECT e.emp_name, d.department_name
      FROM employees e, departments d
     WHERE d.parent_id = cp_parent_id
       AND e.department_id = d.department_id;
    -- 변수 선언
    vn_parent_id departments.parent_id%TYPE;
BEGIN
    vn_parent_id := 10;
    OPEN cur_emp_dep_name(vn_parent_id);
   -- FOR 레코드변수 IN 커서(파라메터) 
    FOR emp_rec IN cur_emp_dep_name(vn_parent_id)
    LOOP

        DBMS_OUTPUT.PUT_LINE(emp_rec.emp_name || ' : ' || emp_rec.department_name);
    END LOOP;    
    -- 자동으로 커서가 close됨
END;

-- 1-3 강한 커서 타입 - %ROWTYPE를 붙여줌으로써 한 컬럼이 아닌 모든 컬럼값을 나타내는 타입이 됨
DECLARE
  TYPE test_curtype IS REF CURSOR RETURN departmentsA%ROWTYPE; -- 커서 타입의 정의
  test_curvar test_curtype; -- curtype이라는 타입을 가진 curvar라는 커서변수 생성
BEGIN
  OPEN test_curvar FOR SELECT * FROM departments;
  
END;

-- 1-4 약한 커서 타입 - 타입을 따로 정해주지 않음으로써 유연한 사용 가능
-- 90번 부서에 속하는 사원의 사원명 조회
DECLARE
  test_cursor SYS_REFCURSOR;
  vs_emp_name employees.emp_name%TYPE;
BEGIN
  OPEN test_cursor FOR
SELECT emp_name
  FROM employees
 WHERE department_id = 90;
  
  LOOP 
    FETCH test_cursor INTO vs_emp_name;
    EXIT WHEN test_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(vs_emp_name);
  END LOOP;
END;

-- departments테이블에서 부서명과 employees테이블에서 관리자명을 출력하는 익명 프로시저 작성
-- 관련 테이블 : departments, employees / 약한 커서타입 사용
-- 출력예 : 부서명 - 관리자명
DECLARE
  dep_mng_cur sys_refcursor; -- 커서변수 선언
  vs_dept_name departments.department_name%TYPE; -- 부서명을 담을 변수 선언
  vs_mng_name employees.emp_name%TYPE; -- 관리자명을 담을 변수 선언
BEGIN
  OPEN dep_mng_cur FOR -- 커서변수 오픈, FOR은 다음에 오는 내용을 커서에 담는다는 의미
    SELECT d.department_name, e.emp_name  -- SELECT 이하의 내용을 커서에 담음
      FROM departments d, employees e 
     WHERE d.manager_id = e.employee_id;
  
  LOOP -- 커서는 내용을 담은 바구니라 반복을 통해 하나씩 꺼내오는 방식으로 사용해야 함
    FETCH dep_mng_cur INTO vs_dept_name, vs_mng_name; -- 커서를 변수들에 반복을 통해 담음
    EXIT WHEN dep_mng_cur%NOTFOUND; -- 커서에 아무런 내용이 남지 않을 때 반복문 종료
    
    DBMS_OUTPUT.PUT_LINE(vs_dept_name || ' - ' || vs_mng_name);
  END LOOP;
END;

-- 1-5. 커서변수의 매개변수 전달
-- 90번 부서에 속한 사원명을 출력
DECLARE
  emp_dept_curvar sys_refcursor; -- emp_dept_curvar라는 커서 선언
  vs_emp_name employees.emp_name%TYPE; -- vs_emp_name라는 변수 선언
  -- 여기서부터
  PROCEDURE test_cursor_argument(p_curvar IN OUT sys_refcursor) -- 90번 부서의 사원명 조회
  IS
    c_temp_curvar sys_refcursor;
  BEGIN
    OPEN c_temp_curvar FOR -- c_temp_curvar라는 커서에 90분 부서의 사원명을 담음
      SELECT emp_name FROM employees WHERE department_id = 90;
      
    p_curvar := c_temp_curvar;
  END;
  -- 여기까지가 하나의 프로시저
BEGIN
  test_cursor_argument(emp_dept_curvar); -- 프로시저에서 조회한 결과가 emp_dept_curvar에 담김
  
  LOOP
    FETCH emp_dept_curvar INTO vs_emp_name;
    EXIT WHEN emp_dept_curvar%NOTFOUND;
    
    DBMS_OUTPUT.PUT_LINE(vs_emp_name);
  END LOOP;
END;

-- 익명의 블록에 프로시저 작성
-- 프로시저에 월급여액을 매개변수로 전달하고 그 금액보다 적게 받는 사원의 이름과 급여를 출력
-- 프로시저 : cur_sal_proc(p_salary, p_curvar)
DECLARE
  emp_sal_curvar SYS_REFCURSOR;
  vs_empname employees.emp_name%TYPE;
  vn_salary employees.salary%TYPE;
  -- 프로시저(변수, 커서)의 형태로 변수p_salary로 입력받고 p_curvar에 값을 저장하고 var가 동시에 출력
  PROCEDURE cur_sal_proc(p_salary employees.salary%TYPE, p_curvar IN OUT sys_refcursor)
  IS
    c_temp_curvar SYS_REFCURSOR;
  BEGIN
    OPEN c_temp_curvar FOR
      SELECT emp_name, salary
        FROM employees
       WHERE salary < p_salary;
    
    p_curvar := c_temp_curvar;
  END;

BEGIN
  cur_sal_proc(5000, emp_sal_curvar);
  LOOP
    FETCH emp_sal_curvar INTO vs_empname, vn_salary;
    EXIT WHEN emp_sal_curvar%NOTFOUND;
  
    DBMS_OUTPUT.PUT_LINE(vs_empname || ' : ' || vn_salary);  
  END LOOP;
END;
------------------------------------------------------------------------------------------
-- 내 풀이
DECLARE
  whatcur SYS_REFCURSOR;
  thiscur SYS_REFCURSOR;
  vs_emp_name employees.employee_name%TYPE;
  vn_salary employees.salary%TYPE;
  
  PROCEDURE cur_sal_proc(p_salary IN OUT sys_refcursor, p_curvar IN OUT sys_refcursor)
  IS
    somecur SYS_REFCURSOR;
    othercur SYS_REFCURSOR;
  BEGIN
    OPEN somecur FOR
      SELECT salary FROM employees;
    OPEN othercur FOR 
      SELECT emp_name, salary FROM employees;
    p_salary := somecur;      
    p_curvar := othercur;
  END;

BEGIN
  cur_sal_proc(whatcur, thiscur);
  LOOP
    FETCH whatcur INTO vn_salary;
    EXIT WHEN whatcur%NOTFOUND;
    
    FETCH thiscur INTO vs_emp_name;
    EXIT WHEN thiscur%NOTFOUND;
     
    DBMS.OUTPUT.PUT_LINE(vs_emp_name || ' : ' || vn_salary);
  END LOOP;
  
END;
------------------------------------------------------------------------------------------
-- 1-6. 커서 표현식
-- 90번 부서에 속한 사원들의 부서명과 사원명 조회
-- (1) 사원테이블을 기준으로 조회시
SELECT ( SELECT d.department_name
           FROM departments d
          WHERE d.department_id = e.department_id) department_name, emp_name
  FROM employees e
 WHERE e.department_id = 90;
-- (2) 부서테이블을 기준으로 조회시
SELECT department_name, ( SELECT emp_name
                            FROM employees e
                           WHERE e.department_id = d.department_id ) emp_name
  FROM departments d
 WHERE d.department_id = 90;
-- (2)의 경우에는 부서명이 1개인데 3명의 사원명을 3행으로 조회하려니 오류가 남
-- (3) 커서 표현식을 사용해 (2) 조회
SELECT department_name,
       CURSOR( SELECT emp_name
                 FROM employees e
                WHERE e.department_id = d.department_id ) emp_name
  FROM departments d
 WHERE d.department_id = 90;
-- (4) 커서 표현식(3)의 결과를 FETCH
DECLARE
  CURSOR my_cursor -- (3)의 내용을 my_cursor라는 커서에 담음
  IS
  SELECT department_name,
         CURSOR( SELECT emp_name
                   FROM employees e
                  WHERE e.department_id = d.department_id ) emp_name
    FROM departments d
   WHERE d.department_id = 90;
   
   vs_dept_name departments.department_name%TYPE; -- 부서명을 담을 변수
   cur_emp_name SYS_REFCURSOR; -- 커서 표현식을 담을 커서변수 (사원명타입을 적는 게 맞아 보이지만
                               -- 커서 표현식을 썻기 때문에 커서타입으로 선언해야함)
   vs_emp_name employees.emp_name%TYPE; -- cur_emp_name커서에서 사용될 변수
BEGIN
  OPEN my_cursor;
  LOOP
    FETCH my_cursor INTO vs_dept_name, cur_emp_name;
    EXIT WHEN my_cursor%NOTFOUND;
    
    DBMS_OUTPUT.PUT_LINE('부서명' || ' : ' || vs_dept_name); -- 부서명 출력
    
    LOOP -- cur_emp_name가 커서표현식 이기 때문에 cur_emp_name을 다시 열어서 다른 데에 값을 담아야함
      FETCH cur_emp_name INTO vs_emp_name;
      EXIT WHEN cur_emp_name%NOTFOUND;
      
      DBMS_OUTPUT.PUT_LINE('사원명' || ' : ' || vs_emp_name); -- 사원명 출력
    END LOOP;
    
  END LOOP;
  CLOSE my_cursor;
END;

-- 사원번호가 176번인 사원의 사원명과 발령내역을 커서 표현식을 이용하고 익명블록을 구현해
-- emp_name, job_id, start_date, end_date를 조회
DECLARE
  CURSOR me_cursor -- me_cursor라는 커서 표현식
  IS
    SELECT job_id, start_date, end_date,
           CURSOR ( SELECT emp_name
                      FROM employees e
                     WHERE e.employee_id = j.employee_id) emp_name
      FROM job_history j
     WHERE j.employee_id = 176;
  cur_emp_name SYS_REFCURSOR; -- 커서표현식 emp_name을 커서 cur_emp_name에 담음
  vn_job_id job_history.job_id%TYPE; -- job_id를 담을 변수
  vd_start_date job_history.start_date%TYPE; -- start_date를 담을 변수
  vd_end_date job_history.end_date%TYPE; -- end_date를 담을 변수
  vs_emp_name employees.emp_name%TYPE; -- 커서cur_emp_name를 담을 변수

BEGIN
  OPEN me_cursor;
  LOOP
    FETCH me_cursor INTO vn_job_id, vd_start_date, vd_end_date, cur_emp_name;
    EXIT WHEN me_cursor%NOTFOUND;
    
    LOOP -- 커서 표현식인 cur_emp_name을 열어서 값을 vs_emp_name에 담아주기 위한 반복문
      FETCH cur_emp_name INTO vs_emp_name;
      EXIT WHEN cur_emp_name%NOTFOUND;
      
      DBMS_OUTPUT.PUT_LINE('사원명 : ' || vs_emp_name);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('발령내역 : ' || vn_job_id || ' (' || vd_start_date || 
                          ' ~ ' || vd_end_date || ')');
  END LOOP;
  CLOSE me_cursor;
END;