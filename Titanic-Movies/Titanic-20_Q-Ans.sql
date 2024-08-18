-- Here are 20 easy questions to help you analyze the Titanic dataset using SQL:

-- 1. How many passengers were on the Titanic?
SELECT COUNT(*) AS total_passengers FROM `train`;
------------------------------------------------------------------------------------------------
--2. How many passengers survived?
SELECT
    COUNT(`survived`) AS total_passengers_survied
FROM
    `train`
WHERE
    `survived` = 1;
------------------------------------------------------------------------------------------------
-- 3. How many passengers did not survive?
SELECT
    COUNT(`survived`) AS total_passengers_survied
FROM
    `train`
WHERE
    `survived` = 0;
------------------------------------------------------------------------------------------------
--4. What is the average age of the passengers?
SELECT
   AVG(`Age`)
FROM
    `train`
------------------------------------------------------------------------------------------------
--5. How many male passengers were on the Titanic?
SELECT
    COUNT(*) total_males
FROM
    `train`
WHERE
    Sex = 'male'
------------------------------------------------------------------------------------------------
-- 6. How many female passengers were on the Titanic?
SELECT
    COUNT(*) total_males
FROM
    `train`
WHERE
    Sex = 'female';
------------------------------------------------------------------------------------------------
--7. How many passengers were in each passenger class (Pclass)?
SELECT
    Pclass,
    COUNT(*) pssengers_class
FROM
    `train`
GROUP BY
    Pclass;
------------------------------------------------------------------------------------------------
--8. What is the average fare paid by passengers?
SELECT
    AVG(Fare)
FROM
    `train`;
------------------------------------------------------------------------------------------------
--9. How many passengers embarked from each port (Embarked)?
SELECT
    Embarked,
    COUNT(Embarked) no_of_passenger_per_city
FROM
    `train`
GROUP BY
    Embarked;
------------------------------------------------------------------------------------------------
--10. How many siblings/spouses (SibSp) did the average passenger have?
SELECT
    AVG(SibSp) avg_of_sibsp
FROM
    `train`;
------------------------------------------------------------------------------------------------
--11. How many parents/children (Parch) did the average passenger have?
SELECT
    AVG(Parch) avg_of_Parch
FROM
    `train`;
------------------------------------------------------------------------------------------------
--12. What is the distribution of survivors across different passenger classes?
SELECT
    survived,
    Pclass,
    COUNT(*)
FROM
    `train`
GROUP BY
    `survived`,
    `Pclass`;
------------------------------------------------------------------------------------------------
-- 13. What is the survival rate for male passengers?
--m1
SELECT
    SUM( CASE WHEN Sex = 'male' AND survived = '1' THEN 1 ELSE 0 END )/
        SUM(CASE WHEN Sex = 'male' THEN 1 ELSE 0 END ) AS male_survied_rate
FROM
    `train`;
--m2
SELECT
   (SELECT COUNT(*) FROM train WHERE sex = 'male' AND survived ='1') /
   (SELECT COUNT(*) FROM train WHERE sex='male') AS male_survied_rate;
------------------------------------------------------------------------------------------------
--14. What is the survival rate for female passengers?
SELECT 
    (SELECT COUNT(*) FROM `train` WHERE Sex = 'female' AND Survived = 1) / 
    (SELECT COUNT(*) FROM `train` WHERE Sex = 'female') AS male_survival_rate;
------------------------------------------------------------------------------------------------
--15. What is the survival rate for each passenger class?
SELECT
 	Pclass, 
 	SUM(CASE WHEN survived=1 THEN 1 ELSE 0 END) /
	COUNT(*) AS survived_rate
FROM train
GROUP BY Pclass;
------------------------------------------------------------------------------------------------
-- 16. What is the average age of survivors?
SELECT
    AVG(Age) survived_avg_age
FROM
    train
    WHERE survived = '1'
------------------------------------------------------------------------------------------------
-- 17. What is the average age of non-survivors?
SELECT
    AVG(Age) survived_avg_age
FROM
    train
    WHERE survived = '0'
------------------------------------------------------------------------------------------------
--18. How many passengers had a cabin assigned (non-null Cabin values)?
SELECT COUNT(*)
FROM `train`
WHERE `Cabin` IS NOT NULL;
------------------------------------------------------------------------------------------------
-- 19. What is the average fare for each passenger class?
SELECT
    Pclass,
    AVG(Fare) AS avg_fare
FROM
    train
GROUP BY
    Pclass
------------------------------------------------------------------------------------------------
-- 20. How many passengers had the same ticket number?
SELECT COUNT(*) AS duplicate_ticket_count
    FROM (
        SELECT Ticket
        FROM train
        GROUP BY Ticket 
        HAVING COUNT(*) > 1
        ) 


-- Time -> 07:45AM 
