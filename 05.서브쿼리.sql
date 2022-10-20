-- 서브쿼리 - 보조적으로 사용되는 쿼리
-- 1. 일반 서브쿼리
-- 1.1 연관성 없는 쿼리
-- (1) 단일행을 반환하는 서브쿼리 
-- 모든 사원의 평균급여보다 많이 받는 사원의 수 조회
SELECT count(*)
  FROM employees
 WHERE salary > (SELECT AVG(salary) FROM employees);

-- orders_ex테이블에서 주문일자가 2012-10-10일 평균 주문금액보다 큰 주문금액 조회
SELECT *
  FROM orders_Ex
 WHERE purch_amt > (SELECT AVG(purch_amt) FROM orders_ex 
                    WHERE ord_date = To_DATE('2012-10-10', 'YYYY-MM-DD'))
ORDER BY purch_amt;

-- (2) 복수행을 반환하는 서브쿼리 - IN을 사용
-- departments테이블에서 parent_id가 없는 부서에 속하는 사원수를 조회
SELECT count(*)
  FROM departments
 WHERE department_id IN (SELECT department_id
                           FROM departments
                          WHERE parent_id IS NULL);
                        
-- 매니저가 존재하는 부서에 속하는 사원의 수 조회
SELECT count(*)
  FROM employees
 WHERE department_id IN (SELECT department_id
                        FROM departments
                       WHERE manager_id IS NOT NULL);
                       
-- salesman, order_ex테이블을 이용해 paris를 담당하는 영업사원들에 대한 모든 주문정보를 조회
SELECT *
  FROM orders_ex
 WHERE salesman_id IN (SELECT salesman_id
                         FROM salesman
                        WHERE city = 'Paris');

-- salesman, orders_ex테이블을 이용해 paul adam이 판매한 모든 주문정보를 조회
SELECT *
  FROM orders_ex
 WHERE salesman_id IN (SELECT salesman_id
                         FROM salesman
                        WHERE name = 'Paul Adam');
                        
-- (3) 동시에 2개 이상의 컬럼값을 반환하는 서브쿼리
-- employees테이블에서 job_history테이블에 존재하는 사원번호, 직책번호 값을 가지는 사원의 정보를 조회
SELECT employee_id, emp_name, job_id
  FROM employees
 WHERE (employee_id, job_id) IN (SELECT employee_id, job_id
                                 FROM job_history);

-- 부서별로 최대급여를 받는 사원의 사원번호, 사원명, 급여 조회 (부서번호, 부서별 최대급여 조회)
SELECT employee_id, emp_name, department_id, salary
  FROM employees
 WHERE (NVL(department_id, 0), salary) IN (SELECT NVL(department_id, 0), max(salary)
                                             from employees
                                         group by department_id);
                                 
-- (4) SELECT가 아닌 다른 문에서의 사용
-- 모든 사원의 급여를 전 사원의 평균급여로 수정
UPDATE employees
   SET salary = (SELECT AVG(salary) FROM employees);
   
-- 1.2 연관성 있는 서브쿼리
-- job_history에 존재하는 모든 레코드에 대해 부서번호를 추출해 department테이블에서 부서번호, 부서명 조회
SELECT department_id, department_name
  FROM departments d
 WHERE EXISTS (SELECT department_id FROM job_history j
                WHERE j.department_id = d.department_id);

-- salesman, customer_ex테이블을 참조해 2명 이상의 고객을 가진 영업사원의 정보 조회
-- 풀이 1
SELECT *
  FROM salesman s
 WHERE 1 < (SELECT count(*) FROM customer_ex c
                WHERE c.salesman_id = s.salesman_id
                GROUP BY salesman_id);
-- 풀이 2
SELECT *
  FROM salesman s
 WHERE EXISTS (SELECT salesman_id, count(*) FROM customer_ex c
                WHERE c.salesman_id = s.salesman_id
                GROUP BY salesman_id
                HAVING COUNT(c.salesman_id)>1);

-- SELECT문 내에 서브쿼리
-- job_history의 모든 행에 대해 사원번호, 사원명, 부서번호, 부서명 조회
SELECT j.employee_id,
       (SELECT emp_name FROM employees e
         WHERE j.employee_id = e.employee_id) 사원명,
       j.department_id,
       (SELECT department_name FROM departments d
         WHERE j.department_id = d.department_id) 부서명
  FROM job_history j;

-- orders_ex테이블에서 전체 주문을 조회하고 각 주문의 고객명과 영업사원명을 함께 조회
SELECT ord_no, purch_amt, ord_date,
       (SELECT c.cust_name FROM customer_ex c
         WHERE c.customer_id = o.customer_id) 고객명,
       (SELECT s.name FROM salesman s
         WHERE s.salesman_id = o.salesman_id) 영업사원명
  FROM orders_ex o;
  
-- 평균급여보다 많이 받는 직원이 있는 부서의 부서번호와 부서명 조회
SELECT department_id, department_name
  FROM departments d
 WHERE EXISTS(SELECT employee_id, department_id
                FROM employees e
               WHERE e.department_id = d.department_id
                 AND salary > (SELECT AVG(salary) FROM employees));

-- UPDATE문에서 연관성 있는 서브쿼리 사용
-- 상위부서가 90인 사원들의 급여를 그 부서의 평균급여로 수정
-- (1) 상위부서가 90인 사원정보 조회
SELECT e.employee_id, e.emp_name, d.department_id, d.department_name, d.parent_id 
  FROM employees e, departments d
 WHERE e.department_id = d.department_id
   AND d.parent_id = 90;
-- (2) 상위부서가 90인 부서의 평균급여 조회
SELECT e.department_id, TRUNC(AVG(e.salary))
  FROM employees e, departments d
 WHERE e.department_id = d.department_id
   AND d.parent_id = 90
GROUP BY e.department_id;
-- (3) 상위부서가 90인 사원들의 급여를 그 부서의 평균급여로 수정
UPDATE employees e
   SET e.salary = (SELECT sal FROM
                 (SELECT e.department_id, TRUNC(AVG(e.salary)) sal
                    FROM employees e, departments d
                   WHERE e.department_id = d.department_id
                     AND d.parent_id = 90
                GROUP BY e.department_id) v
                   WHERE v.department_id = e.department_id)
 WHERE e.department_id IN(SELECT department_id 
                            FROM departments WHERE parent_id = 90);
rollback;

-- parent_id가 90인 부서에 속하는 부서의 평균급여보다 많이 받는
-- 사원의 사원번호, 사원명, 부서번호, 부서명 조회
-- (1) parent_id가 90인 부서에 속하는 모든 사원들의 평균급여 조회
SELECT TRUNC(AVG(salary)) avgsal
  FROM employees e, departments d
 WHERE d.parent_id = 90
   AND e.department_id = d.department_id;
-- (2) 위의 SQL을 뷰로 생성   
CREATE OR REPLACE VIEW avg_view AS 
SELECT TRUNC(AVG(salary)) avgsal
  FROM employees e, departments d
 WHERE d.parent_id = 90
   AND e.department_id = d.department_id;
-- (3) 문제 SQL 작성
SELECT e.employee_id, e.emp_name, e.salary, d.department_id, d.department_name
  FROM employees e, departments d, avg_view v
 WHERE e.department_id = d.department_id
   AND e.salary > v.avgsal
ORDER BY e.department_id;

-- orders_ex, customer_ex 각 고객에 대하여 고객자신의 평균 주문금액보다 큰 주문금액을 가진 모든 주문 조회
-- (1) 각 고객의 평균주문금액 조회
SELECT customer_id, TRUNC(AVG(purch_amt))
  FROM orders_ex
GROUP BY customer_id;
-- (2) orders_ex, 가상뷰를 조인해 평균금액보다 큰 주문금액 조회
SELECT o.customer_id, o.purch_amt 구매금액
  FROM orders_ex o, (SELECT customer_id, TRUNC(AVG(purch_amt)) avgpurch
                       FROM orders_ex
                   GROUP BY customer_id) tmp
WHERE o.customer_id = tmp.customer_id
  AND o.purch_amt > tmp.avgpurch
ORDER BY o.customer_id;

-- customer_ex, salesman, orders_ex테이블을 이용해 두번 이상 주문한 고객을 당담하는
-- 영업사원의 영업사원번호, 사원명, 수수료 조회
-- (1) 두번 이상 주문한 고객 조회
SELECT customer_id, count(customer_id) 
  FROM orders_ex
GROUP BY customer_id HAVING COUNT(customer_id) > 1;
-- (2) 위의 고객을 담당하는 영업사원의 정보 조회
SELECT s.salesman_id, s.name, s.commision
  FROM salesman s
 WHERE EXISTS(SELECT customer_id, COUNT(customer_id)
                FROM orders_ex o
               WHERE o.salesman_id = s.salesman_id
            GROUP BY customer_id HAVING COUNT(customer_id) > 1);

-- 점수가 NewYork에 거주하는 고객의 평균점수 이상인 고객의 점수와 수를 조회
-- 관련테이블 : customer_ex
-- (1) 뉴욕 고객의 평균점수 조회
SELECT AVG(grade)
  FROM customer_ex
 WHERE city = 'New York';
-- (2) 위의 평균점수보다 큰 점수와 고객수 주회
SELECT grade, count(*)
  FROM customer_ex
 WHERE grade > (SELECT AVG(grade)
                  FROM customer_ex
                 WHERE city = 'New York')
GROUP BY grade;

-- orders_ex테이블에서 수수료가 가장 큰 영업사원에 대해 모든 주문정보 조회
-- (1) 영업사원의 최대 수수료 조회
SELECT MAX(commision)
  FROM salesman;
-- (1-1) 서브쿼리를 이용해 최대 수수료를 받는 영업사원 조회
SELECT salesman_id,commision maxcommision
  FROM salesman
 WHERE commision = (SELECT MAX(commision)
                      FROM salesman);
-- (2) orders_ex테이블에서 최대 수수료를 받는 영업사원들의 모든 주문정보 조회
SELECT ord_no, purch_amt, ord_date, customer_id, salesman_id
  FROM orders_ex
 WHERE salesman_id IN (SELECT salesman_id
                         FROM salesman
                        WHERE commision = (SELECT MAX(commision)
                                             FROM salesman));