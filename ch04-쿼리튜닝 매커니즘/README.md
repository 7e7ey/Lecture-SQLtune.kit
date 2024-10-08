# 4장. 쿼리 튜닝의 매커니즘 이해하기

## 강의 목차
- 테이블에 접근하는 선후관계
    - 드라이빙 테이블(Driving Table), 드리븐 테이블(Driven Table) 소개
    - 드라이빙 테이블이 중요한 이유
    - 드라이빙 테이블이 선택되는 조건
- 조인 알고리즘
    - [참고] Random Access vs Sequential Access
    - Nested Loop Join
    - Hash Join
- 오브젝트 스캔(Object Scan)
    - Full Table Scan(=Table Full Scan)
    - Index Range Scan
    - Index Full Scan
    - Index Unique Scan
    - Index Loose Scan
    - Index Skip Scan
    - Index Merge Scan
- 조건절
    - 액세스 조건, 필터 조건
- 정량적 지표
    - 선택도 (Selectivity)
    - 카디널리티 (Cardinality)
- 응용 용어
    - 힌트(Hint)
    - 콜레이션(Collation)
    - 통계정보


## 강의 중 설명한 SQL 코드
- 드라이빙 테이블 vs 드리븐 테이블
```sql
SELECT emp.EMP_ID, emp.FIRST_NAME, emp.LAST_NAME, grade.GRADE_NAME
  FROM grade -- 직급
  JOIN emp   -- 사원
    ON grade.EMP_ID = emp.EMP_ID
 WHERE emp.LAST_NAME = 'Suri'
-- 위/아래 동일
SELECT emp.EMP_ID, emp.FIRST_NAME, emp.LAST_NAME, grade.GRADE_NAME
  FROM grade, emp
 WHERE emp.LAST_NAME = 'Suri'
   AND grade.EMP_ID = emp.EMP_ID
```
- 드라이빙/드리븐 실습1
```sql
SELECT emp.EMP_ID, emp.FIRST_NAME, emp.LAST_NAME, grade.GRADE_NAME
  FROM grade, emp
 WHERE emp.LAST_NAME = 'Suri'
   AND grade.EMP_ID = emp.EMP_ID
```
- 드라이빙/드리븐 실습2
```sql
SELECT emp.EMP_ID, emp.FIRST_NAME, emp.LAST_NAME, grade.GRADE_NAME
  FROM grade, emp
```
- 테이블 스캔: Table Full Scan
```sql
SELECT emp_id, last_name, first_name
  FROM emp
 WHERE gender IS NOT NULL
```
- 인덱스 스캔: Index Range Scan
```sql
SELECT emp_id, last_name, first_name
  FROM emp
 WHERE emp_id BETWEEN 20000 AND 30000
```
- 인덱스 스캔: Index Full Scan
```sql
SELECT last_name
  FROM emp
 WHERE gender <> 'F'
```
- 인덱스 스캔: Index Unique Scan
```sql
SELECT *
  FROM emp
 WHERE emp_id = 20000
```
- 인덱스 스캔: Index Loose Scan
```sql
SELECT gender, COUNT(distinct last_name) cnt
  FROM emp
 WHERE gender ='F'
 GROUP BY gender
```
- 인덱스 스캔: Index Skip Scan
```sql
SELECT MAX(emp_id) max_emp_id
  FROM emp
 WHERE last_name = 'Peha'
```
- 인덱스 스캔: Index Merge Scan
```sql
SELECT emp_id, last_name, first_name
  FROM emp
 WHERE (hire_date BETWEEN '1989-01-01'  AND '1989-06-30')
    OR emp_id > 600000
```
- 액세스 조건/필터 조건 실습
```sql
SELECT emp_id, gender, first_name, last_name, hire_date
  FROM emp
 WHERE emp_id BETWEEN 50000 AND 60000
   AND gender = 'F'
   AND last_name IN ('Kroft','Colorni')
   AND hire_date >= '1990-01-01'
```
- 힌트(Hint)
```sql
SELECT 학번, 전공코드
 FROM 학생 /*! USE INDEX (학생_IDX01) */
WHERE 이름 = '유재석';
```
- 힌트 실습
```sql
-- /*! STRAIGHT_JOIN */, USE INDEX (PRIMARY), FORCE INDEX (PRIMARY), IGNORE INDEX (PRIMARY)
SELECT e.FIRST_NAME, e.LAST_NAME
  FROM emp e,
       manager m
 WHERE e.EMP_ID = m.EMP_ID
```
- Collation 실습
```sql
-- 1. 테이블 생성
CREATE TABLE coll_table (
 bin_col VARCHAR(10) NOT NULL,
 ci_col  VARCHAR(10) NOT NULL COLLATE 'utf8mb3_general_ci'
)
COLLATE='utf8mb3_bin'
ENGINE=INNODB;

-- 2. 데이터 입력
INSERT INTO tuning.coll_table (bin_col, ci_col) 
     VALUES ('A', 'A'),('B', 'a'),('a', 'B'),('b', 'b');

-- 3. 결과 확인
SELECT * FROM coll_table
ORDER BY bin_col, ci_col;

-- 4. 테이블 삭제
DROP TABLE coll_table;
```