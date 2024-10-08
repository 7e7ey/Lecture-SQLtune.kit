# 5장. 쿼리의 실행계획 이해하기

## 강의 목차
- 실행계획 수행
  - 실행계획 출력
- 실행계획 항목-1
  - id
  - table
  - select_type
- 실행계획 항목-2
  - partitions
  - type
- 실행계획 항목-3
  - key
  - key_len
  - ref
  - row
  - filtered
  - extra
  - [참고] Using where
  - [참고] Covering Index
- 실행계획의 판단 기준 & 확장
- SQL 프로파일링

## 강의 중 설명한 SQL 코드
- 실행계획 실습
```sql
-- 실행계획 출력
explain SELECT COUNT(1) FROM dept;
```
- id
```sql
EXPLAIN
SELECT e.emp_id, e.FIRST_NAME, e.LAST_NAME, s.ANNUAL_SALARY,
      (SELECT g.GRADE_NAME FROM grade g 
        WHERE g.EMP_ID = e.EMP_ID
          AND g.END_DATE = '9999-01-01') grade_name
  FROM emp e, salary s
 WHERE e.EMP_ID = 10001
   AND e.EMP_ID = s.EMP_ID
   AND s.IS_YN = 1;
```
- table
```sql
EXPLAIN
SELECT e.emp_id, e.FIRST_NAME, e.LAST_NAME, s.ANNUAL_SALARY,
      (SELECT g.GRADE_NAME FROM grade g 
        WHERE g.EMP_ID = e.EMP_ID
          AND g.END_DATE = '9999-01-01') grade_name
  FROM emp e, salary s
 WHERE e.EMP_ID = 10001
   AND e.EMP_ID = s.EMP_ID
   AND s.IS_YN = 1;
```
- select_type > simple
```sql
EXPLAIN
 SELECT e.emp_id, e.first_name, e.last_name, s.annual_salary
   FROM emp e, salary s
  WHERE e.emp_id = s.emp_id
    AND e.emp_id BETWEEN 10001 AND 10010
    AND s.annual_salary > 80000;
```
- select_type > primary
```sql
EXPLAIN
 SELECT emp_id, first_name, last_name,
        (SELECT MAX(annual_salary) 
           FROM salary 
          WHERE emp_id = e.emp_id) max_salary
   FROM emp e
  WHERE emp_id = 100001;
```
- select_type > subquery
```sql
EXPLAIN
 SELECT (SELECT COUNT(*) FROM emp ) AS e_count,
        (SELECT MAX(annual_salary) FROM salary) as s_max;
```
- select_type > derieved
```sql
EXPLAIN
  SELECT e.emp_id, s.annual_salary
    FROM emp e,
         (SELECT emp_id, MAX(annual_salary) annual_salary
            FROM salary
           WHERE emp_id = 10001) s
   WHERE e.emp_id = s.emp_id;
```
- select_type > union
```sql
EXPLAIN
 SELECT gender, MAX(hire_date) hire_date
   FROM emp e1
  WHERE gender = 'M'

  UNION ALL

 SELECT gender, MAX(hire_date) hire_date
   FROM emp e2
  WHERE gender = 'F'
```
- select_type > union result
```sql
EXPLAIN
 SELECT gender, MAX(hire_date) hire_date
   FROM emp e1
  WHERE gender = 'M'

  UNION

 SELECT gender, MAX(hire_date) hire_date
   FROM emp e2
  WHERE gender = 'F'
```
- select_type > dependent subquery, dependent union
```sql
EXPLAIN
 SELECT m.dept_id, 
       (SELECT concat(gender,' : ',last_name)
          FROM emp e1
         WHERE gender= ‘F’ AND e1.emp_id = m.emp_id

         UNION ALL

        SELECT concat(gender,' : ',first_name)
          FROM emp e2
         WHERE gender= ‘M’ AND e2.emp_id = m.emp_id
        ) name
  FROM manager m;
```
- select_type > materialized
```sql
EXPLAIN
 SELECT *
   FROM emp
  WHERE emp_id IN (SELECT emp_id FROM salary WHERE START_DATE>'2020-01-01' );
```
- type > const
```sql
EXPLAIN
 SELECT *
   FROM emp
  WHERE emp_id = 10001;
```
- type > eq_ref
```sql
EXPLAIN
 SELECT d.dept_id, d.DEPT_NAME
   FROM dept_emp_mapping de,
        dept d
  WHERE de.dept_id = d.dept_id
    AND de.END_DATE = '9999-01-01'
    AND de.emp_id = 10001
```
- type > ref
```sql
-- 유형 1
EXPLAIN
 SELECT *
   FROM dept_emp_mapping de
  WHERE de.END_DATE = ‘9999-01-01’ AND de.emp_id = 10001;
-- 유형 2
EXPLAIN
 SELECT d.dept_id, d.DEPT_NAME
   FROM dept_emp_mapping de, dept d
  WHERE de.dept_id = d.dept_id AND de.END_DATE = '9999-01-01' AND de.emp_id = 10001;
```
- type > range
```sql
EXPLAIN
 SELECT *
   FROM emp
  WHERE emp_id BETWEEN 10001 AND 100000;
```
- type > index_merge
```sql
EXPLAIN
 SELECT *
   FROM emp
  WHERE emp_id BETWEEN 10001 AND 100000
    AND hire_date = '1985-11-21';
```
- type > index
```sql
EXPLAIN
 SELECT emp_id
   FROM grade
  WHERE grade_name = 'Manager';
```
- type > all
```sql
EXPLAIN 
 SELECT emp_id, first_name 
   FROM emp
```
- key & key_len
```sql
EXPLAIN
SELECT emp_id
  FROM emp
 WHERE emp_id BETWEEN 100000 AND 110000
```
- ref
```sql
EXPLAIN
 SELECT e.emp_id, g.grade_name
   FROM emp e, grade g
  WHERE e.emp_id = g.emp_id
    AND e.emp_id BETWEEN 10001 AND 10100;
```
- rows
```sql
EXPLAIN
 SELECT e.emp_id, g.grade_name
   FROM emp e, grade g
  WHERE e.emp_id = g.emp_id
    AND e.emp_id BETWEEN 10001 AND 10100;
```
- Profiling 실습
```sql
-- 1. 확인
SHOW VARIABLES LIKE 'profiling'

-- 2. 접속 세션에서 변수 변경
SET profiling = 'ON'

-- 3. 쿼리 수행

-- 4. 전체 확인
SHOW PROFILES

-- 5. 결과 확인
SHOW PROFILE FOR query #

-- 6. 상세 확인
SHOW PROFILE ALL FOR query 4
```