## 2-6. 연습문제
### 1. 포켓몬 중에 type2가 없는 포켓몬의 수를 작성하는 쿼리를 작성해주세요
(힌트) ~가 없다 : 컬럼 IS NULL
![week3_01](./img/week3_01.png)

### 2. type2가 없는 포켓몬의 type1과 type1의 포켓몬 수를 알려주는 쿼리를 작성해주세요. 단, type1의 포켓몬 수가 큰 순으로 정렬해주세요
![week3_02](./img/week3_02.png)

### 3. type2 상관없이 type1의 포켓몬 수를 알 수 있는 쿼리를 작성해주세요
![week3_03](./img/week3_03.png)

### 4. 전설 여부에 따른 포켓몬 수를 알 수 있는 쿼리를 작성해주세요
![week3_04](./img/week3_04.png)

### 5. 동명 이인이 있는 이름은 무엇일까요? (한번에 찾으려고 하지 않고 단계적으로 가도 괜찮아요)
![week3_05(1)](./img/week3_05(1).png)
![week3_05(2)](./img/week3_05(2).png)

### 6. trainer 테이블에서 “Iris” 트레이너의 정보를 알 수 있는 쿼리를 작성해주세요
![week3_06](./img/week3_06.png)

### 7. trainer 테이블에서 “Iris”,”Whitney”, “Cynthia” 트레이너의 정보를 알 수 있는 쿼리를 작성해주세요
(힌트) 컬럼 IN ("Iris", "Whitney", "Cynthia")
![week3_07](./img/week3_07.png)

### 8. 전체 포켓몬 수는 얼마나 되나요?
![week3_08](./img/week3_08.png)

### 9. 세대(generation) 별로 포켓몬 수가 얼마나 되는지 알 수 있는 쿼리를 작성해주세요
![week3_09](./img/week3_09.png)

### 10. type2가 존재하는 포켓몬의 수는 얼마나 되나요?
![week3_10](./img/week3_10.png)

### 11. type2가 있는 포켓몬 중에 제일 많은 type1은 무엇인가요?
![week3_11](./img/week3_11.png)

### 12. 단일(하나의 타입만 있는) 타입 포켓몬 중 많은 type1은 무엇일까요?
![week3_12](./img/week3_12.png)

### 13. 포켓몬의 이름에 "파"가 들어가는 포켓몬은 어떤 포켓몬이 있을까요?
(힌트) 컬럼 LIKE "파%"
![week3_13](./img/week3_13.png)

### 14. 뱃지가 6개 이상인 트레이너는 몇 명이 있나요?
![week3_14](./img/week3_14.png)

### 15. 트레이너가 보유한 포켓몬(trainer_pokemon)이 제일 많은 트레이너는 누구일까요?
![week3_15](./img/week3_15.png)

### 16. 포켓몬을 많이 풀어준 트레이너는 누구일까요?
![week3_16](./img/week3_16.png)

### 17. 트레이너 별로 풀어준 포켓몬의 비율이 20%가 넘는 포켓몬 트레이너는 누구일까요? 풀어준 포켓몬의 비율 = (풀어준 포켓몬 수/전체 포켓몬의 수)
(힌트) COUNTIF(조건)
![week3_17](./img/week3_17.png)

## 2-7. 정리
![week3_18](./img/week3_18.png)

## 2-8. 새로운 집계 함수
### GROUP BY ALL
```
Description

The GROUP BY ALL clause groups rows by inferring grouping keys from the SELECT items.

The following SELECT items are excluded from the GROUP BY ALL clause:

Expressions that include aggregate functions.
Expressions that include window functions.
Expressions that do not reference a name from the FROM clause. This includes:
Constants
Query parameters
Correlated column references
Expressions that only reference GROUP BY keys inferred from other SELECT items.
After exclusions are applied, an error is produced if any remaining SELECT item includes a volatile function or has a non-groupable type.

If the set of inferred grouping keys is empty after exclusions are applied, all input rows are considered a single group for aggregation. This behavior is equivalent to writing GROUP BY ().
```
![week3_19](./img/week3_19.png)

## 3-1. INTRO
배울 내용
* SQL 쿼리 작성 흐름
* 쿼리 작성 템플릿과 생산성 도구
* 오류를 디버깅하는 방법

## 3-2. SQL 쿼리 작성하는 흐
지표 고민: 어떤 문제를 해결하기 위해 데이터가 필요한가</br>
-> 지표 구체화: 추상적이지 않고 구체적인 지표 명시. 분자, 분모를 표시하고 이름을 구체적으로 작성</br>
-> 지표 탐색: 유사한 문제를 해결한 케이스가 있는지 확인
* 있다면 해당 쿼리 리뷰

-> 없다면 쿼리 작성: 데이터가 있는 테이블 찾기
* 1개 - 사용
* 2개 이상 - 연결 방법 고민

-> 데이터 정합성 확인: 예상한 결과와 동일한지 확인</br>
-> 쿼리 가독성: 나중을 위해서 깔끔하게 쿼리 작성</br>
-> 쿼리 저장: 쿼리는 재사용되므로 문서로 저장

## 3-3. 쿼리 작성 템플릿과 생산성 도구
- 쿼리를 작성하는 목표, 확인할지표
- 쿼리 계산 방법
- 데이터의 기간
- 사용할 테이블
- JOIN KEY
- 데이터특징
```
SELECT

FROM
WHERE
```
이렇게 글로 작성하면 쿼리 작성이 더 수월

>생산성 도구: 템플릿 사용하기 Espanso
특정 단어를 입력하면 원하는 문장(템플릿)으로 변경

![week3_20](./img/week3_20.png)


![week3_21](./img/week3_21.png)