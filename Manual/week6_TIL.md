## 📝 문제 풀이
### 문제1. 복수 국적 메달 수상한 선수 찾기

```sql

```
<img src="./image/week6_1.png" width="600"/>

### 문제3. 온라인 쇼핑몰의 월 별 매출액 집계

```sql

```
<img src="./image/week6_2.png" width="600"/>

### 문제3. 세 명이 서로 친구인 관계 찾기
```sql
WITH ab AS (
  SELECT E1.user_a_id, E1.user_b_id, E2.user_b_id AS user_c_id
  FROM edges AS E1
  JOIN edges AS E2 
    ON E1.user_b_id = E2.user_a_id
),
ac AS (
  -- A-C 관계를 두 방향으로 나눠서 성능 개선
  SELECT ab.user_a_id, ab.user_b_id, ab.user_c_id
  FROM ab
  JOIN edges AS E3
    ON ab.user_a_id = E3.user_a_id AND ab.user_c_id = E3.user_b_id

  UNION ALL

  SELECT ab.user_a_id, ab.user_b_id, ab.user_c_id
  FROM ab
  JOIN edges AS E3
    ON ab.user_a_id = E3.user_b_id AND ab.user_c_id = E3.user_a_id
),
filtered AS (
  -- 중복된 세 친구 관계를 제외
  SELECT DISTINCT *
  FROM ac
  WHERE user_a_id < user_b_id AND user_b_id < user_c_id
)

SELECT *
FROM filtered
WHERE 3820 IN (user_a_id, user_b_id, user_c_id);

```
<img src="./image/week6_3.png" width="600"/>
