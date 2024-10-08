# 7장. 악성 SQL문 튜닝으로 전문가 되기
## 강의 목차 및 대상 SQL
- 불필요한 OO을 수행하는 나쁜 SQL
```sql
SELECT COUNT(DISTINCT e.emp_id) as COUNT
  FROM emp e,
       ( SELECT emp_id
           FROM entry_record 
          WHERE gate = 'A'
       ) record
 WHERE e.emp_id = record.emp_id
```
- OO 절로 추가적 필터를 수행하는 나쁜 SQL
```sql
SELECT e.emp_id, e.first_name, e.last_name
  FROM emp e,
       salary s
 WHERE e.emp_id > 450000
   AND e.emp_id = s.emp_id
 GROUP BY s.emp_id
HAVING MAX(s.annual_salary) > 100000
```
- 유사한 OOO 문을 여러 개 나열한 나쁜 SQL
```sql
SELECT 'BOSS' grade_name, COUNT(*) cnt 
  FROM grade 
 WHERE grade_name = 'Manager' AND end_date = '9999-01-01'
 
 UNION ALL

SELECT 'TL' grade_name, COUNT(*) cnt 
  FROM grade 
 WHERE grade_name = 'Technique Leader' AND end_date = '9999-01-01'
 
 UNION ALL

SELECT 'AE' grade_name, COUNT(*) cnt 
  FROM grade 
 WHERE grade_name = 'Assistant Engineer' AND end_date = '9999-01-01'
```
- 소계/통계를 위한 쿼리를 OO하는 나쁜 SQL
```sql
SELECT region, null gate, COUNT(*) cnt
  FROM entry_record
 WHERE region <> ''
 GROUP BY region

UNION ALL

SELECT region, gate, COUNT(*) cnt
  FROM entry_record
 WHERE region <> ''
 GROUP BY region, gate

UNION ALL
 
SELECT null region, null gate, COUNT(*) cnt
  FROM entry_record
 WHERE region <> ''
```
- 처음부터 OO OOO를 가져오는 나쁜 SQL
```sql
SELECT e.emp_id, 
       s.avg_salary,
       s.max_salary, 
       s.min_salary
  FROM emp e,
       (SELECT emp_id,
               ROUND(AVG(annual_salary),0) avg_salary,
               ROUND(MAX(annual_salary),0) max_salary,
               ROUND(MIN(annual_salary),0) min_salary
          FROM salary
         GROUP BY emp_id
        ) s
 WHERE e.emp_id = s.emp_id
   AND e.emp_id BETWEEN 10001 AND 10100
```
- 비효율적인 OOO을 수행하는 나쁜 SQL
```sql
SELECT e.emp_id, e.first_name, e. last_name, e.hire_date
  FROM emp e,
       salary s
 WHERE e.emp_id = s.emp_id
   AND e.emp_id BETWEEN 10001 AND 50000
 GROUP BY e.emp_id
 ORDER BY SUM(s.annual_salary) DESC
 LIMIT 150,10
```
- OOOO 정보를 가져오는 나쁜 SQL
```sql
SELECT COUNT(emp_id) AS count
  FROM (SELECT e.emp_id, m.dept_id
          FROM (SELECT *
                  FROM emp
                 WHERE gender = 'M'
                   AND emp_id > 300000
                ) e
          LEFT JOIN manager m
                 ON e.emp_id = m.emp_id
       ) sub
```
- 비효율적인 OO을 수행하는 나쁜 SQL
```sql
SELECT DISTINCT de.dept_id
  FROM manager m,
       dept_emp_mapping de
 WHERE m.dept_id = de.dept_id
 ORDER BY de.dept_id
```
- OOO 없이 데이터를 조회하는 나쁜 SQL
```sql
SELECT *
  FROM emp
 WHERE first_name = 'Georgi'
   AND last_name  = 'Wielonsky'
```
- OOO를 사용하지 않는 나쁜 SQL
```sql
SELECT *
  FROM emp
 WHERE first_name = 'Matt'
    OR hire_date = '1987-03-31'
```
- 인덱스에 나쁜 영향을 주는 나쁜 OOO
```sql
UPDATE entry_record
   SET gate = 'X'
 WHERE gate = 'B';
```
- 비효율적인 OOO를 사용하는 나쁜 SQL
```sql
SELECT emp_id, first_name, last_name
  FROM emp
 WHERE gender = 'M'
   AND last_name = 'Baba';
```
- OOOO가 섞인 데이터와 비교하는 나쁜 SQL
```sql
SELECT first_name, last_name, gender, birth
  FROM emp
 WHERE LOWER(first_name) = LOWER('MARY')
   AND hire_date >= STR_TO_DATE('1990-01-01', '%Y-%m-%d')
```
- OO 없이 대량 데이터를 사용하는 나쁜 SQL
```sql
SELECT COUNT(1)
  FROM salary
 WHERE start_date BETWEEN STR_TO_DATE('2000-01-01', '%Y-%m-%d') 
                      AND STR_TO_DATE('2000-12-31', '%Y-%m-%d');
```
