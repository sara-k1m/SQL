## ⭐️ 15.2.13.2 JOIN Clause

### JOIN과 comma   
- 조인 조건이 없는 경우 INNER JOIN과 쉼표(,)는 의미적으로 동일하며 두 테이블 간의 카티션 곱을 생성한다.
조인 우선순위 주의
  ```sql
  SELECT * FROM (SELECT 1, 2, 3) AS t1;
  ```

- `JOIN`이 `,` (comma)보다 **우선순위가 높음**

  ```sql
  -- 오류 발생 (t1.i1은 JOIN 대상 아님)
  SELECT * FROM t1, t2 JOIN t3 ON t1.i1 = t3.i3;
  
  -- 괄호로 묶어서 해결
  SELECT * FROM (t1, t2) JOIN t3 ON t1.i1 = t3.i3;
  
  -- 또는 JOIN만 사용
  SELECT * FROM t1 JOIN t2 JOIN t3 ON t1.i1 = t3.i3;
  ```

---

## ⭐️ 14.19.3 MySQL Handling of GROUP BY
  
### ANY_VALUE() 함수

- 집계되지 않은 컬럼이지만 MySQL에게 어느 값이든 상관없다고 명시적으로 전달할 수 있음
  ```sql
  SELECT name, ANY_VALUE(address), MAX(age)
  FROM t
  GROUP BY name;
  ```

- `GROUP BY` 없이 집계함수 `MAX()`, `SUM()` 등을 사용할 경우,  
  **집계되지 않은 컬럼은 SELECT에 쓸 수 없음**
  ```sql
  SELECT name, MAX(age) FROM t;
  -- 오류 발생
  ```

  → `ANY_VALUE()`로 해결:
  ```sql
  SELECT ANY_VALUE(name), MAX(age) FROM t;
  ```

### GROUP BY의 표현식 사용   

- MySQL은 **비컬럼 표현식도 GROUP BY에 허용**
  ```sql
  SELECT id, FLOOR(value/100)
  FROM tbl_name
  GROUP BY id, FLOOR(value/100);
  ```

- **GROUP BY에서 별칭 사용 가능**
  ```sql
  SELECT id, FLOOR(value/100) AS val
  FROM tbl_name
  GROUP BY id, val;
  ```

### GROUP BY 내 표현식과 SELECT 표현식의 일치

- GROUP BY에 사용된 표현식이 SELECT에도 동일하게 포함되면 허용
  ```sql
  SELECT id, FLOOR(value/100)
  FROM tbl_name
  GROUP BY id, FLOOR(value/100);
  ```

- 표현식 간의 함수적 종속은 자동 인식되지 않음
  → 해결 방법: **파생 테이블(서브쿼리)** 활용

---

## ⭐️ 15.2.13 SELECT Statement (Having)   
HAVING 절은 GROUP BY에 의해 생성된 그룹에 대한 조건을 지정할 때 사용된다.
WHERE 절과 유사하지만, 집계 함수 조건은 HAVING에만 사용 가능하다.

### HAVING vs WHERE
- WHERE은 집계 함수 사용 불가, HAVING은 가능
- WHERE은 그룹화 전에 필터링, HAVING은 그룹화 후 필터링
  ```sql
  SELECT user, MAX(salary) FROM users
    GROUP BY user HAVING MAX(salary) > 10;
  ```

### HAVING 절 처리 순서
- HAVING은 거의 마지막 단계에서 처리됨 (LIMIT보다 앞)
- 최적화가 적용되지 않음

---
## 📝 문제 풀이
### 문제1. 저자 별 카테고리 별 매출액 집계하기   
```sql
SELECT 
    A.AUTHOR_ID, 
    A.AUTHOR_NAME, 
    B.CATEGORY, 
    SUM(BS.SALES * B.PRICE) AS TOTAL_SALES
FROM BOOK AS B
JOIN BOOK_SALES AS BS ON B.BOOK_ID = BS.BOOK_ID
JOIN AUTHOR AS A ON B.AUTHOR_ID = A.AUTHOR_ID
WHERE BS.SALES_DATE <= '2022-01-31'
GROUP BY B.CATEGORY, A.AUTHOR_ID, A.AUTHOR_NAME
ORDER BY A.AUTHOR_ID, B.CATEGORY DESC;
```
<img src="./image/week2_1.png" width="500"/>

### 문제2. 언어별 개발자 분류하기   
```sql
SELECT 
    CASE
        WHEN (SKILL_CODE & 
                (SELECT SUM(CODE) 
                 FROM SKILLCODES 
                 WHERE CATEGORY LIKE 'Front%')) 
             AND (SKILL_CODE & 
                (SELECT CODE 
                 FROM SKILLCODES 
                 WHERE NAME = 'Python')) 
        THEN 'A'
        
        WHEN SKILL_CODE & 
                (SELECT CODE 
                 FROM SKILLCODES 
                 WHERE NAME = 'C#') 
        THEN 'B'
        
        WHEN SKILL_CODE & 
                (SELECT SUM(CODE) 
                 FROM SKILLCODES 
                 WHERE CATEGORY LIKE 'front%') 
        THEN 'C'
        
        ELSE NULL
    END AS GRADE, ID, EMAIL
FROM DEVELOPERS
HAVING GRADE IS NOT NULL
ORDER BY GRADE, ID;
```
<img src="./image/week2_2.png" width="500"/>
