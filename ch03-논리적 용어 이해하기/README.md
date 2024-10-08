# 3장. 손에 잡히는 논리적 용어 이해하기
## 강의 목차
- 위치와 관련된 서브 쿼리
    - 메인 쿼리, 스칼라 서브 쿼리, 인라인 뷰, 중첩 서브 쿼리
- 관계성과 관련된 서브 쿼리
    - 상관 서브 쿼리, 비상관 서브 쿼리
- 반환 결과와 관련된 서브 쿼리
    - 단일행 서브 쿼리, 다중행 서브 쿼리, 다중열 서브 쿼리
- 기초 조인
    - Inner Join, Left Outer Join, Right Outer Join
    - [참고] Full Outer Join
- 응용 조인
    - Cross Join, Natural Join

## 강의 중 설명한 SQL 코드
- Inner Join
```sql
SELECT 학생.학번, 학생.이름, 지도교수.교수명
  FROM 학생, 지도교수 
 WHERE 학생.학번 = 지도교수.학번

--- ANSI SQL
SELECT 학생.학번, 학생.이름, 지도교수.교수명
 FROM 학생
 JOIN 지도교수 
   ON 학생.학번 = 지도교수.학번
```
- Left Outer Join
```sql
SELECT 학생.학번, 학생.이름, 지도교수.교수명
  FROM 학생
  LEFT JOIN 지도교수
         ON 학생.학번 = 지도교수.학번
```
- Right Outer Join
```sql
SELECT 학생.학번, 학생.이름, 지도교수.교수명
  FROM 학생
 RIGHT JOIN 지도교수
         ON 학생.학번 = 지도교수.학번         
```
- Full Outer Join
```sql
SELECT 학생.학번, 학생.이름, 지도교수.교수명
  FROM 학생
  LEFT JOIN 지도교수
         ON 학생.학번 = 지도교수.학번
UNION
SELECT 학생.학번, 학생.이름, 지도교수.교수명
  FROM 학생
 RIGHT JOIN 지도교수
         ON 학생.학번 = 지도교수.학번     
```
- Cross Join
```sql
SELECT 학생.학번, 학생.이름, 
        지도교수.학번, 지도교수.교수명
  FROM 학생
 CROSS JOIN 지도교수
-- 위/아래 동일
SELECT 학생.학번, 학생.이름, 
        지도교수.학번, 지도교수.교수명
  FROM 학생, 지도교수
```
- Natural Join
```sql
SELECT 학생.*, 지도교수.*
  FROM 학생
NATURAL JOIN 지도교수
-- 위/아래 동일
SELECT 학생.*, 지도교수.*
  FROM 학생
  JOIN 지도교수
    ON 학생.학번 = 지도교수.학번
```