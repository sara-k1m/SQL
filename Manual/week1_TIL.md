## ⭐️ 15.2.15 Subqueries  
서브쿼리는 다른 SQL 문 내에서 실행되는 `SELECT` 문이다. MySQL에서는 표준 SQL에서 요구하는 모든 서브쿼리 형식을 지원하며, MySQL만의 추가 기능도 제공한다.  

### 📌 서브쿼리의 주요 특징  
- 쿼리의 특정 부분을 분리하여 구조적으로 작성할 수 있음  
- 복잡한 `JOIN`이나 `UNION` 없이 동일한 결과를 얻을 수 있음  
- 가독성이 뛰어나며, SQL이 **"구조적(Structured)"** 언어로 불리는 이유 중 하나  
- `SELECT, INSERT, UPDATE, DELETE, SET, DO` 문에서 사용 가능  

### 15.2.15.2 Comparisons Using Subqueries  
- 서브쿼리는 비교 연산자(`=, >, <, >=, <=, <>, !=, <=>`)와 함께 사용 가능   
    - **<=> 연산자**
      ```sql
      SELECT NULL <=> NULL;  -- TRUE 반환
      SELECT NULL <=> 'value';  -- FALSE 반환
      SELECT 'value' <=> 'value';  -- TRUE 반환
  
      ```
      - NULL 값을 포함한 비교에서 항상 TRUE 또는 FALSE를 반환해야 하는 경우에 유용하다.   
      - 두 테이블을 조인할 때 NULL 값을 포함한 열을 비교해야 하는 경우 <=> 연산자를 사용하면 편리하다.   
- 서브쿼리 결과를 비교할 때, **반환되는 값이 단일 값이어야 함**  
  ```sql
  SELECT * FROM t1 WHERE column1 = (SELECT MAX(column2) FROM t2);
  ```
- 특정 값이 두 번 등장하는 행을 찾는 서브쿼리 예제  
  ```sql
  SELECT * FROM t1 AS t
  WHERE 2 = (SELECT COUNT(*) FROM t1 WHERE t1.id = t.id);
  ```

### 15.2.15.3 Subqueries with ANY, IN, or SOME  
- `ANY`는 **서브쿼리에서 반환된 값 중 하나라도 조건을 만족하면 TRUE**  
  ```sql
  SELECT s1 FROM t1 WHERE s1 > ANY (SELECT s1 FROM t2);
  ```
- `IN`은 `= ANY`와 동일  
  ```sql
  SELECT s1 FROM t1 WHERE s1 IN (SELECT s1 FROM t2);
  ```
- `SOME`은 `ANY`와 동의어  

---
### 15.2.15.4 Subqueries with ALL  
- `ALL`은 **서브쿼리에서 반환된 모든 값에 대해 조건을 만족하면 TRUE**  
  ```sql
  SELECT s1 FROM t1 WHERE s1 > ALL (SELECT s1 FROM t2);
  ```
- `NOT IN`은 `<> ALL`과 동일  
  ```sql
  SELECT s1 FROM t1 WHERE s1 NOT IN (SELECT s1 FROM t2);
  ```

### 15.2.15.6 Subqueries with EXISTS or NOT EXISTS  
- `EXISTS`는 **서브쿼리가 하나 이상의 행을 반환하면 TRUE**  
  ```sql
  SELECT column1 FROM t1 WHERE EXISTS (SELECT * FROM t2);
  ```
- `NOT EXISTS`는 **서브쿼리가 결과를 반환하지 않으면 TRUE**  
- 중첩된 `NOT EXISTS`는 **"모든 행에 대해 특정 조건이 성립하는가?"**를 확인하는 데 사용됨  
  ```sql
  SELECT DISTINCT store_type FROM stores
  WHERE NOT EXISTS (
      SELECT * FROM cities WHERE NOT EXISTS (
          SELECT * FROM cities_stores 
          WHERE cities_stores.city = cities.city
          AND cities_stores.store_type = stores.store_type
      )
  );
  ```

### 15.2.15.10 Subquery Errors  
서브쿼리에서 발생할 수 있는 주요 오류:  
1. **지원되지 않는 서브쿼리 문법**  
   ```sql
   SELECT * FROM t1 WHERE s1 IN (SELECT s2 FROM t2 ORDER BY s1 LIMIT 1);
   ```
   - `LIMIT`을 `IN/ALL/ANY/SOME` 서브쿼리에서 사용할 수 없음  
   
2. **컬럼 개수 불일치 오류**  
   ```sql
   SELECT (SELECT column1, column2 FROM t2) FROM t1;
   ```
   - 단일 값을 기대하는데 여러 개의 컬럼을 반환할 경우 오류 발생  

3. **다중 행 반환 오류**  
   ```sql
   SELECT * FROM t1 WHERE column1 = (SELECT column1 FROM t2);
   ```
   - `=` 연산자는 하나의 값을 비교해야 하지만, 서브쿼리가 여러 행을 반환할 경우 오류 발생  
   - 해결 방법: `ANY` 사용  
     ```sql
     SELECT * FROM t1 WHERE column1 = ANY (SELECT column1 FROM t2);
     ```

4. **업데이트 테이블 사용 오류**  
   ```sql
   UPDATE t1 SET column2 = (SELECT MAX(column1) FROM t1);
   ```
   - 동일한 테이블을 `UPDATE` 하면서 서브쿼리에서 참조하면 오류 발생
  
## ⭐️ 15.2.20 WITH (Common Table Expressions)  

CTE (Common Table Expression)는 **하나의 SQL 문 내에서만 존재하는 임시 결과 집합**으로, 해당 문장에서 여러 번 참조할 수 있다.  

### 📌 CTE 정의 및 사용법  
CTE는 `WITH` 절을 사용하여 정의되며, 이후 SQL 문에서 참조할 수 있다.  

```sql
WITH
  cte1 AS (SELECT a, b FROM table1),
  cte2 AS (SELECT c, d FROM table2)
SELECT b, d FROM cte1 JOIN cte2
WHERE cte1.a = cte2.c;
```

- `cte1`과 `cte2`라는 두 개의 CTE를 선언  
- 이후 `SELECT` 문에서 `cte1`과 `cte2`를 조인하여 활용  


### 📌 CTE 컬럼명 결정  
아래 두 쿼리는 동일하게 동작한다.  

```sql
WITH cte (col1, col2) AS
(
  SELECT 1, 2
  UNION ALL
  SELECT 3, 4
)
SELECT col1, col2 FROM cte;
```
```sql
WITH cte AS
(
  SELECT 1 AS col1, 2 AS col2
  UNION ALL
  SELECT 3, 4
)
SELECT col1, col2 FROM cte;
```
- `WITH cte (col1, col2) AS (...)`처럼 컬럼명을 직접 지정할 수도 있고,  
- `SELECT` 문 내에서 `AS`를 사용해 컬럼명을 설정할 수도 있다.  


### 📌 CTE 사용 가능 문법  
CTE는 다음과 같은 SQL 문에서 사용 가능하다.  
`SELECT`  `UPDATE`   `DELETE`   `서브쿼리 내부`


### 📌 CTE 사용시 주의할 점 
동일한 수준에서 두 개의 `WITH` 절을 사용할 수 없음  
```sql
WITH cte1 AS (...)
WITH cte2 AS (...)  -- 🚨 오류 발생
SELECT ...;
```

동일한 `WITH` 절 내에서 중복된 CTE 이름을 사용할 수 없음  
```sql
WITH cte1 AS (...),
     cte1 AS (...)  -- 🚨 오류 발생 (중복된 CTE 이름)
SELECT ...;
```
✅ 올바른 코드  
```sql
WITH cte1 AS (...), 
     cte2 AS (...) 
SELECT ...;
```

---

## 📝 문제 풀이
### 문제1. Rank Scores
```sql

```
<img src="./image/week1_1.png" width="500"/>

### 문제2. 다음날도 서울숲의 미세먼지 농도는 나쁨 😢
```sql

```
<img src="./image/week1_2.png" width="500"/>

### 문제3. 그룹별 조건에 맞는 식당 목록 출력하기
```sql
SELECT 
    mp.MEMBER_NAME, 
    rr.REVIEW_TEXT, 
    DATE_FORMAT(rr.REVIEW_DATE, '%Y-%m-%d') AS REVIEW_DATE
FROM MEMBER_PROFILE AS mp
JOIN REST_REVIEW AS rr ON mp.MEMBER_ID = rr.MEMBER_ID
WHERE rr.MEMBER_ID = (SELECT MEMBER_ID
             FROM REST_REVIEW
             GROUP BY MEMBER_ID
             ORDER BY COUNT(REVIEW_SCORE) DESC
             LIMIT 1)
ORDER BY REVIEW_DATE, REVIEW_TEXT;
```

```sql
WITH SUB AS (
    SELECT 
        MEMBER_ID,
        RANK() OVER (ORDER BY COUNT(REVIEW_ID) DESC) AS RANKING
    FROM REST_REVIEW
    GROUP BY MEMBER_ID
)

SELECT 
    mp.MEMBER_NAME,
    rr.REVIEW_TEXT,
    DATE_FORMAT(rr.REVIEW_DATE, '%Y-%m-%d') AS REVIEW_DATE
FROM SUB AS s
JOIN MEMBER_PROFILE mp ON s.MEMBER_ID = mp.MEMBER_ID
JOIN REST_REVIEW rr ON s.MEMBER_ID = rr.MEMBER_ID
WHERE s.RANKING = 1
ORDER BY rr.REVIEW_DATE ASC, rr.REVIEW_TEXT ASC;
```
<img src="./image/week1_3.png" width="500"/>
