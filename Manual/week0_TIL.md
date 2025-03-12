## ⭐️ 15.2.15 Subqueries  
서브쿼리는 다른 SQL 문 내에서 실행되는 `SELECT` 문이다. MySQL에서는 표준 SQL에서 요구하는 모든 서브쿼리 형식을 지원하며, MySQL만의 추가 기능도 제공한다.  

### 📌 서브쿼리의 주요 특징  
- 쿼리의 특정 부분을 분리하여 구조적으로 작성할 수 있음  
- 복잡한 `JOIN`이나 `UNION` 없이 동일한 결과를 얻을 수 있음  
- 가독성이 뛰어나며, SQL이 **"구조적(Structured)"** 언어로 불리는 이유 중 하나  
- `SELECT, INSERT, UPDATE, DELETE, SET, DO` 문에서 사용 가능  

---
### 15.2.15.2 Comparisons Using Subqueries  
- 서브쿼리는 비교 연산자(`=, >, <, >=, <=, <>, !=, <=>`)와 함께 사용 가능  
- 서브쿼리 결과를 비교할 때, **반환되는 값이 단일 값이어야 함**  
  ```sql
  SELECT * FROM t1 WHERE column1 = (SELECT MAX(column2) FROM t2);
  ```
- 특정 값이 두 번 등장하는 행을 찾는 서브쿼리 예제  
  ```sql
  SELECT * FROM t1 AS t
  WHERE 2 = (SELECT COUNT(*) FROM t1 WHERE t1.id = t.id);
  ```

---
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

---
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

---
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
  
  
