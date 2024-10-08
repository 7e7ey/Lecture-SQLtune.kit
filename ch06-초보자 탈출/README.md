# 6장. 악성 SQL문 튜닝으로 초보자 탈출하기
## 강의 목차 및 대상 SQL
- 튜닝을 위한 참고 및 사전 준비
- OOO를 변형하는 나쁜 SQL
```sql
SELECT *
  FROM emp
 WHERE SUBSTRING(emp_id,1,4) = 1100
   AND LENGTH(emp_id) = 5
```
- 불필요한 OO를 포함하는 나쁜 SQL
```sql
SELECT IFNULL(gender,'NO DATA') gender, 
       COUNT(1) count
  FROM emp
 GROUP BY IFNULL(gender,'NO DATA')
```
- OOO를 활용하지 못하는 나쁜 SQL
```sql
SELECT COUNT(*) count
  FROM salary
 WHERE is_yn = 1
```
- OOO 방식으로 수행하는 나쁜 SQL
```sql
SELECT first_name, last_name
  FROM emp
 WHERE hire_date LIKE '1994%'
```
- OO을 결합해서 사용하는 나쁜 SQL
```sql
 SELECT *
   FROM emp
  WHERE CONCAT(gender,' ',last_name) = 'M Radwan'
```
- 습관적으로 OO을 제거하는 나쁜 SQL
```sql
SELECT DISTINCT e.EMP_ID, e.FIRST_NAME, e.LAST_NAME, s.ANNUAL_SALARY  
  FROM emp e
  JOIN salary s
    ON (e.emp_id = s.emp_id)
  WHERE s.is_yn = '1'
```
- OOOOO 문으로 쿼리를 합치는 나쁜 SQL
```sql
SELECT 'M' AS gender, emp_id
  FROM emp
 WHERE gender = 'M'
   AND last_name ='Baba'

 UNION

SELECT 'F', emp_id
  FROM emp
 WHERE gender = 'F'
   AND last_name = 'Baba'
```
- OOO를 생각하지 않고 작성한 나쁜 SQL
```sql
SELECT last_name, gender, COUNT(1) as count
  FROM emp
 GROUP BY last_name, gender
```
- 엉뚱한 OOO를 사용하는 나쁜 SQL
```sql
SELECT emp_id
  FROM emp
 WHERE hire_date LIKE '1989%'
   AND emp_id > 100000
```
- 잘못된 OOOO 테이블로 수행되는 나쁜 SQL
```sql
SELECT de.emp_id, d.dept_id
  FROM dept_emp_mapping de, 
       dept d
 WHERE de.dept_id = d.dept_id
   AND de.start_date >= '2002-03-01'
```