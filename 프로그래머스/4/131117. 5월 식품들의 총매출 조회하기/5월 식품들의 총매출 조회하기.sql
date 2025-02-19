SELECT A.PRODUCT_ID, A.PRODUCT_NAME, SUM(B.AMOUNT * A.PRICE)AS TOTAL_SALES 
FROM FOOD_PRODUCT AS A
JOIN FOOD_ORDER AS B ON A.PRODUCT_ID = B.PRODUCT_ID
WHERE B.PRODUCE_DATE BETWEEN '2022-05-01' AND '2022-05-31'
GROUP BY PRODUCT_ID, PRODUCT_NAME
ORDER BY TOTAL_SALES DESC, A.PRODUCT_ID ASC
