SELECT DISTINCT C.CAR_ID, C.CAR_TYPE, ROUND(DAILY_FEE * (1 - D.DISCOUNT_RATE * 0.01) * 30, 0) AS FEE
FROM (
        SELECT C.CAR_TYPE, C.CAR_ID, C.DAILY_FEE
        FROM (
            (SELECT CAR_ID, CAR_TYPE, DAILY_FEE
            FROM CAR_RENTAL_COMPANY_CAR  
            WHERE CAR_TYPE = '세단' OR CAR_TYPE = 'SUV') C 
            LEFT OUTER JOIN
            (SELECT CAR_ID, HISTORY_ID
            FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY 
            WHERE (
                (YEAR(END_DATE) = 2022 AND MONTH(END_DATE) = 11) 
                OR (YEAR(START_DATE) = 2022 AND MONTH(START_DATE) = 11) 
                OR (START_DATE <= '2022-11-01' AND END_DATE >= '2022-11-30'))) H
            ON C.CAR_ID = H.CAR_ID
        ) 
        WHERE HISTORY_ID IS NULL
    ) C
    INNER JOIN 
        (SELECT CAR_TYPE, DISCOUNT_RATE
        FROM CAR_RENTAL_COMPANY_DISCOUNT_PLAN 
        WHERE DURATION_TYPE = '30일 이상') D
    ON D.CAR_TYPE = C.CAR_TYPE
WHERE DAILY_FEE * (1 - D.DISCOUNT_RATE * 0.01) * 30 >= 500000 
    AND DAILY_FEE * (1 - D.DISCOUNT_RATE * 0.01) * 30 < 2000000
ORDER BY FEE DESC, C.CAR_TYPE ASC;
