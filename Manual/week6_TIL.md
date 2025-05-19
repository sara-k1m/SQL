WITH cte_1 AS (
  SELECT 
    e.user_a_id, 
    e.user_b_id, 
    e2.user_c_id
  FROM edges e 
  JOIN (
    SELECT user_b_id AS user_c_id, user_a_id AS user_b_id 
    FROM edges
  ) e2
    ON e.user_b_id = e2.user_b_id
  WHERE 3820 IN (e.user_a_id, e.user_b_id, e2.user_c_id)
)

SELECT c.user_a_id, c.user_b_id, c.user_c_id
FROM cte_1 c
JOIN edges e 
  ON (e.user_a_id = c.user_a_id AND e.user_b_id = c.user_c_id)
  OR (e.user_a_id = c.user_c_id AND e.user_b_id = c.user_a_id)
WHERE c.user_a_id < c.user_b_id AND c.user_b_id < c.user_c_id
