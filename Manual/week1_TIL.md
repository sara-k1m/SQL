## ⭐️ 14.20.2 Window Function Concepts and Syntax

윈도우 함수는 집계 함수와 유사하지만, **각 행에 대해 결과를 반환**하는 것이 특징이다.

---

### 📌 개념 요약

- 집계 함수는 여러 행을 하나의 결과 행으로 반환하지만, 윈도우 함수는 각 행마다 결과를 반환한다.
- 현재 계산 중인 행을 current row, 관련된 행 집합을 window 라고 한다.
- `OVER()` 절을 통해 윈도우의 범위와 기준을 설정할 수 있다.

```sql
SELECT 
  year, country, product, profit,
  SUM(profit) OVER() AS total_profit,
  SUM(profit) OVER(PARTITION BY country) AS country_profit
FROM sales
ORDER BY country, year, product, profit;
```

### `ROW_NUMBER()`와 정렬 비교

```sql
SELECT
  year, country, product, profit,
  ROW_NUMBER() OVER(PARTITION BY country) AS row_num1,
  ROW_NUMBER() OVER(PARTITION BY country ORDER BY year, product) AS row_num2
FROM sales;
```

---

## ⭐️ 14.20.1 Window Function Descriptions

### `CUME_DIST()` / `PERCENT_RANK()` 예시

```sql
SELECT
  val,
  ROW_NUMBER()   OVER w AS 'row_number',
  CUME_DIST()    OVER w AS 'cume_dist',
  PERCENT_RANK() OVER w AS 'percent_rank'
FROM numbers
WINDOW w AS (ORDER BY val);
```

### `FIRST_VALUE()` / `LAST_VALUE()` / `NTH_VALUE()`

```sql
SELECT
  time, subject, val,
  FIRST_VALUE(val)  OVER w AS 'first',
  LAST_VALUE(val)   OVER w AS 'last',
  NTH_VALUE(val, 2) OVER w AS 'second',
  NTH_VALUE(val, 4) OVER w AS 'fourth'
FROM observations
WINDOW w AS (PARTITION BY subject ORDER BY time
             ROWS UNBOUNDED PRECEDING);
```

### `LAG()` / `LEAD()` + 차이 계산

```sql
SELECT
  t, val,
  LAG(val)        OVER w AS 'lag',
  LEAD(val)       OVER w AS 'lead',
  val - LAG(val)  OVER w AS 'lag diff',
  val - LEAD(val) OVER w AS 'lead diff'
FROM series
WINDOW w AS (ORDER BY t);
```

### `LAG()` / `LEAD()` + 피보나치 예시

```sql
SELECT
  n,
  LAG(n, 1, 0)      OVER w AS 'lag',
  LEAD(n, 1, 0)     OVER w AS 'lead',
  n + LAG(n, 1, 0)  OVER w AS 'next_n',
  n + LEAD(n, 1, 0) OVER w AS 'next_next_n'
FROM fib
WINDOW w AS (ORDER BY n);
```

### `RANK()` / `DENSE_RANK()` / `ROW_NUMBER()`

```sql
SELECT
  val,
  ROW_NUMBER() OVER w AS 'row_number',
  RANK()       OVER w AS 'rank',
  DENSE_RANK() OVER w AS 'dense_rank'
FROM numbers
WINDOW w AS (ORDER BY val);
```

---

## ⭐️ 14.20.4 Named Windows

### 동일 윈도우 정의를 재사용하지 않은 방식

```sql
SELECT
  val,
  ROW_NUMBER() OVER (ORDER BY val) AS 'row_number',
  RANK()       OVER (ORDER BY val) AS 'rank',
  DENSE_RANK() OVER (ORDER BY val) AS 'dense_rank'
FROM numbers;
```

### `WINDOW` 절 사용 방식

```sql
SELECT
  val,
  ROW_NUMBER() OVER w AS 'row_number',
  RANK()       OVER w AS 'rank',
  DENSE_RANK() OVER w AS 'dense_rank'
FROM numbers
WINDOW w AS (ORDER BY val);
```

### `OVER (window_name ...)` 확장 사용 예시

```sql
SELECT
  DISTINCT year, country,
  FIRST_VALUE(year) OVER (w ORDER BY year ASC) AS first,
  FIRST_VALUE(year) OVER (w ORDER BY year DESC) AS last
FROM sales
WINDOW w AS (PARTITION BY country);
```

### `WINDOW` 참조 규칙 예시

```sql
-- 허용되는 참조
WINDOW w1 AS (w2), w2 AS (), w3 AS (w1);

-- 순환 참조: 허용되지 않음
WINDOW w1 AS (w2), w2 AS (w3), w3 AS (w1);
```
---

## ⭐️ over_clause

```sql
<윈도우 함수> OVER ([PARTITION BY ...] [ORDER BY ...] [ROWS|RANGE ...])
```

- `PARTITION BY`: 데이터를 그룹으로 나누어 윈도우 처리
- `ORDER BY`: 파티션 내 행 순서 지정
- `ROWS` / `RANGE`: 프레임 범위 지정 (기본값: `RANGE UNBOUNDED PRECEDING TO CURRENT ROW`)

> `over_clause`는 윈도우 함수 또는 집계 함수에서 반드시 사용되며, 윈도우 계산 방식 지정에 사용된다.
---
## 📝 문제 풀이
### 문제1. Rank Scores
```sql

```
<img src="./image/week1_1.png" width="500"/>

### 문제2. 다음날도 서울숲의 미세먼지 농도는 나쁨 😢
```sql
SELECT
  m1.measured_at AS today,
  m2.measured_at AS next_day,
  m1.pm10 AS pm10,
  m2.pm10 AS next_pm10
FROM measurements AS m1
JOIN measurements AS m2 ON m1.measured_at = DATE(m2.measured_at, '-1 day')
-- DATE_ADD 사용 불가
WHERE
  m1.pm10 < m2.pm10
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
