## 📝 문제 풀이
### 문제1. 복수 국적 메달 수상한 선수 찾기

```sql
SELECT 
  a.name
FROM records AS r
JOIN games AS g ON r.game_id = g.id
JOIN athletes AS a ON r.athlete_id = a.id
WHERE 
  g.year >= 2000
  AND r.medal IS NOT NULL
GROUP BY 
  r.athlete_id, a.name
HAVING 
  COUNT(DISTINCT r.team_id) >= 2
ORDER BY 
  a.name ASC;
```
<img src="./image/week6_1.png" width="600"/>

### 문제3. 온라인 쇼핑몰의 월 별 매출액 집계

```sql
SELECT
  STRFTIME('%Y-%m', o.order_date) AS order_month,
  -- 환불이 아닌 주문 금액
  SUM(CASE WHEN i.order_id NOT LIKE 'C%' THEN i.price * i.quantity ELSE 0 END) AS ordered_amount,
  -- 환불 거래 금액
  SUM(CASE WHEN i.order_id LIKE 'C%' THEN i.price * i.quantity ELSE 0 END) AS canceled_amount,
  -- 전체 거래 금액
  SUM(i.price * i.quantity) AS total_amount
FROM order_items i
LEFT JOIN orders o ON i.order_id = o.order_id
GROUP BY order_month
ORDER BY order_month;
```
<img src="./image/week6_2.png" width="600"/>

### 문제3. 세 명이 서로 친구인 관계 찾기
```sql
SELECT
  A.user_a_id,    -- A: 삼각형의 시작 노드
  B.user_a_id AS user_b_id,     -- B: 중간 노드 (A의 친구)
  B.user_b_id AS user_c_id      -- C: 삼각형의 끝 노드 (B의 친구)
FROM edges A
-- A와 B가 친구
JOIN edges B ON A.user_b_id = B.user_a_id

-- B의 친구인 C가 A와도 친구인지 확인: (A,C) 또는 (C,A)
JOIN edges C 
  ON (
    (A.user_a_id = C.user_a_id AND B.user_b_id = C.user_b_id) OR
    (A.user_a_id = C.user_b_id AND B.user_b_id = C.user_a_id)
  )

-- 3820번 사용자와 친구 관계인 경우만 필터링
WHERE
  3820 IN (A.user_a_id, B.user_a_id, B.user_b_id)
-- 중복 제거
  AND A.user_a_id < B.user_a_id < B.user_b_id;
```
<img src="./image/week6_3.png" width="600"/>
