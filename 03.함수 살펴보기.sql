-- 1. 숫자함수
-- 1.1 CEIL(n) (소수가 있을 시 다음으로 큰 정수를 반환)
SELECT CEIL(10.123), CEIL(10.541), CEIL(11.01) FROM DUAL;

-- 1.2 FLOOR(n) (소수는 버리고 정수만 반환)
SELECT FLOOR(10.123), FLOOR(10.541), FLOOR(11.01) FROM DUAL;

-- 1.3 ROUND(n) (반올림)
SELECT ROUND(10.123), ROUND(10.541), ROUND(11.01) FROM DUAL; 

-- 1.4 ROUND(n, i) (소수점 반올림) (콤마 뒤의 수를 자릿수로 해 소수점을 반올림(음수는 정수의 자릿수))
SELECT ROUND(10.123, 1), ROUND(10.541, 2), ROUND(11.015, 3) FROM DUAL; 
SELECT ROUND(10.123, -1), ROUND(153.541, -2), ROUND(194.015, -3) FROM DUAL; 

-- 1.5 TRUNC(n1, n2) (수 제거) (콤마 뒤의 수를 자릿수로 해 수를 버림)
SELECT TRUNC(115.155), TRUNC(115.155, 2), TRUNC(115.155, -1), TRUNC(115.155, -2) FROM DUAL;

-- 1.6 POWER(n1, n2) (수 제곱) (콤마 뒤의 수만큼 콤마 앞의 수를 제곱)
SELECT POWER(3, 2), POWER(3, 3), POWER(3, 4) FROM DUAL;

-- 1.7 MOD(n1, n2) (나머지) (콤마 앞에 수를 콤마 뒤의 수로 나눈 나머지 값 반환)
SELECT MOD(19, 4), MOD(19.123, 4.2) FROM DUAL;

-- 2. 문자함수
-- 2.1 INITCAP(char) (첫 문자를 대문자로, 나머지는 소문자로 반환 (공백을 기준으로 문자인식)) 
SELECT INITCAP('never say goodbye') FROM DUAL;

-- 2.2 LOWER(char) (모든 글자를 소문자로 반환)
--     UPPER(char) (모든 글자를 대문자로 반환)
SELECT LOWER('HI, ITS MINSU'), UPPER('hi, its minsu') FROM DUAL;

-- 2.3 CONCAT(char1, char2) (두 문자열을 붙여서 반환)
SELECT CONCAT('I Have', ' a Dream'), 'This is' || ' Minsu'FROM DUAL;

-- 2.4 SUBSTR(char, pos, length) (char문자열에서 pos번째 문자열부터 length만큼 잘라서 반환)
SELECT SUBSTR('ABCDEFG', 1, 5), SUBSTR('ABCDEFGHI', -7, 3) FROM DUAL;
SELECT SUBSTR('가나다라마바사', 3, 3), SUBSTR('가나다라마바사', -3, 3) FROM DUAL;

-- 2.5 SUBSTRB(char, pos, length) -- 오라클에서 한글 1글자는 3바이트를 차지
--     (바이트를 기준으로 char문자열에서 pos번째 문자열부터 length만큼 잘라서 반환)
SELECT SUBSTRB('ABCDEFG', 1, 4), SUBSTRB('가나다라마바사', 1, 4) FROM DUAL;

-- 2.6 LTRIM(char, set) (문자열에서 set에 지정된 문자열을 왼쪽에서 제거)
--     RTRIM(char, set) (문자열에서 set에 지정된 문자열을 오른쪽에서 제거)
SELECT LTRIM('ABCDEFGABC', 'ABC'), LTRIM('     가나다라', ' '), 
       RTRIM('ABCDEFGABC', 'ABC'), RTRIM('     가나다라', '라') FROM DUAL;
       
-- 2.7 LPAD(char1, n, char2) (char2문자열을 char1문자열 왼쪽에 붙여서 n개 문자열을 반환)
--     RPAD(char1, n, char2) (char2문자열을 char1문자열 오른쪽에 붙여서 n개 문자열을 반환)
SELECT LPAD('111-1111', 12, '(02)'),
       RPAD('111-1111', 12, '(02)') FROM DUAL;
       
-- SQL 연습문제 1
-- CUSTOMERS테이블 cust_main_phone_number컬럼에서 앞 네자리를 제거하고 (02)를 붙여서 고객명, 번호 조회
-- SELECT LTRIM('620-736-1008', '620-'), LPAD('736-1008', 12, '(02)') FROM DUAL;
SELECT cust_name, LPAD(SUBSTR(cust_main_phone_number, 5), 12, '(02)') FROM customers;

-- 2.8 REPLACE(char, str1, str2) (char문자열에서 str1을문자열을 str2로 변환
SELECT REPLACE('ABC/DEF~GHI', '/', '~') FROM DUAL;

-- 2.9 TRANSLATE(char, from, to) (from의 문자열을 to의 문자열로 하나씩 매핑하여 반환)
SELECT TRANSLATE('PROGRAMING', 'PRM', 'ONB') FROM DUAL;

-- 2.10 INSTR(str, substr, pos)
-- (str문자열에서 pos번째 문자열을 기준으로 substr과 일치하는 문자의 위치를 반환)
SELECT INSTR('prefix, precise, preface', 'pre', 3) AS INSTR1 FROM DUAL;
SELECT INSTR('prefix, precise, preface', 'pre', 7, 2) AS INSTR1 FROM DUAL;

-- 2.11 LENGTH(char) (문자열의 갯수를 반환)
--      LENGTHB(char) (문자열의 바이트수를 반환)
SELECT LENGTH('대한민국'), LENGTHB('대한민국') FROM DUAL;

-- SQL 연습문제 2
-- EMPLOYEES테이블에서 hire_date를 참조해 현재일자를 기준으로 근속년수가 20년 이상인 
-- 사원의 사원번호, 사원명, 입사일자, 근속년수 조회
SELECT employee_id, emp_name, hire_date, TRUNC(MONTHS_BETWEEN(sysdate, hire_date)/12) 근속년수
FROM employees
WHERE MONTHS_BETWEEN(sysdate, hire_date)>=240
ORDER BY hire_date;

SELECT employee_id, emp_name, hire_date, SUBSTR(sysdate, 1, 4)-SUBSTR(hire_date, 1, 4) 근속년수
FROM employees
WHERE SUBSTR(sysdate, 1, 4)-SUBSTR(hire_date, 1, 4)>=20
ORDER BY hire_date;

-- 3. 날짜함수
-- 3.1 SYSDATE, SYSTIMESTAMP
SELECT SYSDATE, SYSTIMESTAMP FROM DUAL;

-- 3.2 ADD_MONTHS(date, integer) (date날짜에 integer만큼의 월을 더한 날짜를 반환)
SELECT ADD_MONTHS(SYSDATE, 1), ADD_MONTHS(SYSDATE, -1) FROM DUAL;

-- 3.3 MONTHS_BETWEEN(date1, date2) (두 날짜 사이의 개월수 반환)
SELECT MONTHS_BETWEEN('2019-03-16', '2019-12-16') FROM DUAL;

-- 3.4 LAST_DAY(date) (date날짜를 기준으로 해당 월의 마지막 일자를 반환)
SELECT LAST_DAY(SYSDATE) FROM DUAL;

-- 3.5 ROUND(date, format) (format에 따라 반올림한 날짜를 반환)
--     TRUNC(date, format) (format에 따라 버린 날짜를 반환)
SELECT SYSDATE, ROUND(SYSDATE, 'month'), TRUNC(SYSDATE, 'month') FROM DUAL;

-- 3.6 NEXT DAY(date, day) (date날짜를 기준으로 앞으로 다가올 day에 명시한 요일을 반환)
SELECT NEXT_DAY(SYSDATE, '금요일') FROM DUAL;

-- SQL 연습문제 3
-- EMPLOYEES테이블에서 employee_id, emp_name, hire_date, 정식발령일 조회
-- hire_date를 기준으로 3개월 후 첫번째 월요일이 정직원 발령날짜임
SELECT employee_id, emp_name, hire_date, NEXT_DAY(ADD_MONTHS(hire_date, 3), '월요일') 정식발령일
FROM employees
ORDER BY hire_date;

-- 4. 변환함수
-- 4.1 TO_CHAR(숫자/날짜, format) (숫자 또는 날짜를 문자로 변환해주는 함수)
SELECT TO_CHAR(123456789, '999,999,999') FROM DUAL;
SELECT TO_CHAR(sysdate, 'AM') FROM DUAL;
SELECT TO_CHAR(sysdate, 'YYYY-MM-DD AM HH:MI:SS') FROM DUAL;
SELECT TO_CHAR(sysdate, 'DD') FROM DUAL;

-- 4.2 TO_NUMBER() (문자나 숫자를 NUMBER형으로 변환)
SELECT TO_NUMBER('123456') FROM DUAL;

-- 4.3 TO_DATE(char, format) (문자를 날짜형으로 변환)
--     TO_TIMESTAMP(char, format) (문자를 날짜형으로 변환)
SELECT TO_DATE('20140101', 'YYYY-MM-DD') FROM DUAL;
SELECT TO_TIMESTAMP('20140101', 'YYYY-MM-DD') FROM DUAL;

-- 5. NULL함수
-- 5.1 NVL(expr1, expr2) (expr1이 null이면 expr2를 반환) (NullValue)
SELECT NVL(manager_id, employee_id) FROM employees WHERE manager_id IS NULL;

-- SQL 연습문제 4
-- EMPLOYEES테이블에서 employee_id, commission_pct를 조회 commission_pct값이 null이면 0으로 반환
SELECT employee_id, NVL(commission_pct, 0)
FROM employees
ORDER BY commission_pct;

-- 5.2 NVL2(expr1, expr2, expr3) (expr1이 null이 아니면 expr2을, null이면 expr3을 반환)
SELECT employee_id, salary, NVL2(commission_pct, salary+(salary*commission_pct), salary) final
FROM employees
ORDER BY commission_pct;

-- 5.3 COALESCE(expr1, expr2...) (값이 NULL이 아닌 첫 표현식을 반환)
SELECT employee_id, salary, commission_pct,
COALESCE(salary * commission_pct, 0) commission_fee
FROM employees
ORDER BY commission_pct;

-- 5.4 LNNVL(조건식) (조건식에 반대되는 값을 조회)
SELECT COUNT (*) FROM employees
WHERE(commission_pct >= 0.2); -- 커미션이 0.2이상인 사람
--<-> 
SELECT COUNT (*) FROM employees
WHERE LNNVL(commission_pct >= 0.2); -- 커미션이 0.2이상이 아닌 사람
-- ==
SELECT COUNT (*) FROM employees
WHERE commission_pct < 0.2 OR commission_pct IS NULL; -- 커미션이 0.2이상이 아닌 사람

-- 5.5 NULLIF(expr1, expr2) (expr1과 expr2를 비교해 같으면 NULL, 다르면 expr1을 반환)
SELECT employee_id, job_id, start_date, end_date,
       NULLIF(TO_CHAR(end_date,'YYYY'), TO_CHAR(start_date,'YYYY')) 직책종료
FROM job_history;

-- 6. 기타함수
-- 6.1 GREATEST(expre1, expr2...) (expr중 가장 큰 값을 반환)
--     LEAST(expre1, expr2...) (expr중 가장 작은 값을 반환)
SELECT GREATEST('이순신', '강감찬', '세종대왕'), LEAST('이순신', '강감찬', '세종대왕')
FROM DUAL;

-- 6.2 DECODE(expr, search1, result1...)(expr과 search1을 비교해 값이 같으면 result1,
--            다르면 다시 search2와 비교해 같으면 result2, 최종적으로 같은 값이 없으면 default를 반환
SELECT cust_id, prod_id, DECODE(channel_id, 2, 'Partners', 3, 'Direct Sales', 4, 'Internet',
       5, 'Catalog', 9, 'Tele Sales', 'Othes') AS 판매방식
FROM sales;

-- SQL 연습문제 5
-- CUSTOMERS테이블에서 고객명, 출생연도, 세대를 조회
-- 고객의 출생연도를 읽어 현재일자를 기준으로 2~70대 고객을 구분해서 조회
SELECT cust_name, cust_year_of_birth, DECODE(FLOOR((TO_CHAR(sysdate, 'YYYY')-cust_year_of_birth)/10),
       2, '20대', 3, '30대', 4, '40대', 5, '50대', 6, '60대', 7, '70대', '기타') AS 세대
FROM customers
ORDER BY 세대;

-- 7. 집계함수
-- 7.1 COUNT(expr) (행의 수 반환)
SELECT COUNT(*) FROM employees;
SELECT COUNT(employee_id) FROM employees;
SELECT COUNT(department_id) FROM employees;
SELECT COUNT(DISTINCT(department_id)) FROM employees;

-- 7.2 SUM(expr) (전체 합계 반환)
SELECT SUM(salary) FROM employees;

-- 7.3 AVG(expr) (전체의 평균값 반환)
SELECT AVG(salary) FROM employees;

-- 7.4 MAX(expr) (최대값 반환)
--     MIN(expr) (최소값 반환)
SELECT MIN(salary), MAX(salary) FROM employees;

-- 8. 집합연산자 (두개 이상의 쿼리를 연결해 하나의 쿼리로 만드는 역할)
CREATE  TABLE  exp_goods_asia (
  country VARCHAR2(10),
  seq     NUMBER,
  goods   VARCHAR2(80)
);

INSERT INTO exp_goods_asia VALUES('한국', 1, '원유제외 석유류');
INSERT INTO exp_goods_asia VALUES('한국', 2, '자동차');
INSERT INTO exp_goods_asia VALUES('한국', 3, '전자직접회로');
INSERT INTO exp_goods_asia VALUES('한국', 4, '선박');
INSERT INTO exp_goods_asia VALUES('한국', 5, 'LCD');
INSERT INTO exp_goods_asia VALUES('한국', 6, '자동차부품');
INSERT INTO exp_goods_asia VALUES('한국', 7, '휴대전화');
INSERT INTO exp_goods_asia VALUES('한국', 8, '환식탄화수소');
INSERT INTO exp_goods_asia VALUES('한국', 9, '무선송신기 디스플레이 부속품');
INSERT INTO exp_goods_asia VALUES('한국', 10, '철 또는 비합금강');

INSERT INTO exp_goods_asia VALUES('일본', 1, '자동차');
INSERT INTO exp_goods_asia VALUES('일본', 2, '자동차부품');
INSERT INTO exp_goods_asia VALUES('일본', 3, '전자직접회로');
INSERT INTO exp_goods_asia VALUES('일본', 4, '선박');
INSERT INTO exp_goods_asia VALUES('일본', 5, '반도체웨이퍼');
INSERT INTO exp_goods_asia VALUES('일본', 6, '화물차');
INSERT INTO exp_goods_asia VALUES('일본', 7, '원유제외 석유류');
INSERT INTO exp_goods_asia VALUES('일본', 8, '건설기계');
INSERT INTO exp_goods_asia VALUES('일본', 9, '다이오드, 트랜지스터');
INSERT INTO exp_goods_asia VALUES('일본', 10, '기계류');
commit;
-- (1) 집합연산자의 조회컬럼의 개수와 타입은 일치해야한다.
-- (2) ORDER BY는 제일 마지막 문장에서만 사용할 수 있다.

-- 8.1 UNION (중복을 제외한 합집합)
SELECT goods FROM exp_goods_asia
WHERE country = '한국'
UNION
SELECT goods FROM exp_goods_asia
WHERE country = '일본';

-- 8.2 UNION ALL (중복을 포함한 합집합)
SELECT goods FROM exp_goods_asia
WHERE country = '한국'
UNION ALL
SELECT goods FROM exp_goods_asia
WHERE country = '일본';

-- 8.3 INTERSECT (교집합)
SELECT goods FROM exp_goods_asia
WHERE country = '한국'
intersect
SELECT goods FROM exp_goods_asia
WHERE country = '일본';

-- 8.4 MINUS (차집합)
SELECT goods FROM exp_goods_asia
WHERE country = '한국'
MINUS
SELECT goods FROM exp_goods_asia
WHERE country = '일본';

-- SQL 연습문제 6
-- employees테이블에서 입사년도별 사원수를 구하시오
SELECT TO_CHAR(hire_date, 'YYYY') AS 입사년도, count(*) AS 사원수
FROM employees
GROUP BY TO_CHAR(hire_date, 'YYYY');

-- SQL 연습문제 7
-- kor_loan_status테이블에서 2012년도 월별, 지역별, 대출총액 조회
SELECT distinct period, region, SUM(loan_jan_amt)
FROM kor_loan_status
WHERE period LIKE '2012%'
GROUP BY period, region
ORDER BY period;

-- SQL 연습문제 8
SELECT period, gubun, SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period, ROLLUP(gubun);

-- 위 쿼리를 집합연산자를 사용한 쿼리로 바꾸시오

-- (1) 월별, 군별, 대출 총액 조회
SELECT period, gubun, SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period, gubun
ORDER BY period;

--(2) 2013년 월별 대출총액 조회
SELECT period, '', SUM(loan_jan_amt)
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period
UNION
SELECT period, '', SUM(loan_jan_amt)
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period;